cpp.jl --- Julia 调用 C++ 
=================================

.. .. module:: cpp.jl
   :synopsis: 为 Julia 调用 C++ 库函数提供部分支持。

为 Julia 调用 C++ 库函数提供部分支持。

.. function:: @cpp(ccall_expression)

   假设有一个 C++ 共享库 ``libdemo`` ，库中包含函数 ``timestwo``::

     int timestwo(int x) {
       return 2*x;
     }

     double timestwo(double x) {
       return 2*x;
     }

   可以在调用时，在函数前添加 ``@cpp`` 宏，例如： ::

     mylib = dlopen("libdemo")
     x = 3.5
     x2 = @cpp ccall(dlsym(mylib, :timestwo), Float64, (Float64,), x)
     y = 3
     y2 = @cpp ccall(dlsym(mylib, :timestwo), Int, (Int,), y)
     
   这个宏通过 C++ ABI name-mangling （使用参数的类型）来确定正确的库符号。

   与 ``ccall`` 一样，这样调用库没有开销，但现在还有些局限：

   * 不支持纯头文件的库
   * ``ccall`` 有些限制；例如，不支持 ``struct`` 。因而，不能使用 C++ 对象。
   * 目前不支持 C++ 命名空间
   * 目前不支持模板函数
   * 目前仅支持 g++ (GNU GCC)

   后三个比较难 `修正 <http://www.agner.org/optimize/calling_conventions.pdf>`_ 。
