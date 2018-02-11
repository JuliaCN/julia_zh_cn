# 线性代数

<!-- # Linear Algebra -->

除了对多维数组的支持以外，Julia 还自带许多常用线性代数的运算。并且支持如
[`trace`](@ref)（迹），[`det`](@ref)（行列式）和 [`inv`](@ref)（逆）一类的基本运算。

<!-- In addition to (and as part of) its support for multi-dimensional arrays, Julia provides native implementations
of many common and useful linear algebra operations. Basic operations, such as [`trace`](@ref), [`det`](@ref),
and [`inv`](@ref) are all supported: -->

```jldoctest
julia> A = [1 2 3; 4 1 6; 7 8 1]
3×3 Array{Int64,2}:
 1  2  3
 4  1  6
 7  8  1

julia> trace(A)
3

julia> det(A)
104.0

julia> inv(A)
3×3 Array{Float64,2}:
 -0.451923   0.211538    0.0865385
  0.365385  -0.192308    0.0576923
  0.240385   0.0576923  -0.0673077
```

<!-- ```jldoctest
julia> A = [1 2 3; 4 1 6; 7 8 1]
3×3 Array{Int64,2}:
 1  2  3
 4  1  6
 7  8  1

julia> trace(A)
3

julia> det(A)
104.0

julia> inv(A)
3×3 Array{Float64,2}:
 -0.451923   0.211538    0.0865385
  0.365385  -0.192308    0.0576923
  0.240385   0.0576923  -0.0673077
``` -->

同样也支持其他实用的运算，例如计算特征值或是特征向量：

<!-- As well as other useful operations, such as finding eigenvalues or eigenvectors: -->

```jldoctest
julia> A = [-4. -17.; 2. 2.]
2×2 Array{Float64,2}:
 -4.0  -17.0
  2.0    2.0

julia> eigvals(A)
2-element Array{Complex{Float64},1}:
 -1.0 + 5.0im
 -1.0 - 5.0im

julia> eigvecs(A)
2×2 Array{Complex{Float64},2}:
  0.945905+0.0im        0.945905-0.0im
 -0.166924-0.278207im  -0.166924+0.278207im
```

<!-- ```jldoctest
julia> A = [-4. -17.; 2. 2.]
2×2 Array{Float64,2}:
 -4.0  -17.0
  2.0    2.0

julia> eigvals(A)
2-element Array{Complex{Float64},1}:
 -1.0 + 5.0im
 -1.0 - 5.0im

julia> eigvecs(A)
2×2 Array{Complex{Float64},2}:
  0.945905+0.0im        0.945905-0.0im
 -0.166924-0.278207im  -0.166924+0.278207im
``` -->

除此之外，Julia 还提供了许多常用于加速计算的 [矩阵分解](@ref man-linalg-factorizations)，例如求线性解或是矩阵幂，
通过运算前的预分解将矩阵转变为更易于处理的形式（考虑执行效率或内存）来解决问题。
戳一戳 [`factorize`](@ref)来获得更详细的信息。下面是一个例子：

<!-- In addition, Julia provides many [factorizations](@ref man-linalg-factorizations) which can be used to
speed up problems such as linear solve or matrix exponentiation by pre-factorizing a matrix into a form
more amenable (for performance or memory reasons) to the problem. See the documentation on [`factorize`](@ref)
for more information. As an example: -->

```jldoctest
julia> A = [1.5 2 -4; 3 -1 -6; -10 2.3 4]
3×3 Array{Float64,2}:
   1.5   2.0  -4.0
   3.0  -1.0  -6.0
 -10.0   2.3   4.0

julia> factorize(A)
LinearAlgebra.LU{Float64,Array{Float64,2}} with factors L and U:
[1.0 0.0 0.0; -0.15 1.0 0.0; -0.3 -0.132196 1.0]
[-10.0 2.3 4.0; 0.0 2.345 -3.4; 0.0 0.0 -5.24947]
```

<!-- ```jldoctest
julia> A = [1.5 2 -4; 3 -1 -6; -10 2.3 4]
3×3 Array{Float64,2}:
   1.5   2.0  -4.0
   3.0  -1.0  -6.0
 -10.0   2.3   4.0

julia> factorize(A)
LinearAlgebra.LU{Float64,Array{Float64,2}} with factors L and U:
[1.0 0.0 0.0; -0.15 1.0 0.0; -0.3 -0.132196 1.0]
[-10.0 2.3 4.0; 0.0 2.345 -3.4; 0.0 0.0 -5.24947]
``` -->

当 `A` 不是厄米矩阵、对称矩阵、三角矩阵、三对角矩阵或双对角矩阵时，LU 分解也许是最好的方法。比较如下：

<!-- Since `A` is not Hermitian, symmetric, triangular, tridiagonal, or bidiagonal, an LU factorization may be the
best we can do. Compare with: -->

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> factorize(B)
LinearAlgebra.BunchKaufman{Float64,Array{Float64,2}}
D factor:
3×3 Tridiagonal{Float64,Array{Float64,1}}:
 -1.64286   0.0   ⋅
  0.0      -2.8  0.0
   ⋅        0.0  5.0
U factor:
3×3 LinearAlgebra.UnitUpperTriangular{Float64,Array{Float64,2}}:
 1.0  0.142857  -0.8
 0.0  1.0       -0.6
 0.0  0.0        1.0
permutation:
3-element Array{Int64,1}:
 1
 2
 3
```

<!-- ```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> factorize(B)
LinearAlgebra.BunchKaufman{Float64,Array{Float64,2}}
D factor:
3×3 Tridiagonal{Float64,Array{Float64,1}}:
 -1.64286   0.0   ⋅
  0.0      -2.8  0.0
   ⋅        0.0  5.0
U factor:
3×3 LinearAlgebra.UnitUpperTriangular{Float64,Array{Float64,2}}:
 1.0  0.142857  -0.8
 0.0  1.0       -0.6
 0.0  0.0        1.0
permutation:
3-element Array{Int64,1}:
 1
 2
 3
``` -->

在这个过程中，Julia 能够自动检测出 `B` 是一个实对称矩阵，并且用一种更加合适的分解方法。
通常可以利用矩阵已知的一些性质来尽可能的写出更加高效的代码，例如对称性或三对角矩阵的性质。
Julia 提供了一些特殊类型用于给这些矩阵的性质打上“标签”。例如：

<!-- Here, Julia was able to detect that `B` is in fact symmetric, and used a more appropriate factorization.
Often it's possible to write more efficient code for a matrix that is known to have certain properties e.g.
it is symmetric, or tridiagonal. Julia provides some special types so that you can "tag" matrices as having
these properties. For instance: -->

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0
```

