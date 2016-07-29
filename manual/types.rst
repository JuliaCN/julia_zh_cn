.. _man-types:

******
 类型
******

Julia 中，如果类型被省略，则值可以是任意类型。添加类型会显著提高性能和系统稳定性。

Julia `类型系统 <http://zh.wikipedia.org/zh-cn/%E9%A1%9E%E5%9E%8B%E7%B3%BB%E7%B5%B1>`_ 的特性是，具体类型不能作为具体类型的子类型，所有的具体类型都是最终的，它们可以拥有抽象类型作为父类型。其它高级特性有：

- 不区分对象和非对象值：Julia 中的所有值都是一个有类型的对象，这个类型
   属于一个单一、全连通类型图，图中的每个节点都是类型.
- 没有“编译时类型”：程序运行时仅有其实际类型，这在面向对象编程语言中被
   称为“运行时类型”.
- 值有类型，变量没有类型——变量仅仅是绑定了值的名字而已.
- 抽象类型和具体类型都可以被其它类型和值参数化.具体来讲, 参数化可以是
  符号, 可以是 `isbits` 返回值为 true 的类型任意值 (本质想是讲, 这些数
  像整数或者布尔值一样, 储存形式类似于 C 中的数据类型或者 struct, 并且
  没有指向其他数据的指针), 也可以是元组. 如果类型参数不需要被使用或者
  限制, 可以省略不写.


Julia的类型系统的设计旨在有效及具表现力，既清楚直观又不夸张。许多Julia程序员可能永远不会觉得有必要去明确地指出类型。然而某些程序会因声明类型变得更清晰，更简单，更迅速及健壮。

类型声明
--------

``::`` 运算符可以用来在程序中给表达式和变量附加类型注释。这样做有两个理由：

1. 作为断言，帮助确认程序是否正常运行
2. 给编译器提供额外类型信息，帮助提升性能

``::`` 运算符放在表示值的表达式之后时读作“前者是后者的实例”，它用来断言左侧表达式是否为右侧表达式的实例。如果右侧是具体类型，此类型应该是左侧的实例。如果右侧是抽象类型，左侧应是一个具体类型的实例的值，该具体类型是这个抽象类型的子类型。如果类型断言为假，将抛出异常，否则，返回左值：

.. doctest::

    julia> (1+2)::FloatingPoint
    ERROR: type: typeassert: expected FloatingPoint, got Int64

    julia> (1+2)::Int
    3

可以在任何表达式的所在位置做类型断言。``::``运算符最常见的用法就是用在函数定义中，来声明操作对象的类型，例如 ``f(x::Int8) = ...`` (详情请看
:ref:`man-methods`).

``::`` 运算符跟在表达式上下文中的 *变量名* 后时，它声明变量应该是某个类型，有点儿类似于 C 等静态语言中的类型声明。赋给这个变量的值会被 ``convert`` 函数转换为所声明的类型：

.. doctest:: foo-func

    julia> function foo()
             x::Int8 = 1000
             x
           end
    foo (generic function with 1 method)

    julia> foo()
    -24

    julia> typeof(ans)
    Int8

这个特性用于避免性能陷阱，即给一个变量赋值时意外更改了类型。

“声明”仅发生在特定的上下文中： ::

    x::Int8        # a variable by itself
    local x::Int8  # in a local declaration
    x::Int8 = 10   # as the left-hand side of an assignment

and applies to the whole current scope, even before the declaration.
Currently, type declarations cannot be used in global scope, e.g. in
the REPL, since Julia does not yet have constant-type globals.  Note
that in a function return statement, the first two of the above
expressions compute a value and then ``::`` is a type assertion and
not a declaration.

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

``<:`` 运算符意思为“前者是后者的子类型”，它声明右侧是左侧新声明类型的直接父类型。也可以用来判断左侧是不是右侧的子类型：

.. doctest::

    julia> Integer <: Number
    true

    julia> Integer <: FloatingPoint
    false

