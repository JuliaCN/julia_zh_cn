.. _man-noteworthy-differences:

******************
 与其它语言的区别
******************

与 MATLAB 的区别
----------------

Julia 的语法和 MATLAB 很像。但 Julia 不是简单地复制 MATLAB ，它们有很多句法和功能上的区别。以下是一些值得注意的区别：

-  数组用方括号来索引， ``A[i,j]``
-  数组是用引用来赋值的。在 ``A=B`` 之后，对 ``B`` 赋值也会修改 ``A``
-  使用引用来传递和赋值。如果一个函数修改了数组，调用函数会发现值也变了
-  Matlab 把赋值和分配内存合并成了一个语句。比如：
   ``a(4) = 3.2`` 会创建一个数组 ``a = [0 0 0 3.2]`` ，即为a分配了内存并且将每个元素初始化为0,然后为第四个元素赋值3.2，而 ``a(5) = 7`` 会为数组a增加长度，并且给第五个元素赋值7。
   Julia 把赋值和分配内存分开了：
   如果 ``a`` 长度为4, ``a[5] = 7`` 会抛出一个错误。 Julia 有一个专用的 ``push!`` 函数来向 ``Vectors`` 里增加元素。并且远比Matlab的 ``a(end+1) = val`` 来的高效。
-  虚数单位 ``sqrt(-1)`` 用 ``im`` 来表示
-  Literal numbers without a decimal point (such as ``42``) create integers
   instead of floating point numbers. Arbitrarily large integer
   literals are supported. But this means that some operations such as
   ``2^-1`` will throw a domain error as the result is not an integer (see
   :ref:`the FAQ entry on domain errors <man-domain-error>` for details).
-  多返回值和多重赋值需要使用圆括号，如 ``return (a, b)`` 和 ``(a, b) = f(x)``
-  Julia 有一维数组。列向量的长度为 ``N`` ，而不是 ``Nx1`` 。例如， ``rand(N)`` 生成的是一维数组
-  使用语法 ``[x,y,z]`` 来连接标量或数组，连接发生在第一维度（“垂直”）上。对于第二维度（“水平”）上的连接，需要使用空格，如 ``[x y z]`` 。   要想构造块矩阵，尽量使用语法 ``[a b; c d]``
-  ``a:b`` 和 ``a:b:c`` 中的冒号，用来构造 ``Range`` 对象。使用 ``linspace`` 构造一个满向量，或者通过使用方括号来“连接”范围，如 ``[a:b]``
-  函数返回须使用 ``return`` 关键字，而不是把它们列在函数定义中（详见 :ref:`man-return-keyword` ）
-  一个文件可以包含多个函数，文件被载入时，所有的函数定义都是外部可见的
-  ``sum``, ``prod``, ``max`` 等约简操作，如果被调用时参数只有一个，作用域是数组的所有元素，如 ``sum(A)``
-  ``sort`` 等函数，默认按列方向操作。（ ``sort(A)`` 等价于 ``sort(A,1)`` ）。要想排序 ``1xN`` 的矩阵，使用 ``sort(A,2)``
-  即使是无参数的函数，也要使用圆括号，如 ``tic()`` 和 ``toc()``
-  表达式结尾不要使用分号。表达式的结果不会自动显示（除非在交互式提示符下）。 ``println`` 函数可以用来打印值并换行
-  若 ``A`` 和 ``B`` 是数组， ``A == B`` 并不返回布尔值数组。应该使用 ``A .== B`` 。其它布尔值运算符可以类比， ``<``, ``>``, ``!=`` 等
-  符号 ``&`` 、``|`` 和 ``$`` 表示位运算“和”、“或”以及“异或”。它们和python中的位运算符有着相同的运算符优先级，和c语言中的位运算符优先级并不一样。
   它们能被应用在标量上或者应用在两个数组间（对每个相同位置的元素分别进行逻辑运算，返回一个由结果组成的新数组）。
   值得注意的是它们的运算符优先级，别忘了括号:
   如果想要判断变量 ``A`` 是等于1还是2, 要这样写 ``(A .== 1) | (A .== 2)`` 。
-  可以用 ``...`` 把集合中的元素作为参数传递给函数，如 ``xs=[1,2]; f(xs...)``
-  Julia 中 ``svd`` 返回的奇异值是向量而不是完整的对角矩阵
-  Julia 中 ``...`` 不用来将一行代码拆成多行。Instead, incomplete
   expressions automatically continue onto the next line.
-  变量 ``ans`` 是交互式会话中执行的最后一条表达式的值；以其它方式执行的表达式的值，不会赋值给它
-  The closest analog to Julia's ``types`` are Matlab's
   ``classes``. Matlab's ``structs`` behave somewhere between Julia's
   ``types`` and ``Dicts``; in particular, if you need to be able to add
   fields to a ``struct`` on-the-fly, use a ``Dict`` rather than a
   ``type``.

与 R 的区别
-----------

Julia 也想成为数据分析和统计编程的高效语言。与 R 的区别：

