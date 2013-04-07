.. _man-types:

******
 类型    
******

Julia 中，如果类型被省略，则值可以是任意类型。添加类型会显著提高性能和系统稳定性。

Julia `类型系统 <http://zh.wikipedia.org/zh-cn/%E9%A1%9E%E5%9E%8B%E7%B3%BB%E7%B5%B1>`_ 的特性是，具体类型不能作为具体类型的子类型，所有的具体类型都是最终的，其子类型只能是抽象类型。其它高级特性有：

-  不区分对象和非对象值：Julia 中的所有值都是一个有类型的对象，这个类型属于一个单一、全连接图，图中的每个节点都是类型
-  没有“编译时类型”：程序运行时仅有其实际类型，这在面向对象编程语言中被称为“运行时类型”
-  值有类型，变量没有类型——变量仅仅是绑定了值得名字而已
-  抽象类型和具体类型都可以被其它类型和整数参数化

.. raw:: html

   <div class="sidebar">

关于首字母大写。Julia 中并不规定首字母大写。但是按照惯例，类型名的每个单词的首字母均大写，并且不用下划线来连接各个单词。变量名则不同，一般都用小写，每个单词间用下划线“\_”连接。

.. raw:: html

   </div>

类型声明
--------

``::`` 运算符可以用来在程序中给表达式和变量附加类型注释。这样做有两个理由：

1. 作为断言，帮助确认程序是否正常运行
2. 给编译器提供额外类型信息，帮助提升性能

``::`` 运算符读作“前者是后者的实例”，它用来断言左侧表达式是否为右侧表达式的实例。如果右侧是具体类型，左侧也必须是同样类型。如果右侧是抽象类型，左侧应是一个具体类型的实例，该具体类型是这个抽象类型的子类型。如果断言为假，将抛出异常，否则，返回左值::

    julia> (1+2)::FloatingPoint
    type error: typeassert: expected FloatingPoint, got Int64

    julia> (1+2)::Int
    3

可以在任何表达式的位置做类型断言。

``::`` 运算符跟在变量名后时，它声明变量应该是某个类型，有点儿类似于 C 等静态语言中的类型声明。赋给这个变量的值会被 ``convert`` 函数转换为所声明的类型： ::

    julia> function foo()
             x::Int8 = 1000
             x
           end

    julia> foo()
    -24

    julia> typeof(ans)
    Int8

这个特性用于避免性能陷阱，即给一个变量赋值时意外更改了类型。

“声明”仅发生在特定的上下文中： ::

    x::Int8        # 仅变量自己
    local x::Int8  # 本地变量声明in a local declaration
    x::Int8 = 10   # 作为赋值语句左侧

在值的上下文，如 ``f(x::Int8)`` 中， ``::`` 是类型断言而不是声明。现在还不能在全局作用域或 REPL 中做这种声明，因为 Julia 现在还没有常量类型的全局变量。

.. _man-abstract-types:

抽象类型
--------

抽象类型不能被实例化，它组织了类型等级关系，方便程序员编程。如，编程时可针对任意整数类型，而不需指明是哪种具体的整数类型。

使用 ``abstract`` 关键字声明抽象类型： ::

    abstract «name»
    abstract «name» <: «supertype»

``abstract`` 关键字引入了新的抽象类型，类型名为 ``«name»`` 。类型名后可跟 ``<:`` 及已存在的类型，表明新声明的抽象类型是这个“父”类型的子类型。

如果没有指明父类型，则父类型默认为 ``Any`` ——所有对象和类型都是这个抽象类型的子类型。在类型理论中， ``Any`` 位于类型图的顶峰，被称为“顶”。Julia 也有预定义的抽象“底”类型，它位于类型图的最底处，被称为 ``None`` ；它与 ``Any`` 对立：任何对象都不是 ``None`` 的实例，所有的类型都是 ``None`` 的父类型。

下面是构造 Julia 数值体系的抽象类型子集的具体例子： ::

    abstract Number
    abstract Real     <: Number
    abstract FloatingPoint <: Real
    abstract Integer  <: Real
    abstract Signed   <: Integer
    abstract Unsigned <: Integer

``<:`` 运算符意思为“前者是后者的子类型”，它声明右侧是左侧新声明类型的直接父类型。也可以用来判断左侧是不是右侧的子类型： ::

    julia> Integer <: Number
    true

    julia> Integer <: FloatingPoint
    false

.. _bits-types:

位类型
------

