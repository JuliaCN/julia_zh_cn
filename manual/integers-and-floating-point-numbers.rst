.. _man-integers-and-floating-point-numbers:

**************
 整数和浮点数
**************

整数和浮点数是算术和计算的基础。它们都是数字文本。例如 ``1`` 是整数文本， ``1.0`` 是浮点数文本。

Julia 提供了丰富的基础数值类型，全部的算数运算符和位运算符，以及标准数学函数。这些数据和操作直接对应于现代计算机支持的操作。因此, Julia 能充分利用硬件的计算资源。另外, Julia 还从软件层面支持 :ref:`man-arbitrary-precision-arithmetic` ，可以用于表示硬件不能原生支持的数值，当然，这牺牲了部分运算效率。

Julia 提供的基础数值类型有：

-  **整数类型：**

===========  =========  ==============  ============== ==================
类型         有符号？  位数            最小值         最大值
-----------  ---------  --------------  -------------- ------------------
``Int8``           ✓       8            -2^7             2^7 - 1
``Uint8``                  8             0               2^8 - 1
``Int16``          ✓       16           -2^15            2^15 - 1
``Uint16``                 16            0               2^16 - 1
``Int32``          ✓       32           -2^31            2^31 - 1
``Uint32``                 32            0               2^32 - 1
``Int64``          ✓       64           -2^63            2^63 - 1
``Uint64``                 64            0               2^64 - 1
``Int128``         ✓       128           -2^127          2^127 - 1
``Uint128``                128           0               2^128 - 1
``Bool``         N/A       8           ``false`` (0)  ``true`` (1)
``Char``         N/A       32          ``'\0'``       ``'\Uffffffff'``
===========  =========  ==============  ============== ==================

``Char`` 原生支持 `Unicode 字符 <http://zh.wikipedia.org/zh-cn/Unicode>`_ ；详见 :ref:`man-strings` 。

-  **浮点数类型：**

=========== ========= ==============
类型        精度      位数
----------- --------- --------------
``Float16`` 半精度_      16
``Float32`` 单精度_    32
``Float64`` 双精度_    64
=========== ========= ==============

.. _半精度: http://en.wikipedia.org/wiki/Half-precision_floating-point_format
.. _单精度: http://zh.wikipedia.org/zh-cn/%E5%96%AE%E7%B2%BE%E5%BA%A6%E6%B5%AE%E9%BB%9E%E6%95%B8
.. _双精度: http://zh.wikipedia.org/zh-cn/%E9%9B%99%E7%B2%BE%E5%BA%A6%E6%B5%AE%E9%BB%9E%E6%95%B8

另外, 对 :ref:`man-complex-and-rational-numbers` 的支持建立在这些基础数据类型之上。所有的基础数据类型通过灵活用户可扩展的 :ref:`类型提升系统 <man-conversion-and-promotion>` ，不需显式类型转换，就可以互相运算。

整数
----

使用标准方式来表示文本化的整数： ::

    julia> 1
    1

    julia> 1234
    1234

整数文本的默认类型，取决于目标系统是 32 位架构还是 64 位架构： ::

    # 32-bit system:
    julia> typeof(1)
    Int32

    # 64-bit system:
    julia> typeof(1)
    Int64

Julia 内部变量 ``WORD_SIZE`` 用以指示目标系统是 32 位还是 64 位. ::

    # 32-bit system:
    julia> WORD_SIZE
    32

    # 64-bit system:
    julia> WORD_SIZE
    64
 
另外，Julia定义了 ``Int`` 和 ``Uint`` 类型，它们分别是系统原生的有符号和无符号
整数类型的别名： ::

    # 32-bit system:
    julia> Int
    Int32
    julia> Uint
    Uint32


    # 64-bit system:
    julia> Int
    Int64
    julia> Uint
    Uint64

对于不能用 32 位而只能用 64 位来表示的大整数文本，不管系统类型是什么，始终被认为是 64 位整数： ::

    # 32-bit or 64-bit system:
    julia> typeof(3000000000)
    Int64

