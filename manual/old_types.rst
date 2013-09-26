参数化抽象类型
~~~~~~~~~~~~~~

类似地，参数化抽象类型声明一个抽象类型的集合： ::

    abstract Pointy{T}

对每个类型或整数值 ``T`` ， ``Pointy{T}`` 都是一个不同的抽象类型。 ``Pointy`` 的每个实例都是它的子类型： ::

    julia> Pointy{Int64} <: Pointy
    true

    julia> Pointy{1} <: Pointy
    true

参数化抽象类型也是不相关的： ::

    julia> Pointy{Float64} <: Pointy{Real}
    false

    julia> Pointy{Real} <: Pointy{Float64}
    false

可以如下声明 ``Point{T}`` 是 ``Pointy{T}`` 的子类型： ::

    type Point{T} <: Pointy{T}
      x::T
      y::T
    end

对每个 ``T`` ，都有 ``Point{T}`` 是 ``Pointy{T}`` 的子类型： ::

    julia> Point{Float64} <: Pointy{Float64}
    true

    julia> Point{Real} <: Pointy{Real}
    true

    julia> Point{String} <: Pointy{String}
    true

它们仍然是不相关的： ::

    julia> Point{Float64} <: Pointy{Real}
    false

参数化抽象类型 ``Pointy`` 有什么用呢？假设我们要构造一个坐标点的实现，点都在对角线 *x = y* 上，因此我们只需要一个坐标： ::

    type DiagPoint{T} <: Pointy{T}
      x::T
    end

``Point{Float64}`` 和 ``DiagPoint{Float64}`` 都是 ``Pointy{Float64}`` 抽象类型的实现，这对其它可选类型 ``T`` 也一样。 ``Pointy`` 可以作为它的子类型的公共接口。有关方法和重载，详见下一节 :ref:`man-methods` 。

有时需要对 ``T`` 的范围做限制： ::

    abstract Pointy{T<:Real}

此时， ``T`` 只能是 ``Real`` 的子类型： ::

    julia> Pointy{Float64}
    Pointy{Float64}

    julia> Pointy{Real}
    Pointy{Real}

    julia> Pointy{String}
    type error: Pointy: in T, expected Real, got AbstractKind

    julia> Pointy{1}
    type error: Pointy: in T, expected Real, got Int64

参数化复合类型的类型参数，也可以同样被限制： ::

    type Point{T<:Real} <: Pointy{T}
      x::T
      y::T
    end

下面是 Julia 的 ``Rational`` 类型是如何定义的，这个类型表示分数： ::

    type Rational{T<:Integer} <: Real
      num::T
      den::T
    end

.. _man-singleton-types:

单态类型
^^^^^^^^

单态类型是一种特殊的抽象参数化类型。对每个类型 ``T`` ，抽象类型“单态” ``Type{T}`` 的实例为对象 ``T`` 。来看些例子::

    julia> isa(Float64, Type{Float64})
    true

    julia> isa(Real, Type{Float64})
    false

    julia> isa(Real, Type{Real})
    true

    julia> isa(Float64, Type{Real})
    false

换句话说，仅当 ``A`` 和 ``B`` 是同一个对象，且这个对象是类型时， ``isa(A,Type{B})`` 返回真。没有参数时， ``Type`` 仅是抽象类型，所有的类型都是它的实例，包括单态类型： ::

    julia> isa(Type{Float64},Type)
    true

    julia> isa(Float64,Type)
    true

    julia> isa(Real,Type)
    true

只有对象是类型时，才是 ``Type`` 的实例： ::

    julia> isa(1,Type)
    false

    julia> isa("foo",Type)
    false

Julia 中只有类型对象才有单态类型，而其它有单态类型的编程语言中，每个对象都有单态。

参数化位类型
~~~~~~~~~~~~

可以参数化地声明位类型。例如，Julia 中指针被定义为位类型： ::

    # 32 位系统:
    bitstype 32 Ptr{T}

    # 64 位系统:
    bitstype 64 Ptr{T}

