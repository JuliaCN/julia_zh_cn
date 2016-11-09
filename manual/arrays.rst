.. _man-arrays:

**********
 多维数组
**********
.. **************************
..  Multi-dimensional Arrays
.. **************************

类似于其它科学计算语言，Julia语言提供了内置的数组。相较于很多科学计算语言都很关注数组在其它容器上的开销。Julia语言并不特别地对待数组。如同其它Julia代码一样，数组基本完全使用Julia本身实现，由编译器本身进行性能优化。同样的，这也使得通过继承 ``AbstractArray`` 来定制数组成为可能。 更多的细节，请参照 :ref: `抽象数组接口`。

.. Julia, like most technical computing languages, provides a first-class
.. array implementation. Most technical computing languages pay a lot of
.. attention to their array implementation at the expense of other
.. containers. Julia does not treat arrays in any special way. The array
.. library is implemented almost completely in Julia itself, and derives
.. its performance from the compiler, just like any other code written in
.. Julia. As such, it's also possible to define custom array types by
.. inheriting from ``AbstractArray.`` See the :ref:`manual section on the
.. AbstractArray interface <man-interfaces-abstractarray>` for more details
.. on implementing a custom array type.

数组是一个存在多维网格中的对象集合。通常，数组包含的对象的类型为 ``Any`` 。对大多数计算而言，数组对象一般更具体为 ``Float64`` 或 ``Int32`` 。

.. An array is a collection of objects stored in a multi-dimensional
.. grid.  In the most general case, an array may contain objects of type
.. ``Any``.  For most computational purposes, arrays should contain
.. objects of a more specific type, such as ``Float64`` or ``Int32``.

总的来说，不像其它的科学计算语言，Julia不需要为了获得高性能而将程序被写成向量化的形式。Julia的编译器使用类型推断生成优化的代码来进行数组索引，这样的编程风格在没有牺牲性能的同时，可读性更好，编写起来更方便，有时候还会使用更少的内存。

.. In general, unlike many other technical computing languages, Julia does
.. not expect programs to be written in a vectorized style for performance.
.. Julia's compiler uses type inference and generates optimized code for
.. scalar array indexing, allowing programs to be written in a style that
.. is convenient and readable, without sacrificing performance, and using
.. less memory at times.


有一些科学计算语言会通过值来传递数组，这在很多情况下很方便，而在 Julia 中，参数将通过引用传递给函数，这使得函数中对于一个数组输入的修改在函数外部是可见的。Julia 的库函数不会修改传递给它的输入。用户写代码时，如果要想做类似的功能，要注意先把输入复制一份儿。

.. In Julia, all arguments to functions are passed by reference. Some
.. technical computing languages pass arrays by value, and this is
.. convenient in many cases. In Julia, modifications made to input arrays
.. within a function will be visible in the parent function. The entire
.. Julia array library ensures that inputs are not modified by library
.. functions. User code, if it needs to exhibit similar behaviour, should
.. take care to create a copy of inputs that it may modify.

数组
====

.. Arrays
.. ======

基础函数
--------

.. Basic Functions
.. ---------------

=============== ========================================================================
函数            说明
=============== ========================================================================
``eltype(A)``   ``A`` 中元素的类型
``length(A)``   ``A`` 中元素的个数
``ndims(A)``    ``A`` 有几个维度
``size(A)``     返回一个元素为 ``A`` 的维度的多元组
``size(A,n)``   ``A`` 在某个维度上的长度
``stride(A,k)`` 在维度 ``k`` 上，邻接元素（在内存中）的线性索引距离
``strides(A)``  返回多元组，其元素为在每个维度上，邻接元素（在内存中）的线性索引距离
=============== ========================================================================

================================  ==============================================================================
函数                               说明
================================  ==============================================================================
:func:`eltype(A) <eltype>`        ``A`` 中元素的类型
:func:`length(A) <length>`        ``A`` 中元素的个数
:func:`ndims(A) <ndims>`          ``A`` 的维数
:func:`size(A) <size>`            返回一个包含 ``A`` 中每个维度元素个数的多元组
:func:`size(A,n) <size>`          ``A`` 在某个维度上的大小
:func:`indices(A) <indices>`      返回一个包含 ``A`` 中可能的索引的多元组
:func:`indices(A,n) <indices>`    返回一个在 ``n`` 维上可能的索引范围
:func:`eachindex(A) <eachindex>`  一个能够高效地访问每个 ``A`` 中的元素的迭代器
:func:`stride(A,k) <stride>`      第``k``维的跨度（相临元素间的索引距离）
:func:`strides(A) <strides>`      返回一个包含每一维度跨度的多元组
================================  ==============================================================================

.. ================================  ==============================================================================
.. Function                          Description
.. ================================  ==============================================================================
.. :func:`eltype(A) <eltype>`        the type of the elements contained in ``A``
.. :func:`length(A) <length>`        the number of elements in ``A``
.. :func:`ndims(A) <ndims>`          the number of dimensions of ``A``
.. :func:`size(A) <size>`            a tuple containing the dimensions of ``A``
.. :func:`size(A,n) <size>`          the size of ``A`` along a particular dimension
.. :func:`indices(A) <indices>`      a tuple containing the valid indices of ``A``
.. :func:`indices(A,n) <indices>`    a range expressing the valid indices along dimension ``n``
.. :func:`eachindex(A) <eachindex>`  an efficient iterator for visiting each position in ``A``
.. :func:`stride(A,k) <stride>`      the stride (linear index distance between adjacent elements) along dimension ``k``
.. :func:`strides(A) <strides>`      a tuple of the strides in each dimension
.. ================================  ==============================================================================

构造和初始化
------------
.. Construction and Initialization
.. -------------------------------

下列函数中调用的 ``dims...`` 参数，既可以是维度的单多元组，也可以是维度作为可变参数时的一组值。

.. Many functions for constructing and initializing arrays are provided. In
.. the following list of such functions, calls with a ``dims...`` argument
.. can either take a single tuple of dimension sizes or a series of
.. dimension sizes passed as a variable number of arguments.


