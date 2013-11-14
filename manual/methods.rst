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

定义函数时，可以像 :ref:`man-composite-types` 中介绍的那样，使用 ``::`` 类型断言运算符，选择性地对参数类型进行限制： ::


    f(x::Float64, y::Float64) = 2x + y

此函数中参数 ``x`` 和 ``y`` 只能是 ``Float64`` 类型： ::

    julia> f(2.0, 3.0)
    7.0

如果参数是其它类型，会引发 “no method” 错误： ::

    julia> f(2.0, 3)
    no method f(Float64,Int64)

    julia> f(float32(2.0), 3.0)
    no method f(Float32,Float64)

    julia> f(2.0, "3.0")
    no method f(Float64,ASCIIString)

    julia> f("2.0", "3.0")
    no method f(ASCIIString,ASCIIString)

有时需要写一些通用方法，这时应声明参数为抽象类型： ::

    f(x::Number, y::Number) = 2x - y

    julia> f(2.0, 3)
    1.0

要想给一个函数定义多个方法，只需要多次定义这个函数，每次定义的参数个数和类型需不同。函数调用时，最匹配的方法被重载： ::

    julia> f(2.0, 3.0)
    7.0

    julia> f(2, 3.0)
    1.0

    julia> f(2.0, 3)
    1.0

    julia> f(2, 3)
    1

对非数值的值，或参数个数少于 2 ， ``f`` 是未定义的，调用它会返回 “no method” 错误::

    julia> f("foo", 3)
    no method f(ASCIIString,Int64)

    julia> f()
    no method f()

在交互式会话中输入函数对象本身，可以看到函数所存在的方法： ::

    julia> f
    Methods for generic function f
    f(Float64,Float64)
    f(Number,Number)

定义类型时如果没使用 ``::`` ，则方法参数的类型默认为 ``Any`` 。对 ``f`` 定义一个总括匹配的方法： ::

    julia> f(x,y) = println("Whoa there, Nelly.")

    julia> f("foo", 1)
    Whoa there, Nelly.

总括匹配的方法，是重载时的最后选择。

