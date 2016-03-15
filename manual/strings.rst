.. _man-strings:

********
 字符串
********

Julia 中处理 `ASCII <http://zh.wikipedia.org/zh-cn/ASCII>`_ 文本简洁高效，也可以处理 `Unicode <http://zh.wikipedia.org/zh-cn/Unicode>`_ 。使用 C 风格的字符串代码来处理 ASCII 字符串，性能和语义都没问题。如果这种代码遇到非 ASCII 文本，会提示错误，而不是显示乱码。这时，修改代码以兼容非 ASCII 数据也很简单。

关于 Julia 字符串，有一些值得注意的高级特性：

-  ``AbstractString`` 是个抽象类型，不是具体类型——很多不同的表述都可以实现 ``AbstractString`` 的接口， 但他们很容易清晰地展示出相互关系并很容易的被一起使用。任何字符串类型的变量都可以传入一个在函数定义中声明了``AbstractString``类型的自变量。
- 和 C语言 以及Java 一样（但和大部分动态语言不同）， Julia 的 ``Char`` 类型代表单字符，是由 32 位整数表示的 Unicode 码位
-  与 Java 中一样，字符串不可更改： ``String`` 对象的值不能改变。要得到不同的字符串，需要构造新的字符串
-  概念上，字符串是从索引值映射到字符的 *部分函数* ，对某些索引值，如果不是字符，会抛出异常
-  Julia 支持全部 Unicode 字符: 文本字符通常都是 ASCII 或 `UTF-8 <http://zh.wikipedia.org/zh-cn/UTF-8>`_ 的，但也支持其它编码

.. _man-characters:

字符
----

``Char`` 表示单个字符：它是 32 位整数，值参见 `Unicode 码位 <http://zh.wikipedia.org/zh-cn/%E7%A0%81%E4%BD%8D>`_ 。 ``Char`` 必须使用单引号：

.. doctest::

    julia> 'x'
    'x'

    julia> typeof(ans)
    Char

可以把 ``Char`` 转换为对应整数值：

.. doctest::

    julia> int('x')
    120

    julia> typeof(ans)
    Int64

在 32 位架构上， ``typeof(ans)`` 的类型为 ``Int32`` 。也可以把整数值转换为 ``Char`` ：

.. doctest::

    julia> char(120)
    'x'

并非所有的整数值都是有效的 Unicode 码位，但为了性能， ``Char`` 一般不检查其是否有效。如果你想要确保其有效，使用 ``isvalid`` 函数：

.. doctest::

    julia> char(0x110000)
    '\U110000'

    julia> is_valid_char(0x110000)
    false

目前，有效的 Unicode 码位为，从 ``U+00`` 至 ``U+d7ff`` ，以及从 ``U+e000`` 至 ``U+10ffff`` 。

可以用单引号包住 ``\u`` 及跟着的最多四位十六进制数，或者 ``\U`` 及跟着的最多八位（有效的字符，最多需要六位）十六进制数，来输入 Unicode 字符：

.. doctest::

    julia> '\u0'
    '\0'

    julia> '\u78'
    'x'

    julia> '\u2200'
    '∀'

    julia> '\U10ffff'
    '\U10ffff'

Julia 使用系统默认的区域和语言设置来确定，哪些字符可以被正确显示，哪些需要用 ``\u`` 或 ``\U`` 的转义来显示。除 Unicode 转义格式之外，所有 `C 语言转义的输入格式 <http://en.wikipedia.org/wiki/C_syntax#Backslash_escapes>`_ 都能使：

.. doctest::

    julia> int('\0')
    0

    julia> int('\t')
    9

    julia> int('\n')
    10

    julia> int('\e')
    27

    julia> int('\x7f')
    127

    julia> int('\177')
    127

    julia> int('\xff')
    255

可以对 ``Char`` 值比较大小，也可以做少量算术运算：

.. doctest::

    julia> 'A' < 'a'
    true

    julia> 'A' <= 'a' <= 'Z'
    false

    julia> 'A' <= 'X' <= 'Z'
    true

    julia> 'x' - 'a'
    23

    julia> 'A' + 1
    'B'

字符串基础
----------

字符串文本应放在双引号 ``"..."`` 或三个双引号 ``"""..."""`` 中间：

.. doctest::

    julia> str = "Hello, world.\n"
    "Hello, world.\n"
    
    julia> """Contains "quote" characters"""
    "Contains \"quote\" characters"

使用索引从字符串提取字符：

.. doctest::

    julia> str[1]
    'H'

    julia> str[6]
    ','

    julia> str[end]
    '\n'

