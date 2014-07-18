.. _man-performance-tips:

**************
 代码性能优化
**************

以下几节将描述一些提高 Julia 代码运行速度的技巧。

避免全局变量
------------

全局变量的值、类型，都可能变化。这使得编译器很难优化使用全局变量的代码。应尽量使用局部变量，或者把变量当做参数传递给函数。

对性能至关重要的代码，应放入函数中。

声明全局变量为常量可以显著提高性能： ::

    const DEFAULT_VAL = 0

使用非常量的全局变量时，最好在使用时指明其类型，这样也能帮助编译器优化： ::

    global x
    y = f(x::Int + 1)

Writing functions is better style. It leads to more reusable code and
clarifies what steps are being done, and what their inputs and outputs
are.

Avoid containers with abstract type parameters
----------------------------------------------

When working with parameterized types, including arrays, it is best to
avoid parameterizing with abstract types where possible.

Consider the following::

    a = Real[]    # typeof(a) = Array{Real,1}
    if (f = rand()) < .8
        push!(a, f)
    end

Because ``a`` is a an array of abstract type ``Real``, it must be able
to hold any Real value.  Since ``Real`` objects can be of arbitrary
size and structure, ``a`` must be represented as an array of pointers to
individually allocated ``Real`` objects.  Because ``f`` will always be
a ``Float64``, we should instead, use::

    a = Float64[] # typeof(a) = Array{Float64,1}

which will create a contiguous block of 64-bit floating-point values
that can be manipulated efficiently.

See also the discussion under :ref:`man-parametric-types`.

类型声明
--------

在 Julia 中，编译器能推断出所有的函数参数与局部变量的类型，因此声名变量类型不能提高性能。然而在有些具体实例中，声明类型还是非常有用的。

给复合类型做类型声明
~~~~~~~~~~~~~~~~~~~~

假如有一个如下的自定义类型： ::

    type Foo
        field
    end

编译器推断不出 ``foo.field`` 的类型，因为当它指向另一个不同类型的值时，它的类型也会被修改。这时最好声明具体的类型，比如 ``field::Float64`` 或者 ``field::Array{Int64,1}`` 。

显式声明未提供类型的值的类型
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

我们经常使用含有不同数据类型的数据结构，比如上述的 ``Foo`` 类型，或者元胞数组（ ``Array{Any}`` 类型的数组）。如果你知道其中元素的类型，最好把它告诉编译器： ::

    function foo(a::Array{Any,1})
        x = a[1]::Int32
        b = x+1
        ...
    end

假如我们知道 ``a`` 的第一个元素是 ``Int32`` 类型的，那就添加上这样的类型声明吧。如果这个元素不是这个类型，在运行时就会报错，这有助于调试代码。

Declare types of keyword arguments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Keyword arguments can have declared types::

    function with_keyword(x; name::Int = 1)
        ...
    end

Functions are specialized on the types of keyword arguments, so these
declarations will not affect performance of code inside the function.
However, they will reduce the overhead of calls to the function that
include keyword arguments.

Functions with keyword arguments have near-zero overhead for call sites
that pass only positional arguments.

Passing dynamic lists of keyword arguments, as in ``f(x; keywords...)``,
can be slow and should be avoided in performance-sensitive code.

把函数拆开
----------

把一个函数拆为多个，有助于编译器调用最匹配的代码，甚至将它内联。

举个应该把“复合函数”写成多个小定义的例子： ::

    function norm(A)
        if isa(A, Vector)
            return sqrt(real(dot(A,A)))
        elseif isa(A, Matrix)
            return max(svd(A)[2])
        else
            error("norm: invalid argument")
        end
    end

如下重写会更精确、高效： ::

    norm(x::Vector) = sqrt(real(dot(x,x)))
    norm(A::Matrix) = max(svd(A)[2])

写“类型稳定”的函数
------------------

