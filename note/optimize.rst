*********
优化代码
*********

使用宏 ``@inbounds`` 加速循环
----------------------------
``@inbounds`` 以牺牲程序的安全性来大幅度加快循环的执行效率。 在对数组结构循环的时候，使用该宏需要确保程序的正确性。


节约空间
----------------------------
Julia提供了很多inplace的函数，合理地使用能够避免分配不必要的空间，从而减少gc的调用且节约了分配空间的时间。比如在数值上的共轭梯度法，其中的矩阵乘法可以使用 ``A_mul_B!`` 而不是 ``*(A,x)``, 这样避免了每次进入循环的时候分配新的空间 ::

	julia> A = rand(5000,5000); x = rand(5000); y = rand(5000);
	julia> @time y = A*x;
	elapsed time: 0.016998118 seconds (40168 bytes allocated)
	julia> @time A_mul_B!(y,A,x);
	elapsed time: 0.012711399 seconds (80 bytes allocated)

手动优化循环(manual loop unrolling)
-----------------------------------
手动地将循环平铺开能削减循环带来的overhead， 因为每次进入循环都会进行 ``end-of-loop`` 检测， 手动增加一些代码会加速循环的运行。缺点是会产生更多的代码，不够简洁，尤其是在循环内部调用inline函数，反而有可能降低性能。一个比较好的例子是 Julia 的sum函数。这里只做个简单的对比 ::

	function simple_sum(a::AbstractArray, first::Int, last::Int)
	    b = a[first];
	    for i = first + 1 : last
	        @inbounds b += a[i]
	    end
	    return b
	end
	
	function unroll_sum(a::AbstractArray, first::Int, last::Int)
	    @inbounds if ifirst + 6 >= ilast # length(a) < 8
	        i = ifirst
	        s =  a[i] + a[i+1]
	        i = i+1
	        while i < ilast
	            s +=a[i+=1]
	        end
	        return s

	    else # length(a) >= 8, manual unrolling
	        @inbounds s1 = a[ifirst] +  a[ifirst + 4]
	        @inbounds s2 = a[ifirst + 1] + a[ifirst + 5]
	        @inbounds s3 = a[ifirst + 2] +  a[ifirst + 6]
	        @inbounds s4 = a[ifirst + 3] +  a[ifirst + 7]
	        i = ifirst + 8
	        il = ilast - 3
	        while i <= il
	          @inbounds  s1 +=  a[i]
	          @inbounds  s2 += a[i+1]
	          @inbounds  s3 += a[i+2]
	          @inbounds  s4 += a[i+3]
	            i += 4
	        end
	        while i <= ilast
	          @inbounds  s1 += a[i]
	            i += 1
	        end
	        return s1 + s2 + s3 + s4
	    end
	end

运行结果如下 ::

	julia>rand_arr = rand(500000);
	julia>@time @inbounds ret_1 = simple_sum(rand_arr, 1, 500000)
	elapsed time: 0.000699786 seconds (160 bytes allocated)
	julia>@time @inbounds ret_2= unroll_sum(rand_arr,1,500000)
	elapsed time: 0.000383906 seconds (96 bytes allocated)
	
调用C或Fortran加速
----------------------------
尽管Julia声称速度和C相提并论，但是并不是所有的情况下都能有C的性能。合理地使用像LAPACK,BLAS,MUMPS这类已经高度优化的函数库有助于提升运行速度。



尽量使用一维数组
----------------------------
多维数组相当于多重指针，读取需要多次读地址，用一维数组能节约读取时间， 但注意一维数组的排列， Julia和MATLAB以及Fortran一样都是列优先储存。对于可以并行的一维数组操作，Julia提供了宏 ``@simd`` (0.3.0，可能会在以后版本中取消)。


良好的编程习惯
-----------------
这是对Julia官方手册的一句话总结，包括声明变量类型，保持函数的健壮性，循环前预分配空间等等。


