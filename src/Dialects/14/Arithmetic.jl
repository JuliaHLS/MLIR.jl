module arith

import ...IR:
    IR, NamedAttribute, Value, Location, Block, Region, Attribute, context, IndexType
import ..Dialects: namedattribute, operandsegmentsizes
import ...API

"""
`addf`

The `addf` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be a floating point
scalar type, a vector whose element type is a floating point type, or a
floating point tensor.

# Example

```mlir
// Scalar addition.
%a = arith.addf %b, %c : f64

// SIMD vector addition, e.g. for Intel SSE.
%f = arith.addf %g, %h : vector<4xf32>

// Tensor addition.
%x = arith.addf %y, %z : tensor<4x?xbf16>
```

TODO: In the distant future, this will accept optional attributes for fast
math, contraction, rounding mode, and other controls.
"""
function addf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.addf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`addi`

The `addi` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be an integer scalar
type, a vector whose element type is integer, or a tensor of integers. It
has no standard attributes.

# Example

```mlir
// Scalar addition.
%a = arith.addi %b, %c : i64

// SIMD vector element-wise addition, e.g. for Intel SSE.
%f = arith.addi %g, %h : vector<4xi32>

// Tensor element-wise addition.
%x = arith.addi %y, %z : tensor<4x?xi8>
```
"""
function addi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.addi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`andi`

The `andi` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be an integer scalar
type, a vector whose element type is integer, or a tensor of integers. It
has no standard attributes.

# Example

```mlir
// Scalar integer bitwise and.
%a = arith.andi %b, %c : i64

// SIMD vector element-wise bitwise integer and.
%f = arith.andi %g, %h : vector<4xi32>

// Tensor element-wise bitwise integer and.
%x = arith.andi %y, %z : tensor<4x?xi8>
```
"""
function andi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.andi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`bitcast`

Bitcast an integer or floating point value to an integer or floating point
value of equal bit width. When operating on vectors, casts elementwise.