无符号整数的输入和输出使用前缀 ``0x`` 和十六进制数字 ``0-9a-f`` （也可以使用 ``A-F`` ）。无符号数的位数大小，由十六进制数的位数决定： ::

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

``typemin`` 和 ``typemax`` 的返回值，与所给的参数类型是同一类的。（上述例子用到了一些将要介绍到的特性，包括 :ref:`for 循环 <man-loops>` ，:ref:`man-strings` ，及 :ref:`man-string-interpolation` 。）


溢出
----

在 Julia 中，如果计算结果超出数据类型所能代表的最大值，将会发生溢出： ::

    julia> x = typemax(Int64)
    9223372036854775807
    
    julia> x + 1
    -9223372036854775808

    julia> x + 1 == typemin(Int64)
    true

可见, Julia 中的算数运算其实是一种 `同余算术 <http://zh.wikipedia.org/zh-cn/%E5%90%8C%E9%A4%98>`_ 。它反映了现代计算机底层整数算术运算特性。如果有可能发生溢出，一定要显式的检查是否溢出；或者使用 ``BigInt`` 类型（详见 :ref:`man-arbitrary-precision-arithmetic` ）。

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

上述结果均为 ``Float64`` 值。文本化的 ``Float32`` 值也可以直接输入，这时使用 ``f`` 来替代 ``e`` ： ::

    julia> 0.5f0
    0.5f0

    julia> typeof(ans)
    Float32

    julia> 2.5f-4
    0.00025f0

浮点数也可以很容易地转换为 ``Float32`` ： ::

    julia> float32(-1.5)
    -1.5f0

    julia> typeof(ans)
    Float32

Hexadecimal floating-point literals are also valid, but only as ``Float64`` values::

    julia> 0x1p0
    1.0

    julia> 0x1.8p3
    12.0

    julia> 0x.4p-1
    0.125

    julia> typeof(ans)
    Float64

Half-precision floating-point numbers are also supported (``Float16``), but
only as a storage format. In calculations they'll be converted to ``Float32``::

    julia> sizeof(float16(4.))
    2

    julia> 2*float16(4.)
    8.0f0


浮点数类型的零
--------------

浮点数类型中存在 `两个零 <http://zh.wikipedia.org/zh-cn/%E2%88%920>`_ ，正数的
零和负数的零。它们相等，但有着不同的二进制表示，可以使用 ``bits`` 函数看出： ::

    julia> 0.0 == -0.0
    true
    
    julia> bits(0.0)
    "0000000000000000000000000000000000000000000000000000000000000000"
    
    julia> bits(-0.0)
    "1000000000000000000000000000000000000000000000000000000000000000"

.. _man-special-floats:

特殊的浮点数
~~~~~~~~~~~~

有三个特殊的标准浮点数：

=========== =========== ===========  ================= ==========================================
特殊值                               名称              描述
-----------------------------------  ----------------- ------------------------------------------
``Float16`` ``Float32`` ``Float64``
=========== =========== ===========  ================= ==========================================
``Inf16``   ``Inf32``    ``Inf``     正无穷            比所有的有限的浮点数都大
``-Inf16``  ``-Inf32``   ``-Inf``    负无穷            比所有的有限的浮点数都小
``NaN16``   ``NaN32``    ``NaN``     不存在            不能和任意浮点数比较大小（包括它自己）
=========== =========== ===========  ================= ==========================================

详见 :ref:`man-numeric-comparisons` 。按照 `IEEE 754 标准 <http://zh.wikipedia.org/zh-cn/IEEE_754>`_ ，这几个值可如下获得： ::

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

``typemin`` 和 ``typemax`` 函数也适用于浮点数类型： ::

    julia> (typemin(Float16),typemax(Float16))
    (Float16(0xfc00),Float16(0x7c00))

    julia> (typemin(Float32),typemax(Float32))
    (-Inf32,Inf32)

    julia> (typemin(Float64),typemax(Float64))
    (-Inf,Inf)


精度
----