Julia 中的索引都是从 1 开始的，最后一个元素的索引与字符串长度相同，都是 ``n`` 。

在任何索引表达式中，关键词 ``end`` 都是最后一个索引值（由 ``endof(str)`` 计算得到）的缩写。可以对字符串做 ``end`` 算术或其它运算：

.. doctest::

    julia> str[end-1]
    '.'

    julia> str[end/2]
    ' '

    julia> str[end/3]
    ERROR: InexactError()
     in getindex at string.jl:59

    julia> str[end/4]
    ERROR: InexactError()
     in getindex at string.jl:59

索引小于 1 或者大于 ``end`` ，会提示错误： ::

    julia> str[0]
    ERROR: BoundsError()

    julia> str[end+1]
    ERROR: BoundsError()

使用范围索引来提取子字符串：

.. doctest::

    julia> str[4:9]
    "lo, wo"

``str[k]`` 和 ``str[k:k]`` 的结果不同：

.. doctest::

    julia> str[6]
    ','

    julia> str[6:6]
    ","

前者是类型为 ``Char`` 的单个字符，后者为仅有一个字符的字符串。在 Julia 中这两者完全不同。

Unicode 和 UTF-8
----------------

Julia 完整支持 Unicode 字符和字符串。正如 `上文所讨论的 <#characters>`_ ，在字符文本中， Unicode 码位可以由 ``\u`` 和 ``\U`` 来转义，也可以使用标准 C 的转义序列。它们都可以用来写字符串文本：

.. doctest::

    julia> s = "\u2200 x \u2203 y"
    "∀ x ∃ y"

非 ASCII 字符串文本使用 UTF-8 编码。 UTF-8 是一种变长编码，意味着并非所有的字符的编码长度都是相同的。在 UTF-8 中，码位低于 ``0x80 (128)`` 的字符即 ASCII 字符，编码如在 ASCII 中一样，使用单字节；其余码位的字符使用多字节，每字符最多四字节。这意味着 UTF-8 字符串中，并非所有的字节索引值都是有效的字符索引值。如果索引到无效的字节索引值，会抛出错误：

.. doctest::

    julia> s[1]
    '∀'

    julia> s[2]
    ERROR: invalid UTF-8 character index
     in next at ./utf8.jl:68
     in getindex at string.jl:57

    julia> s[3]
    ERROR: invalid UTF-8 character index
     in next at ./utf8.jl:68
     in getindex at string.jl:57

    julia> s[4]
    ' '

上例中，字符 ``∀`` 为 3 字节字符，所以索引值 2 和 3 是无效的，而下一个字符的索引值为 4。

由于变长编码，字符串的字符数（由 ``length(s)`` 确定）不一定等于字符串的最后索引值。对字符串 ``s`` 进行索引，并从 1 遍历至 ``endof(s)`` ，如果没有抛出异常，返回的字符序列将包括 ``s`` 的序列。因而 ``length(s) <= endof(s)`` 。下面是个低效率的遍历 ``s`` 字符的例子：

.. doctest::

    julia> for i = 1:endof(s)
             try
               println(s[i])
             catch
               # ignore the index error
             end
           end
    ∀
    <BLANKLINE>
    x
    <BLANKLINE>
    ∃
    <BLANKLINE>
    y

所幸我们可以把字符串作为遍历对象，而不需处理异常：

.. doctest::

    julia> for c in s
             println(c)
           end
    ∀
    <BLANKLINE>
    x
    <BLANKLINE>
    ∃
    <BLANKLINE>
    y

Julia 不只支持 UTF-8 ，增加其它编码的支持也很简单。In particular, Julia also provides
``UTF16String`` and ``UTF32String`` types, constructed by the
``utf16(s)`` and ``utf32(s)`` functions respectively, for UTF-16 and
UTF-32 encodings.  It also provides aliases ``WString`` and
``wstring(s)`` for either UTF-16 or UTF-32 strings, depending on the
size of ``Cwchar_t``. 有关 UTF-8 的讨论，详见下面的 `字节数组文本 <#byte-array-literals>`_ 。

.. _man-string-interpolation:

内插
----

字符串连接是最常用的操作：

.. doctest::

    julia> greet = "Hello"
    "Hello"

    julia> whom = "world"
    "world"

    julia> string(greet, ", ", whom, ".\n")
    "Hello, world.\n"

像 Perl 一样， Julia 允许使用 ``$`` 来内插字符串文本：

.. doctest::

    julia> "$greet, $whom.\n"
    "Hello, world.\n"

系统会将其重写为字符串文本连接。