Note that this implements a logical bitcast independent of target
endianness. This allows constant folding without target information and is
consitent with the bitcast constant folders in LLVM (see
https://github.com/llvm/llvm-project/blob/18c19414eb/llvm/lib/IR/ConstantFold.cpp#L168)
For targets where the source and target type have the same endianness (which
is the standard), this cast will also change no bits at runtime, but it may
still require an operation, for example if the machine has different
floating point and integer register files. For targets that have a different
endianness for the source and target types (e.g. float is big-endian and
integer is little-endian) a proper lowering would add operations to swap the
order of words in addition to the bitcast.
"""
function bitcast(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.bitcast",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`ceildivsi`

Signed integer division. Rounds towards positive infinity, i.e. `7 / -2 = -3`.

Note: the semantics of division by zero or signed division overflow (minimum
value divided by -1) is TBD; do NOT assume any specific behavior.

# Example

```mlir
// Scalar signed integer division.
%a = arith.ceildivsi %b, %c : i64
```
"""
function ceildivsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.ceildivsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`ceildivui`

Unsigned integer division. Rounds towards positive infinity. Treats the
leading bit as the most significant, i.e. for `i16` given two\'s complement
representation, `6 / -2 = 6 / (2^16 - 2) = 1`.

Note: the semantics of division by zero is TBD; do NOT assume any specific
behavior.

# Example

```mlir
// Scalar unsigned integer division.
%a = arith.ceildivui %b, %c : i64
```
"""
function ceildivui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.ceildivui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`cmpf`

The `cmpf` operation compares its two operands according to the float
comparison rules and the predicate specified by the respective attribute.
The predicate defines the type of comparison: (un)orderedness, (in)equality
and signed less/greater than (or equal to) as well as predicates that are
always true or false.  The operands must have the same type, and this type
must be a float type, or a vector or tensor thereof.  The result is an i1,
or a vector/tensor thereof having the same shape as the inputs. Unlike cmpi,
the operands are always treated as signed. The u prefix indicates
*unordered* comparison, not unsigned comparison, so \"une\" means unordered or
not equal. For the sake of readability by humans, custom assembly form for
the operation uses a string-typed attribute for the predicate.  The value of
this attribute corresponds to lower-cased name of the predicate constant,
e.g., \"one\" means \"ordered not equal\".  The string representation of the
attribute is merely a syntactic sugar and is converted to an integer
attribute by the parser.

# Example

```mlir
%r1 = arith.cmpf \"oeq\" %0, %1 : f32
%r2 = arith.cmpf \"ult\" %0, %1 : tensor<42x42xf64>
%r3 = \"arith.cmpf\"(%0, %1) {predicate: 0} : (f8, f8) -> i1
```
"""
function cmpf(lhs::Value, rhs::Value; result::IR.Type, predicate, location=Location())
    results = IR.Type[result,]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[namedattribute("predicate", predicate),]

    return IR.create_operation(
        "arith.cmpf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`cmpi`

The `cmpi` operation is a generic comparison for integer-like types. Its two
arguments can be integers, vectors or tensors thereof as long as their types
match. The operation produces an i1 for the former case, a vector or a
tensor of i1 with the same shape as inputs in the other cases.

Its first argument is an attribute that defines which type of comparison is
performed. The following comparisons are supported:

-   equal (mnemonic: `\"eq\"`; integer value: `0`)
-   not equal (mnemonic: `\"ne\"`; integer value: `1`)
-   signed less than (mnemonic: `\"slt\"`; integer value: `2`)
-   signed less than or equal (mnemonic: `\"sle\"`; integer value: `3`)
-   signed greater than (mnemonic: `\"sgt\"`; integer value: `4`)
-   signed greater than or equal (mnemonic: `\"sge\"`; integer value: `5`)
-   unsigned less than (mnemonic: `\"ult\"`; integer value: `6`)
-   unsigned less than or equal (mnemonic: `\"ule\"`; integer value: `7`)
-   unsigned greater than (mnemonic: `\"ugt\"`; integer value: `8`)
-   unsigned greater than or equal (mnemonic: `\"uge\"`; integer value: `9`)

The result is `1` if the comparison is true and `0` otherwise. For vector or
tensor operands, the comparison is performed elementwise and the element of
the result indicates whether the comparison is true for the operand elements
with the same indices as those of the result.

Note: while the custom assembly form uses strings, the actual underlying
attribute has integer type (or rather enum class in C++ code) as seen from
the generic assembly form. String literals are used to improve readability
of the IR by humans.

This operation only applies to integer-like operands, but not floats. The
main reason being that comparison operations have diverging sets of
attributes: integers require sign specification while floats require various
floating point-related particularities, e.g., `-ffast-math` behavior,
IEEE754 compliance, etc
([rationale](../Rationale/Rationale.md#splitting-floating-point-vs-integer-operations)).
The type of comparison is specified as attribute to avoid introducing ten
similar operations, taking into account that they are often implemented
using the same operation downstream
([rationale](../Rationale/Rationale.md#specifying-comparison-kind-as-attribute)). The
separation between signed and unsigned order comparisons is necessary
because of integers being signless. The comparison operation must know how
to interpret values with the foremost bit being set: negatives in two\'s
complement or large positives
([rationale](../Rationale/Rationale.md#specifying-sign-in-integer-comparison-operations)).

# Example

```mlir
// Custom form of scalar \"signed less than\" comparison.
%x = arith.cmpi \"slt\", %lhs, %rhs : i32

// Generic form of the same operation.
%x = \"arith.cmpi\"(%lhs, %rhs) {predicate = 2 : i64} : (i32, i32) -> i1

// Custom form of vector equality comparison.
%x = arith.cmpi \"eq\", %lhs, %rhs : vector<4xi64>

// Generic form of the same operation.
%x = \"std.arith.cmpi\"(%lhs, %rhs) {predicate = 0 : i64}
    : (vector<4xi64>, vector<4xi64>) -> vector<4xi1>
```
"""
function cmpi(lhs::Value, rhs::Value; result::IR.Type, predicate, location=Location())
    results = IR.Type[result,]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[namedattribute("predicate", predicate),]

    return IR.create_operation(
        "arith.cmpi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`constant`

The `constant` operation produces an SSA value equal to some integer or
floating-point constant specified by an attribute. This is the way MLIR
forms simple integer and floating point constants.

# Example

```
// Integer constant
%1 = arith.constant 42 : i32

// Equivalent generic form
%1 = \"arith.constant\"() {value = 42 : i32} : () -> i32
```
"""
function constant(; result::IR.Type, value, location=Location())
    results = IR.Type[result,]
    operands = Value[]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[namedattribute("value", value),]

    return IR.create_operation(
        "arith.constant",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`divf`

"""
function divf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.divf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`divsi`

Signed integer division. Rounds towards zero. Treats the leading bit as
sign, i.e. `6 / -2 = -3`.

Note: the semantics of division by zero or signed division overflow (minimum
value divided by -1) is TBD; do NOT assume any specific behavior.

# Example

```mlir
// Scalar signed integer division.
%a = arith.divsi %b, %c : i64

// SIMD vector element-wise division.
%f = arith.divsi %g, %h : vector<4xi32>

// Tensor element-wise integer division.
%x = arith.divsi %y, %z : tensor<4x?xi8>
```
"""
function divsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.divsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`divui`

Unsigned integer division. Rounds towards zero. Treats the leading bit as
the most significant, i.e. for `i16` given two\'s complement representation,
`6 / -2 = 6 / (2^16 - 2) = 0`.

Note: the semantics of division by zero is TBD; do NOT assume any specific
behavior.

# Example

```mlir
// Scalar unsigned integer division.
%a = arith.divui %b, %c : i64

// SIMD vector element-wise division.
%f = arith.divui %g, %h : vector<4xi32>

// Tensor element-wise integer division.
%x = arith.divui %y, %z : tensor<4x?xi8>
```
"""
function divui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.divui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`extf`

Cast a floating-point value to a larger floating-point-typed value.
The destination type must to be strictly wider than the source type.
When operating on vectors, casts elementwise.
"""
function extf(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.extf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`extsi`

The integer sign extension operation takes an integer input of
width M and an integer destination type of width N. The destination
bit-width must be larger than the input bit-width (N > M).
The top-most (N - M) bits of the output are filled with copies
of the most-significant bit of the input.

# Example

```mlir
%1 = arith.constant 5 : i3      // %1 is 0b101
%2 = arith.extsi %1 : i3 to i6  // %2 is 0b111101
%3 = arith.constant 2 : i3      // %3 is 0b010
%4 = arith.extsi %3 : i3 to i6  // %4 is 0b000010

%5 = arith.extsi %0 : vector<2 x i32> to vector<2 x i64>
```
"""
function extsi(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.extsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`extui`

The integer zero extension operation takes an integer input of
width M and an integer destination type of width N. The destination
bit-width must be larger than the input bit-width (N > M).
The top-most (N - M) bits of the output are filled with zeros.

# Example

```mlir
  %1 = arith.constant 5 : i3      // %1 is 0b101
  %2 = arith.extui %1 : i3 to i6  // %2 is 0b000101
  %3 = arith.constant 2 : i3      // %3 is 0b010
  %4 = arith.extui %3 : i3 to i6  // %4 is 0b000010

  %5 = arith.extui %0 : vector<2 x i32> to vector<2 x i64>
```
"""
function extui(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.extui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`fptosi`

Cast from a value interpreted as floating-point to the nearest (rounding
towards zero) signed integer value. When operating on vectors, casts
elementwise.
"""
function fptosi(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.fptosi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`fptoui`

Cast from a value interpreted as floating-point to the nearest (rounding
towards zero) unsigned integer value. When operating on vectors, casts
elementwise.
"""
function fptoui(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.fptoui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`floordivsi`

Signed integer division. Rounds towards negative infinity, i.e. `5 / -2 = -3`.

Note: the semantics of division by zero or signed division overflow (minimum
value divided by -1) is TBD; do NOT assume any specific behavior.

# Example

```mlir
// Scalar signed integer division.
%a = arith.floordivsi %b, %c : i64

```
"""
function floordivsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.floordivsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`index_cast`

Casts between scalar or vector integers and corresponding \'index\' scalar or
vectors. Index is an integer of platform-specific bit width. If casting to
a wider integer, the value is sign-extended. If casting to a narrower
integer, the value is truncated.
"""
function index_cast(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.index_cast",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`maxf`

# Syntax

```
operation ::= ssa-id `=` `arith.maxf` ssa-use `,` ssa-use `:` type
```

Returns the maximum of the two arguments, treating -0.0 as less than +0.0.
If one of the arguments is NaN, then the result is also NaN.

# Example

```mlir
// Scalar floating-point maximum.
%a = arith.maxf %b, %c : f64
```
"""
function maxf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.maxf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`maxsi`

"""
function maxsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.maxsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`maxui`

"""
function maxui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.maxui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`minf`

# Syntax

```
operation ::= ssa-id `=` `arith.minf` ssa-use `,` ssa-use `:` type
```

Returns the minimum of the two arguments, treating -0.0 as less than +0.0.
If one of the arguments is NaN, then the result is also NaN.

# Example

```mlir
// Scalar floating-point minimum.
%a = arith.minf %b, %c : f64
```
"""
function minf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.minf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`minsi`

"""
function minsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.minsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`minui`

"""
function minui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.minui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`mulf`

The `mulf` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be a floating point
scalar type, a vector whose element type is a floating point type, or a
floating point tensor.

# Example

```mlir
// Scalar multiplication.
%a = arith.mulf %b, %c : f64

// SIMD pointwise vector multiplication, e.g. for Intel SSE.
%f = arith.mulf %g, %h : vector<4xf32>

// Tensor pointwise multiplication.
%x = arith.mulf %y, %z : tensor<4x?xbf16>
```

TODO: In the distant future, this will accept optional attributes for fast
math, contraction, rounding mode, and other controls.
"""
function mulf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.mulf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`muli`

"""
function muli(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.muli",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`negf`

The `negf` operation computes the negation of a given value. It takes one
operand and returns one result of the same type. This type may be a float
scalar type, a vector whose element type is float, or a tensor of floats.
It has no standard attributes.

# Example

```mlir
// Scalar negation value.
%a = arith.negf %b : f64

// SIMD vector element-wise negation value.
%f = arith.negf %g : vector<4xf32>

// Tensor element-wise negation value.
%x = arith.negf %y : tensor<4x?xf8>
```
"""
function negf(operand::Value; result=nothing::Union{Nothing,IR.Type}, location=Location())
    results = IR.Type[]
    operands = Value[operand,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.negf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`ori`

The `ori` operation takes two operands and returns one result, each of these
is required to be the same type. This type may be an integer scalar type, a
vector whose element type is integer, or a tensor of integers. It has no
standard attributes.

# Example

```mlir
// Scalar integer bitwise or.
%a = arith.ori %b, %c : i64

// SIMD vector element-wise bitwise integer or.
%f = arith.ori %g, %h : vector<4xi32>

// Tensor element-wise bitwise integer or.
%x = arith.ori %y, %z : tensor<4x?xi8>
```
"""
function ori(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.ori",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`remf`

"""
function remf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.remf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`remsi`

Signed integer division remainder. Treats the leading bit as sign, i.e. `6 %
-2 = 0`.

Note: the semantics of division by zero is TBD; do NOT assume any specific
behavior.

# Example

```mlir
// Scalar signed integer division remainder.
%a = arith.remsi %b, %c : i64

// SIMD vector element-wise division remainder.
%f = arith.remsi %g, %h : vector<4xi32>

// Tensor element-wise integer division remainder.
%x = arith.remsi %y, %z : tensor<4x?xi8>
```
"""
function remsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.remsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`remui`

Unsigned integer division remainder. Treats the leading bit as the most
significant, i.e. for `i16`, `6 % -2 = 6 % (2^16 - 2) = 6`.

Note: the semantics of division by zero is TBD; do NOT assume any specific
behavior.

# Example

```mlir
// Scalar unsigned integer division remainder.
%a = arith.remui %b, %c : i64

// SIMD vector element-wise division remainder.
%f = arith.remui %g, %h : vector<4xi32>

// Tensor element-wise integer division remainder.
%x = arith.remui %y, %z : tensor<4x?xi8>
```
"""
function remui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.remui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`sitofp`

Cast from a value interpreted as a signed integer to the corresponding
floating-point value. If the value cannot be exactly represented, it is
rounded using the default rounding mode. When operating on vectors, casts
elementwise.
"""
function sitofp(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.sitofp",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`shli`

The `shli` operation shifts an integer value to the left by a variable
amount. The low order bits are filled with zeros.

# Example

```mlir
%1 = arith.constant 5 : i8                 // %1 is 0b00000101
%2 = arith.constant 3 : i8
%3 = arith.shli %1, %2 : (i8, i8) -> i8    // %3 is 0b00101000
```
"""
function shli(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.shli",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`shrsi`

The `shrsi` operation shifts an integer value to the right by a variable
amount. The integer is interpreted as signed. The high order bits in the
output are filled with copies of the most-significant bit of the shifted
value (which means that the sign of the value is preserved).

# Example

```mlir
%1 = arith.constant 160 : i8               // %1 is 0b10100000
%2 = arith.constant 3 : i8
%3 = arith.shrsi %1, %2 : (i8, i8) -> i8   // %3 is 0b11110100
%4 = arith.constant 96 : i8                   // %4 is 0b01100000
%5 = arith.shrsi %4, %2 : (i8, i8) -> i8   // %5 is 0b00001100
```
"""
function shrsi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.shrsi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`shrui`

The `shrui` operation shifts an integer value to the right by a variable
amount. The integer is interpreted as unsigned. The high order bits are
always filled with zeros.

# Example

```mlir
%1 = arith.constant 160 : i8               // %1 is 0b10100000
%2 = arith.constant 3 : i8
%3 = arith.shrui %1, %2 : (i8, i8) -> i8   // %3 is 0b00010100
```
"""
function shrui(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.shrui",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`subf`

The `subf` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be a floating point
scalar type, a vector whose element type is a floating point type, or a
floating point tensor.

# Example

```mlir
// Scalar subtraction.
%a = arith.subf %b, %c : f64

// SIMD vector subtraction, e.g. for Intel SSE.
%f = arith.subf %g, %h : vector<4xf32>

// Tensor subtraction.
%x = arith.subf %y, %z : tensor<4x?xbf16>
```

TODO: In the distant future, this will accept optional attributes for fast
math, contraction, rounding mode, and other controls.
"""
function subf(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.subf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`subi`

"""
function subi(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.subi",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

"""
`truncf`

Truncate a floating-point value to a smaller floating-point-typed value.
The destination type must be strictly narrower than the source type.
If the value cannot be exactly represented, it is rounded using the default
rounding mode. When operating on vectors, casts elementwise.
"""
function truncf(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.truncf",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`trunci`

The integer truncation operation takes an integer input of
width M and an integer destination type of width N. The destination
bit-width must be smaller than the input bit-width (N < M).
The top-most (N - M) bits of the input are discarded.

# Example

```mlir
  %1 = arith.constant 21 : i5     // %1 is 0b10101
  %2 = arith.trunci %1 : i5 to i4 // %2 is 0b0101
  %3 = arith.trunci %1 : i5 to i3 // %3 is 0b101

  %5 = arith.trunci %0 : vector<2 x i32> to vector<2 x i16>
```
"""
function trunci(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.trunci",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`uitofp`

Cast from a value interpreted as unsigned integer to the corresponding
floating-point value. If the value cannot be exactly represented, it is
rounded using the default rounding mode. When operating on vectors, casts
elementwise.
"""
function uitofp(in::Value; out::IR.Type, location=Location())
    results = IR.Type[out,]
    operands = Value[in,]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]

    return IR.create_operation(
        "arith.uitofp",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=results,
        result_inference=false,
    )
end

"""
`xori`

The `xori` operation takes two operands and returns one result, each of
these is required to be the same type. This type may be an integer scalar
type, a vector whose element type is integer, or a tensor of integers. It
has no standard attributes.

# Example

```mlir
// Scalar integer bitwise xor.
%a = arith.xori %b, %c : i64

// SIMD vector element-wise bitwise integer xor.
%f = arith.xori %g, %h : vector<4xi32>

// Tensor element-wise bitwise integer xor.
%x = arith.xori %y, %z : tensor<4x?xi8>
```
"""
function xori(
    lhs::Value, rhs::Value; result=nothing::Union{Nothing,IR.Type}, location=Location()
)
    results = IR.Type[]
    operands = Value[lhs, rhs]
    owned_regions = Region[]
    successors = Block[]
    attributes = NamedAttribute[]
    !isnothing(result) && push!(results, result)

    return IR.create_operation(
        "arith.xori",
        location;
        operands,
        owned_regions,
        successors,
        attributes,
        results=(length(results) == 0 ? nothing : results),
        result_inference=(length(results) == 0 ? true : false),
    )
end

end # arith