=================================================== =====================================================================
函数                                                 描述
=================================================== =====================================================================
:func:`Array{type}(dims...) <Array>`                未初始化的稠密数组
:func:`zeros(type, dims...) <zeros>`                指定类型的全 0 数组. 如果未指明 ``type``, 默认为 ``Float64``
:func:`zeros(A) <zeros>`                            全 0 数组, 元素类型和大小同 ``A``
:func:`ones(type, dims...) <ones>`                  指定类型的全 1 数组. 如果未指明 ``type``, 默认为 ``Float64``
:func:`ones(A) <ones>`                              全 1 数组, 元素类型和大小同 ``A``
:func:`trues(dims...) <trues>`                      全 ``true`` 的 ``Bool`` 数组
:func:`trues(A) <trues>`                            全 ``true`` 的 ``Bool`` 数组，大小和 ``A`` 相同
:func:`falses(dims...) <falses>`                    全 ``false`` 的 ``Bool`` 数组
:func:`falses(A) <falses>`                          全 ``false`` 的 ``Bool`` 数组，大小和 ``A`` 相同
:func:`reshape(A, dims...) <reshape>`               将数组 ``A`` 中的数据按照指定维度排列
:func:`copy(A) <copy>`                              复制 ``A``
:func:`deepcopy(A) <deepcopy>`                      深度拷贝，递归地复制 ``A`` 中的元素
:func:`similar(A, element_type, dims...) <similar>` 属性与输入数组（稠密、稀疏等）相同的未初始化数组，但指明了元素类型和维度。
                                                    第二、三参数可省略，省略时默认为 ``A`` 的元素类型和维度
:func:`reinterpret(type, A) <reinterpret>`          二进制数据与输入数组相同的数组，但指定了元素类型
:func:`rand(dims) <rand>`                           在 [0,1) 上独立均匀同分布的 ``Float64`` 类型的随机数组
:func:`randn(dims) <randn>`                         ``Float64`` 类型的独立正态同分布的随机数组，均值为 0 ，标准差为 1
:func:`eye(n) <eye>`                                ``n`` x ``n`` 单位矩阵
:func:`eye(m, n) <eye>`                             ``m`` x ``n`` 单位矩阵
:func:`linspace(start, stop, n) <linspace>`         从 ``start`` 至 ``stop`` 的由 ``n`` 个元素构成的线性向量
:func:`fill!(A, x) <fill!>`                         用值 ``x`` 填充数组 ``A``
:func:`fill(x, dims) <fill>`                        创建指定规模的数组, 并使用 ``x`` 填充
=================================================== =====================================================================

.. .. [#] *iid*, independently and identically distributed.

一维数组（向量）可以通过使用``[A, B, C, ...]``这样的语句来构造。

.. The syntax ``[A, B, C, ...]`` constructs a 1-d array (vector) of its arguments.

连接
----

使用下列函数，可在任意维度连接数组：

================ ======================================================
Function         Description
================ ======================================================
``cat(k, A...)`` 在第 ``k`` 维上连接给定的n维数组
``vcat(A...)``   ``cat(1, A...)``的简写
``hcat(A...)``   ``cat(2, A...)``的简写
================ ======================================================

传递给这些函数的参数值将被当做只有一个元素的数组

.. Scalar values passed to these functions are treated as 1-element arrays.

由于连接函数使用的次数很频繁，所以有一些专用的语法来调用它们

.. The concatenation functions are used so often that they have special syntax:

=================== =========
表达式               所调用的函数
=================== =========
``[A B C ...]``     ``hcat``
``[A, B, C, ...]``  ``vcat``
``[A B; C D; ...]`` ``hvcat``
=================== =========

``hvcat`` 同时连接第一维 (用分号隔开) 和第二维度
(用空格隔开).

.. :func:`hvcat` concatenates in both dimension 1 (with semicolons) and dimension 2
.. (with spaces).

指定类型的数组初始化
------------------------

指定类型为``T``的数组可以使用``T[A, B, C, ...]``来初始化. 这将会创建一个元素类型为``T``，元素初始化为``A``, ``B``, ``C``等的一维数组。比如``Any[x, y, z]``将创建一个包含任何类型的混合数组。

类似地，连接语句也能通过加前缀来指定元素类型


.. doctest::

    julia> [[1 2] [3 4]]
    1×4 Array{Int64,2}:
     1  2  3  4

    julia> Int8[[1 2] [3 4]]
    1×4 Array{Int8,2}:
     1  2  3  4

.. Typed array initializers
.. ------------------------

.. An array with a specific element type can be constructed using the syntax
.. ``T[A, B, C, ...]``. This will construct a 1-d array with element type
.. ``T``, initialized to contain elements ``A``, ``B``, ``C``, etc.
.. For example ``Any[x, y, z]`` constructs a heterogeneous array that can
.. contain any values.

.. Concatenation syntax can similarly be prefixed with a type to specify
.. the element type of the result.

.. .. doctest::

..     julia> [[1 2] [3 4]]
..     1×4 Array{Int64,2}:
..      1  2  3  4

..     julia> Int8[[1 2] [3 4]]
..     1×4 Array{Int8,2}:
..      1  2  3  4


.. _comprehensions:

列表推导
--------------

列表推导为构造数组提供了一种更加一般，更加强大的方法。它的语法类似于数学中的集合标记法： ::

    A = [ F(x,y,...) for x=rx, y=ry, ... ]

``F(x,y,...)`` 根据变量 ``x``, ``y`` 等来求值。这些变量的值可以是任何迭代对象，但大多数情况下，都使用类似于 ``1:n`` 或 ``2:(n-1)`` 的范围对象，或显式指明为类似 ``[1.2, 3.4, 5.7]`` 的数组。它的结果是一个 N 维稠密数组。

.. Comprehensions provide a general and powerful way to construct arrays.
.. Comprehension syntax is similar to set construction notation in
.. mathematics

..     A = [ F(x,y,...) for x=rx, y=ry, ... ]

.. The meaning of this form is that ``F(x,y,...)`` is evaluated with the
.. variables ``x``, ``y``, etc. taking on each value in their given list of
.. values. Values can be specified as any iterable object, but will
.. commonly be ranges like ``1:n`` or ``2:(n-1)``, or explicit arrays of
.. values like ``[1.2, 3.4, 5.7]``. The result is an N-d dense array with
.. dimensions that are the concatenation of the dimensions of the variable
.. ranges ``rx``, ``ry``, etc. and each ``F(x,y,...)`` evaluation returns a
.. scalar.

下例计算在维度 1 上，当前元素及左右邻居元素的加权平均数：

.. The following example computes a weighted average of the current element
.. and its left and right neighbor along a 1-d grid. :

.. testsetup:: *

    srand(314)

.. doctest:: array-rand

    julia> x = rand(8)
    8-element Array{Float64,1}:
     0.843025
     0.869052
     0.365105
     0.699456
     0.977653
     0.994953
     0.41084
     0.809411

    julia> [ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
    6-element Array{Float64,1}:
     0.736559
     0.57468
     0.685417
     0.912429
     0.8446
     0.656511


输出的数组类型由所计算出的元素类型决定。显式地控制类型可以通过在列表推导的前面加上类型前缀完成。例如，我们可以这样来使得结果都是单精度的浮点数

    Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]

.. The resulting array type depends on the types of the computed elements.
.. In order to control the type explicitly, a type can be prepended to the comprehension.
.. For example, we could have requested the result in single precision by writing::

..     Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]

