******
 变量
******

Julia 中，变量即是关联到某个值的名字。当你想存储一个值（比如数学计算中的某个中间变量）以备后用时，变量的作用就体现出来了。举个例子：

.. doctest::

    # 将 整数 10 赋值给变量 x
    julia> x = 10 
    10
    
    # 对 x 所存储的值做数值运算
    julia> x + 1
    11
    
    # 重新定义 x 的值
    julia> x = 1 + 1 
    2

    # 你也可以给它赋予其它类型的值, 比如字符串    
    julia> x = "Hello World!"
    "Hello World!"

Julia 提供了极其灵活的变量命名系统。变量名区分大小写。

.. raw:: latex

    \begin{CJK*}{UTF8}{gbsn}

.. doctest::

    julia> x = 1.0
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


在 Julia REPL 和其它一些 Julia 的编辑环境中，支持 Unicode 数学符号
的输入。只需要键入对应的 LaTeX 语句，再按 tab 键即可完成输入。
比如，变量名 ``δ`` 可以通过 ``\delta``-*tab* 来输入，又如 ``α̂₂``可以由
``\alpha``-*tab*-``\hat``-*tab*-``\_2``-*tab* 来完成。

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
    
    julia> sqrt(100)
    10.0
    
    julia> sqrt = 4
	Warning: imported binding for sqrt overwritten in module Main
    4
    
很显然, 不鼓励这样的做法。

可用的变量名
============

变量名必须的开头必须是如下字符:

- 字母
- 比 00A0大的unicode 子集 具体是指, `Unicode character categories`_:
    + Lu/Ll/Lt/Lm/Lo/Nl(字母))开头
    + Sc/So(货币和其它符号)
    + 以及其它一些类似于字母的符号(比如 Sm 数学符号)

在变量名中的字符还可以包含 ! 和数字, 同时也可以是 Unicode 编码点: 变音符号 以及 其它 修饰符号, 一些标点连接符, 元素, 以及一些其它的字符.


.. _Unicode character categories: http://www.fileformat.info/info/unicode/category/index.htm

类似于 ``+`` 的运算符也是允许的标识符, 但会以其它方式解析. 在上下文中, 运算符会被类似于变量一样使用; 比如 ``(+)`` 代表了加法函数, 而 ``(+) = f`` 会重新给它赋值. 大部分的 Unicode 运算符,比如 ``⊕``, 会被当做运算符解析, 并且可以由用户来定义. 比如, 您可以使用 ``const ⊗ = kron`` 来定义 ``⊗``  为一个直乘运算符.

内置的关键字不能当变量名：

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
