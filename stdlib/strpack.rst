strpack.jl --- Julia 类型 <--> C 结构
=====================================

.. .. module:: strpack.jl
   :synopsis: Julia 类型 <--> C 结构

此模块可将 Julia 的复合类型转换成合适的格式，将其作为结构输出传递给 ``ccall`` 。它也能将 C 结构的输出转换回 Julia 类型。

----
例子
----

如下创建一个 C 库：

.. code-block:: c

    struct teststruct {
      int      int1;
      float    float1;
    };
    
    void getvalues(struct teststruct* ts)
    {
      ts->int1 = 7;
      ts->float1 = 3.7;
    }

``getvalues`` 函数给这两个域赋值。将它编译为共享库：在 Linux 上的操作为 ``gcc -fPIC teststruct.c -shared -o libteststruct.so`` 。

用 Julia 也构造一个类似的结构： ::

    type TestStruct
        int1::Int32
        float1::Float32
    end
    TestStruct(i, f) = TestStruct(convert(Int32, i), convert(Float32, f))

注意 C 中的 ``int`` 对应于这儿的 ``Int32`` 。初始化一个此类型的对象： ::

    s = TestStruct(-1, 1.2)
    
现在载入 strpack “模块”， ``load("strpack")`` ，它将引入 ``iostring.jl`` 。我们需要把 ``s`` 打包成合适的格式，将其作为输入传递给 C 函数 ``getvalues`` ： ::

    iostr = IOString()
    pack(iostr, s)

来看下发生了什么： ::

    julia> iostr
    IOString([0xff, 0xff, 0xff, 0xff, 0x9a, 0x99, 0x99, 0x3f],9)

前 4 个字节对应于 ``Int32`` 所表示的 -1 ，最后 4 个对应于 ``Float32`` 所表示的 1.2 。换句话说，它是 ``s`` 打包好的内存缓冲（仍有数据对齐、endian 状态等细微的差别。strpack 可以理解这些东西，用户可以手工控制它们的行为。）

现在，载入库，调用 ``ccall`` ： ::

    const libtest = dlopen("libteststruct")
    ccall(dlsym(libtest, :getvalues), Void, (Ptr{Void},), iostr.data)

C 函数 ``getvalues`` 将输出存储在之前作为输入的缓冲区内。将缓冲解包回 Julia 类型： ::

    seek(iostr, 0)   # “倒回”缓冲区开头
    s2 = unpack(iostr, TestStruct)

这样就取回了结果。
    
.. function:: pack(io, composite, [strategy])

    Create a packed buffer representation of ``composite`` in stream ``io``, using data alignment coded by
    ``strategy``. This buffer is suitable to pass as a ``struct`` argument in a ``ccall``.
    
.. function:: unpack(io, T, [strategy])

    Extract an instance of the Julia composite type ``T`` from the packed representation in the stream ``io``.
    ``io`` must be positioned at the beginning (using ``seek``). This allows you to read C ``struct`` outputs
    from ``ccall``.