尽量确保函数返回同样类型的数值。考虑下面定义： ::

    pos(x) = x < 0 ? 0 : x

尽管看起来没问题，但是 ``0`` 是个整数（ ``Int`` 型）， ``x`` 可能是任意类型。因此，函数有返回两种类型的可能。这个是可以的，有时也很有用，但是最好如下重写： ::

    pos(x) = x < 0 ? zero(x) : x

Julia 中还有 ``one`` 函数，以及更通用的 ``oftype(x,y)`` 函数，它将 ``y`` 转换为与 ``x`` 同样的类型，并返回。这仨函数的第一个参数，可以是一个值，也可以是一个类型。

避免改变变量类型
----------------

在一个函数中重复地使用变量，会导致类似于“类型稳定性”的问题： ::

    function foo()
        x = 1
        for i = 1:10
            x = x/bar()
        end
        return x
    end

局部变量 ``x`` 开始为整数，循环一次后变成了浮点数（ ``/`` 运算符的结果）。这使得编译器很难优化循环体。可以修改为如下的任何一种：

-  用 ``x = 1.0`` 初始化 ``x``
-  声明 ``x`` 的类型： ``x::Float64 = 1``
-  使用显式转换: ``x = one(T)``

分离核心函数
------------

很多函数都先做些初始化设置，然后开始很多次循环迭代去做核心计算。尽可能把这些核心计算放在单独的函数中。例如，下面的函数返回一个随机类型的数组： ::

    function strange_twos(n)
        a = Array(randbool() ? Int64 : Float64, n)
        for i = 1:n
            a[i] = 2
        end
        return a
    end

应该写成： ::

    function fill_twos!(a)
        for i=1:length(a)
            a[i] = 2
        end
    end

    function strange_twos(n)
        a = Array(randbool() ? Int64 : Float64, n)
        fill_twos!(a)
        return a
    end

Julia 的编译器依靠参数类型来优化代码。第一个实现中，编译器在循环时不知道 ``a`` 的类型（因为类型是随机的）。第二个实现中，内层循环使用 ``fill_twos!`` 对不同的类型 ``a`` 重新编译，因此运行速度更快。

第二种实现的代码更好，也更便于代码复用。

标准库中经常使用这种方法。如 `abstractarray.jl <https://github.com/JuliaLang/julia/blob/master/base/abstractarray.jl>`_ 文件中的 ``hvcat_fill`` 和 ``fill!`` 函数。我们可以用这两个函数来替代这儿的 ``fill_twos!`` 函数。

形如 ``strange_twos`` 之类的函数经常用于处理未知类型的数据。比如，从文件载入的数据，可能包含整数、浮点数、字符串，或者其他类型。

Access arrays in memory order, along columns
--------------------------------------------

Multidimensional arrays in Julia are stored in column-major order. This
means that arrays are stacked one column at a time. This can be verified
using the ``vec`` function or the syntax ``[:]`` as shown below (notice
that the array is ordered ``[1 3 2 4]``, not ``[1 2 3 4]``):

.. doctest::

    julia> x = [1 2; 3 4]
    2x2 Array{Int64,2}:
     1  2
     3  4

    julia> x[:]
    4-element Array{Int64,1}:
     1
     3
     2
     4

This convention for ordering arrays is common in many languages like
Fortran, Matlab, and R (to name a few). The alternative to column-major
ordering is row-major ordering, which is the convention adopted by C and
Python (``numpy``) among other languages. Remembering the ordering of
arrays can have significant performance effects when looping over
arrays. A rule of thumb to keep in mind is that with column-major
arrays, the first index changes most rapidly. Essentially this means
that looping will be faster if the inner-most loop index is the first to
appear in a slice expression.