.. _man-generator-expressions:

生成器表达式
---------------------

列表推导也可以被用不闭合的方括号写出，从而产生一个称为生成器的对象。这个对象可以通过迭代来产生所需的值，而不需要提前为一个数组分配内存。
（参见 :ref:`man-interfaces-iteration`）。
例如下面的表达式会对一列没有分配内存的数求和

.. doctest::

    julia> sum(1/n^2 for n=1:1000)
    1.6439345666815615

在生成器参数列表中有多个维度的时候，需要通过括号来分割各个参数::

    julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
    ERROR: syntax: invalid iteration specification

所有在 ``for`` 之后通过逗号分割的表达式将被解释成范围。通过增加括号能够使得我们给 ``map`` 增加第三个参数：

.. doctest::

    julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
    2×2 Array{Tuple{Float64,Int64},2}:
     (0.5,1)       (0.333333,3)
     (0.333333,2)  (0.25,4)

生成器和列表推导的范围可以通过多个``for``关键字对外层范围依赖：

.. doctest::

    julia> [(i,j) for i=1:3 for j=1:i]
    6-element Array{Tuple{Int64,Int64},1}:
     (1,1)
     (2,1)
     (2,2)
     (3,1)
     (3,2)
     (3,3)


在上面发的情况中，结果都会是一维数组

生成的值可以通过 ``if`` 关键字过滤

.. doctest::

    julia> [(i,j) for i=1:3 for j=1:i if i+j == 4]
    2-element Array{Tuple{Int64,Int64},1}:
     (2,2)
     (3,1)


.. .. _man-generator-expressions:

.. Generator Expressions
.. ---------------------

.. Comprehensions can also be written without the enclosing square brackets, producing
.. an object known as a generator. This object can be iterated to produce values on
.. demand, instead of allocating an array and storing them in advance
.. (see :ref:`man-interfaces-iteration`).
.. For example, the following expression sums a series without allocating memory:

.. .. doctest::

..     julia> sum(1/n^2 for n=1:1000)
..     1.6439345666815615

.. When writing a generator expression with multiple dimensions inside an argument
.. list, parentheses are needed to separate the generator from subsequent arguments::

..     julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
..     ERROR: syntax: invalid iteration specification

.. All comma-separated expressions after ``for`` are interpreted as ranges. Adding
.. parentheses lets us add a third argument to ``map``:

.. .. doctest::

..     julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
..     2×2 Array{Tuple{Float64,Int64},2}:
..      (0.5,1)       (0.333333,3)
..      (0.333333,2)  (0.25,4)

.. Ranges in generators and comprehensions can depend on previous ranges by writing
.. multiple ``for`` keywords:

.. .. doctest::

..     julia> [(i,j) for i=1:3 for j=1:i]
..     6-element Array{Tuple{Int64,Int64},1}:
..      (1,1)
..      (2,1)
..      (2,2)
..      (3,1)
..      (3,2)
..      (3,3)

.. In such cases, the result is always 1-d.

.. Generated values can be filtered using the ``if`` keyword:

.. .. doctest::

..     julia> [(i,j) for i=1:3 for j=1:i if i+j == 4]
..     2-element Array{Tuple{Int64,Int64},1}:
..      (2,2)
..      (3,1)


.. _man-array-indexing:

索引
----

索引 n 维数组 A 的通用语法为： ::

    X = A[I_1, I_2, ..., I_n]

其中 I\_k 可以是：

1. 标量
2. 满足 ``:``, ``a:b``, 或 ``a:b:c`` 格式的 ``Range`` 对象
3. 能够选取整个维度的``:``或者``Colon()``
4. 任意整数数组，包括空数组 ``[]``
5. 能够输出所在位置为``true``的索引所对应元素的布尔数组

.. The general syntax for indexing into an n-dimensional array A is

..     X = A[I_1, I_2, ..., I_n]

.. where each I\_k may be:

.. 1. A scalar integer
.. 2. A ``Range`` of the form ``a:b``, or ``a:b:c``
.. 3. A ``:`` or ``Colon()`` to select entire dimensions
.. 4. An arbitrary integer array, including the empty array ``[]``
.. 5. A boolean array to select a vector of elements at its ``true`` indices

如果所有的索引都是标量，那么结果　``X``　就是　``A`` 中的单个元素。不然　``X``就是一个和索引有相同维度的数组。

.. If all the indices are scalars, then the result ``X`` is a single element from
.. the array ``A``. Otherwise, ``X`` is an array with the same number of
.. dimensions as the sum of the dimensionalities of all the indices.

例如如果所有的索引都是向量，那么　``X``的大小就会是``(length(I_1), length(I_2), ..., length(I_n))``，``X``位于``(i_1, i_2, ..., i_n)``的元素具有``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]``的值。如果``I_1``被变为一个两维的矩阵，这个矩阵就会给``X``增加一个维度，那么``X``就会是一个``n+1``维的数组，大小为``(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))``。位于``(i_1, i_2, i_3, ..., i_{n+1})``的元素就会有``A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]``的值。所有用标量索引的维度的大小会被忽略。比如，``A[2, I, 3]``的结果是一个具有 ``size(I)``　大小的数组。它的第 ``i``\ th　个元素是``A[2, I[i], 3]``。

