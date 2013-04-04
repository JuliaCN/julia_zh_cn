.. _note-uses:

******
 心得
******

Win 下启用并行编程
------------------

官网可以下载编译好的 `Windows 版本的 Julia <https://code.google.com/p/julialang/downloads/list>`_ 。电脑中 git 若已经在环境变量 path 中配置好的，就下载体积小的那个；否则就下载体积大的那个。

想在 Win 下启用 :ref:`并行编程 <man-parallel-computing>` ，可如下操作：

-  在命令行中将 ``-p n`` 参数传递给 ``julia.bat`` 脚本
-  编辑 `julia.bat` 脚本中有 ``.exe`` 的那一行为 ``call "%JULIA_HOME%julia-release-readline.exe" -p n %*`` 
-  正常启动 Julia 后调用 ``addprocs_local(1)`` 函数来增加一个处理器

这三种方法都可以分别启用并行编程。前两者中， ``n`` 应设置为电脑 CPU 的内核数。


数字分隔符
----------

数字分隔符可以使数字位数更加清晰： ::

    julia> a = 100_000
    100000

    julia> a = 100_0000_0000
    10000000000

建议大家在写多位数字的时候，使用数字分隔符。