重载是 Julia 最强大最核心的特性。核心运算一般都有好几十种方法： ::

    julia> methods(+)
    # 92 methods for generic function "+":
    +(x::Bool,y::Bool) at bool.jl:38
    +(x::Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)}),y::Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)})) at array.jl:982
    +{S,T}(A::Union(Array{S,N},SubArray{S,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)}),B::Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)})) at array.jl:926
    +{T<:Union(Int16,Int8,Int32)}(x::T<:Union(Int16,Int8,Int32),y::T<:Union(Int16,Int8,Int32)) at int.jl:16
    +{T<:Union(Uint16,Uint8,Uint32)}(x::T<:Union(Uint16,Uint8,Uint32),y::T<:Union(Uint16,Uint8,Uint32)) at int.jl:20
    +(x::Int64,y::Int64) at int.jl:41
    +(x::Uint64,y::Uint64) at int.jl:42
    +(x::Int128,y::Int128) at int.jl:43
    +(x::Uint128,y::Uint128) at int.jl:44
    +(a::Float16,b::Float16) at float.jl:129
    +(x::Float32,y::Float32) at float.jl:131
    +(x::Float64,y::Float64) at float.jl:132
    +(z::Complex{T<:Real},w::Complex{T<:Real}) at complex.jl:132
    +(x::Real,z::Complex{T<:Real}) at complex.jl:140
    +(z::Complex{T<:Real},x::Real) at complex.jl:141
    +(x::Rational{T<:Integer},y::Rational{T<:Integer}) at rational.jl:113
    +(x::Bool,y::Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)})) at array.jl:976
    +(x::Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)}),y::Bool) at array.jl:979
    +(x::Char,y::Char) at char.jl:25
    +(x::Char,y::Integer) at char.jl:30
    +(x::Integer,y::Char) at char.jl:31
    +(x::BigInt,y::BigInt) at gmp.jl:159
    +(x::BigInt,c::Uint64) at gmp.jl:195
    +(c::Uint64,x::BigInt) at gmp.jl:199
    +(c::Unsigned,x::BigInt) at gmp.jl:200
    +(x::BigInt,c::Unsigned) at gmp.jl:201
    +(x::BigInt,c::Signed) at gmp.jl:202
    +(c::Signed,x::BigInt) at gmp.jl:203
    +(x::BigFloat,c::Uint64) at mpfr.jl:141
    +(c::Uint64,x::BigFloat) at mpfr.jl:145
    +(c::Unsigned,x::BigFloat) at mpfr.jl:146
    +(x::BigFloat,c::Unsigned) at mpfr.jl:147
    +(x::BigFloat,c::Int64) at mpfr.jl:151
    +(c::Int64,x::BigFloat) at mpfr.jl:155
    +(x::BigFloat,c::Signed) at mpfr.jl:156
    +(c::Signed,x::BigFloat) at mpfr.jl:157
    +(x::BigFloat,c::Float64) at mpfr.jl:161
    +(c::Float64,x::BigFloat) at mpfr.jl:165
    +(c::Float32,x::BigFloat) at mpfr.jl:166
    +(x::BigFloat,c::Float32) at mpfr.jl:167
    +(x::BigFloat,c::BigInt) at mpfr.jl:171
    +(c::BigInt,x::BigFloat) at mpfr.jl:175
    +(x::BigFloat,y::BigFloat) at mpfr.jl:322
    +(x::MathConst{sym},y::MathConst{sym}) at constants.jl:28
    +{T<:Number}(x::T<:Number,y::T<:Number) at promotion.jl:178
    +(x::Number,y::Number) at promotion.jl:148
    +(x::Real,r::Range{T<:Real}) at range.jl:282
    +(x::Real,r::Range1{T<:Real}) at range.jl:283
    +(r::Ranges{T},x::Real) at range.jl:284
    +(r1::Ranges{T},r2::Ranges{T}) at range.jl:296
    +(x::Bool) at bool.jl:35
    +() at operators.jl:50
    +(x::Number) at operators.jl:56
    +(a::BigInt,b::BigInt,c::BigInt) at gmp.jl:170
    +(a::BigFloat,b::BigFloat,c::BigFloat) at mpfr.jl:333
    +(a,b,c) at operators.jl:67
    +(a::BigInt,b::BigInt,c::BigInt,d::BigInt) at gmp.jl:176
    +(a::BigInt,b::BigInt,c::BigInt,d::BigInt,e::BigInt) at gmp.jl:183
    +(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat) at mpfr.jl:339
    +(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat,e::BigFloat) at mpfr.jl:346
    +(a,b,c,xs...) at operators.jl:68
    +(x::Ptr{T},y::Integer) at pointer.jl:59
    +(x::Integer,y::Ptr{T}) at pointer.jl:61
    +{T<:Number}(x::AbstractArray{T<:Number,N}) at abstractarray.jl:334
    +{T}(A::Number,B::Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)})) at array.jl:937
    +{T}(A::Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)}),B::Number) at array.jl:944
    +{S,T<:Real}(A::Union(Array{S,N},SubArray{S,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)}),B::Ranges{T<:Real}) at array.jl:952
    +{S<:Real,T}(A::Ranges{S<:Real},B::Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Range1{Int64},Int64,Range{Int64})...,)})) at array.jl:961
    +(A::BitArray{N},B::BitArray{N}) at bitarray.jl:1143
    +(B::BitArray{N},x::Bool) at bitarray.jl:1147
    +(B::BitArray{N},x::Number) at bitarray.jl:1150
    +(x::Bool,B::BitArray{N}) at bitarray.jl:1154
    +(x::Number,B::BitArray{N}) at bitarray.jl:1157
    +(A::BitArray{N},B::AbstractArray{T,N}) at bitarray.jl:1395
    +(A::AbstractArray{T,N},B::BitArray{N}) at bitarray.jl:1396
    +{Tv,Ti}(A::SparseMatrixCSC{Tv,Ti},B::SparseMatrixCSC{Tv,Ti}) at sparse/sparsematrix.jl:409
    +{TvA,TiA,TvB,TiB}(A::SparseMatrixCSC{TvA,TiA},B::SparseMatrixCSC{TvB,TiB}) at sparse/sparsematrix.jl:401
    +(A::SparseMatrixCSC{Tv,Ti<:Integer},B::Union(Array{T,N},Number)) at sparse/sparsematrix.jl:503
    +(A::Union(Array{T,N},Number),B::SparseMatrixCSC{Tv,Ti<:Integer}) at sparse/sparsematrix.jl:504
    +(A::SymTridiagonal{T<:Union(Complex{Float64},Float32,Float64,Complex{Float32})},B::SymTridiagonal{T<:Union(Complex{Float64},Float32,Float64,Complex{Float32})}) at linalg/tridiag.jl:50
    +(A::Tridiagonal{T},B::Tridiagonal{T}) at linalg/tridiag.jl:151
    +(A::Tridiagonal{T},B::SymTridiagonal{T<:Union(Complex{Float64},Float32,Float64,Complex{Float32})}) at linalg/tridiag.jl:164
    +(A::SymTridiagonal{T<:Union(Complex{Float64},Float32,Float64,Complex{Float32})},B::Tridiagonal{T}) at linalg/tridiag.jl:165
    +(A::Bidiagonal{T},B::Bidiagonal{T}) at linalg/bidiag.jl:76
    +(Da::Diagonal{T},Db::Diagonal{T}) at linalg/diagonal.jl:28
    +{T}(a::HierarchicalValue{T},b::HierarchicalValue{T}) at pkg/resolve/versionweight.jl:19
    +(a::VWPreBuildItem,b::VWPreBuildItem) at pkg/resolve/versionweight.jl:82
    +(a::VWPreBuild,b::VWPreBuild) at pkg/resolve/versionweight.jl:120
    +(a::VersionWeight,b::VersionWeight) at pkg/resolve/versionweight.jl:164
    +(a::FieldValue,b::FieldValue) at pkg/resolve/fieldvalue.jl:41
    +(a::Vec2,b::Vec2) at graphics.jl:62
    +(bb1::BoundingBox,bb2::BoundingBox) at graphics.jl:128