.. If all indices are vectors, for example, then the shape of ``X`` would be
.. ``(length(I_1), length(I_2), ..., length(I_n))``, with location
.. ``(i_1, i_2, ..., i_n)`` of ``X`` containing the value
.. ``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]``. If ``I_1`` is changed to a
.. two-dimensional matrix, then ``X`` becomes an ``n+1``-dimensional array of
.. shape ``(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))``. The
.. matrix adds a dimension. The location ``(i_1, i_2, i_3, ..., i_{n+1})`` contains
.. the value at ``A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]``. All dimensions
.. indexed with scalars are dropped. For example, the result of ``A[2, I, 3]`` is
.. an array with size ``size(I)``. Its ``i``\ th element is populated by
.. ``A[2, I[i], 3]``.

使用布尔数组``B``通过:func:`find(B) <find>`进行索引和通过向量索引实际上是类似的。它们通常被称作逻辑索引，这将选出那些``B``中值为``true``的元素所在的索引在``A``中的值。一个逻辑索引必须是一个和对应维度有着同样长度的向量，或者是唯一一个和被索引数组的维度以及大小相同的索引。直接使用布尔数组进行索引一般比用:func:`find(B) <find>`进行索引更快。

.. Indexing by a boolean array ``B`` is effectively the same as indexing by the
.. vector that is returned by :func:`find(B) <find>`. Often referred to as logical
.. indexing, this selects elements at the indices where the values are ``true``,
.. akin to a mask. A logical index must be a vector of the same length as the
.. dimension it indexes into, or it must be the only index provided and match the
.. size and dimensionality of the array it indexes into. It is generally more
.. efficient to use boolean arrays as indices directly instead of first calling
.. :func:`find`.

进一步，多维数组的单个元素可以用``x = A[I]``索引，这里``I`` 是一个 ``CartesianIndex``（笛卡尔坐标）。它实际上类似于一个 整数``n``元组。具体参见下面的:ref:`man-array-iteration`

.. Additionally, single elements of a multidimensional array can be indexed as
.. ``x = A[I]``, where ``I`` is a ``CartesianIndex``. It effectively behaves like
.. an ``n``-tuple of integers spanning multiple dimensions of ``A``. See
.. :ref:`man-array-iteration` below.

``end``关键字是这里比较特殊的一个语法，由于最内层被索引的数组的大小会被确定，它可以在索引的括号中用来表示每个维度最后一个索引。不使用``end``关键字的索引与使用``getindex``一样::

    X = getindex(A, I_1, I_2, ..., I_n)

.. As a special part of this syntax, the ``end`` keyword may be used to represent
.. the last index of each dimension within the indexing brackets, as determined by
.. the size of the innermost array being indexed. Indexing syntax without the
.. ``end`` keyword is equivalent to a call to ``getindex``::

..     X = getindex(A, I_1, I_2, ..., I_n)


例子：

.. doctest::

    julia> x = reshape(1:16, 4, 4)
    4×4 Base.ReshapedArray{Int64,2,UnitRange{Int64},Tuple{}}:
     1  5   9  13
     2  6  10  14
     3  7  11  15
     4  8  12  16

    julia> x[2:3, 2:end-1]
    2×2 Array{Int64,2}:
     6  10
     7  11

    julia> x[map(ispow2, x)]
    5-element Array{Int64,1}:
      1
      2
      4
      8
     16

    julia> x[1, [2 3; 4 1]]
    2×2 Array{Int64,2}:
      5  9
     13  1

类似于``n:n-1``的空范围有时可以用来表示索引之间的位置。例如``searchsorted``函数使用这个方法来表示在有序数组中没有出现的元素：

.. doctest::

    julia> a = [1,2,5,6,7];

    julia> searchsorted(a, 3)
    3:2

.. Empty ranges of the form ``n:n-1`` are sometimes used to indicate the inter-index
.. location between ``n-1`` and ``n``.  For example, the ``searchsorted`` function uses
.. this convention to indicate the insertion point of a value not found in a sorted
.. array:

.. .. doctest::

..     julia> a = [1,2,5,6,7];

..     julia> searchsorted(a, 3)
..     3:2


赋值
----

给 n 维数组 A 赋值的通用语法为： ::

    A[I_1, I_2, ..., I_n] = X

其中 I\_k 可能是：

1. 标量
2. 满足 ``:``, ``a:b``, 或 ``a:b:c`` 格式的 ``Range`` 对象
3. 能够选取整个维度的``:``或者``Colon()``
4. 任意整数数组，包括空数组 ``[]``
5. 能够输出所在位置为``true``的索引所对应元素的布尔数组

.. Assignment
.. ----------

.. The general syntax for assigning values in an n-dimensional array A is::

..     A[I_1, I_2, ..., I_n] = X

.. where each ``I_k`` may be:

.. 1. A scalar integer
.. 2. A ``Range`` of the form ``a:b``, or ``a:b:c``
.. 3. A ``:`` or ``Colon()`` to select entire dimensions
.. 4. An arbitrary integer array, including the empty array ``[]``
.. 5. A boolean array to select elements at its ``true`` indices

如果 ``X`` 是一个数组，它的维度应为 ``(length(I_1), length(I_2), ..., length(I_n))`` ，且 ``A`` 在 ``i_1, i_2, ..., i_n`` 处的值被覆写为 ``X[I_1[i_1], I_2[i_2], ..., I_n[i_n]]`` 。如果 ``X`` 不是数组，它的值被写进所有 ``A`` 被引用的地方。

.. If ``X`` is an array, it must have the same number of elements as the product
.. of the lengths of the indices:
.. ``prod(length(I_1), length(I_2), ..., length(I_n))``. The value in location
.. ``I_1[i_1], I_2[i_2], ..., I_n[i_n]`` of ``A`` is overwritten with the value
.. ``X[i_1, i_2, ..., i_n]``. If ``X`` is not an array, its value
.. is written to all referenced locations of ``A``.

用于索引的布尔值向量与 ``getindex`` 中一样（先由 ``find`` 函数进行转换）。

.. A boolean array used as an index behaves as in :func:`getindex`, behaving as
.. though it is first transformed with :func:`find`.

索引赋值语法等价于调用 ``setindex!`` ： ::

      setindex!(A, X, I_1, I_2, ..., I_n)

例如：

