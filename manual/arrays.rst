.. _man-arrays:

**********
 多维数组
**********
.. **************************
..  Multi-dimensional Arrays
.. **************************

数组是一个存在多维网格中的对象集合。通常，数组包含的对象的类型为 ``Any`` 。对大多数计算而言，数组对象一般更具体为 ``Float64`` 或 ``Int32`` 。

.. Julia, like most technical computing languages, provides a first-class
.. array implementation. Most technical computing languages pay a lot of
.. attention to their array implementation at the expense of other
.. containers. Julia does not treat arrays in any special way. The array
.. library is implemented almost completely in Julia itself, and derives
.. its performance from the compiler, just like any other code written in
.. Julia.

.. An array is a collection of objects stored in a multi-dimensional
.. grid.  In the most general case, an array may contain objects of type
.. ``Any``.  For most computational purposes, arrays should contain
.. objects of a more specific type, such as ``Float64`` or ``Int32``.

因为性能的原因，Julia 不希望把程序写成向量化的形式。

.. In general, unlike many other technical computing languages, Julia does
.. not expect programs to be written in a vectorized style for performance.
.. Julia's compiler uses type inference and generates optimized code for
.. scalar array indexing, allowing programs to be written in a style that
.. is convenient and readable, without sacrificing performance, and using
.. less memory at times.


在 Julia 中，通过引用将参数传递给函数。Julia 的库函数不会修改传递给它的输入。用户写代码时，如果要想做类似的功能，要注意先把输入复制一份儿。

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
``eltype(A)``   A 中元素的类型
``length(A)``   A 中元素的个数
``ndims(A)``    A 有几个维度
``nnz(A)``      A 中非零元素的个数
``size(A)``     返回一个元素为 A 的维度的多元组
``size(A,n)``   A 在某个维度上的长度
``stride(A,k)`` 在维度 k 上，邻接元素（在内存中）的线性索引距离
``strides(A)``  返回多元组，其元素为在每个维度上，邻接元素（在内存中）的线性索引距离
=============== ========================================================================

.. =============== ==============================================================================
.. Function        Description
.. =============== ==============================================================================
.. ``eltype(A)``   the type of the elements contained in A
.. ``length(A)``   the number of elements in A
.. ``ndims(A)``    the number of dimensions of A
.. ``size(A)``     a tuple containing the dimensions of A
.. ``size(A,n)``   the size of A in a particular dimension
.. ``stride(A,k)`` the stride (linear index distance between adjacent elements) along dimension k
.. ``strides(A)``  a tuple of the strides in each dimension
.. =============== ==============================================================================

构造和初始化
------------
.. Construction and Initialization
.. -------------------------------

下列函数中调用的 ``dims...`` 参数，既可以是维度的单多元组，也可以是维度作为可变参数时的一组值。

.. Many functions for constructing and initializing arrays are provided. In
.. the following list of such functions, calls with a ``dims...`` argument
.. can either take a single tuple of dimension sizes or a series of
.. dimension sizes passed as a variable number of arguments.


===================================== =====================================================================
函数                                  说明
===================================== =====================================================================
``Array(type, dims...)``              未初始化的稠密数组
``cell(dims...)``                     未初始化的元胞数组（异构数组）
``zeros(type, dims...)``              指定类型的全 0 数组
``ones(type, dims...)``               指定类型的全 1 数组
``trues(dims...)``                    全 ``true`` 的 ``Bool`` 数组
``falses(dims...)``                   全 ``false`` 的 ``Bool`` 数组
``reshape(A, dims...)``               将数组中的数据按照指定维度排列
``copy(A)``                           复制 ``A``
``deepcopy(A)``                       复制 ``A`` ，并递归复制其元素
``similar(A, element_type, dims...)`` 属性与输入数组（稠密、稀疏等）相同的未初始化数组，但指明了元素类型和维度。
                                      第二、三参数可省略，省略时默认为 ``A`` 的元素类型和维度
``reinterpret(type, A)``              二进制数据与输入数组相同的数组，但指明了元素类型
``rand(dims)``                        在 [0,1) 上独立均匀同分布的 ``Float64`` 类型的随机数组
``randn(dims)``                       ``Float64`` 类型的独立正态同分布的随机数组，均值为 0 ，标准差为 1
``eye(n)``                            ``n`` x ``n`` 单位矩阵
``eye(m, n)``                         ``m`` x ``n`` 单位矩阵
``linspace(start, stop, n)``          从 ``start`` 至 ``stop`` 的由 ``n`` 个元素构成的线性向量
``fill!(A, x)``                       用值 ``x`` 填充数组 ``A``
===================================== =====================================================================