重载和灵活的参数化类型系统一起，使得 Julia 可以抽象表达高级算法，不许关注实现的具体细节，生成有效率、运行时专用的代码。

方法歧义
--------

函数方法的适用范围可能会重叠： ::

    julia> g(x::Float64, y) = 2x + y

    julia> g(x, y::Float64) = x + 2y
    Warning: New definition g(Any,Float64) is ambiguous with g(Float64,Any).
             To fix, define g(Float64,Float64) before the new definition.

    julia> g(2.0, 3)
    7.0

    julia> g(2, 3.0)
    8.0

    julia> g(2.0, 3.0)
    7.0

此处 ``g(2.0, 3.0)`` 既可以调用 ``g(Float64, Any)`` ，也可以调用 ``g(Any, Float64)`` ，两种方法没有优先级。遇到这种情况，Julia会警告定义含糊，但仍会任选一个方法来继续执行。应避免含糊的方法： ::

    julia> g(x::Float64, y::Float64) = 2x + 2y

    julia> g(x::Float64, y) = 2x + y

    julia> g(x, y::Float64) = x + 2y

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

构造参数化方法，应在方法名与参数多元组之间，添加类型参数： ::

    same_type{T}(x::T, y::T) = true
    same_type(x,y) = false

这两个方法定义了一个布尔函数，它检查两个参数是否为同一类型： ::

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

类型参数可用于函数定义或函数体的任何地方： ::

    julia> myappend{T}(v::Vector{T}, x::T) = [v..., x]

    julia> myappend([1,2,3],4)
    4-element Int64 Array:
    1
    2
    3
    4

    julia> myappend([1,2,3],2.5)
    no method myappend(Array{Int64,1},Float64)

    julia> myappend([1.0,2.0,3.0],4.0)
    [1.0,2.0,3.0,4.0]

    julia> myappend([1.0,2.0,3.0],4)
    no method myappend(Array{Float64,1},Int64)

下例中，方法类型参数 ``T`` 被用作返回值： ::

    julia> mytypeof{T}(x::T) = T

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
