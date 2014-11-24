.. _man-nullable-types:

*******
可空类型
*******

在很多情况下, 你可能会碰到一些可能存在也可能不存在的变量. 为了处理这种
情况, Julia 提供了参数化的数据类型 ``Nullable{T}``, 可以被当做是一种特
殊的容器, 里面有 0 个或 1 个数据. ``Nullable{T}`` 提供了最小的接口以保
证对可能是空值的操作是安全的. 目前包含四种操作 :

- 创建一个 ``Nullable`` 对象.
- 检查 ``Nullable`` 是否含有数据.
- 获取 ``Nullable`` 内部的数据, 如果没有数据可被返回, 抛出
  ``NullException``.
- 获取 ``Nullable`` 内部的数据, 如果没有数据可被返回, 返回数据类型
  ``T`` 的默认值.

创建 ``Nullable`` 对象
---------------------

使用 ``Nullable{T}()`` 函数来创建一个关于类型 ``T`` 的可空对象 :

.. doctest::

   x1 = Nullable{Int}()
   x2 = Nullable{Float64}()
   x3 = Nullable{Vector{Int}}()

使用 ``Nullable(x::T)`` 函数来创建一个非空的关于类型 ``T`` 的可空对象 :

.. doctest::

   x1 = Nullable(1)
   x2 = NUllable(1.0)
   x3 = Nullalbe([1, 2, 3])

注意上面两种构造可空对象方式的不同: 对第一种方式, 函数接受的参数是类型
``T``; 另一种方式中, 函数接受的是单个参数, 这个参数的类型是 ``T``.

检查 ``Nullabe`` 对象是否含有数据
---------------------------

使用 ``isnull`` 函数来检查 ``Nullable`` 对象是否为空 :

.. doctest::

   isnull(Nullable{Float64}())
   isnull(Nullable(0.0))

安全地访问 ``Nullable`` 对象的内部数据
-----------------------------

使用 ``get`` 来安全地访问 ``Nullable`` 对象的内部数据 :

.. doctest::

   get(Nullable{Float64}())
   get(Nullable(1.0))

如果没有数据, 正如 ``Nullable{Float64}``, 抛出 ``NullException`` 错误.
``get`` 函数保证了任何访问不存在的数据的操作立即抛出错误.

在某些情况下, 如果 ``Nullable`` 对象是空的, 我们希望返回一个合理的默认
值. 我们可以将这个默认值穿递给 ``get`` 函数作为第二个参数 :

.. doctest::

   get(Nullable{Float64}(), 0)
   get(Nullable(1.0), 0)

注意, 这个默认的参数会被自动转换成类型 ``T``. 例如, 上面的例子中, 在
``get`` 函数返回前, ``0`` 会被自动转换成 ``Float64``. ``get`` 函数可以
设置默认替换值这一特性使得处理未定义变量变得非常轻松.
