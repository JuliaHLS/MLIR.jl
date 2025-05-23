abstract type AbstractPass end

mutable struct ExternalPassHandle
    ctx::Union{Nothing,Context}
    pass::AbstractPass
end

mutable struct PassManager
    pass::API.MlirPassManager
    allocator::TypeIDAllocator
    passes::Dict{TypeID,ExternalPassHandle}

    function PassManager(pm::API.MlirPassManager)
        @assert !mlirIsNull(pm) "cannot create PassManager with null MlirPassManager"
        finalizer(new(pm, TypeIDAllocator(), Dict{TypeID,ExternalPassHandle}())) do pm
            API.mlirPassManagerDestroy(pm.pass)
        end
    end
end

"""
    PassManager(; context=context())

Create a new top-level PassManager.
"""
PassManager(; context::Context=context()) = PassManager(API.mlirPassManagerCreate(context))

"""
    PassManager(anchorOp; context=context())

Create a new top-level PassManager anchored on `anchorOp`.
"""
function PassManager(anchor_op::Operation; context::Context=context())
    MLIR_VERSION[] >= v"16" ||
        throw(MLIRException("`PassManager(::Operation)` requires MLIR version 16 or later"))
    return PassManager(API.mlirPassManagerCreateOnOperation(context, anchor_op))
end

Base.convert(::Core.Type{API.MlirPassManager}, pass::PassManager) = pass.pass

"""
    enable_ir_printing!(passManager)

Enable mlir-print-ir-after-all.
"""
function enable_ir_printing!(pm)
    API.mlirPassManagerEnableIRPrinting(pm)
    return pm
end

"""
    enable_verifier!(passManager, enable)

Enable / disable verify-each.
"""
function enable_verifier!(pm, enable=true)
    API.mlirPassManagerEnableVerifier(pm, enable)
    return pm
end

"""
    run!(passManager, module)

Run the provided `passManager` on the given `module`.
"""
function run!(pm::PassManager, mod::Module)
    status = if MLIR_VERSION[] >= v"17"
        LogicalResult(API.mlirPassManagerRunOnOp(pm, Operation(mod)))
    else
        LogicalResult(API.mlirPassManagerRun(pm, mod))
    end
    if isfailure(status)
        throw("failed to run pass manager on module")
    end
    return mod
end

struct OpPassManager
    op_pass::API.MlirOpPassManager
    pass::PassManager

    function OpPassManager(op_pass, pass)
        @assert !mlirIsNull(op_pass) "cannot create OpPassManager with null MlirOpPassManager"
        return new(op_pass, pass)
    end
end

"""
    OpPassManager(passManager)

Cast a top-level `PassManager` to a generic `OpPassManager`.
"""
OpPassManager(pm::PassManager) =
    OpPassManager(API.mlirPassManagerGetAsOpPassManager(pm), pm)

"""
    OpPassManager(passManager, operationName)

Nest an `OpPassManager` under the top-level PassManager, the nested passmanager will only run on operations matching the provided name.
The returned `OpPassManager` will be destroyed when the parent is destroyed. To further nest more `OpPassManager` under the newly returned one, see `mlirOpPassManagerNest` below.
"""
OpPassManager(pm::PassManager, opname) =
    OpPassManager(API.mlirPassManagerGetNestedUnder(pm, opname), pm)

"""
    OpPassManager(opPassManager, operationName)

Nest an `OpPassManager` under the provided `OpPassManager`, the nested passmanager will only run on operations matching the provided name. The returned `OpPassManager` will be destroyed when the parent is destroyed.
"""
OpPassManager(opm::OpPassManager, opname) =
    OpPassManager(API.mlirOpPassManagerGetNestedUnder(opm, opname), opm.pass)

Base.convert(::Core.Type{API.MlirOpPassManager}, op_pass::OpPassManager) = op_pass.op_pass

function Base.show(io::IO, op_pass::OpPassManager)
    c_print_callback = @cfunction(print_callback, Cvoid, (API.MlirStringRef, Any))
    ref = Ref(io)
    println(io, "OpPassManager(\"\"\"")
    API.mlirPrintPassPipeline(op_pass, c_print_callback, ref)
    println(io)
    return print(io, "\"\"\")")
end

struct AddPipelineException <: Exception
    message::String
end

function Base.showerror(io::IO, err::AddPipelineException)
    print(io, "failed to add pipeline:", err.message)
    return nothing
end

"""
    add_owned_pass!(passManager, pass)

Add a pass and transfer ownership to the provided top-level `PassManager`. If the pass is not a generic operation pass or a `ModulePass`, a new `OpPassManager` is implicitly nested under the provided PassManager.
"""
function add_owned_pass!(pm::PassManager, pass)
    API.mlirPassManagerAddOwnedPass(pm, pass)
    return pm
end

