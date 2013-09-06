.. _stdlib-linalg:

线性代数
--------

Julia 中的线性代数函数，大部分调用的是 `LAPACK <http://www.netlib.org/lapack/>`_ 中的函数。稀疏分解则调用  `SuiteSparse <http:://www.suitesparse.com/>`_ 中的函数。

.. function:: *(A, B)

   矩阵乘法。

.. function:: \\(A, B)

   使用 polyalgorithm 做矩阵除法。对输入矩阵 ``A`` 和 ``B`` ，当 ``A`` 为方阵时， 
   输出 ``X`` 满足 ``A*X == B`` 。由 ``A`` 的结构确定使用哪种求解器。 
   对上三角矩阵和下三角矩阵 ``A`` ，直接求解。 
   对 Hermitian 矩阵 ``A`` （它等价于实对称矩阵）时，使用 BunchKaufman 分解。 
   其他情况使用 LU 分解。对长方矩阵 ``A`` ，通过将 ``A`` 约简到双对角线形式， 
   然后使用最小范数最小二乘法来求解双对角线最小二乘问题。 
   对稀疏矩阵 ``A`` ，使用 UMFPACK 中的 LU 分解。

.. function:: dot(x, y)

   计算点积。

.. function:: cross(x, y)

   计算三维向量的向量积。

.. function:: norm(a)

   计算 ``Vector`` 或 ``Matrix`` 的模。

.. function:: lu(A) -> L, U, P

   对 ``A`` 做 LU 分解，满足 ``P*A = L*U`` 。

.. function:: lufact(A) -> LU

   对 ``A`` 做 LU 分解。若 ``A`` 为稠密矩阵，返回 ``LU`` 对象； 
   若 ``A`` 为稀疏矩阵，返回 ``UmfpackLU`` 对象。 
   分解结果 ``F`` 的独立分量是可以被索引的： ``F[:L]``, ``F[:U]``, 
   及 ``F[:P]`` （置换矩阵）或 ``F[:p]`` （置换向量）。 
   ``UmfpackLU`` 对象还有额外的 ``F[:q]`` 分量（ left 置换向量） 
   及缩放因子 ``F[:Rs]`` 向量。 
   ``LU`` 对象和 ``UmfpackLU`` 对象可使用下列函数： 
   ``size``, ``\`` 和 ``det`` 。 ``LUDense`` 对象还可以使用 ``inv`` 方法。 
   稀疏 LU 分解中， ``L*U`` 等价于 ``diagmm(Rs,A)[p,q]`` 。

.. function:: lufact!(A) -> LU

   ``lufact!`` 与 ``lufact`` 类似，但它覆写输入 A ，而非构造浅拷贝。 
   对稀疏矩阵 ``A`` ，它并不覆写 ``nzval`` 域，仅覆写索引值域， 
   ``colptr`` 和 ``rowval`` 在原地缩减， 
   使得从 1 开始的索引改为从 0 开始的索引。

.. function:: chol(A, [LU]) -> F

   计算对称正定矩阵 ``A`` 的 Cholesky 分解，返回 ``F`` 矩阵。 
   如果 ``LU`` 为 ``L`` （下三角）， ``A = L*L'`` 。 
   如果 ``LU`` 为 ``U`` （下三角）， ``A = R'*R`` 。

.. function:: cholfact(A, [LU]) -> Cholesky

   计算稠密对称正定矩阵 ``A`` 的 Cholesky 分解，返回 ``Cholesky`` 对象。 
   ``LU`` 若为 'L' 则使用下三角，若为 'U' 则使用上三角。默认使用 'U' 。 
   可从分解结果 ``F`` 中获取三角矩阵： ``F[:L]`` 和 ``F[:U]`` 。 
   ``Cholesky`` 对象可使用下列函数： ``size``, ``\``, ``inv``, ``det`` 。 
   如果矩阵不是正定，会抛出 ``LAPACK.PosDefException`` 错误。

.. function: cholfact!(A, [LU]) -> Cholesky

   ``cholfact!`` 与 ``cholfact`` 类似，但它覆写输入 A ，而非构造浅拷贝。

