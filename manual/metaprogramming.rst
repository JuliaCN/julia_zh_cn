.. _man-metaprogramming:

.. currentmodule:: Base

********
 元编程(目标: Release 0.4.0版本)
********
在julia语言中，对元编程的支持，是继承自Lisp语言的最强大遗产。类似Lisp，julia自身的代码也是语言本身的数据结构。由于代码是由这门语言本身所构造和处理的对象所表示的，因此程序也可以转换成和生成自身语言的代码。这样不用额外的构建步骤，依然可以生成复杂而精细的高级代码，并且也可以让真正Lisp风格的宏在抽象语法树 (`abstract syntax trees <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`_) 层面进行操作。与此相反的是，称之为预处理器“宏”系统，例如C和C++就采用了这种系统。它所实现的是，在执行任何实际内插 (inter-pretation) 操作或者从语法上解析 (parse) 操作之前，执行文本处理和代入操作（julia与此相反）。因为所有在julia中的数据类型和代码都是通过julia数据结构来表示的，所以用反射 (`reflection <https://en.wikipedia.org/wiki/Reflection_%28computer_programming%29>`_) 功能可以探索程序内部的内容以及这些内容的类型，就像任何其他类型的数据一样。

表达式和求值
------------

Julia 代码表示为由 Julia 的 ``Expr`` 类型的数据结构而构成的语法树。下面是 ``Expr`` 类型的定义： ::

    type Expr
      head::Symbol
      args::Array{Any,1}
      typ
    end

``head`` 是标明表达式种类的符号； ``args`` 是子表达式数组，它可能是求值时引用变量值的符号，也可能是嵌套的 ``Expr`` 对象，还可能是真实的对象值。 ``typ`` 域被类型推断用来做类型注释，通常可以被忽略。

有两种“引用”代码的方法，它们可以简单地构造表达式对象，而不需要显式构造 ``Expr`` 对象。第一种是内联表达式，使用 ``:`` ，后面跟单表达式；第二种是代码块儿，放在 ``quote ... end`` 内部。下例是第一种方法，引用一个算术表达式：

.. doctest::

    julia> ex = :(a+b*c+1)
    :(a + b * c + 1)

    julia> typeof(ex)
    Expr

    julia> ex.head
    :call

    julia> typeof(ans)
    Symbol

    julia> ex.args
    4-element Array{Any,1}:
      :+
      :a
      :(b * c)
     1

    julia> typeof(ex.args[1])
    Symbol

    julia> typeof(ex.args[2])
    Symbol

    julia> typeof(ex.args[3])
    Expr

    julia> typeof(ex.args[4])
    Int64

下例是第二种方法：

.. doctest::

    julia> quote
             x = 1
             y = 2
             x + y
           end
    quote  # none, line 2:
        x = 1 # line 3:
        y = 2 # line 4:
        x + y
    end

符号
~~~~

``:`` 的参数为符号时，结果为 ``Symbol`` 对象，而不是 ``Expr`` ：

.. doctest::

    julia> :foo
    :foo

    julia> typeof(ans)
    Symbol

在表达式的上下文中，符号用来指示对变量的读取。当表达式被求值时，符号的值受限于符号的作用域（详见 :ref:`man-variables-and-scoping` ）。

有时, 为了防止解析时产生歧义， ``:`` 的参数需要添加额外的括号：

.. doctest::

    julia> :(:)
    :(:)

    julia> :(::)
    :(::)

``Symbol`` 也可以使用 ``symbol`` 函数来创建，参数为一个字符或者字符串：

.. doctest::

    julia> symbol('\'')
    :'

    julia> symbol("'")
    :'

求值和内插
~~~~~~~~~~

指定一个表达式，Julia 可以使用 ``eval`` 函数在 global 作用域对其求值。

.. doctest::

    julia> :(1 + 2)
    :(1 + 2)

    julia> eval(ans)
    3

    julia> ex = :(a + b)
    :(a + b)

    julia> eval(ex)
    ERROR: a not defined

    julia> a = 1; b = 2;

    julia> eval(ex)
    3

Every :ref:`module <man-modules>` has its own ``eval`` function that
evaluates expressions in its global scope.
Expressions passed to ``eval`` are not limited to returning values
— they can also have side-effects that alter the state of the enclosing
module's environment:

