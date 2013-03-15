.. _man-modules:

******
 模块  
******

.. index:: module, baremodule, using, import, export, importall

Julia 的模块是一个独立的全局变量工作区。它由句法限制在 ``module Name ... end`` 之间。在模块内部，你可以控制其他模块的命名是否可见（通过 ``import`` ），也可以指明本模块的命名是否为 public （通过 ``export`` ）。

下面的例子展示了模块的主要特征。这个例子仅为演示： ::

    module MyModule
    using Lib
    
    export MyType, foo
    
    type MyType
        x
    end
    
    bar(x) = 2x
    foo(a::MyType) = bar(a.x) + 1
    
    import Base.show
    show(io, a::MyType) = print(io, "MyType $(a.x)")
    end

注意上述例子没有缩进模块体的代码，因为整体缩进没有必要。

这个模块定义了类型 ``MyType`` 和两个函数。 ``foo`` 函数和 ``MyType`` 类型被 export ，因此可以被 import 进其他模块。 ``bar`` 是 ``MyModule`` 的私有函数。

语句 ``using Lib`` 意思为， ``Lib``  模块在需要时可用来解析命名。若一个全局变量在当前模块中没有被声明，系统会在 ``Lib`` 中搜索，并在找到后把它 import 进来。在当前模块中凡是用到这个全局变量时，都会去找 ``Lib`` 中的变量声明做解析。

变量一旦被 import （即通过 ``import`` 关键字），模块就不能构造重名的变量了。import 的变量是只读的。

方法声明有点儿特殊：它们不去搜索 ``using`` 语句中的模块。除非 ``foo`` 是从某处 import 进来的， ``function foo()`` 声明会在当前模块构造一个新的 ``foo`` 。例如，上面的 ``MyModule`` 中，我们要给标准 ``show`` 函数添加一个方法，我们只需要写 ``import Base.show`` 。


模块和文件
----------

文件和文件名与模块无关；模块只与模块表达式有关。一个模块可以有多个文件，一个文件也可以有多个模块： ::

    module Foo

    include("file1.jl")
    include("file2.jl")

    end

在不同的模块中包含同样的代码，会带来类似混合的特征。可以利用这点，在不同的基础声明下运行同样的代码，例如运行一些操作的“安全”版本来进行代码测试： ::

    module Normal
    include("mycode.jl")
    end

    module Testing
    include("safe_operators.jl")
    include("mycode.jl")
    end


标准模块
--------

有三个重要的标准模块：Main, Core, 和 Base 。

Main 是顶级模块，Julia 启动时将 Main 设为当前模块。提示符模式下，变量声明都是在 Main 模块中， ``whos()`` 可以列出 Main 中的所有变量。

Core 包含“内建”的所有标志符，例如部分核心语言，但不包括库。每个模块都隐含地使用了 ``using Core`` ，因为没有这些声明，什么都做不了。

Base 是标准库（ 在 base/ 文件夹下）。所有的模块都隐含地使用了 ``using Base`` ，因为大部分情况下都需要它。


默认顶级声明和裸模块
--------------------

除了 ``using Base`` ，模块还自动包含 ``eval`` 函数的声明，这个函数对本模块上下文中的表达式求值。

如果不想要这些声明，可以使用 ``baremodule`` 关键字来定义模块。使用 ``baremodule`` 时，一个标准的模块有如下格式： ::

    baremodule Mod
    using Base
    eval(x) = Core.eval(Mod, x)
    eval(m,x) = Core.eval(m, x)
    ...
    end


小提示
------

如果一个命名是有许可的(qualified)（如 ``Base.sin`` ），即使它没被 export ，仍能被外部读取。这在调试时非常有用。

如果要在定义宏的模块外部使用这个宏，必须把它 export 。import 或 export 宏时，要在宏名字前添加 ``@`` 符号，例如 ``import Mod.@mac`` 。

形如 ``M.x = y`` 的语法，不能给另一个模块中的全局变量赋值；全局变量的赋值都是在变量所在的模块中进行的。

直接在顶层声明为 ``global x`` ，可以将变量声明为“保留”的。这可以用来防止加载时，全局变量初始化遇到命名冲突。