.. ===================================== =====================================================================
.. Function                              Description
.. ===================================== =====================================================================
.. ``Array(type, dims...)``              an uninitialized dense array
.. ``cell(dims...)``                     an uninitialized cell array (heterogeneous array)
.. ``zeros(type, dims...)``              an array of all zeros of specified type
.. ``ones(type, dims...)``               an array of all ones of specified type
.. ``trues(dims...)``                    a ``Bool`` array with all values ``true``
.. ``falses(dims...)``                   a ``Bool`` array with all values ``false``
.. ``reshape(A, dims...)``               an array with the same data as the given array, but with
..                                       different dimensions.
.. ``copy(A)``                           copy ``A``
.. ``deepcopy(A)``                       copy ``A``, recursively copying its elements
.. ``similar(A, element_type, dims...)`` an uninitialized array of the same type as the given array
..                                       (dense, sparse, etc.), but with the specified element type and
..                                       dimensions. The second and third arguments are both optional,
..                                       defaulting to the element type and dimensions of ``A`` if omitted.
.. ``reinterpret(type, A)``              an array with the same binary data as the given array, but with the
..                                       specified element type
.. ``rand(dims)``                        ``Array`` of ``Float64``\ s with random, iid[#]_ and uniformly
..                                       distributed values in [0,1)
.. ``randn(dims)``                       ``Array`` of ``Float64``\ s with random, iid and standard normally
..                                       distributed random values
.. ``eye(n)``                            ``n``-by-``n`` identity matrix
.. ``eye(m, n)``                         ``m``-by-``n`` identity matrix
.. ``linspace(start, stop, n)``          vector of ``n`` linearly-spaced elements from ``start`` to ``stop``
.. ``fill!(A, x)``                       fill the array ``A`` with value ``x``
.. ===================================== =====================================================================

.. .. [#] *iid*, independently and identically distributed.


连接
----

使用下列函数，可在任意维度连接数组：

================ ======================================================
Function         Description
================ ======================================================
``cat(k, A...)`` concatenate input n-d arrays along the dimension ``k``
``vcat(A...)``   shorthand for ``cat(1, A...)``
``hcat(A...)``   shorthand for ``cat(2, A...)``
================ ======================================================

Scalar values passed to these functions are treated as 1-element arrays.

The concatenation functions are used so often that they have special syntax:

=================== =========
Expression          Calls
=================== =========
``[A B C ...]``     ``hcat``
``[A, B, C, ...]``  ``vcat``
``[A B; C D; ...]`` ``hvcat``
=================== =========

``hvcat`` concatenates in both dimension 1 (with semicolons) and dimension 2
(with spaces).

.. _comprehensions:

Comprehensions
--------------

Comprehensions 用于构造数组。它的语法类似于数学中的集合标记法： ::

    A = [ F(x,y,...) for x=rx, y=ry, ... ]

``F(x,y,...)`` 根据变量 ``x``, ``y`` 等来求值。这些变量的值可以是任何迭代对象，但大多数情况下，都使用类似于 ``1:n`` 或 ``2:(n-1)`` 的范围对象，或显式指明为类似 ``[1.2, 3.4, 5.7]`` 的数组。它的结果是 N 维稠密数组。

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

    julia> const x = rand(8)
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

.. note:: 上例中， ``x`` 被声明为常量，因为对于非常量的全局变量，Julia 的类型推断不怎么样。

.. .. note:: In the above example, ``x`` is declared as constant because type
..   inference in Julia does not work as well on non-constant global
..   variables.

可在 comprehension 之前显式指明它的类型。如要避免在前例中声明 ``x`` 为常量，但仍要确保结果类型为 ``Float64`` ，应这样写： ::

    Float64[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]

使用花括号来替代方括号，可以将它简写为 ``Any`` 类型的数组：

.. The resulting array type is inferred from the expression; in order to control
.. the type explicitly, the type can be prepended to the comprehension. For example,
.. in the above example we could have avoided declaring ``x`` as constant, and ensured
.. that the result is of type ``Float64`` by writing

..  Float64[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]

.. Using curly brackets instead of square brackets is a shorthand notation for an
.. array of type ``Any``:

.. doctest::

    julia> { i/2 for i = 1:3 }
    3-element Array{Any,1}:
     0.5
     1.0
     1.5

.. _man-array-indexing:

索引
----

索引 n 维数组 A 的通用语法为： ::

    X = A[I_1, I_2, ..., I_n]

其中 I\_k 可以是：

1. 标量
2. 满足 ``:``, ``a:b``, 或 ``a:b:c`` 格式的 ``Range`` 对象
3. 任意整数向量，包括空向量 ``[]``
4. 布尔值向量

.. The general syntax for indexing into an n-dimensional array A is

..     X = A[I_1, I_2, ..., I_n]

.. where each I\_k may be:

.. 1. A scalar value
.. 2. A ``Range`` of the form ``:``, ``a:b``, or ``a:b:c``
.. 3. An arbitrary integer vector, including the empty vector ``[]``
.. 4. A boolean vector

结果 X 的维度通常为 ``(length(I_1), length(I_2), ..., length(I_n))`` ，且 X 的索引 ``(i_1, i_2, ..., i_n)`` 处的值为 ``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]`` 。缀在后面的标量索引的维度信息被舍弃。如，``A[I, 1]`` 的维度为 ``(length(I),)`` 。布尔值向量先由 ``find`` 函数进行转换。由布尔值向量索引的维度长度，是向量中 ``true`` 值的个数。

.. The result X generally has dimensions
.. ``(length(I_1), length(I_2), ..., length(I_n))``, with location
.. ``(i_1, i_2, ..., i_n)`` of X containing the value
.. ``A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]``. Trailing dimensions indexed with
.. scalars are dropped. For example, the dimensions of ``A[I, 1]`` will be
.. ``(length(I),)``. Boolean vectors are first transformed with ``find``; the size of
.. a dimension indexed by a boolean vector will be the number of true values in the vector.

