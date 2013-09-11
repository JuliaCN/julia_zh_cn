.. _man-exception-handling:

异常处理
--------

当遇到意外条件时，函数可能无法给调用者返回一个合理值。这时，要么终止程序，打印诊断错误信息；要么程序员编写异常处理。

内置异常
~~~~~~~~

如果程序遇到意外条件, 异常将会被抛出. 下面是全部的内置异常.

+-------------------------+---------------------+
| 异常                    |  说明               |
+=========================+=====================+
| ``ArgumentError``       |  非法参数           |
+-------------------------+---------------------+
| ``BoundsError``         |  (数组元素地址)越界 |
+-------------------------+---------------------+
| ``DivideError``         |                     |
+-------------------------+---------------------+
| ``DomainError``         |                     |
+-------------------------+---------------------+
| ``EOFError``            |  文件末尾           |
+-------------------------+---------------------+
| ``ErrorException``      |                     |
+-------------------------+---------------------+
| ``InexactError``        |  类型不匹配         |
+-------------------------+---------------------+
| ``InterruptException``  |  中断               |
+-------------------------+---------------------+
| ``KeyError``            |                     |
+-------------------------+---------------------+
| ``LoadError``           |                     |
+-------------------------+---------------------+
| ``MemoryError``         |  内存错误           |
+-------------------------+---------------------+
| ``MethodError``         |  函数错误           |
+-------------------------+---------------------+
| ``OverflowError``       |  溢出               |
+-------------------------+---------------------+
| ``ParseError``          |  解析错误           |
+-------------------------+---------------------+
| ``SystemError``         |  系统错误           |
+-------------------------+---------------------+
| ``TypeError``           |  类型错误           |
+-------------------------+---------------------+
| ``UndefRefError``       |  变量未定义         |
+-------------------------+---------------------+

例如, 当对负数使用内置的 ``sqrt`` 函数时，将抛出 ``DomainError()`` ： ::

    julia> sqrt(-1)
    ERROR: DomainError()
     in sqrt at math.jl:117

``throw`` 函数
~~~~~~~~~~~~~~

异常可以使用 ``throw`` 函数显式创建. 例如, 某个函数只对非负数做了定义, 如果参
数为负数, 可以抛出 ``DomaineError`` 异常. ::

    julia> f(x) = x>=0 ? exp(-x) : throw(DomainError())
    # methods for generic function f
    f(x) at none:1

    julia> f(1)
    0.36787944117144233

    julia> f(-1)
    ERROR: DomainError()
     in f at none:1

注意, ``DomainError`` 使用时需要使用带括号的形式, 否则返回的并不是异常. ::

    julia> typeof(DomainError()) <: Exception
    true

    julia> typeof(DomainError()) <: Exception
    false


``error`` 函数
~~~~~~~~~~~~~~

``error`` 函数用来产生 ``ErrorException``, 阻断程序的正常执行.

如下改写 ``sqrt`` 函数，当参数为负数时，提示错误，立即停止执行： ::

    fussy_sqrt(x) = x >= 0 ? sqrt(x) : error("negative x not allowed")

    julia> fussy_sqrt(2)
    1.4142135623730951

    julia> fussy_sqrt(-1)
    negative x not allowed


``warn`` 和 ``info`` 函数
~~~~~~~~~~~~~~~~~~~~~~~~~

另外的一些函数可以输出一些消息, 但不抛出异常, 所以并不会打断程序的执行. ::

    julia> info("Hi"); 1+1
    MESSAGE: Hi
    2

    julia> warn("Hi"); 1+1
    WARNING: Hi
    2

    julia> error("Hi"); 1+1
    ERROR: Hi
     in error at error.jl:21


``try/catch`` 语句
~~~~~~~~~~~~~~~~~~

``try/catch`` 语句可以用于处理一部分预料中的异常. 例如, 下面平方根函数可以正确
处理实数或者复数 ::

    julia> f(x) = try
             sqrt(x)
           catch
             sqrt(complex(x, 0))
           end
    # methods for generic function f
    f(x) at none:1

    julia> f(1)
    1.0

    julia> f(-1)
    0.0 + 1.0im