.. doctest::

    julia> x = reshape(1:9, 3, 3)
    3x3 Array{Int64,2}:
     1  4  7
     2  5  8
     3  6  9

    julia> x[1:2, 2:3] = -1
    -1

    julia> x
    3x3 Array{Int64,2}:
     1  -1  -1
     2  -1  -1
     3   6   9

.. Index assignment syntax is equivalent to a call to ``setindex!``

..       setindex!(A, X, I_1, I_2, ..., I_n)

.. Example:


.. _man-array-iteration:

迭代
---------

我们建议使用下面的方法迭代整个数组::

    for a in A
        # Do something with the element a
    end

    for i in eachindex(A)
        # Do something with i and/or A[i]
    end

.. The recommended ways to iterate over a whole array are
.. ::

..     for a in A
..         # Do something with the element a
..     end

..     for i in eachindex(A)
..         # Do something with i and/or A[i]
..     end

在你需要使用具体的值而不是每个元素的索引的时候，使用第一个方法。在第二种方法里，如果``A``是一个有快速线性索引的数组， ``i``将是一个``Int``　类型，否则将会是``CartesianIndex``::

    A = rand(4,3)
    B = view(A, 1:3, 2:3)
    julia> for i in eachindex(B)
               @show i
           end
           i = Base.IteratorsMD.CartesianIndex_2(1,1)
           i = Base.IteratorsMD.CartesianIndex_2(2,1)
           i = Base.IteratorsMD.CartesianIndex_2(3,1)
           i = Base.IteratorsMD.CartesianIndex_2(1,2)
           i = Base.IteratorsMD.CartesianIndex_2(2,2)
           i = Base.IteratorsMD.CartesianIndex_2(3,2)

.. The first construct is used when you need the value, but not index, of each element.  In the second construct, ``i`` will be an ``Int`` if ``A`` is an array
.. type with fast linear indexing; otherwise, it will be a ``CartesianIndex``::

..     A = rand(4,3)
..     B = view(A, 1:3, 2:3)
..     julia> for i in eachindex(B)
..                @show i
..            end
..            i = Base.IteratorsMD.CartesianIndex_2(1,1)
..            i = Base.IteratorsMD.CartesianIndex_2(2,1)
..            i = Base.IteratorsMD.CartesianIndex_2(3,1)
..            i = Base.IteratorsMD.CartesianIndex_2(1,2)
..            i = Base.IteratorsMD.CartesianIndex_2(2,2)
..            i = Base.IteratorsMD.CartesianIndex_2(3,2)

相较``for i = 1:length(A)``，使用``eachindex``更加高效。

.. In contrast with ``for i = 1:length(A)``, iterating with ``eachindex`` provides an efficient way to iterate over any array type.

数组的特性
------------

.. Array traits
.. ------------

如果你写了一个定制的 ``AbstractArray`` 类型，你可以用下面的方法声明它有快速线性索引::

    Base.linearindexing{T<:MyArray}(::Type{T}) = LinearFast()

.. If you write a custom :obj:`AbstractArray` type, you can specify that it has fast linear indexing using
.. ::

..     Base.linearindexing{T<:MyArray}(::Type{T}) = LinearFast()

这个设置会让　``MyArray``（你所定义的数组类型）的　``eachindex``　的迭代使用整数类型。如果你没有声明这个特性，那么会默认使用　``LinearSlow()``。

.. This setting will cause ``eachindex`` iteration over a ``MyArray`` to use integers.  If you don't specify this trait, the default value ``LinearSlow()`` is used.


向量化的运算符和函数
--------------------

数组支持下列运算符。逐元素进行的运算，应使用带“点”（逐元素）版本的二元运算符。

1.  一元： ``-``, ``+``, ``!``
2.  二元： ``+``, ``-``, ``*``, ``.*``, ``/``, ``./``,
    ``\``, ``.\``, ``^``, ``.^``, ``div``, ``mod``
3.  比较： ``.==``, ``.!=``, ``.<``, ``.<=``, ``.>``, ``.>=``
4.  一元布尔值或位运算： ``~``
5.  二元布尔值或位运算： ``&``, ``|``, ``$``

有一些运算符在没有``.``运算符的时候，由于有一个参数是标量同样是是逐元素运算的。这些运算符是``*``, ``+``, ``-``，和位运算符。``/`` 和 ``\``　运算符在分母是标量时也是逐元素计算的。

.. Some operators without dots operate elementwise anyway when one argument is a
.. scalar. These operators are ``*``, ``+``, ``-``, and the bitwise operators. The
.. operators ``/`` and ``\`` operate elementwise when the denominator is a scalar.

注意比较运算，在给定一个布尔值的时候，是对整个数组进行的，比如``==``。在逐元素比较时请使用``.``运算符。

.. Note that comparisons such as ``==`` operate on whole arrays, giving a single
.. boolean answer. Use dot operators for elementwise comparisons.

Julia为将操作广播至整个数组或者数组和标量的混合变量中，提供了 ``f.(args...)`` 这样的兼容语句。这样会使调用向量化的数学操作或者其它运算更加方便。例如 ``sin.(x)``　或者 ``min.(x,y)``。（广播操作）详见　:ref:`man-dot-vectorizing`

.. To enable convenient vectorization of mathematical and other operations, Julia provides
.. the compact syntax ``f.(args...)``, e.g. ``sin.(x)`` or ``min.(x,y)``, for elementwise
.. operations over arrays or mixtures of arrays and scalars (a :func:`broadcast` operation).
.. See :ref:`man-dot-vectorizing`.

注意 ``min`` ``max`` 和 ``minimum`` ``maximum`` 之间的区别，前者是对多个数组操作，找出各数组对应的的元素中的最大最小，后者是作用在一个数组上找出该数组的最大最小值。

.. Note that there is a difference between ``min`` and ``max``, which operate
.. elementwise over multiple array arguments, and ``minimum`` and ``maximum``, which
.. find the smallest and largest values within an array.

.. _man-broadcasting:

广播
------------

有时要对不同维度的数组进行逐元素的二元运算，如将向量加到矩阵的每一列。低效的方法是，把向量复制成同维度的矩阵：

.. It is sometimes useful to perform element-by-element binary operations
.. on arrays of different sizes, such as adding a vector to each column
.. of a matrix.  An inefficient way to do this would be to replicate the
.. vector to the size of the matrix:

.. doctest::

    julia> a = rand(2,1); A = rand(2,3);

    julia> repmat(a,1,3)+A
    2x3 Array{Float64,2}:
     1.20813  1.82068  1.25387
     1.56851  1.86401  1.67846

维度很大时，效率会很低。Julia 提供 ``broadcast`` 函数，它将数组参数的维度进行扩展，使其匹配另一个数组的对应维度，且不需要额外内存，最后再逐元素调用指定的二元函数：

.. This is wasteful when dimensions get large, so Julia offers
.. :func:`broadcast`, which expands singleton dimensions in
.. array arguments to match the corresponding dimension in the other
.. array without using extra memory, and applies the given
.. function elementwise:

.. doctest::

    julia> broadcast(+, a, A)
    2x3 Array{Float64,2}:
     1.20813  1.82068  1.25387
     1.56851  1.86401  1.67846

    julia> b = rand(1,2)
    1x2 Array{Float64,2}:
     0.867535  0.00457906

    julia> broadcast(+, a, b)
    2x2 Array{Float64,2}:
     1.71056  0.847604
     1.73659  0.873631

逐元素的运算符，如 ``.+`` 和 ``.*`` 将会在必要时进行 broadcasting 。还提供了 ``broadcast!`` 函数，可以明确指明目的，而 ``broadcast_getindex`` 和 ``broadcast_setindex!`` 函数可以在索引前对索引值做 broadcast 。

.. Elementwise operators such as ``.+`` and ``.*`` perform broadcasting if necessary. There is also a :func:`broadcast!` function to specify an explicit destination, and :func:`broadcast_getindex` and :func:`broadcast_setindex!` that broadcast the indices before indexing.   Moreover, ``f.(args...)`` is equivalent to ``broadcast(f, args...)``, providing a convenient syntax to broadcast any function (:ref:`man-dot-vectorizing`).

并且，``broadcast``　不仅限于数组（参见函数的文档），它也能用于多元组和并将不是数组和多元组的参数当做“标量”对待。

.. Additionally, :func:`broadcast` is not limited to arrays (see the function documentation), it also handles tuples and treats any argument that is not an array or a tuple as a "scalar".

.. doctest::

    julia> convert.(Float32, [1, 2])
    2-element Array{Float32,1}:
     1.0
     2.0

    julia> ceil.((UInt8,), [1.2 3.4; 5.6 6.7])
    2×2 Array{UInt8,2}:
     0x02  0x04
     0x06  0x07

    julia> string.(1:3, ". ", ["First", "Second", "Third"])
    3-element Array{String,1}:
     "1. First"
     "2. Second"
     "3. Third"


实现
----

Julia 的基础数组类型是抽象类型 ``AbstractArray{T,N}`` ，其中维度为 ``N`` ，元素类型为 ``T`` 。 ``AbstractVector`` 和 ``AbstractMatrix`` 分别是它 1 维 和 2 维的别名。

``AbstractArray`` 类型包含任何形似数组的类型， 而且它的实现和通常的数组会很不一样。例如，任何具体的 ``AbstractArray{T，N}`` 至少要有 ``size(A)`` (返回 ``Int`` 多元组)， ``getindex(A,i)`` 和 ``getindex(A,i1,...,iN)`` (返回 ``T`` 类型的一个元素), 可变的数组要能 ``setindex！``。 这些操作都要求在近乎常数的时间复杂度或 O(1) 复杂度，否则某些数组函数就会特别慢。具体的类型也要提供类似于 ``similar(A,T=eltype(A),dims=size(A))`` 的方法用来分配一个拷贝。

.. The :obj:`AbstractArray` type includes anything vaguely array-like, and
.. implementations of it might be quite different from conventional
.. arrays. For example, elements might be computed on request rather than
.. stored.  However, any concrete ``AbstractArray{T,N}`` type should
.. generally implement at least :func:`size(A) <size>` (returning an ``Int`` tuple),
.. :func:`getindex(A,i) <getindex>` and :func:`getindex(A,i1,...,iN) <getindex>`;
.. mutable arrays should also implement :func:`setindex!`.  It
.. is recommended that these operations have nearly constant time complexity,
.. or technically Õ(1) complexity, as otherwise some array functions may
.. be unexpectedly slow.   Concrete types should also typically provide
.. a :func:`similar(A,T=eltype(A),dims=size(A)) <similar>` method, which is used to allocate
.. a similar array for :func:`copy` and other out-of-place operations.
.. No matter how an ``AbstractArray{T,N}`` is represented internally,
.. ``T`` is the type of object returned by *integer* indexing (``A[1,
.. ..., 1]``, when ``A`` is not empty) and ``N`` should be the length of
.. the tuple returned by :func:`size`.

``DenseArray``　是``AbstractArray``的一个抽象子类型，它包含了所有的在内存中使用常规形式分配内存，并且也因此能够传递给C和Fortran语言的数组。子类型需要提供``stride(A,k)``方法用以返回第``k``维的间隔：给维度 ``k``　索引增加 ``1``　将会给　:func:`getindex(A,i) <getindex>`　的第 ``i``　个索引增加　:func:`stride(A,k) <stride>`。　如果提供了指针的转换函数:func:`Base.unsafe_convert(Ptr{T}, A) <unsafe_convert>`　那么，内存的分布将会和这些维度的间隔相同。

.. :obj:`DenseArray` is an abstract subtype of :obj:`AbstractArray` intended
.. to include all arrays that are laid out at regular offsets in memory,
.. and which can therefore be passed to external C and Fortran functions
.. expecting this memory layout.  Subtypes should provide a method
.. :func:`stride(A,k) <stride>` that returns the "stride" of dimension ``k``:
.. increasing the index of dimension ``k`` by ``1`` should increase the
.. index ``i`` of :func:`getindex(A,i) <getindex>` by :func:`stride(A,k) <stride>`.  If a
.. pointer conversion method :func:`Base.unsafe_convert(Ptr{T}, A) <unsafe_convert>` is provided, the
.. memory layout should correspond in the same way to these strides.

``Array{T,N}`` 类型是 ``DenseArray`` 的特殊实例，它的元素以列序为主序存储（详见 :ref:`man-performance-tips` ）。 ``Vector`` 和 ``Matrix`` 是分别是它 1 维 和 2 维的别名。