抽象类型的一个重要用途是为具体的类型提供默认实现. 举个简单的例子 ::

  function myplus(x, y)
      x + y
  endof

第一点需要注意的是, 上面的参数声明等效于 ``x::Any`` 和 ``y::Any``. 当
这个函数被调用时, 例如 ``myplus(2, 5)``, Julia 会首先查找参数类型匹配
的 ``myplus`` 函数. (关于多重分派的详细信息请参考下文.) 如果没有找到比
上面的函数更相关的函数, Julia 根据上面的通用函数定义并编译一个
``myplus`` 具体函数, 其参数为两个 Int 型变量, 也就是说, Julia 会定义并
编译 ::

  function myplus(x::Int, y::Int)
      x + y
  end

最后, 调用这个具体的函数.

因此, 程序员可以利用抽象类型编写通用的函数, 然后这个通用函数可以被许多
具体的类型组合调用. 也正是由于多重分派, 程序员可以精确的控制是调用更具
体的还是通用的函数.

需要注意的一点是, 编写面向抽象类型的函数并不会带来性能上的损失, 因为每
次调用函数时, 根据不同的参数组合, 函数总是要重新编译的. (然而, 如果参
数类型为包含抽象类型的容器是, 会有性能方面的问题; 参见下面的关于性能的
提示.)


位类型
------

位类型是具体类型，它的数据是由位构成的。整数和浮点数都是位类型。标准的位类型是用 Julia 语言本身定义的： ::

    bitstype 16 Float16 <: FloatingPoint
    bitstype 32 Float32 <: FloatingPoint
    bitstype 64 Float64 <: FloatingPoint

    bitstype 8  Bool <: Integer
    bitstype 32 Char <: Integer

    bitstype 8  Int8     <: Signed
    bitstype 8  Uint8    <: Unsigned
    bitstype 16 Int16    <: Signed
    bitstype 16 Uint16   <: Unsigned
    bitstype 32 Int32    <: Signed
    bitstype 32 Uint32   <: Unsigned
    bitstype 64 Int64    <: Signed
    bitstype 64 Uint64   <: Unsigned
    bitstype 128 Int128  <: Signed
    bitstype 128 Uint128 <: Unsigned

声明位类型的通用语法是： ::

    bitstype «bits» «name»
    bitstype «bits» «name» <: «supertype»

``«bits»`` 表明类型需要多少空间来存储，``«name»`` 为新类型的名字。目前，位类型的声明的位数只支持 8 的倍数，因此布尔类型也是 8 位的。

``Bool``, ``Int8`` 及 ``Uint8`` 类型的声明是完全相同的，都占用了 8 位内存，但它们是互相独立的。

.. _man-composite-types:

复合类型
--------

`复合类型 <http://zh.wikipedia.org/zh-cn/%E8%A4%87%E5%90%88%E5%9E%8B%E5%88%A5>`_ 也被称为记录、结构、或者对象。复合类型是变量名域的集合。它是 Julia 中最常用的自定义类型。在 Julia 中，所有的值都是对象，但函数并不与它们所操作的对象绑定。Julia 重载时，根据函数 *所有* 参数的类型，而不仅仅是第一个参数的类型，来选取调用哪个方法（详见 :ref:`man-methods` ）。

使用 ``type`` 关键字来定义复合类型：

.. doctest::

    julia> type Foo
             bar
             baz::Int
             qux::Float64
           end

构建复合类型 ``Foo`` 的对象：

.. doctest::

    julia> foo = Foo("Hello, world.", 23, 1.5)
    Foo("Hello, world.",23,1.5)

    julia> typeof(foo)
    Foo (constructor with 2 methods)