``$`` 将其后的最短的完整表达式内插进字符串。可以使用小括号将任意表达式内插：

.. doctest::

    julia> "1 + 2 = $(1 + 2)"
    "1 + 2 = 3"

字符串连接和内插都调用 ``string`` 函数来把对象转换为 ``String`` 。与在交互式会话中一样，大多数非 ``String`` 对象被转换为字符串：

.. doctest::

    julia> v = [1,2,3]
    3-element Array{Int64,1}:
     1
     2
     3

    julia> "v: $v"
    "v: [1,2,3]"

``Char`` 值也可以被内插到字符串中：

.. doctest::

    julia> c = 'x'
    'x'

    julia> "hi, $c"
    "hi, x"

要在字符串文本中包含 ``$`` 文本，应使用反斜杠将其转义：

.. doctest::

    julia> print("I have \$100 in my account.\n")
    I have $100 in my account.

Triple-Quoted String Literals
-----------------------------

When strings are created using triple-quotes (``"""..."""``) they have some
special behavior that can be useful for creating longer blocks of text. First,
if the opening ``"""`` is followed by a newline, the newline is stripped from
the resulting string.

::

    """hello"""

is equivalent to

::

    """
    hello"""

but

::

    """

    hello"""

will contain a literal newline at the beginning. Trailing whitespace is left
unaltered. They can contain ``"`` symbols without escaping. Triple-quoted strings
are also dedented to the level of the least-indented line. This is useful for
defining strings within code that is indented. For example:

.. doctest::

    julia> str = """
               Hello,
               world.
             """
    "  Hello,\n  world.\n"

In this case the final (empty) line before the closing ``"""`` sets the
indentation level.

Note that line breaks in literal strings, whether single- or triple-quoted,
result in a newline (LF) character ``\n`` in the string, even if your
editor uses a carriage return ``\r`` (CR) or CRLF combination to end lines.
To include a CR in a string, use an explicit escape ``\r``; for example,
you can enter the literal string ``"a CRLF line ending\r\n"``.

一般操作
--------

使用标准比较运算符，按照字典顺序比较字符串：

.. doctest::

    julia> "abracadabra" < "xylophone"
    true

    julia> "abracadabra" == "xylophone"
    false

    julia> "Hello, world." != "Goodbye, world."
    true

    julia> "1 + 2 = 3" == "1 + 2 = $(1 + 2)"
    true

使用 ``search`` 函数查找某个字符的索引值：

.. doctest::

    julia> search("xylophone", 'x')
    1

    julia> search("xylophone", 'p')
    5

    julia> search("xylophone", 'z')
    0

可以通过提供第三个参数，从此偏移值开始查找：

.. doctest::

    julia> search("xylophone", 'o')
    4

    julia> search("xylophone", 'o', 5)
    7

    julia> search("xylophone", 'o', 8)
    0

另一个好用的处理字符串的函数 ``repeat`` ：

.. doctest::

    julia> repeat(".:Z:.", 10)
    ".:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:."

其它一些有用的函数：

-  ``endof(str)`` 给出 ``str`` 的最大（字节）索引值
-  ``length(str)`` 给出 ``str`` 的字符数
-  ``i = start(str)`` 给出第一个可在 ``str`` 中被找到的字符的有效索引值（一般为 1 ）
-  ``c, j = next(str,i)`` 返回索引值 ``i`` 处或之后的下一个字符，以及之后的下一个有效字符的索引值。通过 ``start`` 和 ``endof`` ，可以用来遍历 ``str`` 中的字符
-  ``ind2chr(str,i)`` 给出字符串中第 i 个索引值所在的字符，对应的是第几个字符
-  ``chr2ind(str,j)`` 给出字符串中索引为 i 的字符，对应的（第一个）字节的索引值

.. _man-non-standard-string-literals:

非标准字符串文本
----------------

Julia 提供了 :ref:`非标准字符串文本 <man-non-standard-string-literals2>` 。它在正常的双引号括起来的字符串文本上，添加了前缀标识符。下面将要介绍的正则表达式、字节数组文本和版本号文本，就是非标准字符串文本的例子。 :ref:`元编程 <man-non-standard-string-literals2>` 章节有另外的一些例子。

正则表达式
~~~~~~~~~~

Julia 的正则表达式 (regexp) 与 Perl 兼容，由 `PCRE <http://www.pcre.org/>`_ 库提供。它是一种非标准字符串文本，前缀为 ``r`` ，最后面可再跟一些标识符。最基础的正则表达式仅为 ``r"..."`` 的形式：

