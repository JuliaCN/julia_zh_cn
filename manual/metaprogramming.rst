.. _man-metaprogramming:

.. currentmodule:: Base

********
 元编程(Release 0.4.0)
********
在Julia语言中，对元编程的支持，是继承自Lisp语言的最强大遗产。类似Lisp，Julia自身的代码也是语言本身的数据结构。由于代码是由这门语言本身所构造和处理的对象所表示的，因此程序也可以转换成和生成自身语言的代码。这样不用额外的构建步骤，依然可以生成复杂而精细的高级代码，并且也可以让真正Lisp风格的宏在抽象语法树 (`abstract syntax trees <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`_) 层面进行操作。与此相反的是，称之为预处理器“宏”系统，例如C和C++就采用了这种系统。它所实现的是，在执行任何实际内插 (inter-pretation) 操作或者从语法上解析 (parse) 操作之前，执行文本处理和代入操作（Julia与此相反）。因为所有在julia中的数据类型和代码都是通过julia数据结构来表示的，所以用反射 (`reflection <https://en.wikipedia.org/wiki/Reflection_%28computer_programming%29>`_) 功能可以探索程序内部的内容以及这些内容的类型，就像任何其他类型的数据一样。

程序的表示
------------
每一个Julia程序都是从一个字符串开始它的生命的（所有的程序源代码都是字符串）： ::

    julia> prog = "1 + 1"
    "1 + 1"
    
**下一步将发生什么呢？**

下一步是把每一个字符串解析 (`parse <https://en.wikipedia.org/wiki/Parsing#Computer_languages>`_) 成一种被称之为表达式 (Expression) 的对象，用Julia类型 ``Expr`` 来表示： ::

    julia> ex1 = parse(prog)
    :(1 + 1)

    julia> typeof(ex1)
    Expr

``Expr`` 对象包含三部分：

* 一个 ``Symbol`` 用来表示表达式对象的种类。符号 (symbol) 是驻留字符串 (interned string) 的标识符（详见下文）。 ::

    julia> ex1.head
    :call

* （一堆）表达式对象的参数, 他们可能是符号，其他表达式, 或者立即数/字面值： ::

    julia> ex1.args
    3-element Array{Any,1}:
     :+
     1
     1

* 最后，是表达式对象的返回值的类型, 它可能被用户注释或者被编译器推断出来（而且可以被完全忽略，比如在本章里）： ::

    julia> ex1.typ
    Any

通过前缀符号，表达式对象也可以被直接构建： ::

    julia> ex2 = Expr(:call, :+, 1, 1)
    :(1 + 1)

通过上述两种方式 – 解析或者直接构建 – 构建出的表达式对象是等价的： ::

    julia> ex1 == ex2
    true

**这里的要点是，Julia语言的代码内在地被表示成了一种，可以被外界通过Julia语言自身所获取的数据结构**

这个 ``dump()`` 函数可以显示带缩进和注释的表达式对象： ::

    julia> dump(ex2)
    Expr
      head: Symbol call
      args: Array(Any,(3,))
        1: Symbol +
        2: Int64 1
        3: Int64 1
      typ: Any
      
表达式对象也可以是嵌套形式的： ::

    julia> ex3 = parse("(4 + 4) / 2")
    :((4 + 4) / 2)
    
另一种查看表达式内部的方法是用 ``Meta.show_sexpr`` 函数, 它可以把一个给定的表达式对象显示成S-expression形式, Lisp用户肯定会觉得这个形式很眼熟。这有一个例子，用来说明怎样显示一个嵌套形式的表达式对象: ::

    julia> Meta.show_sexpr(ex3)
    (:call, :/, (:call, :+, 4, 4), 2)

符号对象
------------
在Julia中，这个字符： ``:`` 有两个语法的功能. 第一个功能是创建一个 ``Symbol`` 对象, 把一个驻留字符串 (`interned string <https://en.wikipedia.org/wiki/String_interning>`_)用作表达式对象的构建块： ::

    julia> :foo
    :foo

    julia> typeof(ans)
    Symbol

符号对象也可以被 ``symbol()`` 函数构建, 它把所有参数的值（数、字符、字符串、现有的符号对象，或者是用 ``:`` 新构建的符号对象）链接起来，整体创建的一个新的符号对象 ： ::

    julia> :foo == symbol("foo")
    true

    julia> symbol("func",10)
    :func10

    julia> symbol(:var,'_',"sym")
    :var_sym
    