大多数的实数并不能用浮点数精确表示，因此有必要知道两个相邻浮点数间的间距，也即 `计算机的精度 <http://en.wikipedia.org/wiki/Machine_epsilon>`_ 。

Julia 提供了 ``eps`` 函数，可以用来检查 ``1.0`` 和下一个可表示的浮点数之间的间距： ::

    julia> eps(Float32)
    1.192092896e-07

    julia> eps(Float64)
    2.22044604925031308e-16

    julia> eps() #Same as eps(Float64)
    2.22044604925031308e-16

``eps`` 函数也可以取浮点数作为参数，给出这个值和下一个可表示的浮点数的绝对差，即， ``eps(x)`` 的结果与 ``x`` 同类型，且满足 ``x + eps(x)`` 是下一个比 ``x`` 稍大的、可表示的浮点数： ::

    julia> eps(1.0)
    2.22044604925031308e-16

    julia> eps(1000.)
    1.13686837721616030e-13

    julia> eps(1e-27)
    1.79366203433576585e-43

    julia> eps(0.0)
    5.0e-324

相邻的两个浮点数之间的距离并不是固定的，数值越小，间距越小；数值越大, 间距越大。换句话说，浮点数在 0 附近最稠密，随着数值越来越大，数值越来越稀疏，数值间的距离呈指数增长。根据定义， ``eps(1.0)`` 与 ``eps(Float64)`` 相同，因为 ``1.0`` 是 64 位浮点数。

函数 ``nextfloat`` 和 ``prevfloat`` 可以用来获取下一个或上一个浮点数: ::

    julia> x = 1.25f0
    1.25f0
    
    julia> nextfloat(x)
    1.2500001f0
    
    julia> prevfloat(x)
    1.2499999f0
    
    julia> bits(prevfloat(x))
    "00111111100111111111111111111111"
    
    julia> bits(x)
    "00111111101000000000000000000000"
    
    julia> bits(nextfloat(x))
    "00111111101000000000000000000001"

This example highlights the general principle that the adjacent representable
floating-point numbers also have adjacent binary integer representations.

Rounding modes
~~~~~~~~~~~~~~

If a number doesn't have an exact floating-point representation, it must be
rounded to an appropriate representable value, however, if wanted, the manner
in which this rounding is done can be changed according to the rounding modes
presented in the `IEEE 754 标准 <http://en.wikipedia.org/wiki/IEEE_754-2008>`_::
    

    julia> 1.1 + 0.1
    1.2000000000000002

    julia> with_rounding(RoundDown) do
           1.1 + 0.1
           end
    1.2

The default mode used is always ``RoundNearest``, which rounds to the nearest
representable value, with ties rounded towards the nearest value with an even
least significant bit.

背景和参考资料
~~~~~~~~~~~~~~

浮点数的算术运算同人们的预期存在着许多差异，特别是对不了解底层实现的人。许多科学计算的书籍都会详细的解释这些差异。下面是一些参考资料：

- 关于浮点数算数运算最权威的指南是 `IEEE 754-2008 标准 <http://standards.ieee.org/findstds/standard/754-2008.html>`_ ；然而，该指南没有免费的网络版
- 一个简短但是清晰地解释了浮点数是怎么表示的, 请参考 John D. Cook 的 `文章 <http://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/>`_ 。它还 `简述 <http://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/>`_ 了由于浮点数的表示方法不同于理想的实数会带来怎样的问题
- 推荐 Bruce Dawson 的 `关于浮点数的博客 <http://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats/>`_
- David Goldberg 的 `每个计算机科学家都需要了解的浮点数算术计算 <http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.102.244&rep=rep1&type=pdf>`_ ，是一篇非常精彩的文章， 深入讨论了浮点数和浮点数的精度问题
- 更深入的文档, 请参考 "浮点数之父" `William Kahan <http://en.wikipedia.org/wiki/William_Kahan>`_ 的 `collected writings
  <http://www.cs.berkeley.edu/~wkahan/>`_ ，其中详细记录了浮点数的历史、理论依据、问题，还有其它很多的数值计算方面的内容。更有兴趣的可以读 `采访浮点数之父 <http://www.cs.berkeley.edu/~wkahan/ieee754status/754story.html>`_

