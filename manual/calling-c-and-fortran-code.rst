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
2. 返回类型，可以为任意的位类型，包括 ``Int32`` ， ``Int64`` ， ``Float64`` ，或者指向任意参数类型 ``T`` 的指针 ``Ptr{T}`` ，或者仅仅是指向无类型指针 ``void*`` 的 ``Ptr`` 
3. 输入的类型的多元组，与上述的返回类型的要求类似
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

注意，类型多元组的参数必须写成 ``(Ptr{Uint8},)`` ，而不是 ``(Ptr{Uint8})`` 。
这是因为 ``(Ptr{Uint8})`` 等价于 ``Ptr{Uint8}`` ，它并不是一个包含 ``Ptr{Uint8}`` 的多元组： ::

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

如果函数调用者试图读取一个不存在的环境变量，封装将抛出异常： ::

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

``&`` 前缀说明传递的是指向标量参数的指针，而不是标量值本身。下例使用 BLAS 函数计算点积： ::

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

类型相关
~~~~~~~~

基础的 C/C++ 类型和 Julia 类型对照如下。

**与系统无关：**

-  ``bool`` ⟺ ``Bool``
-  ``char`` ⟺ ``Uint8``
-  ``signed char`` ⟺ ``Int8``
-  ``unsigned char`` ⟺ ``Uint8``
-  ``short`` ⟺ ``Int16``
-  ``unsigned short`` ⟺ ``Uint16``
-  ``int`` ⟺ ``Int32``
-  ``unsigned int`` ⟺ ``Uint32``
-  ``long long`` ⟺ ``Int64``
-  ``unsigned long long`` ⟺ ``Uint64``
-  ``float`` ⟺ ``Float32``
-  ``double`` ⟺ ``Float64``
-  ``void`` ⟺ ``Void``

*注意：* ``bool`` 类型仅在 C++ 中定义，它是 8 位的。
然而在 C 中，常常用 ``int`` 来表示布尔值。由于 ``int`` 是 32 位的，这可能会带来一些困扰。

返回 ``void`` 的 C 函数，在 Julia 中返回 ``nothing`` 。

**与系统有关：**

-  ``long`` ⟺ ``Int``
-  ``unsigned long`` ⟺ ``Uint``
-  ``size_t`` ⟺ ``Uint``
-  ``wchar_t`` ⟺ ``Char``

*注意：* 尽管 ``wchar_t`` 与系统有关，但是在 Julia 当前支持的系统上（UNIX），都是 32 位的。

对应于字符串参数（ ``char*`` ）的 Julia 类型为 ``Ptr{Uint8}`` ，而不是 ``ASCIIString`` 。参数中有 ``char**`` 类型的 C 函数，在 Julia 中调用时应使用 ``Ptr{Ptr{Uint8}}`` 类型。例如，C 函数： ::

    int main(int argc, char **argv);

在 Julia 中应该这样调用： ::

    argv = [ "a.out", "arg1", "arg2" ]
    ccall(:main, Int32, (Int32, Ptr{Ptr{Uint8}}), length(argv), argv)

非常量函数说明
--------------

``(name, library)`` 函数说明应为常量表达式。可以通过 ``eval`` ，将计算结果作为函数名： ::

    @eval ccall(($(string("a","b")),"lib"), ...

表达式用 ``string`` 构造名字，然后将名字代入 ``ccall`` 表达式进行计算。注意 ``eval`` 仅在顶层运行，因此在表达式之内，不能使用本地变量（除非本地变量的值使用 ``$`` 进行过内插）。 ``eval`` 通常用来作为顶层定义，例如，将包含多个相似函数的库封装在一起。

间接调用
--------

``ccall`` 的第一个参数可以是运行时求值的表达式。此时，表达式的值应为 ``Ptr`` 类型，指向要调用的本地函数的地址。这个特性用于 ``ccall`` 的第一参数包含对非常量（本地变量或函数参数）的引用时。

C++
---

extras 文件夹内的 :mod:`cpp.jl` 模块仅提供有限的 C++ 支持。
