.. _man-modules:

******
 模块
******

.. index:: module, baremodule, using, import, export, importall

Julia 的模块是一个独立的全局变量工作区。它由句法限制在 ``module Name ... end`` 之间。在模块内部，你可以控制其他模块的命名是否可见（通过 ``import`` ），也可以指明本模块的命名是否为 public （通过 ``export`` ）。

下面的例子展示了模块的主要特征。这个例子仅为演示： ::

    module MyModule
    using Lib
    
    using BigLib: thing1, thing2

    import Base.show

    importall OtherLib
    
    export MyType, foo
    
    type MyType
        x
    end
    
    bar(x) = 2x
    foo(a::MyType) = bar(a.x) + 1
    
    show(io, a::MyType) = print(io, "MyType $(a.x)")
    end

注意上述例子没有缩进模块体的代码，因为整体缩进没有必要。

这个模块定义了类型 ``MyType`` 和两个函数。 ``foo`` 函数和 ``MyType`` 类型被 export ，因此可以被 import 进其他模块使用。 ``bar`` 是 ``MyModule`` 的私有函数。

语句 ``using Lib`` 表明， ``Lib``  模块在需要时可用来解析命名。若一个全局变量在当前模块中没有被定义，系统会在 ``Lib`` export 的变量中搜索，并在找到后把它 import 进来。在当前模块中凡是用到这个全局变量时，都会去找 ``Lib`` 中变量的定义。

语句 ``using BigLib: thing1, thing2`` 是 ``using BigLib.thing1, BigLib.thing2`` 的缩写。

The ``import`` keyword supports all the same syntax as ``using``, but only
operates on a single name at a time. It does not add modules to be searched
the way ``using`` does. ``import`` also differs from ``using`` in that
functions must be imported using ``import`` to be extended with new methods.

In ``MyModule`` above we wanted to add a method to the standard ``show``
function, so we had to write ``import Base.show``.
Functions whose names are only visible via ``using`` cannot be extended.

The keyword ``importall`` explicitly imports all names exported by the
specified module, as if ``import`` were individually used on all of them.

Once a variable is made visible via ``using`` or ``import``, a module may
not create its own variable with the same name.
Imported variables are read-only; assigning to a global variable always
affects a variable owned by the current module, or else raises an error.

Summary of module usage
^^^^^^^^^^^^^^^^^^^^^^^

To load a module, two main keywords can be used: ``using`` and ``import``. To understand their differences, consider the following example::

    module MyModule
    
    export x, y

    x() = "x"
    y() = "y"
    p() = "p"
    
    end

In this module we export the ``x`` and ``y`` functions (with the keyword ``export``), and also have the non-exported function ``p``. There are several different ways to load the Module and its inner functions into the current workspace:

+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
|Import Command                      | What is brought into scope                                                                   | Available for method extension                                         |
+====================================+==============================================================================================+========================================================================+
| ``using MyModule``                 | All ``export`` ed names (``x`` and ``y``), ``MyModule.x``, ``MyModule.y`` and ``MyModule.p`` | ``MyModule.x``, ``MyModule.y`` and ``MyModule.p``                      |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``using MyModule.x, MyModule.p``   | ``x`` and ``p``                                                                              |                                                                        |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``using MyModule: x, p``           | ``x`` and ``p``                                                                              |                                                                        |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``import MyModule``                | ``MyModule.x``, ``MyModule.y`` and ``MyModule.p``                                            | ``MyModule.x``, ``MyModule.y`` and ``MyModule.p``                      |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``import MyModule.x, MyModule.p``  | ``x`` and ``p``                                                                              | ``x`` and ``p``                                                        |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``import MyModule: x, p``          | ``x`` and ``p``                                                                              | ``x`` and ``p``                                                        |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+
| ``importall MyModule``             |  All ``export`` ed names (``x`` and ``y``)                                                   | ``x`` and ``y``                                                        |
+------------------------------------+----------------------------------------------------------------------------------------------+------------------------------------------------------------------------+


模块和文件
----------

