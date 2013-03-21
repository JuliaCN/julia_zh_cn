.. _man-getting-started:

************
 打这儿开始
************

Julia 的安装，不管是使用编译好的程序，还是自己从源代码编译，都很简单。按照 `http://julialang.org/downloads/ <http://julialang.org/downloads/>`_ 的说明下载并安装即可。

使用交互式会话（也记为 repl），是学习 Julia 最简单的方法： ::

    $ julia
                   _
       _       _ _(_)_     |
      (_)     | (_) (_)    |  A fresh approach to technical computing.
       _ _   _| |_  __ _   |
      | | | | | | |/ _` |  |  Version 0 (pre-release)
      | | |_| | | | (_| |  |  Commit 61847c5aa7 (2011-08-20 06:11:31)*
     _/ |\__'_|_|_|\__'_|  |
    |__/                   |

    julia> 1 + 2
    3

    julia> ans
    3

输入 ``^D`` — ``ctrl`` 键加 ``d`` 键，或者输入 ``quit()`` ，可以退出交互式会话。交互式模式下， ``julia`` 会显示一个横幅，并提示用户来输入。一旦用户输入了完整的表达式，例如 ``1 + 2`` ，然后按回车，交互式会话就对表达式求值并返回这个值。如果输入的表达式末尾有分号，就不会显示它的值了。变量 ``ans`` 的值就是上一次计算的表达式的值，无论上一次是否被显示。

如果想运行写在源文件 ``file.jl`` 中的代码，可以输入命令 ``include("file.jl")`` 。

要在非交互式模式下运行代码，你可以把它当做 Julia 命令行的第一个参数： ::

    $ julia script.jl arg1 arg2...

如这个例子所示，julia 后面跟着的命令行参数，被认为是程序 ``script.jl`` 的命令行参数。这些参数使用全局变量 ``ARGS`` 来传递。使用 ``-e`` 选项，也可以设置 ``ARGS`` 参数。可如下操作，来打印传递的参数： ::

    $ julia -e 'for x in ARGS; println(x); end' foo bar
    foo
    bar

也可以把代码放在一个脚本中，然后运行： ::

    $ echo 'for x in ARGS; println(x); end' > script.jl
    $ julia script.jl foo bar
    foo
    bar

运行 Julia 有各种可选项： ::

    julia [options] [program] [args...]
     -v --version             Display version information
     -q --quiet               Quiet startup without banner
     -H --home=<dir>          Load files relative to <dir>
     -T --tab=<size>          Set REPL tab width to <size>

     -e --eval=<expr>         Evaluate <expr>
     -E --print=<expr>        Evaluate and show <expr>
     -P --post-boot=<expr>    Evaluate <expr> right after boot
     -L --load=file           Load <file> right after boot
     -J --sysimage=file       Start up with the given system image file

     -p n                     Run n local processes
     --machinefile file       Run processes on hosts listed in file

     --no-history             Don't load or save history
     -f --no-startup          Don't load ~/.juliarc.jl
     -F                       Load ~/.juliarc.jl, then handle remaining inputs

     -h --help                Print this message

教程
----

网上有些比较随意的教程：

- `Forio 的 Julia 教程 <http://forio.com/julia/tutorials-list>`_
- `MIT 讲师 Homer Reid 数值分析课的教程 <http://homerreid.ath.cx/teaching/18.330/JuliaProgramming.shtml>`_

与 MATLAB 的区别
----------------

Julia 的语法尽量保持与 MATLAB 兼容。但 Julia 不是简单地复制 MATLAB ，它们有一些句法和功能上的区别。以下是一些值得注意的区别：

-  数组用方括号来索引， ``A[i,j]``
-  虚数单位 ``sqrt(-1)`` 用 ``im`` 来表示
-  多返回值和多重赋值需要使用圆括号，如 ``return (a, b)`` 和 ``(a, b) = f(x)``
-  使用引用来传递和赋值
-  有一维数组。列向量的长度为 ``N`` ，而不是 ``Nx1`` 。例如， ``rand(N)`` 生成的是一维数组
-  使用语法 ``[x,y,z]`` 来连接标量或数组，连接发生在第一维度（“垂直”）上。对于第二维度（“水平”）上的连接，需要使用空格，如 ``[x y z]`` 。   要想构造块矩阵，尽量使用语法 ``[a b; c d]``
-  ``a:b`` 和 ``a:b:c`` 中的冒号，用来构造 ``Range`` 对象。使用 ``linspace`` 构造一个满向量，或者通过使用方括号来“连接”范围，如 ``[a:b]``
-  函数返回须使用 ``return`` 关键字，而不是把它们列在函数定义中（详见 :ref:`man-return-keyword` ）
-  一个文件可以包含多个函数，文件被载入时，所有的函数声明都是外部可见的
-  ``sum``, ``prod``, ``max`` 等约简操作，如果被调用时参数只有一个，作用域是数组的所有元素，如 ``sum(A)``
-  ``sort`` 等函数，默认按列方向操作。（ ``sort(A)`` 等价于 ``sort(A,1)`` ）。对于 ``1xN`` 的矩阵，操作后无任何效果。要想排序 ``1xN`` 的矩阵，使用 ``sort(A,2)``
-  即使是无参数的函数，也要使用圆括号，如 ``tic()`` 和 ``toc()``
-  表达式结尾不要使用分号。表达式的结果不会自动显示（除非在交互式提示符下）。 ``println`` 函数可以用来在打印值并换行
-  若 ``A`` 和 ``B`` 是数组， ``A == B`` 并不返回布尔值数组。应该使用 ``A .== B`` 。其它布尔值运算符可以类比， ``<``, ``>``, ``!=`` 等
-  可以用 ``...`` 把集合中的元素作为参数传递给函数，如 ``xs=[1,2]; f(xs...)``
-  Julia 中 ``svd`` 返回的奇异值是向量而不是完整的对角矩阵