``try/catch`` 语句使用时也可以把异常赋值给某个变量. 例如下面演示用的例子 ::

    julia> sqrt_second(x) = try
             sqrt(x[2])
           catch y
             if y == DomainError()
               sqrt(complex(x[2], 0))
             elseif y == BoundsError()
               sqrt(x)
             end
           end
    # methods for generic function sqrt_second
    sqrt_second(x) at none:1

    julia> sqrt_second([1 4])
    2.0

    julia> sqrt_second([1 -4])
    0.0 + 2.0im

    julia> sqrt_second(9)
    3.0

    julia> sqrt_second(-9)
    ERROR: DomainError()
     in sqrt at math.jl:117
     in sqrt_second at none:7

下例中当出现除以零的错误时，抛出 ``DivideByZeroError`` 对象： ::

    julia> div(1,0)
    error: integer divide by zero

    julia> try
             div(1,0)
           catch x
             println(typeof(x))
           end
    DivideByZeroError

``DivideByZeroError`` 是 ``Exception`` 的具体子类型，抛出它表示有整数被零除。
浮点函数会返回 ``NaN`` ，而不是抛出异常。

The power of the ``try/catch`` construct lies in the ability to unwind a
deeply nested computation immediately to a much higher level in the stack of
calling functions. There are situations where no error has occurred, but the
ability to unwind the stack and pass a value to a higher level is desirable.
Julia provides the ``rethrow``, ``backtrace`` and ``catch_backtrace``
functions for more advanced error handling.

finally 语句
~~~~~~~~~~~~

在改变状态或者使用文件等资源时,通常需要在操作执行完成时做清理工作(比如关闭文件
). 异常的存在使得这样的任务变得复杂, 因为异常会导致程序提前退出.  关键字
``finally`` 可以解决这样的问题, 无论程序是怎样退出的, ``finally`` 语句总是会被
执行.

例如, 下面的程序说明了怎样保证打开的文件总是会被关闭::

    f = open("file")
    try
        # 对文件 f 操作
    finally
        close(f)
    end

当程序执行完 ``try`` 语句块 (例如因为执行到 ``return`` 语句, 或者只是正
常完成), ``close`` 语句将会被执行. 如果 ``try`` 语句块因为异常提前退出,
异常将会继续传播. ``catch`` 语句可以和 ``try``, ``finally`` 一块使用. 这
时, ``finally`` 语句将会在 ``catch`` 处理完异常之后执行.

.. _man-tasks:

任务（也称为协程）
------------------

任务是一种允许计算灵活地挂起和恢复的控制流，有时也被称为对称协程、轻量级线程、协同多任务等。

如果一个计算（比如运行一个函数）被设计为 ``Task`` ，有可能因为切换到其它
``Task`` 而被中断。原先的 ``Task`` 在以后恢复时，会从原先中断的地方继续工作。
切换任务不需要任何空间，同时可以有任意数量的任务切换，不需要考虑堆栈问题。任务
切换与函数调用不同，可以按照任何顺序来进行。

任务比较适合生产者-消费者模式，一个过程用来生产值，另一个用来消费值。消费者不
能简单的调用生产者来得到值，因为两者的执行时间不一定协同。在任务中，两者则可以
正常运行。

Julia 提供了 ``produce`` 和 ``consume`` 函数来解决这个问题。生产者调用 ``produce`` 函数来生产值： ::

    function producer()
      produce("start")
      for n=1:4
        produce(2n)
      end
      produce("stop")
    end

要消费生产的值，先对生产者调用 ``Task`` 函数，然后对它重复调用 ``consume`` ： ::

    julia> p = Task(producer)
    Task

    julia> consume(p)
    "start"

    julia> consume(p)
    2

    julia> consume(p)
    4

    julia> consume(p)
    6

    julia> consume(p)
    8

    julia> consume(p)
    "stop"

可以在 ``for`` 循环中迭代任务，生产的值被赋值给循环变量： ::

    julia> for x in Task(producer)
             println(x)
           end
    start
    2
    4
    6
    8
    stop

注意 ``Task()`` 函数的参数，应为零参函数。生产者常常是参数化的，因此需要为其构
造零参 :ref:`匿名函数 <man-anonymous-functions>` 。可以直接写，也可以调用宏：
::

    function mytask(myarg)
        ...
    end

    taskHdl = Task(() -> mytask(7))
    # 也可以写成
    taskHdl = @task mytask(7)

``produce`` 和 ``consume`` 适用于多任务，但它并不在不同的 CPU 发起线程。将在
:ref:`man-parallel-computing` 中，讨论真正的内核线程。
