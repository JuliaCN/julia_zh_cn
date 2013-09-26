.. _man-types:

******
 类型
******

Julia 中，如果类型被省略，则值可以是任意类型。添加类型会显著提高性能和系统稳定性。

Julia `类型系统 <http://zh.wikipedia.org/zh-cn/%E9%A1%9E%E5%9E%8B%E7%B3%BB%E7%B5%B1>`_ 的特性是，具体类型不能作为具体类型的子类型，所有的具体类型都是最终的，它们可以拥有抽象类型作为父类型。其它高级特性有：

-  不区分对象和非对象值：Julia 中的所有值都是一个有类型的对象，这个类型属于一个单一、全连通类型图，图中的每个节点都是类型
-  没有“编译时类型”：程序运行时仅有其实际类型，这在面向对象编程语言中被称为“运行时类型”
-  值有类型，变量没有类型——变量仅仅是绑定了值的名字而已
-  抽象类型和具体类型都可以被其它类型和值（目前是整数和符号）参数化


Julia's type system is designed to be powerful and expressive, yet
clear, intuitive and unobtrusive. Many Julia programmers may never feel
the need to write code that explicitly uses types. Some kinds of
programming, however, become clearer, simpler, faster and more robust
with declared types.

类型声明
--------

``::`` 运算符可以用来在程序中给表达式和变量附加类型注释。这样做有两个理由：

1. 作为断言，帮助确认程序是否正常运行
2. 给编译器提供额外类型信息，帮助提升性能

``::`` 运算符读作“前者是后者的实例”，它用来断言左侧表达式是否为右侧表达式的实例。如果右侧是具体类型，此类型应该是左侧的实例。如果右侧是抽象类型，左侧应是一个具体类型的实例的值，该具体类型是这个抽象类型的子类型。如果类型断言为假，将抛出异常，否则，返回左值::

    julia> (1+2)::FloatingPoint
    ERROR: type: typeassert: expected FloatingPoint, got Int64

    julia> (1+2)::Int
    3

可以在任何表达式的所在位置做类型断言。

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

    x::Int8        # a variable by itself
    local x::Int8  # in a local declaration
    x::Int8 = 10   # as the left-hand side of an assignment

在值的上下文，如 ``f(x::Int8)`` 中， ``::`` 是类型断言而不是声明。现在还不能在全局作用域或 REPL 中做这种声明，因为 Julia 现在还没有常量类型的全局变量。

.. _man-abstract-types:

抽象类型
--------

抽象类型不能被实例化，它组织了类型等级关系，方便程序员编程。如，编程时可针对任意整数类型，而不需指明是哪种具体的整数类型。

使用 ``abstract`` 关键字声明抽象类型： ::

    abstract «name»
    abstract «name» <: «supertype»

``abstract`` 关键字引入了新的抽象类型，类型名为 ``«name»`` 。类型名后可跟 ``<:`` 及已存在的类型，表明新声明的抽象类型是这个“父”类型的子类型。

如果没有指明父类型，则父类型默认为 ``Any`` ——所有对象和类型都是这个抽象类型的子类型。在类型理论中， ``Any`` 位于类型图的顶峰，被称为“顶”。Julia 也有预定义的抽象“底”类型，它位于类型图的最底处，被称为 ``None`` 。 ``None``与 ``Any`` 对立：任何对象都不是 ``None`` 的实例，所有的类型都是 ``None`` 的父类型。

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

``«bits»`` 表明类型需要多少空间来存储，``«name»`` 为新类型的名字。目前，位类型的声明的位数只支持 8 的倍数，因此布尔类型也是 8 位的。

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

由于没有约束 ``bar`` 的类型，它可以被赋任意值； ``baz`` 则必须是 ``Int`` ， ``qux`` 必须是 ``Float64`` 。参数必须与构造类型签名 ``(Any,Int,Float64)`` 相匹配： ::

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

``is`` 函数验证 ``NoFields`` 的“两个”实例是否为同一个。有关单态类型， `后面 <#man-singleton-types>`_ 会详细讲。

