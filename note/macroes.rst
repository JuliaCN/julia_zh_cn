.. _note-macroes:

****
 宏
****

在这儿列几个推荐的宏

@time
-----

@time 宏可打印出程序运行所需的时间。可用于单行表达式或代码块： ::

	julia> @time sqrtm( sum( randn(1000) ) )
	elapsed time: 0.0 seconds
	5.128676446664007
	
	julia> @time for i=1:1000
	                sqrtm(sum(randn(1000)))
	             end
	elapsed time: 0.04699993133544922 seconds
	
这个宏适合在优化代码等情况时使用。
	
@which
------

@which 宏可以显示对于指定的表达式，Julia调用的是哪个具体的方法来求值： ::

	julia> @which rand(1:10)
	rand{T<:Integer}(Range1{T<:Integer},) at random.jl:145
	
	julia> @which 1 + 2im
	+(Number,Number) at promotion.jl:135
	
	julia> a = [ 1 2 3 ; 4 5 6]
	2x3 Int32 Array:
	1  2  3
	4  5  6
	
	julia> @which a[2,3]
	ref(Array{T,N},Real,Real) at array.jl:246

这个宏比较方便 debug 时使用。
