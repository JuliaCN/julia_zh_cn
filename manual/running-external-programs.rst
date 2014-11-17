.. _man-running-external-programs:

**************
 运行外部程序
**************

Julia 使用倒引号 ````` 来运行外部程序：

::

    julia> `echo hello`
    `echo hello`

它有以下几个特性：

-  倒引号并不直接运行程序，它构造一个 ``Cmd`` 对象来表示这个命令。可以用这个对象，通过管道将命令连接起来，运行，并进行读写
-  命令运行时，除非指明， Julia 并不捕获输出。它调用 ``libc`` 的 ``system`` ，命令的输出默认指向 ``stdout`` 。
-  命令运行不需要 shell 。 Julia 直接解析命令语法，对变量内插，像 shell 一样分隔单词，它遵循 shell 引用语法。命令调用 ``fork`` 和 ``exec`` 函数，作为 ``julia`` 的直接子进程。

下面是运行外部程序的例子： ::

    julia> run(`echo hello`)
    hello

``hello`` 是 ``echo`` 命令的输出，它被送到标准输出。 ``run`` 方法本身返回 ``nothing`` 。如果外部命令没有正确运行，将抛出 ``ErrorException`` 异常。 

使用 ``readall`` 读取命令的输出： ::

    julia> a=readall(`echo hello`)
    "hello\n"

    julia> (chomp(a)) == "hello"
    true

More generally, you can use ``open`` to read from or write to an external
command.  For example::

    julia> open(`less`, "w", STDOUT) do io
               for i = 1:1000
                   println(io, i)
               end
           end

.. _man-command-interpolation:

内插
----

将文件名赋给变量 ``file`` ，将其作为命令的参数。像在字符串文本中一样使用 ``$`` 做内插（详见 :ref:`man-strings` ）： ::

    julia> file = "/etc/passwd"
    "/etc/passwd"

    julia> `sort $file`
    `sort /etc/passwd`

如果文件名有特殊字符，比如 ``/Volumes/External HD/data.csv`` ，会如下显示： ::

    julia> file = "/Volumes/External HD/data.csv"
    "/Volumes/External HD/data.csv"

    julia> `sort $file`
    `sort '/Volumes/External HD/data.csv'`

文件名被单引号引起来了。Julia 知道 ``file`` 会被当做一个单变量进行内插，它自动把内容引了起来。事实上，这也不准确： ``file`` 的值并不会被 shell 解释，所以不需要真正的引起来；此处把它引起来，只是为了给用户显示。下例也可以正常运行： ::

    julia> path = "/Volumes/External HD"
    "/Volumes/External HD"

    julia> name = "data"
    "data"

    julia> ext = "csv"
    "csv"

    julia> `sort $path/$name.$ext`
    `sort '/Volumes/External HD/data.csv'`

如果 *要* 内插多个单词，应使用数组（或其它可迭代容器）： ::

    julia> files = ["/etc/passwd","/Volumes/External HD/data.csv"]
    2-element ASCIIString Array:
     "/etc/passwd"                  
     "/Volumes/External HD/data.csv"


    julia> `grep foo $files`
    `grep foo /etc/passwd '/Volumes/External HD/data.csv'`

如果数组内插为 shell 单词的一部分，Julia 会模仿 shell 的 ``{a,b,c}`` 参数生成的行为： ::

    julia> names = ["foo","bar","baz"]
    3-element ASCIIString Array:
     "foo"
     "bar"
     "baz"

    julia> `grep xylophone $names.txt`
    `grep xylophone foo.txt bar.txt baz.txt`

如果将多个数组内插进同一个单词，Julia 会模仿 shell 的笛卡尔乘积生成的行为： ::

    julia> names = ["foo","bar","baz"]
    3-element ASCIIString Array:
     "foo"
     "bar"
     "baz"

    julia> exts = ["aux","log"]
    2-element ASCIIString Array:
     "aux"
     "log"

    julia> `rm -f $names.$exts`
    `rm -f foo.aux foo.log bar.aux bar.log baz.aux baz.log`

不构造临时数组对象，直接内插文本化数组： ::

    julia> `rm -rf $["foo","bar","baz","qux"].$["aux","log","pdf"]`
    `rm -rf foo.aux foo.log foo.pdf bar.aux bar.log bar.pdf baz.aux baz.log baz.pdf qux.aux qux.log qux.pdf`

引用
----

命令复杂时，有时需要使用引号。来看一个 perl 的命令： ::

    sh$ perl -le '$|=1; for (0..3) { print }'
    0
    1
    2
    3

再看个使用双引号的命令： ::

    sh$ first="A"
    sh$ second="B"
    sh$ perl -le '$|=1; print for @ARGV' "1: $first" "2: $second"
    1: A
    2: B

一般来说，Julia 的倒引号语法支持将 shell 命令原封不动的复制粘贴进来，且转义、引用、内插等行为可以原封不动地正常工作。唯一的区别是，内插被集成进了 Julia 中： ::

    julia> `perl -le '$|=1; for (0..3) { print }'`
    `perl -le '$|=1; for (0..3) { print }'`

    julia> run(ans)
    0
    1
    2
    3

    julia> first = "A"; second = "B";

    julia> `perl -le 'print for @ARGV' "1: $first" "2: $second"`
    `perl -le 'print for @ARGV' '1: A' '2: B'`

    julia> run(ans)
    1: A
    2: B

当需要在 Julia 中运行 shell 命令时，先试试复制粘贴。Julia 会先显示出来命令，可以据此检查内插是否正确，再去运行命令。

管道
----

Shell 元字符，如 ``|``, ``&``, 及 ``>`` 在 Julia 倒引号语法中并是不特殊字符。倒引号中的管道符仅仅是文本化的管道字符 “\|” 而已： ::

    julia> run(`echo hello | sort`)
    hello | sort

在 Julia 中要想构造管道，应在 ``Cmd`` 间使用 ``|>`` 运算符： ::

    julia> run(`echo hello` |> `sort`)
    hello

继续看个例子： ::

    julia> run(`cut -d: -f3 /etc/passwd` |> `sort -n` |> `tail -n5`)
    210
    211
    212
    213
    214

它打印 UNIX 系统五个最高级用户的 ID 。 ``cut``, ``sort`` 和 ``tail`` 命令都作为当前 ``julia`` 进程的直接子进程运行，shell 进程没有介入。Julia 自己来设置管道，连接文件描述符。

Julia 可以并行运行多个命令： ::

    julia> run(`echo hello` & `echo world`)
    world
    hello

输出顺序是非确定性的。两个 ``echo`` 进程几乎同时开始，它们竞争 ``stdout`` 描述符的写操作，这个描述符被两个进程和 ``julia`` 进程所共有。使用管道，可将这些进程的输出传递给其它程序： ::

    julia> run(`echo world` & `echo hello` |> `sort`)
    hello
    world

来看一个复杂的使用 Julia 来调用 perl 命令的例子： ::

    julia> prefixer(prefix, sleep) = `perl -nle '$|=1; print "'$prefix' ", $_; sleep '$sleep';'`

    julia> run(`perl -le '$|=1; for(0..9){ print; sleep 1 }'` |> prefixer("A",2) & prefixer("B",2))
    A   0
    B   1
    A   2
    B   3
    A   4
    B   5
    A   6
    B   7
    A   8
    B   9

这是一个单生产者双并发消费者的经典例子：一个 ``perl`` 进程生产从 0 至 9 的 10 行数，两个并行的进程消费这些结果，其中一个给结果加前缀  “A”，另一个加前缀 “B”。我们不知道哪个消费者先消费第一行，但一旦开始，两个进程交替消费这些行。（在 Perl 中设置 ``$|=1`` ，可使打印表达式先清空 ``stdout`` 句柄；否则输出会被缓存并立即打印给管道，结果将只有一个消费者进程在读取。）

再看个更复杂的多步的生产者-消费者的例子： ::

    julia> run(`perl -le '$|=1; for(0..9){ print; sleep 1 }'` |>
               prefixer("X",3) & prefixer("Y",3) & prefixer("Z",3) |>
               prefixer("A",2) & prefixer("B",2))
    B   Y   0
    A   Z   1
    B   X   2
    A   Y   3
    B   Z   4
    A   X   5
    B   Y   6
    A   Z   7
    B   X   8
    A   Y   9

此例和前例类似，单有消费者分两步，且两步的延迟不同。

强烈建议你亲手试试这些例子，看看它们是如何运行的。