有关复合类型如何实例化，需要 `参数化类型 <#man-parametric-types>`_ 和 :ref:`man-methods` 这两个背景知识。将在 :ref:`man-constructors` 中详细介绍构造实例。

.. _man-immutable-composite-types:

Immutable Composite Types
-------------------------

可以使用关键词 ``immutable`` 替代 ``type`` 来定义 *不可变* 复合类型：::

    immutable Complex
      real::Float64
      imag::Float64
    end

Such types behave much like other composite types, except that instances
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
little container that might hold different values over time, and so is
not identified with specific field values. In deciding whether to make a
type immutable, ask whether two instances with the same field values
would be considered identical, or if they might need to change independently
over time. If they would be considered identical, the type should probably
be immutable.

Declared Types
--------------

The three kinds of types discussed in the previous three sections
are actually all closely related. They share the same key properties:

- They are explicitly declared.
- They have names.
- They have explicitly declared supertypes.
- They may have parameters.

Because of these shared properties, these types are internally
represented as instances of the same concept, ``DataType``, which
is the type of any of these types::

    julia> typeof(Real)
    DataType

    julia> typeof(Int)
    DataType

A ``DataType`` may be abstract or concrete. If it is concrete, it
has a specified size, storage layout, and (optionally) field names.
Thus a bits type is a ``DataType`` with nonzero size, but no field
names. A composite type is a ``DataType`` that has field names or
is empty (zero size).

Every concrete value in the system is either an instance of some
``DataType``, or is a tuple.

多元组类型
----------

多元组的类型是类型的多元组： ::

    julia> typeof((1,"foo",2.5))
    (Int64,ASCIIString,Float64)

类型多元组可以在任何需要类型的地方使用： ::

    julia> (1,"foo",2.5) :: (Int64,String,Any)
    (1,"foo",2.5)

    julia> (1,"foo",2.5) :: (Int64,String,Float32)
    ERROR: type: typeassert: expected (Int64,String,Float32), got (Int64,ASCIIString,Float64)

如果类型多元组中有非类型出现，会报错： ::

    julia> (1,"foo",2.5) :: (Int64,String,3)
    ERROR: type: typeassert: expected Type{T<:Top}, got (DataType,DataType,Int64)

注意，空多元组 ``()`` 的类型是其本身： ::

    julia> typeof(())
    ()

Tuple types are *covariant* in their constituent types, which means
that one tuple type is a subtype of another if elements of the first
are subtypes of the corresponding elements of the second. For
example::

    julia> (Int,String) <: (Real,Any)
    true

    julia> (Int,String) <: (Real,Real)
    false

    julia> (Int,String) <: (Real,)
    false

Intuitively, this corresponds to the type of a function's arguments
being a subtype of the function's signature (when the signature matches).

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

抽象类型 ``None`` 是所有其它类型的子类型，且没有实例。零参的 ``Union`` 调用，将返回无实例的类型 ``None`` 。

.. _man-parametric-types:

参数化类型
----------

Julia 的类型系统支持参数化：类型可以引入参数，这样类型声明为每种可能的参数组合声明一个新类型。

所有被声明的类型（ ``DataType`` 的变体）都可以使用同样的语法来参数化。我们将按照如下顺序来讨论：参数化符合类型、参数化抽象类型、参数化位类型。

参数化复合类型
~~~~~~~~~~~~~~

类型参数跟在类型名后，用花括号括起来： ::

    type Point{T}
      x::T
      y::T
    end

这个声明定义了新参数化类型 ``Point{T}`` ，它有两个 ``T`` 类型的“坐标轴”。参数化类型可以是任何类型（也可以是整数，此例中我们用的是类型）。具体类型 ``Point{Float64}`` 等价于将 ``Point`` 中的 ``T`` 替换为 ``Float64`` 后的类型。上例实际上声明了许多种类型： ``Point{Float64}``, ``Point{String}``, ``Point{Int64}`` 等等，因此，现在每个都是可以使用的具体类型： ::

    julia> Point{Float64}
    Point{Float64}

    julia> Point{String}
    Point{String}

