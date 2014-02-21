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

这个宏比较方便 debug 时使用。比使用 :func:`which` 函数方便。

@printf
-------

@printf 宏用于输出指定格式的字符串，它区别于C里的printf函数，Julia的printf
对所要输出的内容会做相应的优化，使用上和C的printf的格式相差不大: ::

	julia> @printf("Hello World!")
	Hello World!
	
	julia> A = [1 2 3;4 5 6]
	2x3 Array{Int64,2}:
 	1  2  3
 	4  5  6
 	
 	julia> @printf("A has %d elements.",length(a))
	A has 6 elements.
	
	julia> @printf("sqrtm(2) is %4.2f.",sqrtm(2))
	sqrtm(2) is 1.41.


@inbounds
---------

@inbounds 宏作用主要是提高运行速度，不过它是以牺牲程序中数组的bound check为代价. 一般来说速度会有相当的提升: ::

	julia>  function f(x)
		N = div(length(x),3)
		r = 0.0
		for i = 1:N
		    for j = 1:N
			for k = 1: N
		            r += x[i+2*j]+x[j+2*k]+x[k+2*i]
			end
		    end
		end
		r
		end
	f (generic function with 1 method)

	julia>  function f1(x)
		N = div(length(x),3)
		r = 0.0
		for i = 1:N
		    for j = 1:N
			for k = 1: N
  			    @inbounds r += x[i+2*j]+x[j+2*k]+x[k+2*i]
			end
		    end
		end
		r
		end
	f1 (generic function with 1 method) 	
	
	julia> a = rand(2000);
	
	julia> @time f(a)
	elapsed time: 0.528003738 seconds (211264 bytes allocated)
	4.4966644948005027e8
	
	julia> @time f1(a)
	elapsed time: 0.307557441 seconds (64 bytes allocated)
	4.4966644948005027e8
	
