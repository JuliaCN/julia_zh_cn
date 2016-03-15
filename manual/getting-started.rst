.. _man-getting-started:

****
开始
****

Julia 的安装，不管是使用编译好的程序，还是自己从源代码编译，都很简单。按照 `这儿 <http://julialang.org/downloads/>`_ 的说明下载并安装即可。

使用交互式会话（也记为 repl），是学习 Julia 最简单的方法： ::

    $ julia
                   _
       _       _ _(_)_     |  A fresh approach to technical computing
      (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
       _ _   _| |_  __ _   |  Type "?help" for help.
      | | | | | | |/ _` |  |
      | | |_| | | | (_| |  |  Version 0.5.0-dev+2440 (2016-02-01 02:22 UTC)
     _/ |\__'_|_|_|\__'_|  |  Commit 2bb94d6 (11 days old master)
    |__/                   |  x86_64-apple-darwin13.1.0

    julia> 1 + 2
    3

    julia> ans
    3


输入 ``^D`` — ``ctrl`` 键加 ``d`` 键，或者输入 ``quit()`` ，可以退出交互式会话。交互式模式下， ``julia`` 会显示一个横幅，并提示用户来输入。一旦用户输入了完整的表达式，例如 ``1 + 2`` ，然后按回车，交互式会话就对表达式求值并返回这个值。如果输入的表达式末尾有分号，就不会显示它的值了。变量 ``ans`` 的值就是上一次计算的表达式的值，无论上一次是否被显示。变量 ``ans`` 仅适用于交互式会话，不适用于以其它方式运行的 Julia 代码。

如果想运行写在源文件 ``file.jl`` 中的代码，可以输入命令 ``include("file.jl")`` 。

要在非交互式模式下运行代码，你可以把它当做 Julia 命令行的第一个参数： ::

    $ julia script.jl arg1 arg2...

如这个例子所示，julia 后面跟着的命令行参数，被认为是程序 ``script.jl`` 的命令行参数。这些参数使用全局变量 ``ARGS`` 来传递。使用 ``-e`` 选项，也可以在命令行设置 ``ARGS`` 参数。可如下操作，来打印传递的参数： ::

    $ julia -e 'for x in ARGS; println(x); end' foo bar
    foo
    bar

也可以把代码放在一个脚本中，然后运行： ::

    $ echo 'for x in ARGS; println(x); end' > script.jl
    $ julia script.jl foo bar
    foo
    bar

定界符``--`` 可以用来将脚本文件和命令行的变量分割开来: ::

    $ julia --color=yes -O -- foo.jl arg1 arg2..


Julia 可以用 ``-p`` 或 ``--machinefile`` 选项来开启并行模式。 ``-p n`` 会发起额外的 ``n`` 个工作进程，而 ``--machinefile file`` 会为文件 ``file`` 的每一行发起一个工作进程。 ``file`` 定义的机器，必须要能经由无密码的 ``ssh`` 访问，且每个机器上的 Julia 安装的位置应完全相同，每个机器的定义为 ``[user@]host[:port] [bind_addr]`` 。 ``user`` defaults to current user,
``port`` to the standard ssh port. Optionally, in case of multi-homed hosts,
``bind_addr`` may be used to explicitly specify an interface.

如果你想让 Julia 在启动时运行一些代码，可以将代码放入 ``~/.juliarc.jl`` ：

.. raw:: latex

    \begin{CJK*}{UTF8}{mj}

::

    $ echo 'println("Greetings! 你好! 안녕하세요?")' > ~/.juliarc.jl
    $ julia
    Greetings! 你好! 안녕하세요?

    ...

.. raw:: latex

    \end{CJK*}

运行 Julia 有各种可选项： ::

    julia [options] [program] [args...]
     -v, --version            Display version information
     -h, --help               Print this message
     -q, --quiet              Quiet startup without banner
     -H, --home <dir>         Set location of julia executable

     -e, --eval <expr>        Evaluate <expr>
     -E, --print <expr>       Evaluate and show <expr>
     -P, --post-boot <expr>   Evaluate <expr> right after boot
     -L, --load <file>        Load <file> right after boot on all processors
     -J, --sysimage <file>    Start up with the given system image file

     -p <n>                   Run n local processes
     --machinefile <file>     Run processes on hosts listed in <file>

     -i                       Force isinteractive() to be true
     --no-history-file        Don't load or save history
     -f, --no-startup         Don't load ~/.juliarc.jl
     -F                       Load ~/.juliarc.jl, then handle remaining inputs
     --color={yes|no}         Enable or disable color text

     --code-coverage          Count executions of source lines
     --check-bounds={yes|no}  Emit bounds checks always or never (ignoring declarations)
     --int-literals={32|64}   Select integer literal size independent of platform

资源
----

除了本手册，还有一些其它的资源：

- `Julia 和 IJulia 使用说明 <http://math.mit.edu/~stevenj/Julia-cheatsheet.pdf>`_
- `速学 Julia <http://learnxinyminutes.com/docs/julia/>`_
- `MIT 讲师 Homer Reid 数值分析课的教程 <http://homerreid.dyndns.org/teaching/18.330/JuliaProgramming.shtml>`_
- `介绍 julia 的演讲 <https://raw.githubusercontent.com/ViralBShah/julia-presentations/master/Fifth-Elephant-2013/Fifth-Elephant-2013.pdf>`_
- `来自 MIT 的 Julia 视频教程 <http://julialang.org/blog/2013/03/julia-tutorial-MIT/>`_
- `Forio 的 Julia 教程  <http://forio.com/labs/julia-studio/tutorials/>`_
