# 整数和浮点数

<!-- # Integers and Floating-Point Numbers -->

整数和浮点值是算术和计算的基础。这些数值内建的表示被称作数值原始类型（numeric primitive），且整数和浮点数在代码中作为即时的值被称作数值字面量（numeric literal）。例如，`1` 是个整型字面量，`1.0` 是个浮点型字面量，它们在内存中作为对象的二进制表示就是数值原始类型。

<!-- Integers and floating-point values are the basic building blocks of arithmetic and computation.
Built-in representations of such values are called numeric primitives, while representations of
integers and floating-point numbers as immediate values in code are known as numeric literals.
For example, `1` is an integer literal, while `1.0` is a floating-point literal; their binary
in-memory representations as objects are numeric primitives. -->

Julia 提供了很丰富的原始数值类型，以及在它们上定义的整套的算术与按位运算符和标准数学函数。这些函数直接映射到现代计算机原生支持的数值类型及运算上，因此 Julia 可以完整地利用运算资源的优势。此外，Julia 还为[任意精度算术](@ref)提供了软件支持，从而能够处理在那些无法高效地使用原生硬件表示的数值上的运算，虽然需要以性能变得相对低一些为代价。

<!-- Julia provides a broad range of primitive numeric types, and a full complement of arithmetic and
bitwise operators as well as standard mathematical functions are defined over them. These map
directly onto numeric types and operations that are natively supported on modern computers, thus
allowing Julia to take full advantage of computational resources. Additionally, Julia provides
software support for [Arbitrary Precision Arithmetic](@ref), which can handle operations on numeric
values that cannot be represented effectively in native hardware representations, but at the cost
of relatively slower performance. -->

以下是 Julia 的原始数值类型：

<!-- The following are Julia's primitive numeric types: -->

  * **整数类型：**

  <!-- * **Integer types:** -->

| 类型              | 带符号? | 比特数 | 最小值 | 最大值 |
<!-- | Type              | Signed? | Number of bits | Smallest value | Largest value | -->
|:----------------- |:------- |:-------------- |:-------------- |:------------- |
| [`Int8`](@ref)    | ✓       | 8              | -2^7           | 2^7 - 1       |
| [`UInt8`](@ref)   |         | 8              | 0              | 2^8 - 1       |
| [`Int16`](@ref)   | ✓       | 16             | -2^15          | 2^15 - 1      |
| [`UInt16`](@ref)  |         | 16             | 0              | 2^16 - 1      |
| [`Int32`](@ref)   | ✓       | 32             | -2^31          | 2^31 - 1      |
| [`UInt32`](@ref)  |         | 32             | 0              | 2^32 - 1      |
| [`Int64`](@ref)   | ✓       | 64             | -2^63          | 2^63 - 1      |
| [`UInt64`](@ref)  |         | 64             | 0              | 2^64 - 1      |
| [`Int128`](@ref)  | ✓       | 128            | -2^127         | 2^127 - 1     |
| [`UInt128`](@ref) |         | 128            | 0              | 2^128 - 1     |
| [`Bool`](@ref)    | N/A     | 8              | `false` (0)    | `true` (1)    |

  * **浮点类型：**

  <!-- * **Floating-point types:** -->