Consider the following contrived example. Imagine we wanted to write a
function that accepts a ``Vector`` and and returns a square ``Matrix``
with either the rows or the columns filled with copies of the input
vector. Assume that it is not important whether rows or columns are
filled with these copies (perhaps the rest of the code can be easily
adapted accordingly). We could conceivably do this in at least four ways
(in addition to the recommended call to the built-in function
``repmat``)::

    function copy_cols{T}(x::Vector{T})
        n = size(x, 1)
        out = Array(eltype(x), n, n)
        for i=1:n
            out[:, i] = x
        end
        out
    end

    function copy_rows{T}(x::Vector{T})
        n = size(x, 1)
        out = Array(eltype(x), n, n)
        for i=1:n
            out[i, :] = x
        end
        out
    end

    function copy_col_row{T}(x::Vector{T})
        n = size(x, 1)
        out = Array(T, n, n)
        for col=1:n, row=1:n
            out[row, col] = x[row]
        end
        out
    end

    function copy_row_col{T}(x::Vector{T})
        n = size(x, 1)
        out = Array(T, n, n)
        for row=1:n, col=1:n
            out[row, col] = x[col]
        end
        out
    end

Now we will time each of these functions using the same random ``10000``
by ``1`` input vector::

    julia> x = randn(10000);

    julia> fmt(f) = println(rpad(string(f)*": ", 14, ' '), @elapsed f(x))

    julia> map(fmt, {copy_cols, copy_rows, copy_col_row, copy_row_col});
    copy_cols:    0.331706323
    copy_rows:    1.799009911
    copy_col_row: 0.415630047
    copy_row_col: 1.721531501

Notice that ``copy_cols`` is much faster than ``copy_rows``. This is
expected because ``copy_cols`` respects the column-based memory layout
of the ``Matrix`` and fills it one column at a time. Additionally,
``copy_col_row`` is much faster than ``copy_row_col`` because it follows
our rule of thumb that the first element to appear in a slice expression
should be coupled with the inner-most loop.

Pre-allocating outputs
----------------------

If your function returns an Array or some other complex
type, it may have to allocate memory.  Unfortunately, oftentimes
allocation and its converse, garbage collection, are substantial
bottlenecks.

Sometimes you can circumvent the need to allocate memory on each
function call by pre-allocating the output.  As a
trivial example, compare
::

    function xinc(x)
        return [x, x+1, x+2]
    end

    function loopinc()
        y = 0
        for i = 1:10^7
            ret = xinc(i)
            y += ret[2]
        end
        y
    end

with
::

    function xinc!{T}(ret::AbstractVector{T}, x::T)
        ret[1] = x
        ret[2] = x+1
        ret[3] = x+2
        nothing
    end

    function loopinc_prealloc()
        ret = Array(Int, 3)
        y = 0
        for i = 1:10^7
            xinc!(ret, i)
            y += ret[2]
        end
        y
    end
    
Timing results::

    julia> @time loopinc()
    elapsed time: 1.955026528 seconds (1279975584 bytes allocated)
    50000015000000

    julia> @time loopinc_prealloc()
    elapsed time: 0.078639163 seconds (144 bytes allocated)
    50000015000000

Pre-allocation has other advantages, for example by allowing the
caller to control the "output" type from an algorithm.  In the example
above, we could have passed a ``SubArray`` rather than an ``Array``,
had we so desired.

Taken to its extreme, pre-allocation can make your code uglier, so
performance measurements and some judgment may be required.

Avoid string interpolation for I/O
----------------------------------

When writing data to a file (or other I/O device), forming extra
intermediate strings is a source of overhead. Instead of::

    println(file, "$a $b")

use::

    println(file, a, " ", b)

The first version of the code forms a string, then writes it
to the file, while the second version writes values directly
to the file. Also notice that in some cases string interpolation can
be harder to read. Consider::

    println(file, "$(f(a))$(f(b))")

versus::

    println(file, f(a), f(b))


处理有关舍弃的警告
------------------

被舍弃的函数，会查表并显示一次警告，而这会影响性能。建议按照警告的提示进行对应的修改。

