.. _man-integers-and-floating-point-numbers:

**************
 整数和浮点数  
**************

整数和浮点数是算术和计算的基础。它们都是数字文本。例如 ``1`` 是整数文本， ``1.0`` 是浮点数文本。Julia 提供的基础数值类型有：

-  **整数类型：**

   -  ``Int8`` — 有符号 8 位整数，取值 -2^7 到 2^7 - 1
   -  ``Uint8`` — 无符号 8 位整数，取值 0 到 2^8 - 1
   -  ``Int16`` — 有符号 16 位整数，取值 -2^15 到 2^15 - 1
   -  ``Uint16`` — 无符号 16 位整数，取值 0 到 2^16 - 1
   -  ``Int32`` — 有符号 32 位整数，取值 -2^31 到 2^31 - 1
   -  ``Uint32`` — 无符号 32 位整数，取值 0 到 2^32 - 1
   -  ``Int64`` — 有符号 64 位整数，取值 -2^63 到 2^63 - 1
   -  ``Uint64`` — 无符号 64 位整数，取值 0 到 2^64 - 1
   -  ``Int128`` - 有符号 128 位整数，取值 -2^127 到 2^127 - 1
   -  ``Uint128`` - 无符号 128 位整数，取值 0 到 2^128 - 1
   -  ``Bool`` — 取值 ``true`` 或者 ``false`` ，数值上对应于 1 和 0
   -  ``Char`` — 一个 32 位的数值类型，表示一个 `Unicode 字符 <http://zh.wikipedia.org/zh-cn/Unicode>`_ （详见 :ref:`man-strings` ）

-  **浮点数类型：**

   -  ``Float32`` — `IEEE 754 32 位浮点数 <http://zh.wikipedia.org/zh-cn/%E5%8D%95%E7%B2%BE%E7%A1%AE%E6%B5%AE%E7%82%B9%E6%95%B0>`_
   -  ``Float64`` — `IEEE 754 64 位浮点数 <http://zh.wikipedia.org/zh-cn/%E9%9B%99%E7%B2%BE%E5%BA%A6%E6%B5%AE%E9%BB%9E%E6%95%B8>`_

整数
----

使用标准方式来表示文本化的整数： ::

    julia> 1
    1

    julia> 1234
    1234

整数文本的默认类型，取决于目标系统是 32 位架构还是 64 位架构： ::

    # 32 位系统:
    julia> typeof(1)
    Int32

    # 64 位系统:
    julia> typeof(1)
    Int64

使用 ``WORD_SIZE`` 来确认目标系统是32 位还是 64 位。 ``Int`` 类型是系统本地整数类型的别名： ::

    # 32 位系统:
    julia> Int
    Int32

    # 64 位系统:
    julia> Int
    Int64

类似的， ``Uint`` 是系统原生的无符号整数类型的别名： ::

    # 32 位系统:
    julia> Uint
    Uint32

    # 64 位系统:
    julia> Uint
    Uint64

不能用 32 位，但能用 64 位来表示的大整数文本，不管系统类型是什么，始终被认为是 64 位整数： ::

    # 32 位或 64 位系统:
    julia> typeof(3000000000)
    Int64

无符号整数使用前缀 ``0x`` 和十六进制数字 ``0-9a-f`` （也可以使用 ``A-F`` ）。无符号数的大小，由十六进制数的位数决定： ::

    julia> 0x1
    0x01

    julia> typeof(ans)
    Uint8

    julia> 0x123
    0x0123

    julia> typeof(ans)
    Uint16

    julia> 0x1234567
    0x01234567

    julia> typeof(ans)
    Uint32

    julia> 0x123456789abcdef
    0x0123456789abcdef

    julia> typeof(ans)
    Uint64

二进制和八进制文本： ::

    julia> 0b10
    0x02

    julia> 0o10
    0x08

基础数值类型的最小值和最大值，可由 ``typemin`` 和 ``typemax`` 函数查询： ::

    julia> (typemin(Int32), typemax(Int32))
    (-2147483648,2147483647)

    julia> for T = {Int8,Int16,Int32,Int64,Int128,Uint8,Uint16,Uint32,Uint64,Uint128}
             println("$(lpad(T,6)): [$(typemin(T)),$(typemax(T))]")
           end

       Int8: [-128,127]
      Int16: [-32768,32767]
      Int32: [-2147483648,2147483647]
      Int64: [-9223372036854775808,9223372036854775807]
     Int128: [-170141183460469231731687303715884105728,170141183460469231731687303715884105727]
      Uint8: [0x00,0xff]
     Uint16: [0x0000,0xffff]
     Uint32: [0x00000000,0xffffffff]
     Uint64: [0x0000000000000000,0xffffffffffffffff]
    Uint128: [0x00000000000000000000000000000000,0xffffffffffffffffffffffffffffffff]

``typemin`` 和 ``typemax`` 的返回值，与所给的参数类型是同一类的。上述例子用到了一些将要介绍到的特性，包括 :ref:`for 循环 <man-loops>` ， :ref:`man-strings` ，及 :ref:`man-string-interpolation` 。

浮点数
------

