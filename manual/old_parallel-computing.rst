.. _man-parallel-computing:

**********
 并行计算  
**********

Julia 提供了一个基于消息传递的多进程环境，能够同时在多处理器上使用独立的内存空间运行程序。

Julia 的消息传递与 MPI 等环境不同。Julia 中的通信是“单边”的，即程序员只需要管理双处理器运算中的一个处理器即可。

Julia 中的并行编程基于两个原语：*remote references* 和 *remote calls* 。remote reference 对象，用于从任意的处理器，查阅指定处理器上存储的对象。remote call 请求，用于一个处理器对另一个（也有可能是同一个）处理器调用某个函数处理某些参数。
remote call 返回 remote reference 对象。remote call 是立即返回的；调用它的处理器继续执行下一步操作，而remote call 继续在某处执行。可以对 remote
reference 调用 ``wait`` ，以等待 remote call 执行完毕，然后通过 ``fetch`` 获取结果的完整值。

通过 ``julia -p n`` 启动，其中 ``n`` 是本地机器上的处理器数目。一般 ``n`` 等于机器上 CPU 内核个数： ::

    $ ./julia -p 2

    julia> r = remote_call(2, rand, 2, 2)
    RemoteRef(2,1,5)

    julia> fetch(r)
    2x2 Float64 Array:
     0.60401   0.501111
     0.174572  0.157411

    julia> s = @spawnat 2 1+fetch(r)
    RemoteRef(2,1,7)

    julia> fetch(s)
    2x2 Float64 Array:
     1.60401  1.50111
     1.17457  1.15741

``remote_call`` 的第一个参数是要进行这个运算的处理器索引值。Julia 中大部分并行编程不查询特定的处理器或可用处理器的个数，但 ``remote_call`` 是个为高级控制所提供的低级接口。第二个参数时要调用的函数，剩下的参数是该函数的参数。此例中，我们先让处理器 2 构造一个 2x2 的随机矩阵，然后我们在结果上加 1 。两个计算的结果保存在两个 remote reference 中，即 ``r`` 和 ``s`` 。 ``@spawnat`` 宏在由第一个参数指明的处理器上，计算第二个参数中的表达式。

``remote_call_fetch`` 函数可以立即获取要在远端计算的值。它等价于 ``fetch(remote_call(...))`` ，但比之更高效： ::

    julia> remote_call_fetch(2, getindex, r, 1, 1)
    0.10824216411304866

``getindex(r,1,1)`` :ref:`等价于 <man-array-indexing>` ``r[1,1]`` ，因此，这个调用获取 remote reference 对象 ``r`` 的第一个元素。

``remote_call`` 语法不太方便。 ``@spawn`` 宏简化了这件事儿，它对表达式而非函数进行操作，并自动选取在哪个处理器进行计算： ::

    julia> r = @spawn rand(2,2)
    RemoteRef(1,1,0)

    julia> s = @spawn 1+fetch(r)
    RemoteRef(1,1,1)

    julia> fetch(s)
    1.10824216411304866 1.13798233877923116
    1.12376292706355074 1.18750497916607167

注意，此处用 ``1+fetch(r)`` 而不是 ``1+r`` 。这是因为我们不知道代码在何处运行，而 ``fetch`` 会将需要的 ``r`` 移到做加法的处理器上。实际上， ``@spawn`` 很聪明，它知道在有 ``r`` 对象的处理器上进行计算，因而 ``fetch`` 将不做任何操作。

（ ``@spawn`` 不是内置函数，而是 Julia 定义的 :ref:`宏 <man-macros>` ）

所有执行程序代码的处理器上，都必须有程序代码。例如，输入::

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

处理器 1 知道 ``rand2`` 函数，但处理器 2 不知道。 ``require`` 函数自动在当前所有可用的处理器上载入源文件，使所有的处理器都能运行代码： ::

    julia> require("myfile")

在集群中，文件（及递归载入的任何文件）的内容会被发送到整个网络。

数据移动
--------

并行计算中，消息传递和数据移动是最大的开销。减少这两者的数量，对性能至关重要。

``fetch`` 是显式的数据移动操作，它直接要求将对象移动到当前机器。 ``@spawn`` （及相关宏）也进行数据移动，但不明显，因而被称为隐含数据移动操作。对比如下两种构造随机矩阵并计算其平方的方法： ::

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

上例中，我们指明了 ``@spawn`` 语句，它将并行计算限制在两个处理器上。要在任意个数的处理器上运行，应使用 *并行 for 循环* ，它在 Julia 中应写为： ::

    nheads = @parallel (+) for i=1:200000000
      randbool()
    end

这个构造实现了给多处理器分配迭代的模式，并且使用特殊约简来综合结果（此例中为 ``(+)`` ）。

注意，尽管并行 for 循环看起来和一组 for 循环差不多，但它们的行为有很大区别。第一，循环不是按顺序进行的。第二，写进变量或数组的值不是全局可见的，因为迭代运行在不同的处理器上。并行循环内使用的所有变量都会被复制、广播到每个处理器。