.. The :obj:`Array` type is a specific instance of :obj:`DenseArray`
.. where elements are stored in column-major order (see additional notes in
.. :ref:`man-performance-tips`). :obj:`Vector` and :obj:`Matrix` are aliases for
.. the 1-d and 2-d cases. Specific operations such as scalar indexing,
.. assignment, and a few other basic storage-specific operations are all
.. that have to be implemented for :obj:`Array`, so that the rest of the array
.. library can be implemented in a generic manner.

``SubArray`` 是 ``AbstractArray`` 的特殊实例，它通过引用而不是复制来进行索引。使用 ``sub`` 函数来构造 ``SubArray`` ，它的调用方式与 ``getindex`` 相同（使用数组和一组索引参数）。 ``sub`` 的结果与 ``getindex`` 的结果类似，但它的数据仍留在原地。 ``sub`` 在 ``SubArray`` 对象中保存输入的索引向量，这个向量将被用来间接索引原数组。

.. :obj:`SubArray` is a specialization of :obj:`AbstractArray` that performs
.. indexing by reference rather than by copying. A :obj:`SubArray` is created
.. with the :func:`view` function, which is called the same way as :func:`getindex`
.. (with an array and a series of index arguments). The result of :func:`view` looks
.. the same as the result of :func:`getindex`, except the data is left in place.
.. :func:`view` stores the input index vectors in a :obj:`SubArray` object, which
.. can later be used to index the original array indirectly.

``StridedVector`` 和 ``StridedMatrix`` 是为了方便而定义的别名。通过给他们传递 ``Array`` 或 ``SubArray`` 对象，可以使 Julia 大范围调用 BLAS 和 LAPACK 函数，提高内存申请和复制的效率。

.. :obj:`StridedVector` and :obj:`StridedMatrix` are convenient aliases defined
.. to make it possible for Julia to call a wider range of BLAS and LAPACK
.. functions by passing them either :obj:`Array` or :obj:`SubArray` objects, and
.. thus saving inefficiencies from memory allocation and copying.

下面的例子计算大数组中的一个小块的 QR 分解，无需构造临时变量，直接调用合适的 LAPACK 函数。

.. The following example computes the QR decomposition of a small section
.. of a larger array, without creating any temporaries, and by calling the
.. appropriate LAPACK function with the right leading dimension size and
.. stride parameters.

.. doctest::

    julia> a = rand(10,10)
    10×10 Array{Float64,2}:
     0.561255   0.226678   0.203391  0.308912   …  0.750307  0.235023   0.217964
     0.718915   0.537192   0.556946  0.996234      0.666232  0.509423   0.660788
     0.493501   0.0565622  0.118392  0.493498      0.262048  0.940693   0.252965
     0.0470779  0.736979   0.264822  0.228787      0.161441  0.897023   0.567641
     0.343935   0.32327    0.795673  0.452242      0.468819  0.628507   0.511528
     0.935597   0.991511   0.571297  0.74485    …  0.84589   0.178834   0.284413
     0.160706   0.672252   0.133158  0.65554       0.371826  0.770628   0.0531208
     0.306617   0.836126   0.301198  0.0224702     0.39344   0.0370205  0.536062
     0.890947   0.168877   0.32002   0.486136      0.096078  0.172048   0.77672
     0.507762   0.573567   0.220124  0.165816      0.211049  0.433277   0.539476

    julia> b = view(a, 2:2:8,2:2:4)
    4×2 SubArray{Float64,2,Array{Float64,2},Tuple{StepRange{Int64,Int64},StepRange{Int64,Int64}},false}:
     0.537192  0.996234
     0.736979  0.228787
     0.991511  0.74485
     0.836126  0.0224702

    julia> (q,r) = qr(b);

    julia> q
    4×2 Array{Float64,2}:
     -0.338809   0.78934
     -0.464815  -0.230274
     -0.625349   0.194538
     -0.527347  -0.534856

    julia> r
    2×2 Array{Float64,2}:
     -1.58553  -0.921517
      0.0       0.866567

稀疏矩阵
========

`稀疏矩阵 <http://zh.wikipedia.org/zh-cn/%E7%A8%80%E7%96%8F%E7%9F%A9%E9%98%B5>`_ 是其元素大部分为 0 ，并以特殊的形式来节省空间和执行时间的存储数据的矩阵。稀疏矩阵适用于当使用这些稀疏矩阵的表示方式能够获得明显优于稠密矩阵的情况。

列压缩（CSC）存储
-----------------

Julia 中，稀疏矩阵使用 `列压缩（CSC）格式 <http://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29>`_ 。Julia 稀疏矩阵的类型为 ``SparseMatrixCSC{Tv,Ti}`` ，其中 ``Tv`` 是非零元素的类型， ``Ti`` 是整数类型，存储列指针和行索引： ::

    type SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrix{Tv,Ti}
        m::Int                  # Number of rows
        n::Int                  # Number of columns
        colptr::Vector{Ti}      # Column i is in colptr[i]:(colptr[i+1]-1)
        rowval::Vector{Ti}      # Row values of nonzeros
        nzval::Vector{Tv}       # Nonzero values
    end

列压缩存储便于按列简单快速地存取稀疏矩阵的元素，但按行存取则较慢。把非零值插入 CSC 结构等运算，都比较慢，这是因为稀疏矩阵中，在所插入元素后面的元素，都要逐一移位。

如果你从其他地方获得的数据是 CSC 格式储存的，想用 Julia 来读取，应确保它的序号从 1 开始索引。每一列中的行索引值应该是排好序的。如果你的 `SparseMatrixCSC` 对象包含未排序的行索引值，对它们进行排序的最快的方法是转置两次。

.. If you have data in CSC format from a different application or library,
.. and wish to import it in Julia, make sure that you use 1-based indexing.
.. The row indices in every column need to be sorted. If your `SparseMatrixCSC`
.. object contains unsorted row indices, one quick way to sort them is by
.. doing a double transpose.