..  function:: cholpfact(A, [LU]) -> CholeskyPivoted

   计算对称正定矩阵 ``A`` 的主元 Cholesky 分解，返回 ``CholeskyPivoted`` 对象。 
   ``LU`` 若为 'L' 则使用下三角，若为 'U' 则使用上三角。默认使用 'U' 。 
   可从分解结果 ``F`` 中获取三角分量： ``F[:L]`` 和 ``F[:U]`` ， 
   置换矩阵和置换向量分布为 ``F[:P]`` 和 ``F[:p]`` 。 
   ``CholeskyPivoted`` 对象可使用下列函数： ``size``, ``\``, ``inv``, ``det`` 。 
   如果矩阵不是满秩，会抛出 ``LAPACK.RankDeficientException`` 错误。

.. function:: cholpfact!(A, [LU]) -> CholeskyPivoted

   ``cholpfact!`` 与 ``cholpfact`` 类似，但它覆写输入 A ，而非构造浅拷贝。

.. function:: qr(A, [thin]) -> Q, R

   对 ``A`` 做 QR 分解，满足 ``A = Q*R`` 。也可参见 ``qrfact`` 。
   默认做 ``thin`` 分解。

.. function:: qrfact(A)

   对 ``A`` 做 QR 分解，返回 ``QR`` 对象。 
   ``factors(qrfact(A))`` 返回 ``Q`` 和 ``R`` 。
   ``QR`` 对象可使用下列函数： ``size``, ``factors``, ``qmulQR``, ``qTmulQR``, ``\`` 。
   提取的 ``Q`` 是 ``QRPackedQ`` 对象，且为了支持 ``Q`` 与 ``Q'`` 的高效乘法， 
   重载了 ``*`` 运算符。

.. function:: qrfact!(A)

   ``qrfact!`` 与 ``qrfact`` 类似，但它覆写输入 A ，而非构造浅拷贝。

.. function:: qrp(A, [thin]) -> Q, R, P

   对 ``A`` 做主元 QR 分解，满足 ``A*P = Q*R`` 。另见 ``qrpfact`` 。
   默认做 ``thin`` 分解。

.. function:: qrpfact(A) -> QRPivoted

   对 ``A`` 做主元 QR 分解，返回 ``QRPivoted`` 对象。 
   可从分解结果 ``F`` 中获取分量：正交矩阵 ``Q`` 为 ``F[:Q]`` ， 
   三角矩阵 ``R`` 为 ``F[:R]`` ，置换矩阵和置换向量分布为 ``F[:P]`` 和 ``F[:p]`` 。 
   ``QRPivoted`` 对象可使用下列函数： ``size``, ``\`` 。 
   提取的 ``Q`` 是 ``QRPivotedQ`` 对象，且为了支持 ``Q`` 与 ``Q'`` 的高效乘法， 
   重载了 ``*`` 运算符。可以使用 ``full`` 函数将 ``QRPivotedQ`` 矩阵转换为普通矩阵。

.. function:: qrpfact!(A) -> QRPivoted

   ``qrpfact!`` 与 ``qrpfact`` 类似，但它覆写 A 以节约空间，而非构造浅拷贝。

.. function:: sqrtm(A)

   计算 ``A`` 的矩阵平方根。如果 ``B = sqrtm(A)`` ，满足在误差范围内 ``B*B == A`` 。

.. function:: eig(A) -> D, V

   计算 ``A`` 的特征值和特征向量。

.. function:: eigvals(A)

   返回  ``A`` 的特征值。

.. function:: eigmax(A)

   返回 ``A`` 的最大的特征值。

.. function:: eigmin(A)

   返回 ``A`` 的最小的特征值。

.. function:: eigvecs(A, [eigvals])

   返回  ``A`` 的特征向量。

   对于对称三对角线矩阵 SymTridiagonal, 
   如果指明了可选项 ``eigvals`` 特征值，返回对应的特征向量。

.. function:: eigfact(A)

   对 ``A`` 做特征分解，返回 ``Eigen`` 对象。可从分解结果 ``F`` 中获取分量： 
   特征值为 ``F[:values]`` ，特征向量为 ``F[:vectors]`` 。 
   ``Eigen`` 对象可使用下列函数： ``inv``, ``det`` 。

.. function:: eigfact!(A)

   ``eigfact!`` 与 ``eigfact`` 类似，但它覆写输入 A ，而非构造浅拷贝。
   
