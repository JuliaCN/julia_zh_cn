:mod:`Base.Sort` --- 有关排序的程序
===================================

.. module:: Base.Sort
   :synopsis: 排序及相关程序

`Sort` 模块包含与排序有关的算法和其它函数。它提供了默认排序函数和各种排序算法的标准版本。可以通过 `import Sort` 来使用具体的排序算法，也可以使用完整的算法名，如： ::

  # Julia 代码
  sort(v, Sort.TimSort)

将会使用 ``TimSort`` 对 ``v`` 排序。


概述
----

大部分人只用默认排序算法，按升序或降序排列： ::

  # Julia 代码
  julia> sort([2,3,1]) == [1,2,3]
  true

  julia> sort([2,3,1], Sort.Reverse) == [3,2,1]
  true

返回排列顺序： ::

  julia> v = [20,30,10]
  3-element Int64 Array:
   20
   30
   10

  julia> p = sortperm(v)
  [3, 1, 2]

  julia> v[p]
  3-element Int64 Array:
   10
   20
   30

使用自定义提取函数来排序输出： ::

  julia> canonicalize(s) = filter(c -> ('A'<=c<='Z' || 'a'<=c<='z'), s) | uppercase

  julia> sortby(["New York", "New Jersey", "Nevada", "Nebraska", "Newark"], canonicalize)
  5-element ASCIIString Array:
   "Nebraska"  
   "Nevada"    
   "Newark"    
   "New Jersey"
   "New York"  

注意，上面的变体并不修改原数组。如果要原地排序（通常更高效）， :func:`sort` 和 :func:`sortby` 都有对应的修改数据的版本，它们函数名后都有感叹号（ :func:`sort!` 和 :func:`sortby!` ）。

这些排序函数使用适当的默认算法，如果想更进一步，研究那种排序算法更适合处理你的数据，请继续阅读……


排序算法
--------

Julia 现在提供四个主要的排序算法： ::

  InsertionSort
  QuickSort
  MergeSort
  TimSort

插入排序是 O(n^2) 稳定排序算法。 ``n`` 较小时比较高效。 ``QuickSort`` 和 ``TimSort`` 都使用插入排序。

快速排序是 O(n log n) 排序算法。为了高效，它是不稳定排序。它属于最快的排序算法之列。

归并排序是 O(n log n) 稳定排序算法。

Timsort 是 O(n log n) 稳定自适应排序算法。它对两种情况混合（一会升序，一会降序）的输入处理比较好，这种数据集常见于现实生活中。

排序算法根据目标数组的类型，选取适当的默认算法。要指明使用哪种排序算法，在参数列表后添加 ``Sort.<algorithm>`` （如 ``sort!(v, Sort.TimSort)`` 使用 Timsort 算法）。


函数
----

--------
排序函数
--------
.. function:: sort(v[, alg[, ord]])

   按升序对向量排序。 ``alg`` 为特定的排序算法（ ``Sort.InsertionSort``, ``Sort.QuickSort``, ``Sort.MergeSort``, 或 ``Sort.TimSort`` ）， ``ord`` 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

.. function:: sort!(...)

   原地排序。

.. function:: sortby(v, by[, alg])

   根据 ``by(v)`` 对向量排序。 ``alg`` 为特定的排序算法（ ``Sort.InsertionSort``, ``Sort.QuickSort``, ``Sort.MergeSort``, 或 ``Sort.TimSort`` ）。

.. function:: sortby!(...)

   ``sortby`` 的原地版本

.. function:: sortperm(v, [alg[, ord]])

   返回排序向量，可用它对输入向量 ``v`` 进行排序。 ``alg`` 为特定的排序算法（ ``Sort.InsertionSort``, ``Sort.QuickSort``, ``Sort.MergeSort``, 或 ``Sort.TimSort`` ）， ``ord`` 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

----------------
与排序相关的函数
----------------

.. function:: issorted(v[, ord])

   判断向量是否为已经为升序排列。 ``ord`` 为自定义的排序顺序。

.. function:: searchsorted(a, x[, ord])

   返回 ``a`` 中排序顺序不小于 ``x`` 的第一个值的索引值， ``ord`` 为自定义的排序顺序（默认为 ``Sort.Forward`` ）。

   ``searchsortedfirst()`` 的别名

.. function:: searchsortedfirst(a, x[, ord])

   返回 ``a`` 中排序顺序不小于 ``x`` 的第一个值的索引值， ``ord`` 为自定义的排序顺序（默认为 ``Sort.Forward`` ）。

.. function:: searchsortedlast(a, x[, ord])

   返回 ``a`` 中排序顺序不大于 ``x`` 的最后一个值的索引值， ``ord`` 为自定义的排序顺序（默认为 ``Sort.Forward`` ）。

.. function:: select(v, k[, ord])

   找到排序好的向量 ``v`` 中第 ``k`` 个位置的元素，在未排序时的索引值。 ``ord`` 为自定义的排序顺序（默认为 ``Sort.Forward`` ）。

.. function:: select!(v, k[, ord])

   ``select`` 的原地版本
   
