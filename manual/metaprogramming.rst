.. _man-metaprogramming:

********
 元编程
********

类似 Lisp ， Julia 也是 `同像性 <http://en.wikipedia.org/wiki/Homoiconicity>`_ 的：它 自身的代码也是语言本身的数据结构。由于代码是由这门语言本身所构造和处理的对象所表示的，因此程序也可以转换并生成自身语言的代码。元编程的另一个功能是反射，它可以在程序运行时动态展现程序本身的特性。

表达式和求值
------------

Julia 代码表示为由 Julia 的 ``Expr`` 类型的数据结构而构成的语法树。下面是 ``Expr`` 类型的定义： ::

    type Expr
      head::Symbol
      args::Array{Any,1}
      typ
    end

``head`` 是标明表达式种类的符号； ``args`` 是子表达式数组，它可能是求值时引用变量值的符号，也可能是嵌套的 ``Expr`` 对象，还可能是真实的对象值。 ``typ`` 域被类型推断用来做类型注释，通常可以被忽略。

有两种“引用”代码的方法，它们可以简单地构造表达式对象，而不需要显式构造 ``Expr`` 对象。第一种是内联表达式，使用 ``:`` ，后面跟单表达式；第二种是代码块儿，放在 ``quote ... end`` 内部。下例是第一种方法，引用一个算术表达式： ::

    julia> ex = :(a+b*c+1)
    +(a,*(b,c),1)

    julia> typeof(ex)
    Expr

    julia> ex.head
    call

    julia> typeof(ans)
    Symbol

    julia> ex.args
    4-element Any Array:
      +        
      a        
      :(*(b,c))
     1         

    julia> typeof(ex.args[1])
    Symbol

    julia> typeof(ex.args[2])
    Symbol

    julia> typeof(ex.args[3])
    Expr

    julia> typeof(ex.args[4])
    Int64

下例是第二种方法： ::

    julia> quote
         x = 1
         y = 2
         x + y
       end

    begin
      x = 1
      y = 2
      +(x,y)
    end

Symbols
~~~~~~~

``:`` 的参数为符号时，结果为 ``Symbol`` 对象，而不是 ``Expr`` ： ::

    julia> :foo
    foo

    julia> typeof(ans)
    Symbol

在表达式的上下文中，符号用来指示对变量的读取。当表达式被求值时，符号的值受限于符号的作用域（详见 :ref:`man-variables-and-scoping` ）。

有时, 为了防止解析时产生歧义， ``:`` 的参数需要添加额外的括号： ::

    julia> :(:)
    :(:)

    julia> :(::)
    :(::)

``Symbol`` 也可以使用 ``symbol`` 函数来创建，参数为一个字符或者字符串： ::

    julia> symbol('\'')
    :'

    julia> symbol("'")
    :'

求值和内插
~~~~~~~~~~

指定一个表达式，Julia 可以使用 ``eval`` 函数在 *顶层* 作用域对其求值。这有点儿像在交互式会话中载入文件或输入命令： ::

    julia> :(1 + 2)
    +(1,2)

    julia> eval(ans)
    3

    julia> ex = :(a + b)
    +(a,b)

    julia> eval(ex)
    a not defined

    julia> a = 1; b = 2;

    julia> eval(ex)
    3

传递给 ``eval`` 的表达式可以不仅返回值，也可以带有改变顶层求值环境状态的副作用： ::

    julia> ex = :(x = 1)
    x = 1

    julia> x
    x not defined

    julia> eval(ex)
    1

    julia> x
    1

表达式仅仅是一个 ``Expr`` 对象，它可以通过编程构造，然后对其求值： ::

    julia> a = 1;

    julia> ex = Expr(:call, :+,a,:b)
    :(+(1,b))

    julia> a = 0; b = 2;

    julia> eval(ex)
    3

注意上例中 ``a`` 与 ``b`` 使用时的区别：

-  表达式构造时，直接使用 *变量* ``a`` 的值。因此，对表达式求值时 ``a`` 的值没有任何影响：表达式中的值为 ``1`` ，与现在 ``a`` 的值无关
-  表达式构造时，使用的是 *符号* ``:b`` 。因此，构造时变量 ``b`` 的值是无关的—— ``:b`` 仅仅是个符号，此时变量 ``b`` 还未定义。对表达式求值时，通过查询变量 ``b`` 的值来解析符号 ``:b`` 的值

这样构造 ``Expr`` 对象太丑了。Julia 允许对表达式对象内插。因此上例可写为： ::

    julia> a = 1;
    1

    julia> ex = :($a + b)
    :(+(1,b))

