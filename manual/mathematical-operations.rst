.. _man-mathematical-operations:

**********
 数学运算  
**********

Julia 为它所有的基础数值类型，提供了整套的基础算术和位运算，也提供了一套高效的标准数学函数。

算术和位运算符
--------------

基础数值类型可以使用 `算术运算符 <http://zh.wikipedia.org/zh-cn/%E7%AE%97%E6%9C%AF#.E7.AE.97.E8.A1.93.E9.81.8B.E7.AE.97>`_ ：

-  ``+x`` — 一元加，为其本身
-  ``-x`` — 一元减，取相反数
-  ``x + y`` — 二元加，做加法
-  ``x - y`` — 二元减，做减法
-  ``x * y`` — 乘法
-  ``x / y`` — 除法

下面的 `位运算符 <http://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators>`_ 适用于所有整数类型：

-  ``~x`` — 取反
-  ``x & y`` — 按位与
-  ``x | y`` — 按位或
-  ``x $ y`` — 按位异或
-  ``x >>> y`` — 向右 `逻辑移位 <http://zh.wikipedia.org/wiki/%E4%BD%8D%E6%93%8D%E4%BD%9C#.E9.80.BB.E8.BE.91.E7.A7.BB.E4.BD.8D>`_ （高位补 0 ）
-  ``x >> y`` — 向右 `算术移位 <http://zh.wikipedia.org/wiki/%E4%BD%8D%E6%93%8D%E4%BD%9C#.E7.AE.97.E6.9C.AF.E7.A7.BB.E4.BD.8D>`_ （复制原高位）
-  ``x << y`` — 向左逻辑/算术移位

算术运算的例子： ::

    julia> 1 + 2 + 3
    6

    julia> 1 - 2
    -1

    julia> 3*2/12
    0.5

（习惯上，优先级低的运算，前后多补些空格。这是个人喜好，没有强制标准。）
	
Julia 的类型提升系统使得参数类型混杂的算术运算也很简单自然。详见 :ref:`man-conversion-and-promotion` 。

位运算的例子： ::

    julia> ~123
    -124

    julia> 123 & 234
    106

    julia> 123 | 234
    251

    julia> 123 $ 234
    145

    julia> ~uint32(123)
    0xffffff84

    julia> ~uint8(123)
    0x84

二进制算术和位运算都有对应的赋值运算符： ::

      julia> x = 1
      1

      julia> x += 3
      4

      julia> x
      4

赋值运算符有： ::

    +=  -=  *=  /=  &=  |=  $=  >>>=  >>=  <<=


.. _man-numeric-comparisons:

数值比较
--------

所有的基础数值类型都可以使用比较运算符：

-  ``==`` — 等于
-  ``!=`` — 不等于
-  ``<`` — 小于
-  ``<=`` — 小于等于
-  ``>`` — 大于
-  ``>=`` — 大于等于

一些例子： ::

    julia> 1 == 1
    true

    julia> 1 == 2
    false

    julia> 1 != 2
    true

    julia> 1 == 1.0
    true

    julia> 1 < 2
    true

    julia> 1.0 > 3
    false

    julia> 1 >= 1.0
    true

    julia> -1 <= 1
    true

    julia> -1 <= -1
    true

    julia> -1 <= -2
    false

    julia> 3 < -0.5
    false

整数是按位比较的。浮点数是按 `IEEE 754 标准 <http://zh.wikipedia.org/zh-cn/IEEE_754>`_ 比较的：

-  有限数按照正常方式做比较
-  ``Inf`` 等于它本身，并且比除了 ``NaN`` 的所有数都大
-  ``-Inf`` 等于它本身，并且比除了 ``NaN`` 的所有数都小
-  ``NaN`` 不等于、不大于、不小于任何数，包括它本身

有关 ``NaN`` 的性质，值得留意： ::

    julia> NaN == NaN
    false

    julia> NaN != NaN
    true

    julia> NaN < NaN
    false

    julia> NaN > NaN
    false

对于想让 ``NaN`` 等于 ``NaN`` 的情况，比如哈希值比较，可以使用 ``isequal`` 函数，它认为 ``NaN`` 等于它本身： ::

    julia> isequal(NaN,NaN)
    true

与大多数语言不同，Julia 支持 `Python链式比较 <http://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators>`_ ： ::

    julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
    true

链式比较使用 ``&`` 运算符，对数组也有效。例如， ``0 < A < 1`` 的结果是一个对应的布尔数组，满足条件的元素为 true 。

注意链式比较的比较顺序： ::

    v(x) = (println(x); x)

    julia> v(1) > v(2) <= v(3)
    2
    1
    3
    false

中间的值只计算了一次，而不是像 ``v(1) > v(2) & v(2) <= v(3)`` 一样计算了两次。链式比较的计算顺序是不确定的。不要在链式比较中使用带副作用（比如打印）的表达式。如果需要使用副作用表达式，推荐使用短路 ``&&`` 运算符（详见 :ref:`man-short-circuit-evaluation` ）。

数学函数
--------

Julia 提供了一系列数学函数和运算符：