索引语法与调用 ``getindex`` 等价： ::

    X = getindex(A, I_1, I_2, ..., I_n)

例如：

.. doctest::

    julia> x = reshape(1:16, 4, 4)
    4x4 Array{Int64,2}:
     1  5   9  13
     2  6  10  14
     3  7  11  15
     4  8  12  16

    julia> x[2:3, 2:end-1]
    2x2 Array{Int64,2}:
     6  10
     7  11

Empty ranges of the form ``n:n-1`` are sometimes used to indicate the inter-index
location between ``n-1`` and ``n``.  For example, the ``searchsorted`` function uses
this convention to indicate the insertion point of a value not found in a sorted
array:

.. doctest::

    julia> a = [1,2,5,6,7];

    julia> searchsorted(a, 3)
    3:2

.. Indexing syntax is equivalent to a call to ``getindex``

..     X = getindex(A, I_1, I_2, ..., I_n)

.. Example:

赋值
----

给 n 维数组 A 赋值的通用语法为： ::

    A[I_1, I_2, ..., I_n] = X

其中 I\_k 可能是：

1. 标量
2. 满足 ``:``, ``a:b``, 或 ``a:b:c`` 格式的 ``Range``  对象
3. 任意整数向量，包括空向量 ``[]``
4. 布尔值向量

.. Assignment
.. ----------

.. The general syntax for assigning values in an n-dimensional array A is

..     A[I_1, I_2, ..., I_n] = X

.. where each I\_k may be:

.. 1. A scalar value
.. 2. A ``Range`` of the form ``:``, ``a:b``, or ``a:b:c``
.. 3. An arbitrary integer vector, including the empty vector ``[]``
.. 4. A boolean vector

如果 ``X`` 是一个数组，它的维度应为 ``(length(I_1), length(I_2), ..., length(I_n))`` ，且 ``A`` 在 ``i_1, i_2, ..., i_n`` 处的值被覆写为 ``X[I_1[i_1], I_2[i_2], ..., I_n[i_n]]`` 。如果 ``X`` 不是数组，它的值被写进所有 ``A`` 被引用的地方。

.. If ``X`` is an array, its size must be ``(length(I_1), length(I_2), ..., length(I_n))``,
.. and the value in location ``i_1, i_2, ..., i_n`` of ``A`` is overwritten with
.. the value ``X[I_1[i_1], I_2[i_2], ..., I_n[i_n]]``. If ``X`` is not an array, its
.. value is written to all referenced locations of ``A``.

