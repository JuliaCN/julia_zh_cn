.. _man-calling-c-and-fortran-code:

************************
 调用 C 和 Fortran 代码
************************

Julia 调用 C 和 Fortran 的函数，既简单又高效。

被调用的代码应该是共享库的格式。大多数 C 和 Fortran 库都已经被编译为共享库。如果自己使用 GCC （或 Clang ）编译代码，需要添加 ``-shared`` 和 ``-fPIC`` 选项。Julia 调用这些库的开销与本地 C 语言相同。

调用共享库和函数时使用多元组形式： ``(:function, "library")`` 或 ``("function", "library")`` ，其中 ``function`` 是 C 的导出函数名， ``library`` 是共享库名。共享库依据名字来解析，路径由环境变量来确定，有时需要直接指明。

多元组内有时仅有函数名（仅 ``:function`` 或 ``"function"`` ）。此时，函数名由当前进程解析。这种形式可以用来调用 C 库函数， Julia 运行时函数，及链接到 Julia 的应用中的函数。

使用 ``ccall`` 来生成库函数调用。 ``ccall`` 的参数如下:

1. (:function, "library") 多元组对儿（必须为常量，详见下面）
2. 返回类型，可以为任意的位类型，包括 ``Int32`` ， ``Int64`` ， ``Float64`` ，或者指向任意类型参数 ``T`` 的指针 ``Ptr{T}`` ，或者仅仅是指向无类型指针 ``void*`` 的 ``Ptr``
3. 输入的类型的多元组，与上述的返回类型的要求类似。输入必须是多元组，而不是值为多元组的变量或表达式
4. 后面的参数，如果有的话，都是被调用函数的实参

下例调用标准 C 库中的 ``clock`` ： ::

    julia> t = ccall( (:clock, "libc"), Int32, ())
    2292761

    julia> t
    2292761

    julia> typeof(ans)
    Int32

``clock`` 函数没有参数，返回 ``Int32`` 类型。输入的类型如果只有一个，常写成一元多元组，在后面跟一逗号。例如要调用 ``getenv`` 函数取得指向一个环境变量的指针，应这样调用： ::

    julia> path = ccall( (:getenv, "libc"), Ptr{Uint8}, (Ptr{Uint8},), "SHELL")
    Ptr{Uint8} @0x00007fff5fbffc45

    julia> bytestring(path)
    "/bin/bash"

注意，类型多元组的参数必须写成 ``(Ptr{Uint8},)`` ，而不是 ``(Ptr{Uint8})`` 。这是因为 ``(Ptr{Uint8})`` 等价于 ``Ptr{Uint8}`` ，它并不是一个包含 ``Ptr{Uint8}`` 的一元多元组： ::

    julia> (Ptr{Uint8})
    Ptr{Uint8}

    julia> (Ptr{Uint8},)
    (Ptr{Uint8},)

实际中要提供可复用代码时，通常要使用 Julia 的函数来封装 ``ccall`` ，设置参数，然后检查 C 或 Fortran 函数中可能出现的任何错误，将其作为异常传递给 Julia 的函数调用者。下例中， ``getenv`` C 库函数被封装在 `env.jl <https://github.com/JuliaLang/julia/blob/master/base/env.jl>`_ 里的 Julia 函数中： ::

    function getenv(var::String)
      val = ccall( (:getenv, "libc"),
                  Ptr{Uint8}, (Ptr{Uint8},), bytestring(var))
      if val == C_NULL
        error("getenv: undefined variable: ", var)
      end
      bytestring(val)
    end

上例中，如果函数调用者试图读取一个不存在的环境变量，封装将抛出异常： ::

    julia> getenv("SHELL")
    "/bin/bash"

    julia> getenv("FOOBAR")
    getenv: undefined variable: FOOBAR

下例稍复杂些，显示本地机器的主机名： ::

    function gethostname()
      hostname = Array(Uint8, 128)
      ccall( (:gethostname, "libc"), Int32,
            (Ptr{Uint8}, Uint),
            hostname, length(hostname))
      return bytestring(convert(Ptr{Uint8}, hostname))
    end