``Point`` 本身也是个有效的类型对象： ::

    julia> Point
    Point{T}

``Point`` 在这儿是一个抽象类型，它包含所有如 ``Point{Float64}``, ``Point{String}`` 之类的具体实例： ::

    julia> Point{Float64} <: Point
    true

    julia> Point{String} <: Point
    true

其它类型则不是其子类型： ::

    julia> Float64 <: Point
    false

    julia> String <: Point
    false

``Point`` 不同 ``T`` 值所声明的具体类型之间，不能互相作为子类型： ::

    julia> Point{Float64} <: Point{Int64}
    false

    julia> Point{Float64} <: Point{Real}
    false

这一点非常重要：

    **虽然** ``Float64 <: Real`` **，但** ``Point{Float64} <: Point{Real}`` **不成立！**

换句话说，Julia 的类型参数是 *不相关* 的。尽管 ``Point{Float64}`` 的实例按照概念来说，应该是 ``Point{Real}`` 的实例，但两者在内存中的表示上有区别：

-  ``Point{Float64}`` 的实例可以简便、有效地表示 64 位数对儿
-  ``Point{Real}`` 的实例可以表示任意 ``Real`` 实例的数对儿。由于 ``Real`` 的实例可以为任意大小、任意结构，因此 ``Point{Real}`` 实际上表示指向 ``Real`` 对象的指针对儿

上述区别在数组中更明显： ``Array{Float64}`` 可以在一块连续内存中存储 64 位浮点数，而 ``Array{Real}`` 则保存指向每个 ``Real`` 对象的指针数组。而每个 ``Real`` 对象的大小，可能比 64 位浮点数的大。

:ref:`man-constructors` 中将介绍如何给复合类型自定义构造方法，但如果没有特殊构造声明时，默认有两种构造新复合对象的方法：一种是明确指明构造方法的类型参数；另一种是由对象构造方法的参数来隐含类型参数。

指明构造方法的类型参数： ::

    julia> Point{Float64}(1.0,2.0)
    Point(1.0,2.0)

    julia> typeof(ans)
    Point{Float64}

参数个数应与构造函数相匹配： ::

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

这种情况其实也可以处理，详见 :ref:`man-constructors` 。

Parametric Abstract Types
~~~~~~~~~~~~~~~~~~~~~~~~~

Parametric abstract type declarations declare a collection of abstract
types, in much the same way::

    abstract Pointy{T}

With this declaration, ``Pointy{T}`` is a distinct abstract type for
each type or integer value of ``T``. As with parametric composite types,
each such instance is a subtype of ``Pointy``::

    julia> Pointy{Int64} <: Pointy
    true

    julia> Pointy{1} <: Pointy
    true

Parametric abstract types are invariant, much as parametric composite
types are::

    julia> Pointy{Float64} <: Pointy{Real}
    false

    julia> Pointy{Real} <: Pointy{Float64}
    false

Much as plain old abstract types serve to create a useful hierarchy of
types over concrete types, parametric abstract types serve the same
purpose with respect to parametric composite types. We could, for
example, have declared ``Point{T}`` to be a subtype of ``Pointy{T}`` as
follows::

    type Point{T} <: Pointy{T}
      x::T
      y::T
    end

Given such a declaration, for each choice of ``T``, we have ``Point{T}``
as a subtype of ``Pointy{T}``::

    julia> Point{Float64} <: Pointy{Float64}
    true

    julia> Point{Real} <: Pointy{Real}
    true

    julia> Point{String} <: Pointy{String}
    true

This relationship is also invariant::

    julia> Point{Float64} <: Pointy{Real}
    false

What purpose do parametric abstract types like ``Pointy`` serve?
Consider if we create a point-like implementation that only requires a
single coordinate because the point is on the diagonal line *x = y*::

    type DiagPoint{T} <: Pointy{T}
      x::T
    end