下列代码并不会按照预想运行： ::

    a = zeros(100000)
    @parallel for i=1:100000
      a[i] = i
    end

如果不需要，可以省略约简运算符。但此代码不会初始化 ``a`` 的所有元素，因为每个处理器上都只有独立的一份儿。应避免类似的并行 for 循环。

如果“外部”变量是只读的，可以在并行循环中使用它： ::

    a = randn(1000)
    @parallel (+) for i=1:100000
      f(a[randi(end)])
    end

有时我们不需要约简，仅希望将函数应用到某个范围的整数（或某个集合的元素）上。这时可以使用 *并行映射* ``pmap`` 函数。下例中并行计算几个大随机矩阵的奇异值： ::

    M = {rand(1000,1000) for i=1:10}
    pmap(svd, M)

被调用的函数需处理大量工作时使用 ``pmap`` ，反之，则使用 ``@parallel for`` 。

分布式数组
----------

并行计算综合使用多个机器上的内存资源，因而可以使用一个机器上不能使用的大数组。这时，可使用分布式数组，每个处理器仅对它所拥有的那部分数组进行操作。

分布式数组（或 *全局对象* ）逻辑上是个单数组，但它分为很多块儿，每个处理器上保存一块儿。但对整个数组的运算与在本地数组的运算是一样的，并行计算是隐藏的。

分布式数组是 ``DArray`` 类型的实例。 ``DArray`` 的元素类型和维度与 ``Array`` 一样，但它有个额外属性：数据分布在哪个维度上。Julia 只允许数据分布在一个维度上。如果 2 维 ``DArray`` 分布在维度 1 上，则每个处理器仅存储一部分行；如果它分布在维度 2 上，则每个处理器仅存储一部分列。

一些常用分布式数组可以使用 ``d`` 开头的函数来构造： ::

   dzeros(100,100,10)
   dones(100,100,10)
   drand(100,100,10)
   drandn(100,100,10)
   dcell(100,100,10)
   dfill(x, 100,100,10)

最后一个例子中，数组的元素由值 ``x`` 来初始化。这些函数自动选取分布在某个维度上。如果要指明分布的维度，应这样写： ::

   drand((100,100,10), 3)
   dzeros(Int64, (100,100), 2)
   dzeros((100,100), 2, [7, 8])

调用 ``drand`` 时，我们指明数组分布在维度 3 上。第一个 ``dzeros`` 调用指明了元素类型和分布维度。第二个 ``dzeros`` 调用还指明了在哪个处理器上存储数据。如果数据分布在太多处理器上，性能提升会出现边际效用递减。

``distribute(a::Array, dim)`` 可用来将本地数组转换为分布式数组，分布维度是可选的。 ``localize(a::DArray)`` 可用来获取 ``DArray`` 本地存储的部分。 ``owner(a::DArray, index)`` 返回存储分布式维度指定索引的处理器 ID 。 ``myindexes(a::DArray)`` 返回本地处理器所存储的维度索引值多元组。 ``convert(Array, a::DArray)`` 将所有数据综合到一个节点上。

``DArray`` 可存储在可用处理器的子集上。 ``DArray`` 的实例 ``d`` 可由三个属性来完整描述。 ``d.pmap[i]`` 返回存储数组的第 ``i`` 块儿处理器 ID 。第 ``i`` 块儿包含了从 ``d.dist[i]`` 到 ``d.dist[i+1]-1`` 的索引值。 ``distdim(d)`` 返回分布的维度。 ``d.localpiece`` 返回当前处理器存储的块儿数。数组 ``d.pmap`` 也可由 ``procs(d)`` 提供。

索引 ``DArray`` （方括号）时将所有参考数据聚集到本地 ``Array`` 对象。

使用 ``sub`` 函数索引 ``DArray`` 时，会构造一个“虚拟”子数组，所有的数据仍在原地。尽量使用这种索引方式。

``sub`` 本身不做任何通信，因此很高效。但它并不总是最优的。有很多情形下为了进行快速串行运算，需要显式把数据移动到本地处理器。如，矩阵乘法等函数经常读取数据，最好把数据移动到本地前端。

构造分布式数组
~~~~~~~~~~~~~~

``DArray`` 的构造函数是 ``darray`` ，它的声明如下： ::

   darray(init, type, dims, distdim, procs, dist)

``init`` 是有三个参数的函数，它在每个处理器上都运行，返回当前处理器存储的本地数据 ``Array`` 。它的参数为 ``(T,d,da)`` ，其中 ``T`` 是类型参数， ``d`` 是所需本地块儿的维度， ``da`` 是要构造的新 ``DArray`` （尽管它是部分初始化的）。

``type`` 是元素类型。

``dims`` 是整个 ``DArray`` 的维度。

``distdim`` 是分布的维度。

``procs`` 向量保存要使用的处理器 ID 。

``dist`` 向量，给出每个邻近分布块儿的第一个索引值，其中第 n 个块儿包含从 ``dist[n]`` 到 ``dist[n+1]-1`` 的索引值。如果 ``v`` 为块儿大小的向量， ``dist`` 可由 ``cumsum([1,v])`` 给出。