.. doctest::

    julia> ex = :(x = 1)
    :(x = 1)

    julia> x
    ERROR: x not defined

    julia> eval(ex)
    1

    julia> x
    1

表达式仅仅是一个 ``Expr`` 对象，它可以通过编程构造，然后对其求值：

.. doctest::

    julia> a = 1;

    julia> ex = Expr(:call, :+,a,:b)
    :(+(1,b))

    julia> a = 0; b = 2;

    julia> eval(ex)
    3

注意上例中 ``a`` 与 ``b`` 使用时的区别：

-  表达式构造时，直接使用 *变量* ``a`` 的值。因此，对表达式求值时 ``a`` 的值没有任何影响：表达式中的值为 ``1`` ，与现在 ``a`` 的值无关
-  表达式构造时，使用的是 *符号* ``:b`` 。因此，构造时变量 ``b`` 的值是无关的—— ``:b`` 仅仅是个符号，此时变量 ``b`` 还未定义。对表达式求值时，通过查询变量 ``b`` 的值来解析符号 ``:b`` 的值

这样构造 ``Expr`` 对象太丑了。Julia 允许对表达式对象内插。因此上例可写为：

.. doctest::

    julia> a = 1;

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

对非引用表达式进行内插，会引发编译时错误：

.. doctest::

    julia> $a + b
    ERROR: unsupported or misplaced expression $

.. _man-macros:

宏
--

宏有点儿像编译时的表达式生成函数。 Just as functions map a tuple of argument values to a
return value, macros map a tuple of argument *expressions* to a returned
*expression*. They allow the programmer to arbitrarily transform the
written code to a resulting expression, which then takes the place of
the macro call in the final syntax tree.调用宏的语法为： ::

    @name expr1 expr2 ...
    @name(expr1, expr2, ...)

注意，宏名前有 ``@`` 符号。第一种形式，参数表达式之间没有逗号；第二种形式，宏名后没有空格。这两种形式不要记混。例如，下面的写法的结果就与上例不同，它只向宏传递了一个参数，此参数为多元组 ``(expr1, expr2, ...)`` ：  ::

    @name (expr1, expr2, ...)

程序运行前， ``@name`` 展开函数会对表达式参数处理，用结果替代这个表达式。使用关键字 ``macro`` 来定义展开函数： ::

    macro name(expr1, expr2, ...)
        ...
        return resulting_expr
    end

下例是 Julia 中 ``@assert`` 宏的简单定义： ::

    macro assert(ex)
        return :($ex ? nothing : error("Assertion failed: ", $(string(ex))))
    end

这个宏可如下使用：

.. doctest::

    julia> @assert 1==1.0

    julia> @assert 1==0
    ERROR: Assertion failed: 1 == 0
     in error at error.jl:22

宏调用在解析时被展开为返回的结果。这等价于： ::

    1==1.0 ? nothing : error("Assertion failed: ", "1==1.0")
    1==0 ? nothing : error("Assertion failed: ", "1==0")

That is, in the first call, the expression ``:(1==1.0)`` is spliced into
the test condition slot, while the value of ``string(:(1==1.0))`` is
spliced into the assertion message slot. The entire expression, thus
constructed, is placed into the syntax tree where the ``@assert`` macro
call occurs. Then at execution time, if the test expression evaluates to
true, then ``nothing`` is returned, whereas if the test is false, an error
is raised indicating the asserted expression that was false. Notice that
it would not be possible to write this as a function, since only the
*value* of the condition is available and it would be impossible to
display the expression that computed it in the error message.

The actual definition of ``@assert`` in the standard library is more
complicated. It allows the user to optionally specify their own error
message, instead of just printing the failed expression. Just like in
functions with a variable number of arguments, this is specified with an
ellipses following the last argument::

    macro assert(ex, msgs...)
        msg_body = isempty(msgs) ? ex : msgs[1]
        msg = string("assertion failed: ", msg_body)
        return :($ex ? nothing : error($msg))
    end

