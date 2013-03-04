:mod:`GZip` --- zlib 中 gzip 函数的封装
=======================================

.. module:: GZip
   :synopsis: zlib 中 gzip 函数的封装

.. note:: 位于 ``gzip.jl``

此模块提供（ `zlib <http://zlib.net/>`_ ）中与 gzip 相关的函数的封装。zlib 是免费、通用、不受法律限制、无损数据压缩库。这些函数可用来读写 gzip 文件。

它现在基于 zlib 1.2.7 。

----
注意
----

 * 此接口只适用于 gzip 文件，它不是流 zlib 压缩接口。它依赖于流接口，但 gzip 相关函数只是适用于 gzip 文件的高层函数

 * :class:`GZipStream` 是 :class:`IO` 的实现， :class:`IO` 可使用的地方，它都可以使用

 * 此实现模仿 :class:`IOStream` 实现，它是 :class:`IOStream` 的简易替代者，但有一些例外：

   * 没有 :func:`seek_end` 和 :func:`truncate` 
   * :func:`readuntil` 效率不高（但 :func:`readline` 没问题）

除了 :func:`gzopen` 和 :func:`gzfdio`/:func:`gzdopen` ，还支持下列 :class:`IO`/:class:`IOStream` 函数：

  :func:`close()`
  :func:`flush()`
  :func:`seek()`
  :func:`skip()`
  :func:`position()`
  :func:`eof()`
  :func:`read()`
  :func:`readuntil()`
  :func:`readline()`
  :func:`write()`

由于 ``zlib`` 的限制，现在没有 :func:`seek_end` 和 :func:`truncate` 。

----
函数
----

.. function:: gzopen(fname, [gzmode, [buf_size]])

   Opens a file with mode (default ``"r"``), setting internal buffer size
   to buf_size (default ``Z_DEFAULT_BUFSIZE=8192``), and returns a the
   file as a :class:`GZipStream`.

   ``gzmode`` must contain one of

   ==== =================================
    r    read
    w    write, create, truncate
    a    write, create, append
   ==== =================================

   In addition, gzmode may also contain

   ===== =================================
     x    create the file exclusively
          (fails if file exists)
    0-9   compression level
   ===== =================================

   and/or a compression strategy:

   ==== =================================
    f    filtered data
    h    Huffman-only compression
    R    run-length encoding
    F    fixed code compression
   ==== =================================

   Note that ``+`` is not allowed in gzmode.

   If an error occurs, ``gzopen`` throws a :class:`GZError`


.. function:: gzdopen(fd, [gzmode, [buf_size]])

   Create a :class:`GZipStream` object from an integer file descriptor.
   See :func:`gzopen` for ``gzmode`` and ``buf_size`` descriptions.

.. function:: gzdopen(s, [gzmode, [buf_size]])

   Create a :class:`GZipStream` object from :class:`IOStream` ``s``.

----
类型
----

.. type:: GZipStream(name, gz_file, [buf_size, [fd, [s]]])

   Subtype of :class:`IO` which wraps a gzip stream.  Returned by
   :func:`gzopen` and :func:`gzdopen`.

.. type:: GZError(err, err_str)

   gzip 错误值和字符串。可能的错误值：

   +---------------------+----------------------------------------+
   | ``Z_OK``            | No error                               |
   +---------------------+----------------------------------------+
   | ``Z_ERRNO``         | Filesystem error (consult ``errno()``) |
   +---------------------+----------------------------------------+
   | ``Z_STREAM_ERROR``  | Inconsistent stream state              |
   +---------------------+----------------------------------------+
   | ``Z_DATA_ERROR``    | Compressed data error                  |
   +---------------------+----------------------------------------+
   | ``Z_MEM_ERROR``     | Out of memory                          |
   +---------------------+----------------------------------------+
   | ``Z_BUF_ERROR``     | Input buffer full/output buffer empty  |
   +---------------------+----------------------------------------+
   | ``Z_VERSION_ERROR`` | zlib library version is incompatible   |
   |                     | with caller version                    |
   +---------------------+----------------------------------------+