与 R 的区别
-----------

- 使用 ``=`` 赋值，不提供 ``<-`` 或 ``<<-`` 等箭头式运算符
- 用方括号构造向量。Julia 中 ``[1, 2, 3]`` 等价于 R 中的 ``c(1, 2, 3)``
- Julia 的矩阵运算比 R 更接近传统数学语言。如果 ``A`` 和 ``B`` 是矩阵，那么矩阵乘法在 Julia 中为 ``A * B`` ， R 中为 ``A %*% B`` 。在 R 中，原语句表示的是元素的 Hadamard 乘法。要进行元素点乘，Julia 中为 ``A .* B``
- 用 ``'`` 进行矩阵转置。Julia 中 ``A'`` 对应于 R 中的 ``t(A)``
- 写 ``if`` 语句或 ``for`` 循环时不需要写圆括号：应写 ``for i in [1, 2, 3]`` 而不是 ``for (i in c(1, 2, 3))`` ；应写 ``if i == 1`` 而不是 ``if (i == 1)``
- ``0`` 和 ``1`` 不是布尔值。不能写 ``if (1)`` ，因为 ``if`` 语句仅接受布尔值作为参数。应写成 ``if true``
- 不提供 ``nrow`` 和 ``ncol`` 。应该使用 ``size(M, 1)`` 替代 ``nrow(M)`` ；使用 ``size(M, 2)`` 替代 ``ncol(M)``
- Julia 的 SVD 默认为非 thinned ，与 R 不同。要得到与 R 一样的结果，应该对矩阵 ``X`` 调用 ``svd(X, true)``
- Julia 能区分标量、向量和矩阵。在 R 中， ``1`` 和 ``c(1)`` 是一样的。在 Julia 中，它们完全不同。例如若 ``x`` 和 ``y`` 为向量，则 ``x' * y`` 是一个单元素向量，而不是标量。要得到标量，应使用 ``dot(x, y)``
- Julia 中的 ``diag()`` 和 ``diagm()`` 与 R 中的不同
- Julia 不能在赋值语句左侧写函数调用：不能写 ``diag(M) = ones(n)``
- Julia 不赞成把 main 命名空间塞满函数。大多数统计学函数可以在 `扩展包 </en/latest/packages/packagelist.html/>`_ 中找到，比如 DataFrames 和 Distributions 包：
	- `Distributions 包 <https://github.com/JuliaStats/Distributions.jl>`_ 提供了概率分布函数
	- `DataFrames 包 <https://github.com/HarlanH/DataFrames.jl>`_ 提供了数据框
	- GLM 公式必须要转义：使用 ``:(y ~ x)`` ，而不是 ``y ~ x``
- Julia 提供了多元组和哈希表，但不提供 R 的列表。当返回多项时，应该使用多元组：不要使用 ``list(a = 1, b = 2)`` ，应该使用 ``(1, 2)``
- 鼓励自定义类型。Julia 的类型比 R 中的 S3 或 S4 对象简单。Julia 的重载系统使 ``table(x::TypeA)`` 和 ``table(x::TypeB)`` 的结果，和 R 中的 ``table.TypeA(x)`` 和 ``table.TypeB(x)`` 一样
- 在 Julia 中，传递值和赋值是靠引用。如果一个函数修改了数组，所调用的函数就能告诉你。这与 R 非常不同，这使得在大数据结构上进行新函数操作非常高效
- 使用 ``hcat`` 和 ``vcat`` 来连接向量和矩阵，而不是 ``c``, ``rbind`` 和 ``cbind``
- Julia 的范围对象如 ``a:b`` 与 R 中的定义向量的符号不同。它是一个特殊的对象，用于无高内存开销的迭代。要把范围对象转换为向量，应该用方括号把范围对象括起来 ``[a:b]``
- Julia 有许多函数可以修改它们的参数。例如， ``sort(v)`` 和 ``sort!(v)`` 函数中，带感叹号的可以修改 ``v``
- ``colMeans()`` 和 ``rowMeans()``, ``size(m, 1)`` 和 ``size(m, 2)``
- 在 R 中，需要向量化代码来提高性能。在 Julia 中与之相反：效率最高的代码通常使用非向量化的循环
- 与 R 不同，Julia 中没有延时求值
- 不提供 ``NULL`` 类型
- 目前没有命名参数，将来计划会有
- Julia 中没有与 R 的 ``assign`` 或 ``get`` 所等价的语句