.. doctest::

    julia> r"^\s*(?:#|$)"
    r"^\s*(?:#|$)"

    julia> typeof(ans)
    Regex (constructor with 3 methods)

检查正则表达式是否匹配字符串，使用 ``ismatch`` 函数：

.. doctest::

    julia> ismatch(r"^\s*(?:#|$)", "not a comment")
    false

    julia> ismatch(r"^\s*(?:#|$)", "# a comment")
    true

``ismatch`` 根据正则表达式是否匹配字符串，返回真或假。 ``match`` 函数可以返回匹配的具体情况：

.. doctest::

    julia> match(r"^\s*(?:#|$)", "not a comment")

    julia> match(r"^\s*(?:#|$)", "# a comment")
    RegexMatch("#")

如果没有匹配， ``match`` 返回 ``nothing`` ，这个值不会在交互式会话中打印。除了不被打印，这个值完全可以在编程中正常使用： ::

    m = match(r"^\s*(?:#|$)", line)
    if m == nothing
      println("not a comment")
    else
      println("blank or comment")
    end

如果匹配成功， ``match`` 的返回值是一个 ``RegexMatch`` 对象。这个对象记录正则表达式是如何匹配的，包括类型匹配的子字符串，和其他捕获的子字符串。本例中仅捕获了匹配字符串的一部分，假如我们想要注释字符后的非空白开头的文本，可以这么写：

.. doctest::

    julia> m = match(r"^\s*(?:#\s*(.*?)\s*$|$)", "# a comment ")
    RegexMatch("# a comment ", 1="a comment")
    
When calling ``match``, you have the option to specify an index at
which to start the search. For example:

.. doctest::

   julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",1)
   RegexMatch("1")

   julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",6)
   RegexMatch("2")

   julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",11)
   RegexMatch("3")

可以在 ``RegexMatch`` 对象中提取下列信息：

-  完整匹配的子字符串： ``m.match``
-  捕获的子字符串组成的字符串多元组： ``m.captures``
-  完整匹配的起始偏移值： ``m.offset``
-  捕获的子字符串的偏移值向量： ``m.offsets``

对于没匹配的捕获， ``m.captures`` 的内容不是子字符串，而是 ``nothing`` ， ``m.offsets`` 为 0 偏移（ Julia 中的索引值都是从 1 开始的，因此 0 偏移值表示无效）： ::

    julia> m = match(r"(a|b)(c)?(d)", "acd")
    RegexMatch("acd", 1="a", 2="c", 3="d")

    julia> m.match
    "acd"

    julia> m.captures
    3-element Array{Union(SubString{UTF8String},Nothing),1}:
     "a"
     "c"
     "d"

    julia> m.offset
    1

    julia> m.offsets
    3-element Array{Int64,1}:
     1
     2
     3

    julia> m = match(r"(a|b)(c)?(d)", "ad")
    RegexMatch("ad", 1="a", 2=nothing, 3="d")

    julia> m.match
    "ad"

    julia> m.captures
    3-element Array{Union(SubString{UTF8String},Nothing),1}:
     "a"
     nothing
     "d"

    julia> m.offset
    1

    julia> m.offsets
    3-element Array{Int64,1}:
     1
     0
     2

可以把结果多元组绑定给本地变量： ::

    julia> first, second, third = m.captures; first
    "a"

可以在右引号之后，使用标识符 ``i``, ``m``, ``s``, 及 ``x`` 的组合，来修改正则表达式的行为。这几个标识符的用法与 Perl 中的一样，详见 `perlre
manpage <http://perldoc.perl.org/perlre.html#Modifiers>`_ ： ::


    i   不区分大小写

    m   多行匹配。 "^" 和 "$" 匹配多行的起始和结尾

    s   单行匹配。 "." 匹配所有字符，包括换行符

        一起使用时，例如 r""ms 中， "." 匹配任意字符，而 "^" 与 "$" 匹配字符串中新行之前和之后的字符

    x   忽略大多数空白，除非是反斜杠。可以使用这个标识符，把正则表达式分为可读的小段。 '#' 字符被认为是引入注释的元字符

例如，下面的正则表达式使用了所有选项：