.. _man-arbitrary-precision-arithmetic:

任意精度的算术
--------------

为保证整数和浮点数计算的精度，Julia 打包了 `GNU Multiple Precision Arithmetic Library, GMP <http://gmplib.org>`_ 和 `GNU MPFR Library <http://www.mpfr.org>`_ 。Julia 相应提供了 ``BigInt`` 和 ``BigFloat`` 类型。

可以通过基础数值类型或 ``String`` 类型来构造： ::

    julia> BigInt(typemax(Int64)) + 1
    9223372036854775808

    julia> BigInt("123456789012345678901234567890") + 1
    123456789012345678901234567891

    julia> BigFloat("1.23456789012345678901")
    1.234567890123456789010000000000000000000000000000000000000000000000000000000004e+00 with 256 bits of precision

    julia> BigFloat(2.0^66) / 3
    2.459565876494606882133333333333333333333333333333333333333333333333333333333344e+19 with 256 bits of precision

    julia> factorial(BigInt(40))
    815915283247897734345611269596115894272000000000

然而，基础数据类型和 `BigInt`/`BigFloat` 不能自动进行类型转换，需要明确指定 ::

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

The default precision (in number of bits of the significand) and rounding
mode of `BigFloat` operations can be changed, and all further calculations 
will take these changes in account::

    julia> with_bigfloat_rounding(RoundUp) do
           BigFloat(1) + BigFloat("0.1")
           end
    1.100000000000000000000000000000000000000000000000000000000000000000000000000003e+00 with 256 bits of precision

    julia> with_bigfloat_rounding(RoundDown) do
           BigFloat(1) + BigFloat("0.1")
           end
    1.099999999999999999999999999999999999999999999999999999999999999999999999999986e+00 with 256 bits of precision

    julia> with_bigfloat_precision(40) do
           BigFloat(1) + BigFloat("0.1")
           end
    1.0999999999985e+00 with 40 bits of precision


   
.. _man-numeric-literal-coefficients:

代数系数
--------

Julia 允许在变量前紧跟着数值文本，来表示乘法。这有助于写多项式表达式： ::

    julia> x = 3
    3

    julia> 2x^2 - 3x + 1
    10

    julia> 1.5x^2 - .5x + 1
    13.0

指数函数也更好看： ::

    julia> 2^2x
    64

数值文本系数同单目运算符一样。因此 ``2^3x`` 被解析为 ``2^(3x)`` ， ``2x^3`` 被解析为 ``2*(x^3)`` 。

数值文本也可以作为括号表达式的因子： ::

    julia> 2(x-1)^2 - 3(x-1) + 1
    3

括号表达式可作为变量的因子： ::

    julia> (x-1)x
    6

不要接着写两个变量括号表达式，也不要把变量放在括号表达式之前。它们不能被用来指代乘法运算： ::

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
-  浮点数文本表达式 ``1e10`` 可以被解析为数值文本 ``1`` 乘以变量 ``e10`` 。 ``E`` 格式也同样。

这两种情况下，我们都把表达式解析为数值文本：

-  以 ``0x`` 开头的表达式，都被解析为十六进制文本
-  以数字文本开头，后面跟着 ``e`` 或 ``E`` ，都被解析为浮点数文本

零和一
------

Julia 提供了一些函数, 用以得到特定数据类型的零和一文本。

===========  =====================================================
函数         说明
-----------  -----------------------------------------------------
``zero(x)``  类型 ``x`` 或变量 ``x`` 的类型下的文本零
``one(x)``   类型 ``x`` 或变量 ``x`` 的类型下的文本一
===========  =====================================================

这俩函数在 :ref:`man-numeric-comparisons` 中可用来避免额外的 :ref:`类型转换 <man-conversion-and-promotion>` 。

例如： ::

    julia> zero(Float32)
    0.0f0
    
    julia> zero(1.0)
    0.0

    julia> one(Int32)
    1

    julia> one(BigFloat)
    1e+00
    