Now both ``Point{Float64}`` and ``DiagPoint{Float64}`` are
implementations of the ``Pointy{Float64}`` abstraction, and similarly
for every other possible choice of type ``T``. This allows programming
to a common interface shared by all ``Pointy`` objects, implemented for
both ``Point`` and ``DiagPoint``. This cannot be fully demonstrated,
however, until we have introduced methods and dispatch in the next
section, :ref:`man-methods`.

There are situations where it may not make sense for type parameters to
range freely over all possible types. In such situations, one can
constrain the range of ``T`` like so::

    abstract Pointy{T<:Real}

With such a declaration, it is acceptable to use any type that is a
subtype of ``Real`` in place of ``T``, but not types that are not
subtypes of ``Real``::

    julia> Pointy{Float64}
    Pointy{Float64}

    julia> Pointy{Real}
    Pointy{Real}

    julia> Pointy{String}
    ERROR: type: Pointy: in T, expected Real, got Type{String}

    julia> Pointy{1}
    ERROR: type: Pointy: in T, expected Real, got Int64

Type parameters for parametric composite types can be restricted in the
same manner::

    type Point{T<:Real} <: Pointy{T}
      x::T
      y::T
    end

To give a couple of real-world examples of how all this parametric type
machinery can be useful, here is the actual definition of Julia's
``Rational`` type, representing an exact ratio of integers::

    type Rational{T<:Integer} <: Real
      num::T
      den::T
    end

It only makes sense to take ratios of integer values, so the parameter
type ``T`` is restricted to being a subtype of ``Integer``, and a ratio
of integers represents a value on the real number line, so any
``Rational`` is an instance of the ``Real`` abstraction.

.. _man-singleton-types:

Singleton Types
^^^^^^^^^^^^^^^

There is a special kind of abstract parametric type that must be
mentioned here: singleton types. For each type, ``T``, the "singleton
type" ``Type{T}`` is an abstract type whose only instance is the object
``T``. Since the definition is a little difficult to parse, let's look
at some examples::

    julia> isa(Float64, Type{Float64})
    true

    julia> isa(Real, Type{Float64})
    false

    julia> isa(Real, Type{Real})
    true

    julia> isa(Float64, Type{Real})
    false

In other words, ``isa(A,Type{B})`` is true if and only if ``A`` and
``B`` are the same object and that object is a type. Without the
parameter, ``Type`` is simply an abstract type which has all type
objects as its instances, including, of course, singleton types::

    julia> isa(Type{Float64},Type)
    true

    julia> isa(Float64,Type)
    true

    julia> isa(Real,Type)
    true

Any object that is not a type is not an instance of ``Type``::

    julia> isa(1,Type)
    false

    julia> isa("foo",Type)
    false

Until we discuss :ref:`man-parametric-methods`
and :ref:`conversions <man-conversion>`, it is
difficult to explain the utility of the singleton type construct, but in
short, it allows one to specialize function behavior on specific type
*values*. This is useful for writing
methods (especially parametric ones) whose behavior depends on a type
that is given as an explicit argument rather than implied by the type of
one of its arguments.

A few popular languages have singleton types, including Haskell, Scala
and Ruby. In general usage, the term "singleton type" refers to a type
whose only instance is a single value. This meaning applies to Julia's
singleton types, but with that caveat that only type objects have
singleton types.

Parametric Bits Types
~~~~~~~~~~~~~~~~~~~~~

Bits types can also be declared parametrically. For example, pointers
are represented as boxed bits types which would be declared in Julia
like this::

    # 32-bit system:
    bitstype 32 Ptr{T}

    # 64-bit system:
    bitstype 64 Ptr{T}

The slightly odd feature of these declarations as compared to typical
parametric composite types, is that the type parameter ``T`` is not used
in the definition of the type itself — it is just an abstract tag,
essentially defining an entire family of types with identical structure,
differentiated only by their type parameter. Thus, ``Ptr{Float64}`` and
``Ptr{Int64}`` are distinct types, even though they have identical
representations. And of course, all specific pointer types are subtype
of the umbrella ``Ptr`` type::

    julia> Ptr{Float64} <: Ptr
    true

    julia> Ptr{Int64} <: Ptr
    true