此例先分配出一个字节数组，然后调用 C 库函数 ``gethostname`` 向数组中填充主机名，取得指向主机名缓冲区的指针，在默认其为空结尾 C 字符串的前提下，将其转换为 Julia 字符串。 C 库函数一般都用这种方式从函数调用者那儿，将申请的内存传递给被调用者，然后填充。在 Julia 中分配内存，通常都需要通过构建非初始化数组，然后将指向数据的指针传递给 C 函数。

调用 Fortran 函数时，所有的输入都必须通过引用来传递。

``&`` 前缀说明传递的是指向标量参数的指针，而不是标量值本身。下例使用 BLAS 函数计算点积：

::

    function compute_dot(DX::Vector, DY::Vector)
      assert(length(DX) == length(DY))
      n = length(DX)
      incx = incy = 1
      product = ccall( (:ddot_, "libLAPACK"),
                      Float64,
                      (Ptr{Int32}, Ptr{Float64}, Ptr{Int32}, Ptr{Float64}, Ptr{Int32}),
                      &n, DX, &incx, DY, &incy)
      return product
    end

前缀 ``&`` 的意思与 C 中的不同。对引用的变量的任何更改，都是对 Julia 不可见的。 ``&`` 并不是真正的地址运算符，可以在任何语法中使用它，例如 ``&0`` 和 ``&f(x)`` 。

注意在处理过程中，C 的头文件可以放在任何地方。目前还不能将 Julia 的结构和其他非基础类型传递给 C 库。通过传递指针来生成、使用非透明结构类型的 C 函数，可以向 Julia 返回 ``Ptr{Void}`` 类型的值，这个值以 ``Ptr{Void}`` 的形式被其它 C 函数调用。可以像任何 C 程序一样，通过调用库中对应的程序，对对象进行内存分配和释放。

把 C 类型映射到 Julia
---------------------

Julia 自动调用 ``convert`` 函数，将参数转换为指定类型。例如： ::

    ccall( (:foo, "libfoo"), Void, (Int32, Float64),
          x, y)

会按如下操作： ::

    ccall( (:foo, "libfoo"), Void, (Int32, Float64),
          convert(Int32, x), convert(Float64, y))

如果标量值与 ``&`` 一起被传递作为 ``Ptr{T}`` 类型的参数时，值首先会被转换为 ``T`` 类型。

数组转换
~~~~~~~~

把 ``Array`` 作为 ``Ptr`` 参数传递给 C 时，“转换”过程是仅提取首元素的地址。

因此，如果 ``Array`` 中的数据格式不对时，要使用显式转换，如 ``int32(a)`` 。

类型相关
~~~~~~~~

基础的 C/C++ 类型和 Julia 类型对照如下。每个 C 类型也有一个对应名称的 Julia 类型，不过冠以了前缀 C 。这有助于编写简便的代码（但 C 中的 int 与 Julia 中的 Int 不同）。

**与系统无关：**