.. function:: hessfact(A)

   对 ``A`` 做 Hessenberg 分解，返回 ``Hessenberg`` 对象。 
   如果分解后的结果为 ``F`` ，酉矩阵为 ``F[:Q]`` ， Hessenberg 矩阵为 ``F[:H]`` 。 
   提取的 ``Q`` 是 ``HessenbergQ`` 对象， 
   可以使用 ``full`` 函数将其转换为普通矩阵。
   
.. function:: hessfact!(A)

   ``hessfact!`` 与 ``hessfact`` 类似，但它覆写输入 A ，而非构造浅拷贝。

.. function:: schurfact(A) -> Schur

   对 ``A`` 做 Schur 分解。
   分解结果 ``Schur`` 对象 ``F`` 的（近似）三角 Schur 因子为 ``F[:Schur]`` 或 ``F[:T]`` ，
   正交 Schur 向量为 ``F[:vectors]`` 或 ``F[:Z]`` 。
   满足 ``A=F[:vectors]*F[:Schur]*F[:vectors]'`` 。
   ``A`` 的特征值为 ``F[:values]`` 。

.. function:: schur(A) -> Schur[:T], Schur[:Z], Schur[:values]

   详见 :func:`schurfact` 。

.. function:: schurfact(A, B) -> GeneralizedSchur

   计算 ``A`` 和 ``B`` 做广义 Schur （或 QZ ）分解。
   分解结果 ``Schur`` 对象 ``F`` 的（近似）三角 Schur 因子为 ``F[:S]`` 和 ``F[:T]`` ，
   左正交 Schur 向量为 ``F[:left]`` 或 ``F[:Q]`` ，
   左正交 Schur 向量为 ``F[:right]`` 或 ``F[:Z]`` 。
   满足 ``A=F[:left]*F[:S]*F[:right]'`` 及 ``B=F[:left]*F[:T]*F[:right]'`` 。
   ``A`` 和 ``B`` 做广义特征值为 ``F[:alpha]./F[:beta]`` 。

.. function:: schur(A,B) -> GeneralizedSchur[:S], GeneralizedSchur[:T], GeneralizedSchur[:Q], GeneralizedSchur[:Z]

   详见 :func:`schurfact` 。

.. function:: svdfact(A, [thin]) -> SVD

   对 ``A`` 做奇异值分解（SVD），返回 ``SVD`` 对象。 
   分解结果 ``F`` 的 ``U``, ``S``, ``V`` 和 ``Vt`` 可分别通过 ``F[:U]``, 
   ``F[:S]``, ``F[:V]`` 和 ``F[:Vt]`` 来获得，它们满足 ``A = U*diagm(S)*Vt`` 。 
   如果 ``thin`` 为 ``true`` ，则做节约模式分解。 
   此算法先计算 ``Vt`` ，即 ``V`` 的转置，后者是由前者转置得到的。
   默认做 ``thin`` 分解。

.. function:: svdfact!(A, [thin]) -> SVD

   ``svdfact!`` 与 ``svdfact`` 类似，但它覆写 A 以节约空间，而非构造浅拷贝。 
   如果 ``thin`` 为 ``true`` ，则做 ``thin`` 分解。默认做 ``thin`` 分解。

.. function:: svd(A, [thin]) -> U, S, V

   对 ``A`` 做奇异值分解，返回 ``U`` ，向量 ``S`` ，及 ``V`` ， 
   满足 ``A == U*diagm(S)*V'`` 。如果 ``thin`` 为 ``true`` ，则做节约模式分解。

.. function:: svdvals(A)

   返回 ``A`` 的奇异值。

.. function:: svdvals!(A)

   返回 ``A`` 的奇异值，将结果覆写到输入上以节约空间。

.. function:: svdfact(A, B) -> GSVDDense

   计算 ``A`` 和 ``B`` 的广义 SVD ，返回 ``GeneralizedSVD`` 分解对象。  
   满足 ``A = U*D1*R0*Q'`` 及 ``B = V*D2*R0*Q'`` 。
   
.. function:: svd(A, B) -> U, V, Q, D1, D2, R0

   计算 ``A`` 和 ``B`` 的广义 SVD ，返回 ``U``, ``V``, ``Q``, ``D1``, 
   ``D2``, 和 ``R0`` ，满足 ``A = U*D1*R0*Q'`` 及 ``B = V*D2*R0*Q'`` 。
 