Type Aliases
------------

Sometimes it is convenient to introduce a new name for an already
expressible type. For such occasions, Julia provides the ``typealias``
mechanism. For example, ``Uint`` is type aliased to either ``Uint32`` or
``Uint64`` as is appropriate for the size of pointers on the system::

    # 32-bit system:
    julia> Uint
    Uint32

    # 64-bit system:
    julia> Uint
    Uint64

This is accomplished via the following code in ``base/boot.jl``::

    if is(Int,Int64)
        typealias Uint Uint64
    else
        typealias Uint Uint32
    end

Of course, this depends on what ``Int`` is aliased to — but that is
pre-defined to be the correct type — either ``Int32`` or ``Int64``.

For parametric types, ``typealias`` can be convenient for providing
names for cases where some of the parameter choices are fixed.
Julia's arrays have type ``Array{T,N}`` where ``T`` is the element type
and ``N`` is the number of array dimensions. For convenience, writing
``Array{Float64}`` allows one to specify the element type without
specifying the dimension::

    julia> Array{Float64,1} <: Array{Float64} <: Array
    true

However, there is no way to equally simply restrict just the dimension
but not the element type. Yet, one often needs to ensure an object
is a vector or a matrix (imposing restrictions on the number of dimensions).
For that reason, the following type aliases are provided::

    typealias Vector{T} Array{T,1}
    typealias Matrix{T} Array{T,2}

Writing ``Vector{Float64}`` is equivalent to writing
``Array{Float64,1}``, and the umbrella type ``Vector`` has as instances
all ``Array`` objects where the second parameter — the number of array
dimensions — is 1, regardless of what the element type is. In languages
where parametric types must always be specified in full, this is not
especially helpful, but in Julia, this allows one to write just
``Matrix`` for the abstract type including all two-dimensional dense
arrays of any element type.

Operations on Types
-------------------

Since types in Julia are themselves objects, ordinary functions can
operate on them. Some functions that are particularly useful for working
with or exploring types have already been introduced, such as the ``<:``
operator, which indicates whether its left hand operand is a subtype of
its right hand operand.

The ``isa`` function tests if an object is of a given type and returns
true or false::

    julia> isa(1,Int)
    true

    julia> isa(1,FloatingPoint)
    false

The ``typeof`` function, already used throughout the manual in examples,
returns the type of its argument. Since, as noted above, types are
objects, they also have types, and we can ask what their types are::

    julia> typeof(Rational)
    DataType

    julia> typeof(Union(Real,Float64,Rational))
    UnionType

    julia> typeof((Rational,None))
    (DataType,UnionType)

What if we repeat the process? What is the type of a type of a type?
As it happens, types are all composite values and thus all have a type of
``DataType``::

    julia> typeof(DataType)
    DataType

    julia> typeof(UnionType)
    DataType

The reader may note that ``DataType`` shares with the empty tuple
(see `above <#tuple-types>`_), the distinction of being its own type
(i.e. a fixed point of the ``typeof`` function). This leaves any number
of tuple types recursively built with ``()`` and ``DataType`` as
their only atomic values, which are their own type::

    julia> typeof(())
    ()

    julia> typeof(DataType)
    DataType

    julia> typeof(((),))
    ((),)

    julia> typeof((DataType,))
    (DataType,)

    julia> typeof(((),DataType))
    ((),DataType)

All fixed points of the ``typeof`` function are like this.

Another operation that applies to some types is ``super``, which
reveals a type's supertype.
Only declared types (``DataType``) have unambiguous supertypes::

    julia> super(Float64)
    FloatingPoint

    julia> super(Number)
    Any

    julia> super(String)
    Any

    julia> super(Any)
    Any

If you apply ``super`` to other type objects (or non-type objects), a
"no method" error is raised::

    julia> super(Union(Float64,Int64))
    no method super(UnionType,)

    julia> super(None)
    no method super(UnionType,)

    julia> super((Float64,Int64))
    no method super((DataType,DataType),)