当一个类型像函数一样被调用时，它可以被叫做类型构造函数（*constructor*)。
每个类型有两种构造函数是自动被生成的（它们被叫做*默认构造函数*)。
第一种是当传给构造函数的参数和这个类型的字段类型不一一匹配时，构造函数会把它的参数传给 ``convert`` 函数，并且转换到这个类型相应的字段类型。
第二种是当传给构造函数的每个参数和这个类型的字段类型都一一相同时，构造函数直接生成类型。
要自动生成两种默认构造函数的原因是：为了防止用户在声明别的新变量的时候不小心把构造函数给覆盖掉。

由于没有约束 ``bar`` 的类型，它可以被赋任意值；但是 ``baz`` 必须能被转换为 ``Int`` ：

.. doctest::

    julia> Foo((), 23.5, 1)
    ERROR: InexactError()
     in Foo at no file

你可以用 ``names`` 这个函数来获取类型的所有字段。

.. doctest::

    julia> names(foo)
    3-element Array{Symbol,1}:
     :bar
     :baz
     :qux

获取复合对象域的值：

.. doctest::

    julia> foo.bar
    "Hello, world."

    julia> foo.baz
    23

    julia> foo.qux
    1.5

修改复合对象域的值：

.. doctest::

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

不可变复合类型
-------------------------

可以使用关键词 ``immutable`` 替代 ``type`` 来定义 *不可变* 复合类型：::

    immutable Complex
      real::Float64
      imag::Float64
    end

这种类型和其他复合类型类似，除了它们的实例不能被更改。不可变复合类型具有以下几种优势：

- 它们在一些情况下更高效。像上面``Complex``例子里的类型就被有效地封装到数组里，而且有些时候编译器能够避免完整地分配不可变对象。
- 不会与类型的构造函数提供的不变量冲突。
- 用不可变对象的代码不容易被侵入。

一个不可变对象可以包含可变对象，比如数组，域。那些被包含的可变对象仍然保持可变;只有不可变对象自己的域不能变得指向别的对象。

理解不可变复合变量的一个有用的办法是每个实例都是和特定域的值相关联的 --- 这些域的值就能告诉你关于这个对象的一切。相反地，一个可变的对象就如同一个小的容器可能包含了各种各样的值，所以它不能从它的域的值确定出这个对象。在决定是否把一个类型定义为不变的时候，先问问是否两个实例包含相同的域的值就被认为是相同，或者它们会独立地改变。如果它们被认为是相同的，那么这个类型就该被定义成不可变的。

再次强调下, Julia 中不可变类型有两个重要的特性:

- 不可变复合类型的数据在传递时会被拷贝 (在赋值时是这样, 在调用函数时也
  是这样), 相对的, 可变类型的数据是以引用的方式互相传递.
- 不可变复合类型内的域不可改变.

对于有着 C/C++ 背景的读者, 需要仔细想下为什么这两个特性是息息相关的.
设想下, 如果这两个特性是分开的, 也就是说, 如果数据在传递时是拷贝的, 然
而数据内部的变量可以被改变, 那么将很难界定某段代码的实际作用. 举个例子,
假设 ``x`` 是某个函数的参数, 同时假设函数改变了参数中的一个域:
``x.isprocessed = true``. 根据 ``x`` 是值传递或者引用传递, 在调用完函
数是, 原来 ``x`` 的值有可能没有改变, 也有可能改变. 为了防止出现这种不
确定效应, Julia 限定如果参数是值传递, 其内部域的值不可改变.

被声明类型
--------------

以上的三种类型是紧密相关的。它们有相同的特性：

- 明确地被声明
- 有名字
- 有明确的父类
- 可以有参数

正因有共有的特性，这些类型内在地表达为同一种概念的实例，``DataType``,是以下类型之一：

.. doctest::

    julia> typeof(Real)
    DataType

    julia> typeof(Int)
    DataType

``DataType`` 既可以抽象也可以具体。如果是具体的，它会拥有既定的大小，存储安排和（可选的）名域。
所以一个位类型是一个大小非零的 ``DataType``，但没有名域。一个复合类型是一个可能拥有名域也可以为空集(大小为零)的 ``DataType`` 。

在这个系统里的每一个具体的值都是某个 ``DataType`` 的实例，或者一个多元组。