| 类型              | 精度                                                                      | 比特数 |
<!-- | Type              | Precision                                                                      | Number of bits | -->
|:----------------- |:------------------------------------------------------------------------------ |:-------------- |
| [`Float16`](@ref) | [half](https://en.wikipedia.org/wiki/Half-precision_floating-point_format)     | 16             |
| [`Float32`](@ref) | [single](https://en.wikipedia.org/wiki/Single_precision_floating-point_format) | 32             |
| [`Float64`](@ref) | [double](https://en.wikipedia.org/wiki/Double_precision_floating-point_format) | 64             |

此外，对[复数和分数](@ref)的完整支持是在这些原始类型之上建立起来的。多亏了 Julia 有一个很灵活的、用户可扩展的[类型提升系统](@ref conversion-and-promotion)，所有的数值类型都无需现实转换就可以很自然地相互进行运算。

<!-- Additionally, full support for [Complex and Rational Numbers](@ref) is built on top of these primitive
numeric types. All numeric types interoperate naturally without explicit casting, thanks to a
flexible, user-extensible [type promotion system](@ref conversion-and-promotion). -->

## 整数

<!-- ## Integers -->

字面的整数以标准习俗表示：

<!-- Literal integers are represented in the standard manner: -->

```jldoctest
julia> 1
1

julia> 1234
1234
```

整型字面量的默认类型决定于目标系统是 32 位架构还是 64 位的：

<!-- The default type for an integer literal depends on whether the target system has a 32-bit architecture
or a 64-bit architecture: -->

```julia-repl
# 32-bit system:
julia> typeof(1)
Int32

# 64-bit system:
julia> typeof(1)
Int64
```

Julia 的内部变量 [`Sys.WORD_SIZE`](@ref) 指示了目标系统是 32 位还是 64 位：

<!-- The Julia internal variable [`Sys.WORD_SIZE`](@ref) indicates whether the target system is 32-bit
or 64-bit: -->

```julia-repl
# 32-bit system:
julia> Sys.WORD_SIZE
32

# 64-bit system:
julia> Sys.WORD_SIZE
64
```

Julia 也定义了 `Int` 与 `UInt` 类型，它们分别是系统有符号和无符号的原生整数类型的别名。

<!-- Julia also defines the types `Int` and `UInt`, which are aliases for the system's signed and unsigned
native integer types respectively: -->

```julia-repl
# 32-bit system:
julia> Int
Int32
julia> UInt
UInt32

# 64-bit system:
julia> Int
Int64
julia> UInt
UInt64
```

那些超过 32 位表示的大整数，如果能用 64 位表示，则无论是什么系统都会用 64 位表示：

<!-- Larger integer literals that cannot be represented using only 32 bits but can be represented in
64 bits always create 64-bit integers, regardless of the system type: -->

```jldoctest
# 32-bit or 64-bit system:
julia> typeof(3000000000)
Int64
```

无符号整数通过 `0x` 前缀以及十六进制数 `0-9a-f` 输入和输出（输入也可以使用大写的 `A-F`）。无符号值的位数决定于使用的十六进制数字的数量：

<!-- Unsigned integers are input and output using the `0x` prefix and hexadecimal (base 16) digits
`0-9a-f` (the capitalized digits `A-F` also work for input). The size of the unsigned value is
determined by the number of hex digits used: -->

```jldoctest
julia> 0x1
0x01

julia> typeof(ans)
UInt8

julia> 0x123
0x0123

julia> typeof(ans)
UInt16

julia> 0x1234567
0x01234567

julia> typeof(ans)
UInt32

julia> 0x123456789abcdef
0x0123456789abcdef

julia> typeof(ans)
UInt64

julia> 0x11112222333344445555666677778888
0x11112222333344445555666677778888

julia> typeof(ans)
UInt128
```

这种做法是由于当人们使用无符号十六进制字面量表示整数值，通常会用它们来表示一个固定的数值字节序列，而不仅仅是个整数值。

<!-- This behavior is based on the observation that when one uses unsigned hex literals for integer
values, one typically is using them to represent a fixed numeric byte sequence, rather than just
an integer value. -->

还记得这个 [`ans`](@ref) 吗？它表示交互式会话中上一个表达式的运算结果，但是在其他方式运行的 Julia 代码不存在。

<!-- Recall that the variable [`ans`](@ref) is set to the value of the last expression evaluated in
an interactive session. This does not occur when Julia code is run in other ways. -->

二进制和八进制字面量也受到支持：

<!-- Binary and octal literals are also supported: -->

```jldoctest
julia> 0b10
0x02

julia> typeof(ans)
UInt8

julia> 0o010
0x08

julia> typeof(ans)
UInt8

julia> 0x00000000000000001111222233334444
0x00000000000000001111222233334444

julia> typeof(ans)
UInt128
```

十六进制、二进制和八进制的字面量都会产生无符号的整数类型。当字面量不是开头全是 0 时，它们二进制数据项的位数会是最少需要的位数。当开头都是 0 时，位数决定于一个字面量的最少需要位数，这里的字面量指的是一个有着同样长度但开头都为 `1` 的数。这样用户就可以控制位数了。那些无法使用 `UInt128` 类型存储下的值无法写成这样的字面量。

<!-- As for hexadecimal literals, binary and octal literals produce unsigned integer types. The size
of the binary data item is the minimal needed size, if the leading digit of the literal is not
`0`. In the case of leading zeros, the size is determined by the minimal needed size for a
literal, which has the same length but leading digit `1`. That allows the user to control
the size.
Values, which cannot be stored in `UInt128` cannot be written as such literals. -->

二进制、八进制和十六进制的字面量可以在前面紧接着加一个 `-` 符号，这样可以产生一个和原字面量有着同样位数而值为原数的补码（二补数）：

<!-- Binary, octal, and hexadecimal literals may be signed by a `-` immediately preceding the
unsigned literal. They produce an unsigned integer of the same size as the unsigned literal
would do, with the two's complement of the value: -->

```jldoctest
julia> -0x2
0xfe

julia> -0x0002
0xfffe
```

整型等原始数值类型的最小和最大可表示的值可用 [`typemin`](@ref) 和 [`typemax`](@ref) 函数得到：

<!-- The minimum and maximum representable values of primitive numeric types such as integers are given
by the [`typemin`](@ref) and [`typemax`](@ref) functions: -->

```jldoctest
julia> (typemin(Int32), typemax(Int32))
(-2147483648, 2147483647)

julia> for T in [Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128]
           println("$(lpad(T,7)): [$(typemin(T)),$(typemax(T))]")
       end
   Int8: [-128,127]
  Int16: [-32768,32767]
  Int32: [-2147483648,2147483647]
  Int64: [-9223372036854775808,9223372036854775807]
 Int128: [-170141183460469231731687303715884105728,170141183460469231731687303715884105727]
  UInt8: [0,255]
 UInt16: [0,65535]
 UInt32: [0,4294967295]
 UInt64: [0,18446744073709551615]
UInt128: [0,340282366920938463463374607431768211455]
```

[`typemin`](@ref) 和 [`typemax`](@ref) 返回的值总是属于所给的参数类型。（上面的表达式用了一些我们目前还没有介绍的功能，包括 [for 循环](@ref man-loops)、[字符串](@ref man-strings)和[插值](@ref)，但对于已有一些编程经验的用户应该是足够容易理解的。）

<!-- The values returned by [`typemin`](@ref) and [`typemax`](@ref) are always of the given argument
type. (The above expression uses several features we have yet to introduce, including [for loops](@ref man-loops),
[Strings](@ref man-strings), and [Interpolation](@ref), but should be easy enough to understand for users
with some existing programming experience.) -->

### 溢出

<!-- ### Overflow behavior -->

Julia 中，超过了一个类型最大可表示的值时会以一个环绕行为（wraparound behavior）给出结果：

<!-- In Julia, exceeding the maximum representable value of a given type results in a wraparound behavior: -->

```jldoctest
julia> x = typemax(Int64)
9223372036854775807

julia> x + 1
-9223372036854775808

julia> x + 1 == typemin(Int64)
true
```

因此，Julia 整数的算术实际上是[模算数](https://zh.wikipedia.org/wiki/%E6%A8%A1%E7%AE%97%E6%95%B8)的一种形式。它可以反映出如现代计算机所实现的一样的整数算术的特点。在可能遇到溢出的应用场景中，对溢出产生的环绕行为进行显式的检查是很重要的。否则，推荐使用[任意精度算术](@ref)中的 [`BigInt`](@ref) 类型作为替代。

<!-- Thus, arithmetic with Julia integers is actually a form of [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic).
This reflects the characteristics of the underlying arithmetic of integers as implemented on modern
computers. In applications where overflow is possible, explicit checking for wraparound produced
by overflow is essential; otherwise, the [`BigInt`](@ref) type in [Arbitrary Precision Arithmetic](@ref)
is recommended instead. -->

### 除法错误

<!-- ### Division errors -->

整数除法（`div` 函数）有两种异常情况：被 0 除，以及使用 -1 去除最小的负数（[`typemin`](@ref)）。这两种情况都会抛出一个 [`DivideError`](@ref) 错误。取余和取模函数（`rem` 和 `mod`）在它们第二个参数是零时抛出 [`DivideError`](@ref) 错误。

<!-- Integer division (the `div` function) has two exceptional cases: dividing by zero, and dividing
the lowest negative number ([`typemin`](@ref)) by -1. Both of these cases throw a [`DivideError`](@ref).
The remainder and modulus functions (`rem` and `mod`) throw a [`DivideError`](@ref) when their
second argument is zero. -->

## 浮点数

<!-- ## Floating-Point Numbers -->

字面的浮点数也使用标准习俗表示，必要时可使用 [E-表示法](https://en.wikipedia.org/wiki/Scientific_notation#E-notation)：

<!-- Literal floating-point numbers are represented in the standard formats, using
[E-notation](https://en.wikipedia.org/wiki/Scientific_notation#E-notation) when necessary: -->

```jldoctest
julia> 1.0
1.0

julia> 1.
1.0

julia> 0.5
0.5

julia> .5
0.5

julia> -1.23
-1.23

julia> 1e10
1.0e10

julia> 2.5e-4
0.00025
```

上面的结果都是 [`Float64`](@ref) 值。使用 `f` 替代 `e` 可以写出字面的 [`Float32`](@ref) 值：

<!-- The above results are all [`Float64`](@ref) values. Literal [`Float32`](@ref) values can be
entered by writing an `f` in place of `e`: -->

```jldoctest
julia> 0.5f0
0.5f0

julia> typeof(ans)
Float32

julia> 2.5f-4
0.00025f0
```

值也可以很容易地被转换成 [`Float32`](@ref)：

Values can be converted to [`Float32`](@ref) easily:

```jldoctest
julia> Float32(-1.5)
-1.5f0

julia> typeof(ans)
Float32
```

也存在十六进制的浮点数字面量，但只适用于 [`Float64`] 值，加上使用 `p` 及以 2 为底的指数来表示：

<!-- Hexadecimal floating-point literals are also valid, but only as [`Float64`](@ref) values,
with `p` preceding the base-2 exponent: -->

```jldoctest
julia> 0x1p0
1.0

julia> 0x1.8p3
12.0

julia> 0x.4p-1
0.125

julia> typeof(ans)
Float64
```

Julia 也支持半精度浮点数（[`Float16`](@ref)），但它们是由软件实现的，且使用 [`Float32`](@ref) 做计算。

<!-- Half-precision floating-point numbers are also supported ([`Float16`](@ref)), but they are
implemented in software and use [`Float32`](@ref) for calculations. -->

```jldoctest
julia> sizeof(Float16(4.))
2

julia> 2*Float16(4.)
Float16(8.0)
```

下划线 `_` 可被用作数字分隔符：

<!-- The underscore `_` can be used as digit separator: -->

```jldoctest
julia> 10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010
(10000, 5.0e-9, 0xdeadbeef, 0xb2)
```

### 浮点型的零

<!-- ### Floating-point zero -->

浮点数有[两个零](https://zh.wikipedia.org/wiki/%E2%88%920)，正零和负零。它们相互相等但有着不同的二进制表示，可以使用 `bits` 函数来查看：

<!-- Floating-point numbers have [two zeros](https://en.wikipedia.org/wiki/Signed_zero), positive zero
and negative zero. They are equal to each other but have different binary representations, as
can be seen using the `bits` function: -->

```jldoctest
julia> 0.0 == -0.0
true

julia> bitstring(0.0)
"0000000000000000000000000000000000000000000000000000000000000000"

julia> bitstring(-0.0)
"1000000000000000000000000000000000000000000000000000000000000000"
```

### 特殊的浮点值

<!-- ### Special floating-point values -->

有三种特定的标准浮点值不和实数轴上任何一点对应：

<!-- There are three specified standard floating-point values that do not correspond to any point on
the real number line: -->

| `Float16` | `Float32` | `Float64` | 名称                  | 描述                                        |
|:--------- |:--------- |:--------- |:--------------------- |:------------------------------------------- |
| `Inf16`   | `Inf32`   | `Inf`     | 正无穷大               | 一个比所有有限浮点值都更大的值                |
| `-Inf16`  | `-Inf32`  | `-Inf`    | 负无穷大               | 一个比所有有限浮点值都更小的值                |
| `NaN16`   | `NaN32`   | `NaN`     | 不是数（not a number） | 一个不和任何浮点值（包括自己）相等（`==`）的值 |

<!-- | `Float16` | `Float32` | `Float64` | Name              | Description                                                     |
|:--------- |:--------- |:--------- |:----------------- |:--------------------------------------------------------------- |
| `Inf16`   | `Inf32`   | `Inf`     | positive infinity | a value greater than all finite floating-point values           |
| `-Inf16`  | `-Inf32`  | `-Inf`    | negative infinity | a value less than all finite floating-point values              |
| `NaN16`   | `NaN32`   | `NaN`     | not a number      | a value not `==` to any floating-point value (including itself) | -->

对于这些非有限浮点值相互之间以及关于其它浮点值的顺序的更多讨论，请参见[数值比较](Wref)。根据 [IEEE 754 标准](https://en.wikipedia.org/wiki/IEEE_754_revision)，这些浮点值是某些算术运算的结果：

<!-- For further discussion of how these non-finite floating-point values are ordered with respect
to each other and other floats, see [Numeric Comparisons](@ref). By the [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008),
these floating-point values are the results of certain arithmetic operations: -->

```jldoctest
julia> 1/Inf
0.0

julia> 1/0
Inf

julia> -5/0
-Inf

julia> 0.000001/0
Inf

julia> 0/0
NaN

julia> 500 + Inf
Inf

julia> 500 - Inf
-Inf

julia> Inf + Inf
Inf

julia> Inf - Inf
NaN

julia> Inf * Inf
Inf

julia> Inf / Inf
NaN

julia> 0 * Inf
NaN
```

[`typemin`](@ref) 和 [`typemax`](@ref) 函数同样适用于浮点类型：

<!-- The [`typemin`](@ref) and [`typemax`](@ref) functions also apply to floating-point types: -->

```jldoctest
julia> (typemin(Float16),typemax(Float16))
(-Inf16, Inf16)

julia> (typemin(Float32),typemax(Float32))
(-Inf32, Inf32)

julia> (typemin(Float64),typemax(Float64))
(-Inf, Inf)
```

### 机器零点（Machine epsilon）

<!-- ### Machine epsilon -->

大多数实数都无法用浮点数准确地表示，因此有必要知道两个相邻可表示的浮点数间的距离。它通常被叫做[机器零点](https://en.wikipedia.org/wiki/Machine_epsilon)。

<!-- Most real numbers cannot be represented exactly with floating-point numbers, and so for many purposes
it is important to know the distance between two adjacent representable floating-point numbers,
which is often known as [machine epsilon](https://en.wikipedia.org/wiki/Machine_epsilon). -->

Julia 提供了 [`eps`](@ref) 函数，它可以给出 `1.0` 与下一个更大的可表示的浮点数之间的距离：

<!-- Julia provides [`eps`](@ref), which gives the distance between `1.0` and the next larger representable
floating-point value: -->

```jldoctest
julia> eps(Float32)
1.1920929f-7

julia> eps(Float64)
2.220446049250313e-16

julia> eps() # same as eps(Float64)
2.220446049250313e-16
```

这些值分别是 [`Float32`](@ref) 中的 `2.0^-23` 和 [`Float64`](@ref) 中的 `2.0^-52`。[`eps`](@ref) 函数也可以接受一个浮点值作为参数，然后给出这个值与下一个可表示的值直接的绝对差。也就是说，`eps(x)` 产生一个和 `x` 类型相同的值使得 `x + eps(x)` 是比 `x` 更大的下一个可表示的浮点值：

<!-- These values are `2.0^-23` and `2.0^-52` as [`Float32`](@ref) and [`Float64`](@ref) values,
respectively. The [`eps`](@ref) function can also take a floating-point value as an
argument, and gives the absolute difference between that value and the next representable
floating point value. That is, `eps(x)` yields a value of the same type as `x` such that
`x + eps(x)` is the next representable floating-point value larger than `x`: -->

```jldoctest
julia> eps(1.0)
2.220446049250313e-16

julia> eps(1000.)
1.1368683772161603e-13

julia> eps(1e-27)
1.793662034335766e-43

julia> eps(0.0)
5.0e-324
```

两个相邻可表示的浮点数之间的距离并不是常数，数值越小，间距越小，数值越大，间距越大。换句话说，可表示的浮点数在实数轴上的零点附近最稠密，并沿着远离零点的方向以指数型的速度变得越来越稀疏。根据定义，`eps(1.0)` 与 `eps(Float64)` 相等，因为 `1.0` 是个 64 位浮点值。

<!-- The distance between two adjacent representable floating-point numbers is not constant, but is
smaller for smaller values and larger for larger values. In other words, the representable floating-point
numbers are densest in the real number line near zero, and grow sparser exponentially as one moves
farther away from zero. By definition, `eps(1.0)` is the same as `eps(Float64)` since `1.0` is
a 64-bit floating-point value. -->

Julia 也提供了 [`nextfloat`](@ref) 和 [`prevfloat`](@ref) 两个函数分别来返回对于参数下一个更大或更小的可表示的浮点数：

<!-- Julia also provides the [`nextfloat`](@ref) and [`prevfloat`](@ref) functions which return
the next largest or smallest representable floating-point number to the argument respectively: -->

```jldoctest
julia> x = 1.25f0
1.25f0

julia> nextfloat(x)
1.2500001f0

julia> prevfloat(x)
1.2499999f0

julia> bitstring(prevfloat(x))
"00111111100111111111111111111111"

julia> bitstring(x)
"00111111101000000000000000000000"

julia> bitstring(nextfloat(x))
"00111111101000000000000000000001"
```

这个例子体现了一般原则，即相邻可表示的浮点数也有着相邻的二进制整数表示。

<!-- This example highlights the general principle that the adjacent representable floating-point numbers
also have adjacent binary integer representations. -->

### 舍入模式

<!-- ### Rounding modes -->

一个数如果没有精确的浮点表示，就必须被舍入到一个合适的可表示的值。然而，如果想的话，可以根据舍入模式改变舍入的方式，如 [IEEE 754 标准](https://en.wikipedia.org/wiki/IEEE_754_revision)所述。

<!-- If a number doesn't have an exact floating-point representation, it must be rounded to an appropriate
representable value, however, if wanted, the manner in which this rounding is done can be changed
according to the rounding modes presented in the [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008). -->

```jldoctest
julia> x = 1.1; y = 0.1;

julia> x + y
1.2000000000000002

julia> setrounding(Float64,RoundDown) do
           x + y
       end
1.2
```

Julia 所使用的默认模式总是 [`RoundNearest`](@ref)，指的是会舍入到最接近的可表示的值，这个被舍入的值会使用尽量少的有效位数。

<!-- The default mode used is always [`RoundNearest`](@ref), which rounds to the nearest representable
value, with ties rounded towards the nearest value with an even least significant bit. -->

!!! 警告
    舍入通常只对基础的算术函数（[`+`](@ref)，[`-`](@ref)，[`*`](@ref)，[`/`](@ref) 和 [`sqrt`](@ref)）及类型转换操作是正确的。很多其它函数假设了使用默认模式 [`RoundNearest`](@ref)，从而会在使用其它舍入模式的运算时给出有误的结果。

<!-- !!! warning
    Rounding is generally only correct for basic arithmetic functions ([`+`](@ref), [`-`](@ref),
    [`*`](@ref), [`/`](@ref) and [`sqrt`](@ref)) and type conversion operations. Many other
    functions assume the default [`RoundNearest`](@ref) mode is set, and can give erroneous results
    when operating under other rounding modes. -->

### 背景及参考

<!-- ### Background and References -->

浮点算术带来了很多微妙之处，它们可能对于那些不熟悉底层实现细节的用户会是很出人意料的。然而，这些微妙之处在大部分科学计算的书籍中以及以下的参考资料中都有详细介绍:

<!-- Floating-point arithmetic entails many subtleties which can be surprising to users who are unfamiliar
with the low-level implementation details. However, these subtleties are described in detail in
most books on scientific computation, and also in the following references: -->

  * 浮点算术的权威性指南是 [IEEE 754-2008 Standard](http://standards.ieee.org/findstds/standard/754-2008.html)。然而在网上无法免费获得。
  * 关于浮点数是如何表示的，想要一个简单而明白的介绍的话，可以看 John D. Cook 在这个主题上的的[文章](https://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/)，以及他关于从这种表示与实数理想的抽象化的差别中产生的一些问题的[介绍](https://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/)。
  * 同样推荐 Bruce Dawson 的[一系列关于浮点数的博客文章](https://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats)。
  * 想要一个对浮点数和使用浮点数计算时产生的数值精度问题的极好的、有深度的讨论，可以参见 David Goldberg 的文章 [What Every Computer Scientist Should Know About Floating-Point Arithmetic](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf)。
  * 更多延伸文档，包括浮点数的历史、基础理论、问题以及数值计算中很多其它主题的讨论，可以参见 [William Kahan](https://en.wikipedia.org/wiki/William_Kahan) 的[写作集](https://people.eecs.berkeley.edu/~wkahan/)。他以“浮点数之父”闻名。特别感兴趣的话可以看 [An Interview with the Old Man of Floating-Point](https://people.eecs.berkeley.edu/~wkahan/ieee754status/754story.html)。

  <!-- * The definitive guide to floating point arithmetic is the [IEEE 754-2008 Standard](http://standards.ieee.org/findstds/standard/754-2008.html);
    however, it is not available for free online.
  * For a brief but lucid presentation of how floating-point numbers are represented, see John D.
    Cook's [article](https://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/)
    on the subject as well as his [introduction](https://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/)
    to some of the issues arising from how this representation differs in behavior from the idealized
    abstraction of real numbers.
  * Also recommended is Bruce Dawson's [series of blog posts on floating-point numbers](https://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats/).
  * For an excellent, in-depth discussion of floating-point numbers and issues of numerical accuracy
    encountered when computing with them, see David Goldberg's paper [What Every Computer Scientist Should Know About Floating-Point Arithmetic](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf).
  * For even more extensive documentation of the history of, rationale for, and issues with floating-point
    numbers, as well as discussion of many other topics in numerical computing, see the [collected writings](https://people.eecs.berkeley.edu/~wkahan/)
    of [William Kahan](https://en.wikipedia.org/wiki/William_Kahan), commonly known as the "Father
    of Floating-Point". Of particular interest may be [An Interview with the Old Man of Floating-Point](https://people.eecs.berkeley.edu/~wkahan/ieee754status/754story.html). -->

## 任意精度算术

<!-- ## Arbitrary Precision Arithmetic -->

为了允许使用任意精度的整数与浮点数，Julia 分别包装了 [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org) 以及 [GNU MPFR Library](http://www.mpfr.org)。Julia 中的 [`BigInt`](@ref) 与 [`BigFloat`](@ref) 两种类型分别提供了任意精度的整数和浮点数。

<!-- To allow computations with arbitrary-precision integers and floating point numbers, Julia wraps
the [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org) and the [GNU MPFR Library](http://www.mpfr.org),
respectively. The [`BigInt`](@ref) and [`BigFloat`](@ref) types are available in Julia for arbitrary
precision integer and floating point numbers respectively. -->

存在从原始数字类型创建它们的构造器，也可以使用 [`parse`](@ref) 从 `AbstractString` 来构造它们。一旦被创建，它们就可以像所有其它数值类型一样参与算术（也是多亏了 Julia 的[类型提升和转换机制](@ref conversion-and-promotion)）。

<!-- Constructors exist to create these types from primitive numerical types, and [`parse`](@ref)
can be used to construct them from `AbstractString`s.  Once created, they participate in arithmetic
with all other numeric types thanks to Julia's [type promotion and conversion mechanism](@ref conversion-and-promotion): -->

```jldoctest
julia> BigInt(typemax(Int64)) + 1
9223372036854775808

julia> parse(BigInt, "123456789012345678901234567890") + 1
123456789012345678901234567891

julia> parse(BigFloat, "1.23456789012345678901")
1.234567890123456789010000000000000000000000000000000000000000000000000000000004

julia> BigFloat(2.0^66) / 3
2.459565876494606882133333333333333333333333333333333333333333333333333333333344e+19

julia> factorial(BigInt(40))
815915283247897734345611269596115894272000000000
```

然而，上面的原始类型与 [`BigInt`](@ref)/[`BigFloat`](@ref) 之间的类型提升并不是自动的，需要明确地指定：

<!-- However, type promotion between the primitive types above and [`BigInt`](@ref)/[`BigFloat`](@ref)
is not automatic and must be explicitly stated. -->

```jldoctest
julia> x = typemin(Int64)
-9223372036854775808

julia> x = x - 1
9223372036854775807

julia> typeof(x)
Int64

julia> y = BigInt(typemin(Int64))
-9223372036854775808

julia> y = y - 1
-9223372036854775809

julia> typeof(y)
BigInt
```

[`BigFloat`](@ref) 的默认精度（有效数字的位数）和舍入模式可以通过调用 [`setprecision`](@ref) 和 [`setrounding`](@ref) 来全局地改变，所有之后的计算都会根据这些改变进行。还有一种方法，可以使用同样的函数以及 `do` 语句块来只在运行一个特定代码块时改变精度和舍入模式：

<!-- The default precision (in number of bits of the significand) and rounding mode of [`BigFloat`](@ref)
operations can be changed globally by calling [`setprecision`](@ref) and [`setrounding`](@ref),
and all further calculations will take these changes in account.  Alternatively, the precision
or the rounding can be changed only within the execution of a particular block of code by using
the same functions with a `do` block: -->

```jldoctest
julia> setrounding(BigFloat, RoundUp) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.100000000000000000000000000000000000000000000000000000000000000000000000000003

julia> setrounding(BigFloat, RoundDown) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.099999999999999999999999999999999999999999999999999999999999999999999999999986

julia> setprecision(40) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.1000000000004
```

## [数值字面量系数](@id man-numeric-literal-coefficients)

<!-- ## [Numeric Literal Coefficients](@id man-numeric-literal-coefficients) -->

为了让常见的数值公式和表达式更清楚，Julia 允许变量直接跟在一个数值字面量后，暗指乘法。这可以让写多项式变得很清楚：

<!-- To make common numeric formulas and expressions clearer, Julia allows variables to be immediately
preceded by a numeric literal, implying multiplication. This makes writing polynomial expressions
much cleaner: -->

```jldoctest numeric-coefficients
julia> x = 3
3

julia> 2x^2 - 3x + 1
10

julia> 1.5x^2 - .5x + 1
13.0
```

也会让写指数函数更加优雅：

<!-- It also makes writing exponential functions more elegant: -->

```jldoctest numeric-coefficients
julia> 2^2x
64
```

数值字面量系数的优先级跟一元运算符相同，比如说取相反数。所以 `2^3x` 会被解析成 `2^(3x)`，而 `2x^3` 会被解析成 `2*(x^3)`。

<!-- The precedence of numeric literal coefficients is the same as that of unary operators such as
negation. So `2^3x` is parsed as `2^(3x)`, and `2x^3` is parsed as `2*(x^3)`. -->

数值字面量也能作为被括号表达式的系数：

<!-- Numeric literals also work as coefficients to parenthesized expressions: -->

```jldoctest numeric-coefficients
julia> 2(x-1)^2 - 3(x-1) + 1
3
```
!!! 注意
    用于隐式乘法的数值字面量系数的优先级高于其它的二元运算符，例如乘法（`*`）和除法（`/`、`\` 以及 `//`）。这意味着，比如说，`1 / 2im` 等于 `-0.5im` 以及 `6 // 2(2+1)` 等于 `1 // 1`。

<!-- !!! note
    The precedence of numeric literal coefficients used for implicit
    multiplication is higher than other binary operators such as multiplication
    (`*`), and division (`/`, `\`, and `//`).  This means, for example, that
    `1 / 2im` equals `-0.5im` and `6 // 2(2 + 1)` equals `1 // 1`. -->

此外，括号表达式可以被用作变量的系数，暗指表达式与变量相乘：

<!-- Additionally, parenthesized expressions can be used as coefficients to variables, implying multiplication
of the expression by the variable: -->

```jldoctest numeric-coefficients
julia> (x-1)x
6
```

但是，无论是把两个括号表达式并列，还是把变量放在括号表达式之前，都不会被用作暗指乘法：

<!-- Neither juxtaposition of two parenthesized expressions, nor placing a variable before a parenthesized
expression, however, can be used to imply multiplication: -->

```jldoctest numeric-coefficients
julia> (x-1)(x+1)
ERROR: MethodError: objects of type Int64 are not callable

julia> x(x+1)
ERROR: MethodError: objects of type Int64 are not callable
```

这两种表达式都会被解释成函数调用：所有不是数值字面量的表达式，后面紧跟一个括号，就会被解释成使用括号内的值来调用函数（更多关于函数的信息请参见[函数](@ref)）。因此，在这两种情况中，都会因为左手边的值并不是函数而产生错误

<!-- Both expressions are interpreted as function application: any expression that is not a numeric
literal, when immediately followed by a parenthetical, is interpreted as a function applied to
the values in parentheses (see [Functions](@ref) for more about functions). Thus, in both of these
cases, an error occurs since the left-hand value is not a function. -->

上述的语法糖显著地降低了在写通常的数学公式时的视觉噪音。注意数值字面量系数和后面用来相乘的标识符或括号表达式之间不能有空格。

<!-- The above syntactic enhancements significantly reduce the visual noise incurred when writing common
mathematical formulae. Note that no whitespace may come between a numeric literal coefficient
and the identifier or parenthesized expression which it multiplies. -->

### 语法冲突

<!-- ### Syntax Conflicts -->

并列的字面量系数语法可能和两种数值字面量语法产生冲突：十六进制整数字面量以及浮点字面量的工程表示法。下面是几种会产生语法冲突的情况：

<!-- Juxtaposed literal coefficient syntax may conflict with two numeric literal syntaxes: hexadecimal
integer literals and engineering notation for floating-point literals. Here are some situations
where syntactic conflicts arise: -->

  * 十六进制整数字面量 `0xff` 可能被解释成数值字面量 `0` 乘以变量 `xff`。
  * 浮点字面量表达式 `1e10` 可以被解释成 `1` 乘以变量 `e10`，与之等价的 `E` 形式也存在类似的情况。

  <!-- * The hexadecimal integer literal expression `0xff` could be interpreted as the numeric literal
    `0` multiplied by the variable `xff`.
  * The floating-point literal expression `1e10` could be interpreted as the numeric literal `1` multiplied
    by the variable `e10`, and similarly with the equivalent `E` form. -->

在这两种情况中，都使用这样的解释方法来解决二义性：

<!-- In both cases, we resolve the ambiguity in favor of interpretation as a numeric literals: -->

  * `0x` 开头的表达式总是十六进制字面量。
  * 数值开头跟着 `e` 和 `E` 的表达式总是浮点字面量。

  <!-- * Expressions starting with `0x` are always hexadecimal literals.
  * Expressions starting with a numeric literal followed by `e` or `E` are always floating-point literals. -->

## 零和一的字面量

<!-- ## Literal zero and one -->

Julia 提供了 0 和 1 的字面量函数，可以返回特定类型或所给变量的类型。

<!-- Julia provides functions which return literal 0 and 1 corresponding to a specified type or the
type of a given variable. -->

| 函数              | 描述                              |
|:----------------- |:-------------------------------- |
| [`zero(x)`](@ref) | `x` 类型或变量 `x` 的类型的零字面量 |
| [`one(x)`](@ref)  | `x` 类型或变量 `x` 的类型的一字面量 |

<!-- | Function          | Description                                      |
|:----------------- |:------------------------------------------------ |
| [`zero(x)`](@ref) | Literal zero of type `x` or type of variable `x` |
| [`one(x)`](@ref)  | Literal one of type `x` or type of variable `x`  | -->

这些函数在[数值比较](@ref)中可以用来避免不必要的[类型转换](@ref conversion-and-promotion)带来的开销。

<!-- These functions are useful in [Numeric Comparisons](@ref) to avoid overhead from unnecessary
[type conversion](@ref conversion-and-promotion). -->

例如：

<!-- Examples: -->

```jldoctest
julia> zero(Float32)
0.0f0

julia> zero(1.0)
0.0

julia> one(Int32)
1

julia> one(BigFloat)
1.0
```