-  ``round(x)`` — 把 ``x`` 舍入到最近的整数
-  ``iround(x)`` — 把 ``x`` 舍入到最近的整数，返回类型为整数
-  ``floor(x)`` — 把 ``x`` 向 ``-Inf`` 取整
-  ``ifloor(x)`` — 把 ``x`` 向 ``-Inf`` 取整，返回类型为整数
-  ``ceil(x)`` — 把 ``x`` 向 ``+Inf`` 取整
-  ``iceil(x)`` — 把 ``x`` 向 ``+Inf`` 取整，返回类型为整数
-  ``trunc(x)`` — 把 ``x`` 向 0 取整
-  ``itrunc(x)`` — 把 ``x`` 向 0 取整，返回类型为整数
-  ``div(x,y)`` — 截断取整除法；商向 0 舍入
-  ``fld(x,y)`` — 向下取整除法；商向 ``-Inf`` 舍入
-  ``rem(x,y)`` — 除法余数；满足 ``x == div(x,y)*y + rem(x,y)`` ，与 ``x`` 同号
-  ``mod(x,y)`` — 取模余数；满足 ``x == fld(x,y)*y + mod(x,y)`` ，与 ``y`` 同号
-  ``gcd(x,y...)`` — ``x``, ``y``... 的最大公约数，与 ``x`` 同号
-  ``lcm(x,y...)`` — ``x``, ``y``... 的最小公倍数，与 ``x`` 同号
-  ``abs(x)`` — ``x`` 的幅值
-  ``abs2(x)`` — ``x`` 的幅值的平方
-  ``sign(x)`` — ``x`` 的正负号，返回值为 -1, 0, 或 +1
-  ``signbit(x)`` — 是否有符号位，有 (1) 或者 无 (0)
-  ``copysign(x,y)`` — 返回一个数，它具有 ``x`` 的幅值， ``y`` 的符号位
-  ``flipsign(x,y)`` — 返回一个数，它具有 ``x`` 的幅值， ``x*y`` 的符号位
-  ``sqrt(x)`` — ``x`` 的平方根
-  ``cbrt(x)`` — ``x`` 的立方根
-  ``hypot(x,y)`` — 精确计算 ``sqrt(x^2 + y^2)`` 
-  ``pow(x,y)`` — ``x`` 的 ``y`` 次幂
-  ``exp(x)`` — 自然指数 ``e`` 的 ``x`` 次幂
-  ``expm1(x)`` — 当 ``x`` 接近 0 时，精确计算 ``exp(x)-1`` 
-  ``ldexp(x,n)`` — 当 ``n`` 为整数时，高效计算``x*2^n`` 
-  ``log(x)`` — ``x`` 的自然对数
-  ``log(b,x)`` — 以 ``b`` 为底 ``x`` 的对数
-  ``log2(x)`` — 以 2 为底 ``x`` 的对数
-  ``log10(x)`` — 以 10 为底 ``x`` 的对数
-  ``log1p(x)`` — 当 ``x`` 接近 0 时，精确计算 ``log(1+x)`` 
-  ``logb(x)`` — ``trunc(log2(x))``
-  ``erf(x)`` — ``x`` 处的 `误差函数 <http://zh.wikipedia.org/zh-cn/%E8%AF%AF%E5%B7%AE%E5%87%BD%E6%95%B0>`_ 
-  ``erfc(x)`` — 对于大 ``x`` ，精确计算 ``1-erf(x)``
-  ``gamma(x)`` — ``x`` 处的 `Γ函数 <http://zh.wikipedia.org/zh-cn/%CE%93%E5%87%BD%E6%95%B0>`_ 
-  ``lgamma(x)`` — 对于大 ``x`` ，精确计算 ``log(gamma(x))`` 

为什么要有 ``hypot``, ``expm1``, ``log1p``, ``erfc`` 等函数，参见 John D. Cook 的博客： `expm1, log1p, erfc <http://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/>`_ 和 `hypot <http://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/>`_ 。

三角函数： ::

    sin    cos    tan    cot    sec    csc
    sinh   cosh   tanh   coth   sech   csch
    asin   acos   atan   acot   asec   acsc
    acoth  asech  acsch  sinc   cosc   atan2

除了 `atan2 <http://zh.wikipedia.org/zh-cn/Atan2>`_ 之外，都是单参数函数。 ``atan2`` 给出了 *x* 轴，与由 *x* 、 *y* 确定的点之间的 `弧度 <http://zh.wikipedia.org/zh-cn/%E5%BC%A7%E5%BA%A6>`_ 。要以度为单位计算三角函数，使用带 ``d`` 后缀的函数。例如， ``sind(x)`` 计算 ``x`` 的正弦值， ``x`` 的单位是度。

为了好记， ``rem`` 和 ``pow`` 函数有等价运算符：

-  ``x % y`` 等价于 ``rem(x,y)`` 
-  ``x ^ y`` 等价于 ``pow(x,y)`` 

前者中 ``rem`` 较“正式”， ``%`` 是为了与其它系统保持兼容性。后者中 ``^`` 更正式， ``pow`` 函数是为了保持兼容性。 ``%`` 和 ``^`` 也有对应的赋值运算符。 ``x %= y`` 等价于 ``x = x % y`` ， ``x ^= y`` 等价于 ``x = x^y`` ： ::

    julia> x = 2; x ^= 5; x
    32

    julia> x = 7; x %= 4; x
    3