- 使用 ``=`` 赋值，不提供 ``<-`` 或 ``<<-`` 等箭头式运算符
- 用方括号构造向量。Julia 中 ``[1, 2, 3]`` 等价于 R 中的 ``c(1, 2, 3)``
- Julia 的矩阵运算比 R 更接近传统数学语言。如果 ``A`` 和 ``B`` 是矩阵，那么矩阵乘法在 Julia 中为 ``A * B`` ， R 中为 ``A %*% B`` 。在 R 中，第一个语句表示的是逐元素的 Hadamard 乘法。要进行逐元素点乘，Julia 中为 ``A .* B``
- 使用 ``'`` 运算符做矩阵转置。 Julia 中 ``A'`` 等价于 R 中 ``t(A)``
- 写 ``if`` 语句或 ``for`` 循环时不需要写圆括号：应写 ``for i in [1, 2, 3]`` 而不是 ``for (i in c(1, 2, 3))`` ；应写 ``if i == 1`` 而不是 ``if (i == 1)``
- ``0`` 和 ``1`` 不是布尔值。不能写 ``if (1)`` ，因为 ``if`` 语句仅接受布尔值作为参数。应写成 ``if true``
- 不提供 ``nrow`` 和 ``ncol`` 。应该使用 ``size(M, 1)`` 替代 ``nrow(M)`` ；使用 ``size(M, 2)`` 替代 ``ncol(M)``
- Julia 的 SVD 默认为非 thinned ，与 R 不同。要得到与 R 一样的结果，应该对矩阵 ``X`` 调用 ``svd(X, true)``
- Julia 区分标量、向量和矩阵。在 R 中， ``1`` 和 ``c(1)`` 是一样的。在 Julia 中，它们完全不同。例如若 ``x`` 和 ``y`` 为向量，则 ``x' * y`` 是一个单元素向量，而不是标量。要得到标量，应使用 ``dot(x, y)``
- Julia 中的 ``diag()`` 和 ``diagm()`` 与 R 中的不同
- Julia 不能在赋值语句左侧调用函数：不能写 ``diag(M) = ones(n)``
- Julia 不赞成把 main 命名空间塞满函数。大多数统计学函数可以在 `扩展包 <http://pkg.julialang.org/>`_ 中找到，比如 DataFrames 和 Distributions 包：

	- `Distributions 包 <https://github.com/JuliaStats/Distributions.jl>`_ 提供了概率分布函数.
	- `DataFrames 包 <https://github.com/JuliaStats/DataFrames.jl>`_ 提供了数据框架
	- `GLM 扩展包 <https://github.com/JuliaStats/GLM.jl>`_ 提供了广义的线性模型.

- Julia 提供了多元组和哈希表，但不提供 R 的列表。当返回多项时，应该使用多元组：不要使用 ``list(a = 1, b = 2)`` ，应该使用 ``(1, 2)``
- 鼓励自定义类型。Julia 的类型比 R 中的 S3 或 S4 对象简单。Julia 的重载系统使 ``table(x::TypeA)`` 和 ``table(x::TypeB)`` 等价于 R 中的 ``table.TypeA(x)`` 和 ``table.TypeB(x)``
- 在 Julia 中，传递值和赋值是靠引用。如果一个函数修改了数组，调用函数会发现值也变了。这与 R 非常不同，这使得在大数据结构上进行新函数操作非常高效
- 使用 ``hcat`` 和 ``vcat`` 来连接向量和矩阵，而不是 ``c``, ``rbind`` 和 ``cbind``
- Julia 的范围对象如 ``a:b`` 与 R 中的定义向量的符号不同。它是一个特殊的对象，用于低内存开销的迭代。要把范围对象转换为向量，应该用方括号把范围对象括起来 ``[a:b]``
- ``max``, ``min`` are the equivalent of ``pmax`` and ``pmin`` in R, but both arguments need to have the same dimensions.  While ``maximum``, ``minimum`` replace ``max`` and ``min`` in R, there are important differences.
- The functions ``sum``, ``prod``, ``maximum``, ``minimum`` are different from their counterparts in R. They all accept one or two arguments. The first argument is an iterable collection such as an array.  If there is a second argument, then this argument indicates the dimensions, over which the operation is carried out.  For instance, let ``A=[[1 2],[3,4]]`` in Julia and ``B=rbind(c(1,2),c(3,4))`` be the same matrix in R.  Then ``sum(A)`` gives the same result as ``sum(B)``, but ``sum(A,1)`` is a row vector containing the sum over each column and ``sum(A,2)`` is a column vector containing the sum over each row.  This contrasts to the behavior of R, where ``sum(B,1)=11`` and ``sum(B,2)=12``.  If the second argument is a vector, then it specifies all the dimensions over which the sum is performed, e.g., ``sum(A,[1,2])=10``.  It should be noted that there is no error checking regarding the second argument.
- Julia 有许多函数可以修改它们的参数。例如， ``sort(v)`` 和 ``sort!(v)`` 函数中，带感叹号的可以修改 ``v``
- ``colMeans()`` 和 ``rowMeans()``, ``size(m, 1)`` 和 ``size(m, 2)``
- 在 R 中，需要向量化代码来提高性能。在 Julia 中与之相反：使用非向量化的循环通常效率最高
- 与 R 不同，Julia 中没有延时求值
- 不提供 ``NULL`` 类型
- Julia 中没有与 R 的 ``assign`` 或 ``get`` 所等价的语句

与 Python 的区别
----------------

- 对数组、字符串等索引。Julia 索引的下标是从 1 开始，而不是从 0 开始
- 索引列表和数组的最后一个元素时，Julia 使用 ``end`` ，Python 使用 -1
- Julia 中的 Comprehensions （还）没有条件 if 语句
- for, if, while, 等块的结尾需要 ``end`` ；不强制要求缩进排版
- Julia 没有代码分行的语法：如果在一行的结尾，输入已经是个完整的表达式，就直接执行；否则就继续等待输入。强迫 Julia 的表达式分行的方法是用圆括号括起来
- Julia 总是以列为主序的（类似 Fortran ），而 `numpy` 数组默认是以行为主序的（类似 C ）。如果想优化遍历数组的性能，从 `numpy` 到 Julia 时应改变遍历的顺序（详见 :ref:`man-performance-tips` ）。