+------------------------+-------------------+--------------------------------+
| ``bool`` (8 bits)      | ``Cbool``         | ``Bool``                       |
+------------------------+-------------------+--------------------------------+
| ``signed char``        |                   | ``Int8``                       |
+------------------------+-------------------+--------------------------------+
| ``unsigned char``      | ``Cuchar``        | ``Uint8``                      |
+------------------------+-------------------+--------------------------------+
| ``short``              | ``Cshort``        | ``Int16``                      |
+------------------------+-------------------+--------------------------------+
| ``unsigned short``     | ``Cushort``       | ``Uint16``                     |
+------------------------+-------------------+--------------------------------+
| ``int``                | ``Cint``          | ``Int32``                      |
+------------------------+-------------------+--------------------------------+
| ``unsigned int``       | ``Cuint``         | ``Uint32``                     |
+------------------------+-------------------+--------------------------------+
| ``long long``          | ``Clonglong``     | ``Int64``                      |
+------------------------+-------------------+--------------------------------+
| ``unsigned long long`` | ``Culonglong``    | ``Uint64``                     |
+------------------------+-------------------+--------------------------------+
| ``float``              | ``Cfloat``        | ``Float32``                    |
+------------------------+-------------------+--------------------------------+
| ``double``             | ``Cdouble``       | ``Float64``                    |
+------------------------+-------------------+--------------------------------+
| ``ptrdiff_t``          | ``Cptrdiff_t``    | ``Int``                        |
+------------------------+-------------------+--------------------------------+
| ``ssize_t``            | ``Cssize_t``      | ``Int``                        |
+------------------------+-------------------+--------------------------------+
| ``size_t``             | ``Csize_t``       | ``Uint``                       |
+------------------------+-------------------+--------------------------------+
| ``complex float``      | ``Ccomplex_float`` (future addition)               |
+------------------------+-------------------+--------------------------------+
| ``complex double``     | ``Ccomplex_double`` (future addition)              |
+------------------------+-------------------+--------------------------------+
| ``void``               |                   | ``Void``                       |
+------------------------+-------------------+--------------------------------+
| ``void*``              |                   | ``Ptr{Void}``                  |
+------------------------+-------------------+--------------------------------+
| ``char*`` (or ``char[]``, e.g. a string)   | ``Ptr{Uint8}``                 |
+------------------------+-------------------+--------------------------------+
| ``char**`` (or ``*char[]``)                | ``Ptr{Ptr{Uint8}}``            |
+------------------------+-------------------+--------------------------------+
| ``struct T*`` (where T represents an       | ``Ptr{T}`` (call using         |
| appropriately defined bits type)           | &variable_name in the          |
|                                            | parameter list)                |
+------------------------+-------------------+--------------------------------+
| ``struct T`` (where T represents  an       | ``T`` (call using              |
| appropriately defined bits type)           | &variable_name in the          |
|                                            | parameter list)                |
+------------------------+-------------------+--------------------------------+
| ``jl_value_t*`` (any Julia Type)           | ``Ptr{Any}``                   |
+------------------------+-------------------+--------------------------------+

*注意：* ``bool`` 类型仅在 C++ 中定义，它是 8 位的。然而在 C 中，常常用 ``int`` 来表示布尔值。由于 ``int`` 是 32 位的，这可能会带来一些困扰。

Julia 的 ``Char`` 类型是 32 位的，与所有平台的宽字符类型 (``wchar_t`` 或 ``wint_t``) 不同。

返回 ``void`` 的 C 函数，在 Julia 中返回 ``nothing`` 。

**与系统有关：**

======================  ==============  =======
``char``                ``Cchar``       ``Int8`` (x86, x86_64)

                                        ``Uint8`` (powerpc, arm)
``long``                ``Clong``       ``Int`` (UNIX)

                                        ``Int32`` (Windows)
``unsigned long``       ``Culong``      ``Uint`` (UNIX)

                                        ``Uint32`` (Windows)
``wchar_t``             ``Cwchar_t``    ``Int32`` (UNIX)

                                        ``Uint16`` (Windows)
======================  ==============  =======

对应于字符串参数（ ``char*`` ）的 Julia 类型为 ``Ptr{Uint8}`` ，而不是 ``ASCIIString`` 。参数中有 ``char**`` 类型的 C 函数，在 Julia 中调用时应使用 ``Ptr{Ptr{Uint8}}`` 类型。例如，C 函数： ::

    int main(int argc, char **argv);

在 Julia 中应该这样调用： ::

    argv = [ "a.out", "arg1", "arg2" ]
    ccall(:main, Int32, (Int32, Ptr{Ptr{Uint8}}), length(argv), argv)


通过指针读取数据
----------------

下列方法是“不安全”的，因为坏指针或类型声明可能会导致意外终止或损坏任意进程内存。

指定 ``Ptr{T}`` ，常使用 ``unsafe_ref(ptr, [index])`` 方法，将类型为 ``T`` 的内容从所引用的内存复制到 Julia 对象中。 ``index`` 参数是可选的（默认为 1 ），它是从 1 开始的索引值。此函数类似于 ``getindex()`` 和 ``setindex!()`` 的行为（如 ``[]`` 语法）。

返回值是一个被初始化的新对象，它包含被引用内存内容的浅拷贝。被引用的内存可安全释放。