Now ``@assert`` has two modes of operation, depending upon the number of
arguments it receives! If there's only one argument, the tuple of expressions
captured by ``msgs`` will be empty and it will behave the same as the simpler
definition above. But now if the user specifies a second argument, it is
printed in the message body instead of the failing expression. You can inspect
the result of a macro expansion with the aptly named :func:`macroexpand`
function:

.. doctest::

    julia> macroexpand(:(@assert a==b))
    :(if a == b
            nothing
        else
            Base.error("assertion failed: a == b")
        end)

    julia> macroexpand(:(@assert a==b "a should equal b!"))
    :(if a == b
            nothing
        else
            Base.error("assertion failed: a should equal b!")
        end)

There is yet another case that the actual ``@assert`` macro handles: what
if, in addition to printing "a should equal b," we wanted to print their
values? One might naively try to use string interpolation in the custom
message, e.g., ``@assert a==b "a ($a) should equal b ($b)!"``, but this
won't work as expected with the above macro. Can you see why? Recall
from :ref:`string interpolation <man-string-interpolation>` that an
interpolated string is rewritten to a call to the ``string`` function.
Compare:

.. doctest::

    julia> typeof(:("a should equal b"))
    ASCIIString (constructor with 2 methods)

    julia> typeof(:("a ($a) should equal b ($b)!"))
    Expr

    julia> dump(:("a ($a) should equal b ($b)!"))
    Expr
      head: Symbol string
      args: Array(Any,(5,))
        1: ASCIIString "a ("
        2: Symbol a
        3: ASCIIString ") should equal b ("
        4: Symbol b
        5: ASCIIString ")!"
      typ: Any

So now instead of getting a plain string in ``msg_body``, the macro is
receiving a full expression that will need to be evaluated in order to
display as expected. This can be spliced directly into the returned expression
as an argument to the ``string`` call; see `error.jl
<https://github.com/JuliaLang/julia/blob/master/base/error.jl>`_ for
the complete implementation.

The ``@assert`` macro makes great use of splicing into quoted expressions
to simplify the manipulation of expressions inside the macro body.

卫生宏
~~~~~~

`卫生宏 <http://en.wikipedia.org/wiki/Hygienic_macro>`_ 是个更复杂的宏。In short, macros must
ensure that the variables they introduce in their returned expressions do not
accidentally clash with existing variables in the surrounding code they expand
into. Conversely, the expressions that are passed into a macro as arguments are
often *expected* to evaluate in the context of the surrounding code,
interacting with and modifying the existing variables. Another concern arises
from the fact that a macro may be called in a different module from where it
was defined. In this case we need to ensure that all global variables are
resolved to the correct module. Julia already has a major advantage over
languages with textual macro expansion (like C) in that it only needs to
consider the returned expression. All the other variables (such as ``msg`` in
``@assert`` above) follow the :ref:`normal scoping block behavior
<man-variables-and-scoping>`.

来看一下 ``@time`` 宏，它的参数是一个表达式。它先记录下时间，运行表达式，再记录下时间，打印出这两次之间的时间差，它的最终值是表达式的值： ::

    macro time(ex)
      return quote
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
      return esc(:(x = 0))
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
      if m == nothing
        # non-comment
      else
        # comment
      end
    end

如果不想使用宏，要使上例只编译一次，需要如下改写： ::

    re = Regex("^\\s*(?:#|\$)")
    for line = lines
      m = match(re, line)
      if m == nothing
        # non-comment
      else
        # comment
      end
    end

由于编译器优化的原因，上例依然不如使用宏高效。但有时，不使用宏可能更方便：要对正则表达式内插时必须使用这种麻烦点儿的方式；正则表达式模式本身是动态的，每次循环迭代都会改变，生成新的正则表达式。

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
using the ``names`` command. For example, given the following type::

	type Point
	  x::FloatingPoint
	  y
	end

``names(Point)`` will return the array ``Any[:x, :y]``. The type of
each field in a ``Point`` is stored in the ``types`` field of the Point object::

	julia> typeof(Point)
	DataType
	julia> Point.types
	(FloatingPoint,Any)

**Subtypes** The *direct* subtypes of any DataType may be listed using
``subtypes(t::DataType)``. For example, the abstract DataType ``FloatingPoint``
has four (concrete) subtypes::

	julia> subtypes(FloatingPoint)
	4-element Array{Any,1}:
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
