.. _man-constructors:

**********
 构造函数
**********

构造函数 [#]_ 是构造新对象，即新 :ref:`man-composite-types` 实例的函数。构造类型对象： ::

    type Foo
      bar
      baz
    end

    julia> foo = Foo(1,2)
    Foo(1,2)

    julia> foo.bar
    1

    julia> foo.baz
    2

`递归数据结构 <http://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Recursive_data_structures_.28structural_recursion.29>`_ ，尤其是自引用的数据结构，常需要先构造为非完整状态，再按步骤将其完善。

.. [#] 关于命名：尽管“构造函数”通常被用来描述创建新对象的函数，它也经常被滥用于特定的构造方法。通常情况下，可以很容易地从上下文推断出到底是“构造函数”还是“构造方法”。

外部构造方法
------------

构造函数与其它函数一样，整体行为由它的方法的组合行为来定义。通过定义新方法，可以给构造函数增加新性能。下例给 ``Foo`` 添加了新构造方法，仅输入一个参数，将该参数值赋给 ``bar`` 和 ``baz`` 域： ::

    Foo(x) = Foo(x,x)

    julia> Foo(1)
    Foo(1,1)

添加 ``Foo`` 的零参构造方法，给 ``bar`` 和 ``baz`` 域赋默认值： ::

    Foo() = Foo(0)

    julia> Foo()
    Foo(0,0)

这种追加的构造方法被称为 *外部* 构造方法。它仅能通过提供默认值的方式，调用其它构造方法来构造实例。

内部构造方法
------------

*内部* 构造方法与外部构造方法类似，但有两个区别：

1. 它在类型声明块儿内部被声明，而不是像普通方法一样在外部被声明
2. 它调用本地已存在的 ``new`` 函数，来构造声明块儿的类型的对象

例如，要声明一个保存实数对儿的类型，且第一个数不大于第二个数：

.. testcode::

    type OrderedPair
      x::Real
      y::Real

      OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
    end

仅当 ``x <= y`` 时，才会构造 ``OrderedPair`` 对象：

.. doctest::

    julia> OrderedPair(1,2)
    OrderedPair(1,2)

    julia> OrderedPair(2,1)
    ERROR: out of order
     in OrderedPair at none:5

所有的外部构造方法，最终都会调用内部构造方法。

当然，如果类型被声明为 ``immutable`` ，它的构造函数的结构就不能变了。这对判断一个类型是否应该是 immutable 时很重要。

如果定义了内部构造方法，Julia 将不再提供默认的构造方法。默认的构造方法等价于一个自定义内部构造方法，它将对象的所有域作为参数（如果对应域有类型，应为具体类型），传递给 ``new`` ，最后返回结果对象： ::

    type Foo
      bar
      baz

      Foo(bar,baz) = new(bar,baz)
    end

这个声明与前面未指明内部构造方法的 ``Foo`` 是等价的。下面两者也是等价的，一个使用默认构造方法，一个写明了构造方法： ::

    type T1
      x::Int64
    end

    type T2
      x::Int64
      T2(x::Int64) = new(x)
    end

    julia> T1(1)
    T1(1)

    julia> T2(1)
    T2(1)

    julia> T1(1.0)
    no method T1(Float64,)

    julia> T2(1.0)
    no method T2(Float64,)

内部构造方法能不写就不写。提供默认值之类的事儿，应该写成外部构造方法，由它们调用内部构造方法。

部分初始化
----------

考虑如下递归类型声明： ::

    type SelfReferential
      obj::SelfReferential
    end

如果 ``a`` 是 ``SelfReferential`` 的实例，则可以如下构造第二个实例： ::

    b = SelfReferential(a)

但是，当没有任何实例来为 ``obj`` 域提供有效值时，如何构造第一个实例呢？唯一的解决方法是构造 ``obj`` 域未赋值的 ``SelfReferential`` 部分初始化实例，使用这个实例作为另一个实例（如它本身）中 ``obj`` 域的有效值。

构造部分初始化对象时，Julia 允许调用 ``new`` 函数来处理比该类型域个数少的参数，返回部分域未初始化的对象。这时，内部构造函数可以使用这个不完整的对象，并在返回之前完成它的初始化。下例中，我们定义 ``SelfReferential`` 类型时，使用零参内部构造方法，返回一个 ``obj`` 域指向它本身的实例：

.. testcode::

    type SelfReferential
      obj::SelfReferential

      SelfReferential() = (x = new(); x.obj = x)
    end

此构造方法可以运行并构造自引对象：

.. doctest::

    julia> x = SelfReferential();

    julia> is(x, x)
    true

    julia> is(x, x.obj)
    true

    julia> is(x, x.obj.obj)
    true

内部构造方法最好返回完全初始化的对象，但也可以返回部分初始化对象：

.. doctest::

    julia> type Incomplete
             xx
             Incomplete() = new()
           end

    julia> z = Incomplete();

尽管可以构造未初始化域的对象，但读取未初始化的引用会报错：

.. doctest::

    julia> z.xx
    ERROR: access to undefined reference
    
.. This avoids the need to continually check for ``null`` values.
.. However, not all object fields are references. Julia considers some
.. types to be "plain data", meaning all of their data is self-contained
.. and does not reference other objects. The plain data types consist of bits
.. types (e.g. ``Int``) and immutable structs of other plain data types.
.. The initial contents of a plain data type is undefined::

这避免了持续检查 ``null`` 值。但是，所有对象的域都是引用。Julia 认为一些类型是“普通数据”，即他们的数据都是独立的，都不引用其他的对象。普通数据类型是由位类型或者其他普通数据类型的不可变数据结构所构成的（例如 ``Int`` ）。普通数据类型的初始内容是未定义的： ::

    julia> type HasPlain
             n::Int
             HasPlain() = new()
           end

    julia> HasPlain()
    HasPlain(438103441441)

普通数据类型所构成的数组具有相同的行为。

.. Arrays of plain data types exhibit the same behavior.
    
可以在内部构造方法中，将不完整的对象传递给其它函数，来委托完成全部初始化： ::

    type Lazy
      xx

      Lazy(v) = complete_me(new(), v)
    end

如果 ``complete_me`` 或其它被调用的函数试图在初始化 ``Lazy`` 对象的 ``xx`` 域之前读取它，将会立即报错。

参数化构造方法
--------------

参数化构造方法的例子：

.. doctest::

    julia> type Point{T<:Real}
             x::T
             y::T
           end

    ## implicit T ##

    julia> Point(1,2)
    Point{Int64}(1,2)

    julia> Point(1.0,2.5)
    Point{Float64}(1.0,2.5)

    julia> Point(1,2.5)
    ERROR: no method Point{T<:Real}(Int64, Float64)

    ## explicit T ##

    julia> Point{Int64}(1,2)
    Point{Int64}(1,2)

    julia> Point{Int64}(1.0,2.5)
    ERROR: no method Point{Int64}(Float64, Float64)

    julia> Point{Float64}(1.0,2.5)
    Point{Float64}(1.0,2.5)

    julia> Point{Float64}(1,2)
    ERROR: no method Point{Float64}(Int64, Int64)

上面的参数化构造方法等价于下面的声明： ::

    type Point{T<:Real}
      x::T
      y::T

      Point(x::T, y::T) = new(x,y)
    end

    Point{T<:Real}(x::T, y::T) = Point{T}(x,y)

内部构造方法只定义 ``Point{T}`` 的方法，而非 ``Point`` 的构造函数的方法。 ``Point`` 不是具体类型，不能有内部构造方法。外部构造方法定义了 ``Point`` 的构造方法。

可以将整数值 ``1`` “提升”为浮点数 ``1.0`` ，来完成构造：

.. doctest::

    julia> Point(x::Int64, y::Float64) = Point(convert(Float64,x),y);

这样下例就可以正常运行：

.. doctest::

    julia> Point(1,2.5)
    Point{Float64}(1.0,2.5)

    julia> typeof(ans)
    Point{Float64} (constructor with 1 method)

但下例仍会报错：

.. doctest::

    julia> Point(1.5,2)
    ERROR: no method Point{T<:Real}(Float64, Int64)

其实只需定义下列外部构造方法：

.. doctest::

    julia> Point(x::Real, y::Real) = Point(promote(x,y)...);

``promote`` 函数将它的所有参数转换为相同类型。现在，所有的实数参数都可以正常运行：

.. doctest::

    julia> Point(1.5,2)
    Point{Float64}(1.5,2.0)

    julia> Point(1,1//2)
    Point{Rational{Int64}}(1//1,1//2)

    julia> Point(1.0,1//2)
    Point{Float64}(1.0,0.5)


案例：分数
----------

下面是 `rational.jl <https://github.com/JuliaLang/julia/blob/master/base/rational.jl>`_ 文件的开头部分，它实现了 Julia 的 :ref:`man-rational-numbers` ： ::

    type Rational{T<:Integer} <: Real
        num::T
        den::T

        function Rational(num::T, den::T)
            if num == 0 && den == 0
                error("invalid rational: 0//0")
            end
            g = gcd(den, num)
            num = div(num, g)
            den = div(den, g)
            new(num, den)
        end
    end
    Rational{T<:Integer}(n::T, d::T) = Rational{T}(n,d)
    Rational(n::Integer, d::Integer) = Rational(promote(n,d)...)
    Rational(n::Integer) = Rational(n,one(n))

    //(n::Integer, d::Integer) = Rational(n,d)
    //(x::Rational, y::Integer) = x.num // (x.den*y)
    //(x::Integer, y::Rational) = (x*y.den) // y.num
    //(x::Complex, y::Real) = complex(real(x)//y, imag(x)//y)
    //(x::Real, y::Complex) = x*y'//real(y*y')

    function //(x::Complex, y::Complex)
        xy = x*y'
        yy = real(y*y')
        complex(real(xy)//yy, imag(xy)//yy)
    end

复数分数的例子：

.. doctest::

    julia> (1 + 2im)//(1 - 2im)
    -3//5 + 4//5im

    julia> typeof(ans)
    Complex{Rational{Int64}} (constructor with 1 method)

    julia> ans <: Complex{Rational}
    false