如果 ``T`` 是 ``Any`` 类型，被引用的内存会被认为包含对 Julia 对象 ``jl_value_t*`` 的引用，结果为这个对象的引用，且此对象不会被拷贝。需要谨慎确保对象始终对垃圾回收机制可见（指针不重要，重要的是新的引用），来确保内存不会过早释放。注意，如果内存原本不是由 Julia 申请的，新对象将永远不会被 Julia 的垃圾回收机制释放。如果 ``Ptr`` 本身就是 ``jl_value_t*`` ，可使用 ``unsafe_pointer_to_objref(ptr)`` 将其转换回 Julia 对象引用。（可通过调用 ``pointer_from_objref(v)`` 将Julia 值 ``v`` 转换为 ``jl_value_t*`` 指针 ``Ptr{Void}``  。）

逆操作（向 Ptr{T} 写数据）可通过 ``unsafe_store!(ptr, value, [index])`` 来实现。目前，仅支持位类型和其它无指针（ ``isbits`` ）不可变类型。

现在任何抛出异常的操作，估摸着都是还没实现完呢。来写个帖子上报 bug 吧，就会有人来解决啦。

如果所关注的指针是（位类型或不可变）的目标数据数组， ``pointer_to_array(ptr,dims,[own])`` 函数就非常有用啦。如果想要 Julia “控制”底层缓冲区并在返回的 ``Array`` 被释放时调用 ``free(ptr)`` ，最后一个参数应该为真。如果省略 ``own`` 参数或它为假，则调用者需确保缓冲区一直存在，直至所有的读取都结束。

垃圾回收机制的安全
------------------

给 ccall 传递数据时，最好避免使用 ``pointer()`` 函数。应当定义一个转换方法，将变量直接传递给 ccall 。ccall 会自动安排，使得在调用返回前，它的所有参数都不会被垃圾回收机制处理。如果 C API 要存储一个由 Julia 分配好的内存的引用，当 ccall 返回后，需要自己设置，使对象对垃圾回收机制保持可见。推荐的方法为，在一个类型为 ``Array{Any,1}`` 的全局变量中保存这些值，直到 C 接口通知它已经处理完了。

只要构造了指向 Julia 数据的指针，就必须保证原始数据直至指针使用完之前一直存在。Julia 中的许多方法，如 ``unsafe_ref()`` 和 ``bytestring()`` ，都复制数据而不是控制缓冲区，因此可以安全释放（或修改）原始数据，不会影响到 Julia 。有一个例外需要注意，由于性能的原因， ``pointer_to_array()`` 会共享（或控制）底层缓冲区。

The garbage collector does not guarantee any order of finalization. That is, if ``a`` 
contained a reference to ``b`` and both ``a`` and ``b`` are due for garbage 
collection, there is no guarantee that ``b`` would be finalized after ``a``. If
proper finalization of ``a`` depends on ``b`` being valid, it must be handled in 
other ways.

非常量函数说明
--------------