位类型是具体类型，它的数据是由位构成的。整数和浮点数都是位类型。标准的位类型是用 Julia 语言本身定义的： ::

    bitstype 32 Float32 <: FloatingPoint
    bitstype 64 Float64 <: FloatingPoint

    bitstype 8  Bool <: Integer
    bitstype 32 Char <: Integer

    bitstype 8  Int8   <: Signed
    bitstype 8  Uint8  <: Unsigned
    bitstype 16 Int16  <: Signed
    bitstype 16 Uint16 <: Unsigned
    bitstype 32 Int32  <: Signed
    bitstype 32 Uint32 <: Unsigned
    bitstype 64 Int64  <: Signed
    bitstype 64 Uint64 <: Unsigned

声明位类型的通用语法是： ::

    bitstype «bits» «name»
    bitstype «bits» «name» <: «supertype»

``«bits»`` 表明类型需要多少空间来存储，``«name»`` 为新类型的名字。目前，位类型的声明的位数只支持 8 的倍数。

``Bool``, ``Int8`` 及 ``Uint8`` 类型的声明是完全相同的，都占用了 8 位内存，但它们是互相独立的。

.. _man-composite-types:

复合类型
--------

`复合类型 <http://zh.wikipedia.org/zh-cn/%E8%A4%87%E5%90%88%E5%9E%8B%E5%88%A5>`_ 也被称为记录、结构、或者对象。复合类型是变量名域的集合。它是 Julia 中最常用的自定义类型。在 Julia 中，所有的值都是对象，但函数并不与它们所操作的对象绑定。Julia 重载时，根据函数 *所有* 参数的类型，而不仅仅是第一个参数的类型，来选取调用哪个方法（详见 :ref:`man-methods` ）。

使用 ``type`` 关键字来定义复合类型： ::

    type Foo
      bar
      baz::Int
      qux::Float64
    end

构建复合类型 ``Foo`` 的对象： ::

    julia> foo = Foo("Hello, world.", 23, 1.5)
    Foo("Hello, world.",23,1.5)

    julia> typeof(foo)
    Foo

由于没有约束 ``bar`` 类型，它可以被赋任意值， ``baz`` 则必须是 ``Int`` ， ``qux`` 必须是 ``Float64`` 。参数必须与构造类型签名 ``(Any,Int,Float64)`` 相匹配： ::

    julia> Foo((), 23.5, 1)
    no method Foo((),Float64,Int64)

获取复合对象域的值： ::

    julia> foo.bar
    "Hello, world."

    julia> foo.baz
    23

    julia> foo.qux
    1.5

修改复合对象域的值： ::

    julia> foo.qux = 2
    2.0

    julia> foo.bar = 1//2
    1//2

没有域的复合类型是单态类型，这种类型只能有一个实例： ::

    type NoFields
    end

    julia> is(NoFields(), NoFields())
    true

``is`` 函数验证 ``NoFields`` 的“两个”实例是否为同一个。

有关复合类型如何实例化，需要 `参数化类型 <#man-parametric-types>`_ 和 :ref:`man-methods` 这两个背景知识。将在 :ref:`man-constructors` 中详细介绍构造实例。

Immutable Composite Types
-------------------------

可以使用关键词 ``immutable`` 替代 ``type`` 来定义 *不可变* 复合类型：::

    immutable Complex
      real::Float64
      imag::Float64
    end

Such types behave just like other composite types, except that instances
of them cannot be modified. Immutable types have several advantages:

- They are more efficient in some cases. Types like the ``Complex``
  example above can be packed efficiently into arrays, and in some
  cases the compiler is able to avoid allocating immutable objects
  entirely.
- It is not possible to violate the invariants provided by the
  type's constructors.
- Code using immutable objects can be easier to reason about.

An immutable object might contain mutable objects, such as arrays, as
fields. Those contained objects will remain mutable; only the fields of the
immutable object itself cannot be changed to point to different objects.

A useful way to think about immutable composites is that each instance is
associated with specific field values --- the field values alone tell
you everything about the object. In contrast, a mutable object is like a
little container that might contain different values over time, and so is
not identified with specific field values. In deciding whether to make a
type immutable, ask whether two instances with the same field values
would be considered identical, or if they might need to change independently
over time. If they would be considered identical, the type should probably
be immutable.


类型共用体
----------

类型共用体是特殊的抽象类型，使用 ``Union`` 函数来声明： ::

    julia> IntOrString = Union(Int,String)
    Union(Int,String)

    julia> 1 :: IntOrString
    1

    julia> "Hello!" :: IntOrString
    "Hello!"

    julia> 1.0 :: IntOrString
    type error: typeassert: expected Union(Int,String), got Float64

不含任何类型的类型共用体，是“底”类型 ``None`` ： ::

    julia> Union()
    None

抽象类型 ``None`` 是所有其它类型的子类型，且没有实例。零参的 ``Union`` 调用，将返回无实例对象 ``None`` 。

.. _tuple-types:

多元组类型
----------

多元组的类型是类型多元组： ::

    julia> typeof((1,"foo",2.5))
    (Int64,ASCIIString,Float64)

类型多元组可以在任何需要类型的地方使用： ::

    julia> (1,"foo",2.5) :: (Int64,String,Any)
    (1,"foo",2.5)

    julia> (1,"foo",2.5) :: (Int64,String,Float32)
    type error: typeassert: expected (Int64,String,Float32), got (Int64,ASCIIString,Float64)

如果类型多元组中有非类型出现，会报错： ::

    julia> (1,"foo",2.5) :: (Int64,String,3)
    type error: typeassert: expected Type{T}, got (BitsKind,AbstractKind,Int64)

注意，空多元组 ``()`` 的类型是其本身： ::

    julia> typeof(())
    ()

.. _man-parametric-types:

参数化类型
----------

Julia 的类型系统支持参数化：类型可以引入参数，这样类型声明为每种可能的参数组合声明一个新类型。

抽象类型，位类型，和复合类型都可以使用同样的语法进行参数化。

参数化复合类型
~~~~~~~~~~~~~~

类型参数跟在类型名后，用花括号括起来： ::

    type Point{T}
      x::T
      y::T
    end

这个声明定义了新参数化类型 ``Point{T}`` ，它有两个 ``T`` 类型的“坐标系”。参数化类型可以使任何类型（或整数，此处作为类型）。具体类型 ``Point{Float64}`` 等价于将 ``Point`` 中的 ``T`` 替换为 ``Float64`` 后的类型。上例事实上声明了许多种类型： ``Point{Float64}``, ``Point{String}``,
``Point{Int64}`` 等等，每个都是现在可用的具体类型： ::

    julia> Point{Float64}
    Point{Float64}

    julia> Point{String}
    Point{String}

``Point`` 本身也是个有效的类型对象： ::

    julia> Point
    Point{T}

``Point`` 在这儿是包含所有 ``Point{Float64}``, ``Point{String}`` 等具体实例的抽象类型： ::

    julia> Point{Float64} <: Point
    true

    julia> Point{String} <: Point
    true

其它类型则不是其子类型： ::

    julia> Float64 <: Point
    false

    julia> String <: Point
    false

``Point`` 不同 ``T`` 值的具体类型之间，不能互相作为子类型： ::

    julia> Point{Float64} <: Point{Int64}
    false

    julia> Point{Float64} <: Point{Real}
    false

后者非常重要：

    **虽然** ``Float64 <: Real`` **，但** ``Point{Float64} <: Point{Real}`` **不成立！**

换句话说，Julia 的类型参数是 *不相关* 的。尽管 ``Point{Float64}`` 的实例按照概念来说，应该是 ``Point{Real}`` 的实例，但两者在内存表示上有区别：

-  ``Point{Float64}`` 的实例可以简便、有效地表示 64 位数对儿
-  ``Point{Real}`` 的实例可以表示任意 ``Real`` 实例的数对儿。由于 ``Real`` 的实例可以为任意大小、任意结构，因此 ``Point{Real}`` 实际上表示指向 ``Real`` 对象的指针对儿

上述区别在数组中更明显： ``Array{Float64}`` 可以在一块连续内存中存储 64 位浮点数，而 ``Array{Real}`` 则保存指向每个 ``Real`` 对象的指针数组。而每个 ``Real`` 对象的大小，可能比 64 位浮点数的大。

:ref:`man-constructors` 中将介绍如何给复合类型自定义构造方法，但如果没有特殊构造声明时，默认有两种构造新复合对象的方法：一种是明确指明构造方法的类型参数；另一种是由对象构造方法的参数来隐含类型参数。

指明构造方法的类型参数： ::

    julia> Point{Float64}(1.0,2.0)
    Point(1.0,2.0)

    julia> typeof(ans)
    Point{Float64}

参数个数应匹配： ::

    julia> Point{Float64}(1.0)
    no method Point(Float64,)

    julia> Point{Float64}(1.0,2.0,3.0)
    no method Point(Float64,Float64,Float64)

大多数情况下不需要提供 ``Point`` 对象的类型，它可由参数类型来提供信息。因此，可以不提供 ``T`` 的值： ::

    julia> Point(1.0,2.0)
    Point(1.0,2.0)

    julia> typeof(ans)
    Point{Float64}

    julia> Point(1,2)
    Point(1,2)

    julia> typeof(ans)
    Point{Int64}

上例中， ``Point`` 的两个参数类型相同，因此可以 ``T`` 可以省略。但当参数类型不同时，会报错： ::

    julia> Point(1,2.5)
    no method Point(Int64,Float64)

详见 :ref:`man-constructors` 。

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