使用标准格式来表示文本化的浮点数： ::

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
    1e+10

    julia> 2.5e-4
    0.00025

上述结果均为 ``Float64`` 值。不存在 ``Float32`` 的文本化格式，但可以把一个值转换为 ``Float32`` ： ::

    julia> float32(-1.5)
    -1.5

    julia> typeof(ans)
    Float32

有三个特殊的标准浮点值：

-  ``Inf`` — 正无穷 — 比所有的有限的浮点值都大
-  ``-Inf`` — 负无穷 — 比所有的有限的浮点值都小
-  ``NaN`` — 不存在 — 不能和任意浮点数比较大小（包括它自己）

详见 :ref:`man-numeric-comparisons` 。按照 `IEEE 754 标准 <http://zh.wikipedia.org/zh-cn/IEEE_754>`_ ，这几个值可如下获得： ::

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

    julia> Inf/Inf
    NaN

``typemin`` 和 ``typemax`` 函数也适用于浮点数类型： ::

    julia> (typemin(Float32),typemax(Float32))
    (-Inf32,Inf32)

    julia> (typemin(Float64),typemax(Float64))
    (-Inf,Inf)

注意 ``Float32`` 都有后缀 “32” : ``NaN32``, ``Inf32``, 和 ``-Inf32`` 。

浮点数类型也支持 ``eps`` 函数，它给出了 ``1.0`` 与下一个比 ``1.0`` 稍大的、可表示的浮点数的差： ::

    julia> eps(Float32)
    1.192092896e-07

    julia> eps(Float64)
    2.22044604925031308e-16

``eps`` 函数也可以取浮点数作为参数，给出这个值和下一个可表示的浮点数的绝对差，即， ``eps(x)`` 的结果与 ``x`` 同类型，满足 ``x + eps(x)`` 是下一个比 ``x`` 稍大的、可表示的浮点数： ::

    julia> eps(1.0)
    2.22044604925031308e-16

    julia> eps(1000.)
    1.13686837721616030e-13

    julia> eps(1e-27)
    1.79366203433576585e-43

    julia> eps(0.0)
    5.0e-324

可表示的浮点数，靠近 0 最密，离 0 越远则指数般地越来越稀疏。由定义可知， ``eps(1.0)`` 与 ``eps(Float64)`` 相同，因为 ``1.0`` 是 64 位浮点数。

.. _man_arbitrary_precision_arithmetic:

任意精度的算术
------------------------------

为保证整数和浮点数计算的精度，Julia 打包了 `GNU Multiple Precision Arithmetic Library, GMP <http://gmplib.org>`_ 。Julia 相应提供了 ``BigInt`` 和 ``BigFloat`` 类型。

可以通过基础数值类型或 ``String`` 类型来构造： ::

    julia> BigInt(typemax(Int64)) + 1
    9223372036854775808

    julia> BigInt("123456789012345678901234567890") + 1
    123456789012345678901234567891

    julia> BigFloat("1.23456789012345678901")
    1.23456789012345678901

    julia> BigFloat(2.0^66) / 3
    24595658764946068821.3

    julia> factorial(BigInt(40))
    815915283247897734345611269596115894272000000000

.. _man-numeric-literal-coefficients:

代数系数
--------

Julia 允许在变量前紧跟着数值文本，来表示乘法。这有助于简化表达式： ::

    julia> x = 3
    3

    julia> 2x^2 - 3x + 1
    10

    julia> 1.5x^2 - .5x + 1
    13.0

还可以使指数函数更好看： ::

    julia> 2^2x
    64

数值文本系数同单目运算符一样。因此 ``2^3x`` 被解析为 ``2^(3x)`` ， ``2x^3`` 被解析为 ``2*(x^3)`` 。

也可以把数值文本作为括号表达式的因子： ::

    julia> 2(x-1)^2 - 3(x-1) + 1
    3

括号表达式可作为变量的因子： ::

    julia> (x-1)x
    6

两个变量括号表达式邻接，或者把变量放在括号表达式之前，不能被用来指代乘法运算： ::

    julia> (x-1)(x+1)
    type error: apply: expected Function, got Int64

    julia> x(x+1)
    type error: apply: expected Function, got Int64

这两个表达式都被解析为函数调用：任何非数值文本的表达式，如果后面跟着括号，代表调用函数来处理括号内的数值（详见 :ref:`man-functions` ）。因此，由于左面的值不是函数，这两个例子都出错了。

需要注意，代数因子和变量或括号表达式之间不能有空格。

语法冲突
~~~~~~~~

文本因子与两个数值表达式语法冲突: 十六进制整数文本和浮点数文本的科学计数法：

-  十六进制整数文本表达式 ``0xff`` 可以被解析为数值文本 ``0`` 乘以变量 ``xff``
-  浮点数文本表达式 ``1e10`` 可以被解析为数值文本 ``1`` 乘以变量 ``e10`` ，类比 ``E`` 格式

两种情况下，我们都把表达式解析为数值文本：

-  以 ``0x`` 开头的表达式，都被解析为十六进制文本
-  以数字文本开头，后面跟着 ``e`` 或 ``E`` ，都被解析为浮点数文本
