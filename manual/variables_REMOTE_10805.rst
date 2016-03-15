******
 变量
******

Julia 中，变量即是关联到某个值的名字。当你想存储一个值（比如数学计算中的某个中间变量）以备后用时，变量的作用就体现出来了。举个例子：

.. doctest::

    # Assign the value 10 to the variable x
    julia> x = 10 
    10
    
    # Doing math with x's value
    julia> x + 1
    11
    
    # Reassign x's value
    julia> x = 1 + 1 
    2
    
    # You can assign values of other types, like strings of text
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

Variable names must begin with a letter (A-Z or a-z), underscore, or a
subset of Unicode code points greater than 00A0; in particular, `Unicode character categories`_ Lu/Ll/Lt/Lm/Lo/Nl (letters), Sc/So (currency and
other symbols), and a few other letter-like characters (e.g. a subset
of the Sm math symbols) are allowed. Subsequent characters may also
include ! and digits (0-9 and other characters in categories Nd/No),
as well as other Unicode code points: diacritics and other modifying
marks (categories Mn/Mc/Me/Sk), some punctuation connectors (category
Pc), primes, and a few other characters.

.. _Unicode character categories: http://www.fileformat.info/info/unicode/category/index.htm

Operators like ``+`` are also valid identifiers, but are parsed specially. In
some contexts, operators can be used just like variables; for example
``(+)`` refers to the addition function, and ``(+) = f`` will reassign
it.  Most of the Unicode infix operators (in category Sm),
such as ``⊕``, are parsed as infix operators and are available for
user-defined methods (e.g. you can use ``const ⊗ = kron`` to define
``⊗`` as an infix Kronecker product).

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