有时，在 `SparseMatrixCSC` 中存储一些零值，后面的运算比较方便。 ``Base`` 中允许这种行为（但是不保证在操作中会一直保留这些零值）。这些被存储的零被许多函数认为是非零值。 ``nnz`` 函数返回稀疏数据结构中存储的元素数目，包括被存储的零。要想得到准确的非零元素的数目，请使用 ``countnz`` 函数，它挨个检查每个元素的值（因此它的时间复杂度不再是常数，而是与元素数目成正比）。

.. In some applications, it is convenient to store explicit zero values
.. in a `SparseMatrixCSC`. These *are* accepted by functions in ``Base``
.. (but there is no guarantee that they will be preserved in mutating
.. operations).  Such explicitly stored zeros are treated as structural
.. nonzeros by many routines.  The ``nnz`` function returns the number of
.. elements explicitly stored in the sparse data structure,
.. including structural nonzeros. In order to count the exact number of actual
.. values that are nonzero, use ``countnz``, which inspects every stored
.. element of a sparse matrix.

构造稀疏矩阵
------------

稠密矩阵有 ``zeros`` 和 ``eye`` 函数，稀疏矩阵对应的函数，在函数名前加 ``sp`` 前缀即可：

.. doctest::

    julia> spzeros(3,5)
    3x5 sparse matrix with 0 Float64 entries:

    julia> speye(3,5)
    3x5 sparse matrix with 3 Float64 entries:
            [1, 1]  =  1.0
            [2, 2]  =  1.0
            [3, 3]  =  1.0

``sparse`` 函数是比较常用的构造稀疏矩阵的方法。它输入行索引 ``I`` ，列索引向量 ``J`` ，以及非零值向量 ``V`` 。 ``sparse(I,J,V)`` 构造一个满足 ``S[I[k], J[k]] = V[k]`` 的稀疏矩阵：

.. doctest::

    julia> I = [1, 4, 3, 5]; J = [4, 7, 18, 9]; V = [1, 2, -5, 3];

    julia> S = sparse(I,J,V)
    5x18 sparse matrix with 4 Int64 entries:
            [1 ,  4]  =  1
            [4 ,  7]  =  2
            [5 ,  9]  =  3
            [3 , 18]  =  -5

与 ``sparse`` 相反的函数为 ``findn`` ，它返回构造稀疏矩阵时的输入：

.. doctest::

    julia> findn(S)
    ([1,4,5,3],[4,7,9,18])

    julia> findnz(S)
    ([1,4,5,3],[4,7,9,18],[1,2,3,-5])

另一个构造稀疏矩阵的方法是，使用 ``sparse`` 函数将稠密矩阵转换为稀疏矩阵：

.. doctest::

    julia> sparse(eye(5))
    5x5 sparse matrix with 5 Float64 entries:
            [1, 1]  =  1.0
            [2, 2]  =  1.0
            [3, 3]  =  1.0
            [4, 4]  =  1.0
            [5, 5]  =  1.0

可以使用 ``dense`` 或 ``full`` 函数做逆操作。 ``issparse`` 函数可用来检查矩阵是否稀疏：

.. doctest::

    julia> issparse(speye(5))
    true

稀疏矩阵运算
------------

稠密矩阵的算术运算也可以用在稀疏矩阵上。对稀疏矩阵进行赋值运算，是比较费资源的。大多数情况下，建议使用 ``findnz`` 函数把稀疏矩阵转换为 ``(I,J,V)`` 格式，在非零数或者稠密向量 ``(I,J,V)`` 的结构上做运算，最后再重构回稀疏矩阵。

稠密矩阵和稀疏矩阵函数对应关系
------------------------------

接下来的表格列出了内置的稀疏矩阵的函数, 及其对应的稠密矩阵的函数。通常，稀疏矩阵的函数，要么返回与输入稀疏矩阵 ``S`` 同样的稀疏度，要么返回   ``d`` 稠密度，例如矩阵的每个元素是非零的概率为 ``d`` 。

详见可以标准库文档的 :ref:`stdlib-sparse` 章节。

.. tabularcolumns:: |l|l|L|

+-----------------------+-------------------+----------------------------------------+
| 稀疏矩阵              | 稠密矩阵          | 说明                                   |
+-----------------------+-------------------+----------------------------------------+
| ``spzeros(m,n)``      | ``zeros(m,n)``    | 构造 *m* x *n* 的全 0 矩阵             |
|                       |                   | (``spzeros(m,n)`` 是空矩阵)            |
+-----------------------+-------------------+----------------------------------------+
| ``spones(S)``         | ``ones(m,n)``     | 构造的全 1 矩阵                        |
|                       |                   | 与稠密版本的不同， ``spones``  的稀疏  |
|                       |                   | 度与 *S* 相同                          |
+-----------------------+-------------------+----------------------------------------+
| ``speye(n)``          | ``eye(n)``        | 构造 *m* x *n* 的单位矩阵              |
+-----------------------+-------------------+----------------------------------------+
| ``full(S)``           | ``sparse(A)``     | 转换为稀疏矩阵和稠密矩阵               |
+-----------------------+-------------------+----------------------------------------+
| ``sprand(m,n,d)``     | ``rand(m,n)``     | 构造 *m*-by-*n* 的随机矩阵（稠密度为   |
|                       |                   | *d* ） 独立同分布的非零元素在 [0, 1]   |
|                       |                   | 内均匀分布                             |
+-----------------------+-------------------+----------------------------------------+
| ``sprandn(m,n,d)``    | ``randn(m,n)``    | 构造 *m*-by-*n* 的随机矩阵（稠密度为   |
|                       |                   | *d* ） 独立同分布的非零元素满足标准正  |
|                       |                   | 态（高斯）分布                         |
+-----------------------+-------------------+----------------------------------------+
| ``sprandn(m,n,d,X)``  | ``randn(m,n,X)``  | 构造 *m*-by-*n* 的随机矩阵（稠密度为   |
|                       |                   | *d* ） 独立同分布的非零元素满足 *X* 分 |
|                       |                   | 布。（需要 ``Distributions`` 扩展包）  |
+-----------------------+-------------------+----------------------------------------+
| ``sprandbool(m,n,d)`` | ``randbool(m,n)`` | 构造 *m*-by-*n* 的随机矩阵（稠密度为   |
|                       |                   | *d* ） ，非零 ``Bool``元素的概率为 *d* |
|                       |                   | (``randbool`` 中 *d* =0.5 )            |
+-----------------------+-------------------+----------------------------------------+