编译器自动将这个语法翻译成上面带 ``Expr`` 的语法。

代码生成
~~~~~~~~

Julia 使用表达式内插和求值来生成重复的代码。下例定义了一组操作三个参数的运算符： ::

    for op = (:+, :*, :&, :|, :$)
      eval(quote
        ($op)(a,b,c) = ($op)(($op)(a,b),c)
      end)
    end

上例可用 ``:`` 前缀引用格式写的更精简： ::

    for op = (:+, :*, :&, :|, :$)
      eval(:(($op)(a,b,c) = ($op)(($op)(a,b),c)))
    end

使用 ``eval(quote(...))`` 模式进行语言内的代码生成，这种方式太常见了。Julia 用宏来简写这个模式： ::

    for op = (:+, :*, :&, :|, :$)
      @eval ($op)(a,b,c) = ($op)(($op)(a,b),c)
    end

``@eval`` 宏重写了这个调用，使得代码更精简。 ``@eval`` 的参数也可以是块代码： ::

    @eval begin
      # multiple lines
    end

对非引用表达式进行内插，会引发编译时错误： ::

    julia> $a + b
    unsupported or misplaced expression $

.. _man-macros:

Macros
------

宏
--

宏有点儿像编译时的表达式生成函数：它允许程序员，通过把零参或多个参数的表达式转换为单个结果表达式，来自动生成表达式。调用宏的语法为： ::

    @name expr1 expr2 ...
    @name(expr1, expr2, ...)

注意，宏名前有 ``@`` 符号。第一种形式，参数表达式之间没有逗号；第二种形式，宏名后没有空格。这两种形式不要记混。例如，下面的写法的结果就与上例不同，它只向宏传递了一个参数，此参数为多元组 ``(expr1, expr2, ...)`` ：  ::

    @name (expr1, expr2, ...)

程序运行前， ``name`` 展开函数会对表达式参数处理，用结果替代这个表达式。使用关键字 ``macro`` 来定义展开函数： ::

    macro name(expr1, expr2, ...)
        ...
    end

下例是 Julia 中 ``@assert`` 宏的定义（详见 `error.jl <https://github.com/JuliaLang/julia/blob/master/base/error.jl>`_ ）： ::

    macro assert(ex)
        :($ex ? nothing : error("Assertion failed: ", $(string(ex))))
    end

这个宏可如下使用： ::

    julia> @assert 1==1.0

    julia> @assert 1==0
    Assertion failed: 1==0

宏调用时被展开，因此上面调用等价于： ::

    1==1.0 ? nothing : error("Assertion failed: ", "1==1.0")
    1==0 ? nothing : error("Assertion failed: ", "1==0")

上例没法写成函数，因为只知道结果 *值* ，不知道要求值的表达式是什么。

``@assert`` 的例子也演示了如何在宏中使用 ``@quote`` 块儿。这种特性允许我们在宏内部方便地操作表达式。

卫生宏
~~~~~~

`卫生宏 <http://en.wikipedia.org/wiki/Hygienic_macro>`_ 是个更复杂的宏。Julia 需要确保宏引入和使用的变量不会与代码内插进宏的变量冲突。宏也可能在不是它所定义的模块中被调用。我们需要确保所有的全局变量都解析到正确的模块中。

来看一下 ``@time`` 宏，它的参数是一个表达式。它先记录下时间，运行表达式，再记录下时间，打印出这两次之间的时间差，它的最终值是表达式的值： ::

    macro time(ex)
      quote
        local t0 = time()
        local val = $ex
        local t1 = time()
        println("elapsed time: ", t1-t0, " seconds")
        val
      end
    end

``t0``, ``t1``, 及 ``val`` 应为私有临时变量，而 ``time`` 是标准库中的 ``time`` 函数，而不是用户可能使用的某个叫 ``time`` 的变量（ ``println`` 函数也如此）。

Julia 宏展开机制是这样解决命名冲突的。首先，宏结果的变量被分类为本地变量或全局变量。如果变量被赋值（且未被声明为全局变量）、被声明为本地变量、或被用作函数参数名，则它被认为是本地变量；否则，它被认为是全局变量。本地变量被重命名为一个独一无二的名字（使用 ``gensym`` 函数产生新符号），全局变量被解析到宏定义环境中。

但还有个问题没解决。考虑下例： ::

    module MyModule
    import Base.@time

    time() = ... # compute something

    @time time()
    end

