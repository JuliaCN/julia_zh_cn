.. _man-variables-and-scoping:

**************
 变量的作用域
**************

变量的 *作用域* 是变量可见的区域。变量作用域能帮助避免变量命名冲突。

*作用域块* 是作为变量作用域的代码区域。变量的作用域被限制在这些块内部。作用域块有：

-  ``function`` 函数体（或 :ref:`语法 <man-functions>` ）
-  ``while`` 循环体
-  ``for`` 循环体
-  ``try`` 块
-  ``catch`` 块
-  ``let`` 块
-  ``type`` 块

注意 :ref:`begin 块 <man-compound-expressions>` *不能* 引入新作用域块。

当变量被引入到一个作用域中时，所有的内部作用域都继承了这个变量，除非某个内部作用域显式复写了它。将新变量引入当前作用域的方法：

-  声明 ``local x`` 或 ``const x`` ，可以引入新本地变量
-  声明 ``global x`` 使得 ``x`` 引入当前作用域和更内层的作用域
-  函数的参数，作为新变量被引入函数体的作用域
-  无论是在当前代码之前或 *之后* ， ``x = y`` 赋值都将引入新变量 ``x`` ，除非 ``x`` 已经在任何外层作用域内被声明为全局变量或被引入为本地变量

下面例子中，循环内部和外部，仅有一个 ``x`` 被赋值： ::

    function foo(n)
      x = 0
      for i = 1:n
        x = x + 1
      end
      x
    end

    julia> foo(10)
    10

下例中，循环体有一个独立的 ``x`` ，函数始终返回 0 ： ::

    function foo(n)
      x = 0
      for i = 1:n
        local x
        x = i
      end
      x
    end

    julia> foo(10)
    0

下例中， ``x`` 仅存在于循环体内部，因此函数在最后一行会遇到变量未定义的错误（除非 ``x`` 已经声明为全局变量）： ::

    function foo(n)
      for i = 1:n
        x = i
      end
      x
    end

    julia> foo(10)
    in foo: x not defined

在非顶层作用域给全局变量赋值的唯一方法，是在某个作用域中显式声明变量是全局的。否则，赋值会引入新的局部变量，而不是给全局变量赋值。

不必在内部使用前，就在外部赋值引入 ``x`` ： ::

    function foo(n)
      f = y -> n + x + y
      x = 1
      f(2)
    end

    julia> foo(10)
    13

上例看起来有点儿奇怪，但是并没有问题。因为在这儿是将一个函数绑定给变量。这使得我们可以按照任意顺序定义函数，不需要像 C 一样自底向上或者提前声明。这儿有个低效率的例子，互递归地验证一个正数的奇偶： ::

    even(n) = n == 0 ? true  :  odd(n-1)
    odd(n)  = n == 0 ? false : even(n-1)

    julia> even(3)
    false

    julia> odd(3)
    true

Julia 内置了高效的函数 ``iseven`` 和 ``isodd`` 来验证奇偶性。

由于函数可以先被调用再定义，因此不需要提前声明，定义的顺序也可以是任意的。

在交互式模式下，可以假想有一层作用域块包在任何输入之外，类似于全局作用域：

.. doctest::

    julia> for i = 1:1; y = 10; end

    julia> y
    ERROR: y not defined

    julia> y = 0
    0

    julia> for i = 1:1; y = 10; end

    julia> y
    10

前一个例子中， ``y`` 仅存在于 ``for`` 循环中。后一个例子中，外部声明的 ``y`` 被引入到循环中。由于会话的作用域与全局作用域差不多，因此在循环中不必声明 ``global y`` 。但是，不在交互式模式下运行的代码，必须声明全局变量。

使用以下的语法形式，可以将多个变量声明为全局变量::

    function foo()
        global x=1, y="bar", z=3
    end

    julia> foo()
    3

    julia> x
    1

    julia> y
    "bar"

    julia> z
    3

``let`` 语句提供了另一种引入变量的方法。 ``let`` 语句每次运行都会声明新变量。 ``let`` 语法接受由逗号隔开的赋值语句或者变量名： ::

    let var1 = value1, var2, var3 = value3
        code
    end

``let x = x`` 是合乎语法的，因为这两个 ``x`` 变量不同。它先对右边的求值，然后再引入左边的新变量并赋值。下面是个需要使用 ``let`` 的例子： ::

    Fs = cell(2)
    i = 1
    while i <= 2
      Fs[i] = ()->i
      i += 1
    end

    julia> Fs[1]()
    3

    julia> Fs[2]()
    3

两个闭包的返回值相同。如果用 ``let`` 来绑定变量 ``i`` ： ::

    Fs = cell(2)
    i = 1
    while i <= 2
      let i = i
        Fs[i] = ()->i
      end
      i += 1
    end

    julia> Fs[1]()
    1

    julia> Fs[2]()
    2

由于 ``begin`` 块并不引入新作用域块，使用 ``let`` 来引入新作用域块是很有用的：

.. doctest::

    julia> begin
             local x = 1
             begin
               local x = 2
             end
             x
           end
    ERROR: syntax: local "x" declared twice

    julia> begin
             local x = 1
             let
               local x = 2
             end
             x
           end
    1

第一个例子，不能在同一个作用域中声明同名本地变量。第二个例子， ``let`` 引入了新作用域块，内层的本地变量 ``x`` 与外层的本地变量 ``x`` 不同。

For 循环及 Comprehensions
----------------------------

For 循环及 :ref:`Comprehensions <comprehensions>` 有特殊的行为：在其中声明的新变量，都会在每次循环中重新声明。因此，它有点儿类似于带有内部 ``let`` 块的 ``while`` 循环： ::

    Fs = cell(2)
    for i = 1:2
        Fs[i] = ()->i
    end

    julia> Fs[1]()
    1

    julia> Fs[2]()
    2

``for`` 循环会复用已存在的变量来迭代： ::

    i = 0
    for i = 1:3
    end
    i  # here equal to 3

但是, comprehensions 与之不同，它总是声明新变量： ::

    x = 0
    [ x for x=1:3 ]
    x  # here still equal to 0

常量
----

``const`` 关键字告诉编译器要声明常量： ::

    const e  = 2.71828182845904523536
    const pi = 3.14159265358979323846

``const`` 可以声明全局常量和局部常量，最好用它来声明全局常量。全局变量的值（甚至类型）可能随时会改变，编译器很难对其进行优化。如果全局变量不改变的话，可以添加一个 ``const`` 声明来解决性能问题。

本地变量则不同。编译器能自动推断本地变量是否为常量，所以本地常量的声明不是必要的。

特殊的顶层赋值默认为常量，如使用 ``function`` 和 ``type`` 关键字的赋值。

注意 ``const`` 仅对变量的绑定有影响；变量有可能被绑定到可变对象（如数组），这个对象仍能被修改。