在表达式对象的语境里, 符号被用来表明变量的值; 当计算一个表达式对象的时候, 每个符号都被替换成它在当前变量作用范围内 (scope) 所代表的值。

有时用额外的圆括号包住的 ``:`` 来表示 ``:`` 的字符意义（而不是语法意义，在语法意义中，它表示把自己之后的字符串变成一个符号） 从而避免在解析时出现混淆。 ::

    julia> :(:)
    :(:)

    julia> :(::)
    :(::)
    
表达式及其计算
----------------------------          

引用 (Quote)
~~~~~~~~~    
这个 ``:`` 字符的第二个语法功能是，不用显式的 (explicit)表达式对象构建器，从而构建一个表达式对象。这被称之为引用。 通过使用这个 ``:`` 字符, 以及后面跟着的由一对圆括号所包住的一条 julia 表达式语句（注意表达式语句和表达式对象不一样，表达式语句就是一条 julia 程序/脚本的语句）, 生成一个基于这条被包括住的语句的表达式对象。 这个例子表明了对一个简短的算数运算的引用： ::

    julia> ex = :(a+b*c+1)
    :(a + b * c + 1)

    julia> typeof(ex)
    Expr
    
（为了查看这个表达式对象的结构, 请尝试上文提到过的 ``ex.head``、 ``ex.args`` 或者 ``dump()``）

注意：用这种方法构建出来的表达式对象，和用``Expr``对象构建器直接构建，或者用 ``parse()`` 函数构建，构建出来的表达式对象是等价的： ::

    julia>      :(a + b*c + 1)  ==
           parse("a + b*c + 1") ==
           Expr(:call, :+, :a, Expr(:call, :*, :b, :c), 1)
    true

由解析器 (parser) 生成的表达式对象通常把符号对象、其他表达式对象、或者字面值作为他们的参数, 然而用 julia 代码（即 ``Expr()`` , ``:()`` 这些方法）构建的表达式可以不通过字面形式，把任意实时值 (run-time values) 作为参数（比如可以把变量 ``a`` 的实时值当做参数，而不是变量 ``a`` 这一字面形式作为参数，后文有详细描述）。 在上面这个具体的例子里,  ``+``  和 ``a`` 都是符号对象, ``*(b,c)`` 是一个子表达式对象, 以及 ``1`` 是一个字面值（64位有符号整数）

引用的另一种语法是通过“引用块”实现多重表达式： 在引用块里，代码被包含在 quote ... end中。 注意，当直接操作由引用块生成的表达式树时，一定要注意到，这种形式把 QuoteNode 元素引入了表达式树。其他情况下比如 ``:( ... )`` 和 ``quote .. end`` 块会被当做一样的对象来处理。 ::

    julia> ex = quote
               x = 1
               y = 2
               x + y
           end
    quote  # none, line 2:
        x = 1 # none, line 3:
        y = 2 # none, line 4:
        x + y
    end

    julia> typeof(ex)
    Expr

内插 (Interpolation)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

用参数值直接构建表达式对象，这种方法是非常强大的, 但是与“正常”的julia 语法相比， ``Expr`` 对象构建器就可能显得冗长。作为另一个选择， julia 允许, 把字面值或者表达式对象 “拼接 (splicing) ” 或者“内插” 进 一个被引用的表达式语句（即表达式对象）。 内插的内容之前加 ``$`` 前缀.

在这个例子里，被内插的是变量 ``a`` 的值： ::

    julia> a = 1;

    julia> ex = :($a + b)
    :(1 + b)
    
对于没有被引用的表达式语句，是不能做“内插”操作的，并且如果对这种表达式语句做内插操作，将会导致一个编译错误 (compile-time error)。： ::

    julia> $a + b
    ERROR: unsupported or misplaced expression $
    
在这个例子里, tuple ``(1,2,3)`` 作为一个表达式语句，先被 ``:`` 引用成了表达式对象 ``b`` ，再被内插进一个条件测试： ::

    julia> b = :(1,2,3)
    julia> ex = :(a in $b )
    :($(Expr(:in, :a, :((1,2,3)))))
    
把符号对象内插进一个嵌套的表达式对象需要在一个封闭的引用块（如下所示的 ``:(:a + :b)`` ）内附每一个符号对象： ::

    julia> :( :a in $( :(:a + :b) ) )
                       ^^^^^^^^^^
                   被引用的内部表达式
                   
