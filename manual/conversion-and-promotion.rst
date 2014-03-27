.. _man-conversion-and-promotion:

********************
 类型转换和类型提升
********************

Julia 可以将数学运算符的参数提升为同一个类型，这些参数的类型曾经在 :ref:`man-integers-and-floating-point-numbers` ， :ref:`man-mathematical-operations` ， :ref:`man-types` ，及 :ref:`man-methods` 中提到过。

在某种意义上，Julia 是“非自动类型提升”的：数学运算符只是有特殊语法的函数，函数的参数不会被自动转换。但通过重载，仍能做到“自动”类型提升。

.. _man-conversion:

类型转换
--------

``convert`` 函数用于将值转换为各种类型。它有两个参数：第一个是类型对象，第二个是要转换的值；返回值是转换为指定类型的值：

.. doctest::

    julia> x = 12
    12

    julia> typeof(x)
    Int64

    julia> convert(Uint8, x)
    0x0c

    julia> typeof(ans)
    Uint8

    julia> convert(FloatingPoint, x)
    12.0

    julia> typeof(ans)
    Float64

遇到不能转换时， ``convert`` 会引发 “no method” 错误：

.. doctest::

    julia> convert(FloatingPoint, "foo")
    ERROR: no method convert(Type{FloatingPoint}, ASCIIString)
     in convert at base.jl:11

Julia 不做字符串和数字之间的类型转换。

定义新类型转换
~~~~~~~~~~~~~~

要定义新类型转换，只需给 ``convert`` 提供新方法即可。下例将数值转换为布尔值： ::

    convert(::Type{Bool}, x::Number) = (x!=0)

此方法第一个参数的类型是 :ref:`单态类型 <man-singleton-types>` ， ``Bool`` 是 ``Type{Bool}`` 的唯一实例。此方法仅在第一个参数是 ``Bool`` 才调用，转换时检查数值是否为 0 ：

.. doctest::

    julia> convert(Bool, 1)
    true

    julia> convert(Bool, 0)
    false

    julia> convert(Bool, 1im)
    ERROR: InexactError()
     in convert at complex.jl:27

    julia> convert(Bool, 0im)
    false

实际使用的类型转换都比较复杂，下例是 Julia 中的一个实现： ::

    convert{T<:Real}(::Type{T}, z::Complex) = (imag(z)==0 ? convert(T,real(z)) :
                                               throw(InexactError()))

    julia> convert(Bool, 1im)
    InexactError()
     in convert at complex.jl:40


案例：分数类型转换
~~~~~~~~~~~~~~~~~~

继续 Julia 的 ``Rational`` 类型的案例研究， `rational.jl <https://github.com/JuliaLang/julia/blob/master/base/rational.jl>`_ 中类型转换的声明紧跟在类型声明和构造函数之后： ::

    convert{T<:Int}(::Type{Rational{T}}, x::Rational) = Rational(convert(T,x.num),convert(T,x.den))
    convert{T<:Int}(::Type{Rational{T}}, x::Int) = Rational(convert(T,x), convert(T,1))

    function convert{T<:Int}(::Type{Rational{T}}, x::FloatingPoint, tol::Real)
        if isnan(x); return zero(T)//zero(T); end
        if isinf(x); return sign(x)//zero(T); end
        y = x
        a = d = one(T)
        b = c = zero(T)
        while true
            f = convert(T,round(y)); y -= f
            a, b, c, d = f*a+c, f*b+d, a, b
            if y == 0 || abs(a/b-x) <= tol
                return a//b
            end
            y = 1/y
        end
    end
    convert{T<:Int}(rt::Type{Rational{T}}, x::FloatingPoint) = convert(rt,x,eps(x))

    convert{T<:FloatingPoint}(::Type{T}, x::Rational) = convert(T,x.num)/convert(T,x.den)
    convert{T<:Int}(::Type{T}, x::Rational) = div(convert(T,x.num),convert(T,x.den))


前四个定义可确保 ``a//b == convert(Rational{Int64}, a/b)`` 。后两个把分数转换为浮点数和整数类型。

.. _man-promotion:

类型提升
--------

类型提升是指将各种类型的值转换为同一类型。它与类型等级关系无关，例如，每个 ``Int32`` 值都可以被表示为 ``Float64`` 值，但 ``Int32`` 不是 ``Float64`` 的子类型。

Julia 使用 ``promote`` 函数来做类型提升，其参数个数可以是任意多，它返回同样个数的同一类型的多元组；如果不能提升，则抛出异常。类型提升常用来将数值参数转换为同一类型：