.. function:: svdvals(A, B)

   仅返回 ``A`` 和 ``B`` 广义 SVD 中的奇异值。

.. function:: triu(M)

   矩阵上三角。

.. function:: tril(M)

   矩阵下三角。

.. function:: diag(M, [k])

   矩阵的第 ``k`` 条对角线，结果为向量。 ``k`` 从 0 开始。

.. function:: diagm(v, [k])

   构造 ``v`` 为第 ``k`` 条对角线的对角矩阵。 ``k`` 从 0 开始。

.. function:: diagmm(matrix, vector)

   矩阵与向量相乘。此函数也可以做向量与矩阵相乘。

.. function:: Tridiagonal(dl, d, du)

   由下对角线、主对角线、上对角线来构造三对角矩阵

.. function:: Bidiagonal(dv, ev, isupper)

   使用指定的对角线 (dv) 和非对角线 (ev) 向量，
   构造上(isupper=true)或下(isupper=false) 双对角线矩阵。

.. function:: Woodbury(A, U, C, V)

   构造 Woodbury matrix identity 格式的矩阵。

.. function:: rank(M)

   计算矩阵的秩。

.. function:: norm(A, [p])

   计算向量或矩阵的 ``p`` 范数。 ``p`` 默认为 2 。 
   如果 ``A`` 是向量， ``norm(A, p)`` 计算 ``p`` 范数。 
   ``norm(A, Inf)`` 返回 ``abs(A)`` 中的最大值， ``norm(A, -Inf)`` 返回最小值。 
   如果 ``A`` 是矩阵， ``p`` 的有效值为 ``1``, ``2``, 和 ``Inf`` 。 
   要计算 Frobenius 范数，应使用 ``normfro`` 。

.. function:: normfro(A)

   计算矩阵 ``A`` 的 Frobenius 范数。

.. function:: cond(M, [p])

   使用 p 范数计算矩阵条件数。 ``p`` 如果省略，默认为 2 。 
   ``p`` 的有效值为 ``1``, ``2``, 和 ``Inf``.

.. function:: trace(M)

   矩阵的迹。

.. function:: det(M)

   矩阵的行列式。

.. function:: inv(M)

   矩阵的逆。

.. function:: pinv(M)

   矩阵的 Moore-Penrose （广义）逆

.. function:: null(M)

   矩阵 M 的零空间的基。

.. function:: repmat(A, n, m)

   重复矩阵 ``A`` 来构造新数组，在第一维度上重复 ``n`` 次，第二维度上重复 ``m`` 次。

.. function:: kron(A, B)

   两个向量或两个矩阵的 Kronecker 张量积。

.. function:: linreg(x, y)

   最小二乘法线性回归来计算参数 ``[a, b]`` ，使 ``y`` 逼近 ``a+b*x`` 。

.. function:: linreg(x, y, w)

   带权最小二乘法线性回归。

.. function:: expm(A)

   矩阵指数。

.. function:: issym(A)

   判断是否为对称矩阵。

.. function:: isposdef(A)

   判断是否为正定矩阵。

.. function:: istril(A)

   判断是否为下三角矩阵。

.. function:: istriu(A)

   判断是否为上三角矩阵。

.. function:: ishermitian(A)

   判断是否为 Hamilton 矩阵。

.. function:: transpose(A)

   转置运算符（ ``.'`` ）。

.. function:: ctranspose(A)

   共轭转置运算符（ ``'`` ）。


BLAS 函数
---------

此模块为线性代数提供一些 BLAS 函数的封装。覆写输入数组的 BLAS 函数名，都以感叹号 ``'!'`` 结尾。

通常每个函数有四个定义，分别适用于 ``Float64``, ``Float32``, ``Complex128`` 及 ``Complex64`` 数组。

.. function:: copy!(n, X, incx, Y, incy)

   将内存邻接距离为 ``incx`` 的数组 ``X`` 的 ``n`` 个元素复制到 
   内存邻接距离为 ``incy`` 的数组 ``Y`` 中。返回 ``Y`` 。