这儿的参数类型 ``T`` 不是用来做类型定义，而是个抽象标签，它定义了一组结构相同的类型，这些类型仅能由类型参数来区分。尽管 ``Ptr{Float64}`` 和 ``Ptr{Int64}`` 的表示是一样的，它们是不同的类型。所有的特定指针类型，都是 ``Ptr`` 类型的子类型： ::

    julia> Ptr{Float64} <: Ptr
    true

    julia> Ptr{Int64} <: Ptr
    true

类型别名
--------

Julia 提供 ``typealias`` 机制来实现类型别名。如， ``Uint`` 是 ``Uint32`` 或 ``Uint64`` 的类型别名，这取决于系统的指针大小： ::

    # 32-bit system:
    julia> Uint
    Uint32

    # 64-bit system:
    julia> Uint
    Uint64

它是通过 ``base/boot.jl`` 中的代码实现的： ::

    if is(Int,Int64)
        typealias Uint Uint64
    else
        typealias Uint Uint32
    end

这取决于预定义中， ``Int`` 是 ``Int32`` 还是 ``Int64`` 的别名。

对参数化类型， ``typealias`` 提供了简单的参数化类型名。Julia 的数组类型为 ``Array{T,n}`` ，其中 ``T`` 是元素类型， ``n`` 是数组维度的数值。为简单起见， ``Array{Float64}`` 可以只指明元素类型而不需指明维度： ::

    julia> Array{Float64,1} <: Array{Float64} <: Array
    true

``Vector`` 和 ``Matrix`` 对象是如下定义的： ::

    typealias Vector{T} Array{T,1}
    typealias Matrix{T} Array{T,2}

``Vector{Float64}`` 等价于 ``Array{Float64,1}`` 。 ``Vector`` 是 ``Array`` 的实例化对象，第二个参数为 1 ，元素可以是任意类型。

类型运算
--------

Julia 中，类型本身也是对象，可以对其使用普通的函数。如 ``<:`` 运算符，可以判断左侧是否是右侧的子类型。

``isa`` 函数检测对象是否属于某个指定的类型： ::

    julia> isa(1,Int)
    true

    julia> isa(1,FloatingPoint)
    false

``typeof`` 函数返回参数的类型。类型也是对象，因此它也有类型： ::

    julia> typeof(Real)
    AbstractKind

    julia> typeof(Float64)
    BitsKind

    julia> typeof(Rational)
    CompositeKind

    julia> typeof(Union(Real,Float64,Rational))
    UnionKind

    julia> typeof((Real,Float64,Rational,None))
    (AbstractKind,BitsKind,CompositeKind,UnionKind)

类型的类型，按照惯例被称为“种类（kind）”：

-  抽象类型的类型为 ``AbstractKind``
-  位类型的类型为 ``BitsKind``
-  复合类型的类型为 ``CompositeKind``
-  共用体的类型为 ``UnionKind``
-  多元组的类型为对应种类的多元组

种类的类型都是 ``CompositeKind`` ： ::

    julia> typeof(AbstractKind)
    CompositeKind

    julia> typeof(BitsKind)
    CompositeKind

    julia> typeof(CompositeKind)
    CompositeKind

    julia> typeof(UnionKind)
    CompositeKind

注意到 ``CompositeKind`` 与空多元组相同（详见 `上文 <#tuple-types>`_ ），其类型为本身。递归使用 ``()`` 和 ``CompositeKind`` 所组成的多元组的类型，是该类型本身： ::

    julia> typeof(())
    ()

    julia> typeof(CompositeKind)
    CompositeKind

    julia> typeof(((),))
    ((),)

    julia> typeof((CompositeKind,))
    (CompositeKind,)

    julia> typeof(((),CompositeKind))
    ((),CompositeKind)

只有抽象类型 ``AbstractKind`` ，位类型 ``BitsKind`` ，及复合类型 ``CompositeKind`` 有父类型， ``super`` 只能用在这些类型上： ::

    julia> super(Float64)
    FloatingPoint

    julia> super(Number)
    Any

    julia> super(String)
    Any

    julia> super(Any)
    Any

对其它类型对象（或非类型对象）使用 ``super`` ，会引发 “no method” 错误： ::

    julia> super(Union(Float64,Int64))
    no method super(UnionKind,)

    julia> super(None)
    no method super(UnionKind,)

    julia> super((Float64,Int64))
    no method super((BitsKind,BitsKind),)