大多数情况下,文件和文件名与模块无关；模块只与模块表达式有关。一个模块可
以有多个文件，一个文件也可以有多个模块： ::

    module Foo

    include("file1.jl")
    include("file2.jl")

    end

在不同的模块中包含同样的代码，会带来类似 mixin 的特征。可以利用这点，在不同的环境定义下运行同样的代码，例如运行一些操作的“安全”版本来进行代码测试： ::

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

Main 是顶级模块，Julia 启动时将 Main 设为当前模块。提示符模式下，变量都是在 Main 模块中定义， ``whos()`` 可以列出 Main 中的所有变量。

Core 包含“内置”的所有标志符，例如部分核心语言，但不包括库。每个模块都隐含地调用了 ``using Core`` ，因为没有这些声明，什么都做不了。

Base 是标准库（ 在 base/ 文件夹下）。所有的模块都隐含地调用了 ``using Base`` ，因为大部分情况下都需要它。


默认顶级声明和裸模块
--------------------

除了 ``using Base`` ，模块显式引入了所有的运算符。模块还自动包含 ``eval`` 函数的定义，这个函数对本模块中的表达式求值。

如果不想要这些定义，可以使用 ``baremodule`` 关键字来定义模块。使用 ``baremodule`` 时，一个标准的模块有如下格式： ::

    baremodule Mod

    using Base

    importall Base.Operators

    eval(x) = Core.eval(Mod, x)
    eval(m,x) = Core.eval(m, x)

    ...

    end


模块的相对和绝对路径
--------------------

输入指令 ``using foo``, Julia 会首先在 ``Main`` 名字空间中寻找 ``Foo`` 。如果模块未找到, Julia 会尝试 ``require("Foo")`` 。通常情况下, 这会从已安装的包中载入模块.

然而，有些模块还有子模块，也就是说，有时候不能从 ``Main`` 中直接引用一些模块。有两种方法可以解决这个问题：方法一，使用绝对路径，如 ``using Base.Sort`` 。方法二，使用相对路径，这样可以方便地载入当前模块的子模块或者嵌套的模块： ::

    module Parent

    module Utils
    ...
    end

    using .Utils

    ...
    end

模块 ``Parent`` 包含子模块 ``Utils`` 。如果想要 ``Utils`` 中的内容对 ``Parent`` 可见, 可以使用 ``using`` 加上英文句号。更多的句号表示在更下一层的命名空间进行搜索。例如， ``using ..Utils`` 将会在 ``Parent`` 模块的
子模块内寻找 ``Utils`` 。

模块文件路径
------------
.. Module file paths
.. -----------------

全局变量 ``LOAD_PATH`` 包含了调用 ``require`` 时 Julia搜索模块的目录。可以用 ``push!`` 进行扩展 ::

    push!(LOAD_PATH, "/Path/To/My/Module/")

将这一段代码放在 ``~\.juliarc.jl`` 里能够在每次 Julia启动时对 ``LOAD_PATH`` 扩展。 此外，还可以通过定义环境变量
``JULIA_LOAD_PATH`` 来扩展 Julia的模块路径。

.. The Julia variable LOAD_PATH contains the directories Julia searches for 
.. modules. It can be extended using the ``push!`` method::

..     push!(LOAD_PATH, "/Path/To/My/Module/")

.. Putting this statement to the ``~\.juliarc.jl`` file will extend LOAD_PATH 
.. on every Julia startup. Alternatively, the Julia module load path can be
.. extended by defining the environoment variable JULIA_LOAD_PATH.


小提示
------

如果一个命名是有许可的(qualified)（如 ``Base.sin`` ），即使它没被 export ，仍能被外部读取。这在调试时非常有用。

import 或 export 宏时，要在宏名字前添加 ``@`` 符号，例如 ``import Mod.@mac`` 。Macros in other modules can be invoked as ``Mod.@mac``
or ``@Mod.mac``.

形如 ``M.x = y`` 的语法是错的，不能给另一个模块中的全局变量赋值；全局变量的赋值都是在变量所在的模块中进行的。

直接在顶层声明为 ``global x`` ，可以将变量声明为“保留”的。这可以用来防止加载时，全局变量初始化遇到命名冲突。
