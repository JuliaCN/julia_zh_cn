.. _stdlib-sparse:

稀疏矩阵
--------

稀疏矩阵支持大部分稠密矩阵的对应操作。下列函数仅适用于稀疏矩阵。

.. function:: sparse(I,J,V,[m,n,combine])

   构造 ``m x n`` 的稀疏矩阵 ``S`` ，满足 ``S[I[k], J[k]] = V[k]`` 。 
   使用 ``combine`` 函数来处理坐标重复的元素。 
   如果未指明 ``m`` 和 ``n`` ，则默认为 ``max(I)`` 和 ``max(J)`` 。 
   如果省略 ``combine`` 函数，默认对坐标重复的元素求和。

.. function:: sparsevec(I, V, [m, combine])

   构造 ``m x 1`` 的稀疏矩阵 ``S`` ，满足 ``S[I[k]] = V[k]`` 。 
   使用 ``combine`` 函数来处理坐标重复的元素，如果它被省略，则默认为 ``+`` 。 
   在 Julia 中，稀疏向量是只有一列的稀疏矩阵。 
   由于 Julia 使用列压缩（CSC）存储格式，只有一列的稀疏列矩阵是稀疏的， 
   但只有一行的稀疏行矩阵是稠密的。

.. function:: sparsevec(D::Dict, [m])

   构造 ``m x 1`` 大小的稀疏矩阵，其行值为字典中的键，非零值为字典中的值。

.. function:: issparse(S)

   如果 ``S`` 为稀疏矩阵，返回 ``true`` ；否则为 ``false`` 。

.. function:: sparse(A)

   将稠密矩阵 ``A`` 转换为稀疏矩阵。

.. function:: sparsevec(A)

   将稠密矩阵 ``A`` 转换为 ``m x 1`` 的稀疏矩阵。 
   在 Julia 中，稀疏向量是只有一列的稀疏矩阵。

.. function:: dense(S)

   将稀疏矩阵 ``S`` 转换为稠密矩阵。

.. function:: full(S)

   将稀疏矩阵 ``S`` 转换为稠密矩阵。

.. function:: spzeros(m,n)

   构造 ``m x n`` 的空稀疏矩阵。

.. function:: speye(type,m[,n])

   构造指定类型、大小为 ``m x m`` 的稀疏单位矩阵。 
   如果提供了 ``n`` 则构建大小为 ``m x n`` 的稀疏单位矩阵。

.. function:: spones(S)

   构造与 ``S`` 同样结构的稀疏矩阵，但非零元素值为 ``1.0`` 。

.. function:: sprand(m,n,density[,rng])

   构造指定密度的随机稀疏矩阵。非零样本满足由 ``rng`` 指定的分布。默认为均匀分布。

.. function:: sprandn(m,n,density)

   构造指定密度的随机稀疏矩阵，非零样本满足正态分布。

.. function:: sprandbool(m,n,density)

   构造指定密度的随机稀疏布尔值矩阵。

