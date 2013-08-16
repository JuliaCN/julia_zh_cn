****
变量
****

Julia 提供了极其灵活的变量命名系统. 在 Julia 中, 全部字母大写和首字母大写没有
语法上特殊的意义. ::

    julia> ix = 1.0
    1.0

    julia> y = -3
    -3

    julia> Z = "My string"
    "My string"

    julia> customary_phase = "Hello world!"
    "Hello world"

    julia> BeginningOfTheUniversalDeclarationOfHumanRightsInChinese = "人人生而自由，在尊严和权力上一律平等。"
    "人人生而自由，在尊严和权力上一律平等。"

甚至可以使用 Unicode 字符作为变量名 ::

    julia> δ = 0.00001
    0.00001

    julia> 안녕하세요 = "Hello"
    "Hello"

Julia 甚至允许重定义内置的常量和函数, 如果需要的话 ::

    julia> pi
    3.141592653589793

    julia> pi = 3
    Warning: imported binding for pi overwritten in module Main
    3

    julia> pi
    3

    julia> sqrt = 4
    4

很显然, 不鼓励这样的做法.

然而, 内置语句禁止作为变量名 ::

    julia> else = false
    ERROR: syntax: unexpected else

    julia> try = "No"
    ERROR: syntax: unexpected =


命名规范
~~~~~~~~

尽管 Julia 对命名本身只有很少的限制, 遵循一定的命名规范会带来额外的好处.

- 变量名称使用小写字母, 单词间使用下划线 (``'\_'``) 分隔.
- 类型名称使用首字母大写, 单词间使用驼峰式分隔.
- 函数名和宏名使用小写字母, 不使用下划线分隔单词.
- 修改参数的函数结尾使用 ``!`` . 这样的函数被称为 mutating functions 或者
  in-place functions.