用于表达式内插的 ``$`` 的用法，令人想起字符串内插和指令内插。表达式内插这一功能，使得复杂julia表达式，得以方便，可读，程序化的被构建。 

``eval()`` 函数及其效果
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
使用 ``eval()`` 函数,可以在全局作用域，让 julia 执行 (evaluate) 一个表达式对象： ::

    julia> :(1 + 2)
    :(1 + 2)

    julia> eval(ans)
    3

    julia> ex = :(a + b)
    :(a + b)

    julia> eval(ex)
    ERROR: UndefVarError: b not defined

    julia> a = 1; b = 2;

    julia> eval(ex)
    3

每个模块都有自己的 ``eval()`` 函数，用来在全局作用域执行表达式对象。 用 ``eval()`` 函数执行表达式对象，不仅可以得到返回值 — 而且还有这样一个附带后果：在当前作用域，修改在这个表达式对象中所被修改的状态量： ::

    julia> ex = :(x = 1)
    :(x = 1)

    julia> x
    ERROR: UndefVarError: x not defined

    julia> eval(ex)
    1

    julia> x
    1
    
这里, 对表达式对象所进行的计算给全局变量 ``x`` 赋了一个值（1）。

既然表达式语句都是可以通过先程序化的构建表达式对象，再计算这个对象从而生成的， 这也就是说，可以动态的生成任意代码（动态的构建表达式对象），然后这些代码可以用 ``eval()`` 函数执行。 这里有一个简单的例子： ::

    julia> a = 1;

    julia> ex = Expr(:call, :+, a, :b)
    :(1 + b)

    julia> a = 0; b = 2;

    julia> eval(ex)
    3

``a`` 的值被用来构建表达式对象 ``ex`` ，  ``ex``  用  ``+``  函数来加”值1“和“变量 ``b`` ”。 注意  ``a`` 和 ``b`` 的用法有着重要的不同点：

在构建表达式时，变量 ``a`` 的值，被用作一个用在表达式中的立即数。 因此, 当计算这个表达式的时候，变量 ``a`` 的值是什么都无所谓了： 在表达式中，这个值已经是1了，与``a``这个变量的值后来变成什么就没关系了。

另一方面而言, 符号 ``:b`` 被用在了表达式里, 所以在构建表达式时，变量 ``b`` 的值就无所谓是多少了 — ``:b``  只是一个符号对象，甚至变量 ``b`` 在那个时候（计算 ``ex`` 之前）都没必要被定义。然而在计算 ``ex`` 的时候, 把这个时候变量 ``b`` 的值当做符号 ``:b`` 的值，来进行计算。

表达式的函数
~~~~~~~~~~~~~~~

正如上文所提示过的, julia 的一个极其有用的特性是用 julia 程序有能力自己生成和操作这个程序自己的代码。我们已经见过这样的一个例子，一个函数的返回值是一个表达式对象：``parse()`` 函数，它输入的是一个 julia 代码构成的字符串，输出的是这些代码所对应的表达式对象。 一个函数也可以把一个或者更多的表达式对象当做参数，然后返回另一个表达式对象。这是一个简单的有启发性的例子： ::

    julia> function math_expr(op, op1, op2)
             expr = Expr(:call, op, op1, op2)
             return expr
           end

     julia>  ex = math_expr(:+, 1, Expr(:call, :*, 4, 5))
     :(1 + 4*5)

     julia> eval(ex)
     21
 
比如另一个例子,这里有一个函数，把任何数值参数都翻倍，其他部分不变，只返回新的表达式对象： ::

    julia> function make_expr2(op, opr1, opr2)
             opr1f, opr2f = map(x -> isa(x, Number) ? 2*x : x, (opr1, opr2))
             retexpr = Expr(:call, op, opr1f, opr2f)

             return retexpr
       end
    make_expr2 (generic function with 1 method)

    julia> make_expr2(:+, 1, 2)
    :(2 + 4)

    julia> ex = make_expr2(:+, 1, Expr(:call, :*, 5, 8))
    :(2 + 5 * 8)

    julia> eval(ex)
    42

Macros
------------

Macros provide a method to include generated code in the final body of a program. A macro maps a tuple of arguments to a returned expression, and the resulting expression is compiled directly rather than requiring a runtime eval() call. Macro arguments may include expressions, literal values, and symbols.

** （以下是0.3.0版本内容） **

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
