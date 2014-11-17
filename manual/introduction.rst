.. _man-introduction:

******
 简介
******

Julia 是个灵活的动态语言，适合科学和数值计算，性能可与传统静态类型语言媲美。

Because Julia's compiler is different from the interpreters used
for languages like Python or R, you may find that Julia's performance
is unintuitive at first. If you find that something is slow, we highly
recommend reading through the
`Performance Tips <http://docs.julialang.org/en/latest/manual/performance-tips>`_
section before trying anything else. Once you understand how Julia 
works, it's easy to write code that's nearly as fast as C.

通过使用类型推断和 `即时(JIT)编译 <http://zh.wikipedia.org/zh-cn/%E5%8D%B3%E6%99%82%E7%B7%A8%E8%AD%AF>`_ ，以及 `LLVM <http://zh.wikipedia.org/wiki/LLVM>`_ ， Julia 具有可选的类型声明，重载，高性能等特性。Julia 是多编程范式的，包含指令式、函数式和面向对象编程的特征。
它提供了简易和简洁的高等数值计算，它类似于 R 、 MATLAB 和 Python ，支持一般用途的编程。
为了达到这个目的，Julia 在数学编程语言的基础上，参考了不少流行动态语言： `Lisp <http://zh.wikipedia.org/zh-cn/LISP>`_ 、 `Perl <http://zh.wikipedia.org/zh-cn/Perl>`_ 、 `Python <http://zh.wikipedia.org/zh-cn/Python>`_ 、 `Lua <http://zh.wikipedia.org/zh-cn/Lua>`_ 和 `Ruby <http://zh.wikipedia.org/zh-cn/Ruby>`_ 。

Julia 与传统动态语言最大的区别是：

-  核心语言很小；标准库是用 Julia 本身写的，如整数运算在内的基础运算
-  完善的类型，方便构造对象和做类型声明
-  基于参数类型进行函数 `重载 <http://en.wikipedia.org/wiki/Multiple_dispatch>`_
-  参数类型不同，自动生成高效、专用的代码
-  高性能，接近静态编译语言，如 C 语言

动态语言是有类型的：每个对象，不管是基础的还是用户自定义的，都有类型。许多动态语言没有类型声明，意味着它不能告诉编译器值的类型，也就不能准确的判断出类型。静态语言必须告诉编译器值的类型，类型仅存在于编译时，在运行时则不能更改。在 Julia 中，类型本身就是运行时对象，同时它也可以把信息传递给编译器。

重载函数由参数（参数列表）的类型来区别，调用函数时传入的参数类型，决定了选取哪个函数来进行调用。对于数学领域的程序设计来说，这种方式比起传统面向对象程序设计中操作属于某个对象的方法的方式更显自然。在 Julia 中运算符仅仅是函数的别名。程序员可以为新数据类型定义 “+” 的新方法，原先的代码就可以无缝地重载到新数据类型上。

因为运行时类型推断（得益于可选的类型声明），以及从开始就看重性能，Julia 的计算性能超越了其他动态语言，甚至可与静态编译语言媲美。在大数据处理的问题上，性能一直是决定性的因素：在刚刚过去的十年中，数据量还在以摩尔定律增长着。

Julia 想要变成一个前所未有的集易用、强大、高效于一体的语言。除此之外，Julia 的优势还在于：

-  免费开源（ `MIT 协议 <https://github.com/JuliaLang/julia/blob/master/LICENSE.md>`_ ）
-  自定义类型与内置类型同样高效、紧凑
-  不需要把代码向量化；非向量化的代码跑得也很快
-  为并行和分布式计算而设计
-  轻量级“绿色”线程（ `协程 <http://zh.wikipedia.org/zh-cn/%E5%8D%8F%E7%A8%8B>`_ ）
-  低调又牛逼的类型系统
-  优雅、可扩展的类型转换
-  高效支持
   `Unicode <http://zh.wikipedia.org/zh-cn/Unicode>`_, 包括且不只 `UTF-8 <http://zh.wikipedia.org/zh-cn/UTF-8>`_
-  直接调用 C 函数（不需封装或 API）
-  像 Shell 一样强大的管理其他进程的能力
-  像 Lisp 一样的宏和其他元编程工具