<!-- ```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0
``` -->

`sB` 已被标记为一个（实）对称矩阵，因此对于被标记矩阵的后续运算，
例如特征分解或矩阵-向量乘积运算，通过仅仅引用矩阵中的一半元素使运算高效。例如：

<!-- `sB` has been tagged as a matrix that's (real) symmetric, so for later operations we might perform on it,
such as eigenfactorization or computing matrix-vector products, efficiencies can be found by only referencing
half of it. For example: -->

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> x = [1; 2; 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> sB\x
3-element Array{Float64,1}:
 -1.7391304347826084
 -1.1086956521739126
 -1.4565217391304346
```

<!-- ```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> x = [1; 2; 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> sB\x
3-element Array{Float64,1}:
 -1.7391304347826084
 -1.1086956521739126
 -1.4565217391304346
``` -->

这里的 `\` 运算执行了线性求解过程（译者注：对 sB*u = x 这一非齐次线性方程组的求解过程）。这一左除运算符是十分强大的，
并且很容易利用它写出简洁，易读的代码，从而灵活的解决各种线性方程组问题。

<!-- The `\` operation here performs the linear solution. The left-division operator is pretty powerful and it's easy to write compact, readable code that is flexible enough to solve all sorts of systems of linear equations. -->

## 特殊矩阵

<!-- ## Special matrices -->

[带有特殊对称性和特殊结构的矩阵](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=3274)
在线性代数中很常见，这些矩阵时常和矩阵分解联系到一起。Julia 内置了非常丰富的特殊矩阵类型，
可以快速地对特殊矩阵进行特定的操作。

<!-- [Matrices with special symmetries and structures](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=3274)
arise often in linear algebra and are frequently associated with various matrix factorizations.
Julia features a rich collection of special matrix types, which allow for fast computation with
specialized routines that are specially developed for particular matrix types. -->

下面的表格总结了 Julia 中的特殊矩阵类型，其中也包含了LAPACK中一些已优化的运算。

<!-- The following tables summarize the types of special matrices that have been implemented in Julia,
as well as whether hooks to various optimized methods for them in LAPACK are available. -->

| 类型                      | 描述                                                                      |
|:------------------------- |:-------------------------------------------------------------------------------- |
| [`Symmetric`](@ref)       | [对称矩阵](https://en.wikipedia.org/wiki/Symmetric_matrix)               |
| [`Hermitian`](@ref)       | [埃尔米特矩阵](https://en.wikipedia.org/wiki/Hermitian_matrix)               |
| [`UpperTriangular`](@ref) | 上[三角矩阵](https://en.wikipedia.org/wiki/Triangular_matrix)       |
| [`LowerTriangular`](@ref) | 下[三角矩阵](https://en.wikipedia.org/wiki/Triangular_matrix)       |
| [`Tridiagonal`](@ref)     | [三对角矩阵](https://en.wikipedia.org/wiki/Tridiagonal_matrix)           |
| [`SymTridiagonal`](@ref)  | 对称三对角矩阵                                                     |
| [`Bidiagonal`](@ref)      | 上/下[双对称矩阵](https://en.wikipedia.org/wiki/Bidiagonal_matrix) |
| [`Diagonal`](@ref)        | [对角矩阵](https://en.wikipedia.org/wiki/Diagonal_matrix)                 |
| [`UniformScaling`](@ref)  | [归一化缩放运算符](https://en.wikipedia.org/wiki/Uniform_scaling)        |

<!-- | Type                      | Description                                                                      |
|:------------------------- |:-------------------------------------------------------------------------------- |
| [`Symmetric`](@ref)       | [Symmetric matrix](https://en.wikipedia.org/wiki/Symmetric_matrix)               |
| [`Hermitian`](@ref)       | [Hermitian matrix](https://en.wikipedia.org/wiki/Hermitian_matrix)               |
| [`UpperTriangular`](@ref) | Upper [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix)       |
| [`LowerTriangular`](@ref) | Lower [triangular matrix](https://en.wikipedia.org/wiki/Triangular_matrix)       |
| [`Tridiagonal`](@ref)     | [Tridiagonal matrix](https://en.wikipedia.org/wiki/Tridiagonal_matrix)           |
| [`SymTridiagonal`](@ref)  | Symmetric tridiagonal matrix                                                     |
| [`Bidiagonal`](@ref)      | Upper/lower [bidiagonal matrix](https://en.wikipedia.org/wiki/Bidiagonal_matrix) |
| [`Diagonal`](@ref)        | [Diagonal matrix](https://en.wikipedia.org/wiki/Diagonal_matrix)                 |
| [`UniformScaling`](@ref)  | [Uniform scaling operator](https://en.wikipedia.org/wiki/Uniform_scaling)        | -->

### 基本运算

<!-- ### Elementary operations -->

| 矩阵类型                   | `+` | `-` | `*` | `\` | 其他已优化的函数                                             |
|:------------------------- |:--- |:--- |:--- |:--- |:----------------------------------------------------------- |
| [`Symmetric`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`Hermitian`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`UpperTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`LowerTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`SymTridiagonal`](@ref)  | M   | M   | MS  | MV  | [`eigmax`](@ref), [`eigmin`](@ref)                          |
| [`Tridiagonal`](@ref)     | M   | M   | MS  | MV  |                                                             |
| [`Bidiagonal`](@ref)      | M   | M   | MS  | MV  |                                                             |
| [`Diagonal`](@ref)        | M   | M   | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref), [`/`](@ref) |
| [`UniformScaling`](@ref)  | M   | M   | MVS | MVS | [`/`](@ref)                                                 |

<!-- | Matrix type               | `+` | `-` | `*` | `\` | Other functions with optimized methods                      |
|:------------------------- |:--- |:--- |:--- |:--- |:----------------------------------------------------------- |
| [`Symmetric`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`Hermitian`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`UpperTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`LowerTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`SymTridiagonal`](@ref)  | M   | M   | MS  | MV  | [`eigmax`](@ref), [`eigmin`](@ref)                          |
| [`Tridiagonal`](@ref)     | M   | M   | MS  | MV  |                                                             |
| [`Bidiagonal`](@ref)      | M   | M   | MS  | MV  |                                                             |
| [`Diagonal`](@ref)        | M   | M   | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref), [`/`](@ref) |
| [`UniformScaling`](@ref)  | M   | M   | MVS | MVS | [`/`](@ref)                                                 | -->

图例：

<!-- Legend: -->

| 关键字   | 描述                 |
|:-------- |:------------------- |
| M (矩阵) | 已对矩阵-矩阵运算优化 |
| V (向量) | 已对矩阵-向量运算优化 |
| S (标量) | 已对矩阵-标量运算优化 |

<!-- | Key        | Description                                                   |
|:---------- |:------------------------------------------------------------- |
| M (matrix) | An optimized method for matrix-matrix operations is available |
| V (vector) | An optimized method for matrix-vector operations is available |
| S (scalar) | An optimized method for matrix-scalar operations is available | -->

### 矩阵分解

<!-- ### Matrix factorizations -->

| 矩阵类型                   | LAPACK | [`eig`](@ref) | [`eigvals`](@ref) | [`eigvecs`](@ref) | [`svd`](@ref) | [`svdvals`](@ref) |
|:------------------------- |:------ |:------------- |:----------------- |:----------------- |:------------- |:----------------- |
| [`Symmetric`](@ref)       | SY     |               | ARI               |                   |               |                   |
| [`Hermitian`](@ref)       | HE     |               | ARI               |                   |               |                   |
| [`UpperTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`LowerTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`SymTridiagonal`](@ref)  | ST     | A             | ARI               | AV                |               |                   |
| [`Tridiagonal`](@ref)     | GT     |               |                   |                   |               |                   |
| [`Bidiagonal`](@ref)      | BD     |               |                   |                   | A             | A                 |
| [`Diagonal`](@ref)        | DI     |               | A                 |                   |               |                   |

<!-- | Matrix type               | LAPACK | [`eig`](@ref) | [`eigvals`](@ref) | [`eigvecs`](@ref) | [`svd`](@ref) | [`svdvals`](@ref) |
|:------------------------- |:------ |:------------- |:----------------- |:----------------- |:------------- |:----------------- |
| [`Symmetric`](@ref)       | SY     |               | ARI               |                   |               |                   |
| [`Hermitian`](@ref)       | HE     |               | ARI               |                   |               |                   |
| [`UpperTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`LowerTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`SymTridiagonal`](@ref)  | ST     | A             | ARI               | AV                |               |                   |
| [`Tridiagonal`](@ref)     | GT     |               |                   |                   |               |                   |
| [`Bidiagonal`](@ref)      | BD     |               |                   |                   | A             | A                 |
| [`Diagonal`](@ref)        | DI     |               | A                 |                   |               |                   | -->

图例：

<!-- Legend: -->

| 关键字       | 描述                                                                                                                     | 实例                        |
|:------------ |:------------------------------------------------------------------------------------------------------------------------------- |:-------------------- |
| A (所有)        | 已对寻找特征值和/或特征向量进行优化                                                                                                  | 例如 `eigvals(M)`    |
| R (范围)        | 已对寻找从 `il`th 到 `ih`th 的特征值进行优化                                                                                        | `eigvals(M, il, ih)` |
| I (区间)        | 已对寻找在闭区间 [`vl`, `vh`] 之间的特征值进行优化                                                                                   | `eigvals(M, vl, vh)` |
| V (向量)        | 已对寻找特征值 `x=[x1, x2,...]` 所对应的特征向量进行优化                                                                             | `eigvecs(M, x)`      |

<!-- | Key          | Description                                                                                                                     | Example              |
|:------------ |:------------------------------------------------------------------------------------------------------------------------------- |:-------------------- |
| A (all)      | An optimized method to find all the characteristic values and/or vectors is available                                           | e.g. `eigvals(M)`    |
| R (range)    | An optimized method to find the `il`th through the `ih`th characteristic values are available                                   | `eigvals(M, il, ih)` |
| I (interval) | An optimized method to find the characteristic values in the interval [`vl`, `vh`] is available                                 | `eigvals(M, vl, vh)` |
| V (vectors)  | An optimized method to find the characteristic vectors corresponding to the characteristic values `x=[x1, x2,...]` is available | `eigvecs(M, x)`      | -->

### 归一化缩放运算符（矩阵）

<!-- ### The uniform scaling operator -->

[`UniformScaling`](@ref)（归一化缩放）算符（矩阵）代表了一个标量乘上一个单位算子——`λ*I`。
单位算子 `I` 被定义为一个常量并且是 `UniformScaling` 的一个实例。
这些算符（矩阵）的行列数是不确定的并且会和其他双目矩阵运算符进行匹配，即 [`+`](@ref)、[`-`](@ref)、
[`*`](@ref) 和 [`\`](@ref)。对于 `A+I` 和 `A-I` 则意味着 `A` 必须是方阵。
带有单位算子 `I` 的乘法是一个空操作（除了检测缩放因子是一），因此几乎没有资源开销。

<!-- A [`UniformScaling`](@ref) operator represents a scalar times the identity operator, `λ*I`. The identity
operator `I` is defined as a constant and is an instance of `UniformScaling`. The size of these
operators are generic and match the other matrix in the binary operations [`+`](@ref), [`-`](@ref),
[`*`](@ref) and [`\`](@ref). For `A+I` and `A-I` this means that `A` must be square. Multiplication
with the identity operator `I` is a noop (except for checking that the scaling factor is one)
and therefore almost without overhead. -->

关于 `UniformScaling` 算符的实例：

<!-- To see the `UniformScaling` operator in action: -->

```jldoctest
julia> U = UniformScaling(2);

julia> a = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> a + U
2×2 Array{Int64,2}:
 3  2
 3  6

julia> a * U
2×2 Array{Int64,2}:
 2  4
 6  8

julia> [a U]
2×4 Array{Int64,2}:
 1  2  2  0
 3  4  0  2

julia> b = [1 2 3; 4 5 6]
2×3 Array{Int64,2}:
 1  2  3
 4  5  6

julia> b - U
ERROR: DimensionMismatch("matrix is not square: dimensions are (2, 3)")
Stacktrace:
 [1] checksquare at ./linalg/linalg.jl:220 [inlined]
 [2] -(::Array{Int64,2}, ::UniformScaling{Int64}) at ./linalg/uniformscaling.jl:156
 [3] top-level scope
```

<!-- ```jldoctest
julia> U = UniformScaling(2);

julia> a = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> a + U
2×2 Array{Int64,2}:
 3  2
 3  6

julia> a * U
2×2 Array{Int64,2}:
 2  4
 6  8

julia> [a U]
2×4 Array{Int64,2}:
 1  2  2  0
 3  4  0  2

julia> b = [1 2 3; 4 5 6]
2×3 Array{Int64,2}:
 1  2  3
 4  5  6

julia> b - U
ERROR: DimensionMismatch("matrix is not square: dimensions are (2, 3)")
Stacktrace:
 [1] checksquare at ./linalg/linalg.jl:220 [inlined]
 [2] -(::Array{Int64,2}, ::UniformScaling{Int64}) at ./linalg/uniformscaling.jl:156
 [3] top-level scope
``` -->

## [矩阵分解](@id man-linalg-factorizations)

<!-- ## [Matrix factorizations](@id man-linalg-factorizations) -->

[矩阵分解](https://en.wikipedia.org/wiki/Matrix_decomposition)是将一个矩阵分解为数个矩阵的乘积，
是线性代数中的一个核心概念。

<!-- [Matrix factorizations (a.k.a. matrix decompositions)](https://en.wikipedia.org/wiki/Matrix_decomposition)
compute the factorization of a matrix into a product of matrices, and are one of the central concepts
in linear algebra. -->

下表总结了 Julia 中已实现的几种矩阵分解类型，具体的函数可以参考线性代数文档中的[标准函数](@ref)部分。

<!-- The following table summarizes the types of matrix factorizations that have been implemented in
Julia. Details of their associated methods can be found in the [Standard Functions](@ref) section
of the Linear Algebra documentation. -->

| 类型              | 描述                                                                                                           |
|:----------------- |:-------------------------------------------------------------------------------------------------------------- |
| `Cholesky`        | [Cholesky 分解](https://en.wikipedia.org/wiki/Cholesky_decomposition)                                          |
| `CholeskyPivoted` | [主元](https://en.wikipedia.org/wiki/Pivot_element) Cholesky 分解                                              |
| `LU`              | [LU 分解](https://en.wikipedia.org/wiki/LU_decomposition)                                                      |
| `LUTridiagonal`   | [`三对角`](@ref)矩阵的 LU 分解                                                                                  |
| `QR`              | [QR 分解](https://en.wikipedia.org/wiki/QR_decomposition)                                                      |
| `QRCompactWY`     | 紧凑型 WY 的 QR 分解                                                                                            |
| `QRPivoted`       | 主元 [QR 分解](https://en.wikipedia.org/wiki/QR_decomposition)                                                 |
| `Hessenberg`      | [Hessenberg 分解](http://mathworld.wolfram.com/HessenbergDecomposition.html)                                   |
| `Eigen`           | [特征分解](https://en.wikipedia.org/wiki/Eigendecomposition_(matrix))                                          |
| `SVD`             | [奇异值分解](https://en.wikipedia.org/wiki/Singular_value_decomposition)                                       |
| `GeneralizedSVD`  | [广义奇异值分解](https://en.wikipedia.org/wiki/Generalized_singular_value_decomposition#Higher_order_version) |

<!-- | Type              | Description                                                                                                    |
|:----------------- |:-------------------------------------------------------------------------------------------------------------- |
| `Cholesky`        | [Cholesky factorization](https://en.wikipedia.org/wiki/Cholesky_decomposition)                                 |
| `CholeskyPivoted` | [Pivoted](https://en.wikipedia.org/wiki/Pivot_element) Cholesky factorization                                  |
| `LU`              | [LU factorization](https://en.wikipedia.org/wiki/LU_decomposition)                                             |
| `LUTridiagonal`   | LU factorization for [`Tridiagonal`](@ref) matrices                                                            |
| `QR`              | [QR factorization](https://en.wikipedia.org/wiki/QR_decomposition)                                             |
| `QRCompactWY`     | Compact WY form of the QR factorization                                                                        |
| `QRPivoted`       | Pivoted [QR factorization](https://en.wikipedia.org/wiki/QR_decomposition)                                     |
| `Hessenberg`      | [Hessenberg decomposition](http://mathworld.wolfram.com/HessenbergDecomposition.html)                          |
| `Eigen`           | [Spectral decomposition](https://en.wikipedia.org/wiki/Eigendecomposition_(matrix))                            |
| `SVD`             | [Singular value decomposition](https://en.wikipedia.org/wiki/Singular_value_decomposition)                     |
| `GeneralizedSVD`  | [Generalized SVD](https://en.wikipedia.org/wiki/Generalized_singular_value_decomposition#Higher_order_version) | -->


## 标准函数

<!-- ## Standard Functions -->

Julia 通过调用 [LAPACK](http://www.netlib.org/lapack/) 函数的方式实现了大量的线性代数函数。
少部分矩阵分解函数则调用了 [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html) 的函数。

<!-- Linear algebra functions in Julia are largely implemented by calling functions from [LAPACK](http://www.netlib.org/lapack/).
 Sparse factorizations call functions from [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html). -->

```@docs
Base.:*(::AbstractMatrix, ::AbstractMatrix)
Base.:\(::AbstractMatrix, ::AbstractVecOrMat)
LinearAlgebra.dot
LinearAlgebra.vecdot
LinearAlgebra.cross
LinearAlgebra.factorize
LinearAlgebra.Diagonal
LinearAlgebra.Bidiagonal
LinearAlgebra.SymTridiagonal
LinearAlgebra.Tridiagonal
LinearAlgebra.Symmetric
LinearAlgebra.Hermitian
LinearAlgebra.LowerTriangular
LinearAlgebra.UpperTriangular
LinearAlgebra.UniformScaling
LinearAlgebra.lu
LinearAlgebra.lufact
LinearAlgebra.lufact!
LinearAlgebra.chol
LinearAlgebra.cholfact
LinearAlgebra.cholfact!
LinearAlgebra.lowrankupdate
LinearAlgebra.lowrankdowndate
LinearAlgebra.lowrankupdate!
LinearAlgebra.lowrankdowndate!
LinearAlgebra.ldltfact
LinearAlgebra.ldltfact!
LinearAlgebra.qr
LinearAlgebra.qr!
LinearAlgebra.qrfact
LinearAlgebra.qrfact!
LinearAlgebra.QR
LinearAlgebra.QRCompactWY
LinearAlgebra.QRPivoted
LinearAlgebra.lqfact!
LinearAlgebra.lqfact
LinearAlgebra.lq
LinearAlgebra.bkfact
LinearAlgebra.bkfact!
LinearAlgebra.eig
LinearAlgebra.eigvals
LinearAlgebra.eigvals!
LinearAlgebra.eigmax
LinearAlgebra.eigmin
LinearAlgebra.eigvecs
LinearAlgebra.eigfact
LinearAlgebra.eigfact!
LinearAlgebra.hessfact
LinearAlgebra.hessfact!
LinearAlgebra.schurfact
LinearAlgebra.schurfact!
LinearAlgebra.schur
LinearAlgebra.ordschur
LinearAlgebra.ordschur!
LinearAlgebra.svdfact
LinearAlgebra.svdfact!
LinearAlgebra.svd
LinearAlgebra.svdvals
LinearAlgebra.svdvals!
LinearAlgebra.Givens
LinearAlgebra.givens
LinearAlgebra.triu
LinearAlgebra.triu!
LinearAlgebra.tril
LinearAlgebra.tril!
LinearAlgebra.diagind
LinearAlgebra.diag
LinearAlgebra.diagm
LinearAlgebra.rank
LinearAlgebra.norm
LinearAlgebra.vecnorm
LinearAlgebra.normalize!
LinearAlgebra.normalize
LinearAlgebra.cond
LinearAlgebra.condskeel
LinearAlgebra.trace
LinearAlgebra.det
LinearAlgebra.logdet
LinearAlgebra.logabsdet
Base.inv(::AbstractMatrix)
LinearAlgebra.pinv
LinearAlgebra.nullspace
Base.repmat
Base.kron
LinearAlgebra.linreg
LinearAlgebra.exp(::StridedMatrix{<:LinearAlgebra.BlasFloat})
LinearAlgebra.log(::StridedMatrix)
LinearAlgebra.sqrt(::StridedMatrix{<:Real})
LinearAlgebra.cos(::StridedMatrix{<:Real})
LinearAlgebra.sin(::StridedMatrix{<:Real})
LinearAlgebra.sincos(::StridedMatrix{<:Real})
LinearAlgebra.tan(::StridedMatrix{<:Real})
LinearAlgebra.sec(::StridedMatrix)
LinearAlgebra.csc(::StridedMatrix)
LinearAlgebra.cot(::StridedMatrix)
LinearAlgebra.cosh(::StridedMatrix)
LinearAlgebra.sinh(::StridedMatrix)
LinearAlgebra.tanh(::StridedMatrix)
LinearAlgebra.sech(::StridedMatrix)
LinearAlgebra.csch(::StridedMatrix)
LinearAlgebra.coth(::StridedMatrix)
LinearAlgebra.acos(::StridedMatrix)
LinearAlgebra.asin(::StridedMatrix)
LinearAlgebra.atan(::StridedMatrix)
LinearAlgebra.asec(::StridedMatrix)
LinearAlgebra.acsc(::StridedMatrix)
LinearAlgebra.acot(::StridedMatrix)
LinearAlgebra.acosh(::StridedMatrix)
LinearAlgebra.asinh(::StridedMatrix)
LinearAlgebra.atanh(::StridedMatrix)
LinearAlgebra.asech(::StridedMatrix)
LinearAlgebra.acsch(::StridedMatrix)
LinearAlgebra.acoth(::StridedMatrix)
LinearAlgebra.lyap
LinearAlgebra.sylvester
LinearAlgebra.issuccess
LinearAlgebra.issymmetric
LinearAlgebra.isposdef
LinearAlgebra.isposdef!
LinearAlgebra.istril
LinearAlgebra.istriu
LinearAlgebra.isdiag
LinearAlgebra.ishermitian
Base.transpose
LinearAlgebra.transpose!
Base.adjoint
LinearAlgebra.adjoint!
LinearAlgebra.peakflops
LinearAlgebra.stride1
LinearAlgebra.checksquare
```

<!-- ```@docs
Base.:*(::AbstractMatrix, ::AbstractMatrix)
Base.:\(::AbstractMatrix, ::AbstractVecOrMat)
LinearAlgebra.dot
LinearAlgebra.vecdot
LinearAlgebra.cross
LinearAlgebra.factorize
LinearAlgebra.Diagonal
LinearAlgebra.Bidiagonal
LinearAlgebra.SymTridiagonal
LinearAlgebra.Tridiagonal
LinearAlgebra.Symmetric
LinearAlgebra.Hermitian
LinearAlgebra.LowerTriangular
LinearAlgebra.UpperTriangular
LinearAlgebra.UniformScaling
LinearAlgebra.lu
LinearAlgebra.lufact
LinearAlgebra.lufact!
LinearAlgebra.chol
LinearAlgebra.cholfact
LinearAlgebra.cholfact!
LinearAlgebra.lowrankupdate
LinearAlgebra.lowrankdowndate
LinearAlgebra.lowrankupdate!
LinearAlgebra.lowrankdowndate!
LinearAlgebra.ldltfact
LinearAlgebra.ldltfact!
LinearAlgebra.qr
LinearAlgebra.qr!
LinearAlgebra.qrfact
LinearAlgebra.qrfact!
LinearAlgebra.QR
LinearAlgebra.QRCompactWY
LinearAlgebra.QRPivoted
LinearAlgebra.lqfact!
LinearAlgebra.lqfact
LinearAlgebra.lq
LinearAlgebra.bkfact
LinearAlgebra.bkfact!
LinearAlgebra.eig
LinearAlgebra.eigvals
LinearAlgebra.eigvals!
LinearAlgebra.eigmax
LinearAlgebra.eigmin
LinearAlgebra.eigvecs
LinearAlgebra.eigfact
LinearAlgebra.eigfact!
LinearAlgebra.hessfact
LinearAlgebra.hessfact!
LinearAlgebra.schurfact
LinearAlgebra.schurfact!
LinearAlgebra.schur
LinearAlgebra.ordschur
LinearAlgebra.ordschur!
LinearAlgebra.svdfact
LinearAlgebra.svdfact!
LinearAlgebra.svd
LinearAlgebra.svdvals
LinearAlgebra.svdvals!
LinearAlgebra.Givens
LinearAlgebra.givens
LinearAlgebra.triu
LinearAlgebra.triu!
LinearAlgebra.tril
LinearAlgebra.tril!
LinearAlgebra.diagind
LinearAlgebra.diag
LinearAlgebra.diagm
LinearAlgebra.rank
LinearAlgebra.norm
LinearAlgebra.vecnorm
LinearAlgebra.normalize!
LinearAlgebra.normalize
LinearAlgebra.cond
LinearAlgebra.condskeel
LinearAlgebra.trace
LinearAlgebra.det
LinearAlgebra.logdet
LinearAlgebra.logabsdet
Base.inv(::AbstractMatrix)
LinearAlgebra.pinv
LinearAlgebra.nullspace
Base.repmat
Base.kron
LinearAlgebra.linreg
LinearAlgebra.exp(::StridedMatrix{<:LinearAlgebra.BlasFloat})
LinearAlgebra.log(::StridedMatrix)
LinearAlgebra.sqrt(::StridedMatrix{<:Real})
LinearAlgebra.cos(::StridedMatrix{<:Real})
LinearAlgebra.sin(::StridedMatrix{<:Real})
LinearAlgebra.sincos(::StridedMatrix{<:Real})
LinearAlgebra.tan(::StridedMatrix{<:Real})
LinearAlgebra.sec(::StridedMatrix)
LinearAlgebra.csc(::StridedMatrix)
LinearAlgebra.cot(::StridedMatrix)
LinearAlgebra.cosh(::StridedMatrix)
LinearAlgebra.sinh(::StridedMatrix)
LinearAlgebra.tanh(::StridedMatrix)
LinearAlgebra.sech(::StridedMatrix)
LinearAlgebra.csch(::StridedMatrix)
LinearAlgebra.coth(::StridedMatrix)
LinearAlgebra.acos(::StridedMatrix)
LinearAlgebra.asin(::StridedMatrix)
LinearAlgebra.atan(::StridedMatrix)
LinearAlgebra.asec(::StridedMatrix)
LinearAlgebra.acsc(::StridedMatrix)
LinearAlgebra.acot(::StridedMatrix)
LinearAlgebra.acosh(::StridedMatrix)
LinearAlgebra.asinh(::StridedMatrix)
LinearAlgebra.atanh(::StridedMatrix)
LinearAlgebra.asech(::StridedMatrix)
LinearAlgebra.acsch(::StridedMatrix)
LinearAlgebra.acoth(::StridedMatrix)
LinearAlgebra.lyap
LinearAlgebra.sylvester
LinearAlgebra.issuccess
LinearAlgebra.issymmetric
LinearAlgebra.isposdef
LinearAlgebra.isposdef!
LinearAlgebra.istril
LinearAlgebra.istriu
LinearAlgebra.isdiag
LinearAlgebra.ishermitian
Base.transpose
LinearAlgebra.transpose!
Base.adjoint
LinearAlgebra.adjoint!
LinearAlgebra.peakflops
LinearAlgebra.stride1
LinearAlgebra.checksquare
``` -->

## 低耗矩阵运算

<!-- ## Low-level matrix operations -->

在许多情况下，矩阵的原地运算支持通过预申请空间的方式输出向量或矩阵。
这一特性在优化关键代码的时候十分有用，避免了重复申请的开销。
Julia 规则规定下面这些原地运算加上 `!` 的后缀（例如 `mul!`）。

<!-- In many cases there are in-place versions of matrix operations that allow you to supply
a pre-allocated output vector or matrix.  This is useful when optimizing critical code in order
to avoid the overhead of repeated allocations. These in-place operations are suffixed with `!`
below (e.g. `mul!`) according to the usual Julia convention. -->

```@docs
LinearAlgebra.mul!
LinearAlgebra.lmul!
LinearAlgebra.rmul!
LinearAlgebra.ldiv!
LinearAlgebra.rdiv!
```

<!-- ```@docs
LinearAlgebra.mul!
LinearAlgebra.lmul!
LinearAlgebra.rmul!
LinearAlgebra.ldiv!
LinearAlgebra.rdiv!
``` -->

## BLAS 函数

<!-- ## BLAS Functions -->

在 Julia 中（就像在许多科学计算语言中那样），密集型线性代数运算以 [LAPACK 库](http://www.netlib.org/lapack/)
为基础，它依次构建在一个叫 [BLAS](http://www.netlib.org/blas/) 的基础线性代数库的顶层之上。
对于每种计算机构架都有 BLAS 的高优化实现，并且在高性能的线性代数程序中，有时直接调用 BLAS 函数会十分有用。

<!-- In Julia (as in much of scientific computation), dense linear-algebra operations are based on
the [LAPACK library](http://www.netlib.org/lapack/), which in turn is built on top of basic linear-algebra
building-blocks known as the [BLAS](http://www.netlib.org/blas/). There are highly optimized
implementations of BLAS available for every computer architecture, and sometimes in high-performance
linear algebra routines it is useful to call the BLAS functions directly. -->

`LinearAlgebra.BLAS` 为一些 BLAS 函数提供了封装器。那些重写了输入数组的 BLAS 函数在函数名结尾会加上 `'!'`。
通常，一个 BLAS 函数一般有四种已定义的方法，即类型为 [`Float64`](@ref)、[`Float32`](@ref)、`ComplexF64` 和 `ComplexF32` 的数组。

<!-- `LinearAlgebra.BLAS` provides wrappers for some of the BLAS functions. Those BLAS functions
that overwrite one of the input arrays have names ending in `'!'`.  Usually, a BLAS function has
four methods defined, for [`Float64`](@ref), [`Float32`](@ref), `ComplexF64`, and `ComplexF32` arrays. -->

### [BLAS 特征参数](@id stdlib-blas-chars)
许多 BLAS 函数接收的参数决定了是否需要转置——参数 (`trans`)，
调用哪种类型的三角矩阵——参数 (`uplo` 或 `ul`)，
是否默认三角矩阵的对角线元素全为一——参数 (`dA`) 或者选择哪种矩阵乘法——参数 (`side`)。
以下是可能的参数类型：

<!-- ### [BLAS Character Arguments](@id stdlib-blas-chars)
Many BLAS functions accept arguments that determine whether to transpose an argument (`trans`),
which triangle of a matrix to reference (`uplo` or `ul`),
whether the diagonal of a triangular matrix can be assumed to
be all ones (`dA`) or which side of a matrix multiplication
the input argument belongs on (`side`). The possiblities are: -->

#### [矩阵乘序](@id stdlib-blas-side)
| `side` | 意义             |
|:-------|:-----------------|
| `'L'`  | *左*乘矩阵运算。  |
| `'R'`  | *右*乘矩阵运算。  |

<!-- #### [Multplication Order](@id stdlib-blas-side)
| `side` | Meaning                                                             |
|:-------|:--------------------------------------------------------------------|
| `'L'`  | The argument goes on the *left* side of a matrix-matrix operation.  |
| `'R'`  | The argument goes on the *right* side of a matrix-matrix operation. | -->

#### [三角矩阵类型](@id stdlib-blas-uplo)
| `uplo`/`ul` | 意义                |
|:------------|:-------------------|
| `'U'`       | 将调用*上*三角矩阵。 |
| `'L'`       | 将调用*下*三角矩阵。 |

<!-- #### [Triangle Referencing](@id stdlib-blas-uplo)
| `uplo`/`ul` | Meaning                                               |
|:------------|:------------------------------------------------------|
| `'U'`       | Only the *upper* triangle of the matrix will be used. |
| `'L'`       | Only the *lower* triangle of the matrix will be used. | -->

#### [转置运算](@id stdlib-blas-trans)
| `trans`/`tX` | 意义                            |
|:-------------|:-------------------------------|
| `'N'`        | 输入矩阵 `X` 既不转置也不共轭。   |
| `'T'`        | 输入矩阵 `X` 将进行转置。        |
| `'C'`        | 输入矩阵 `X` 将共轭转置。        |

<!-- #### [Transposition Operation](@id stdlib-blas-trans)
| `trans`/`tX` | Meaning                                                 |
|:-------------|:--------------------------------------------------------|
| `'N'`        | The input matrix `X` is not transposed or conjugated.   |
| `'T'`        | The input matrix `X` will be transposed.                |
| `'C'`        | The input matrix `X` will be conjugated and transposed. | -->

#### [单位对角线](@id stdlib-blas-diag)
| `diag`/`dX` | 意义                              |
|:------------|:----------------------------------|
| `'N'`       | 将读取矩阵 `X` 的对角线元素。       |
| `'U'`       | 将默认 `X` 矩阵的对角线元素全为一。  |

<!-- #### [Unit Diagonal](@id stdlib-blas-diag)
| `diag`/`dX` | Meaning                                                   |
|:------------|:----------------------------------------------------------|
| `'N'`       | The diagonal values of the matrix `X` will be read.       |
| `'U'`       | The diagonal of the matrix `X` is assumed to be all ones. | -->

```@docs
LinearAlgebra.BLAS
LinearAlgebra.BLAS.dotu
LinearAlgebra.BLAS.dotc
LinearAlgebra.BLAS.blascopy!
LinearAlgebra.BLAS.nrm2
LinearAlgebra.BLAS.asum
LinearAlgebra.axpy!
LinearAlgebra.BLAS.scal!
LinearAlgebra.BLAS.scal
LinearAlgebra.BLAS.ger!
LinearAlgebra.BLAS.syr!
LinearAlgebra.BLAS.syrk!
LinearAlgebra.BLAS.syrk
LinearAlgebra.BLAS.her!
LinearAlgebra.BLAS.herk!
LinearAlgebra.BLAS.herk
LinearAlgebra.BLAS.gbmv!
LinearAlgebra.BLAS.gbmv
LinearAlgebra.BLAS.sbmv!
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm!
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemv!
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm!
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symv!
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.trmm!
LinearAlgebra.BLAS.trmm
LinearAlgebra.BLAS.trsm!
LinearAlgebra.BLAS.trsm
LinearAlgebra.BLAS.trmv!
LinearAlgebra.BLAS.trmv
LinearAlgebra.BLAS.trsv!
LinearAlgebra.BLAS.trsv
LinearAlgebra.BLAS.set_num_threads
LinearAlgebra.I
```

<!-- ```@docs
LinearAlgebra.BLAS
LinearAlgebra.BLAS.dotu
LinearAlgebra.BLAS.dotc
LinearAlgebra.BLAS.blascopy!
LinearAlgebra.BLAS.nrm2
LinearAlgebra.BLAS.asum
LinearAlgebra.axpy!
LinearAlgebra.BLAS.scal!
LinearAlgebra.BLAS.scal
LinearAlgebra.BLAS.ger!
LinearAlgebra.BLAS.syr!
LinearAlgebra.BLAS.syrk!
LinearAlgebra.BLAS.syrk
LinearAlgebra.BLAS.her!
LinearAlgebra.BLAS.herk!
LinearAlgebra.BLAS.herk
LinearAlgebra.BLAS.gbmv!
LinearAlgebra.BLAS.gbmv
LinearAlgebra.BLAS.sbmv!
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.sbmv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm!
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemv!
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.gemv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm!
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symm(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symv!
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any, ::Any)
LinearAlgebra.BLAS.symv(::Any, ::Any, ::Any)
LinearAlgebra.BLAS.trmm!
LinearAlgebra.BLAS.trmm
LinearAlgebra.BLAS.trsm!
LinearAlgebra.BLAS.trsm
LinearAlgebra.BLAS.trmv!
LinearAlgebra.BLAS.trmv
LinearAlgebra.BLAS.trsv!
LinearAlgebra.BLAS.trsv
LinearAlgebra.BLAS.set_num_threads
LinearAlgebra.I
``` -->

## LAPACK 函数

<!-- ## LAPACK Functions -->

`LinearAlgebra.LAPACK` 为一些线性代数的 LAPACK 函数提供了封装器。
那些重写了输入数组的函数在函数名结尾加上 `'!'`。

<!-- `LinearAlgebra.LAPACK` provides wrappers for some of the LAPACK functions for linear algebra.
 Those functions that overwrite one of the input arrays have names ending in `'!'`. -->

通常，一个函数有四种已定义的方法，各有 [`Float64`](@ref)、[`Float32`](@ref)、`ComplexF64` 和 `ComplexF32` 类型的数组。

<!-- Usually a function has 4 methods defined, one each for [`Float64`](@ref), [`Float32`](@ref),
`ComplexF64` and `ComplexF32` arrays. -->

注意，由 Julia 所提供的 LAPACK API 在将来很可能会发生变化。
因为这个 API 并不是面向用户的，在将来的发行版本中，没有义务去支持/反对这套特定的函数集。

<!-- Note that the LAPACK API provided by Julia can and will change in the future. Since this API is
not user-facing, there is no commitment to support/deprecate this specific set of functions in
future releases. -->

```@docs
LinearAlgebra.LAPACK
LinearAlgebra.LAPACK.gbtrf!
LinearAlgebra.LAPACK.gbtrs!
LinearAlgebra.LAPACK.gebal!
LinearAlgebra.LAPACK.gebak!
LinearAlgebra.LAPACK.gebrd!
LinearAlgebra.LAPACK.gelqf!
LinearAlgebra.LAPACK.geqlf!
LinearAlgebra.LAPACK.geqrf!
LinearAlgebra.LAPACK.geqp3!
LinearAlgebra.LAPACK.gerqf!
LinearAlgebra.LAPACK.geqrt!
LinearAlgebra.LAPACK.geqrt3!
LinearAlgebra.LAPACK.getrf!
LinearAlgebra.LAPACK.tzrzf!
LinearAlgebra.LAPACK.ormrz!
LinearAlgebra.LAPACK.gels!
LinearAlgebra.LAPACK.gesv!
LinearAlgebra.LAPACK.getrs!
LinearAlgebra.LAPACK.getri!
LinearAlgebra.LAPACK.gesvx!
LinearAlgebra.LAPACK.gelsd!
LinearAlgebra.LAPACK.gelsy!
LinearAlgebra.LAPACK.gglse!
LinearAlgebra.LAPACK.geev!
LinearAlgebra.LAPACK.gesdd!
LinearAlgebra.LAPACK.gesvd!
LinearAlgebra.LAPACK.ggsvd!
LinearAlgebra.LAPACK.ggsvd3!
LinearAlgebra.LAPACK.geevx!
LinearAlgebra.LAPACK.ggev!
LinearAlgebra.LAPACK.gtsv!
LinearAlgebra.LAPACK.gttrf!
LinearAlgebra.LAPACK.gttrs!
LinearAlgebra.LAPACK.orglq!
LinearAlgebra.LAPACK.orgqr!
LinearAlgebra.LAPACK.orgql!
LinearAlgebra.LAPACK.orgrq!
LinearAlgebra.LAPACK.ormlq!
LinearAlgebra.LAPACK.ormqr!
LinearAlgebra.LAPACK.ormql!
LinearAlgebra.LAPACK.ormrq!
LinearAlgebra.LAPACK.gemqrt!
LinearAlgebra.LAPACK.posv!
LinearAlgebra.LAPACK.potrf!
LinearAlgebra.LAPACK.potri!
LinearAlgebra.LAPACK.potrs!
LinearAlgebra.LAPACK.pstrf!
LinearAlgebra.LAPACK.ptsv!
LinearAlgebra.LAPACK.pttrf!
LinearAlgebra.LAPACK.pttrs!
LinearAlgebra.LAPACK.trtri!
LinearAlgebra.LAPACK.trtrs!
LinearAlgebra.LAPACK.trcon!
LinearAlgebra.LAPACK.trevc!
LinearAlgebra.LAPACK.trrfs!
LinearAlgebra.LAPACK.stev!
LinearAlgebra.LAPACK.stebz!
LinearAlgebra.LAPACK.stegr!
LinearAlgebra.LAPACK.stein!
LinearAlgebra.LAPACK.syconv!
LinearAlgebra.LAPACK.sysv!
LinearAlgebra.LAPACK.sytrf!
LinearAlgebra.LAPACK.sytri!
LinearAlgebra.LAPACK.sytrs!
LinearAlgebra.LAPACK.hesv!
LinearAlgebra.LAPACK.hetrf!
LinearAlgebra.LAPACK.hetri!
LinearAlgebra.LAPACK.hetrs!
LinearAlgebra.LAPACK.syev!
LinearAlgebra.LAPACK.syevr!
LinearAlgebra.LAPACK.sygvd!
LinearAlgebra.LAPACK.bdsqr!
LinearAlgebra.LAPACK.bdsdc!
LinearAlgebra.LAPACK.gecon!
LinearAlgebra.LAPACK.gehrd!
LinearAlgebra.LAPACK.orghr!
LinearAlgebra.LAPACK.gees!
LinearAlgebra.LAPACK.gges!
LinearAlgebra.LAPACK.trexc!
LinearAlgebra.LAPACK.trsen!
LinearAlgebra.LAPACK.tgsen!
LinearAlgebra.LAPACK.trsyl!
```

<!-- ```@docs
LinearAlgebra.LAPACK
LinearAlgebra.LAPACK.gbtrf!
LinearAlgebra.LAPACK.gbtrs!
LinearAlgebra.LAPACK.gebal!
LinearAlgebra.LAPACK.gebak!
LinearAlgebra.LAPACK.gebrd!
LinearAlgebra.LAPACK.gelqf!
LinearAlgebra.LAPACK.geqlf!
LinearAlgebra.LAPACK.geqrf!
LinearAlgebra.LAPACK.geqp3!
LinearAlgebra.LAPACK.gerqf!
LinearAlgebra.LAPACK.geqrt!
LinearAlgebra.LAPACK.geqrt3!
LinearAlgebra.LAPACK.getrf!
LinearAlgebra.LAPACK.tzrzf!
LinearAlgebra.LAPACK.ormrz!
LinearAlgebra.LAPACK.gels!
LinearAlgebra.LAPACK.gesv!
LinearAlgebra.LAPACK.getrs!
LinearAlgebra.LAPACK.getri!
LinearAlgebra.LAPACK.gesvx!
LinearAlgebra.LAPACK.gelsd!
LinearAlgebra.LAPACK.gelsy!
LinearAlgebra.LAPACK.gglse!
LinearAlgebra.LAPACK.geev!
LinearAlgebra.LAPACK.gesdd!
LinearAlgebra.LAPACK.gesvd!
LinearAlgebra.LAPACK.ggsvd!
LinearAlgebra.LAPACK.ggsvd3!
LinearAlgebra.LAPACK.geevx!
LinearAlgebra.LAPACK.ggev!
LinearAlgebra.LAPACK.gtsv!
LinearAlgebra.LAPACK.gttrf!
LinearAlgebra.LAPACK.gttrs!
LinearAlgebra.LAPACK.orglq!
LinearAlgebra.LAPACK.orgqr!
LinearAlgebra.LAPACK.orgql!
LinearAlgebra.LAPACK.orgrq!
LinearAlgebra.LAPACK.ormlq!
LinearAlgebra.LAPACK.ormqr!
LinearAlgebra.LAPACK.ormql!
LinearAlgebra.LAPACK.ormrq!
LinearAlgebra.LAPACK.gemqrt!
LinearAlgebra.LAPACK.posv!
LinearAlgebra.LAPACK.potrf!
LinearAlgebra.LAPACK.potri!
LinearAlgebra.LAPACK.potrs!
LinearAlgebra.LAPACK.pstrf!
LinearAlgebra.LAPACK.ptsv!
LinearAlgebra.LAPACK.pttrf!
LinearAlgebra.LAPACK.pttrs!
LinearAlgebra.LAPACK.trtri!
LinearAlgebra.LAPACK.trtrs!
LinearAlgebra.LAPACK.trcon!
LinearAlgebra.LAPACK.trevc!
LinearAlgebra.LAPACK.trrfs!
LinearAlgebra.LAPACK.stev!
LinearAlgebra.LAPACK.stebz!
LinearAlgebra.LAPACK.stegr!
LinearAlgebra.LAPACK.stein!
LinearAlgebra.LAPACK.syconv!
LinearAlgebra.LAPACK.sysv!
LinearAlgebra.LAPACK.sytrf!
LinearAlgebra.LAPACK.sytri!
LinearAlgebra.LAPACK.sytrs!
LinearAlgebra.LAPACK.hesv!
LinearAlgebra.LAPACK.hetrf!
LinearAlgebra.LAPACK.hetri!
LinearAlgebra.LAPACK.hetrs!
LinearAlgebra.LAPACK.syev!
LinearAlgebra.LAPACK.syevr!
LinearAlgebra.LAPACK.sygvd!
LinearAlgebra.LAPACK.bdsqr!
LinearAlgebra.LAPACK.bdsdc!
LinearAlgebra.LAPACK.gecon!
LinearAlgebra.LAPACK.gehrd!
LinearAlgebra.LAPACK.orghr!
LinearAlgebra.LAPACK.gees!
LinearAlgebra.LAPACK.gges!
LinearAlgebra.LAPACK.trexc!
LinearAlgebra.LAPACK.trsen!
LinearAlgebra.LAPACK.tgsen!
LinearAlgebra.LAPACK.trsyl!
``` -->