多元组类型
----------

多元组的类型是类型的多元组：

.. doctest::

    julia> typeof((1,"foo",2.5))
    (Int64,ASCIIString,Float64)

类型多元组可以在任何需要类型的地方使用：

.. doctest::

    julia> (1,"foo",2.5) :: (Int64,String,Any)
    (1,"foo",2.5)

    julia> (1,"foo",2.5) :: (Int64,String,Float32)
    ERROR: type: typeassert: expected (Int64,String,Float32), got (Int64,ASCIIString,Float64)

如果类型多元组中有非类型出现，会报错：

.. doctest::

    julia> (1,"foo",2.5) :: (Int64,String,3)
    ERROR: type: typeassert: expected Type{T<:Top}, got (DataType,DataType,Int64)

注意，空多元组 ``()`` 的类型是其本身：

.. doctest::

    julia> typeof(())
    ()

.. Tuple types are *covariant* in their constituent types, which means
.. that one tuple type is a subtype of another if elements of the first
.. are subtypes of the corresponding elements of the second. For
.. example:
多元组类型是关于它的组成类型是 *协变* 的，一个多元组是另一个多元组的子类型
意味着对应的第一个多元组的各元素的类型是第二个多元组对应元素类型的子类型。比如:


.. doctest::

    julia> (Int,String) <: (Real,Any)
    true

    julia> (Int,String) <: (Real,Real)
    false

    julia> (Int,String) <: (Real,)
    false

.. @readproof
.. -function signature
.. Intuitively, this corresponds to the type of a function's arguments
.. being a subtype of the function's signature (when the signature matches).
直观地看，这就像一个函数的各个参数的类型必须是函数签名的子类型（当签名匹配的时候）。

类型共用体
----------

类型共用体是特殊的抽象类型，使用 ``Union`` 函数来声明： ::

    julia> IntOrString = Union(Int,String)
    Union(String,Int64)

    julia> 1 :: IntOrString
    1

    julia> "Hello!" :: IntOrString
    "Hello!"

    julia> 1.0 :: IntOrString
    ERROR: type: typeassert: expected Union(String,Int64), got Float64

不含任何类型的类型共用体，是“底”类型 ``None`` ：

.. doctest::

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

.. testsetup::

    abstract Pointy{T}
    type Point{T} <: Pointy{T}
      x::T
      y::T
    end

类型参数跟在类型名后，用花括号括起来： ::

    type Point{T}
      x::T
      y::T
    end

这个声明定义了新参数化类型 ``Point{T}`` ，它有两个 ``T`` 类型的“坐标轴”。参数化类型可以是任何类型（也可以是整数，此例中我们用的是类型）。具体类型 ``Point{Float64}`` 等价于将 ``Point`` 中的 ``T`` 替换为 ``Float64`` 后的类型。上例实际上声明了许多种类型： ``Point{Float64}``, ``Point{String}``, ``Point{Int64}`` 等等，因此，现在每个都是可以使用的具体类型：

.. doctest::

    julia> Point{Float64}
    Point{Float64} (constructor with 1 method)

    julia> Point{String}
    Point{String} (constructor with 1 method)

``Point`` 本身也是个有效的类型对象：

.. doctest::

    julia> Point
    Point{T} (constructor with 1 method)

``Point`` 在这儿是一个抽象类型，它包含所有如 ``Point{Float64}``, ``Point{String}`` 之类的具体实例：

.. doctest::

    julia> Point{Float64} <: Point
    true

    julia> Point{String} <: Point
    true

其它类型则不是其子类型：

.. doctest::

    julia> Float64 <: Point
    false

    julia> String <: Point
    false

``Point`` 不同 ``T`` 值所声明的具体类型之间，不能互相作为子类型：

.. doctest::

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

指明构造方法的类型参数：

.. doctest::

    julia> Point{Float64}(1.0,2.0)
    Point{Float64}(1.0,2.0)

    julia> typeof(ans)
    Point{Float64} (constructor with 1 method)

