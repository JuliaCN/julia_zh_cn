.. _man-methods:

******
 方法
******

:ref:`man-functions` 中说到，函数是从参数多元组映射到返回值的对象，若没有合适返回值则抛出异常。实际中常需要对不同类型的参数做同样的运算，例如对整数做加法、对浮点数做加法、对整数与浮点数做加法，它们都是加法。在 Julia 中，它们都属于同一对象： ``+`` 函数。

对同一概念做一系列实现时，可以逐个定义特定参数类型、个数所对应的特定函数行为。 *方法* 是对函数中某一特定的行为定义。函数中可以定义多个方法。对一个特定的参数多元组调用函数时，最匹配此参数多元组的方法被调用。

函数调用时，选取调用哪个方法，被称为 `重载 <http://en.wikipedia.org/wiki/Multiple_dispatch>`_ 。 Julia 依据参数个数、类型来进行重载。


定义方法
--------

Julia 的所有标准函数和运算符，如前面提到的 ``+`` 函数，都有许多针对各种参数类型组合和不同参数个数而定义的方法。

定义函数时，可以像 :ref:`man-composite-types` 中介绍的那样，使用 ``::`` 类型断言运算符，选择性地对参数类型进行限制：


.. doctest::

    julia> f(x::Float64, y::Float64) = 2x + y;

此函数中参数 ``x`` 和 ``y`` 只能是 ``Float64`` 类型：

.. doctest::

    julia> f(2.0, 3.0)
    7.0

如果参数是其它类型，会引发 “no method” 错误：

.. doctest::

    julia> f(2.0, 3)
    ERROR: `f` has no method matching f(::Float64, ::Int64)

    julia> f(float32(2.0), 3.0)
    ERROR: `f` has no method matching f(::Float32, ::Float64)

    julia> f(2.0, "3.0")
    ERROR: `f` has no method matching f(::Float64, ::ASCIIString)

    julia> f("2.0", "3.0")
    ERROR: `f` has no method matching f(::ASCIIString, ::ASCIIString)

有时需要写一些通用方法，这时应声明参数为抽象类型：

.. doctest::

    julia> f(x::Number, y::Number) = 2x - y;

    julia> f(2.0, 3)
    1.0

要想给一个函数定义多个方法，只需要多次定义这个函数，每次定义的参数个数和类型需不同。函数调用时，最匹配的方法被重载：

.. doctest::

    julia> f(2.0, 3.0)
    7.0

    julia> f(2, 3.0)
    1.0

    julia> f(2.0, 3)
    1.0

    julia> f(2, 3)
    1

对非数值的值，或参数个数少于 2 ， ``f`` 是未定义的，调用它会返回 “no method” 错误：

.. doctest::

    julia> f("foo", 3)
    ERROR: `f` has no method matching f(::ASCIIString, ::Int64)

    julia> f()
    ERROR: `f` has no method matching f()

在交互式会话中输入函数对象本身，可以看到函数所存在的方法：

.. doctest::

    julia> f
    f (generic function with 2 methods)
    
This output tells us that ``f`` is a function object with two
methods. To find out what the signatures of those methods are, use the
``methods`` function:

.. doctest::

    julia> methods(f)
    # 2 methods for generic function "f":
    f(x::Float64,y::Float64) at none:1
    f(x::Number,y::Number) at none:1

which shows that f has two methods, one taking two ``Float64``
arguments and one taking arguments of type ``Number``. It also
indicates the file and line number where the methods were defined:
because these methods were defined at the REPL, we get the apparent
line number ``none:1``.    

定义类型时如果没使用 ``::`` ，则方法参数的类型默认为 ``Any`` 。对 ``f`` 定义一个总括匹配的方法：

.. doctest::

    julia> f(x,y) = println("Whoa there, Nelly.");

    julia> f("foo", 1)
    Whoa there, Nelly.

总括匹配的方法，是重载时的最后选择。

