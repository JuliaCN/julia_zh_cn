:mod:`Base.Test` --- 与测试相关的例程
-------------------------------------

.. module:: Base.Test
    :synopsis: 测试和相关例程

`Test` 模块包含了一些与测试相关的函数和宏. 模块提供了运行测试的默认管理程序,
个人定制的管理程序可以通过函数 :func:`registerhandler` 提供.

概述
----

默认的管理程序, :func:`\@test`, 可以直接运行::

  # Julia code
  julia> @test 1 == 1

  julia> @test 1 == 0
  ERROR: test failed: :((1==0))
    in default_handle at test.jl:20
    in do_test at test.jl:37

  julia> @test error("This is what happens when a test fails")
  ERROR: test error during :(error("This is what happens when a fails"))
  This is what happens when a test fails
    in error at error.jl:21
    in anonymous at test.jl:62
    in do_test at test.jl:35

从上面的例子可以看到, 失败或错误都会导致程序打印导致问题表达式的抽象语法树.

另外一个宏, :func:`@test_fails`, 用以检查表达式是否抛出错误::

  julia> @test_fails error("An error")

  julia> @test_fails 1 == 1
  ERROR: test failed: :((1==1))
    in default_handler at test.jl:20
    in default_fails at test.jl:46

  julia> @test_fails 1 != 1
  ERROR: test failed: :((1!=1))
    in default_handler at test.jl:20
    in do_test_fails at test.jl:46

考虑到浮点数的比较可能不准确, 另有两个宏用于处理浮点数的微小误差::

  juila> @test_approx_eq 1. 0.999999999
  ERROR: assertion failed:. |1.0 - 0.999999999| < 2.220446049250313e-12
    1.0 = 1.0
    0.999999999 = 0.999999999
   in test_approx_eq at test.jl:75
   in test_approx_eq at test.jl:80

  julia> @test_approx_eq 1. 0.999 e-2

  julia> @test_approx_eq 1. 0.999 e-3
  ERROR: assertion failed: |1.0 - 0.999| < -0.2817181715409549
    1.0 = 1.0
    0.999 = 0.999
   in test_approx_eq at test.jl:75

管理程序
-------

一个管理程序可以接受三种不同的参数, `Success`, `Failure`, `Error`::

  # 默认管理程序的定义
  default_handler(r::Success) = nothing
  default_handler(r::Failure) = error("test failed: $(r.expr)")
  default_handler(r::Error) = rethrow(r)

在一个程序块内, 其它的管理程序也可以被使用(通过函数 :func:`withhandler`)::

  julia> handler(r::Success) = println("Success on $(r.expr)")
  # methods for generic function handler
  handler(r::Success) at none:1

  julia> handler(r::Failure) = error("Error on custom handler: $(r.expr)")
  # methods for generic function handler
  handler(r::Success) at none:1
  handler(r::Failure) at none:1

  julia> handler(r::Error) = rethrow(r)
  # methods for generic function handler
  handler(r::Success) at none:1
  handler(r::Failure) at none:1
  handler(r::Error) at none:1

  julia> withhandler(handler) do
           @test 1 == 1
           @test 1 != 1
         end
  Success on :((1==1))
  ERROR: Error on custom handler: :((1!=1))
    in handler at none:1
    in do_test at test.jl:38
    in anonymous at no file:3
    in withhandler at test.jl:57

或者重新定义全局的管理程序 (通过函数 :func:`registerhandler`)::

  julia> registerhander(handler)
  # methods for generic function handler
  handler(r::Success) at none:1
  handler(r::Failure) at none:1
  handler(r::Error) at none:1

  julia> @test 1 == 1
  Success on :((1==1))

宏
--

.. function:: @test ex

  测试表达式 `ex`, 然后调用当前管理程序处理结果.

.. function:: @test_fails ex

  测试表达式 `ex`, 然后调用当前管理程序依照下面的方式处理结果:

  * 如果测试没有抛出异常, 返回 `Failure`.
  * 如果测试抛出异常, 返回 `Success`.

.. function:: @test_approx_eq a b

  测试两个浮点数, `a` 和 `b`, 在考虑微小误差的情况下是否相等.

.. function:: @test_approx_eq a b c

  测试两个浮点数, `a` 和 `b`, 在考虑到最大误差 `c` 的情况下是否相等.

函数
----

.. function:: registerhandler(handler)

  修改全局管理函数为 `handler`

.. function:: withhandler(f, handler)

  使用 `hander` 当作管理函数来运行函数 `f`.