用于索引的布尔值向量与 ``getindex`` 中一样（先由 ``find`` 函数进行转换）。

.. A boolean vector used as an index behaves as in ``getindex`` (it is first transformed
.. with ``find``).

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


向量化的运算符和函数
--------------------

数组支持下列运算符。逐元素进行的运算，应使用带“点”（逐元素）版本的二元运算符。

1.  一元： ``-``, ``+``, ``!``
2.  二元： ``+``, ``-``, ``*``, ``.*``, ``/``, ``./``,
    ``\``, ``.\``, ``^``, ``.^``, ``div``, ``mod``
3.  比较： ``.==``, ``.!=``, ``.<``, ``.<=``, ``.>``, ``.>=``
4.  一元布尔值或位运算： ``~``
5.  二元布尔值或位运算： ``&``, ``|``, ``$``

Some operators without dots operate elementwise anyway when one argument is a
scalar. These operators are ``*``, ``/``, ``\``, and the bitwise
operators.

Note that comparisons such as ``==`` operate on whole arrays, giving a single
boolean answer. Use dot operators for elementwise comparisons.

下列内置的函数也都是向量化的, 即函数是逐元素版本的： ::

    abs abs2 angle cbrt
    airy airyai airyaiprime airybi airybiprime airyprime
    acos acosh asin asinh atan atan2 atanh
    acsc acsch asec asech acot acoth
    cos  cospi cosh  sin  sinpi sinh  tan  tanh  sinc  cosc
    csc  csch  sec  sech  cot  coth
    acosd asind atand asecd acscd acotd
    cosd  sind  tand  secd  cscd  cotd
    besselh besseli besselj besselj0 besselj1 besselk bessely bessely0 bessely1
    exp  erf  erfc  erfinv erfcinv exp2  expm1
    beta dawson digamma erfcx erfi
    exponent eta zeta gamma
    hankelh1 hankelh2
     ceil  floor  round  trunc
    iceil ifloor iround itrunc
    isfinite isinf isnan
    lbeta lfact lgamma
    log log10 log1p log2
    copysign max min significand
    sqrt hypot

注意 ``min`` ``max`` 和 ``minimum`` ``maximum`` 之间的区别，前者是对多个数组操作，找出各数组对应的的元素中的最大最小，后者是作用在一个数组上找出该数组的最大最小值。

.. Note that there is a difference between ``min`` and ``max``, which operate
.. elementwise over multiple array arguments, and ``minimum`` and ``maximum``, which
.. find the smallest and largest values within an array.


Julia 提供了 ``@vectorize_1arg`` 和 ``@vectorize_2arg`` 两个宏，分别用来向量化任意的单参数或两个参数的函数。每个宏都接收两个参数，即函数参数的类型和函数名。例如：

.. doctest::

    julia> square(x) = x^2
    square (generic function with 1 method)

    julia> @vectorize_1arg Number square
    square (generic function with 4 methods)

    julia> methods(square)
    # 4 methods for generic function "square":
    square{T<:Number}(::AbstractArray{T<:Number,1}) at operators.jl:359
    square{T<:Number}(::AbstractArray{T<:Number,2}) at operators.jl:360
    square{T<:Number}(::AbstractArray{T<:Number,N}) at operators.jl:362
    square(x) at none:1

    julia> square([1 2 4; 5 6 7])
    2x3 Array{Int64,2}:
      1   4  16
     25  36  49

Broadcasting
------------

有时要对不同维度的数组进行逐元素的二元运算，如将向量加到矩阵的每一列。低效的方法是，把向量复制成同维度的矩阵：

.. doctest::

    julia> a = rand(2,1); A = rand(2,3);

    julia> repmat(a,1,3)+A
    2x3 Array{Float64,2}:
     1.20813  1.82068  1.25387
     1.56851  1.86401  1.67846

维度很大时，效率会很低。Julia 提供 ``broadcast`` 函数，它将数组参数的维度进行扩展，使其匹配另一个数组的对应维度，且不需要额外内存，最后再逐元素调用指定的二元函数：

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

实现
----

Julia 的基础数组类型是抽象类型 ``AbstractArray{T,N}`` ，其中维度为 ``N`` ，元素类型为 ``T`` 。 ``AbstractVector`` 和 ``AbstractMatrix`` 分别是它 1 维 和 2 维的别名。