此例中， ``ex`` 是对 ``time`` 的调用，但它并不是宏使用的 ``time`` 函数。它实际指向的是 ``MyModule.time`` 。因此我们应对要解析到宏调用环境中的 ``ex`` 代码做修改。这是通过 ``esc`` 函数的对表达式“转义”完成的： ::

    macro time(ex)
        ...
        local val = $(esc(ex))
        ...
    end

这样，封装的表达式就不会被宏展开机制处理，能够正确的在宏调用环境中解析。

必要时这个转义机制可以用来“破坏”卫生，从而引入或操作自定义变量。下例在调用环境中宏将 ``x`` 设置为 0 ： ::

    macro zerox()
      esc(:(x = 0))
    end

    function foo()
      x = 1
      @zerox
      x  # is zero
    end

应审慎使用这种操作。

.. _man-non-standard-string-literals2:

非标准字符串文本
~~~~~~~~~~~~~~~~

:ref:`字符串 <man-non-standard-string-literals>` 中曾讨论过带标识符前缀的字符串文本被称为非标准字符串文本，它们有特殊的语义。例如：

-  ``r"^\s*(?:#|$)"`` 生成正则表达式对象而不是字符串
-  ``b"DATA\xff\u2200"`` 是字节数组文本 ``[68,65,84,65,255,226,136,128]`` 

事实上，这些行为不是 Julia 解释器或编码器内置的，它们调用的是特殊名字的宏。例如，正则表达式宏的定义如下： ::

    macro r_str(p)
      Regex(p)
    end

因此，表达式 ``r"^\s*(?:#|$)"`` 等价于把下列对象直接放入语法树： ::

    Regex("^\\s*(?:#|\$)")

这么写不仅字符串文本短，而且效率高：正则表达式需要被编译，而 ``Regex`` 仅在 *代码编译时* 才构造，因此仅编译一次，而不是每次执行都编译。下例中循环中有一个正则表达式： ::

    for line = lines
      m = match(r"^\s*(?:#|$)", line)
      if m.match == nothing
        # non-comment
      else
        # comment
      end
    end

如果不想使用宏，要使上例只编译一次，需要如下改写： ::

    re = Regex("^\\s*(?:#|\$)")
    for line = lines
      m = match(re, line)
      if m.match == nothing
        # non-comment
      else
        # comment
      end
    end

由于编译器优化的原因，上例依然不如使用宏高效。但有时，不使用宏可能更方便：要对正则表达式内插时；正则表达式模式本身是动态的，每次循环迭代都会改变，生成新的正则表达式。

不止非标准字符串文本，命令文本语法（ ```echo "Hello, $person"``` ）也是用宏实现的： ::

    macro cmd(str)
      :(cmd_gen($shell_parse(str)))
    end

当然，大量复杂的工作被这个宏定义中的函数隐藏了，但是这些函数也是用 Julia 写的。你可以阅读源代码，看看它如何工作。它所做的事儿就是构造一个表达式对象，用于插入到你的程序的语法树中。

反射
----

In addition to the syntax-level introspection utilized in metaprogramming,
Julia provides several other runtime reflection capabilities.

**Type fields** The names of data type fields (or module members) may be interrogated
using the `names` command. For example, given the following type::

	type Point
		x::FloatingPoint
		y
	end

`names(Point)` will return the array: `Any[ :x :y ]`. Note that the type of
each field in a `Point` is stored in the `types` field of the Point object::

	julia> typeof(Point)
	DataType
	julia> Point.types
	(FloatingPoint,Any)

**Subtypes** The *direct* subtypes of any DataType may be listed using
``subtypes(t::DataType)``. For example, the abstract DataType `FloatingPoint`
has four (concrete) subtypes::
	
	julia> subtypes(FloatingPoint)
	5-element Array{Any,1}:
	 BigFloat
	 Float16
	 Float32
	 Float64

Any abstract subtype will also be included in this list, but further subtypes
thereof will not; recursive applications of ``subtypes`` allow to build the
full type tree.

**Type internals** The internal representation of types is critically important
when interfacing with C code. ``isbits(T::DataType)`` returns true if `T` is
stored with C-compatible aligment. The offsets of each field may be listed
using ``fieldoffsets(T::DataType)``.

**Function methods** The methods of any function may be listed using
``methods(f::Function)``. 

**Function representations** Functions may be introspected at several levels
of representation. The lowered form of a function is available
using ``code_lowered(f::Function, (Args...))``, and the type-inferred lowered form
is available using ``code_typed(f::Function, (Args...))``.

Closer to the machine, the LLVM Intermediate Representation of a function is
printed by ``code_llvm(f::Function, (Args...))``, and finally the resulting
assembly instructions (after JIT'ing step) are available using
``code_native(f::Function, (Args...)``.
