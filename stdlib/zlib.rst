:mod:`Zlib` --- Zlib 压缩/解压缩 封装
=====================================

.. module:: Zlib
   :synopsis: Zlib 压缩/解压缩 封装

.. note:: 位于 ``zlib.jl``

此模块提供了（ `zlib <http://zlib.net/>`_ ）的 压缩/解压缩 的封装，以及相关的实用函数。zlib 是免费、通用、不受法律限制、无损数据压缩库。这些函数可以压缩、解压缩字节缓冲（ ``Array{Uint8,1}`` ）。

注意，还没有对 zlib 流函数的封装。

它现在基于 zlib 1.2.7 。

实用函数
--------

.. function:: compress_bound(input_size)

   返回the maximum size of the compressed output buffer for a
   given uncompressed input size.


.. function:: compress(source, [level])

   Compresses source using the given compression level, and returns
   the compressed buffer (``Array{Uint8,1}``).  ``level`` is an
   integer between 0 and 9, or one of ``Z_NO_COMPRESSION``,
   ``Z_BEST_SPEED``, ``Z_BEST_COMPRESSION``, or
   ``Z_DEFAULT_COMPRESSION``.  It defaults to
   ``Z_DEFAULT_COMPRESSION``.

   If an error occurs, ``compress`` throws a :class:`ZError` with more
   information about the error.


.. function:: compress_to_buffer(source, dest, level=Z_DEFAULT_COMPRESSION)

   Compresses the source buffer into the destination buffer, and
   returns the number of bytes written into dest.

   If an error occurs, ``uncompress`` throws a :class:`ZError` with more
   information about the error.


.. function:: uncompress(source, [uncompressed_size])

   Allocates a buffer of size ``uncompressed_size``, uncompresses
   source to this buffer using the given compression level, and
   returns the compressed buffer.  If ``uncompressed_size`` is not
   given, the size of the output buffer is estimated as
   ``2*length(source)``.  If the uncompressed_size is larger than
   uncompressed_size, the allocated buffer is grown and the
   uncompression is retried.

   If an error occurs, ``uncompress`` throws a :class:`ZError` with more
   information about the error.


.. function:: uncompress_to_buffer(source, dest)

   Uncompresses the source buffer into the destination buffer.
   返回the number of bytes written into dest.  An error is thrown
   if the destination buffer does not have enough space.

   If an error occurs, ``uncompress_to_buffer`` throws a :class:`ZError`
   with more information about the error.

