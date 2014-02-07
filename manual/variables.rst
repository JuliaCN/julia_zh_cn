******
 变量
******

Julia 提供了极其灵活的变量命名系统。变量名区分大小写。

.. raw:: latex

    \begin{CJK*}{UTF8}{gbsn}

.. doctest::

    julia> ix = 1.0
    1.0

    julia> y = -3
    -3

    julia> Z = "My string"
    "My string"

    julia> customary_phrase = "Hello world!"
    "Hello world!"

    julia> UniversalDeclarationOfHumanRightsStart = "人人生而自由，在尊严和权力上一律平等。"
    "人人生而自由，在尊严和权力上一律平等。"

.. raw:: latex

    \end{CJK*}

也可以使用 Unicode 字符（UTF-8 编码）来命名：

.. raw:: latex

    \begin{CJK*}{UTF8}{mj}

.. doctest::

    julia> δ = 0.00001
    1.0e-5

    julia> 안녕하세요 = "Hello" 
    "Hello"

.. raw:: latex

    \end{CJK*}

Julia 甚至允许重新定义内置的常数和函数：

.. doctest::

    julia> pi
    π = 3.1415926535897...
    
    julia> pi = 3
    Warning: imported binding for pi overwritten in module Main
    3
    
    julia> pi
    3
    
    julia> sqrt = 4
    4
    
很显然, 不鼓励这样的做法。

可用的变量名
============

变量名的第一个字符必须是字母 (A-Z 或 a-z) ，下划线，或者码位大于 00A0 的 Unicode 字符。后续的字符则可以增加 ! 和数字 (0-9) 。

运算符都是有效的标识符，但被特殊的解析。某些情况下，运算符可以像变量一样使；例如 ``(+)`` 是加法函数，但是可用 ``(+) = f`` 来重定义。

内置的关键字不能当变量名： ::

.. doctest::

    julia> else = false
    ERROR: syntax: unexpected "else"
    
    julia> try = "No"
    ERROR: syntax: unexpected "="

命名规范
========

尽管 Julia 对命名本身只有很少的限制, 但尽量遵循一定的命名规范吧：

- 变量名使用小写字母
- 单词间使用下划线 (``'_'``) 分隔，但不鼓励
- 类型名首字母大写, 单词间使用驼峰式分隔.
- 函数名和宏名使用小写字母, 不使用下划线分隔单词.
- 修改参数的函数结尾使用 ``!`` . 这样的函数被称为 mutating functions 或 in-place functions