小技巧
------

注意些有些小事项，能使内部循环更紧致。

-  避免不必要的数组。例如，不要使用 ``sum([x,y,z])`` ，而应使用 ``x+y+z``
-  对于较小的整数幂，使用 ``*`` 更好。如 ``x*x*x`` 比 ``x^3`` 好
-  针对复数 ``z`` ，使用 ``abs2(z)`` 代替 ``abs(z)^2`` 。一般情况下，对于复数参数，尽量用 ``abs2`` 代替 ``abs``
-  对于整数除法，使用 ``div(x,y)`` 和 ``fld(x,y)`` 代替 ``trunc(x/y)`` 和 ``floor(x/y)``


Performance Annotations
-----------------------

Sometimes you can enable better optimization by promising certain program
properties.

-  Use ``@inbounds`` to eliminate array bounds checking within expressions.
   Be certain before doing this. If the subscripts are ever out of bounds,
   you may suffer crashes or silent corruption.
-  Write ``@simd`` in front of ``for`` loops that are amenable to vectorization.
   **This feature is experimental** and could change or disappear in future 
   versions of Julia.  

Here is an example with both forms of markup::

    function inner( x, y )
        s = zero(eltype(x))
        for i=1:length(x)
            @inbounds s += x[i]*y[i]
        end
        s
    end

    function innersimd( x, y )
        s = zero(eltype(x))
        @simd for i=1:length(x)
            @inbounds s += x[i]*y[i]
        end
        s
    end
 
    function timeit( n, reps )
        x = rand(Float32,n)
        y = rand(Float32,n)
        s = zero(Float64)
        time = @elapsed for j in 1:reps
            s+=inner(x,y)
        end
        println("GFlop        = ",2.0*n*reps/time*1E-9)
        time = @elapsed for j in 1:reps
            s+=innersimd(x,y)
        end
        println("GFlop (SIMD) = ",2.0*n*reps/time*1E-9)
    end

    timeit(1000,1000)

On a computer with a 2.4GHz Intel Core i5 processor, this produces::

    GFlop        = 1.9467069505224963
    GFlop (SIMD) = 17.578554163920018

The range for a ``@simd for`` loop should be a one-dimensional range.
A variable used for accumulating, such as ``s`` in the example, is called
a *reduction variable*. By using``@simd``, you are asserting several
properties of the loop:

-  It is safe to execute iterations in arbitrary or overlapping order,
   with special consideration for reduction variables.
-  Floating-point operations on reduction variables can be reordered,
   possibly causing different results than without ``@simd``.
-  No iteration ever waits on another iteration to make forward progress.

Using ``@simd`` merely gives the compiler license to vectorize. Whether 
it actually does so depends on the compiler. To actually benefit from the 
current implementation, your loop should have the following additional 
properties:

-  The loop must be an innermost loop.
-  The loop body must be straight-line code. This is why ``@inbounds`` is currently needed for all array accesses.
-  Accesses must have a stride pattern and cannot be "gathers" (random-index reads) or "scatters" (random-index writes).
- The stride should be unit stride.
- In some simple cases, for example with 2-3 arrays accessed in a loop, the LLVM auto-vectorization may kick in automatically, leading to no further speedup with ``@simd``. 

工具
----

Julia includes some tools that may help you improve the performance of your code:

- :ref:`stdlib-profiling` allows you to measure the performance of
  your running code and identify lines that serve as bottlenecks.

- Unexpectedly-large memory allocations---as reported by ``@time``,
  ``@allocated``, or the profiler (through calls to the
  garbage-collection routines)---hint that there might be issues with
  your code.  If you don't see another reason for the allocations,
  suspect a type problem.

- Using ``code_typed()`` on your function can help identify sources of
  type problems.  Look particularly for variables that, contrary to
  your intentions, are inferred to be ``Union`` types.  Such problems
  can usually be fixed using the tips above.
  