.. function:: dot(n, X, incx, Y, incy)

   内存邻接距离为 ``incx`` 的数组 ``X`` 的 ``n`` 个元素组成的向量，与 
   内存邻接距离为 ``incy`` 的数组 ``Y`` 的 ``n`` 个元素组成的向量，做点积。
   ``Complex`` 数组没有 ``dot`` 方法。

.. function:: nrm2(n, X, incx)

   内存邻接距离为 ``incx`` 的数组 ``X`` 的 ``n`` 个元素组成的向量的 2 范数。

.. function:: axpy!(n, a, X, incx, Y, incy)

   将 ``a*X + Y`` 赋值给 ``Y`` 并返回。

.. function:: syrk!(uplo, trans, alpha, A, beta, C)

   由参数 ``trans`` （ 'N' 或 'T' ）确定，计算 ``alpha*A*A.' + beta*C`` 
   或 ``alpha*A.'*A + beta*C`` ，由参数 ``uplo`` （ 'U' 或 'L' ）确定， 
   用计算的结果更新对称矩阵 ``C`` 的上三角矩阵或下三角矩阵。返回 ``C`` 。

.. function:: syrk(uplo, trans, alpha, A)

   由参数 ``trans`` （ 'N' 或 'T' ）确定，计算 ``alpha*A*A.'`` 
   或 ``alpha*A.'*A`` ，由参数 ``uplo`` （ 'U' 或 'L' ）确定， 
   返回计算结果的上三角矩阵或下三角矩阵。

.. function:: herk!(uplo, trans, alpha, A, beta, C)

   此方法只适用于复数数组。由参数 ``trans`` （ 'N' 或 'T' ）确定， 
   计算 ``alpha*A*A' + beta*C`` 或 ``alpha*A'*A + beta*C`` ， 
   由参数 ``uplo`` （ 'U' 或 'L' ）确定， 
   用计算的结果更新对称矩阵 ``C`` 的上三角矩阵或下三角矩阵。返回 ``C`` 。
   
.. function:: herk(uplo, trans, alpha, A)

   此方法只适用于复数数组。由参数 ``trans`` （ 'N' 或 'T' ）确定， 
   计算 ``alpha*A*A'`` 或 ``alpha*A'*A`` ， 
   由参数 ``uplo`` （ 'U' 或 'L' ）确定，返回计算结果的上三角矩阵或下三角矩阵。

.. function:: gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)

   由参数 ``trans`` （ 'N' 或 'T' ）确定，计算 ``alpha*A*x`` 或 
   ``alpha*A'*x`` ，将结果赋值给 ``y`` 并返回。矩阵 ``A`` 为普通带矩阵， 
   其维度 ``m`` 为 ``size(A,2)`` ， 子对角线为 ``kl`` ，超对角线为 ``ku`` 。

.. function:: gbmv(trans, m, kl, ku, alpha, A, x, beta, y)

   由参数 ``trans`` （ 'N' 或 'T' ）确定，计算 ``alpha*A*x`` 或 
   ``alpha*A'*x`` 。矩阵 ``A`` 为普通带矩阵， 
   其维度 ``m`` 为 ``size(A,2)`` ， 子对角线为 ``kl`` ， 
   超对角线为 ``ku`` 。

.. function:: sbmv!(uplo, k, alpha, A, x, beta, y)

   将 ``alpha*A*x + beta*y`` 赋值给 ``y`` 并返回。 
   其中 ``A`` 是对称带矩阵，维度为 ``size(A,2)`` ，超对角线为 ``k`` 。 
   关于 A 是如何存储的，详见 `<http://www.netlib.org/lapack/explore-html/>`_ 的 level-2 BLAS 。

.. function:: sbmv(uplo, k, alpha, A, x)

   返回 ``alpha*A*x`` 。 
   其中 ``A`` 是对称带矩阵，维度为 ``size(A,2)`` ，超对角线为 ``k`` 。

.. function:: gemm!(tA, tB, alpha, A, B, beta, C)

   由 ``tA`` （ ``A`` 做转置）和 ``tB`` 确定， 
   计算 ``alpha*A*B + beta*C`` 或其它对应的三个表达式， 
   将结果赋值给 ``C`` 并返回。

.. function:: gemm(tA, tB, alpha, A, B)

   由 ``tA`` （ ``A`` 做转置）和 ``tB`` 确定， 
   计算 ``alpha*A*B + beta*C`` 或其它对应的三个表达式。

