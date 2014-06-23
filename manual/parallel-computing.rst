.. _man-parallel-computing:

**********
 并行计算
**********

Julia 提供了一个基于消息传递的多处理器环境，能够同时在多处理器上使用独立的内存空间运行程序。

Julia 的消息传递与 MPI [#mpi2rma]_ 等环境不同。Julia 中的通信是“单边”的，即程序员只需要管理双处理器运算中的一个处理器即可。

Julia 中的并行编程基于两个原语：*remote references* 和 *remote calls* 。remote reference 对象，用于从任意的处理器，查阅指定处理器上存储的对象。 remote call 请求，用于一个处理器对另一个（也有可能是同一个）处理器调用某个函数处理某些参数。
remote call 返回 remote reference 对象。 remote call 是立即返回的；调用它的处理器继续执行下一步操作，而 remote call 继续在某处执行。可以对 remote
reference 调用 ``wait`` ，以等待 remote call 执行完毕，然后通过 ``fetch`` 获取结果的完整值。使用 ``put`` 可将值存储到 remote reference 。

通过 ``julia -p n`` 启动，可以在本地机器上提供 ``n`` 个处理器。一般 ``n`` 等于机器上 CPU 内核个数：

::

    $ ./julia -p 2

    julia> r = remotecall(2, rand, 2, 2)
    RemoteRef(2,1,5)

    julia> fetch(r)
    2x2 Float64 Array:
     0.60401   0.501111
     0.174572  0.157411

    julia> s = @spawnat 2 1 .+ fetch(r)
    RemoteRef(2,1,7)

    julia> fetch(s)
    2x2 Float64 Array:
     1.60401  1.50111
     1.17457  1.15741

``remote_call`` 的第一个参数是要进行这个运算的处理器索引值。Julia 中大部分并行编程不查询特定的处理器或可用处理器的个数，但可认为 ``remote_call`` 是个为精细控制所提供的低级接口。第二个参数是要调用的函数，剩下的参数是该函数的参数。此例中，我们先让处理器 2 构造一个 2x2 的随机矩阵，然后我们在结果上加 1 。两个计算的结果保存在两个 remote reference 中，即 ``r`` 和 ``s`` 。 ``@spawnat`` 宏在由第一个参数指明的处理器上，计算第二个参数中的表达式。

``remote_call_fetch`` 函数可以立即获取要在远端计算的值。它等价于 ``fetch(remote_call(...))`` ，但比之更高效：

::

    julia> remotecall_fetch(2, getindex, r, 1, 1)
    0.10824216411304866

``getindex(r,1,1)`` :ref:`等价于 <man-array-indexing>` ``r[1,1]`` ，因此，这个调用获取 remote reference 对象 ``r`` 的第一个元素。

``remote_call`` 语法不太方便。 ``@spawn`` 宏简化了这件事儿，它对表达式而非函数进行操作，并自动选取在哪儿进行计算： ::

    julia> r = @spawn rand(2,2)
    RemoteRef(1,1,0)

    julia> s = @spawn 1 .+ fetch(r)
    RemoteRef(1,1,1)

    julia> fetch(s)
    1.10824216411304866 1.13798233877923116
    1.12376292706355074 1.18750497916607167

注意，此处用 ``1 .+ fetch(r)`` 而不是 ``1 .+ r`` 。这是因为我们不知道代码在何处运行，而 ``fetch`` 会将需要的 ``r`` 移到做加法的处理器上。此例中， ``@spawn`` 很聪明，它知道在有 ``r`` 对象的处理器上进行计算，因而 ``fetch`` 将不做任何操作。

（ ``@spawn`` 不是内置函数，而是 Julia 定义的 :ref:`宏 <man-macros>` ）

所有执行程序代码的处理器上，都必须能获得程序代码。例如，输入： ::

    julia> function rand2(dims...)
             return 2*rand(dims...)
           end

    julia> rand2(2,2)
    2x2 Float64 Array:
     0.153756  0.368514
     1.15119   0.918912

    julia> @spawn rand2(2,2)
    RemoteRef(1,1,1)

    julia> @spawn rand2(2,2)
    RemoteRef(2,1,2)

    julia> exception on 2: in anonymous: rand2 not defined 

进程 1 知道 ``rand2`` 函数，但进程 2 不知道。 ``require`` 函数自动在当前所有可用的处理器上载入源文件，使所有的处理器都能运行代码： ::

    julia> require("myfile")

在集群中，文件（及递归载入的任何文件）的内容会被发送到整个网络。可以使用 ``@everywhere`` 宏在所有处理器上执行命令： ::

    julia> @everywhere id = myid()

    julia> remotecall_fetch(2, ()->id)
    2

    @everywhere include("defs.jl")

A file can also be preloaded on multiple processes at startup, and a driver script can be used to drive the computation::

    julia -p <n> -L file1.jl -L file2.jl driver.jl
    
Each process has an associated identifier. The process providing the interactive julia prompt
always has an id equal to 1, as would the julia process running the driver script in the
example above.
The processes used by default for parallel operations are referred to as ``workers``.
When there is only one process, process 1 is considered a worker. Otherwise, workers are
considered to be all processes other than process 1.

The base Julia installation has in-built support for two types of clusters: 

    - A local cluster specified with the ``-p`` option as shown above.  
    
    - A cluster spanning machines using the ``--machinefile`` option. This uses a passwordless 
      ``ssh`` login to start julia worker processes (from the same path as the current host)
      on the specified machines.
    
Functions ``addprocs``, ``rmprocs``, ``workers``, and others are available as a programmatic means of 
adding, removing and querying the processes in a cluster.

Other types of clusters can be supported by writing your own custom ClusterManager. See section on 
ClusterManagers.

数据移动
--------

并行计算中，消息传递和数据移动是最大的开销。减少这两者的数量，对性能至关重要。

``fetch`` 是显式的数据移动操作，它直接要求将对象移动到当前机器。 ``@spawn`` （及相关宏）也进行数据移动，但不是显式的，因而被称为隐式数据移动操作。对比如下两种构造随机矩阵并计算其平方的方法： ::

    # method 1
    A = rand(1000,1000)
    Bref = @spawn A^2
    ...
    fetch(Bref)

    # method 2
    Bref = @spawn rand(1000,1000)^2
    ...
    fetch(Bref)

方法 1 中，本地构造了一个随机矩阵，然后将其传递给做平方计算的处理器。方法 2 中，在同一处理器构造随机矩阵并进行平方计算。因此，方法 2 比方法 1 移动的数据少得多。

并行映射和循环
--------------

大部分并行计算不需要移动数据。最常见的是蒙特卡罗仿真。下例使用 ``@spawn`` 在两个处理器上仿真投硬币。先在 ``count_heads.jl`` 中写如下函数： ::

    function count_heads(n)
        c::Int = 0
        for i=1:n
            c += randbool()
        end
        c
    end

在两台机器上做仿真，最后将结果加起来： ::

    require("count_heads")

    a = @spawn count_heads(100000000)
    b = @spawn count_heads(100000000)
    fetch(a)+fetch(b)

在多处理器上独立地进行迭代运算，然后用一些函数把它们的结果综合起来。综合的过程称为 *约简* 。

上例中，我们显式调用了两个 ``@spawn`` 语句，它将并行计算限制在两个处理器上。要在任意个数的处理器上运行，应使用 *并行 for 循环* ，它在 Julia 中应写为： ::

    nheads = @parallel (+) for i=1:200000000
      int(randbool())
    end

这个构造实现了给多处理器分配迭代的模式，并且使用特定约简来综合结果（此例中为 ``(+)`` ）。

注意，尽管并行 for 循环看起来和一组 for 循环差不多，但它们的行为有很大区别。第一，循环不是按顺序进行的。第二，写进变量或数组的值不是全局可见的，因为迭代运行在不同的处理器上。并行循环内使用的所有变量都会被复制、广播到每个处理器。

下列代码并不会按照预想运行： ::

    a = zeros(100000)
    @parallel for i=1:100000
      a[i] = i
    end

如果不需要，可以省略约简运算符。但此代码不会初始化 ``a`` 的所有元素，因为每个处理器上都只有独立的一份儿。应避免类似的并行 for 循环。但是我们可以使用分布式数组来规避这种情形，后面我们会讲。

如果“外部”变量是只读的，就可以在并行循环中使用它： ::

    a = randn(1000)
    @parallel (+) for i=1:100000
      f(a[randi(end)])
    end

有时我们不需要约简，仅希望将函数应用到某个范围的整数（或某个集合的元素）上。这时可以使用 *并行映射* ``pmap`` 函数。下例中并行计算几个大随机矩阵的奇异值： ::

    M = {rand(1000,1000) for i=1:10}
    pmap(svd, M)

被调用的函数需处理大量工作时使用 ``pmap`` ，反之，则使用 ``@parallel for`` 。

Synchronization With Remote References
--------------------------------------

Scheduling
----------

Julia's parallel programming platform uses
:ref:`man-tasks` to switch among
multiple computations. Whenever code performs a communication operation
like ``fetch`` or ``wait``, the current task is suspended and a
scheduler picks another task to run. A task is restarted when the event
it is waiting for completes.

For many problems, it is not necessary to think about tasks directly.
However, they can be used to wait for multiple events at the same time,
which provides for *dynamic scheduling*. In dynamic scheduling, a
program decides what to compute or where to compute it based on when
other jobs finish. This is needed for unpredictable or unbalanced
workloads, where we want to assign more work to processes only when
they finish their current tasks.

As an example, consider computing the singular values of matrices of
different sizes::

    M = {rand(800,800), rand(600,600), rand(800,800), rand(600,600)}
    pmap(svd, M)

If one process handles both 800x800 matrices and another handles both
600x600 matrices, we will not get as much scalability as we could. The
solution is to make a local task to "feed" work to each process when
it completes its current task. This can be seen in the implementation of
``pmap``::

    function pmap(f, lst)
        np = nprocs()  # determine the number of processes available
        n = length(lst)
        results = cell(n)
        i = 1
        # function to produce the next work item from the queue.
        # in this case it's just an index.
        nextidx() = (idx=i; i+=1; idx)
        @sync begin
            for p=1:np
                if p != myid() || np == 1 
                    @async begin
                        while true
                            idx = nextidx()
                            if idx > n
                                break
                            end
                            results[idx] = remotecall_fetch(p, f, lst[idx])
                        end
                    end
                end
            end
        end
        results
    end

``@async`` is similar to ``@spawn``, but only runs tasks on the
local process. We use it to create a "feeder" task for each process.
Each task picks the next index that needs to be computed, then waits for
its process to finish, then repeats until we run out of indexes. Note
that the feeder tasks do not begin to execute until the main task
reaches the end of the ``@sync`` block, at which point it surrenders
control and waits for all the local tasks to complete before returning
from the function. The feeder tasks are able to share state via
``nextidx()`` because they all run on the same process. No locking is
required, since the threads are scheduled cooperatively and not
preemptively. This means context switches only occur at well-defined
points: in this case, when ``remotecall_fetch`` is called.

分布式数组
----------

并行计算综合使用多个机器上的内存资源，因而可以使用在一个机器上不能实现的大数组。这时，可使用分布式数组，每个处理器仅对它所拥有的那部分数组进行操作。

分布式数组（或 *全局对象* ）逻辑上是个单数组，但它分为很多块儿，每个处理器上保存一块儿。但对整个数组的运算与在本地数组的运算是一样的，并行计算是隐藏的。

分布式数组是用 ``DArray`` 类型来实现的。 ``DArray`` 的元素类型和维度与 ``Array`` 一样。 ``DArray`` 的数据的分布，是这样实现的：它把索引空间在每个维度都分成一些小块。

一些常用分布式数组可以使用 ``d`` 开头的函数来构造： ::

    dzeros(100,100,10)
    dones(100,100,10)
    drand(100,100,10)
    drandn(100,100,10)
    dfill(x, 100,100,10)

最后一个例子中，数组的元素由值 ``x`` 来初始化。这些函数自动选取某个分布。如果要指明使用哪个进程，如何分布数据，应这样写： ::

    dzeros((100,100), [1:4], [1,4])

The second argument specifies that the array should be created on processors
1 through 4. When dividing data among a large number of processes,
one often sees diminishing returns in performance. Placing ``DArray``\ s
on a subset of processes allows multiple ``DArray`` computations to
happen at once, with a higher ratio of work to communication on each
process.

The third argument specifies a distribution; the nth element of
this array specifies how many pieces dimension n should be divided into.
In this example the first dimension will not be divided, and the second
dimension will be divided into 4 pieces. Therefore each local chunk will be
of size ``(100,25)``. Note that the product of the distribution array must
equal the number of processes.

``distribute(a::Array)`` 可用来将本地数组转换为分布式数组。

``localpart(a::DArray)`` 可用来获取 ``DArray`` 本地存储的部分。

``localindexes(a::DArray)`` 返回本地进程所存储的维度索引值范围多元组。

``convert(Array, a::DArray)`` 将所有数据综合到本地进程上。

使用索引值范围来索引 ``DArray`` （方括号）时，会创建 ``SubArray`` 对象，但不复制数据。


构造分布式数组
--------------

``DArray`` 的构造函数是 ``darray`` ，它的声明如下： ::

    DArray(init, dims[, procs, dist])

``init`` 函数的参数，是索引值范围多元组。这个函数在本地声名一块分布式数组，并用指定索引值来进行初始化。 ``dims`` 是整个分布式数组的维度。 ``procs`` 是可选的，指明一个存有要使用的进程 ID 的向量 。 ``dist`` 是一个整数向量，指明分布式数组在每个维度应该被分成几块。

最后俩参数是可选的，忽略的时候使用默认值。

下例演示如果将本地数组 ``fill`` 的构造函数更改为分布式数组的构造函数： ::

    dfill(v, args...) = DArray(I->fill(v, map(length,I)), args...)

此例中 ``init`` 函数仅对它构造的本地块的维度调用 ``fill`` 。

分布式数组运算
--------------

At this time, distributed arrays do not have much functionality. Their
major utility is allowing communication to be done via array indexing, which
is convenient for many problems. As an example, consider implementing the
"life" cellular automaton, where each cell in a grid is updated according
to its neighboring cells. To compute a chunk of the result of one iteration,
each process needs the immediate neighbor cells of its local chunk. The
following code accomplishes this::

    function life_step(d::DArray)
        DArray(size(d),procs(d)) do I
            top   = mod(first(I[1])-2,size(d,1))+1
            bot   = mod( last(I[1])  ,size(d,1))+1
            left  = mod(first(I[2])-2,size(d,2))+1
            right = mod( last(I[2])  ,size(d,2))+1

            old = Array(Bool, length(I[1])+2, length(I[2])+2)
            old[1      , 1      ] = d[top , left]   # left side
            old[2:end-1, 1      ] = d[I[1], left]
            old[end    , 1      ] = d[bot , left]
            old[1      , 2:end-1] = d[top , I[2]]
            old[2:end-1, 2:end-1] = d[I[1], I[2]]   # middle
            old[end    , 2:end-1] = d[bot , I[2]]
            old[1      , end    ] = d[top , right]  # right side
            old[2:end-1, end    ] = d[I[1], right]
            old[end    , end    ] = d[bot , right]

            life_rule(old)
        end
    end

As you can see, we use a series of indexing expressions to fetch
data into a local array ``old``. Note that the ``do`` block syntax is
convenient for passing ``init`` functions to the ``DArray`` constructor.
Next, the serial function ``life_rule`` is called to apply the update rules
to the data, yielding the needed ``DArray`` chunk. Nothing about ``life_rule``
is ``DArray``\ -specific, but we list it here for completeness::

    function life_rule(old)
        m, n = size(old)
        new = similar(old, m-2, n-2)
        for j = 2:n-1
            for i = 2:m-1
                nc = +(old[i-1,j-1], old[i-1,j], old[i-1,j+1],
                       old[i  ,j-1],             old[i  ,j+1],
                       old[i+1,j-1], old[i+1,j], old[i+1,j+1])
                new[i-1,j-1] = (nc == 3 || nc == 2 && old[i,j])
            end
        end
        new
    end


Shared Arrays (Experimental, UNIX-only feature)
-----------------------------------------------

Shared Arrays use system shared memory to map the same array across
many processes.  While there are some similarities to a ``DArray``,
the behavior of a ``SharedArray`` is quite different. In a ``DArray``,
each process has local access to just a chunk of the data, and no two
processes share the same chunk; in contrast, in a ``SharedArray`` each
"participating" process has access to the entire array.  A
``SharedArray`` is a good choice when you want to have a large amount
of data jointly accessible to two or more processes on the same machine.

``SharedArray`` indexing (assignment and accessing values) works just
as with regular arrays, and is efficient because the underlying memory
is available to the local process.  Therefore, most algorithms work
naturally on ``SharedArrays``, albeit in single-process mode.  In
cases where an algorithm insists on an ``Array`` input, the underlying
array can be retrieved from a ``SharedArray`` by calling ``sdata(S)``.
For other ``AbstractArray`` types, ``sdata`` just returns the object
itself, so it's safe to use ``sdata`` on any Array-type object.

The constructor for a shared array is of the form 
  ``SharedArray(T::Type, dims::NTuple; init=false, pids=Int[])``
which creates a shared array of a bitstype ``T`` and size ``dims``
across the processes specified by ``pids``.  Unlike distributed
arrays, a shared array is accessible only from those participating
workers specified by the ``pids`` named argument (and the creating
process too, if it is on the same host).
  
If an ``init`` function, of signature ``initfn(S::SharedArray)``, is
specified, it is called on all the participating workers.  You can
arrange it so that each worker runs the ``init`` function on a
distinct portion of the array, thereby parallelizing initialization.

Here's a brief example::

  julia> addprocs(3)
  3-element Array{Any,1}:
   2
   3
   4

  julia> S = SharedArray(Int, (3,4), init = S -> S[localindexes(S)] = myid())
  3x4 SharedArray{Int64,2}:
   2  2  3  4
   2  3  3  4
   2  3  4  4

  julia> S[3,2] = 7
  7

  julia> S
  3x4 SharedArray{Int64,2}:
   2  2  3  4
   2  3  3  4
   2  7  4  4

``localindexes`` provides disjoint one-dimensional ranges of indexes,
and is sometimes convenient for splitting up tasks among processes.
You can, of course, divide the work any way you wish::

  julia> S = SharedArray(Int, (3,4), init = S -> S[myid()-1:nworkers():length(S)] = myid())
  3x4 SharedArray{Int64,2}:
   2  2  2  2
   3  3  3  3
   4  4  4  4

Since all processes have access to the underlying data, you do have to
be careful not to set up conflicts.  For example::

  @sync begin
      for p in workers()
          @async begin
              remotecall_wait(p, fill!, S, p)
          end
      end
  end

would result in undefined behavior: because each process fills the
*entire* array with its own ``pid``, whichever process is the last to
execute (for any particular element of ``S``) will have its ``pid``
retained.


ClusterManagers
---------------

Julia worker processes can also be spawned on arbitrary machines,
enabling Julia's natural parallelism to function quite transparently
in a cluster environment. The ``ClusterManager`` interface provides a
way to specify a means to launch and manage worker processes. For
example, ``ssh`` clusters are also implemented using a ``ClusterManager``::

    immutable SSHManager <: ClusterManager
        launch::Function
        manage::Function
        machines::AbstractVector

        SSHManager(; machines=[]) = new(launch_ssh_workers, manage_ssh_workers, machines)
    end

    function launch_ssh_workers(cman::SSHManager, np::Integer, config::Dict)
        ...
    end

    function manage_ssh_workers(id::Integer, config::Dict, op::Symbol)
        ...
    end

where ``launch_ssh_workers`` is responsible for instantiating new
Julia processes and ``manage_ssh_workers`` provides a means to manage
those processes, e.g. for sending interrupt signals. New processes can
then be added at runtime using ``addprocs``::

    addprocs(5, cman=LocalManager())

which specifies a number of processes to add and a ``ClusterManager`` to
use for launching those processes.

.. rubric:: Footnotes

.. [#mpi2rma] In this context, MPI refers to the MPI-1 standard. Beginning with MPI-2, the MPI standards committee introduced a new set of communication mechanisms, collectively referred to as Remote Memory Access (RMA). The motivation for adding RMA to the MPI standard was to facilitate one-sided communication patterns. For additional information on the latest MPI standard, see http://www.mpi-forum.org/docs.
