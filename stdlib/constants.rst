
.. currentmodule:: Base

常量
----

.. data:: OS_NAME

   表示操作系统名的符号。可能的值有 ``:Linux``, ``:Darwin`` (OS X), 或 ``:Windows`` 。

.. data:: ARGS

   传递给 Julia 的命令行参数数组，它是个字符串数组。

.. data:: C_NULL

   C 空指针常量，有时用于调用外部代码。

.. data:: CPU_CORES

   系统中 CPU 内核的个数。

.. data:: WORD_SIZE

   当前机器的标准字长，单位为位。

.. data:: VERSION

   描述 Julia 版本的对象。

.. data:: LOAD_PATH

   路径的字符串数组， ``require`` 函数在这些路径下查找代码。
 