最后三个参数是可选的。第一个参数，即 ``init`` 函数也可以省略；如果省略，则它构造非初始化的 ``DArray`` 。

下例演示如果将本地数组 ``rand`` 的构造函数更改为分布式数组的构造函数： ::

   drand(args...) = darray((T,d,da)->rand(d), Float64, args...)

此例中 ``init`` 函数仅对它所构造的本地块儿的维度调用 ``rand`` 。 ``drand`` 接收与 ``darray`` 相同的尾参数。 ``darray`` 还有一种定义，可以使 ``drand`` 之类的函数接收与本地函数相同的参数，因此还可以调用 ``drand(m,n)`` 。

``changedist`` 函数更改 ``DArray`` 的分布，可通过调用一个函数处理 ``darray`` 来实现，这里 ``init`` 函数使用索引值来将数据聚集到已存在的数组上： ::

   function changedist(A::DArray, to_dist)
	   return darray((T,sz,da)->A[myindexes(da)...],
			 eltype(A), size(A), to_dist, procs(A))
   end

构造 ``DArray`` 非常简单，它的每个块儿都是对已存在的 ``DArray`` 中的块儿进行运算的函数。这是通过 ``darray(f, A)`` 来完成的。例如，取相反数的函数可如下实现： ::

   -(A::DArray) = darray(-, A)

分布式数组计算
~~~~~~~~~~~~~~

遍历数组的运算适用于分布式数组，但是仅仅它还不够。要处理更复杂的问题，可以对 ``DArray`` 的每个块儿分配任务，将结果写入另一个 ``DArray`` 。例如，将 ``f`` 函数应用到 3 维 ``DArray`` 的每个 2 维切片上： ::

   function compute_something(A::DArray)
	   B = darray(eltype(A), size(A), 3)
	   for i = 1:size(A,3)
		   @spawnat owner(B,i) B[:,:,i] = f(A[:,:,i])
	   end
	   B
   end

``@spawnat`` 将代码搬到它要操作的内存附近。

这段儿代码是有问题的，因为它异步执行写操作。换句话说，我们不知道结果数据何时被写入数组，并可以继续后续处理。这被称为“竞争冒险”，是并行编程的有名缺陷。我们需要同步来等待结果。 ``@spawn`` 返回 remote reference ，可以用它来等待计算完成： ::

   function compute_something(A::DArray)
	   B = darray(eltype(A), size(A), 3)
	   deps = cell(size(A,3))
	   for i = 1:size(A,3)
		   deps[i] = @spawnat owner(B,i) B[:,:,i] = f(A[:,:,i])
	   end
	   (B, deps)
   end

现在，如果函数要读取 ``i`` 切片，它先运行 ``wait(deps[i])`` 来确保数据可用。

也可以使用 ``@sync`` 块儿： ::

   function compute_something(A::DArray)
	   B = darray(eltype(A), size(A), 3)
	   @sync begin
		   for i = 1:size(A,3)
		   @spawnat owner(B,i) B[:,:,i] = f(A[:,:,i])
		   end
	   end
	   B
   end

``@sync`` 等待它内部的所有任务完成。这样 ``compute_something`` 函数更好用，但会降低一些并行机制（因为对它的调用不能与后面的运算混叠）。

还可以使用最原始的、未同步版本的代码，将 ``@sync`` 块儿放在调用这个函数的一堆运算的外面。

与 remote reference 同步
------------------------

计划表
~~~~~~

Julia 的并行编程平台在多个计算之间使用 :ref:`man-tasks` 进行切换。当代码执行到 ``fetch`` 或 ``wait`` 等通信操作时，当前任务被挂起，按计划表选取并运行另一个任务。

在动态计划表中，程序根据其它任务何时结束，来决定在哪儿计算或在计算什么。

下例中，计算不同大小矩阵的奇异值： ::

    M = {rand(800,800), rand(600,600), rand(800,800), rand(600,600)}
    pmap(svd, M)

``pmap`` 的代码可以看出，它在每个处理器完成它当前的任务时，给它分配新的任务： ::

    function pmap(f, lst)
        np = nprocs()  # 当前可用的处理器个数
        n = length(lst)
        results = cell(n)
        i = 1
        # 从任务队列中取出下一个新任务
        # 新任务在这儿仅是一个索引值
        next_idx() = (idx=i; i+=1; idx)
        @sync begin
            for p=1:np
                @spawnlocal begin
                    while true
                        idx = next_idx()
                        if idx > n
                            break
                        end
                        results[idx] = remote_call_fetch(p, f, lst[idx])
                    end
                end
            end
        end
        results
    end

``@spawnlocal`` 类似于 ``@spawn`` ，但是它仅在本地处理器上运行任务。 ``@sync`` 块儿用于等待所有本地任务完成，那时整个运算也就结束了。

将指令传给所有的处理器
----------------------

在所有的处理器上运行指令是很有用的，尤其是载入源文件、定义通用变量等设置任务。可以通过 ``@everywhere`` 宏来完成： ::

    @everywhere include("defs.jl")
