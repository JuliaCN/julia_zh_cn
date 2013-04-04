.. _man-performance-tips:

**************
 代码性能优化
**************

以下几节将描述一些提高 Julia 代码运行速度的技巧。

避免全局变量
------------

全局变量的值、类型，都可能变化。这使得编译器很难优化使用全局变量的代码。应尽量使用局部变量，或者把变量当做参数传递给函数。

声明全局变量为常量可以显著提高性能： ::

    const DEFAULT_VAL = 0

使用非常量的全局变量时，最好在使用时指明其类型： ::

    global x
    y = f(x::Int + 1)

类型声明
--------

在 Julia 中，编译器能推断出所有的函数参数与局部变量的类型。然而在有些具体实例中，声明类型还是非常有用的。

给复合类型做类型声明
~~~~~~~~~~~~~~~~~~~~

假如有一个如下的自定义类型： ::

    type Foo
        field
    end

编译器推断不出 ``foo.field`` 的类型，因为当它指向另一个不同类型的值时，它的类型也会被修改。最好声明具体的类型，比如 ``field::Float64`` 或者 ``field::Array{Int64,1}`` 。

显式声明值类型
~~~~~~~~~~~~~~

我们经常使用含有不同数据类型的数据结构，比如上述的 ``Foo`` 类型，或者元胞数组（ ``Array{Any}`` 类型的数组）。如果你知道其中元素的类型，最好把它告诉编译器： ::

    function foo(a::Array{Any,1})
        x = a[1]::Int32
        b = x+1
        ...
    end

假如我们知道 ``a`` 的一个元素是 ``Int32`` 类型的，那就添加上这样的类型声明吧。如果这个元素不是这个类型，在运行时就会报错，这有助于调试代码。

Declare types of named arguments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Named arguments can have declared types::

    function with_named(x; name::Int = 1)
        ...
    end

Functions are specialized on the types of named arguments, so these
declarations will not affect performance of code inside the function.
However, they will reduce the overhead of calls to the function that
include named arguments.

Functions with named arguments have near-zero overhead for call sites
that pass only positional arguments.

Passing dynamic lists of named arguments, as in ``f(x; names...)``,
can be slow and should be avoided in performance-sensitive code.


把函数变为多个定义
------------------

把一个函数变为多个小定义，有助于编译器调用最匹配的代码，或者将它内联。

举个把“复合函数”写成多个小定义的例子： ::

    function norm(A)
        if isa(A, Vector)
            return sqrt(real(dot(x,x)))
        elseif isa(A, Matrix)
            return max(svd(A)[2])
        else
            error("norm: invalid argument")
        end
    end

如下重写会更精确、高效： ::

    norm(A::Vector) = sqrt(real(dot(x,x)))
    norm(A::Matrix) = max(svd(A)[2])

写“类型稳定”的函数
------------------

尽量确保函数返回同样类型的数值。考虑下面定义： ::

    pos(x) = x < 0 ? 0 : x

看起来没问题，但是 ``0`` 是个整数（ ``Int`` 型）， ``x`` 可能是任意类型。因此，函数有返回两种类型的可能。这个是可以的，有时也很有用，但是最好如下重写： ::

    pos(x) = x < 0 ? zero(x) : x

Julia 中还有 ``one`` 函数，以及更通用的 ``oftype(x,y)`` 函数，它将 ``y`` 转换为与 ``x`` 同样的类型，并返回。这仨函数的第一个参数，可以为任意值或类型。

避免改变变量类型
----------------

在一个函数中重复地使用变量，会导致“类型稳定性”的问题： ::

    function foo()
        x = 1
        for i = 1:10
            x = x/bar()
        end
        return x
    end

局部变量 ``x`` 开始为整数，循环一次后变成了浮点数（ ``/`` 运算符的结果）。这使得编译器很难优化循环体。可以如下修改：

-  用 ``x = 1.0`` 初始化 ``x``
-  声明 ``x`` 的类型： ``x::Float64 = 1``
-  使用显式转换: ``x = one(T)``

分离核心函数
------------

一些函数先做些初始化设置，然后开始很多次循环迭代去做核心计算。尽可能把这些核心计算放在单独的函数中。例如，下面的函数返回一个随机类型的数组： ::

    function strange_twos(n)
        a = Array(randbool() ? Int64 : Float64, n)
        for i = 1:n
            a[i] = 2
        end
        return a
    end

应该写成::

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

Julia 的编译器依靠参数类型来优化代码。第一个实现中，编译器在循环时不知道 ``a`` 的类型（因为类型是随机的）。第二个实现中，内层循环使用 ``fill_twos!`` 对类型 ``a`` 重新编译，因此运行速度更快。

第二种实现的代码更好，也更便于代码复用。

标准库中经常使用这种方法。如 `abstractarray.jl <https://github.com/JuliaLang/julia/blob/master/base/abstractarray.jl>`_ 文件中的 ``hvcat_fill`` 和 ``fill!`` 函数。我们可以用这两个函数来替代这儿的 ``fill_twos!`` 函数。

形如 ``strange_twos`` 之类的函数经常用于处理未知类型的数据。比如，从文件载入的数据，可能包含整数、浮点数、字符串，或者其他类型。

小配置
------

注意些有些小事项，能使内部循环更紧致。

-  尽量使用 ``size(A,n)`` 来替代 ``size(A)``
-  避免不必要的数组。例如，不要使用 ``sum([x,y,z])`` ，而应使用 ``x+y+z``