``AbstractArray`` 类型包含任何形似数组的类型， 而且它的实现和通常的数组会很不一样。例如，任何具体的 ``AbstractArray{T，N}`` 至少要有 ``size(A)`` (返回 ``Int`` 多元组)， ``getindex(A,i)`` 和 ``getindex(A,i1,...,iN)`` (返回 ``T`` 类型的一个元素), 可变的数组要能 ``setindex！``。 这些操作都要求在近乎常数的时间复杂度或 O(1) 复杂度，否则某些数组函数就会特别慢。具体的类型也要提供类似于 ``similar(A,T=eltype(A),dims=size(A))`` 的方法用来分配一个拷贝。

.. The ``AbstractArray`` type includes anything vaguely array-like, and
.. implementations of it might be quite different from conventional
.. arrays. For example, elements might be computed on request rather than
.. stored.  However, any concrete ``AbstractArray{T,N}`` type should
.. generally implement at least ``size(A)`` (returing an ``Int`` tuple),
.. ``getindex(A,i)`` and ``getindex(A,i1,...,iN)`` (returning an element
.. of type ``T``); mutable arrays should also implement ``setindex!``.  It
.. is recommended that these operations have nearly constant time complexity,
.. or technically Õ(1) complexity, as otherwise some array functions may
.. be unexpectedly slow.   Concrete types should also typically provide
.. a `similar(A,T=eltype(A),dims=size(A))` method, which is used to allocate
.. a similar array for `copy` and other out-of-place operations.

``DenseArray`` is an abstract subtype of ``AbstractArray`` intended
to include all arrays that are laid out at regular offsets in memory,
and which can therefore be passed to external C and Fortran functions
expecting this memory layout.  Subtypes should provide a method
``stride(A,k)`` that returns the "stride" of dimension ``k``:
increasing the index of dimension ``k`` by ``1`` should increase the
index ``i`` of ``getindex(A,i)`` by ``stride(A,k)``.  If a
pointer conversion method ``convert(Ptr{T}, A)`` is provided, the
memory layout should correspond in the same way to these strides.

``Array{T,N}`` 类型是 ``DenseArray`` 的特殊实例，它的元素以列序为主序存储（详见 :ref:`man-performance-tips` ）。 ``Vector`` 和 ``Matrix`` 是分别是它 1 维 和 2 维的别名。

``SubArray`` 是 ``AbstractArray`` 的特殊实例，它通过引用而不是复制来进行索引。使用 ``sub`` 函数来构造 ``SubArray`` ，它的调用方式与 ``getindex`` 相同（使用数组和一组索引参数）。 ``sub`` 的结果与 ``getindex`` 的结果类似，但它的数据仍留在原地。 ``sub`` 在 ``SubArray`` 对象中保存输入的索引向量，这个向量将被用来间接索引原数组。

``StridedVector`` 和 ``StridedMatrix`` 是为了方便而定义的别名。通过给他们传递 ``Array`` 或 ``SubArray`` 对象，可以使 Julia 大范围调用 BLAS 和 LAPACK 函数，提高内存申请和复制的效率。

下面的例子计算大数组中的一个小块的 QR 分解，无需构造临时变量，直接调用合适的 LAPACK 函数。

.. doctest::

    julia> a = rand(10,10)
    10x10 Array{Float64,2}:
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

    julia> b = sub(a, 2:2:8,2:2:4)
    4x2 SubArray{Float64,2,Array{Float64,2},(StepRange{Int64,Int64},StepRange{Int64,Int64})}:
     0.537192  0.996234
     0.736979  0.228787
     0.991511  0.74485
     0.836126  0.0224702

    julia> (q,r) = qr(b);

    julia> q
    4x2 Array{Float64,2}:
     -0.338809   0.78934
     -0.464815  -0.230274
     -0.625349   0.194538
     -0.527347  -0.534856

    julia> r
    2x2 Array{Float64,2}:
     -1.58553  -0.921517
      0.0       0.866567

稀疏矩阵
========

`稀疏矩阵 <http://zh.wikipedia.org/zh-cn/%E7%A8%80%E7%96%8F%E7%9F%A9%E9%98%B5>`_ 是其元素大部分为 0 的矩阵。

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
