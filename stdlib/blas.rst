:mod:`BLAS` --- 基础线性代数程序集
==================================

.. module:: BLAS
   :synopsis: 基础线性代数程序集的封装函数

此模块为线性代数提供一些 BLAS 函数的封装。覆写输入数组的 BLAS 函数名，都以感叹号 ``'!'`` 结尾。

通常每个函数有四个定义，分别适用于 ``Float64``, ``Float32``, ``Complex128`` 及 ``Complex64`` 数组。

实用函数
--------

.. function:: copy!(n, X, incx, Y, incy)

   Copy ``n`` elements of array ``X`` with stride ``incx`` to array
   ``Y`` with stride ``incy``.返回 ``Y`` 。

.. function:: dot(n, X, incx, Y, incy)

   Dot product of two vectors consisting of ``n`` elements of array
   ``X`` with stride ``incx`` and ``n`` elements of array ``Y`` with
   stride ``incy``.  There are no ``dot`` methods for ``Complex``
   arrays.

.. function:: nrm2(n, X, incx)

   2-norm of a vector consisting of ``n`` elements of array ``X`` with
   stride ``incx``.

.. function:: axpy!(n, a, X, incx, Y, incy)

   Overwrite ``Y`` with ``a*X + Y``.返回 ``Y`` 。

.. function:: syrk!(uplo, trans, alpha, A, beta, C)

   Rank-k update of the symmetric matrix ``C`` as ``alpha*A*A.' +
   beta*C`` or ``alpha*A.'*A + beta*C`` according to whether ``trans``
   is 'N' or 'T'.  When ``uplo`` is 'U' the upper triangle of ``C`` is
   updated ('L' for lower triangle).返回 ``C`` 。

.. function:: syrk(uplo, trans, alpha, A)

   返回either the upper triangle or the lower triangle, according
   to ``uplo`` ('U' or 'L'), of ``alpha*A*A.'`` or ``alpha*A.'*A``,
   according to ``trans`` ('N' or 'T').

.. function:: herk!(uplo, trans, alpha, A, beta, C)

   Methods for complex arrays only.  Rank-k update of the Hermitian
   matrix ``C`` as ``alpha*A*A' + beta*C`` or ``alpha*A'*A + beta*C``
   according to whether ``trans`` is 'N' or 'T'.  When ``uplo`` is 'U'
   the upper triangle of ``C`` is updated ('L' for lower triangle).
   返回 ``C`` 。

.. function:: herk(uplo, trans, alpha, A)

   Methods for complex arrays only.  返回either the upper triangle
   or the lower triangle, according to ``uplo`` ('U' or 'L'), of
   ``alpha*A*A'`` or ``alpha*A'*A``, according to ``trans`` ('N' or 'T').

.. function:: gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)

   Update vector ``y`` as ``alpha*A*x + beta*y`` or ``alpha*A'*x +
   beta*y`` according to ``trans`` ('N' or 'T').  The matrix ``A`` is
   a general band matrix of dimension ``m`` by ``size(A,2)`` with
   ``kl`` sub-diagonals and ``ku`` super-diagonals. 返回更新后的 ``y`` 。

.. function:: gbmv(trans, m, kl, ku, alpha, A, x, beta, y)

   返回 ``alpha*A*x`` or ``alpha*A'*x`` according to ``trans`` ('N'
   or 'T'). The matrix ``A`` is a general band matrix of dimension
   ``m`` by ``size(A,2)`` with ``kl`` sub-diagonals and
   ``ku`` super-diagonals.

.. function:: sbmv!(uplo, k, alpha, A, x, beta, y)

   Update vector ``y`` as ``alpha*A*x + beta*y`` where ``A`` is a 
   a symmetric band matrix of order ``size(A,2)`` with
   ``k`` super-diagonals stored in the argument ``A``.  The storage
   layout for ``A`` is described the reference BLAS module, level-2
   BLAS at `<http://www.netlib.org/lapack/explore-html/>`.

   返回更新后的 ``y`` 。

.. function:: sbmv(uplo, k, alpha, A, x)

   返回 ``alpha*A*x`` where ``A`` is a symmetric band matrix of
   order ``size(A,2)`` with ``k`` super-diagonals stored in the
   argument ``A``.

.. function:: gemm!(tA, tB, alpha, A, B, beta, C)

   Update ``C`` as ``alpha*A*B + beta*C`` or the other three variants
   according to ``tA`` (transpose ``A``) and ``tB``.返回更新后的 ``C`` 。

.. function:: gemm(tA, tB, alpha, A, B)

   返回 ``alpha*A*B`` or the other three variants
   according to ``tA`` (transpose ``A``) and ``tB``.