参数个数应与构造函数相匹配：

.. doctest::

    julia> Point{Float64}(1.0)
    ERROR: no method Point{Float64}(Float64)

    julia> Point{Float64}(1.0,2.0,3.0)
    ERROR: no method Point{Float64}(Float64, Float64, Float64)

对于带有类型参数的类型，因为重载构造函数是不可能的，所以只有一种默认构造函数被自动生成——这个构造函数接受任何参数并且把们转换成对应的字段类型并赋值

大多数情况下不需要提供 ``Point`` 对象的类型，它可由参数类型来提供信息。因此，可以不提供 ``T`` 的值：

.. doctest::

    julia> Point(1.0,2.0)
    Point{Float64}(1.0,2.0)

    julia> typeof(ans)
    Point{Float64} (constructor with 1 method)

    julia> Point(1,2)
    Point{Int64}(1,2)

    julia> typeof(ans)
    Point{Int64} (constructor with 1 method)

上例中， ``Point`` 的两个参数类型相同，因此 ``T`` 可以省略。但当参数类型不同时，会报错：

.. doctest::

    julia> Point(1,2.5)
    ERROR: `Point{T}` has no method matching Point{T}(::Int64, ::Float64)

这种情况其实也可以处理，详见 :ref:`man-constructors` 。

参数化抽象类型
~~~~~~~~~~~~~~

类似地，参数化抽象类型声明一个抽象类型的集合： ::

    abstract Pointy{T}

对每个类型或整数值 ``T`` ， ``Pointy{T}`` 都是一个不同的抽象类型。 ``Pointy`` 的每个实例都是它的子类型：

.. doctest::

    julia> Pointy{Int64} <: Pointy
    true

    julia> Pointy{1} <: Pointy
    true

参数化抽象类型也是不相关的：

.. doctest::

    julia> Pointy{Float64} <: Pointy{Real}
    false

    julia> Pointy{Real} <: Pointy{Float64}
    false

可以如下声明 ``Point{T}`` 是 ``Pointy{T}`` 的子类型： ::

    type Point{T} <: Pointy{T}
      x::T
      y::T
    end

对每个 ``T`` ，都有 ``Point{T}`` 是 ``Pointy{T}`` 的子类型：

.. doctest::

    julia> Point{Float64} <: Pointy{Float64}
    true

    julia> Point{Real} <: Pointy{Real}
    true

    julia> Point{String} <: Pointy{String}
    true

它们仍然是不相关的：

.. doctest::

    julia> Point{Float64} <: Pointy{Real}
    false

参数化抽象类型 ``Pointy`` 有什么用呢？假设我们要构造一个坐标点的实现，点都在对角线 *x = y* 上，因此我们只需要一个坐标轴： ::

    type DiagPoint{T} <: Pointy{T}
      x::T
    end

``Point{Float64}`` 和 ``DiagPoint{Float64}`` 都是 ``Pointy{Float64}`` 抽象类型的实现，这对其它可选类型 ``T`` 也一样。 ``Pointy`` 可以作为它的子类型的公共接口。有关方法和重载，详见下一节 :ref:`man-methods` 。

有时需要对 ``T`` 的范围做限制： ::

    abstract Pointy{T<:Real}

此时， ``T`` 只能是 ``Real`` 的子类型：

.. testsetup:: real-pointy

    abstract Pointy{T<:Real}

.. doctest:: real-pointy

    julia> Pointy{Float64}
    Pointy{Float64}

    julia> Pointy{Real}
    Pointy{Real}

    julia> Pointy{String}
    ERROR: type: Pointy: in T, expected T<:Real, got Type{String}

    julia> Pointy{1}
    ERROR: type: Pointy: in T, expected T<:Real, got Int64

参数化复合类型的类型参数，也可以同样被限制： ::

    type Point{T<:Real} <: Pointy{T}
      x::T
      y::T
    end

