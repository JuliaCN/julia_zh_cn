.. _man-methods:

******
 方法  
******

:ref:`man-functions` 中说到，函数是从参数多元组映射到返回值的对象，若没有合适返回值则抛出异常。实际中常需要对不同类型的参数做同样的运算，例如对整数做加法、对浮点数做加法、对整数与浮点数做加法，它们都是加法。在 Julia 中，它们都属于同一对象： ``+`` 函数。

对同一概念做一系列实现时，可以逐一定义特定参数类型、个数所对应的特定函数行为。 *方法* 对函数中某一特定的行为定义。函数中可以定义多个方法。对一个特定的参数多元组调用函数时，最匹配此参数多元组的方法被调用。

函数调用时，选取调用哪个方法，被称为 `重载 <http://en.wikipedia.org/wiki/Multiple_dispatch>`_ 。Julia 依据参数个数、类型来进行重载。

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

    julia> +
    Methods for generic function +
    +(Real,Range{T<:Real}) at range.jl:136
    +(Real,Range1{T<:Real}) at range.jl:137
    +(Ranges{T<:Real},Real) at range.jl:138
    +(Ranges{T<:Real},Ranges{T<:Real}) at range.jl:150
    +(Bool,) at bool.jl:45
    +(Bool,Bool) at bool.jl:48
    +(Int64,Int64) at int.jl:224
    +(Int128,Int128) at int.jl:226
    +(Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)}),Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)})) at array.jl:902
    +{T<:Signed}(T<:Signed,T<:Signed) at int.jl:207
    +(Uint64,Uint64) at int.jl:225
    +(Uint128,Uint128) at int.jl:227
    +{T<:Unsigned}(T<:Unsigned,T<:Unsigned) at int.jl:211
    +(Float32,Float32) at float.jl:113
    +(Float64,Float64) at float.jl:114
    +(Complex{T<:Real},Complex{T<:Real}) at complex.jl:207
    +(Rational{T<:Integer},Rational{T<:Integer}) at rational.jl:101
    +(Bool,Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)})) at array.jl:896
    +(Union(Array{Bool,N},SubArray{Bool,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)}),Bool) at array.jl:899
    +(Char,Char) at char.jl:46
    +(Char,Int64) at char.jl:47
    +(Int64,Char) at char.jl:48
    +{T<:Number}(T<:Number,T<:Number) at promotion.jl:68
    +(Number,Number) at promotion.jl:40
    +() at operators.jl:30
    +(Number,) at operators.jl:36
    +(Any,Any,Any) at operators.jl:44
    +(Any,Any,Any,Any) at operators.jl:45
    +(Any,Any,Any,Any,Any) at operators.jl:46
    +(Any,Any,Any,Any...) at operators.jl:48
    +{T}(Ptr{T},Integer) at pointer.jl:52
    +(Integer,Ptr{T}) at pointer.jl:54
    +{T<:Number}(AbstractArray{T<:Number,N},) at abstractarray.jl:232
    +{S,T}(Union(Array{S,N},SubArray{S,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)}),Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)})) at array.jl:850
    +{T}(Number,Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)})) at array.jl:857
    +{T}(Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)}),Number) at array.jl:864
    +{S,T<:Real}(Union(Array{S,N},SubArray{S,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)}),Ranges{T<:Real}) at array.jl:872
    +{S<:Real,T}(Ranges{S<:Real},Union(Array{T,N},SubArray{T,N,A<:Array{T,N},I<:(Union(Int64,Range1{Int64},Range{Int64})...,)})) at array.jl:881
    +(BitArray{N},BitArray{N}) at bitarray.jl:922
    +(BitArray{N},Number) at bitarray.jl:923
    +(Number,BitArray{N}) at bitarray.jl:924
    +(BitArray{N},AbstractArray{T,N}) at bitarray.jl:986
    +(AbstractArray{T,N},BitArray{N}) at bitarray.jl:987
    +{Tv,Ti}(SparseMatrixCSC{Tv,Ti},SparseMatrixCSC{Tv,Ti}) at sparse.jl:536
    +(SparseMatrixCSC{Tv,Ti<:Integer},Union(Array{T,N},Number)) at sparse.jl:626
    +(Union(Array{T,N},Number),SparseMatrixCSC{Tv,Ti<:Integer}) at sparse.jl:627

重载和灵活的参数化类型系统一起，使得 Julia 可以抽象表达高级算法，不许关注实现的具体细节，生成有效率、运行时专用的代码。

方法歧义
--------

函数方法的适用范围可能会重叠： ::

    julia> g(x::Float64, y) = 2x + y

    julia> g(x, y::Float64) = x + 2y
    Warning: New definition g(Any,Float64) is ambiguous with g(Float64,Any).
             Make sure g(Float64,Float64) is defined first.

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

Note on Optional and Named Arguments
------------------------------------

As mentioned briefly in :ref:`man-functions`, optional arguments are
implemented as syntax for multiple method definitions. For example,
this definition::

    f(a=1,b=2) = a+2b

translates to the following three methods:

    f(a,b) = a+2b
    f(a) = f(a,2)
    f() = f(1,2)

Named arguments behave quite differently from ordinary positional arguments.
In particular, they do not participate in method dispatch. Methods are
dispatched based only on positional arguments, with named arguments processed
after the matching method is identified.
