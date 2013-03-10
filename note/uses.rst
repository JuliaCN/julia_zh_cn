.. _note-uses:

******
 心得
******

Win 下启用并行编程
------------------

官网可以下载编译好的 `Windows 版本的 Julia <https://code.google.com/p/julialang/downloads/list>`_ 。电脑中 git 若已经在环境变量 path 中配置好的，就下载体积小的那个；否则就下载体积大的那个。

想在 Win 下启用 :ref:`并行编程 <man-parallel-computing>`_ ，可如下操作：

a) 在命令行中将 ``-p n`` 参数传递给 ``julia.bat`` 脚本
b) 编辑 `julia.bat` 脚本中有 ``julia-release-readline`` 的那一行为 ``call \"%JULIA_HOME%julia-release-readline.exe\" -p n %*`` 
c) 正常启动 Julia 后调用 ``add_procslocal(1)`` 函数来增加一个处理器

这三种方法都可以分别启用并行编程。前两者中， ``n`` 应设置为电脑 CPU 的内核数。