下面是 Julia 的 ``Rational`` 的 immutable 类型是如何定义的，这个类型表示分数： ::

    immutable Rational{T<:Integer} <: Real
      num::T
      den::T
    end

.. _man-singleton-types:

单态类型
^^^^^^^^

单态类型是一种特殊的抽象参数化类型。对每个类型 ``T`` ，抽象类型“单态” ``Type{T}`` 的实例为对象 ``T`` 。来看些例子：

.. doctest::

    julia> isa(Float64, Type{Float64})
    true

    julia> isa(Real, Type{Float64})
    false

    julia> isa(Real, Type{Real})
    true

    julia> isa(Float64, Type{Real})
    false

换句话说，仅当 ``A`` 和 ``B`` 是同一个对象，且此对象是类型时， ``isa(A,Type{B})`` 才返回真。没有参数时， ``Type`` 仅是抽象类型，所有的类型都是它的实例，包括单态类型：

.. doctest::

    julia> isa(Type{Float64},Type)
    true

    julia> isa(Float64,Type)
    true

    julia> isa(Real,Type)
    true

只有对象是类型时，才是 ``Type`` 的实例：

.. doctest::

    julia> isa(1,Type)
    false

    julia> isa("foo",Type)
    false

Julia 中只有类型对象才有单态类型。

参数化位类型
~~~~~~~~~~~~

可以参数化地声明位类型。例如，Julia 中指针被定义为位类型： ::

    # 32-bit system:
    bitstype 32 Ptr{T}

    # 64-bit system:
    bitstype 64 Ptr{T}

这儿的参数类型 ``T`` 不是用来做类型定义，而是个抽象标签，它定义了一组结构相同的类型，这些类型仅能由类型参数来区分。尽管 ``Ptr{Float64}`` 和 ``Ptr{Int64}`` 的表示是一样的，它们是不同的类型。所有的特定指针类型，都是 ``Ptr`` 类型的子类型：

.. doctest::

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

对参数化类型， ``typealias`` 提供了简单的参数化类型名。Julia 的数组类型为 ``Array{T,n}`` ，其中 ``T`` 是元素类型， ``n`` 是数组维度的数值。为简单起见， ``Array{Float64}`` 可以只指明元素类型而不需指明维度：

.. doctest::

    julia> Array{Float64,1} <: Array{Float64} <: Array
    true

``Vector`` 和 ``Matrix`` 对象是如下定义的： ::

    typealias Vector{T} Array{T,1}
    typealias Matrix{T} Array{T,2}

类型运算
--------

Julia 中，类型本身也是对象，可以对其使用普通的函数。如 ``<:`` 运算符，可以判断左侧是否是右侧的子类型。

``isa`` 函数检测对象是否属于某个指定的类型：

.. doctest::

    julia> isa(1,Int)
    true

    julia> isa(1,FloatingPoint)
    false

``typeof`` 函数返回参数的类型。类型也是对象，因此它也有类型：

.. doctest::

    julia> typeof(Rational)
    DataType

    julia> typeof(Union(Real,Float64,Rational))
    DataType

    julia> typeof((Rational,None))
    (DataType,UnionType)

类型的类型是什么？它们的类型是 ``DataType`` ：

.. doctest::

    julia> typeof(DataType)
    DataType

    julia> typeof(UnionType)
    DataType

读者也许会注意到， ``DataType`` 类似于空多元组（详见 `上文 <#tuple-types>`_ ）。因此，递归使用 ``()`` 和 ``DataType`` 所组成的多元组的类型，是该类型本身：

.. doctest::

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

``super`` 可以指明一些类型的父类型。只有声明的类型(``DataType``)才有父类型：

.. doctest::

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
    ERROR: `super` has no method matching super(::Type{Union(Float64,Int64)})

    julia> super(None)
    ERROR: `super` has no method matching super(::Type{None})

    julia> super((Float64,Int64))
    ERROR: `super` has no method matching super(::Type{(Float64,Int64)})