.. doctest::

    julia> r"a+.*b+.*?d$"ism
    r"a+.*b+.*?d$"ims

    julia> match(r"a+.*b+.*?d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
    RegexMatch("angry,\nBad world")
    
Julia 支持三个双引号所引起来的正则表达式字符串，即 ``r"""..."""`` 。这种形式在正则表达式包含引号或换行符时比较有用。

... Triple-quoted regex strings, of the form ``r"""..."""``, are also
... supported (and may be convenient for regular expressions containing
... quotation marks or newlines).

.. _man-byte-array-literals:

字节数组文本
------------

另一类非标准字符串文本为 ``b"..."`` ，可以表示文本化的字节数组，如 ``Uint8`` 数组。习惯上，非标准文本的前缀为大写，会生成实际的字符串对象；而前缀为小写的，会生成非字符串对象，如字节数组或编译后的正则表达式。字节表达式的规则如下：

-  ASCII 字符与 ASCII 转义符生成一个单字节
-  ``\x`` 和 八进制转义序列生成对应转义值的 *字节*
-  Unicode 转义序列生成 UTF-8 码位的字节序列

三种情况都有的例子：

.. doctest::

    julia> b"DATA\xff\u2200"
    8-element Array{Uint8,1}:
     0x44
     0x41
     0x54
     0x41
     0xff
     0xe2
     0x88
     0x80

ASCII 字符串 "DATA" 对应于字节 68, 65, 84, 65 。 ``\xff`` 生成的单字节为 255 。Unicode 转义 ``\u2200`` 按 UTF-8 编码为三字节 226, 136, 128 。注意，字节数组的结果并不对应于一个有效的 UTF-8 字符串，如果把它当作普通的字符串文本，会得到语法错误：

.. doctest::

    julia> "DATA\xff\u2200"
    ERROR: syntax: invalid UTF-8 sequence

``\xff`` 和 ``\uff`` 也不同：前者是 *字节 255* 的转义序列；后者是 *码位 255* 的转义序列，将被 UTF-8 编码为两个字节：

.. doctest::

    julia> b"\xff"
    1-element Array{Uint8,1}:
     0xff

    julia> b"\uff"
    2-element Array{Uint8,1}:
     0xc3
     0xbf

在字符文本中，这两个是相同的。 ``\xff`` 也可以代表码位 255，因为字符 *永远* 代表码位。然而在字符串中， ``\x`` 转义永远表示字节而不是码位，而 ``\u`` 和 ``\U`` 转义永远表示码位，编码后为 1 或多个字节。


.. _man-version-number-literals:

Version Number Literals
-----------------------

Version numbers can easily be expressed with non-standard string literals of
the form ``v"..."``. Version number literals create :obj:`VersionNumber` objects
which follow the specifications of `semantic versioning <http://semver.org>`_,
and therefore are composed of major, minor and patch numeric values, followed
by pre-release and build alpha-numeric annotations. For example,
``v"0.2.1-rc1+win64"`` is broken into major version ``0``, minor version ``2``,
patch version ``1``, pre-release ``rc1`` and build ``win64``. When entering a
version literal, everything except the major version number is optional,
therefore e.g.  ``v"0.2"`` is equivalent to ``v"0.2.0"`` (with empty
pre-release/build annotations), ``v"2"`` is equivalent to ``v"2.0.0"``, and so
on.

:obj:`VersionNumber` objects are mostly useful to easily and correctly compare two
(or more) versions. For example, the constant ``VERSION`` holds Julia version
number as a :obj:`VersionNumber` object, and therefore one can define some
version-specific behavior using simple statements as::

    if v"0.2" <= VERSION < v"0.3-"
        # do something specific to 0.2 release series
    end

Note that in the above example the non-standard version number ``v"0.3-"`` is
used, with a trailing ``-``: this notation is a Julia extension of the
standard, and it's used to indicate a version which is lower than any ``0.3``
release, including all of its pre-releases. So in the above example the code
would only run with stable ``0.2`` versions, and exclude such versions as
``v"0.3.0-rc1"``. In order to also allow for unstable (i.e. pre-release)
``0.2`` versions, the lower bound check should be modified like this: ``v"0.2-"
<= VERSION``.

Another non-standard version specification extension allows one to use a trailing
``+`` to express an upper limit on build versions, e.g.  ``VERSION >
"v"0.2-rc1+"`` can be used to mean any version above ``0.2-rc1`` and any of its
builds: it will return ``false`` for version ``v"0.2-rc1+win64"`` and ``true``
for ``v"0.2-rc2"``.

It is good practice to use such special versions in comparisons (particularly,
the trailing ``-`` should always be used on upper bounds unless there's a good
reason not to), but they must not be used as the actual version number of
anything, as they are invalid in the semantic versioning scheme.

Besides being used for the :const:`VERSION` constant, :obj:`VersionNumber` objects are
widely used in the :mod:`Pkg <Base.Pkg>` module, to specify packages versions and their
dependencies.