重载是 Julia 最强大最核心的特性。核心运算一般都有好几十种方法： ::

    julia> methods(+)
    # 125 methods for generic function "+":
    +(x::Bool) at bool.jl:36
    +(x::Bool,y::Bool) at bool.jl:39
    +(y::FloatingPoint,x::Bool) at bool.jl:49
    +(A::BitArray{N},B::BitArray{N}) at bitarray.jl:848
    +(A::Union(DenseArray{Bool,N},SubArray{Bool,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)}),B::Union(DenseArray{Bool,N},SubArray{Bool,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)})) at array.jl:797
    +{S,T}(A::Union(SubArray{S,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)},DenseArray{S,N}),B::Union(SubArray{T,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)},DenseArray{T,N})) at array.jl:719
    +{T<:Union(Int16,Int32,Int8)}(x::T<:Union(Int16,Int32,Int8),y::T<:Union(Int16,Int32,Int8)) at int.jl:16
    +{T<:Union(Uint32,Uint16,Uint8)}(x::T<:Union(Uint32,Uint16,Uint8),y::T<:Union(Uint32,Uint16,Uint8)) at int.jl:20
    +(x::Int64,y::Int64) at int.jl:33
    +(x::Uint64,y::Uint64) at int.jl:34
    +(x::Int128,y::Int128) at int.jl:35
    +(x::Uint128,y::Uint128) at int.jl:36
    +(x::Float32,y::Float32) at float.jl:119
    +(x::Float64,y::Float64) at float.jl:120
    +(z::Complex{T<:Real},w::Complex{T<:Real}) at complex.jl:110
    +(x::Real,z::Complex{T<:Real}) at complex.jl:120
    +(z::Complex{T<:Real},x::Real) at complex.jl:121
    +(x::Rational{T<:Integer},y::Rational{T<:Integer}) at rational.jl:113
    +(x::Char,y::Char) at char.jl:23
    +(x::Char,y::Integer) at char.jl:26
    +(x::Integer,y::Char) at char.jl:27
    +(a::Float16,b::Float16) at float16.jl:132
    +(x::BigInt,y::BigInt) at gmp.jl:194
    +(a::BigInt,b::BigInt,c::BigInt) at gmp.jl:217
    +(a::BigInt,b::BigInt,c::BigInt,d::BigInt) at gmp.jl:223
    +(a::BigInt,b::BigInt,c::BigInt,d::BigInt,e::BigInt) at gmp.jl:230
    +(x::BigInt,c::Uint64) at gmp.jl:242
    +(c::Uint64,x::BigInt) at gmp.jl:246
    +(c::Union(Uint32,Uint16,Uint8,Uint64),x::BigInt) at gmp.jl:247
    +(x::BigInt,c::Union(Uint32,Uint16,Uint8,Uint64)) at gmp.jl:248
    +(x::BigInt,c::Union(Int64,Int16,Int32,Int8)) at gmp.jl:249
    +(c::Union(Int64,Int16,Int32,Int8),x::BigInt) at gmp.jl:250
    +(x::BigFloat,c::Uint64) at mpfr.jl:147
    +(c::Uint64,x::BigFloat) at mpfr.jl:151
    +(c::Union(Uint32,Uint16,Uint8,Uint64),x::BigFloat) at mpfr.jl:152
    +(x::BigFloat,c::Union(Uint32,Uint16,Uint8,Uint64)) at mpfr.jl:153
    +(x::BigFloat,c::Int64) at mpfr.jl:157
    +(c::Int64,x::BigFloat) at mpfr.jl:161
    +(x::BigFloat,c::Union(Int64,Int16,Int32,Int8)) at mpfr.jl:162
    +(c::Union(Int64,Int16,Int32,Int8),x::BigFloat) at mpfr.jl:163
    +(x::BigFloat,c::Float64) at mpfr.jl:167
    +(c::Float64,x::BigFloat) at mpfr.jl:171
    +(c::Float32,x::BigFloat) at mpfr.jl:172
    +(x::BigFloat,c::Float32) at mpfr.jl:173
    +(x::BigFloat,c::BigInt) at mpfr.jl:177
    +(c::BigInt,x::BigFloat) at mpfr.jl:181
    +(x::BigFloat,y::BigFloat) at mpfr.jl:328
    +(a::BigFloat,b::BigFloat,c::BigFloat) at mpfr.jl:339
    +(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat) at mpfr.jl:345
    +(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat,e::BigFloat) at mpfr.jl:352
    +(x::MathConst{sym},y::MathConst{sym}) at constants.jl:23
    +{T<:Number}(x::T<:Number,y::T<:Number) at promotion.jl:188
    +{T<:FloatingPoint}(x::Bool,y::T<:FloatingPoint) at bool.jl:46
    +(x::Number,y::Number) at promotion.jl:158
    +(x::Integer,y::Ptr{T}) at pointer.jl:68
    +(x::Bool,A::AbstractArray{Bool,N}) at array.jl:767
    +(x::Number) at operators.jl:71
    +(r1::OrdinalRange{T,S},r2::OrdinalRange{T,S}) at operators.jl:325
    +{T<:FloatingPoint}(r1::FloatRange{T<:FloatingPoint},r2::FloatRange{T<:FloatingPoint}) at operators.jl:331
    +(r1::FloatRange{T<:FloatingPoint},r2::FloatRange{T<:FloatingPoint}) at operators.jl:348
    +(r1::FloatRange{T<:FloatingPoint},r2::OrdinalRange{T,S}) at operators.jl:349
    +(r1::OrdinalRange{T,S},r2::FloatRange{T<:FloatingPoint}) at operators.jl:350
    +(x::Ptr{T},y::Integer) at pointer.jl:66
    +{S,T<:Real}(A::Union(SubArray{S,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)},DenseArray{S,N}),B::Range{T<:Real}) at array.jl:727
    +{S<:Real,T}(A::Range{S<:Real},B::Union(SubArray{T,N,A<:DenseArray{T,N},I<:(Union(Range{Int64},Int64)...,)},DenseArray{T,N})) at array.jl:736
    +(A::AbstractArray{Bool,N},x::Bool) at array.jl:766
    +{Tv,Ti}(A::SparseMatrixCSC{Tv,Ti},B::SparseMatrixCSC{Tv,Ti}) at sparse/sparsematrix.jl:530
    +{TvA,TiA,TvB,TiB}(A::SparseMatrixCSC{TvA,TiA},B::SparseMatrixCSC{TvB,TiB}) at sparse/sparsematrix.jl:522
    +(A::SparseMatrixCSC{Tv,Ti<:Integer},B::Array{T,N}) at sparse/sparsematrix.jl:621
    +(A::Array{T,N},B::SparseMatrixCSC{Tv,Ti<:Integer}) at sparse/sparsematrix.jl:623
    +(A::SymTridiagonal{T},B::SymTridiagonal{T}) at linalg/tridiag.jl:45
    +(A::Tridiagonal{T},B::Tridiagonal{T}) at linalg/tridiag.jl:207
    +(A::Tridiagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:99
    +(A::SymTridiagonal{T},B::Tridiagonal{T}) at linalg/special.jl:98
    +{T,MT,uplo}(A::Triangular{T,MT,uplo,IsUnit},B::Triangular{T,MT,uplo,IsUnit}) at linalg/triangular.jl:10
    +{T,MT,uplo1,uplo2}(A::Triangular{T,MT,uplo1,IsUnit},B::Triangular{T,MT,uplo2,IsUnit}) at linalg/triangular.jl:11
    +(Da::Diagonal{T},Db::Diagonal{T}) at linalg/diagonal.jl:44
    +(A::Bidiagonal{T},B::Bidiagonal{T}) at linalg/bidiag.jl:92
    +{T}(B::BitArray{2},J::UniformScaling{T}) at linalg/uniformscaling.jl:26
    +(A::Diagonal{T},B::Bidiagonal{T}) at linalg/special.jl:89
    +(A::Bidiagonal{T},B::Diagonal{T}) at linalg/special.jl:90
    +(A::Diagonal{T},B::Tridiagonal{T}) at linalg/special.jl:89
    +(A::Tridiagonal{T},B::Diagonal{T}) at linalg/special.jl:90
    +(A::Diagonal{T},B::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
    +(A::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit},B::Diagonal{T}) at linalg/special.jl:90
    +(A::Diagonal{T},B::Array{T,2}) at linalg/special.jl:89
    +(A::Array{T,2},B::Diagonal{T}) at linalg/special.jl:90
    +(A::Bidiagonal{T},B::Tridiagonal{T}) at linalg/special.jl:89
    +(A::Tridiagonal{T},B::Bidiagonal{T}) at linalg/special.jl:90
    +(A::Bidiagonal{T},B::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
    +(A::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit},B::Bidiagonal{T}) at linalg/special.jl:90
    +(A::Bidiagonal{T},B::Array{T,2}) at linalg/special.jl:89
    +(A::Array{T,2},B::Bidiagonal{T}) at linalg/special.jl:90
    +(A::Tridiagonal{T},B::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
    +(A::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit},B::Tridiagonal{T}) at linalg/special.jl:90
    +(A::Tridiagonal{T},B::Array{T,2}) at linalg/special.jl:89
    +(A::Array{T,2},B::Tridiagonal{T}) at linalg/special.jl:90
    +(A::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit},B::Array{T,2}) at linalg/special.jl:89
    +(A::Array{T,2},B::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:90
    +(A::SymTridiagonal{T},B::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:98
    +(A::Triangular{T,S<:AbstractArray{T,2},UpLo,IsUnit},B::SymTridiagonal{T}) at linalg/special.jl:99
    +(A::SymTridiagonal{T},B::Array{T,2}) at linalg/special.jl:98
    +(A::Array{T,2},B::SymTridiagonal{T}) at linalg/special.jl:99
    +(A::Diagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:107
    +(A::SymTridiagonal{T},B::Diagonal{T}) at linalg/special.jl:108
    +(A::Bidiagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:107
    +(A::SymTridiagonal{T},B::Bidiagonal{T}) at linalg/special.jl:108
    +{T<:Number}(x::AbstractArray{T<:Number,N}) at abstractarray.jl:358
    +(A::AbstractArray{T,N},x::Number) at array.jl:770
    +(x::Number,A::AbstractArray{T,N}) at array.jl:771
    +(J1::UniformScaling{T<:Number},J2::UniformScaling{T<:Number}) at linalg/uniformscaling.jl:25
    +(J::UniformScaling{T<:Number},B::BitArray{2}) at linalg/uniformscaling.jl:27
    +(J::UniformScaling{T<:Number},A::AbstractArray{T,2}) at linalg/uniformscaling.jl:28
    +(J::UniformScaling{T<:Number},x::Number) at linalg/uniformscaling.jl:29
    +(x::Number,J::UniformScaling{T<:Number}) at linalg/uniformscaling.jl:30
    +{TA,TJ}(A::AbstractArray{TA,2},J::UniformScaling{TJ}) at linalg/uniformscaling.jl:33
    +{T}(a::HierarchicalValue{T},b::HierarchicalValue{T}) at pkg/resolve/versionweight.jl:19
    +(a::VWPreBuildItem,b::VWPreBuildItem) at pkg/resolve/versionweight.jl:82
    +(a::VWPreBuild,b::VWPreBuild) at pkg/resolve/versionweight.jl:120
    +(a::VersionWeight,b::VersionWeight) at pkg/resolve/versionweight.jl:164
    +(a::FieldValue,b::FieldValue) at pkg/resolve/fieldvalue.jl:41
    +(a::Vec2,b::Vec2) at graphics.jl:60
    +(bb1::BoundingBox,bb2::BoundingBox) at graphics.jl:123
    +(a,b,c) at operators.jl:82
    +(a,b,c,xs...) at operators.jl:83

重载和灵活的参数化类型系统一起，使得 Julia 可以抽象表达高级算法，不需关注实现的具体细节，生成有效率、运行时专用的代码。

方法歧义
--------

函数方法的适用范围可能会重叠：

.. doctest::

    julia> g(x::Float64, y) = 2x + y;

    julia> g(x, y::Float64) = x + 2y;
    Warning: New definition 
        g(Any,Float64) at none:1
    is ambiguous with: 
        g(Float64,Any) at none:1.
    To fix, define 
        g(Float64,Float64)
    before the new definition.

    julia> g(2.0, 3)
    7.0

    julia> g(2, 3.0)
    8.0

    julia> g(2.0, 3.0)
    7.0

此处 ``g(2.0, 3.0)`` 既可以调用 ``g(Float64, Any)`` ，也可以调用 ``g(Any, Float64)`` ，两种方法没有优先级。遇到这种情况，Julia会警告定义含糊，但仍会任选一个方法来继续执行。应避免含糊的方法：

.. doctest::

    julia> g(x::Float64, y::Float64) = 2x + 2y;

    julia> g(x::Float64, y) = 2x + y;

    julia> g(x, y::Float64) = x + 2y;

    julia> g(2.0, 3)
    7.0

    julia> g(2, 3.0)
    8.0

    julia> g(2.0, 3.0)
    10.0

要消除 Julia 的警告，应先定义清晰的方法。

.. _man-parametric-methods:

参数化方法
----------

构造参数化方法，应在方法名与参数多元组之间，添加类型参数：

.. doctest::

    julia> same_type{T}(x::T, y::T) = true;

    julia> same_type(x,y) = false;

这两个方法定义了一个布尔函数，它检查两个参数是否为同一类型：

.. doctest::

    julia> same_type(1, 2)
    true

    julia> same_type(1, 2.0)
    false

    julia> same_type(1.0, 2.0)
    true

    julia> same_type("foo", 2.0)
    false

    julia> same_type("foo", "bar")
    true

    julia> same_type(int32(1), int64(2))
    false

类型参数可用于函数定义或函数体的任何地方：

.. doctest::

    julia> myappend{T}(v::Vector{T}, x::T) = [v..., x]
    myappend (generic function with 1 method)

    julia> myappend([1,2,3],4)
    4-element Array{Int64,1}:
     1
     2
     3
     4

    julia> myappend([1,2,3],2.5)
    ERROR: `myappend` has no method matching myappend(::Array{Int64,1}, ::Float64)

    julia> myappend([1.0,2.0,3.0],4.0)
    4-element Array{Float64,1}:
     1.0
     2.0
     3.0
     4.0

    julia> myappend([1.0,2.0,3.0],4)
    ERROR: `myappend` has no method matching myappend(::Array{Float64,1}, ::Int64)

下例中，方法类型参数 ``T`` 被用作返回值：

.. doctest::

    julia> mytypeof{T}(x::T) = T
    mytypeof (generic function with 1 method)

    julia> mytypeof(1)
    Int64

    julia> mytypeof(1.0)
    Float64

方法的类型参数也可以被限制范围： ::

    same_type_numeric{T<:Number}(x::T, y::T) = true
    same_type_numeric(x::Number, y::Number) = false

    julia> same_type_numeric(1, 2)
    true

    julia> same_type_numeric(1, 2.0)
    false

    julia> same_type_numeric(1.0, 2.0)
    true

    julia> same_type_numeric("foo", 2.0)
    no method same_type_numeric(ASCIIString,Float64)

    julia> same_type_numeric("foo", "bar")
    no method same_type_numeric(ASCIIString,ASCIIString)

    julia> same_type_numeric(int32(1), int64(2))
    false

``same_type_numeric`` 函数与 ``same_type`` 大致相同，但只应用于数对儿。

关于可选参数和关键字参数
------------------------

:ref:`man-functions` 中曾简略提到，可选参数是可由多方法定义语法的实现。例如： ::

    f(a=1,b=2) = a+2b

可以翻译为下面三个方法： ::

    f(a,b) = a+2b
    f(a) = f(a,2)
    f() = f(1,2)

关键字参数则与普通的与位置有关的参数不同。它们不用于方法重载。方法重载仅基于位置参数，选取了匹配的方法后，才处理关键字参数。