"""
    add_owned_pass!(opPassManager, pass)

Add a pass and transfer ownership to the provided `OpPassManager`. If the pass is not a generic operation pass or matching the type of the provided `OpPassManager`, a new `OpPassManager` is implicitly nested under the provided `OpPassManager`.
"""
function add_owned_pass!(opm::OpPassManager, pass)
    API.mlirOpPassManagerAddOwnedPass(opm, pass)
    return opm
end

"""
    parse(passManager, pipeline)

Parse a textual MLIR pass pipeline and add it to the provided `OpPassManager`.
"""
function Base.parse(opm::OpPassManager, pipeline::String)
    result = LogicalResult(
        if MLIR_VERSION[] >= v"16"
            io = IOBuffer()
            c_print_callback = @cfunction(print_callback, Cvoid, (API.MlirStringRef, Any))
            API.mlirParsePassPipeline(opm, pipeline, c_print_callback, Ref(io))
        else
            API.mlirParsePassPipeline(opm, pipeline)
        end,
    )

    if isfailure(result)
        throw(AddPipelineException(String(take!(io))))
    end
    return opm
end

"""
    add_pipeline!(passManager, pipelineElements, callback, userData)

Parse a sequence of textual MLIR pass pipeline elements and add them to the provided OpPassManager. If parsing fails an error message is reported using the provided callback.
"""
function add_pipeline!(op_pass::OpPassManager, pipeline)
    if MLIR_VERSION[] >= v"16"
        io = IOBuffer()
        c_print_callback = @cfunction(print_callback, Cvoid, (API.MlirStringRef, Any))
        result = LogicalResult(
            API.mlirOpPassManagerAddPipeline(op_pass, pipeline, c_print_callback, Ref(io))
        )
        if isfailure(result)
            exc = AddPipelineException(String(take!(io)))
            throw(exc)
        end
    else
        result = LogicalResult(API.mlirParsePassPipeline(op_pass, pipeline))
        if isfailure(result)
            throw(AddPipelineException(" " * pipeline))
        end
    end
    return op_pass
end

### Pass

# AbstractPass interface:
opname(::AbstractPass) = ""
function pass_run(::Context, ::P, op) where {P<:AbstractPass}
    return error("pass $P does not implement `MLIR.pass_run`")
end

mlirLogicalResultSuccess() = API.MlirLogicalResult(one(Int8))
mlirLogicalResultFailure() = API.MlirLogicalResult(zero(Int8))



function _pass_construct(ptr::ExternalPassHandle)
    return nothing
end

function _pass_destruct(ptr::ExternalPassHandle)
    return nothing
end

function _pass_initialize(ctx, handle::ExternalPassHandle)
    try
        handle.ctx = Context(ctx)
        # API.Types.MlirLogicalResult(0)
        # IR.Mli
        # IR.success()
        mlirLogicalResultSuccess()
    catch
        mlirLogicalResultFailure()
    end
end

function _pass_clone(handle::ExternalPassHandle)
    ExternalPassHandle(handle.ctx, deepcopy(handle.pass))
end

function _pass_run(rawop, external_pass, handle::ExternalPassHandle)
    if handle.ctx == nothing
        error("Failed to run external pass, external pass handle ctx is a nullptr")
    end

    println("RUNNING PASS")
    op = Operation(rawop, false)
    activate!(handle.ctx)
    try
        println("PASS: $(handle.pass)")
        pass_run(handle.pass, op)
    catch ex
        @error "Something went wrong running pass" exception = (ex, catch_backtrace())
        API.mlirExternalPassSignalFailure(external_pass)
    finally
        deactivate!(handle.ctx)
    end
    return nothing
end

function create_external_pass!(oppass::OpPassManager, args...)
    return create_external_pass!(oppass.pass, args...)
end
function create_external_pass!(
    manager,
    pass,
    name,
    argument,
    description,
    opname=opname(pass),
    dependent_dialects=API.MlirDialectHandle[],
)
    passid = TypeID(manager.allocator)
    MLIR_VERSION[] >= v"15" ||
        throw(MLIRException("`create_external_pass!` requires MLIR version 15 or later"))
    callbacks = API.MlirExternalPassCallbacks(
        @cfunction(_pass_construct, Cvoid, (Any,)),
        @cfunction(_pass_destruct, Cvoid, (Any,)),
        @cfunction(_pass_initialize, API.MlirLogicalResult, (API.MlirContext, Any)),
        @cfunction(_pass_clone, Any, (Any,)),
        @cfunction(_pass_run, Cvoid, (API.Types.MlirOperation, API.MlirExternalPass, Any))
    )
    pass_handle = manager.passes[passid] = ExternalPassHandle(nothing, pass)
    userdata = Base.pointer_from_objref(pass_handle)
    mlir_pass = API.mlirCreateExternalPass(
        passid,
        name,
        argument,
        description,
        opname,
        length(dependent_dialects),
        dependent_dialects,
        callbacks,
        userdata,
    )
    return mlir_pass
end