.. doctest::

    julia> promote(1, 2.5)
    (1.0,2.5)

    julia> promote(1, 2.5, 3)
    (1.0,2.5,3.0)

    julia> promote(2, 3//4)
    (2//1,3//4)

    julia> promote(1, 2.5, 3, 3//4)
    (1.0,2.5,3.0,0.75)

    julia> promote(1.5, im)
    (1.5 + 0.0im,0.0 + 1.0im)

    julia> promote(1 + 2im, 3//4)
    (1//1 + 2//1im,3//4 + 0//1im)

浮点数值提升为最高的浮点数类型。整数值提升为本地机器的原生字长或最高的整数值类型。既有整数也有浮点数时，提升为可以包括所有值的浮点数类型。既有整数也有分数时，提升为分数。既有分数也有浮点数时，提升为浮点数。既有复数也有实数时，提升为适当的复数。

数值运算中，数学运算符 ``+``, ``-``, ``*`` 和 ``/`` 等方法定义，都“巧妙”的应用了类型提升。下例是 `promotion.jl <https://github.com/JuliaLang/julia/blob/master/base/promotion.jl>`_ 中的一些定义： ::

    +(x::Number, y::Number) = +(promote(x,y)...)
    -(x::Number, y::Number) = -(promote(x,y)...)
    *(x::Number, y::Number) = *(promote(x,y)...)
    /(x::Number, y::Number) = /(promote(x,y)...)

`promotion.jl <https://github.com/JuliaLang/julia/blob/master/base/promotion.jl>`_ 中还定义了其它算术和数学运算类型提升的方法，但 Julia 标准库中几乎没有调用 ``promote`` 。 ``promote`` 一般用在外部构造方法中，便于使构造函数适应各种不同类型的参数。 `rational.jl <https://github.com/JuliaLang/julia/blob/master/base/rational.jl>`_ 中提供了如下的外部构造方法： ::

    Rational(n::Integer, d::Integer) = Rational(promote(n,d)...)

此方法的例子：

.. doctest::

    julia> Rational(int8(15),int32(-5))
    -3//1

    julia> typeof(ans)
    Rational{Int64} (constructor with 1 method)

对自定义类型来说，最好由程序员给构造函数显式提供所期待的类型。但处理数值问题时，做自动类型提升比较方便。

定义类型提升规则
~~~~~~~~~~~~~~~~

尽管可以直接给 ``promote`` 函数定义方法，但这太麻烦了。我们用辅助函数 ``promote_rule`` 来定义 ``promote`` 的行为。 ``promote_rule`` 函数接收类型对象对儿，返回另一个类型对象。此函数将参数中的类型的实例，提升为要返回的类型： ::

    promote_rule(::Type{Float64}, ::Type{Float32} ) = Float64

提升后的类型不需要与函数的参数类型相同。下面是 Julia 标准库中的例子： ::

    promote_rule(::Type{Uint8}, ::Type{Int8}) = Int
    promote_rule(::Type{Char}, ::Type{Uint8}) = Int32

不需要同时定义 ``promote_rule(::Type{A}, ::Type{B})`` 和 ``promote_rule(::Type{B}, ::Type{A})`` —— ``promote_rule`` 函数在提升过程中隐含了对称性。

``promote_type`` 函数使用 ``promote_rule`` 函数来定义，它接收任意个数的类型对象，返回它们作为 ``promote`` 参数时，所应返回值的公共类型。因此可以使用 ``promote_type`` 来了解特定类型的组合会提升为哪种类型：

.. doctest::

    julia> promote_type(Int8, Uint16)
    Int64

``promote`` 使用 ``promote_type`` 来决定类型提升时要把参数值转换为哪种类型。完整的类型提升机制可见 `promotion.jl <https://github.com/JuliaLang/julia/blob/master/base/promotion.jl>`_ ，一共有 35 行。

案例：分数类型提升
~~~~~~~~~~~~~~~~~~

我们结束 Julia 分数类型的案例： ::

    promote_rule{T<:Int}(::Type{Rational{T}}, ::Type{T}) = Rational{T}
    promote_rule{T<:Int,S<:Int}(::Type{Rational{T}}, ::Type{S}) = Rational{promote_type(T,S)}
    promote_rule{T<:Int,S<:Int}(::Type{Rational{T}}, ::Type{Rational{S}}) = Rational{promote_type(T,S)}
    promote_rule{T<:Int,S<:FloatingPoint}(::Type{Rational{T}}, ::Type{S}) = promote_type(T,S)