``(name, library)`` 函数说明应为常量表达式。可以通过 ``eval`` ，将计算结果作为函数名： ::

    @eval ccall(($(string("a","b")),"lib"), ...

表达式用 ``string`` 构造名字，然后将名字代入 ``ccall`` 表达式进行计算。注意 ``eval`` 仅在顶层运行，因此在表达式之内，不能使用本地变量（除非本地变量的值使用 ``$`` 进行过内插）。 ``eval`` 通常用来作为顶层定义，例如，将包含多个相似函数的库封装在一起。

间接调用
--------

``ccall`` 的第一个参数可以是运行时求值的表达式。此时，表达式的值应为 ``Ptr`` 类型，指向要调用的原生函数的地址。这个特性用于 ``ccall``
的第一参数包含对非常量（本地变量或函数参数）的引用时。

调用方式
--------

``ccall`` 的第二个（可选）参数指定调用方式（在返回值之前）。如果没指定，将会使用操作系统的默认 C 调用方式。其它支持的调用方式为: ``stdcall`` , ``cdecl`` , ``fastcall`` 和 ``thiscall`` 。例如 (来自 base/libc.jl)： ::

    hn = Array(Uint8, 256)
    err=ccall(:gethostname, stdcall, Int32, (Ptr{Uint8}, Uint32), hn, length(hn))

更多信息请参考 `LLVM Language Reference`_.

.. _LLVM Language Reference: http://llvm.org/docs/LangRef.html#calling-conventions

Accessing Global Variables
--------------------------

Global variables exported by native libraries can be accessed by name using the
``cglobal`` function. The arguments to ``cglobal`` are a symbol specification
identical to that used by ``ccall``, and a type describing the value stored in
the variable::

    julia> cglobal((:errno,:libc), Int32)
    Ptr{Int32} @0x00007f418d0816b8

The result is a pointer giving the address of the value. The value can be
manipulated through this pointer using ``unsafe_load`` and ``unsafe_store``.

Passing Julia Callback Functions to C
-------------------------------------

It is possible to pass Julia functions to native functions that accept function
pointer arguments. A classic example is the standard C library ``qsort`` function,
declared as::

    void qsort(void *base, size_t nmemb, size_t size,
               int(*compare)(const void *a, const void *b));

The ``base`` argument is a pointer to an array of length ``nmemb``, with elements of
``size`` bytes each. ``compare`` is a callback function which takes pointers to two
elements ``a`` and ``b`` and returns an integer less/greater than zero if ``a`` should
appear before/after ``b`` (or zero if any order is permitted). Now, suppose that we
have a 1d array ``A`` of values in Julia that we want to sort using the ``qsort``
function (rather than Julia’s built-in sort function). Before we worry about calling
``qsort`` and passing arguments, we need to write a comparison function that works for
some arbitrary type T::

    function mycompare{T}(a_::Ptr{T}, b_::Ptr{T})
        a = unsafe_load(a_)
        b = unsafe_load(b_)
        return convert(Cint, a < b ? -1 : a > b ? +1 : 0)
    end

Notice that we have to be careful about the return type: ``qsort`` expects a function
returning a C ``int``, so we must be sure to return ``Cint`` via a call to ``convert``.

In order to pass this function to C, we obtain its address using the function
``cfunction``::

    const mycompare_c = cfunction(mycompare, Cint, (Ptr{Cdouble}, Ptr{Cdouble}))

``cfunction`` accepts three arguments: the Julia function (``mycompare``), the return
type (``Cint``), and a tuple of the argument types, in this case to sort an array of
``Cdouble`` (Float64) elements.

The final call to ``qsort`` looks like this::

    A = [1.3, -2.7, 4.4, 3.1]
    ccall(:qsort, Void, (Ptr{Cdouble}, Csize_t, Csize_t, Ptr{Void}),
          A, length(A), sizeof(eltype(A)), mycompare_c)

After this executes, ``A`` is changed to the sorted array ``[ -2.7, 1.3, 3.1, 4.4]``.
Note that Julia knows how to convert an array into a ``Ptr{Cdouble}``, how to compute
the size of a type in bytes (identical to C’s ``sizeof`` operator), and so on.
For fun, try inserting a ``println("mycompare($a,$b)")`` line into ``mycompare``, which
will allow you to see the comparisons that ``qsort`` is performing (and to verify that
it is really calling the Julia function that you passed to it).

More About Callbacks
--------------------

For more details on how to pass callbacks to C libraries, see this
`blog post <http://julialang.org/blog/2013/05/callback/>`_.

C++
---

`Cpp <http://github.com/timholy/Cpp.jl>`_ 和 `Clang <https://github.com/ihnorton/Clang.jl>`_ 扩展包提供了有限的 C++ 支持。

处理不同平台
------------

When dealing with platform libraries, it is often necessary to provide special cases
for various platforms. The variable ``OS_NAME`` can be used to write these special
cases. Additionally, there are several macros intended to make this easier:
``@windows``, ``@unix``, ``@linux``, and ``@osx``. Note that linux and osx are mutually 
exclusive subsets of unix. Their usage takes the form of a ternary conditional
operator, as demonstrated in the following examples.

Simple blocks::

    ccall( (@windows? :_fopen : :fopen), ...)

Complex blocks::

    @linux? (
             begin
                 some_complicated_thing(a)
             end
           : begin
                 some_different_thing(a)
             end
           )

Chaining (parentheses optional, but recommended for readability)::

    @windows? :a : (@osx? :b : :c)
