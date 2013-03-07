# automatically generated -- do not edit

{

(E"ArgParse",E"ArgParse",E"parse_args",E"parse_args([args], settings)

   This is the central function of the \"ArgParse\" module. It takes a
   \"Vector\" of arguments and an \"ArgParseSettings\" objects (see
   *this section*), and returns a \"Dict{String,Any}\". If \"args\" is
   not provided, the global variable \"ARGS\" will be used.

   The returned \"Dict\" keys are defined (possibly implicitly) in
   \"settings\", and their associated values are parsed from \"args\".
   Special keys are used for more advanced purposes; at the moment,
   one such key exists: \"%COMMAND%\" (see *this section*).

   Arguments are parsed in sequence and matched against the argument
   table in \"settings\" to determine whether they are long options,
   short options, option arguments or positional arguments:

   * long options begin with a doule dash \"\"--\"\"; if a \"'='\"
     character is found, the remainder is the option argument;
     therefore, \"[\"--opt=arg\"]\" and \"[\"--opt\", \"arg\"]\" are
     equivalent if \"--opt\" takes at least one argument. Long options
     can be abbreviated (e.g. \"--opt\" instead of \"--option\") as
     long as there is no ambiguity.

   * short options begin with a single dash \"\"-\"\" and their name
     consists of a single character; they can be grouped togheter
     (e.g. \"[\"-x\", \"-y\"]\" can become \"[\"-xy\"]\"), but in that
     case only the last option in the group can take an argument
     (which can also be grouped, e.g. \"[\"-a\", \"-f\",
     \"file.txt\"]\" can be passed as \"[\"-affile.txt\"]\" if \"-a\"
     does not take an argument and \"-f\" does). The \"'='\" character
     can be used to separate option names from option arguments as
     well (e.g. \"-af=file.txt\").

   * positional arguments are anything else; they can appear anywhere.

   The special string \"\"--\"\" can be used to signal the end of all
   options; after that, everything is considered as a positional
   argument (e.g. if \"args = [\"--opt1\", \"--\", \"--opt2\"]\", the
   parser will recognize \"--opt1\" as a long option without argument,
   and \"--opt2\" as a positional argument).

   The special string \"\"-\"\" is always parsed as a positional
   argument.

   The parsing can stop early if a \":show_help\" or \":show_version\"
   action is triggered, or if a parsing error is found.

   Some ambiguities can arise in parsing, see *this section* for a
   detailed description of how they're solved.

"),

(E"ArgParse",E"ArgParse",E"@add_arg_table",E"@add_arg_table(settings, table...)

   This macro adds a table of arguments and options to the given
   \"settings\". It can be invoked multiple times. The arguments
   groups are determined automatically, or the current default group
   is used if specified (see *this section* for more details).

   The \"table\" is a list in which each element can be either
   \"String\", or a tuple or a vector of \"String\", or an assigmment
   expression, or a block:

   * a \"String\", a tuple or a vector introduces a new positional
     argument or option. Tuples and vectors are only allowed for
     options and provide alternative names (e.g. \"[\"--opt\",
     \"-o\"]\")

   * assignment expressions (i.e. expressions using \"=\", \":=\" or
     \"=>\") describe the previous argument behavior (e.g. \"help =
     \"an option\"\" or \"required => false\").  See *this section*
     for a complete description

   * blocks (\"begin...end\" or lists of expressions in parentheses
     separated by semicolons) are useful to group entries and span
     multiple lines.

   These rules allow for a variety usage styles, which are discussed
   in *this section*. In the rest of this document, we will mostly use
   this style:

      @add_arg_table settings begin
          \"--opt1\", \"-o\"
              help = \"an option with an argument\"
          \"--opt2\"
          \"arg1\"
              help = \"a positional argument\"
              required = true
      end

   In the above example, the \"table\" is put in a single
   \"begin...end\" block and the line \"\"-opt1\", \"-o\"\" is parsed
   as a tuple; indentation is used to help readability.

"),

(E"ArgParse",E"ArgParse",E"add_arg_table",E"add_arg_table(settings, [arg_name [,arg_options]]...)

   This function is almost equivalent to the macro version. Its syntax
   is stricter (tuples and blocks are not allowed and argument options
   are explicitly specified as \"Options\" objects) but the
   \"arg_name\" entries need not be explicit, they can be anything
   which evaluates to a \"String\" or a \"Vector{String}\".

   Example:

      add_arg_table(settings,
          [\"--opt1\", \"-o\"],
          @options begin
              help = \"an option with an argument\"
          end,
          \"--opt2\",
          \"arg1\",
          @options begin
              help = \"a positional argument\"
              required = true
          end)

   Note that the \"OptionsMod\" module must be imported in order to
   use this function.

"),

(E"ArgParse",E"ArgParse",E"add_arg_group",E"add_arg_group(settings, description[, name[, set_as_default]])

   This function adds an argument group to the argument table in
   \"settings\". The \"description\" is a \"String\" used in the help
   screen as a title for that group. The \"name\" is a unique name
   which can be provided to refer to that group at a later time.

   After invoking this function, all subsequent invocations of the
   \"@add_arg_table\" macro and \"add_arg_table\" function will use
   the new group as the default, unless \"set_as_default\" is set to
   \"false\" (the default is \"true\", and the option can only be set
   if providing a \"name\"). Therefore, the most obvious usage pattern
   is: for each group, add it and populate the argument table of that
   group. Example:

      julia> settings = ArgParseSettings();

      julia> add_arg_group(settings, \"custom group\");

      julia> @add_arg_table settings begin
                \"--opt\"
                \"arg\"
             end;

      julia> parse_args([\"--help\"], settings)
      usage: <command> [--opt OPT] [-h] [arg]

      optional arguments:
        -h, --help  show this help message and exit

      custom group:
        --opt OPT
        arg

   As seen from the example, new groups are always added at the end of
   existing ones.

   The \"name\" can also be passed as a \"Symbol\". Forbidden names
   are the standard groups names (\"\"command\"\", \"\"positional\"\"
   and \"\"optional\"\") and those beginning with a hash character
   \"'#'\".

"),

(E"ArgParse",E"ArgParse",E"set_default_arg_group",E"set_default_arg_group(settings[, name])

   Set the default group for subsequent invocations of the
   \"@add_arg_table\" macro and \"add_arg_table\" function. \"name\"
   is a \"String\", and must be one of the standard group names
   (\"\"command\"\", \"\"positional\"\" or \"\"optional\"\") or one of
   the user-defined names given in \"add_arg_group\" (groups with no
   assigned name cannot be used with this function).

   If \"name\" is not provided or is the empty string \"\"\"\", then
   the default behavior is reset (i.e. arguments will be automatically
   assigned to the standard groups). The \"name\" can also be passed
   as a \"Symbol\".

"),

(E"ArgParse",E"ArgParse",E"import_settings",E"import_settings(settings, other_settings[, args_only])

   Imports \"other_settings\" into \"settings\", where both are
   \"ArgParseSettings\" objects. If \"args_only\" is \"true\" (this is
   the default), only the argument table will be imported; otherwise,
   the default argument group will also be imported, and all general
   settings except \"prog\", \"description\", \"epilog\" and
   \"usage\".

   Sub-settings associated with commands will also be imported
   recursively; the \"args_only\" setting applies to those as well. If
   there are common commands, their sub-settings will be merged.

   While importing, conflicts may arise: if
   \"settings.error_on_conflict\" is \"true\", this will result in an
   error, otherwise conflicts will be resolved in favor of
   \"other_settings\" (see *this section* for a detailed discussion of
   how conflicts are handled).

   Argument groups will also be imported; if two groups in
   \"settings\" and \"other_settings\" match, they are merged (groups
   match either by name, or, if unnamed, by their description).

   Note that the import will have effect immediately: any subsequent
   modification of \"other_settings\" will not have any effect on
   \"settings\".

   This function can be used at any time.

"),

(E"杂项",E"Base",E"exit",E"exit([code])

   退出（或在会话中按下 control-D ）。默认退出代码为 0 ，表示进程正常结束。

"),

(E"杂项",E"Base",E"whos",E"whos([Module,] [pattern::Regex])

   打印模块中全局变量的信息，可选择性地限制打印匹配 \"pattern\" 的变量。

"),

(E"杂项",E"Base",E"edit",E"edit(file::String[, line])

   编辑文件；可选择性地提供要编辑的行号。退出编辑器后返回 Julia 会话。如果文件后缀名为 \".jl\" ，关闭文件后会重载该文件。

"),

(E"杂项",E"Base",E"edit",E"edit(function[, types])

   编辑函数定义，可选择性地提供一个类型多元组以指明要编辑哪个方法。退出编辑器后，包含定义的源文件会被重载。

"),

(E"杂项",E"Base",E"require",E"require(file::String...)

   在 \"Main\" 模块的上下文中，对每个活动的节点，通过系统的 \"LOAD_PATH\"
   查找文件，并只载入一次。``require`` 是顶层操作，因此它设置当前的 \"include\"
   路径，但并不使用它来查找文件（参见 \"include\" 的帮助）。此函数常用来载入库代码； \"using\"
   函数隐含使用它来载入扩展包。

"),

(E"杂项",E"Base",E"reload",E"reload(file::String)

   类似 \"require\" ，但不管是否曾载入过，都要载入文件。常在交互式地开发库时使用。

"),

(E"杂项",E"Base",E"include",E"include(path::String)

   在当前上下文中，对源文件的内容求值。在包含的过程中，它将本地任务包含路径设置为包含文件的文件夹。嵌套调用 \"include\"
   时会搜索那个路径的相关的路径。并行运行时，所有的路径都指向节点 1 上文件，并从节点 1
   上获取文件。此函数常用来交互式地载入源文件，或将分散为多个源文件的扩展包结合起来。

"),

(E"杂项",E"Base",E"include_string",E"include_string(code::String)

   类似 \"include\" ，但它从指定的字符串读取代码，而不是从文件中。由于没有涉及到文件路径，不会进行路径处理或从节点 1
   获取文件。

"),

(E"杂项",E"Base",E"evalfile",E"evalfile(path::String)

   对指定文件的所有表达式求值，并返回最后一个表达式的值。不会进行其他处理（搜索路径，从节点 1 获取文件等）。

"),

(E"杂项",E"Base",E"help",E"help(name)

   获得函数帮助。 \"name\" 可以是对象或字符串。

"),

(E"杂项",E"Base",E"apropos",E"apropos(string)

   查询文档中与 \"string\" 相关的函数。

"),

(E"杂项",E"Base",E"which",E"which(f, args...)

   对指定的参数，显示应调用 \"f\" 的哪个方法。

"),

(E"杂项",E"Base",E"methods",E"methods(f)

   显示 \"f\" 的所有方法及其对应的参数类型。

"),

(E"杂项",E"Base",E"methodswith",E"methodswith(t)

   显示 \"t\" 类型的所有方法。

"),

(E"所有对象",E"Base",E"is",E"is(x, y)

   判断 \"x\" 与 \"y\" 是否相同，依据为程序不能区分它们。

"),

(E"所有对象",E"Base",E"isa",E"isa(x, type)

   判断 \"x\" 是否为指定类型。

"),

(E"所有对象",E"Base",E"isequal",E"isequal(x, y)

   当且仅当 \"x\" 和 \"y\" 内容相同是为真。粗略地说，即打印出来的 \"x\" 和 \"y\" 看起来一模一样。

"),

(E"所有对象",E"Base",E"isless",E"isless(x, y)

   判断 \"x\" 是否比 \"y\" 小。它具有与 \"isequal\" 一致的整体排序。不能正常排序的值如 \"NaN\"
   ，会按照任意顺序排序，但其排序方式会保持一致。它是 \"sort\" 默认使用的比较函数。可进行排序的非数值类型，应当实现此方法。

"),

(E"所有对象",E"Base",E"typeof",E"typeof(x)

   返回 \"x\" 的具体类型。

"),

(E"所有对象",E"Base",E"tuple",E"tuple(xs...)

   构造指定对象的多元组。

"),

(E"所有对象",E"Base",E"ntuple",E"ntuple(n, f::Function)

   构造长度为 \"n\" 的多元组，每个元素为 \"f(i)\" ，其中 \"i\" 为元素的索引值。

"),

(E"所有对象",E"Base",E"object_id",E"object_id(x)

   获取 \"x\" 唯一的整数值 ID 。当且仅当 \"is(x,y)\" 时，
   \"object_id(x)==object_id(y)\" 。

"),

(E"所有对象",E"Base",E"hash",E"hash(x)

   计算整数哈希值。因而 \"isequal(x,y)\" 等价于 \"hash(x)==hash(y)\" 。

"),

(E"所有对象",E"Base",E"finalizer",E"finalizer(x, function)

   当没有程序可理解的对 \"x\" 的引用时，注册一个注册可调用的函数 \"f(x)\" 。当 \"x\"
   为位类型时，此函数的行为不可预测。

"),

(E"所有对象",E"Base",E"copy",E"copy(x)

   构造 \"x\" 的浅拷贝：仅复制外层结构，不复制内部值。如，复制数组时，会生成一个元素与原先完全相同的新数组。

"),

(E"所有对象",E"Base",E"deepcopy",E"deepcopy(x)

   构造 \"x\" 的深拷贝：递归复制所有的东西，返回一个完全独立的对象。如，深拷贝数组时，会生成一个元素为原先元素深拷贝的新数组。

   作为特例，匿名函数只能深拷贝，非匿名函数则为浅拷贝。它们的区别仅与闭包有关，例如含有隐藏的内部引用的函数。

   While it isn't normally necessary,自定义类型可通过定义特殊版本的
   \"deepcopy_internal(x::T, dict::ObjectIdDict)\"
   函数（此函数其它情况下不应使用）来覆盖默认的 \"deepcopy\" 行为，其中 \"T\" 是要指明的类型， \"dict\"
   记录迄今为止递归中复制的对象。在定义中， \"deepcopy_internal\" 应当用来代替 \"deepcopy\" ，
   \"dict\" 变量应当在返回前正确的更新。

"),

(E"所有对象",E"Base",E"convert",E"convert(type, x)

   试着将 \"x\" 转换为指定类型。

"),

(E"所有对象",E"Base",E"promote",E"promote(xs...)

   将所有参数转换为共同的提升类型（如果有的话），并将它们（作为多元组）返回。

"),

(E"类型",E"Base",E"subtype",E"subtype(type1, type2)

   仅在 \"type1\" 的所有值都是 \"type2\" 时为真。也可使用 \"<:\" 中缀运算符，写为 \"type1 <:
   type2\" 。

"),

(E"类型",E"Base",E"typemin",E"typemin(type)

   指定（实数）数值类型可表示的最小值。

"),

(E"类型",E"Base",E"typemax",E"typemax(type)

   指定（实数）数值类型可表示的最大值。

"),

(E"类型",E"Base",E"realmin",E"realmin(type)

   指定的浮点数类型可表示的非反常值中，绝对值最小的数。

"),

(E"类型",E"Base",E"realmax",E"realmax(type)

   指定的浮点数类型可表示的最大的有穷数。

"),

(E"类型",E"Base",E"maxintfloat",E"maxintfloat(type)

   指定的浮点数类型可无损表示的最大整数。

"),

(E"类型",E"Base",E"sizeof",E"sizeof(type)

   指定类型的权威二进制表示（如果有的话）所占的字节大小。

"),

(E"类型",E"Base",E"eps",E"eps([type])

   1.0 与下一个稍大的 \"type\" 类型可表示的浮点数之间的距离。有效的类型为 \"Float32\" 和
   \"Float64\" 。如果省略 \"type\" ，则返回 \"eps(Float64)\" 。

"),

(E"类型",E"Base",E"eps",E"eps(x)

   \"x\" 与下一个稍大的 \"x\" 同类型可表示的浮点数之间的距离。

"),

(E"类型",E"Base",E"promote_type",E"promote_type(type1, type2)

   如果可能的话，给出可以无损表示每个参数类型值的类型。若不存在无损表示时，可以容忍有损；如
   \"promote_type(Int64,Float64)\" 返回 \"Float64\" ，尽管严格来说，并非所有的
   \"Int64\" 值都可以由 \"Float64\" 无损表示。

"),

(E"通用函数",E"Base",E"method_exists",E"method_exists(f, tuple) -> Bool

   判断指定的通用函数是否有匹配参数类型多元组的方法。

   **例子** ： \"method_exists(length, (Array,)) = true\"

"),

(E"通用函数",E"Base",E"applicable",E"applicable(f, args...)

   判断指定的通用函数是否有可用于指定参数的方法。

"),

(E"通用函数",E"Base",E"invoke",E"invoke(f, (types...), args...)

   对指定的参数，为匹配指定类型（多元组）的通用函数指定要调用的方法。参数应与指定的类型兼容。它允许在最匹配的方法之外，指定一个方法。这对
   明确需要一个更通用的定义的行为时非常有用（通常作为相同函数的更特殊的方法实现的一部分）。

"),

(E"通用函数",E"Base",E"|",E"|()

   对前面的参数应用一个函数，方便写链式函数。

   **例子** ： \"[1:5] | x->x.^2 | sum | inv\"

"),

(E"迭代",E"Base",E"start",E"start(iter) -> state

   获取可迭代对象的初始迭代状态。

"),

(E"迭代",E"Base",E"done",E"done(iter, state) -> Bool

   判断迭代是否完成。

"),

(E"迭代",E"Base",E"next",E"next(iter, state) -> item, state

   对指定的可迭代对象和迭代状态，返回当前项和下一个迭代状态。

"),

(E"迭代",E"Base",E"zip",E"zip(iters...)

   对一组迭代对象，返回一组可迭代多元组，其中第 \"i\" 个多元组包含每个可迭代输入的第 \"i\" 个分量。

   注意 \"zip\" 是它自己的逆操作： [zip(zip(a...)...)...] == [a...]

"),

(E"通用集合",E"Base",E"isempty",E"isempty(collection) -> Bool

   判断集合是否为空（没有元素）。

"),

(E"通用集合",E"Base",E"empty!",E"empty!(collection) -> collection

   移除集合中的所有元素。

"),

(E"通用集合",E"Base",E"length",E"length(collection) -> Integer

   对可排序、可索引的集合，用于 \"ref(collection, i)\" 最大索引值 \"i\"
   是有效的。对不可排序的集合，结果为元素个数。

"),

(E"通用集合",E"Base",E"endof",E"endof(collection) -> Integer

   返回集合的最后一个索引值。

   **例子** ： \"endof([1,2,4]) = 3\"

"),

(E"可迭代集合",E"Base",E"contains",E"contains(itr, x) -> Bool

   判断集合是否包含指定值 \"x\" 。

"),

(E"可迭代集合",E"Base",E"findin",E"findin(a, b)

   返回曾在集合 \"b\" 中出现的，集合 \"a\"  中元素的索引值。

"),

(E"可迭代集合",E"Base",E"unique",E"unique(itr)

   返回 \"itr\" 中去除多余重复元素的数组。

"),

(E"可迭代集合",E"Base",E"reduce",E"reduce(op, v0, itr)

   使用指定的运算符约简指定集合， \"v0\" 为约简的初始值。一些常用运算符的缩减，有更简便的单参数格式： \"max(itr)\",
   \"min(itr)\", \"sum(itr)\", \"prod(itr)\", \"any(itr)\",
   \"all(itr)\".

"),

(E"可迭代集合",E"Base",E"max",E"max(itr)

   返回集合中最大的元素。

"),

(E"可迭代集合",E"Base",E"min",E"min(itr)

   返回集合中最小的元素。

"),

(E"可迭代集合",E"Base",E"indmax",E"indmax(itr) -> Integer

   返回集合中最大的元素的索引值。

"),

(E"可迭代集合",E"Base",E"indmin",E"indmin(itr) -> Integer

   返回集合中最小的元素的索引值。

"),

(E"可迭代集合",E"Base",E"findmax",E"findmax(itr) -> (x, index)

   返回最大的元素及其索引值。

"),

(E"可迭代集合",E"Base",E"findmin",E"findmin(itr) -> (x, index)

   返回最小的元素及其索引值。

"),

(E"可迭代集合",E"Base",E"sum",E"sum(itr)

   返回集合中所有元素的和。

"),

(E"可迭代集合",E"Base",E"prod",E"prod(itr)

   返回集合中所有元素的乘积。

"),

(E"可迭代集合",E"Base",E"any",E"any(itr) -> Bool

   判断布尔值集合中是否有为真的元素。

"),

(E"可迭代集合",E"Base",E"all",E"all(itr) -> Bool

   判断布尔值集合中是否所有的元素都为真。

"),

(E"可迭代集合",E"Base",E"count",E"count(itr) -> Integer

   \"itr\" 中为真的布尔值元素的个数。

"),

(E"可迭代集合",E"Base",E"countp",E"countp(p, itr) -> Integer

   \"itr\" 中断言 \"p\" 为真的布尔值元素的个数。

"),

(E"可迭代集合",E"Base",E"any",E"any(p, itr) -> Bool

   判断 \"itr\" 中是否存在使指定断言为真的元素。

"),

(E"可迭代集合",E"Base",E"all",E"all(p, itr) -> Bool

   判断 \"itr\" 中是否所有元素都使指定断言为真。

"),

(E"可迭代集合",E"Base",E"map",E"map(f, c) -> collection

   使用 \"f\" 遍历集合 \"c\" 的每个元素。

   **例子** ： \"map((x) -> x * 2, [1, 2, 3]) = [2, 4, 6]\"

"),

(E"可迭代集合",E"Base",E"map!",E"map!(function, collection)

   \"map()\" 的原地版本。

"),

(E"可迭代集合",E"Base",E"mapreduce",E"mapreduce(f, op, itr)

   使用 \"f\" 遍历集合 \"c\" 的每个元素，然后使用二元函数 \"op\" 对结果进行约简。

   **例子** ： \"mapreduce(x->x^2, +, [1:3]) == 1 + 4 + 9 == 14\"

"),

(E"可迭代集合",E"Base",E"first",E"first(coll)

   获取可排序集合的第一个元素。

"),

(E"可迭代集合",E"Base",E"last",E"last(coll)

   获取可排序集合的最后一个元素。

"),

(E"可索引集合",E"Base",E"collection[key...]",E"ref(collection, key...)
collection[key...]()

   取回集合中存储在指定 key 键或索引值内的值。

"),

(E"可索引集合",E"",E"collection[key...] = value",E"assign(collection, value, key...)
collection[key...] = value

   将指定值存储在集合的指定 key 键或索引值内。

"),

(E"关联性集合",E"Base",E"Dict{K,V}",E"Dict{K,V}()

   使用 K 类型的 key 和 V 类型的值来构造哈希表。

"),

(E"关联性集合",E"Base",E"has",E"has(collection, key)

   判断集合是否含有指定 key 的映射。

"),

(E"关联性集合",E"Base",E"get",E"get(collection, key, default)

   返回指定 key 存储的值；当前没有 key 的映射时，返回默认值。

"),

(E"关联性集合",E"Base",E"getkey",E"getkey(collection, key, default)

   如果参数 \"key\" 匹配 \"collection\" 中的 key ，将其返回；否在返回 \"default\" 。

"),

(E"关联性集合",E"Base",E"delete!",E"delete!(collection, key)

   删除集合中指定 key 的映射。

"),

(E"关联性集合",E"Base",E"empty!",E"empty!(collection)

   删除集合中所有的 key 。

"),

(E"关联性集合",E"Base",E"keys",E"keys(collection)

   返回集合中所有 key 组成的数组。

"),

(E"关联性集合",E"Base",E"values",E"values(collection)

   返回集合中所有值组成的数组。

"),

(E"关联性集合",E"Base",E"collect",E"collect(collection)

   返回集合中的所有项。对关联性集合，返回 (key, value) 多元组。

"),

(E"关联性集合",E"Base",E"merge",E"merge(collection, others...)

   使用指定的集合构造归并集合。

"),

(E"关联性集合",E"Base",E"merge!",E"merge!(collection, others...)

   将其它集合中的对儿更新进 \"collection\" 。

"),

(E"关联性集合",E"Base",E"filter",E"filter(function, collection)

   返回集合的浅拷贝，移除使 \"function\" 函数为假的 (key, value) 对儿。

"),

(E"关联性集合",E"Base",E"filter!",E"filter!(function, collection)

   更新集合，移除使 \"function\" 函数为假的 (key, value) 对儿。

"),

(E"关联性集合",E"Base",E"eltype",E"eltype(collection)

   返回集合中包含的 (key,value) 对儿的类型多元组。

"),

(E"关联性集合",E"Base",E"sizehint",E"sizehint(s, n)

   使集合 \"s\" 保留最少 \"n\" 个元素的容量。这样可提高性能。

"),

(E"类集集合",E"Base",E"add!",E"add!(collection, key)

   向类集集合添加元素。

"),

(E"类集集合",E"Base",E"add_each!",E"add_each!(collection, iterable)

   Adds each element in iterable to the collection.

"),

(E"类集集合",E"Base",E"Set",E"Set(x...)

   构造a \"Set\" with the given elements. Should be used instead of
   \"IntSet\" for sparse integer sets.

"),

(E"类集集合",E"Base",E"IntSet",E"IntSet(i...)

   构造an \"IntSet\" of the given integers. Implemented as a bit string,
   and therefore good for dense integer sets.

"),

(E"类集集合",E"Base",E"union",E"union(s1, s2...)

   构造the union of two or more sets. Maintains order with arrays.

"),

(E"类集集合",E"Base",E"union!",E"union!(s1, s2)

   Constructs the union of IntSets s1 and s2, stores the result in
   \"s1\".

"),

(E"类集集合",E"Base",E"intersect",E"intersect(s1, s2...)

   构造the intersection of two or more sets. Maintains order with
   arrays.

"),

(E"类集集合",E"Base",E"setdiff",E"setdiff(s1, s2)

   构造the set of elements in \"s1\" but not \"s2\". Maintains order
   with arrays.

"),

(E"类集集合",E"Base",E"symdiff",E"symdiff(s1, s2...)

   构造the symmetric difference of elements in the passed in sets or
   arrays. Maintains order with arrays.

"),

(E"类集集合",E"Base",E"symdiff!",E"symdiff!(s, n)

   IntSet s is destructively modified to toggle the inclusion of
   integer \"n\".

"),

(E"类集集合",E"Base",E"symdiff!",E"symdiff!(s, itr)

   For each element in \"itr\", destructively toggle its inclusion in
   set \"s\".

"),

(E"类集集合",E"Base",E"symdiff!",E"symdiff!(s1, s2)

   构造the symmetric difference of IntSets \"s1\" and \"s2\", storing
   the result in \"s1\".

"),

(E"类集集合",E"Base",E"complement",E"complement(s)

   返回the set-complement of IntSet s.

"),

(E"类集集合",E"Base",E"complement!",E"complement!(s)

   Mutates IntSet s into its set-complement.

"),

(E"类集集合",E"Base",E"del_each!",E"del_each!(s, itr)

   删除each element of itr in set s in-place.

"),

(E"类集集合",E"Base",E"intersect!",E"intersect!(s1, s2)

   Intersects IntSets s1 and s2 and overwrites the set s1 with the
   result. If needed, s1 will be expanded to the size of s2.

"),

(E"双端队列",E"Base",E"push!",E"push!(collection, item) -> collection

   在集合尾端插入一项。

"),

(E"双端队列",E"Base",E"pop!",E"pop!(collection) -> item

   移除集合的最后一项，并将其返回。

"),

(E"双端队列",E"Base",E"unshift!",E"unshift!(collection, item) -> collection

   在集合首端插入一项。

"),

(E"双端队列",E"Base",E"shift!",E"shift!(collection) -> item

   移除集合首项。

"),

(E"双端队列",E"Base",E"insert!",E"insert!(collection, index, item)

   在指定索引值处插入一项。

"),

(E"双端队列",E"Base",E"delete!",E"delete!(collection, index) -> item

   移除指定索引值处的项，并返回删除项。

"),

(E"双端队列",E"Base",E"delete!",E"delete!(collection, range) -> items

   移除指定范围内的项，并返回包含删除项的集合。

"),

(E"双端队列",E"Base",E"resize!",E"resize!(collection, n) -> collection

   改变集合的大小，使其可包含 \"n\" 个元素。

"),

(E"双端队列",E"Base",E"append!",E"append!(collection, items) -> collection

   将 \"items\" 元素附加到集合末尾。

"),

(E"字符串",E"Base",E"length",E"length(s)

   字符串 \"s\" 中的字符数。

"),

(E"字符串",E"Base",E"collect",E"collect(string)

   返回 \"string\" 中的字符数组。

"),

(E"字符串",E"Base",E"string",E"*()
string(strs...)

   连接字符串。

   **例子** ： \"\"Hello \" * \"world\" == \"Hello world\"\"

"),

(E"字符串",E"Base",E"^",E"^()

   重复字符串。

   **例子** ： \"\"Julia \"^3 == \"Julia Julia Julia \"\"

"),

(E"字符串",E"Base",E"string",E"string(char...)

   使用指定字符构造字符串。

"),

(E"字符串",E"Base",E"string",E"string(x)

   使用 \"print\" 函数的值构造字符串。

"),

(E"字符串",E"Base",E"repr",E"repr(x)

   使用 \"show\" 函数的值构造字符串。

"),

(E"字符串",E"Base",E"bytestring",E"bytestring(::Ptr{Uint8})

   从 C （以 0 结尾的）格式字符串的地址构造一个字符串。它使用了浅拷贝；可以安全释放指针。

"),

(E"字符串",E"Base",E"bytestring",E"bytestring(s)

   将字符串转换为连续的字节数组，从而可将它传递给 C 函数。

"),

(E"字符串",E"Base",E"ascii",E"ascii(::Array{Uint8, 1})

   从字节数组构造 ASCII 字符串。

"),

(E"字符串",E"Base",E"ascii",E"ascii(s)

   将字符串转换为连续的 ASCII 字符串（所有的字符都是有效的 ASCII 字符）。

"),

(E"字符串",E"Base",E"utf8",E"utf8(::Array{Uint8, 1})

   从字节数组构造 UTF-8 字符串。

"),

(E"字符串",E"Base",E"utf8",E"utf8(s)

   将字符串转换为连续的 UTF-8 字符串（所有的字符都是有效的 UTF-8 字符）。

"),

(E"字符串",E"Base",E"is_valid_ascii",E"is_valid_ascii(s) -> Bool

   如果字符串是有效的 ASCII ，返回真；否则返回假。

"),

(E"字符串",E"Base",E"is_valid_utf8",E"is_valid_utf8(s) -> Bool

   如果字符串是有效的 UTF-8 ，返回真；否则返回假。

"),

(E"字符串",E"Base",E"check_ascii",E"check_ascii(s)

   对字符串调用 \"is_valid_ascii()\" 。如果它不是有效的，则抛出错误。

"),

(E"字符串",E"Base",E"check_utf8",E"check_utf8(s)

   对字符串调用 \"is_valid_utf8()\" 。如果它不是有效的，则抛出错误。

"),

(E"字符串",E"Base",E"byte_string_classify",E"byte_string_classify(s)

   如果字符串不是有效的 ASCII 或 UTF-8 ，则返回 0 ；如果是有效的 ASCII，则返回 1 ；如果是有效的
   UTF-8，则返回 2 。

"),

(E"字符串",E"Base",E"search",E"search(string, char[, i])

   返回 \"string\" 中 \"char\" 的索引值；如果没找到，则返回 0
   。第二个参数也可以是字符向量或集合。第三个参数是可选的，它指明起始索引值。

"),

(E"字符串",E"Base",E"ismatch",E"ismatch(r::Regex, s::String)

   判断字符串是否匹配指定的正则表达式。

"),

(E"字符串",E"Base",E"lpad",E"lpad(string, n, p)

   在字符串左侧填充一系列 \"p\" ，以保证字符串至少有 \"n\" 个字符。

"),

(E"字符串",E"Base",E"rpad",E"rpad(string, n, p)

   在字符串右侧填充一系列 \"p\" ，以保证字符串至少有 \"n\" 个字符。

"),

(E"字符串",E"Base",E"search",E"search(string, chars[, start])

   在指定字符串中查找指定字符。第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式（但正则表达式仅用来处理连续字符串，如
   ASCII 或 UTF-8 字符串）。第三个参数是可选的，它指明起始索引值。返回值为所找到的匹配序列的索引值范围，它满足
   \"s[search(s,x)] == x\" 。如果没有匹配，则返回值为 \"0:-1\" 。

"),

(E"字符串",E"Base",E"replace",E"replace(string, pat, r[, n])

   查找指定模式 \"pat\" ，并替换为 \"r\" 。如果提供 \"n\" ，则最多替换 \"n\"
   次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

"),

(E"字符串",E"Base",E"replace",E"replace(string, pat, f[, n])

   查找指定模式 \"pat\" ，并替换为 \"f(pat)\" 。如果提供 \"n\" ，则最多替换 \"n\"
   次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

"),

(E"字符串",E"Base",E"split",E"split(string, [chars, [limit,] [include_empty]])

   返回由指定字符分割符所分割的指定字符串的字符串数组。分隔符可由 \"search\"
   的第二个参数所允许的任何格式所指明（如单字符、字符集合、字符串、或正则表达式）。如果省略 \"chars\"
   ，则它默认为整个空白字符集，且 \"include_empty\"
   默认为假。最后两个参数是可选的：它们是结果的最大长度，且由标志位决定是否在结果中包括空域。

"),

(E"字符串",E"Base",E"strip",E"strip(string[, chars])

   返回去除头部、尾部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

(E"字符串",E"Base",E"lstrip",E"lstrip(string[, chars])

   返回去除头部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

(E"字符串",E"Base",E"rstrip",E"rstrip(string[, chars])

   返回去除尾部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

(E"字符串",E"Base",E"begins_with",E"begins_with(string, prefix)

   如果 \"string\" 以 \"prefix\" 开始，则返回 \"true\" 。

"),

(E"字符串",E"Base",E"ends_with",E"ends_with(string, suffix)

   如果 \"string\" 以 \"suffix\" 结尾，则返回 \"true\" 。

"),

(E"字符串",E"Base",E"uppercase",E"uppercase(string)

   返回所有字符转换为大写的 \"string\" 。

"),

(E"字符串",E"Base",E"lowercase",E"lowercase(string)

   返回所有字符转换为小写的 \"string\" 。

"),

(E"字符串",E"Base",E"join",E"join(strings, delim)

   Join an array of strings into a single string, inserting the given
   delimiter between adjacent strings.

"),

(E"字符串",E"Base",E"chop",E"chop(string)

   移除字符串的最后一个字符。

"),

(E"字符串",E"Base",E"chomp",E"chomp(string)

   移除字符串最后的换行符。

"),

(E"字符串",E"Base",E"ind2chr",E"ind2chr(string, i)

   Convert a byte index to a character index

"),

(E"字符串",E"Base",E"chr2ind",E"chr2ind(string, i)

   Convert a character index to a byte index

"),

(E"字符串",E"Base",E"isvalid",E"isvalid(str, i)

   Tells whether index \"i\" is valid for the given string

"),

(E"字符串",E"Base",E"nextind",E"nextind(str, i)

   Get the next valid string index after \"i\". 返回``endof(str)+1`` at
   the end of the string.

"),

(E"字符串",E"Base",E"prevind",E"prevind(str, i)

   Get the previous valid string index before \"i\". 返回``0`` at the
   beginning of the string.

"),

(E"字符串",E"Base",E"thisind",E"thisind(str, i)

   Adjust \"i\" downwards until it reaches a valid index for the given
   string.

"),

(E"字符串",E"Base",E"randstring",E"randstring(len)

   构造a random ASCII string of length \"len\", consisting of upper- and
   lower-case letters and the digits 0-9

"),

(E"字符串",E"Base",E"charwidth",E"charwidth(c)

   Gives the number of columns needed to print a character.

"),

(E"字符串",E"Base",E"strwidth",E"strwidth(s)

   Gives the number of columns needed to print a string.

"),

(E"字符串",E"Base",E"isalnum",E"isalnum(c::Char)

   判断字符是否为字母或数字。

"),

(E"字符串",E"Base",E"isalpha",E"isalpha(c::Char)

   判断字符是否为字母。

"),

(E"字符串",E"Base",E"isascii",E"isascii(c::Char)

   判断字符是否属于 ASCII 字符集。

"),

(E"字符串",E"Base",E"isblank",E"isblank(c::Char)

   判断字符是否为 tab 或空格。

"),

(E"字符串",E"Base",E"iscntrl",E"iscntrl(c::Char)

   判断字符是否为控制字符。

"),

(E"字符串",E"Base",E"isdigit",E"isdigit(c::Char)

   判断字符是否为一位数字（0-9）。

"),

(E"字符串",E"Base",E"isgraph",E"isgraph(c::Char)

   判断字符是否可打印，且不是空白字符。

"),

(E"字符串",E"Base",E"islower",E"islower(c::Char)

   判断字符是否为小写字母。

"),

(E"字符串",E"Base",E"isprint",E"isprint(c::Char)

   判断字符是否可打印，包括空白字符。

"),

(E"字符串",E"Base",E"ispunct",E"ispunct(c::Char)

   判断字符是否可打印，且既非空白字符也非字母或数字。

"),

(E"字符串",E"Base",E"isspace",E"isspace(c::Char)

   判断字符是否为任意空白字符。

"),

(E"字符串",E"Base",E"isupper",E"isupper(c::Char)

   判断字符是否为大写字母。

"),

(E"字符串",E"Base",E"isxdigit",E"isxdigit(c::Char)

   判断字符是否为有效的十六进制字符。

"),

(E"I/O",E"Base",E"STDOUT",E"STDOUT

   指向标准输出流的全局变量。

"),

(E"I/O",E"Base",E"STDERR",E"STDERR

   指向标准错误流的全局变量。

"),

(E"I/O",E"Base",E"STDIN",E"STDIN

   指向标准输入流的全局变量。

"),

(E"I/O",E"Base",E"open",E"open(file_name[, read, write, create, truncate, append]) -> IOStream

   Open a file in a mode specified by five boolean arguments. The
   default is to open files for reading only. 返回a stream for accessing
   the file.

"),

(E"I/O",E"Base",E"open",E"open(file_name[, mode]) -> IOStream

   Alternate syntax for open, where a string-based mode specifier is
   used instead of the five booleans. The values of \"mode\"
   correspond to those from \"fopen(3)\" or Perl \"open\", and are
   equivalent to setting the following boolean groups:

   +------+-----------------------------------+
   | r    | 读                                 |
   +------+-----------------------------------+
   | r+   | 读、写                               |
   +------+-----------------------------------+
   | w    | 写、新建、truncate                     |
   +------+-----------------------------------+
   | w+   | 读写、新建、truncate                    |
   +------+-----------------------------------+
   | a    | 写、新建、追加                           |
   +------+-----------------------------------+
   | a+   | 读、写、新建、追加                         |
   +------+-----------------------------------+

"),

(E"I/O",E"Base",E"open",E"open(file_name) -> IOStream

   以只读模式打开文件。

"),

(E"I/O",E"Base",E"open",E"open(f::function, args...)

   Apply the function \"f\" to the result of \"open(args...)\" and
   close the resulting file descriptor upon completion.

   **例子** ： \"open(readall, \"file.txt\")\"

"),

(E"I/O",E"Base",E"memio",E"memio([size[, finalize::Bool]]) -> IOStream

   构造an in-memory I/O stream, optionally specifying how much initial
   space is needed.

"),

(E"I/O",E"Base",E"fdio",E"fdio(fd::Integer[, own::Bool]) -> IOStream
fdio(name::String, fd::Integer, [own::Bool]]) -> IOStream

   构造an \"IOStream\" object from an integer file descriptor. If
   \"own\" is true, closing this object will close the underlying
   descriptor. By default, an \"IOStream\" is closed when it is
   garbage collected. \"name\" allows you to associate the descriptor
   with a named file.

"),

(E"I/O",E"Base",E"flush",E"flush(stream)

   Commit all currently buffered writes to the given stream.

"),

(E"I/O",E"Base",E"close",E"close(stream)

   Close an I/O stream. Performs a \"flush\" first.

"),

(E"I/O",E"Base",E"write",E"write(stream, x)

   Write the canonical binary representation of a value to the given
   stream.

"),

(E"I/O",E"Base",E"read",E"read(stream, type)

   Read a value of the given type from a stream, in canonical binary
   representation.

"),

(E"I/O",E"Base",E"read",E"read(stream, type, dims)

   Read a series of values of the given type from a stream, in
   canonical binary representation. \"dims\" is either a tuple or a
   series of integer arguments specifying the size of \"Array\" to
   return.

"),

(E"I/O",E"Base",E"position",E"position(s)

   Get the current position of a stream.

"),

(E"I/O",E"Base",E"seek",E"seek(s, pos)

   Seek a stream to the given position.

"),

(E"I/O",E"Base",E"seek_end",E"seek_end(s)

   Seek a stream to the end.

"),

(E"I/O",E"Base",E"skip",E"skip(s, offset)

   Seek a stream relative to the current position.

"),

(E"I/O",E"Base",E"eof",E"eof(stream)

   判断 whether an I/O stream is at end-of-file. If the stream is not
   yet exhausted, this function will block to wait for more data if
   necessary, and then return \"false\". Therefore it is always safe
   to read one byte after seeing \"eof\" return \"false\".

"),

(E"文本 I/O",E"Base",E"show",E"show(x)

   Write an informative text representation of a value to the current
   output stream. New types should overload \"show(io, x)\" where the
   first argument is a stream.

"),

(E"文本 I/O",E"Base",E"print",E"print(x)

   Write (to the default output stream) a canonical (un-decorated)
   text representation of a value if there is one, otherwise call
   \"show\".

"),

(E"文本 I/O",E"Base",E"println",E"println(x)

   使用 \"print()\" 打印 \"x\" ，并接一个换行符。

"),

(E"文本 I/O",E"Base",E"showall",E"showall(x)

   Show x, printing all elements of arrays

"),

(E"文本 I/O",E"Base",E"dump",E"dump(x)

   Write a thorough text representation of a value to the current
   output stream.

"),

(E"文本 I/O",E"Base",E"readall",E"readall(stream)

   Read the entire contents of an I/O stream as a string.

"),

(E"文本 I/O",E"Base",E"readline",E"readline(stream)

   Read a single line of text, including a trailing newline character
   (if one is reached before the end of the input).

"),

(E"文本 I/O",E"Base",E"readuntil",E"readuntil(stream, delim)

   Read a string, up to and including the given delimiter byte.

"),

(E"文本 I/O",E"Base",E"readlines",E"readlines(stream)

   Read all lines as an array.

"),

(E"文本 I/O",E"Base",E"each_line",E"each_line(stream)

   构造an iterable object that will yield each line from a stream.

"),

(E"文本 I/O",E"Base",E"readdlm",E"readdlm(filename, delim::Char)

   Read a matrix from a text file where each line gives one row, with
   elements separated by the given delimeter. If all data is numeric,
   the result will be a numeric array. If some elements cannot be
   parsed as numbers, a cell array of numbers and strings is returned.

"),

(E"文本 I/O",E"Base",E"readdlm",E"readdlm(filename, delim::Char, T::Type)

   Read a matrix from a text file with a given element type. If \"T\"
   is a numeric type, the result is an array of that type, with any
   non-numeric elements as \"NaN\" for floating-point types, or zero.
   Other useful values of \"T\" include \"ASCIIString\", \"String\",
   and \"Any\".

"),

(E"文本 I/O",E"Base",E"writedlm",E"writedlm(filename, array, delim::Char)

   Write an array to a text file using the given delimeter (defaults
   to comma).

"),

(E"文本 I/O",E"Base",E"readcsv",E"readcsv(filename[, T::Type])

   Equivalent to \"readdlm\" with \"delim\" set to comma.

"),

(E"文本 I/O",E"Base",E"writecsv",E"writecsv(filename, array)

   Equivalent to \"writedlm\" with \"delim\" set to comma.

"),

(E"内存映射 I/O",E"Base",E"mmap_array",E"mmap_array(type, dims, stream[, offset])

   使用内存映射构造数组，数组的值连接到文件。它提供了处理对计算机内存来说过于庞大数据的简便方法。

   \"type\" 决定了如何解释数组中的字节（不使用格式转换）。 \"dims\" 是包含字节大小的多元组。

   文件是由 \"stream\" 指明的。初始化流时，对“只读”数组使用 “r” ，使用 \"w+\"
   新建用于向硬盘写入值的数组。可以选择指明偏移值（单位为字节），用来跳过文件头等。

   **例子** ：  A = mmap_array(Int64, (25,30000), s)

   它将构造一个 25 x 30000 的 Int64 类型的数列，它链接到与流 s 有关的文件上。

"),

(E"内存映射 I/O",E"Base",E"msync",E"msync(array)

   对内存映射数组的内存中的版本和硬盘上的版本强制同步。程序员可能不需要调用此函数，因为操作系统在休息时自动同步。但是，如果你担心丢失一个
   需要很长时间来运算的结果，就可以直接调用此函数。

"),

(E"内存映射 I/O",E"Base",E"mmap",E"mmap(len, prot, flags, fd, offset)

   mmap 系统调用的低级接口。

"),

(E"内存映射 I/O",E"Base",E"munmap",E"munmap(pointer, len)

   取消内存映射的低级接口。对于 mmap_array 则不需要直接调用此函数；当数组离开作用域时，会自动取消内存映射。

"),

(E"数学函数",E"Base",E"-",E"-()

   一元减。

"),

(E"数学函数",E"",E"+ - * / \\ ^",E"+ - * / \\ ^

   二元加、减、乘、左除、右除、指数运算符。

"),

(E"数学函数",E"",E".+ .- .* ./ .\\ .^",E".+ .- .* ./ .\\ .^

   逐元素二元加、减、乘、左除、右除、指数运算符。

"),

(E"数学函数",E"Base",E"div",E"div(a, b)

   计算 a/b, truncating to an integer

"),

(E"数学函数",E"Base",E"fld",E"fld(a, b)

   Largest integer less than or equal to a/b

"),

(E"数学函数",E"Base",E"mod",E"mod(x, m)

   Modulus after division, returning in the range [0,m)

"),

(E"数学函数",E"Base",E"%",E"rem()
%()

   Remainder after division

"),

(E"数学函数",E"Base",E"mod1",E"mod1(x, m)

   Modulus after division, returning in the range (0,m]

"),

(E"数学函数",E"Base",E"//",E"//()

   分数除法。

"),

(E"数学函数",E"Base",E"num",E"num(x)

   分数 \"x\" 的分子。

"),

(E"数学函数",E"Base",E"den",E"den(x)

   分数 \"x\" 的分母。

"),

(E"数学函数",E"",E"<< >>",E"<< >>

   左移、右移运算符。

"),

(E"数学函数",E"",E"== != < <= > >=",E"== != < <= > >=

   比较运算符，用于判断是否相等、不等、小于、小于等于、大于、大于等于。

"),

(E"数学函数",E"Base",E"cmp",E"cmp(x, y)

   返回-1, 0, or 1 depending on whether \"x<y\", \"x==y\", or \"x>y\",
   respectively

"),

(E"数学函数",E"Base",E"!",E"!()

   逻辑非。

"),

(E"数学函数",E"Base",E"~",E"~()

   Boolean or bitwise not

"),

(E"数学函数",E"Base",E"&",E"&()

   逻辑与。

"),

(E"数学函数",E"Base",E"|",E"|()

   逻辑或。

"),

(E"数学函数",E"Base",E"$",E"$()

   Bitwise exclusive or

"),

(E"数学函数",E"Base",E"sin",E"sin(x)

   计算 \"x\" 的正弦值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"cos",E"cos(x)

   计算 \"x\" 的余弦值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"tan",E"tan(x)

   计算 \"x\" 的正切值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"sind",E"sind(x)

   计算 \"x\" 的正弦值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"cosd",E"cosd(x)

   计算 \"x\" 的余弦值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"tand",E"tand(x)

   计算 \"x\" 的正切值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"sinh",E"sinh(x)

   计算 \"x\" 的双曲正弦值。

"),

(E"数学函数",E"Base",E"cosh",E"cosh(x)

   计算 \"x\" 的双曲余弦值。

"),

(E"数学函数",E"Base",E"tanh",E"tanh(x)

   计算 \"x\" 的双曲正切值。

"),

(E"数学函数",E"Base",E"asin",E"asin(x)

   计算 \"x\" 的反正弦值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"acos",E"acos(x)

   计算 \"x\" 的反余弦值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"atan",E"atan(x)

   计算 \"x\" 的反正切值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"atan2",E"atan2(y, x)

   计算 \"y/x\" 的反正切值，由 \"x\" 和 \"y\" 的正负号来确定返回值的象限。

"),

(E"数学函数",E"Base",E"asind",E"asind(x)

   计算 \"x\" 的反正弦值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"acosd",E"acosd(x)

   计算 \"x\" 的反余弦值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"atand",E"atand(x)

   计算 \"x\" 的反正切值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"sec",E"sec(x)

   计算 \"x\" 的正割值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"csc",E"csc(x)

   计算 \"x\" 的余割值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"cot",E"cot(x)

   计算 \"x\" 的余切值，其中 \"x\" 的单位为弧度。

"),

(E"数学函数",E"Base",E"secd",E"secd(x)

   计算 \"x\" 的正割值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"cscd",E"cscd(x)

   计算 \"x\" 的余割值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"cotd",E"cotd(x)

   计算 \"x\" 的余切值，其中 \"x\" 的单位为度数。

"),

(E"数学函数",E"Base",E"asec",E"asec(x)

   计算 \"x\" 的反正割值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"acsc",E"acsc(x)

   计算 \"x\" 的反余割值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"acot",E"acot(x)

   计算 \"x\" 的反余切值，结果的单位为弧度。

"),

(E"数学函数",E"Base",E"asecd",E"asecd(x)

   计算 \"x\" 的反正割值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"acscd",E"acscd(x)

   计算 \"x\" 的反余割值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"acotd",E"acotd(x)

   计算 \"x\" 的反余切值，结果的单位为度数。

"),

(E"数学函数",E"Base",E"sech",E"sech(x)

   计算 \"x\" 的双曲正割值。

"),

(E"数学函数",E"Base",E"csch",E"csch(x)

   计算 \"x\" 的双曲余割值。

"),

(E"数学函数",E"Base",E"coth",E"coth(x)

   计算 \"x\" 的双曲余切值。

"),

(E"数学函数",E"Base",E"asinh",E"asinh(x)

   计算 \"x\" 的反双曲正弦值。

"),

(E"数学函数",E"Base",E"acosh",E"acosh(x)

   计算 \"x\" 的反双曲余弦值。

"),

(E"数学函数",E"Base",E"atanh",E"atanh(x)

   计算 \"x\" 的反双曲正切值。

"),

(E"数学函数",E"Base",E"asech",E"asech(x)

   计算 \"x\" 的反双曲正割值。

"),

(E"数学函数",E"Base",E"acsch",E"acsch(x)

   计算 \"x\" 的反双曲余割值。

"),

(E"数学函数",E"Base",E"acoth",E"acoth(x)

   计算 \"x\" 的反双曲余切值。

"),

(E"数学函数",E"Base",E"sinc",E"sinc(x)

   计算 sin(\\pi x) / x 。

"),

(E"数学函数",E"Base",E"cosc",E"cosc(x)

   计算 cos(\\pi x) / x 。

"),

(E"数学函数",E"Base",E"degrees2radians",E"degrees2radians(x)

   将 \"x\" 度数转换为弧度。

"),

(E"数学函数",E"Base",E"radians2degrees",E"radians2degrees(x)

   将 \"x\" 弧度转换为度数。

"),

(E"数学函数",E"Base",E"hypot",E"hypot(x, y)

   计算 \"sqrt( (x^2+y^2) )\" ，计算过程不会出现上溢、下溢。

"),

(E"数学函数",E"Base",E"log",E"log(x)

   计算 \"x\" 的自然对数。

"),

(E"数学函数",E"Base",E"log2",E"log2(x)

   计算 \"x\" 以 2 为底的对数。

"),

(E"数学函数",E"Base",E"log10",E"log10(x)

   计算 \"x\" 以 10 为底的对数。

"),

(E"数学函数",E"Base",E"log1p",E"log1p(x)

   \"1+x\" 自然对数的精确值。

"),

(E"数学函数",E"Base",E"logb",E"logb(x)

   返回浮点数 \"trunc( log2( abs(x) ) )\" 。

"),

(E"数学函数",E"Base",E"ilogb",E"ilogb(x)

   \"logb()\" 的返回值为整数的版本。

"),

(E"数学函数",E"Base",E"frexp",E"frexp(val, exp)

   返回a number \"x\" such that it has a magnitude in the interval
   \"[1/2, 1)\" or 0, and val = x \\times 2^{exp}.

"),

(E"数学函数",E"Base",E"exp",E"exp(x)

   计算 \"e^x\" 。

"),

(E"数学函数",E"Base",E"exp2",E"exp2(x)

   计算 \"2^x\" 。

"),

(E"数学函数",E"Base",E"ldexp",E"ldexp(x, n)

   计算 x \\times 2^n 。

"),

(E"数学函数",E"Base",E"modf",E"modf(x)

   返回一个数的小数部分和整数部分的多元组。两部分都与参数同正负号。

"),

(E"数学函数",E"Base",E"expm1",E"expm1(x)

   \"e^x-1\" 的精确值。

"),

(E"数学函数",E"Base",E"square",E"square(x)

   计算 \"x^2\" 。

"),

(E"数学函数",E"Base",E"round",E"round(x[, digits[, base]]) -> FloatingPoint

   \"round(x)\" 返回离 \"x\" 最近的整数。 \"round(x, digits)\" rounds to the
   specified number of digits after the decimal place, or before if
   negative, e.g., \"round(pi,2)\" is \"3.14\". \"round(x, digits,
   base)\" rounds using a different base, defaulting to 10, e.g.,
   \"round(pi, 3, 2)\" is \"3.125\".

"),

(E"数学函数",E"Base",E"ceil",E"ceil(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 +Inf 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

(E"数学函数",E"Base",E"floor",E"floor(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 -Inf 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

(E"数学函数",E"Base",E"trunc",E"trunc(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 0 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

(E"数学函数",E"Base",E"iround",E"iround(x) -> Integer

   结果为整数类型的 \"round()\" 。

"),

(E"数学函数",E"Base",E"iceil",E"iceil(x) -> Integer

   结果为整数类型的 \"ceil()\" 。

"),

(E"数学函数",E"Base",E"ifloor",E"ifloor(x) -> Integer

   结果为整数类型的 \"floor()\" 。

"),

(E"数学函数",E"Base",E"itrunc",E"itrunc(x) -> Integer

   结果为整数类型的 \"trunc()\" 。

"),

(E"数学函数",E"Base",E"signif",E"signif(x, digits[, base]) -> FloatingPoint

   Rounds (in the sense of \"round\") \"x\" so that there are
   \"digits\" significant digits, under a base \"base\"
   representation, default 10. E.g., \"signif(123.456, 2)\" is
   \"120.0\", and \"signif(357.913, 4, 2)\" is \"352.0\".

"),

(E"数学函数",E"Base",E"min",E"min(x, y)

   返回 \"x\" 和 \"y\" 的最小值。

"),

(E"数学函数",E"Base",E"max",E"max(x, y)

   返回 \"x\" 和 \"y\" 的最大值。

"),

(E"数学函数",E"Base",E"clamp",E"clamp(x, lo, hi)

   返回 x if \"lo <= x <= y\". If \"x < lo\", return \"lo\". If \"x >
   hi\", return \"hi\".

"),

(E"数学函数",E"Base",E"abs",E"abs(x)

   \"x\" 的绝对值。

"),

(E"数学函数",E"Base",E"abs2",E"abs2(x)

   \"x\" 绝对值的平方。

"),

(E"数学函数",E"Base",E"copysign",E"copysign(x, y)

   返回 \"x\" such that it has the same sign as \"y\"

"),

(E"数学函数",E"Base",E"sign",E"sign(x)

   如果 \"x\" 是正数时返回 \"+1\" ， \"x == 0\" 时返回 \"0\" ， \"x\" 是负数时返回 \"-1\"
   。

"),

(E"数学函数",E"Base",E"signbit",E"signbit(x)

   返回 \"1\" if the value of the sign of \"x\" is negative, otherwise
   \"0\".

"),

(E"数学函数",E"Base",E"flipsign",E"flipsign(x, y)

   返回 \"x\" with its sign flipped if \"y\" is negative. For example
   \"abs(x) = flipsign(x,x)\".

"),

(E"数学函数",E"Base",E"sqrt",E"sqrt(x)

   返回 \\sqrt{x} 。

"),

(E"数学函数",E"Base",E"cbrt",E"cbrt(x)

   返回 x^{1/3} 。

"),

(E"数学函数",E"Base",E"erf",E"erf(x)

   计算 \"x\" 的误差函数，defined by \\frac{2}{\\sqrt{\\pi}} \\int_0^x
   e^{-t^2} dt for arbitrary complex \"x\".

"),

(E"数学函数",E"Base",E"erfc",E"erfc(x)

   计算the complementary error function of \"x\", defined by 1 -
   \\operatorname{erf}(x).

"),

(E"数学函数",E"Base",E"erfcx",E"erfcx(x)

   计算the scaled complementary error function of \"x\", defined by
   e^{x^2} \\operatorname{erfc}(x).  Note also that
   \\operatorname{erfcx}(-ix) computes the Faddeeva function \"w(x)\".

"),

(E"数学函数",E"Base",E"erfi",E"erfi(x)

   计算the imaginary error function of \"x\", defined by -i
   \\operatorname{erf}(ix).

"),

(E"数学函数",E"Base",E"dawson",E"dawson(x)

   计算the Dawson function (scaled imaginary error function) of \"x\",
   defined by \\frac{\\sqrt{\\pi}}{2} e^{-x^2}
   \\operatorname{erfi}(x).

"),

(E"数学函数",E"Base",E"real",E"real(z)

   返回复数 \"z\" 的实数部分。

"),

(E"数学函数",E"Base",E"imag",E"imag(z)

   返回复数 \"z\" 的虚数部分。

"),

(E"数学函数",E"Base",E"reim",E"reim(z)

   返回复数 \"z\" 的整数部分和虚数部分。

"),

(E"数学函数",E"Base",E"conj",E"conj(z)

   计算复数 \"z\" 的共轭。

"),

(E"数学函数",E"Base",E"angle",E"angle(z)

   计算复数 \"z\" 的相位角。

"),

(E"数学函数",E"Base",E"cis",E"cis(z)

   如果 \"z\" 是实数，返回 \"cos(z) + i*sin(z)\" 。如果 \"z\" 是实数，返回
   \"(cos(real(z)) + i*sin(real(z)))/exp(imag(z))\" 。

"),

(E"数学函数",E"Base",E"binomial",E"binomial(n, k)

   从  \"n\" 项中选取 \"k\" 项，有多少种方法。

"),

(E"数学函数",E"Base",E"factorial",E"factorial(n)

   n 的阶乘。

"),

(E"数学函数",E"Base",E"factorial",E"factorial(n, k)

   计算 \"factorial(n)/factorial(k)\"

"),

(E"数学函数",E"Base",E"factor",E"factor(n)

   对 \"n\" 分解质因数。返回a dictionary. The keys of the dictionary correspond
   to the factors, and hence are of the same type as \"n\". The value
   associated with each key indicates the number of times the factor
   appears in the factorization.

   **例子** ： \"100=2*2*5*5\" ，因此 \"factor(100) -> [5=>2,2=>2]\"

"),

(E"数学函数",E"Base",E"gcd",E"gcd(x, y)

   最大公因数。

"),

(E"数学函数",E"Base",E"lcm",E"lcm(x, y)

   最小公倍数。

"),

(E"数学函数",E"Base",E"gcdx",E"gcdx(x, y)

   Greatest common divisor, also returning integer coefficients \"u\"
   and \"v\" that solve \"ux+vy == gcd(x,y)\"

"),

(E"数学函数",E"Base",E"ispow2",E"ispow2(n)

   Test whether \"n\" is a power of two

"),

(E"数学函数",E"Base",E"nextpow2",E"nextpow2(n)

   Next power of two not less than \"n\"

"),

(E"数学函数",E"Base",E"prevpow2",E"prevpow2(n)

   Previous power of two not greater than \"n\"

"),

(E"数学函数",E"Base",E"nextpow",E"nextpow(a, n)

   Next power of \"a\" not less than \"n\"

"),

(E"数学函数",E"Base",E"prevpow",E"prevpow(a, n)

   Previous power of \"a\" not greater than \"n\"

"),

(E"数学函数",E"Base",E"nextprod",E"nextprod([a, b, c], n)

   Next integer not less than \"n\" that can be written \"a^i1 * b^i2
   * c^i3\" for integers \"i1\", \"i2\", \"i3\".

"),

(E"数学函数",E"Base",E"prevprod",E"prevprod([a, b, c], n)

   Previous integer not greater than \"n\" that can be written \"a^i1
   * b^i2 * c^i3\" for integers \"i1\", \"i2\", \"i3\".

"),

(E"数学函数",E"Base",E"invmod",E"invmod(x, m)

   Inverse of \"x\", modulo \"m\"

"),

(E"数学函数",E"Base",E"powermod",E"powermod(x, p, m)

   计算 \"mod(x^p, m)\" 。

"),

(E"数学函数",E"Base",E"gamma",E"gamma(x)

   计算 \"x\" 的 gamma 函数。

"),

(E"数学函数",E"Base",E"lgamma",E"lgamma(x)

   计算the logarithm of \"gamma(x)\"

"),

(E"数学函数",E"Base",E"lfact",E"lfact(x)

   计算the logarithmic factorial of \"x\"

"),

(E"数学函数",E"Base",E"digamma",E"digamma(x)

   计算the digamma function of \"x\" (the logarithmic derivative of
   \"gamma(x)\")

"),

(E"数学函数",E"Base",E"airyai",E"airy(x)
airyai(x)

   Airy 函数 \\operatorname{Ai}(x).

"),

(E"数学函数",E"Base",E"airyaiprime",E"airyprime(x)
airyaiprime(x)

   Airy 函数 derivative \\operatorname{Ai}'(x).

"),

(E"数学函数",E"Base",E"airybi",E"airybi(x)

   Airy 函数 \\operatorname{Bi}(x).

"),

(E"数学函数",E"Base",E"airybiprime",E"airybiprime(x)

   Airy 函数 derivative \\operatorname{Bi}'(x).

"),

(E"数学函数",E"Base",E"besselj0",E"besselj0(x)

   Bessel 函数 of the first kind of order 0, J_0(x).

"),

(E"数学函数",E"Base",E"besselj1",E"besselj1(x)

   Bessel 函数 of the first kind of order 1, J_1(x).

"),

(E"数学函数",E"Base",E"besselj",E"besselj(nu, x)

   Bessel 函数 of the first kind of order \"nu\", J_\\nu(x).

"),

(E"数学函数",E"Base",E"bessely0",E"bessely0(x)

   Bessel 函数 of the second kind of order 0, Y_0(x).

"),

(E"数学函数",E"Base",E"bessely1",E"bessely1(x)

   Bessel 函数 of the second kind of order 1, Y_1(x).

"),

(E"数学函数",E"Base",E"bessely",E"bessely(nu, x)

   Bessel 函数 of the second kind of order \"nu\", Y_\\nu(x).

"),

(E"数学函数",E"Base",E"hankelh1",E"hankelh1(nu, x)

   Bessel 函数 of the third kind of order \"nu\", H^{(1)}_\\nu(x).

"),

(E"数学函数",E"Base",E"hankelh2",E"hankelh2(nu, x)

   Bessel 函数 of the third kind of order \"nu\", H^{(2)}_\\nu(x).

"),

(E"数学函数",E"Base",E"besseli",E"besseli(nu, x)

   Modified Bessel 函数 of the first kind of order \"nu\", I_\\nu(x).

"),

(E"数学函数",E"Base",E"besselk",E"besselk(nu, x)

   Modified Bessel 函数 of the second kind of order \"nu\", K_\\nu(x).

"),

(E"数学函数",E"Base",E"beta",E"beta(x, y)

   Euler integral of the first kind \\operatorname{B}(x,y) =
   \\Gamma(x)\\Gamma(y)/\\Gamma(x+y).

"),

(E"数学函数",E"Base",E"lbeta",E"lbeta(x, y)

   Natural logarithm of the beta function
   \\log(\\operatorname{B}(x,y)).

"),

(E"数学函数",E"Base",E"eta",E"eta(x)

   Dirichlet eta 函数 \\eta(s) = \\sum^\\infty_{n=1}(-)^{n-1}/n^{s} 。

"),

(E"数学函数",E"Base",E"zeta",E"zeta(x)

   Riemann zeta 函数 \"\\zeta(s)\" 。

"),

(E"数学函数",E"Base",E"bitmix",E"bitmix(x, y)

   Hash two integers into a single integer. Useful for constructing
   hash functions.

"),

(E"数学函数",E"Base",E"ndigits",E"ndigits(n, b)

   计算the number of digits in number \"n\" written in base \"b\".

"),

(E"数据格式",E"Base",E"bin",E"bin(n[, pad])

   Convert an integer to a binary string, optionally specifying a
   number of digits to pad to.

"),

(E"数据格式",E"Base",E"hex",E"hex(n[, pad])

   Convert an integer to a hexadecimal string, optionally specifying a
   number of digits to pad to.

"),

(E"数据格式",E"Base",E"dec",E"dec(n[, pad])

   Convert an integer to a decimal string, optionally specifying a
   number of digits to pad to.

"),

(E"数据格式",E"Base",E"oct",E"oct(n[, pad])

   Convert an integer to an octal string, optionally specifying a
   number of digits to pad to.

"),

(E"数据格式",E"Base",E"base",E"base(b, n[, pad])

   Convert an integer to a string in the given base, optionally
   specifying a number of digits to pad to.

"),

(E"数据格式",E"Base",E"bits",E"bits(n)

   A string giving the literal bit representation of a number.

"),

(E"数据格式",E"Base",E"parse_int",E"parse_int(type, str[, base])

   Parse a string as an integer in the given base (default 10),
   yielding a number of the specified type.

"),

(E"数据格式",E"Base",E"parse_bin",E"parse_bin(type, str)

   Parse a string as an integer in base 2, yielding a number of the
   specified type.

"),

(E"数据格式",E"Base",E"parse_oct",E"parse_oct(type, str)

   Parse a string as an integer in base 8, yielding a number of the
   specified type.

"),

(E"数据格式",E"Base",E"parse_hex",E"parse_hex(type, str)

   Parse a string as an integer in base 16, yielding a number of the
   specified type.

"),

(E"数据格式",E"Base",E"parse_float",E"parse_float(type, str)

   Parse a string as a decimal floating point number, yielding a
   number of the specified type.

"),

(E"数据格式",E"Base",E"bool",E"bool(x)

   Convert a number or numeric array to boolean

"),

(E"数据格式",E"Base",E"isbool",E"isbool(x)

   Test whether number or array is boolean

"),

(E"数据格式",E"Base",E"int",E"int(x)

   Convert a number or array to the default integer type on your
   platform. Alternatively, \"x\" can be a string, which is parsed as
   an integer.

"),

(E"数据格式",E"Base",E"uint",E"uint(x)

   Convert a number or array to the default unsigned integer type on
   your platform. Alternatively, \"x\" can be a string, which is
   parsed as an unsigned integer.

"),

(E"数据格式",E"Base",E"integer",E"integer(x)

   Convert a number or array to integer type. If \"x\" is already of
   integer type it is unchanged, otherwise it converts it to the
   default integer type on your platform.

"),

(E"数据格式",E"Base",E"isinteger",E"isinteger(x)

   Test whether a number or array is of integer type

"),

(E"数据格式",E"Base",E"signed",E"signed(x)

   Convert a number to a signed integer

"),

(E"数据格式",E"Base",E"unsigned",E"unsigned(x)

   Convert a number to an unsigned integer

"),

(E"数据格式",E"Base",E"int8",E"int8(x)

   将数或数组转换为 \"Int8\" 数据类型。

"),

(E"数据格式",E"Base",E"int16",E"int16(x)

   将数或数组转换为 \"Int16\" 数据类型。

"),

(E"数据格式",E"Base",E"int32",E"int32(x)

   将数或数组转换为 \"Int32\" 数据类型。

"),

(E"数据格式",E"Base",E"int64",E"int64(x)

   将数或数组转换为 \"Int64\" 数据类型。

"),

(E"数据格式",E"Base",E"int128",E"int128(x)

   将数或数组转换为 \"Int128\" 数据类型。

"),

(E"数据格式",E"Base",E"uint8",E"uint8(x)

   将数或数组转换为 \"Uint8\" 数据类型。

"),

(E"数据格式",E"Base",E"uint16",E"uint16(x)

   将数或数组转换为 \"Uint16\" 数据类型。

"),

(E"数据格式",E"Base",E"uint32",E"uint32(x)

   将数或数组转换为 \"Uint32\" 数据类型。

"),

(E"数据格式",E"Base",E"uint64",E"uint64(x)

   将数或数组转换为 \"Uint64\" 数据类型。

"),

(E"数据格式",E"Base",E"uint128",E"uint128(x)

   将数或数组转换为 \"Uint128\" 数据类型。

"),

(E"数据格式",E"Base",E"float32",E"float32(x)

   将数或数组转换为 \"Float32\" 数据类型。

"),

(E"数据格式",E"Base",E"float64",E"float64(x)

   将数或数组转换为 \"Float64\" 数据类型。

"),

(E"数据格式",E"Base",E"float",E"float(x)

   Convert a number, array, or string to a \"FloatingPoint\" 数据类型. For
   numeric data, the smallest suitable \"FloatingPoint\" type is used.
   For strings, it converts to \"Float64\".

"),

(E"数据格式",E"Base",E"significand",E"significand(x)

   Extract the significand(s) (a.k.a. mantissa), in binary
   representation, of a floating-point number or array.

   For example, \"significand(15.2)/15.2 == 0.125\", and
   \"significand(15.2)*8 == 15.2\"

"),

(E"数据格式",E"Base",E"float64_valued",E"float64_valued(x::Rational)

   True if \"x\" can be losslessly represented as a \"Float64\" 数据类型

"),

(E"数据格式",E"Base",E"complex64",E"complex64(r, i)

   Convert to \"r+i*im\" represented as a \"Complex64\" 数据类型

"),

(E"数据格式",E"Base",E"complex128",E"complex128(r, i)

   Convert to \"r+i*im\" represented as a \"Complex128\" 数据类型

"),

(E"数据格式",E"Base",E"char",E"char(x)

   将数或数组转换为 \"Char\" 数据类型。

"),

(E"数据格式",E"Base",E"safe_char",E"safe_char(x)

   Convert to \"Char\", checking for invalid code points

"),

(E"数据格式",E"Base",E"complex",E"complex(r, i)

   Convert real numbers or arrays to complex

"),

(E"数据格式",E"Base",E"iscomplex",E"iscomplex(x) -> Bool

   判断数或数组是否为复数类型。

"),

(E"数据格式",E"Base",E"isreal",E"isreal(x) -> Bool

   判断数或数组是否为实数类型。

"),

(E"数据格式",E"Base",E"bswap",E"bswap(n)

   Byte-swap an integer

"),

(E"数据格式",E"Base",E"num2hex",E"num2hex(f)

   Get a hexadecimal string of the binary representation of a floating
   point number

"),

(E"数据格式",E"Base",E"hex2num",E"hex2num(str)

   Convert a hexadecimal string to the floating point number it
   represents

"),

(E"数",E"Base",E"one",E"one(x)

   Get the multiplicative identity element for the type of x (x can
   also specify the type itself). For matrices, returns an identity
   matrix of the appropriate size and type.

"),

(E"数",E"Base",E"zero",E"zero(x)

   Get the additive identity element for the type of x (x can also
   specify the type itself).

"),

(E"数",E"Base",E"pi",E"pi

   常量 pi 。

"),

(E"数",E"Base",E"isdenormal",E"isdenormal(f) -> Bool

   Test whether a floating point number is denormal

"),

(E"数",E"Base",E"isfinite",E"isfinite(f) -> Bool

   判断数是否有限。

"),

(E"数",E"Base",E"isinf",E"isinf(f)

   判断数是否为无穷大或无穷小。

"),

(E"数",E"Base",E"isnan",E"isnan(f)

   判断浮点数是否为非数值（NaN）。

"),

(E"数",E"Base",E"inf",E"inf(f)

   返回infinity in the same floating point type as \"f\" (or \"f\" can
   by the type itself)

"),

(E"数",E"Base",E"nan",E"nan(f)

   返回 NaN in the same floating point type as \"f\" (or \"f\" can by
   the type itself)

"),

(E"数",E"Base",E"nextfloat",E"nextfloat(f)

   Get the next floating point number in lexicographic order

"),

(E"数",E"Base",E"prevfloat",E"prevfloat(f) -> Float

   Get the previous floating point number in lexicographic order

"),

(E"数",E"Base",E"integer_valued",E"integer_valued(x)

   判断 \"x\" 在数值上是否为整数。

"),

(E"数",E"Base",E"real_valued",E"real_valued(x)

   判断 \"x\" 在数值上是否为实数。

"),

(E"数",E"Base",E"exponent",E"exponent(f)

   Get the exponent of a floating-point number

"),

(E"数",E"Base",E"mantissa",E"mantissa(f)

   Get the mantissa of a floating-point number

"),

(E"数",E"Base",E"BigInt",E"BigInt(x)

   构造an arbitrary precision integer. \"x\" may be an \"Int\" (or
   anything that can be converted to an \"Int\") or a \"String\". The
   usual mathematical operators are defined for this type, and results
   are promoted to a \"BigInt\".

"),

(E"数",E"Base",E"BigFloat",E"BigFloat(x)

   构造an arbitrary precision floating point number. \"x\" may be an
   \"Integer\", a \"Float64\", a \"String\" or a \"BigInt\". The usual
   mathematical operators are defined for this type, and results are
   promoted to a \"BigFloat\".

"),

(E"数",E"Base",E"count_ones",E"count_ones(x::Integer) -> Integer

   Number of ones in the binary representation of \"x\".

   **例子** ： \"count_ones(7) -> 3\"

"),

(E"数",E"Base",E"count_zeros",E"count_zeros(x::Integer) -> Integer

   Number of zeros in the binary representation of \"x\".

   **例子** ： \"count_zeros(int32(2 ^ 16 - 1)) -> 16\"

"),

(E"数",E"Base",E"leading_zeros",E"leading_zeros(x::Integer) -> Integer

   Number of zeros leading the binary representation of \"x\".

   **例子** ： \"leading_zeros(int32(1)) -> 31\"

"),

(E"数",E"Base",E"leading_ones",E"leading_ones(x::Integer) -> Integer

   Number of ones leading the binary representation of \"x\".

   **例子** ： \"leading_ones(int32(2 ^ 32 - 2)) -> 31\"

"),

(E"数",E"Base",E"trailing_zeros",E"trailing_zeros(x::Integer) -> Integer

   Number of zeros trailing the binary representation of \"x\".

   **例子** ： \"trailing_zeros(2) -> 1\"

"),

(E"数",E"Base",E"trailing_ones",E"trailing_ones(x::Integer) -> Integer

   Number of ones trailing the binary representation of \"x\".

   **例子** ： \"trailing_ones(3) -> 2\"

"),

(E"数",E"Base",E"isprime",E"isprime(x::Integer) -> Bool

   返回``true`` if \"x\" is prime, and \"false\" otherwise.

   **例子** ： \"isprime(3) -> true\"

"),

(E"数",E"Base",E"isodd",E"isodd(x::Integer) -> Bool

   返回``true`` if \"x\" is odd (that is, not divisible by 2), and
   \"false\" otherwise.

   **例子** ： \"isodd(9) -> false\"

"),

(E"数",E"Base",E"iseven",E"iseven(x::Integer) -> Bool

   返回``true`` is \"x\" is even (that is, divisible by 2), and
   \"false\" otherwise.

   **例子** ： \"iseven(1) -> false\"

"),

(E"随机数",E"Base",E"srand",E"srand([rng], seed)

   Seed the RNG with a \"seed\", which may be an unsigned integer or a
   vector of unsigned integers. \"seed\" can even be a filename, in
   which case the seed is read from a file. If the argument \"rng\" is
   not provided, the default global RNG is seeded.

"),

(E"随机数",E"Base",E"MersenneTwister",E"MersenneTwister([seed])

   构造a \"MersenneTwister\" RNG object. Different RNG objects can have
   their own seeds, which may be useful for generating different
   streams of random numbers.

"),

(E"随机数",E"Base",E"rand",E"rand()

   生成 (0,1) 内的 \"Float64\" 随机数。

"),

(E"随机数",E"Base",E"rand!",E"rand!([rng], A)

   Populate the array A with random number generated from the
   specified RNG.

"),

(E"随机数",E"Base",E"rand",E"rand(rng::AbstractRNG[, dims...])

   Generate a random \"Float64\" number or array of the size specified
   by dims, using the specified RNG object. Currently,
   \"MersenneTwister\" is the only available Random Number Generator
   (RNG), which may be seeded using srand.

"),

(E"随机数",E"Base",E"rand",E"rand(dims...)

   Generate a random \"Float64\" array of the size specified by dims

"),

(E"随机数",E"Base",E"rand",E"rand(Int32|Uint32|Int64|Uint64|Int128|Uint128[, dims...])

   Generate a random integer of the given type. Optionally, generate
   an array of random integers of the given type by specifying dims.

"),

(E"随机数",E"Base",E"rand",E"rand(r[, dims...])

   Generate a random integer from \"1\":\"n\" inclusive. Optionally,
   generate a random integer array.

"),

(E"随机数",E"Base",E"randbool",E"randbool([dims...])

   Generate a random boolean value. Optionally, generate an array of
   random boolean values.

"),

(E"随机数",E"Base",E"randbool!",E"randbool!(A)

   Fill an array with random boolean values. A may be an \"Array\" or
   a \"BitArray\".

"),

(E"随机数",E"Base",E"randn",E"randn([dims...])

   Generate a normally-distributed random number with mean 0 and
   standard deviation 1. Optionally generate an array of normally-
   distributed random numbers.

"),

(E"数组",E"Base",E"ndims",E"ndims(A) -> Integer

   返回 A 有几个维度。

"),

(E"数组",E"Base",E"size",E"size(A)

   返回 A 的维度多元组。

"),

(E"数组",E"Base",E"eltype",E"eltype(A)

   返回 A 中元素的类型。

"),

(E"数组",E"Base",E"length",E"length(A) -> Integer

   返回the number of elements in A (note that this differs from MATLAB
   where \"length(A)\" is the largest dimension of \"A\")

"),

(E"数组",E"Base",E"nnz",E"nnz(A)

   A 中非零元素的个数。

"),

(E"数组",E"Base",E"scale!",E"scale!(A, k)

   Scale the contents of an array A with k (in-place)

"),

(E"数组",E"Base",E"conj!",E"conj!(A)

   Convert an array to its complex conjugate in-place

"),

(E"数组",E"Base",E"stride",E"stride(A, k)

   返回the distance in memory (in number of elements) between adjacent
   elements in dimension k

"),

(E"数组",E"Base",E"strides",E"strides(A)

   返回a tuple of the memory strides in each dimension

"),

(E"数组",E"Base",E"Array",E"Array(type, dims)

   构造an uninitialized dense array. \"dims\" may be a tuple or a series
   of integer arguments.

"),

(E"数组",E"Base",E"ref",E"ref(type)

   构造an empty 1-d array of the specified type. This is usually called
   with the syntax \"Type[]\". Element values can be specified using
   \"Type[a,b,c,...]\".

"),

(E"数组",E"Base",E"cell",E"cell(dims)

   构造an uninitialized cell array (heterogeneous array). \"dims\" can
   be either a tuple or a series of integer arguments.

"),

(E"数组",E"Base",E"zeros",E"zeros(type, dims)

   构造指定类型的全零数组。

"),

(E"数组",E"Base",E"ones",E"ones(type, dims)

   构造指定类型的全一数组。

"),

(E"数组",E"Base",E"trues",E"trues(dims)

   构造元素全为真的布尔值数组。

"),

(E"数组",E"Base",E"falses",E"falses(dims)

   构造元素全为假的布尔值数组。

"),

(E"数组",E"Base",E"fill",E"fill(v, dims)

   构造数组，元素都初始化为 \"v\" 。

"),

(E"数组",E"Base",E"fill!",E"fill!(A, x)

   将数组 \"A\" 的元素都改为 \"x\" 。

"),

(E"数组",E"Base",E"reshape",E"reshape(A, dims)

   构造an array with the same data as the given array, but with
   different dimensions. An implementation for a particular type of
   array may choose whether the data is copied or shared.

"),

(E"数组",E"Base",E"copy",E"copy(A)

   构造a copy of \"A\"

"),

(E"数组",E"Base",E"similar",E"similar(array, element_type, dims)

   构造an uninitialized array of the same type as the given array, but
   with the specified element type and dimensions. The second and
   third arguments are both optional. The \"dims\" argument may be a
   tuple or a series of integer arguments.

"),

(E"数组",E"Base",E"reinterpret",E"reinterpret(type, A)

   构造an array with the same binary data as the given array, but with
   the specified element type

"),

(E"数组",E"Base",E"rand",E"rand(dims)

   构造a random array with Float64 random values in (0,1)

"),

(E"数组",E"Base",E"randf",E"randf(dims)

   构造a random array with Float32 random values in (0,1)

"),

(E"数组",E"Base",E"randn",E"randn(dims)

   构造a random array with Float64 normally-distributed random values
   with a mean of 0 and standard deviation of 1

"),

(E"数组",E"Base",E"eye",E"eye(n)

   n x n 单位矩阵。

"),

(E"数组",E"Base",E"eye",E"eye(m, n)

   m x n 单位矩阵。

"),

(E"数组",E"Base",E"linspace",E"linspace(start, stop, n)

   构造a vector of \"n\" linearly-spaced elements from \"start\" to
   \"stop\".

"),

(E"数组",E"Base",E"logspace",E"logspace(start, stop, n)

   构造a vector of \"n\" logarithmically-spaced numbers from
   \"10^start\" to \"10^stop\".

"),

(E"数组",E"Base",E"bsxfun",E"bsxfun(fn, A, B[, C...])

   对两个或两个以上的数组使用二元函数 \"fn\" ，它会展开单态的维度。

"),

(E"数组",E"Base",E"ref",E"ref(A, ind)

   返回a subset of \"A\" as specified by \"ind\", 结果可能是 \"Int\",
   \"Range\", 或 \"Vector\" 。

"),

(E"数组",E"Base",E"sub",E"sub(A, ind)

   返回a SubArray, which stores the input \"A\" and \"ind\" rather than
   computing the result immediately. Calling \"ref\" on a SubArray
   computes the indices on the fly.

"),

(E"数组",E"Base",E"slicedim",E"slicedim(A, d, i)

   返回all the data of \"A\" where the index for dimension \"d\" equals
   \"i\". Equivalent to \"A[:,:,...,i,:,:,...]\" where \"i\" is in
   position \"d\".

"),

(E"数组",E"Base",E"assign",E"assign(A, X, ind)

   Store an input array \"X\" within some subset of \"A\" as specified
   by \"ind\".

"),

(E"数组",E"Base",E"cat",E"cat(dim, A...)

   Concatenate the input arrays along the specified dimension

"),

(E"数组",E"Base",E"vcat",E"vcat(A...)

   在维度 1 上连接。

"),

(E"数组",E"Base",E"hcat",E"hcat(A...)

   在维度 2 上连接。

"),

(E"数组",E"Base",E"hvcat",E"hvcat()

   Horizontal and vertical concatenation in one call

"),

(E"数组",E"Base",E"flipdim",E"flipdim(A, d)

   Reverse \"A\" in dimension \"d\".

"),

(E"数组",E"Base",E"flipud",E"flipud(A)

   等价于 \"flipdim(A,1)\" 。

"),

(E"数组",E"Base",E"fliplr",E"fliplr(A)

   等价于 \"flipdim(A,2)\" 。

"),

(E"数组",E"Base",E"circshift",E"circshift(A, shifts)

   Circularly shift the data in an array. The second argument is a
   vector giving the amount to shift in each dimension.

"),

(E"数组",E"Base",E"find",E"find(A)

   返回a vector of the linear indexes of the non-zeros in \"A\".

"),

(E"数组",E"Base",E"findn",E"findn(A)

   返回a vector of indexes for each dimension giving the locations of
   the non-zeros in \"A\".

"),

(E"数组",E"Base",E"nonzeros",E"nonzeros(A)

   Return a vector of the non-zero values in array \"A\".

"),

(E"数组",E"Base",E"findfirst",E"findfirst(A)

   Return the index of the first non-zero value in \"A\".

"),

(E"数组",E"Base",E"findfirst",E"findfirst(A, v)

   Return the index of the first element equal to \"v\" in \"A\".

"),

(E"数组",E"Base",E"findfirst",E"findfirst(predicate, A)

   Return the index of the first element that satisfies the given
   predicate in \"A\".

"),

(E"数组",E"Base",E"permutedims",E"permutedims(A, perm)

   Permute the dimensions of array \"A\". \"perm\" is a vector
   specifying a permutation of length \"ndims(A)\". This is a
   generalization of transpose for multi-dimensional arrays. Transpose
   is equivalent to \"permute(A,[2,1])\".

"),

(E"数组",E"Base",E"ipermutedims",E"ipermutedims(A, perm)

   Like \"permutedims()\", except the inverse of the given permutation
   is applied.

"),

(E"数组",E"Base",E"squeeze",E"squeeze(A, dims)

   移除the dimensions specified by \"dims\" from array \"A\"

"),

(E"数组",E"Base",E"vec",E"vec(Array) -> Vector

   Vectorize an array using column-major convention.

"),

(E"数组",E"Base",E"cumprod",E"cumprod(A[, dim])

   Cumulative product along a dimension.

"),

(E"数组",E"Base",E"cumsum",E"cumsum(A[, dim])

   Cumulative sum along a dimension.

"),

(E"数组",E"Base",E"cumsum_kbn",E"cumsum_kbn(A[, dim])

   Cumulative sum along a dimension, using the Kahan-Babuska-Neumaier
   compensated summation algorithm for additional accuracy.

"),

(E"数组",E"Base",E"cummin",E"cummin(A[, dim])

   Cumulative minimum along a dimension.

"),

(E"数组",E"Base",E"cummax",E"cummax(A[, dim])

   Cumulative maximum along a dimension.

"),

(E"数组",E"Base",E"diff",E"diff(A[, dim])

   Finite difference operator of matrix or vector.

"),

(E"数组",E"Base",E"rot180",E"rot180(A)

   Rotate matrix \"A\" 180 degrees.

"),

(E"数组",E"Base",E"rotl90",E"rotl90(A)

   Rotate matrix \"A\" left 90 degrees.

"),

(E"数组",E"Base",E"rotr90",E"rotr90(A)

   Rotate matrix \"A\" right 90 degrees.

"),

(E"数组",E"Base",E"reducedim",E"reducedim(f, A, dims, initial)

   Reduce 2-argument function \"f\" along dimensions of \"A\".
   \"dims\" is a vector specifying the dimensions to reduce, and
   \"initial\" is the initial value to use in the reductions.

"),

(E"数组",E"Base",E"sum_kbn",E"sum_kbn(A)

   Returns the sum of all array elements, using the Kahan-Babuska-
   Neumaier compensated summation algorithm for additional accuracy.

"),

(E"稀疏矩阵",E"Base",E"sparse",E"sparse(I, J, V[, m, n, combine])

   构造a sparse matrix \"S\" of dimensions \"m x n\" such that \"S[I[k],
   J[k]] = V[k]\". The \"combine\" function is used to combine
   duplicates. If \"m\" and \"n\" are not specified, they are set to
   \"max(I)\" and \"max(J)\" respectively. If the \"combine\" function
   is not supplied, duplicates are added by default.

"),

(E"稀疏矩阵",E"Base",E"sparsevec",E"sparsevec(I, V[, m, combine])

   构造a sparse matrix \"S\" of size \"m x 1\" such that \"S[I[k]] =
   V[k]\". Duplicates are combined using the \"combine\" function,
   which defaults to *+* if it is not provided. In julia, sparse
   vectors are really just sparse matrices with one column. Given
   Julia's Compressed Sparse Columns (CSC) storage format, a sparse
   column matrix with one column is sparse, whereas a sparse row
   matrix with one row ends up being dense.

"),

(E"稀疏矩阵",E"Base",E"sparsevec",E"sparsevec(D::Dict[, m])

   构造a sparse matrix of size \"m x 1\" where the row values are keys
   from the dictionary, and the nonzero values are the values from the
   dictionary.

"),

(E"稀疏矩阵",E"Base",E"issparse",E"issparse(S)

   返回 \"true\" if \"S\" is sparse, 否则为 \"false\" 。

"),

(E"稀疏矩阵",E"Base",E"nnz",E"nnz(S)

   返回the number of nonzeros in \"S\".

"),

(E"稀疏矩阵",E"Base",E"sparse",E"sparse(A)

   将稠密矩阵 \"A\" 转换为稀疏矩阵。

"),

(E"稀疏矩阵",E"Base",E"sparsevec",E"sparsevec(A)

   将稠密矩阵 \"A\" 转换为 \"m x 1\" 的稀疏矩阵。在 Julia 中，稀疏向量是只有一列的稀疏矩阵。

"),

(E"稀疏矩阵",E"Base",E"dense",E"dense(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

(E"稀疏矩阵",E"Base",E"full",E"full(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

(E"稀疏矩阵",E"Base",E"spzeros",E"spzeros(m, n)

   构造 \"m x n\" 的空稀疏矩阵。

"),

(E"稀疏矩阵",E"Base",E"speye",E"speye(type, m[, n])

   构造a sparse identity matrix of specified type of size \"m x m\". In
   case \"n\" is supplied, create a sparse identity matrix of size \"m
   x n\".

"),

(E"稀疏矩阵",E"Base",E"spones",E"spones(S)

   构造a sparse matrix with the same structure as that of \"S\", but
   with every nonzero element having the value \"1.0\".

"),

(E"稀疏矩阵",E"Base",E"sprand",E"sprand(m, n, density[, rng])

   构造a random sparse matrix with the specified density. Nonzeros are
   sampled from the distribution specified by \"rng\". The uniform
   distribution is used in case \"rng\" is not specified.

"),

(E"稀疏矩阵",E"Base",E"sprandn",E"sprandn(m, n, density)

   构造a random sparse matrix of specified density with nonzeros sampled
   from the normal distribution.

"),

(E"稀疏矩阵",E"Base",E"sprandbool",E"sprandbool(m, n, density)

   构造a random sparse boolean matrix with the specified density.

"),

(E"线性代数",E"Base",E"*",E"*()

   矩阵乘法。

"),

(E"线性代数",E"Base",E"\\",E"\\()

   Matrix division using a polyalgorithm. For input matrices \"A\" and
   \"B\", the result \"X\" is such that \"A*X == B\". For rectangular
   \"A\", QR factorization is used. For triangular \"A\", a triangular
   solve is performed. For square \"A\", Cholesky factorization is
   tried if the input is symmetric with a heavy diagonal. LU
   factorization is used in case Cholesky factorization fails or for
   general square inputs. If \"size(A,1) > size(A,2)\", the result is
   a least squares solution of \"A*X+eps=B\" using the singular value
   decomposition. \"A\" does not need to have full rank.

"),

(E"线性代数",E"Base",E"dot",E"dot()

   计算点积。

"),

(E"线性代数",E"Base",E"cross",E"cross()

   计算the cross product of two 3-vectors

"),

(E"线性代数",E"Base",E"norm",E"norm()

   计算 \"Vector\" 或 \"Matrix\" 的模。

"),

(E"线性代数",E"Base",E"factors",E"factors(F)

   返回the factors of a factorization \"F\". For example, in the case of
   an LU decomposition, factors(LU) -> L, U, P

"),

(E"线性代数",E"Base",E"lu",E"lu(A) -> L, U, P

   计算the LU factorization of \"A\", such that \"A[P,:] = L*U\".

"),

(E"线性代数",E"Base",E"lufact",E"lufact(A) -> LUDense

   计算the LU factorization of \"A\" and return a \"LUDense\" object.
   \"factors(lufact(A))\" returns the triangular matrices containing
   the factorization. The following functions are available for
   \"LUDense\" objects: \"size\", \"factors\", \"\\\", \"inv\",
   \"det\".

"),

(E"线性代数",E"Base",E"lufact!",E"lufact!(A) -> LUDense

   \"lufact!\" 与 \"lufact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

(E"线性代数",E"Base",E"chol",E"chol(A[, LU]) -> F

   计算Cholesky factorization of a symmetric positive-definite matrix
   \"A\" and return the matrix \"F\". If \"LU\" is \"L\" (Lower), \"A
   = L*L'\". If \"LU\" is \"U\" (Upper), \"A = R'*R\".

"),

(E"线性代数",E"Base",E"cholfact",E"cholfact(A[, LU]) -> CholeskyDense

   计算the Cholesky factorization of a symmetric positive-definite
   matrix \"A\" and return a \"CholeskyDense\" object. \"LU\" may be
   'L' for using the lower part or 'U' for the upper part. The default
   is to use 'U'. \"factors(cholfact(A))\" returns the triangular
   matrix containing the factorization. The following functions are
   available for \"CholeskyDense\" objects: \"size\", \"factors\",
   \"\\\", \"inv\", \"det\". A \"LAPACK.PosDefException\" error is
   thrown in case the matrix is not positive definite.

"),

(E"线性代数",E"Base",E"cholpfact",E"cholpfact(A[, LU]) -> CholeskyPivotedDense

   计算the pivoted Cholesky factorization of a symmetric positive semi-
   definite matrix \"A\" and return a \"CholeskyDensePivoted\" object.
   \"LU\" may be 'L' for using the lower part or 'U' for the upper
   part. The default is to use 'U'. \"factors(cholpfact(A))\" returns
   the triangular matrix containing the factorization. The following
   functions are available for \"CholeskyDensePivoted\" objects:
   \"size\", \"factors\", \"\\\", \"inv\", \"det\". A
   \"LAPACK.RankDeficientException\" error is thrown in case the
   matrix is rank deficient.

"),

(E"线性代数",E"Base",E"cholpfact!",E"cholpfact!(A[, LU]) -> CholeskyPivotedDense

   \"cholpfact!\" 与 \"cholpfact\" 相同，but saves space by overwriting
   the input A, instead of creating a copy.

"),

(E"线性代数",E"Base",E"qr",E"qr(A) -> Q, R

   计算the QR factorization of \"A\" such that \"A = Q*R\". Also see
   \"qrd\".

"),

(E"线性代数",E"Base",E"qrfact",E"qrfact(A)

   计算the QR factorization of \"A\" and return a \"QRDense\" object.
   \"factors(qrfact(A))\" returns \"Q\" and \"R\". The following
   functions are available for \"QRDense\" objects: \"size\",
   \"factors\", \"qmulQR\", \"qTmulQR\", \"\\\".

"),

(E"线性代数",E"Base",E"qrfact!",E"qrfact!(A)

   \"qrfact!\" 与 \"qrfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

(E"线性代数",E"Base",E"qrp",E"qrp(A) -> Q, R, P

   计算the QR factorization of \"A\" with pivoting, such that \"A*I[:,P]
   = Q*R\", where \"I\" is the identity matrix. Also see \"qrpfact\".

"),

(E"线性代数",E"Base",E"qrpfact",E"qrpfact(A) -> QRPivotedDense

   计算the QR factorization of \"A\" with pivoting and return a
   \"QRDensePivoted\" object. \"factors(qrpfact(A))\" returns \"Q\"
   and \"R\". The following functions are available for
   \"QRDensePivoted\" objects: \"size\", \"factors\", \"qmulQR\",
   \"qTmulQR\", \"\\\".

"),

(E"线性代数",E"Base",E"qrpfact!",E"qrpfact!(A) -> QRPivotedDense

   \"qrpfact!\" 与 \"qrpfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

(E"线性代数",E"Base",E"qmulQR",E"qmulQR(QR, A)

   Perform Q*A efficiently, where Q is a an orthogonal matrix defined
   as the product of k elementary reflectors from the QR
   decomposition.

"),

(E"线性代数",E"Base",E"qTmulQR",E"qTmulQR(QR, A)

   Perform \"Q'*A\" efficiently, where Q is a an orthogonal matrix
   defined as the product of k elementary reflectors from the QR
   decomposition.

"),

(E"线性代数",E"Base",E"sqrtm",E"sqrtm(A)

   计算the matrix square root of \"A\". If \"B = sqrtm(A)\", then \"B*B
   == A\" within roundoff error.

"),

(E"线性代数",E"Base",E"eig",E"eig(A) -> D, V

   计算 \"A\" 的特征值和特征向量。

"),

(E"线性代数",E"Base",E"eigvals",E"eigvals(A)

   返回  \"A\" 的特征值。

"),

(E"线性代数",E"Base",E"svdfact",E"svdfact(A[, thin]) -> SVDDense

   计算the Singular Value Decomposition (SVD) of \"A\" and return an
   \"SVDDense\" object. \"factors(svdfact(A))\" returns \"U\", \"S\",
   and \"Vt\", such that \"A = U*diagm(S)*Vt\". If \"thin\" is
   \"true\", an economy mode decomposition is returned.

"),

(E"线性代数",E"Base",E"svdfact!",E"svdfact!(A[, thin]) -> SVDDense

   \"svdfact!\" 与 \"svdfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy. If \"thin\" is \"true\", an
   economy mode decomposition is returned.

"),

(E"线性代数",E"Base",E"svd",E"svd(A[, thin]) -> U, S, V

   计算the SVD of A, returning \"U\", vector \"S\", and \"V\" such that
   \"A == U*diagm(S)*V'\". If \"thin\" is \"true\", an economy mode
   decomposition is returned.

"),

(E"线性代数",E"Base",E"svdt",E"svdt(A[, thin]) -> U, S, Vt

   计算the SVD of A, returning \"U\", vector \"S\", and \"Vt\" such that
   \"A = U*diagm(S)*Vt\". If \"thin\" is \"true\", an economy mode
   decomposition is returned.

"),

(E"线性代数",E"Base",E"svdvals",E"svdvals(A)

   返回the singular values of \"A\".

"),

(E"线性代数",E"Base",E"svdvals!",E"svdvals!(A)

   返回the singular values of \"A\", while saving space by overwriting
   the input.

"),

(E"线性代数",E"Base",E"svdfact",E"svdfact(A, B) -> GSVDDense

   计算the generalized SVD of \"A\" and \"B\", returning a \"GSVDDense\"
   Factorization object. \"factors(svdfact(A,b))\" returns \"U\",
   \"V\", \"Q\", \"D1\", \"D2\", and \"R0\" such that \"A =
   U*D1*R0*Q'\" and \"B = V*D2*R0*Q'\".

"),

(E"线性代数",E"Base",E"svd",E"svd(A, B) -> U, V, Q, D1, D2, R0

   计算the generalized SVD of \"A\" and \"B\", returning \"U\", \"V\",
   \"Q\", \"D1\", \"D2\", and \"R0\" such that \"A = U*D1*R0*Q'\" and
   \"B = V*D2*R0*Q'\".

"),

(E"线性代数",E"Base",E"svdvals",E"svdvals(A, B)

   返回only the singular values from the generalized singular value
   decomposition of \"A\" and \"B\".

"),

(E"线性代数",E"Base",E"triu",E"triu(M)

   矩阵上三角。

"),

(E"线性代数",E"Base",E"tril",E"tril(M)

   矩阵下三角。

"),

(E"线性代数",E"Base",E"diag",E"diag(M[, k])

   The \"k\"-th diagonal of a matrix, as a vector

"),

(E"线性代数",E"Base",E"diagm",E"diagm(v[, k])

   构造a diagonal matrix and place \"v\" on the \"k\"-th diagonal

"),

(E"线性代数",E"Base",E"diagmm",E"diagmm(matrix, vector)

   Multiply matrices, interpreting the vector argument as a diagonal
   matrix. The arguments may occur in the other order to multiply with
   the diagonal matrix on the left.

"),

(E"线性代数",E"Base",E"Tridiagonal",E"Tridiagonal(dl, d, du)

   构造a tridiagonal matrix from the lower diagonal, diagonal, and upper
   diagonal

"),

(E"线性代数",E"Base",E"Woodbury",E"Woodbury(A, U, C, V)

   构造a matrix in a form suitable for applying the Woodbury matrix
   identity

"),

(E"线性代数",E"Base",E"rank",E"rank(M)

   计算矩阵的秩。

"),

(E"线性代数",E"Base",E"norm",E"norm(A[, p])

   计算the \"p\"-norm of a vector or a matrix. \"p\" is \"2\" by
   default, if not provided. If \"A\" is a vector, \"norm(A, p)\"
   computes the \"p\"-norm. \"norm(A, Inf)\" returns the largest value
   in \"abs(A)\", whereas \"norm(A, -Inf)\" returns the smallest. If
   \"A\" is a matrix, valid values for \"p\" are \"1\", \"2\", or
   \"Inf\". In order to compute the Frobenius norm, use \"normfro\".

"),

(E"线性代数",E"Base",E"normfro",E"normfro(A)

   计算the Frobenius norm of a matrix \"A\".

"),

(E"线性代数",E"Base",E"cond",E"cond(M[, p])

   Matrix condition number, computed using the p-norm. \"p\" 如果省略，默认为
   2 。 \"p\" 的有效值为 \"1\", \"2\", 和 \"Inf\".

"),

(E"线性代数",E"Base",E"trace",E"trace(M)

   矩阵的迹。

"),

(E"线性代数",E"Base",E"det",E"det(M)

   矩阵的行列式。

"),

(E"线性代数",E"Base",E"inv",E"inv(M)

   矩阵的逆。

"),

(E"线性代数",E"Base",E"pinv",E"pinv(M)

   Moore-Penrose inverse

"),

(E"线性代数",E"Base",E"null",E"null(M)

   Basis for null space of M.

"),

(E"线性代数",E"Base",E"repmat",E"repmat(A, n, m)

   构造a matrix by repeating the given matrix \"n\" times in dimension 1
   and \"m\" times in dimension 2.

"),

(E"线性代数",E"Base",E"kron",E"kron(A, B)

   Kronecker tensor product of two vectors or two matrices.

"),

(E"线性代数",E"Base",E"linreg",E"linreg(x, y)

   Determine parameters \"[a, b]\" that minimize the squared error
   between \"y\" and \"a+b*x\".

"),

(E"线性代数",E"Base",E"linreg",E"linreg(x, y, w)

   Weighted least-squares linear regression.

"),

(E"线性代数",E"Base",E"expm",E"expm(A)

   Matrix exponential.

"),

(E"线性代数",E"Base",E"issym",E"issym(A)

   判断是否为对称矩阵。

"),

(E"线性代数",E"Base",E"isposdef",E"isposdef(A)

   判断是否为正定矩阵。

"),

(E"线性代数",E"Base",E"istril",E"istril(A)

   判断是否为下三角矩阵。

"),

(E"线性代数",E"Base",E"istriu",E"istriu(A)

   判断是否为上三角矩阵。

"),

(E"线性代数",E"Base",E"ishermitian",E"ishermitian(A)

   判断是否为 Hamilton 矩阵。

"),

(E"线性代数",E"Base",E"transpose",E"transpose(A)

   转置运算符（ \".'\" ）。

"),

(E"线性代数",E"Base",E"ctranspose",E"ctranspose(A)

   共轭转置运算符（ \"'\" ）。

"),

(E"排列组合",E"Base",E"nthperm",E"nthperm(v, k)

   计算the kth lexicographic permutation of a vector.

"),

(E"排列组合",E"Base",E"nthperm!",E"nthperm!(v, k)

   \"nthperm()\" 的原地版本。

"),

(E"排列组合",E"Base",E"randperm",E"randperm(n)

   构造a random permutation of the given length.

"),

(E"排列组合",E"Base",E"invperm",E"invperm(v)

   返回the inverse permutation of v.

"),

(E"排列组合",E"Base",E"isperm",E"isperm(v) -> Bool

   返回true if v is a valid permutation.

"),

(E"排列组合",E"Base",E"permute!",E"permute!(v, p)

   Permute vector \"v\" in-place, according to permutation \"p\".  No
   checking is done to verify that \"p\" is a permutation.

   To return a new permutation, use \"v[p]\".  Note that this is
   generally faster than \"permute!(v,p)\" for large vectors.

"),

(E"排列组合",E"Base",E"ipermute!",E"ipermute!(v, p)

   Like permute!, but the inverse of the given permutation is applied.

"),

(E"排列组合",E"Base",E"randcycle",E"randcycle(n)

   构造a random cyclic permutation of the given length.

"),

(E"排列组合",E"Base",E"shuffle",E"shuffle(v)

   Randomly rearrange the elements of a vector.

"),

(E"排列组合",E"Base",E"shuffle!",E"shuffle!(v)

   \"shuffle()\" 的原地版本。

"),

(E"排列组合",E"Base",E"reverse",E"reverse(v)

   Reverse vector \"v\".

"),

(E"排列组合",E"Base",E"reverse!",E"reverse!(v) -> v

   \"reverse()\" 的原地版本。

"),

(E"排列组合",E"Base",E"combinations",E"combinations(array, n)

   Generate all combinations of \"n\" elements from a given array.
   Because the number of combinations can be very large, this function
   runs inside a Task to produce values on demand. Write \"c = @task
   combinations(a,n)\", then iterate \"c\" or call \"consume\" on it.

"),

(E"排列组合",E"Base",E"integer_partitions",E"integer_partitions(n, m)

   Generate all arrays of \"m\" integers that sum to \"n\". Because
   the number of partitions can be very large, this function runs
   inside a Task to produce values on demand. Write \"c = @task
   integer_partitions(n,m)\", then iterate \"c\" or call \"consume\"
   on it.

"),

(E"排列组合",E"Base",E"partitions",E"partitions(array)

   Generate all set partitions of the elements of an array,
   represented as arrays of arrays. Because the number of partitions
   can be very large, this function runs inside a Task to produce
   values on demand. Write \"c = @task partitions(a)\", then iterate
   \"c\" or call \"consume\" on it.

"),

(E"统计",E"Base",E"mean",E"mean(v[, dim])

   计算the mean of whole array \"v\", or optionally along dimension
   \"dim\"

"),

(E"统计",E"Base",E"std",E"std(v[, corrected])

   计算the sample standard deviation of a vector \"v\". If the optional
   argument \"corrected\" is either left unspecified or is explicitly
   set to the default value of \"true\", then the algorithm will
   return an estimator of the generative distribution's standard
   deviation under the assumption that each entry of \"v\" is an IID
   draw from that generative distribution. This computation is
   equivalent to calculating \"sqrt(sum((v .- mean(v)).^2) /
   (length(v) - 1))\" and involves an implicit correction term
   sometimes called the Bessel correction which insures that the
   estimator of the variance is unbiased. If, instead, the optional
   argument \"corrected\" is set to \"false\", then the algorithm will
   produce the equivalent of \"sqrt(sum((v .- mean(v)).^2) /
   length(v))\", which is the empirical standard deviation of the
   sample.

"),

(E"统计",E"Base",E"std",E"std(v, m[, corrected])

   计算the sample standard deviation of a vector \"v\" with known mean
   \"m\". If the optional argument \"corrected\" is either left
   unspecified or is explicitly set to the default value of \"true\",
   then the algorithm will return an estimator of the generative
   distribution's standard deviation under the assumption that each
   entry of \"v\" is an IID draw from that generative distribution.
   This computation is equivalent to calculating \"sqrt(sum((v .-
   m).^2) / (length(v) - 1))\" and involves an implicit correction
   term sometimes called the Bessel correction which insures that the
   estimator of the variance is unbiased. If, instead, the optional
   argument \"corrected\" is set to \"false\", then the algorithm will
   produce the equivalent of \"sqrt(sum((v .- m).^2) / length(v))\",
   which is the empirical standard deviation of the sample.

"),

(E"统计",E"Base",E"var",E"var(v[, corrected])

   计算the sample variance of a vector \"v\". If the optional argument
   \"corrected\" is either left unspecified or is explicitly set to
   the default value of \"true\", then the algorithm will return an
   unbiased estimator of the generative distribution's variance under
   the assumption that each entry of \"v\" is an IID draw from that
   generative distribution. This computation is equivalent to
   calculating \"sum((v .- mean(v)).^2) / (length(v) - 1)\" and
   involves an implicit correction term sometimes called the Bessel
   correction. If, instead, the optional argument \"corrected\" is set
   to \"false\", then the algorithm will produce the equivalent of
   \"sum((v .- mean(v)).^2) / length(v)\", which is the empirical
   variance of the sample.

"),

(E"统计",E"Base",E"var",E"var(v, m[, corrected])

   计算the sample variance of a vector \"v\" with known mean \"m\". If
   the optional argument \"corrected\" is either left unspecified or
   is explicitly set to the default value of \"true\", then the
   algorithm will return an unbiased estimator of the generative
   distribution's variance under the assumption that each entry of
   \"v\" is an IID draw from that generative distribution. This
   computation is equivalent to calculating \"sum((v .- m)).^2) /
   (length(v) - 1)\" and involves an implicit correction term
   sometimes called the Bessel correction. If, instead, the optional
   argument \"corrected\" is set to \"false\", then the algorithm will
   produce the equivalent of \"sum((v .- m)).^2) / length(v)\", which
   is the empirical variance of the sample.

"),

(E"统计",E"Base",E"median",E"median(v)

   计算the median of a vector \"v\"

"),

(E"统计",E"Base",E"hist",E"hist(v[, n])

   计算the histogram of \"v\", optionally using \"n\" bins

"),

(E"统计",E"Base",E"hist",E"hist(v, e)

   计算the histogram of \"v\" using a vector \"e\" as the edges for the
   bins

"),

(E"统计",E"Base",E"quantile",E"quantile(v, p)

   计算the quantiles of a vector \"v\" at a specified set of probability
   values \"p\".

"),

(E"统计",E"Base",E"quantile",E"quantile(v)

   计算the quantiles of a vector \"v\" at the probability values \"[.0,
   .2, .4, .6, .8, 1.0]\".

"),

(E"统计",E"Base",E"cov",E"cov(v)

   计算the Pearson covariance between two vectors \"v1\" and \"v2\".

"),

(E"统计",E"Base",E"cor",E"cor(v)

   计算the Pearson correlation between two vectors \"v1\" and \"v2\".

"),

(E"信号处理",E"Base",E"fft",E"fft(A[, dims])

   Performs a multidimensional FFT of the array \"A\".  The optional
   \"dims\" argument specifies an iterable subset of dimensions (e.g.
   an integer, range, tuple, or array) to transform along.  Most
   efficient if the size of \"A\" along the transformed dimensions is
   a product of small primes; see \"nextprod()\".  See also
   \"plan_fft()\" for even greater efficiency.

   A one-dimensional FFT computes the one-dimensional discrete Fourier
   transform (DFT) as defined by \\operatorname{DFT}[k] =
   \\sum_{n=1}^{\\operatorname{length}(A)} \\exp\\left(-i\\frac{2\\pi
   (n-1)(k-1)}{\\operatorname{length}(A)} \\right) A[n].  A
   multidimensional FFT simply performs this operation along each
   transformed dimension of \"A\".

"),

(E"信号处理",E"Base",E"fft!",E"fft!(A[, dims])

   与 \"fft()\" 相同，but operates in-place on \"A\", which must be an
   array of complex floating-point numbers.

"),

(E"信号处理",E"",E"ifft(A [, dims]), bfft, bfft!",E"ifft(A [, dims]), bfft, bfft!

   Multidimensional inverse FFT.

   A one-dimensional backward FFT computes \\operatorname{BDFT}[k] =
   \\sum_{n=1}^{\\operatorname{length}(A)} \\exp\\left(+i\\frac{2\\pi
   (n-1)(k-1)}{\\operatorname{length}(A)} \\right) A[n].  A
   multidimensional backward FFT simply performs this operation along
   each transformed dimension of \"A\".  The inverse FFT computes the
   same thing divided by the product of the transformed dimensions.

"),

(E"信号处理",E"Base",E"ifft!",E"ifft!(A[, dims])

   与 \"ifft()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"bfft",E"bfft(A[, dims])

   类似 \"ifft()\", but computes an unnormalized inverse (backward)
   transform, which must be divided by the product of the sizes of the
   transformed dimensions in order to obtain the inverse.  (This is
   slightly more efficient than \"ifft()\" because it omits a scaling
   step, which in some applications can be combined with other
   computational steps elsewhere.)

"),

(E"信号处理",E"Base",E"bfft!",E"bfft!(A[, dims])

   与 \"bfft()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"",E"plan_fft(A [, dims [, flags [, timelimit]]]),  plan_ifft, plan_bfft",E"plan_fft(A [, dims [, flags [, timelimit]]]),  plan_ifft, plan_bfft

   Pre-plan an optimized FFT along given dimensions (\"dims\") of
   arrays matching the shape and type of \"A\".  (The first two
   arguments have the same meaning as for \"fft()\".)  返回a function
   \"plan(A)\" that computes \"fft(A, dims)\" quickly.

   The \"flags\" argument is a bitwise-or of FFTW planner flags,
   defaulting to \"FFTW.ESTIMATE\".  e.g. passing \"FFTW.MEASURE\" or
   \"FFTW.PATIENT\" will instead spend several seconds (or more)
   benchmarking different possible FFT algorithms and picking the
   fastest one; see the FFTW manual for more information on planner
   flags.  The optional \"timelimit\" argument specifies a rough upper
   bound on the allowed planning time, in seconds. Passing
   \"FFTW.MEASURE\" or \"FFTW.PATIENT\" may cause the input array
   \"A\" to be overwritten with zeros during plan creation.

   \"plan_fft!()\" 与 \"plan_fft()\" 相同，but creates a plan that
   operates in-place on its argument (which must be an array of
   complex floating-point numbers).  \"plan_ifft()\" and so on are
   similar but produce plans that perform the equivalent of the
   inverse transforms \"ifft()\" and so on.

"),

(E"信号处理",E"Base",E"plan_fft!",E"plan_fft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"plan_ifft!",E"plan_ifft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_ifft()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"plan_bfft!",E"plan_bfft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_bfft()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"rfft",E"rfft(A[, dims])

   Multidimensional FFT of a real array A, exploiting the fact that
   the transform has conjugate symmetry in order to save roughly half
   the computational time and storage costs compared with \"fft()\".
   If \"A\" has size \"(n_1, ..., n_d)\", the result has size
   \"(floor(n_1/2)+1, ..., n_d)\".

   The optional \"dims\" argument specifies an iterable subset of one
   or more dimensions of \"A\" to transform, similar to \"fft()\".
   Instead of (roughly) halving the first dimension of \"A\" in the
   result, the \"dims[1]\" dimension is (roughly) halved in the same
   way.

"),

(E"信号处理",E"Base",E"irfft",E"irfft(A, d[, dims])

   Inverse of \"rfft()\": for a complex array \"A\", gives the
   corresponding real array whose FFT yields \"A\" in the first half.
   As for \"rfft()\", \"dims\" is an optional subset of dimensions to
   transform, defaulting to \"1:ndims(A)\".

   \"d\" is the length of the transformed real array along the
   \"dims[1]\" dimension, which must satisfy \"d ==
   floor(size(A,dims[1])/2)+1\". (This parameter cannot be inferred
   from \"size(A)\" due to the possibility of rounding by the
   \"floor\" function here.)

"),

(E"信号处理",E"Base",E"brfft",E"brfft(A, d[, dims])

   类似 \"irfft()\" but computes an unnormalized inverse transform
   (similar to \"bfft()\"), which must be divided by the product of
   the sizes of the transformed dimensions (of the real output array)
   in order to obtain the inverse transform.

"),

(E"信号处理",E"Base",E"plan_rfft",E"plan_rfft(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized real-input FFT, similar to \"plan_fft()\"
   except for \"rfft()\" instead of \"fft()\".  The first two
   arguments, and the size of the transformed result, are the same as
   for \"rfft()\".

"),

(E"信号处理",E"",E"plan_irfft(A, d [, dims [, flags [, timelimit]]]), plan_bfft",E"plan_irfft(A, d [, dims [, flags [, timelimit]]]), plan_bfft

   Pre-plan an optimized inverse real-input FFT, similar to
   \"plan_rfft()\" except for \"irfft()\" and \"brfft()\",
   respectively.  The first three arguments have the same meaning as
   for \"irfft()\".

"),

(E"信号处理",E"Base",E"dct",E"dct(A[, dims])

   Performs a multidimensional type-II discrete cosine transform (DCT)
   of the array \"A\", using the unitary normalization of the DCT. The
   optional \"dims\" argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along.  Most efficient if the size of \"A\" along the transformed
   dimensions is a product of small primes; see \"nextprod()\".  See
   also \"plan_dct()\" for even greater efficiency.

"),

(E"信号处理",E"Base",E"dct!",E"dct!(A[, dims])

   与 \"dct!()\" 相同，except that it operates in-place on \"A\", which
   must be an array of real or complex floating-point values.

"),

(E"信号处理",E"Base",E"idct",E"idct(A[, dims])

   Computes the multidimensional inverse discrete cosine transform
   (DCT) of the array \"A\" (technically, a type-III DCT with the
   unitary normalization). The optional \"dims\" argument specifies an
   iterable subset of dimensions (e.g. an integer, range, tuple, or
   array) to transform along.  Most efficient if the size of \"A\"
   along the transformed dimensions is a product of small primes; see
   \"nextprod()\".  See also \"plan_idct()\" for even greater
   efficiency.

"),

(E"信号处理",E"Base",E"idct!",E"idct!(A[, dims])

   与 \"idct!()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"plan_dct",E"plan_dct(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized discrete cosine transform (DCT), similar to
   \"plan_fft()\" except producing a function that computes \"dct()\".
   The first two arguments have the same meaning as for \"dct()\".

"),

(E"信号处理",E"Base",E"plan_dct!",E"plan_dct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_dct()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"Base",E"plan_idct",E"plan_idct(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized inverse discrete cosine transform (DCT),
   similar to \"plan_fft()\" except producing a function that computes
   \"idct()\". The first two arguments have the same meaning as for
   \"idct()\".

"),

(E"信号处理",E"Base",E"plan_idct!",E"plan_idct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_idct()\" 相同，但在原地对 \"A\" 进行运算。

"),

(E"信号处理",E"",E"FFTW.r2r(A, kind [, dims]), FFTW.r2r!",E"FFTW.r2r(A, kind [, dims]), FFTW.r2r!

   Performs a multidimensional real-input/real-output (r2r) transform
   of type \"kind\" of the array \"A\", as defined in the FFTW manual.
   \"kind\" specifies either a discrete cosine transform of various
   types (\"FFTW.REDFT00\", \"FFTW.REDFT01\", \"FFTW.REDFT10\", or
   \"FFTW.REDFT11\"), a discrete sine transform of various types
   (\"FFTW.RODFT00\", \"FFTW.RODFT01\", \"FFTW.RODFT10\", or
   \"FFTW.RODFT11\"), a real-input DFT with halfcomplex-format output
   (\"FFTW.R2HC\" and its inverse \"FFTW.HC2R\"), or a discrete
   Hartley transform (\"FFTW.DHT\").  The \"kind\" argument may be an
   array or tuple in order to specify different transform types along
   the different dimensions of \"A\"; \"kind[end]\" is used for any
   unspecified dimensions.  See the FFTW manual for precise
   definitions of these transform types, at
   *<http://www.fftw.org/doc>*.

   The optional \"dims\" argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along. \"kind[i]\" is then the transform type for \"dims[i]\", with
   \"kind[end]\" being used for \"i > length(kind)\".

   See also \"FFTW.plan_r2r()\" to pre-plan optimized r2r transforms.

   \"FFTW.r2r!()\" 与 \"FFTW.r2r()\" 相同，but operates in-place on \"A\",
   which must be an array of real or complex floating-point numbers.

"),

(E"信号处理",E"",E"FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]]), FFTW.plan_r2r!",E"FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]]), FFTW.plan_r2r!

   Pre-plan an optimized r2r transform, similar to \"plan_fft()\"
   except that the transforms (and the first three arguments)
   correspond to \"FFTW.r2r()\" and \"FFTW.r2r!()\", respectively.

"),

(E"信号处理",E"Base",E"fftshift",E"fftshift(x)

   Swap the first and second halves of each dimension of \"x\".

"),

(E"信号处理",E"Base",E"fftshift",E"fftshift(x, dim)

   Swap the first and second halves of the given dimension of array
   \"x\".

"),

(E"信号处理",E"Base",E"ifftshift",E"ifftshift(x[, dim])

   Undoes the effect of \"fftshift\".

"),

(E"信号处理",E"Base",E"filt",E"filt(b, a, x)

   Apply filter described by vectors \"a\" and \"b\" to vector \"x\".

"),

(E"信号处理",E"Base",E"deconv",E"deconv(b, a)

   构造vector \"c\" such that \"b = conv(a,c) + r\". Equivalent to
   polynomial division.

"),

(E"信号处理",E"Base",E"conv",E"conv(u, v)

   计算两个向量的卷积。使用 FFT 算法。

"),

(E"信号处理",E"Base",E"xcorr",E"xcorr(u, v)

   计算两个向量的互相关。

"),

(E"并行计算",E"Base",E"addprocs_local",E"addprocs_local(n)

   Add processes on the local machine. Can be used to take advantage
   of multiple cores.

"),

(E"并行计算",E"Base",E"addprocs_ssh",E"addprocs_ssh({\"host1\", \"host2\", ...})

   Add processes on remote machines via SSH. Requires julia to be
   installed in the same location on each node, or to be available via
   a shared file system.

"),

(E"并行计算",E"Base",E"addprocs_sge",E"addprocs_sge(n)

   Add processes via the Sun/Oracle Grid Engine batch queue, using
   \"qsub\".

"),

(E"并行计算",E"Base",E"nprocs",E"nprocs()

   获取当前可用处理器的个数。

"),

(E"并行计算",E"Base",E"myid",E"myid()

   获取当前处理器的 ID 。

"),

(E"并行计算",E"Base",E"pmap",E"pmap(f, c)

   Transform collection \"c\" by applying \"f\" to each element in
   parallel.

"),

(E"并行计算",E"Base",E"remote_call",E"remote_call(id, func, args...)

   Call a function asynchronously on the given arguments on the
   specified processor. 返回 \"RemoteRef\" 。

"),

(E"并行计算",E"Base",E"wait",E"wait(RemoteRef)

   Wait for a value to become available for the specified remote
   reference.

"),

(E"并行计算",E"Base",E"fetch",E"fetch(RemoteRef)

   等待并获取 remote reference 的值。

"),

(E"并行计算",E"Base",E"remote_call_wait",E"remote_call_wait(id, func, args...)

   Perform \"wait(remote_call(...))\" in one message.

"),

(E"并行计算",E"Base",E"remote_call_fetch",E"remote_call_fetch(id, func, args...)

   Perform \"fetch(remote_call(...))\" in one message.

"),

(E"并行计算",E"Base",E"put",E"put(RemoteRef, value)

   Store a value to a remote reference. Implements \"shared queue of
   length 1\" semantics: if a value is already present, blocks until
   the value is removed with \"take\".

"),

(E"并行计算",E"Base",E"take",E"take(RemoteRef)

   取回 remote reference 的值，removing it so that the reference is empty
   again.

"),

(E"并行计算",E"Base",E"RemoteRef",E"RemoteRef()

   Make an uninitialized remote reference on the local machine.

"),

(E"并行计算",E"Base",E"RemoteRef",E"RemoteRef(n)

   Make an uninitialized remote reference on processor \"n\".

"),

(E"分布式数组",E"Base",E"DArray",E"DArray(init, dims[, procs, dist])

   构造分布式数组。 \"init\" is a function accepting a tuple of index ranges.
   This function should return a chunk of the distributed array for
   the specified indexes. \"dims\" is the overall size of the
   distributed array. \"procs\" optionally specifies a vector of
   processor IDs to use. \"dist\" is an integer vector specifying how
   many chunks the distributed array should be divided into in each
   dimension.

"),

(E"分布式数组",E"Base",E"dzeros",E"dzeros(dims, ...)

   构造全零的分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

(E"分布式数组",E"Base",E"dones",E"dones(dims, ...)

   构造全一的分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

(E"分布式数组",E"Base",E"dfill",E"dfill(x, dims, ...)

   构造值全为 \"x\" 的分布式数组。Trailing arguments are the same as those
   accepted by \"darray\".

"),

(E"分布式数组",E"Base",E"drand",E"drand(dims, ...)

   构造均匀分布的随机分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

(E"分布式数组",E"Base",E"drandn",E"drandn(dims, ...)

   构造正态分布的随机分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

(E"分布式数组",E"Base",E"distribute",E"distribute(a)

   将本地数组转换为分布式数组。

"),

(E"分布式数组",E"Base",E"localize",E"localize(d)

   获取分布式数组的本地部分。

"),

(E"分布式数组",E"Base",E"myindexes",E"myindexes(d)

   A tuple describing the indexes owned by the local processor

"),

(E"分布式数组",E"Base",E"procs",E"procs(d)

   Get the vector of processors storing pieces of \"d\"

"),

(E"系统",E"Base",E"run",E"run(command)

   执行命令对象， constructed with backticks. Throws an error if anything
   goes wrong, including the process exiting with a non-zero status.

"),

(E"系统",E"Base",E"success",E"success(command)

   执行命令对象， constructed with backticks, and tell whether it was
   successful (exited with a code of 0).

"),

(E"系统",E"Base",E"readsfrom",E"readsfrom(command)

   Starts running a command asynchronously, and returns a tuple
   (stream,process). The first value is a stream reading from the
   process' standard output.

"),

(E"系统",E"Base",E"writesto",E"writesto(command)

   Starts running a command asynchronously, and returns a tuple
   (stream,process). The first value is a stream writing to the
   process' standard input.

"),

(E"系统",E"Base",E"readandwrite",E"readandwrite(command)

   Starts running a command asynchronously, and returns a tuple
   (stdout,stdin,process) of the output stream and input stream of the
   process, and the process object itself.

"),

(E"系统",E"",E"> < >> .>",E"> < >> .>

   \">\" \"<\" and \">>\" work exactly as in bash, and \".>\"
   redirects STDERR.

   **例子** ： \"run((`ls` > \"out.log\") .> \"err.log\")\"

"),

(E"系统",E"Base",E"gethostname",E"gethostname() -> String

   Get the local machine's host name.

"),

(E"系统",E"Base",E"getipaddr",E"getipaddr() -> String

   Get the IP address of the local machine, as a string of the form
   \"x.x.x.x\".

"),

(E"系统",E"Base",E"pwd",E"pwd() -> String

   Get the current working directory.

"),

(E"系统",E"Base",E"cd",E"cd(dir::String)

   Set the current working directory. 返回the new current directory.

"),

(E"系统",E"Base",E"cd",E"cd(f[, \"dir\"])

   Temporarily changes the current working directory (HOME if not
   specified) and applies function f before returning.

"),

(E"系统",E"Base",E"mkdir",E"mkdir(path[, mode])

   Make a new directory with name \"path\" and permissions \"mode\".
   \"mode\" defaults to 0o777, modified by the current file creation
   mask.

"),

(E"系统",E"Base",E"rmdir",E"rmdir(path)

   移除the directory named \"path\".

"),

(E"系统",E"Base",E"getpid",E"getpid() -> Int32

   Get julia's process ID.

"),

(E"系统",E"Base",E"time",E"time()

   Get the system time in seconds since the epoch, with fairly high
   (typically, microsecond) resolution.

"),

(E"系统",E"Base",E"time_ns",E"time_ns()

   Get the time in nanoseconds. The time corresponding to 0 is
   undefined, and wraps every 5.8 years.

"),

(E"系统",E"Base",E"tic",E"tic()

   设置计时器， \"toc()\" 或 \"toq()\" 会调用它所计时的时间。The macro call \"@time
   expr\" can also be used to time evaluation.

"),

(E"系统",E"Base",E"toc",E"toc()

   打印and return the time elapsed since the last \"tic()\".

"),

(E"系统",E"Base",E"toq",E"toq()

   Return, but do not print, the time elapsed since the last
   \"tic()\".

"),

(E"系统",E"Base",E"EnvHash",E"EnvHash() -> EnvHash

   A singleton of this type provides a hash table interface to
   environment variables.

"),

(E"系统",E"Base",E"ENV",E"ENV

   Reference to the singleton \"EnvHash\".

"),

(E"C 接口",E"Base",E"ccall",E"ccall((symbol, library), RetType, (ArgType1, ...), ArgVar1, ...)
ccall(fptr::Ptr{Void}, RetType, (ArgType1, ...), ArgVar1, ...)

   Call function in C-exported shared library, specified by (function
   name, library) tuple (String or :Symbol). Alternatively, ccall may
   be used to call a function pointer returned by dlsym, but note that
   this usage is generally discouraged to facilitate future static
   compilation.

"),

(E"C 接口",E"Base",E"cfunction",E"cfunction(fun::Function, RetType::Type, (ArgTypes...))

   Generate C-callable function pointer from Julia function.

"),

(E"C 接口",E"Base",E"dlopen",E"dlopen(libfile::String[, flags::Integer])

   Load a shared library, returning an opaque handle.

   The optional flags argument is a bitwise-or of zero or more of
   RTLD_LOCAL, RTLD_GLOBAL, RTLD_LAZY, RTLD_NOW, RTLD_NODELETE,
   RTLD_NOLOAD, RTLD_DEEPBIND, and RTLD_FIRST.  These are converted to
   the corresponding flags of the POSIX (and/or GNU libc and/or MacOS)
   dlopen command, if possible, or are ignored if the specified
   functionality is not available on the current platform.  The
   default is RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL.  An important usage
   of these flags, on POSIX platforms, is to specify
   RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL in order for the library's
   symbols to be available for usage in other shared libraries, in
   situations where there are dependencies between shared libraries.

"),

(E"C 接口",E"Base",E"dlsym",E"dlsym(handle, sym)

   Look up a symbol from a shared library handle, return callable
   function pointer on success.

"),

(E"C 接口",E"Base",E"dlsym_e",E"dlsym_e(handle, sym)

   Look up a symbol from a shared library handle, silently return NULL
   pointer on lookup failure.

"),

(E"C 接口",E"Base",E"dlclose",E"dlclose(handle)

   通过句柄来关闭共享库的引用。

"),

(E"C 接口",E"Base",E"c_free",E"c_free(addr::Ptr)

   调用 C 标准库中的 ·``free()`` 。

"),

(E"C 接口",E"Base",E"unsafe_ref",E"unsafe_ref(p::Ptr{T}, i::Integer)

   对指针解引用 \"p[i]\" 或 \"*p\" ，返回类型 T 的值的浅拷贝。

"),

(E"C 接口",E"Base",E"unsafe_assign",E"unsafe_assign(p::Ptr{T}, x, i::Integer)

   给指针赋值 \"p[i] = x\" 或 \"*p = x\" ，将对象 x 复制进 p 处的内存中。

"),

(E"错误",E"Base",E"error",E"error(message::String)
error(Exception)

   报错，并显示指定信息。

"),

(E"错误",E"Base",E"throw",E"throw(e)

   将一个对象作为异常抛出。

"),

(E"错误",E"Base",E"errno",E"errno()

   获取 C 库 \"errno\" 的值。

"),

(E"错误",E"Base",E"strerror",E"strerror(n)

   将系统调用错误代码转换为描述字符串。

"),

(E"错误",E"Base",E"assert",E"assert(cond)

   如果 \"cond\" 为假则报错。也可以使用宏 \"@assert expr\" 。

"),

(E"任务",E"Base",E"Task",E"Task(func)

   构造 \"Task\" （如线程，协程）来执行指定程序。此函数返回时，任务自动退出。

"),

(E"任务",E"Base",E"yieldto",E"yieldto(task, args...)

   跳转到指定的任务。第一次跳转到某任务时，使用 \"args\" 参数来调用任务的函数。在后续的跳转时， \"args\"
   被任务的最后一个调用返回到 \"yieldto\" 。

"),

(E"任务",E"Base",E"current_task",E"current_task()

   获取当前正在运行的任务。

"),

(E"任务",E"Base",E"istaskdone",E"istaskdone(task)

   判断任务是否已退出。

"),

(E"任务",E"Base",E"consume",E"consume(task)

   接收由指定任务传递给 \"produce\" 的下一个值。

"),

(E"任务",E"Base",E"produce",E"produce(value)

   将指定值传递给最近的一次 \"consume\" 调用，然后跳转到消费者任务。

"),

(E"任务",E"Base",E"make_scheduled",E"make_scheduled(task)

   使用主事件循环来注册任务，任务会在允许的时候自动运行。

"),

(E"任务",E"Base",E"yield",E"yield()

   对安排好的任务，跳转到安排者来允许运行另一个安排好的任务。

"),

(E"任务",E"Base",E"tls",E"tls(symbol)

   在当前任务的本地任务存储中查询 \"symbol\" 的值。

"),

(E"任务",E"Base",E"tls",E"tls(symbol, value)

   给当前任务的本地任务存储中的 \"symbol\" 赋值 \"value\" 。

"),

(E"BLAS",E"BLAS",E"copy!",E"copy!(n, X, incx, Y, incy)

   Copy \"n\" elements of array \"X\" with stride \"incx\" to array
   \"Y\" with stride \"incy\".返回 \"Y\" 。

"),

(E"BLAS",E"BLAS",E"dot",E"dot(n, X, incx, Y, incy)

   Dot product of two vectors consisting of \"n\" elements of array
   \"X\" with stride \"incx\" and \"n\" elements of array \"Y\" with
   stride \"incy\".  There are no \"dot\" methods for \"Complex\"
   arrays.

"),

(E"BLAS",E"BLAS",E"nrm2",E"nrm2(n, X, incx)

   2-norm of a vector consisting of \"n\" elements of array \"X\" with
   stride \"incx\".

"),

(E"BLAS",E"BLAS",E"axpy!",E"axpy!(n, a, X, incx, Y, incy)

   Overwrite \"Y\" with \"a*X + Y\".返回 \"Y\" 。

"),

(E"BLAS",E"BLAS",E"syrk!",E"syrk!(uplo, trans, alpha, A, beta, C)

   Rank-k update of the symmetric matrix \"C\" as \"alpha*A*A.' +
   beta*C\" or \"alpha*A.'*A + beta*C\" according to whether \"trans\"
   is 'N' or 'T'.  When \"uplo\" is 'U' the upper triangle of \"C\" is
   updated ('L' for lower triangle).返回 \"C\" 。

"),

(E"BLAS",E"BLAS",E"syrk",E"syrk(uplo, trans, alpha, A)

   返回either the upper triangle or the lower triangle, according to
   \"uplo\" ('U' or 'L'), of \"alpha*A*A.'\" or \"alpha*A.'*A\",
   according to \"trans\" ('N' or 'T').

"),

(E"BLAS",E"BLAS",E"herk!",E"herk!(uplo, trans, alpha, A, beta, C)

   Methods for complex arrays only.  Rank-k update of the Hermitian
   matrix \"C\" as \"alpha*A*A' + beta*C\" or \"alpha*A'*A + beta*C\"
   according to whether \"trans\" is 'N' or 'T'.  When \"uplo\" is 'U'
   the upper triangle of \"C\" is updated ('L' for lower triangle). 返回
   \"C\" 。

"),

(E"BLAS",E"BLAS",E"herk",E"herk(uplo, trans, alpha, A)

   Methods for complex arrays only.  返回either the upper triangle or
   the lower triangle, according to \"uplo\" ('U' or 'L'), of
   \"alpha*A*A'\" or \"alpha*A'*A\", according to \"trans\" ('N' or
   'T').

"),

(E"BLAS",E"BLAS",E"gbmv!",E"gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)

   Update vector \"y\" as \"alpha*A*x + beta*y\" or \"alpha*A'*x +
   beta*y\" according to \"trans\" ('N' or 'T').  The matrix \"A\" is
   a general band matrix of dimension \"m\" by \"size(A,2)\" with
   \"kl\" sub-diagonals and \"ku\" super-diagonals. 返回更新后的 \"y\" 。

"),

(E"BLAS",E"BLAS",E"gbmv",E"gbmv(trans, m, kl, ku, alpha, A, x, beta, y)

   返回 \"alpha*A*x\" or \"alpha*A'*x\" according to \"trans\" ('N' or
   'T'). The matrix \"A\" is a general band matrix of dimension \"m\"
   by \"size(A,2)\" with \"kl\" sub-diagonals and \"ku\" super-
   diagonals.

"),

(E"BLAS",E"BLAS",E"sbmv!",E"sbmv!(uplo, k, alpha, A, x, beta, y)

   Update vector \"y\" as \"alpha*A*x + beta*y\" where \"A\" is a a
   symmetric band matrix of order \"size(A,2)\" with \"k\" super-
   diagonals stored in the argument \"A\".  The storage layout for
   \"A\" is described the reference BLAS module, level-2 BLAS at
   *<http://www.netlib.org/lapack/explore-html/>*.

   返回更新后的 \"y\" 。

"),

(E"BLAS",E"BLAS",E"sbmv",E"sbmv(uplo, k, alpha, A, x)

   返回 \"alpha*A*x\" where \"A\" is a symmetric band matrix of order
   \"size(A,2)\" with \"k\" super-diagonals stored in the argument
   \"A\".

"),

(E"BLAS",E"BLAS",E"gemm!",E"gemm!(tA, tB, alpha, A, B, beta, C)

   Update \"C\" as \"alpha*A*B + beta*C\" or the other three variants
   according to \"tA\" (transpose \"A\") and \"tB\".返回更新后的 \"C\" 。

"),

(E"BLAS",E"BLAS",E"gemm",E"gemm(tA, tB, alpha, A, B)

   返回 \"alpha*A*B\" or the other three variants according to \"tA\"
   (transpose \"A\") and \"tB\".

"),

(E"常量",E"Base",E"OS_NAME",E"OS_NAME

   表示操作系统名的符号。可能的值有 \":Linux\", \":Darwin\" (OS X), 或 \":Windows\" 。

"),

(E"cpp.jl",E"",E"@cpp",E"@cpp(ccall_expression)

   假设有一个 C++ 共享库 \"libdemo\" ，库中包含函数 \"timestwo\" ：

      int timestwo(int x) {
        return 2*x;
      }

      double timestwo(double x) {
        return 2*x;
      }

   可以在调用时，在函数前添加 \"@cpp\" 宏，例如：

      mylib = dlopen(\"libdemo\")
      x = 3.5
      x2 = @cpp ccall(dlsym(mylib, :timestwo), Float64, (Float64,), x)
      y = 3
      y2 = @cpp ccall(dlsym(mylib, :timestwo), Int, (Int,), y)

   这个宏通过 C++ ABI name-mangling （使用参数的类型）来确定正确的库符号。

   与 \"ccall\" 一样，这样调用库没有开销，但现在还有些局限：

   * 不支持纯头文件的库

   * \"ccall\" 有些限制；例如，不支持 \"struct\" 。因而，不能使用 C++ 对象。

   * 目前不支持 C++ 命名空间

   * 目前不支持模板函数

   * 目前仅支持 g++ (GNU GCC)

   后三个比较难 修正 。

"),

(E"GLPK",E"GLPK",E"set_prob_name",E"set_prob_name(glp_prob, name)

   Assigns a name to the problem object (or deletes it if \"name\" is
   empty or \"nothing\").

"),

(E"GLPK",E"GLPK",E"set_obj_name",E"set_obj_name(glp_prob, name)

   Assigns a name to the objective function (or deletes it if \"name\"
   is empty or \"nothing\").

"),

(E"GLPK",E"GLPK",E"set_obj_dir",E"set_obj_dir(glp_prob, dir)

   Sets the optimization direction, \"GLPK.MIN\" (minimization) or
   \"GLPK.MAX\" (maximization).

"),

(E"GLPK",E"GLPK",E"add_rows",E"add_rows(glp_prob, rows)

   Adds the given number of rows (constraints) to the problem object;
   returns the number of the first new row added.

"),

(E"GLPK",E"GLPK",E"add_cols",E"add_cols(glp_prob, cols)

   Adds the given number of columns (structural variables) to the
   problem object; returns the number of the first new column added.

"),

(E"GLPK",E"GLPK",E"set_row_name",E"set_row_name(glp_prob, row, name)

   Assigns a name to the specified row (or deletes it if \"name\" is
   empty or \"nothing\").

"),

(E"GLPK",E"GLPK",E"set_col_name",E"set_col_name(glp_prob, col, name)

   Assigns a name to the specified column (or deletes it if \"name\"
   is empty or \"nothing\").

"),

(E"GLPK",E"GLPK",E"set_row_bnds",E"set_row_bnds(glp_prob, row, bounds_type, lb, ub)

   Sets the type and bounds on a row. \"type\" must be one of
   \"GLPK.FR\" (free), \"GLPK.LO\" (lower bounded), \"GLPK.UP\" (upper
   bounded), \"GLPK.DB\" (double bounded), \"GLPK.FX\" (fixed).

   At initialization, each row is free.

"),

(E"GLPK",E"GLPK",E"set_col_bnds",E"set_col_bnds(glp_prob, col, bounds_type, lb, ub)

   Sets the type and bounds on a column. \"type\" must be one of
   \"GLPK.FR\" (free), \"GLPK.LO\" (lower bounded), \"GLPK.UP\" (upper
   bounded), \"GLPK.DB\" (double bounded), \"GLPK.FX\" (fixed).

   At initialization, each column is fixed at 0.

"),

(E"GLPK",E"GLPK",E"set_obj_coef",E"set_obj_coef(glp_prob, col, coef)

   Sets the objective coefficient to a column (\"col\" can be 0 to
   indicate the constant term of the objective function).

"),

(E"GLPK",E"GLPK",E"set_mat_row",E"set_mat_row(glp_prob, row[, len], ind, val)

   Sets (replaces) the content of a row. The content is specified in
   sparse format: \"ind\" is a vector of indices, \"val\" is the
   vector of corresponding values. \"len\" is the number of vector
   elements which will be considered, and must be less or equal to the
   length of both \"ind\" and \"val\".  If \"len\" is 0, \"ind\"
   and/or \"val\" can be \"nothing\".

   In Julia, \"len\" can be omitted, and then it is inferred from
   \"ind\" and \"val\" (which need to have the same length in such
   case).

"),

(E"GLPK",E"GLPK",E"set_mat_col",E"set_mat_col(glp_prob, col[, len], ind, val)

   Sets (replaces) the content of a column. Everything else is like
   \"set_mat_row\".

"),

(E"GLPK",E"GLPK",E"load_matrix",E"load_matrix(glp_prob[, numel], ia, ja, ar)
load_matrix(glp_prob, A)

   Sets (replaces) the content matrix (i.e. sets all  rows/coluns at
   once). The matrix is passed in sparse format.

   In the first form (original C API), it's passed via 3 vectors:
   \"ia\" and \"ja\" are for rows/columns indices, \"ar\" is for
   values. \"numel\" is the number of elements which will be read and
   must be less or equal to the length of any of the 3 vectors. If
   \"numel\" is 0, any of the vectors can be passed as \"nothing\".

   In Julia, \"numel\" can be omitted, and then it is inferred from
   \"ia\", \"ja\" and \"ar\" (which need to have the same length in
   such case).

   Also, in Julia there's a second, simpler calling form, in which the
   matrix is passed as a \"SparseMatrixCSC\" object.

"),

(E"GLPK",E"GLPK",E"check_dup",E"check_dup(rows, cols[, numel], ia, ja)

   Check for duplicates in the indices vectors \"ia\" and \"ja\".
   \"numel\" has the same meaning and (optional) use as in
   \"load_matrix\". 返回0 if no duplicates/out-of-range indices are
   found, or a positive number indicating where a duplicate occurs, or
   a negative number indicating an out-of-bounds index.

"),

(E"GLPK",E"GLPK",E"sort_matrix",E"sort_matrix(glp_prob)

   Sorts the elements of the problem object's matrix.

"),

(E"GLPK",E"GLPK",E"del_rows",E"del_rows(glp_prob[, num_rows], rows_ids)

   删除rows from the problem object. Rows are specified in the
   \"rows_ids\" vector. \"num_rows\" is the number of elements of
   \"rows_ids\" which will be considered, and must be less or equal to
   the length id \"rows_ids\". If \"num_rows\" is 0, \"rows_ids\" can
   be \"nothing\". In Julia, \"num_rows\" is optional (it's inferred
   from \"rows_ids\" if not given).

"),

(E"GLPK",E"GLPK",E"del_cols",E"del_cols(glp_prob, cols_ids)

   删除columns from the problem object. See \"del_rows\".

"),

(E"GLPK",E"GLPK",E"copy_prob",E"copy_prob(glp_prob_dest, glp_prob, copy_names)

   Makes a copy of the problem object. The flag \"copy_names\"
   determines if names are copied, and must be either \"GLPK.ON\" or
   \"GLPK.OFF\".

"),

(E"GLPK",E"GLPK",E"erase_prob",E"erase_prob(glp_prob)

   Resets the problem object.

"),

(E"GLPK",E"GLPK",E"get_prob_name",E"get_prob_name(glp_prob)

   返回the problem object's name. Unlike the C version, if the problem
   has no assigned name, returns an empty string.

"),

(E"GLPK",E"GLPK",E"get_obj_name",E"get_obj_name(glp_prob)

   返回the objective function's name. Unlike the C version, if the
   objective has no assigned name, returns an empty string.

"),

(E"GLPK",E"GLPK",E"get_obj_dir",E"get_obj_dir(glp_prob)

   返回the optimization direction, \"GLPK.MIN\" (minimization) or
   \"GLPK.MAX\" (maximization).

"),

(E"GLPK",E"GLPK",E"get_num_rows",E"get_num_rows(glp_prob)

   返回the current number of rows.

"),

(E"GLPK",E"GLPK",E"get_num_cols",E"get_num_cols(glp_prob)

   返回the current number of columns.

"),

(E"GLPK",E"GLPK",E"get_row_name",E"get_row_name(glp_prob, row)

   返回the name of the specified row. Unlike the C version, if the row
   has no assigned name, returns an empty string.

"),

(E"GLPK",E"GLPK",E"get_col_name",E"get_col_name(glp_prob, col)

   返回the name of the specified column. Unlike the C version, if the
   column has no assigned name, returns an empty string.

"),

(E"GLPK",E"GLPK",E"get_row_type",E"get_row_type(glp_prob, row)

   返回the type of the specified row: \"GLPK.FR\" (free), \"GLPK.LO\"
   (lower bounded), \"GLPK.UP\" (upper bounded), \"GLPK.DB\" (double
   bounded), \"GLPK.FX\" (fixed).

"),

(E"GLPK",E"GLPK",E"get_row_lb",E"get_row_lb(glp_prob, row)

   返回the lower bound of the specified row, \"-DBL_MAX\" if unbounded.

"),

(E"GLPK",E"GLPK",E"get_row_ub",E"get_row_ub(glp_prob, row)

   返回the upper bound of the specified row, \"+DBL_MAX\" if unbounded.

"),

(E"GLPK",E"GLPK",E"get_col_type",E"get_col_type(glp_prob, col)

   返回the type of the specified column: \"GLPK.FR\" (free), \"GLPK.LO\"
   (lower bounded), \"GLPK.UP\" (upper bounded), \"GLPK.DB\" (double
   bounded), \"GLPK.FX\" (fixed).

"),

(E"GLPK",E"GLPK",E"get_col_lb",E"get_col_lb(glp_prob, col)

   返回the lower bound of the specified column, \"-DBL_MAX\" if
   unbounded.

"),

(E"GLPK",E"GLPK",E"get_col_ub",E"get_col_ub(glp_prob, col)

   返回the upper bound of the specified column, \"+DBL_MAX\" if
   unbounded.

"),

(E"GLPK",E"GLPK",E"get_obj_coef",E"get_obj_coef(glp_prob, col)

   返回 the objective coefficient to a column (\"col\" can be 0 to
   indicate the constant term of the objective function).

"),

(E"GLPK",E"GLPK",E"get_num_nz",E"get_num_nz(glp_prob)

   返回 the number of non-zero elements in the constraint matrix.

"),

(E"GLPK",E"GLPK",E"get_mat_row",E"get_mat_row(glp_prob, row, ind, val)
get_mat_row(glp_prob, row)

   返回the contents of a row. In the first form (original C API), it
   fills the \"ind\" and \"val\" vectors provided, which must be of
   type \"Vector{Int32}\" and \"Vector{Float64}\" respectively, and
   have a sufficient length to hold the result (or they can be empty
   or \"nothing\", and then they're not filled). It returns the length
   of the result.

   In Julia, there's a second, simpler calling form which allocates
   and returns the two vectors as \"(ind, val)\".

"),

(E"GLPK",E"GLPK",E"get_mat_col",E"get_mat_col(glp_prob, col, ind, val)
get_mat_col(glp_prob, col)

   返回the contents of a column. See \"get_mat_row\".

"),

(E"GLPK",E"GLPK",E"create_index",E"create_index(glp_prob)

   Creates the name index (used by \"find_row\", \"find_col\") for the
   problem object.

"),

(E"GLPK",E"GLPK",E"find_row",E"find_row(glp_prob, name)

   Finds the numeric id of a row by name. 返回0 if no row with the given
   name is found.

"),

(E"GLPK",E"GLPK",E"find_col",E"find_col(glp_prob, name)

   Finds the numeric id of a column by name. 返回0 if no column with the
   given name is found.

"),

(E"GLPK",E"GLPK",E"delete_index",E"delete_index(glp_prob)

   删除the name index for the problem object.

"),

(E"GLPK",E"GLPK",E"set_rii",E"set_rii(glp_prob, row, rii)

   Sets the rii scale factor for the specified row.

"),

(E"GLPK",E"GLPK",E"set_sjj",E"set_sjj(glp_prob, col, sjj)

   Sets the sjj scale factor for the specified column.

"),

(E"GLPK",E"GLPK",E"get_rii",E"get_rii(glp_prob, row)

   返回the rii scale factor for the specified row.

"),

(E"GLPK",E"GLPK",E"get_sjj",E"get_sjj(glp_prob, col)

   返回the sjj scale factor for the specified column.

"),

(E"GLPK",E"GLPK",E"scale_prob",E"scale_prob(glp_prob, flags)

   Performs automatic scaling of problem data for the problem object.
   The parameter \"flags\" can be \"GLPK.SF_AUTO\" (automatic) or a
   bitwise OR of the forllowing: \"GLPK.SF_GM\" (geometric mean),
   \"GLPK.SF_EQ\" (equilibration), \"GLPK.SF_2N\" (nearest power of
   2), \"GLPK.SF_SKIP\" (skip if well scaled).

"),

(E"GLPK",E"GLPK",E"unscale_prob",E"unscale_prob(glp_prob)

   Unscale the problem data (cancels the scaling effect).

"),

(E"GLPK",E"GLPK",E"set_row_stat",E"set_row_stat(glp_prob, row, stat)

   Sets the status of the specified row. \"stat\" must be one of:
   \"GLPK.BS\" (basic), \"GLPK.NL\" (non-basic lower bounded),
   \"GLPK.NU\" (non-basic upper-bounded), \"GLPK.NF\" (non-basic
   free), \"GLPK.NS\" (non-basic fixed).

"),

(E"GLPK",E"GLPK",E"set_col_stat",E"set_col_stat(glp_prob, col, stat)

   Sets the status of the specified column. \"stat\" must be one of:
   \"GLPK.BS\" (basic), \"GLPK.NL\" (non-basic lower bounded),
   \"GLPK.NU\" (non-basic upper-bounded), \"GLPK.NF\" (non-basic
   free), \"GLPK.NS\" (non-basic fixed).

"),

(E"GLPK",E"GLPK",E"std_basis",E"std_basis(glp_prob)

   构造the standard (trivial) initial LP basis for the problem object.

"),

(E"GLPK",E"GLPK",E"adv_basis",E"adv_basis(glp_prob[, flags])

   构造an advanced initial LP basis for the problem object. The flag
   \"flags\" is optional; it must be 0 if given.

"),

(E"GLPK",E"GLPK",E"cpx_basis",E"cpx_basis(glp_prob)

   构造an initial LP basis for the problem object with the algorithm
   proposed by R. Bixby.

"),

(E"GLPK",E"GLPK",E"simplex",E"simplex(glp_prob[, glp_param])

   The routine \"simplex\" is a driver to the LP solver based on the
   simplex method. This routine retrieves problem data from the
   specified problem object, calls the solver to solve the problem
   instance, and stores results of computations back into the problem
   object.

   The parameters are specified via the optional \"glp_param\"
   argument, which is of type \"GLPK.SimplexParam\" (or \"nothing\" to
   use the default settings).

   返回0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EBADB\" (invalid base), \"GLPK.ESING\"
   (singular matrix), \"GLPK.ECOND\" (ill-conditioned matrix),
   \"GLPK.EBOUND\" (incorrect bounds), \"GLPK.EFAIL\" (solver
   failure), \"GLPK.EOBJLL\" (lower limit reached), \"GLPK.EOBJUL\"
   (upper limit reached), \"GLPK.ITLIM\" (iterations limit exceeded),
   \"GLPK.ETLIM\" (time limit exceeded), \"GLPK.ENOPFS\" (no primal
   feasible solution), \"GLPK.ENODFS\" (no dual feasible solution).

"),

(E"GLPK",E"GLPK",E"exact",E"exact(glp_prob[, glp_param])

   A tentative implementation of the primal two-phase simplex method
   based on exact (rational) arithmetic. Similar to \"simplex\". The
   optional \"glp_param\" is of type \"GLPK.SimplexParam\".

   The possible return values are \"0\" (success) or \"GLPK.EBADB\",
   \"GLPK.ESING\", \"GLPK.EBOUND\", \"GLPK.EFAIL\", \"GLPK.ITLIM\",
   \"GLPK.ETLIM\" (see \"simplex()\").

"),

(E"GLPK",E"GLPK",E"init_smcp",E"init_smcp(glp_param)

   Initializes a \"GLPK.SimplexParam\" object with the default values.
   In Julia, this is done at object creation time; this function can
   be used to reset the object.

"),

(E"GLPK",E"GLPK",E"get_status",E"get_status(glp_prob)

   返回the generic status of the current basic solution: \"GLPK.OPT\"
   (optimal), \"GLPK.FEAS\" (feasible), \"GLPK.INFEAS\" (infeasible),
   \"GLPK.NOFEAS\" (no feasible solution), \"GLPK.UNBND\" (unbounded
   solution), \"GLPK.UNDEF\" (undefined).

"),

(E"GLPK",E"GLPK",E"get_prim_stat",E"get_prim_stat(glp_prob)

   返回the status of the primal basic solution: \"GLPK.FEAS\",
   \"GLPK.INFEAS\", \"GLPK.NOFEAS\", \"GLPK.UNDEF\" (see
   \"get_status()\").

"),

(E"GLPK",E"GLPK",E"get_dual_stat",E"get_dual_stat(glp_prob)

   返回the status of the dual basic solution: \"GLPK.FEAS\",
   \"GLPK.INFEAS\", \"GLPK.NOFEAS\", \"GLPK.UNDEF\" (see
   \"get_status()\").

"),

(E"GLPK",E"GLPK",E"get_obj_val",E"get_obj_val(glp_prob)

   返回the current value of the objective function.

"),

(E"GLPK",E"GLPK",E"get_row_stat",E"get_row_stat(glp_prob, row)

   返回the status of the specified row: \"GLPK.BS\", \"GLPK.NL\",
   \"GLPK.NU\", \"GLPK.NF\", \"GLPK.NS\" (see \"set_row_stat()\").

"),

(E"GLPK",E"GLPK",E"get_row_prim",E"get_row_prim(glp_prob, row)

   返回the primal value of the specified row.

"),

(E"GLPK",E"GLPK",E"get_row_dual",E"get_row_dual(glp_prob, row)

   返回the dual value (reduced cost) of the specified row.

"),

(E"GLPK",E"GLPK",E"get_col_stat",E"get_col_stat(glp_prob, col)

   返回the status of the specified column: \"GLPK.BS\", \"GLPK.NL\",
   \"GLPK.NU\", \"GLPK.NF\", \"GLPK.NS\" (see \"set_row_stat()\").

"),

(E"GLPK",E"GLPK",E"get_col_prim",E"get_col_prim(glp_prob, col)

   返回the primal value of the specified column.

"),

(E"GLPK",E"GLPK",E"get_col_dual",E"get_col_dual(glp_prob, col)

   返回the dual value (reduced cost) of the specified column.

"),

(E"GLPK",E"GLPK",E"get_unbnd_ray",E"get_unbnd_ray(glp_prob)

   返回the number k of a variable, which causes primal or dual
   unboundedness (if 1 <= k <= rows it's row k; if rows+1 <= k <=
   rows+cols it's column k-rows, if k=0 such variable is not defined).

"),

(E"GLPK",E"GLPK",E"interior",E"interior(glp_prob[, glp_param])

   The routine \"interior\" is a driver to the LP solver based on the
   primal-dual interior-point method. This routine retrieves problem
   data from the specified problem object, calls the solver to solve
   the problem instance, and stores results of computations back into
   the problem object.

   The parameters are specified via the optional \"glp_param\"
   argument, which is of type \"GLPK.InteriorParam\" (or \"nothing\"
   to use the default settings).

   返回 0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EFAIL\" (solver failure), \"GLPK.ENOCVG\" (very
   slow convergence, or divergence), \"GLPK.ITLIM\" (iterations limit
   exceeded), \"GLPK.EINSTAB\" (numerical instability).

"),

(E"GLPK",E"GLPK",E"init_iptcp",E"init_iptcp(glp_param)

   Initializes a \"GLPK.InteriorParam\" object with the default
   values. In Julia, this is done at object creation time; this
   function can be used to reset the object.

"),

(E"GLPK",E"GLPK",E"ipt_status",E"ipt_status(glp_prob)

   返回the status of the interior-point solution: \"GLPK.OPT\"
   (optimal), \"GLPK.INFEAS\" (infeasible), \"GLPK.NOFEAS\" (no
   feasible solution), \"GLPK.UNDEF\" (undefined).

"),

(E"GLPK",E"GLPK",E"ipt_obj_val",E"ipt_obj_val(glp_prob)

   返回the current value of the objective function for the interior-
   point solution.

"),

(E"GLPK",E"GLPK",E"ipt_row_prim",E"ipt_row_prim(glp_prob, row)

   返回the primal value of the specified row for the interior-point
   solution.

"),

(E"GLPK",E"GLPK",E"ipt_row_dual",E"ipt_row_dual(glp_prob, row)

   返回the dual value (reduced cost) of the specified row for the
   interior-point solution.

"),

(E"GLPK",E"GLPK",E"ipt_col_prim",E"ipt_col_prim(glp_prob, col)

   返回the primal value of the specified column for the interior-point
   solution.

"),

(E"GLPK",E"GLPK",E"ipt_col_dual",E"ipt_col_dual(glp_prob, col)

   返回the dual value (reduced cost) of the specified column for the
   interior-point solution.

"),

(E"GLPK",E"GLPK",E"set_col_kind",E"set_col_kind(glp_prob, col, kind)

   Sets the kind for the specified column (for mixed-integer
   programming). \"kind\" must be one of: \"GLPK.CV\" (continuous),
   \"GLPK.IV\" (integer), \"GLPK.BV\" (binary, 0/1).

"),

(E"GLPK",E"GLPK",E"get_col_kind",E"get_col_kind(glp_prob, col)

   返回the kind for the specified column (see \"set_col_kind()\").

"),

(E"GLPK",E"GLPK",E"get_num_int",E"get_num_int(glp_prob)

   返回the number of columns marked as integer (including binary).

"),

(E"GLPK",E"GLPK",E"get_num_bin",E"get_num_bin(glp_prob)

   返回the number of columns marked binary.

"),

(E"GLPK",E"GLPK",E"intopt",E"intopt(glp_prob[, glp_param])

   The routine \"intopt\" is a driver to the mixed-integer-programming
   (MIP) solver based on the branch- and-cut method, which is a hybrid
   of branch-and-bound and cutting plane methods.

   The parameters are specified via the optional \"glp_param\"
   argument, which is of type \"GLPK.IntoptParam\" (or \"nothing\" to
   use the default settings).

   返回 0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EBOUND\" (incorrect bounds), \"GLPK.EROOT\" (no
   optimal LP basis given), \"GLPK.ENOPFS\" (no primal feasible LP
   solution), \"GLPK.ENODFS\" (no dual feasible LP solution),
   \"GLPK.EFAIL\" (solver failure), \"GLPK.EMIPGAP\" (mip gap
   tolearance reached), \"GLPK.ETLIM\" (time limit exceeded),
   \"GLPK.ESTOP\" (terminated by application).

"),

(E"GLPK",E"GLPK",E"init_iocp",E"init_iocp(glp_param)

   Initializes a \"GLPK.IntoptParam\" object with the default values.
   In Julia, this is done at object creation time; this function can
   be used to reset the object.

"),

(E"GLPK",E"GLPK",E"mip_status",E"mip_status(glp_prob)

   返回the generic status of the MIP solution: \"GLPK.OPT\" (optimal),
   \"GLPK.FEAS\" (feasible), \"GLPK.NOFEAS\" (no feasible solution),
   \"GLPK.UNDEF\" (undefined).

"),

(E"GLPK",E"GLPK",E"mip_obj_val",E"mip_obj_val(glp_prob)

   返回the current value of the objective function for the MIP solution.

"),

(E"GLPK",E"GLPK",E"mip_row_val",E"mip_row_val(glp_prob, row)

   返回the value of the specified row for the MIP solution.

"),

(E"GLPK",E"GLPK",E"mip_col_val",E"mip_col_val(glp_prob, col)

   返回the value of the specified column for the MIP solution.

"),

(E"GLPK",E"GLPK",E"read_mps",E"read_mps(glp_prob, format[, param], filename)

   Reads problem data in MPS format from a text file. \"format\" must
   be one of \"GLPK.MPS_DECK\" (fixed, old) or \"GLPK.MPS_FILE\"
   (free, modern). \"param\" is optional; if given it must be
   \"nothing\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_mps",E"write_mps(glp_prob, format[, param], filename)

   Writes problem data in MPS format from a text file. See
   \"read_mps\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"read_lp",E"read_lp(glp_prob[, param], filename)

   Reads problem data in CPLEX LP format from a text file. \"param\"
   is optional; if given it must be \"nothing\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_lp",E"write_lp(glp_prob[, param], filename)

   Writes problem data in CPLEX LP format from a text file. See
   \"read_lp\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"read_prob",E"read_prob(glp_prob[, flags], filename)

   Reads problem data in GLPK LP/MIP format from a text file.
   \"flags\" is optional; if given it must be 0.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_prob",E"write_prob(glp_prob[, flags], filename)

   Writes problem data in GLPK LP/MIP format from a text file. See
   \"read_prob\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"mpl_read_model",E"mpl_read_model(glp_tran, filename, skip)

   Reads the model section and, optionally, the data section, from a
   text file in MathProg format, and stores it in \"glp_tran\", which
   is a \"GLPK.MathProgWorkspace\" object. If \"skip\" is nonzero, the
   data section is skipped if present.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"mpl_read_data",E"mpl_read_data(glp_tran, filename)

   Reads data section from a text file in MathProg format and stores
   it in \"glp_tran\", which is a \"GLPK.MathProgWorkspace\" object.
   May be called more than once.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"mpl_generate",E"mpl_generate(glp_tran[, filename])

   Generates the model using its description stored in the
   \"GLPK.MathProgWorkspace\" translator workspace \"glp_tran\". The
   optional \"filename\" specifies an output file; if not given or
   \"nothing\", the terminal is used.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"mpl_build_prob",E"mpl_build_prob(glp_tran, glp_prob)

   Transfer information from the \"GLPK.MathProgWorkspace\" translator
   workspace \"glp_tran\" to the \"GLPK.Prob\" problem object
   \"glp_prob\".

"),

(E"GLPK",E"GLPK",E"mpl_postsolve",E"mpl_postsolve(glp_tran, glp_prob, sol)

   Copies the solution from the \"GLPK.Prob\" problem object
   \"glp_prob\" to the \"GLPK.MathProgWorkspace\" translator workspace
   \"glp_tran\" and then executes all the remaining model statements,
   which follow the solve statement.

   The parameter \"sol\" specifies which solution should be copied
   from the problem object to the workspace: \"GLPK.SOL\" (basic),
   \"GLPK.IPT\" (interior-point), \"GLPK.MIP\" (MIP).

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"print_sol",E"print_sol(glp_prob, filename)

   Writes the current basic solution to a text file, in printable
   format.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"read_sol",E"read_sol(glp_prob, filename)

   Reads the current basic solution from a text file, in the format
   used by \"write_sol\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_sol",E"write_sol(glp_prob, filename)

   Writes the current basic solution from a text file, in a format
   which can be read by \"read_sol\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"print_ipt",E"print_ipt(glp_prob, filename)

   Writes the current interior-point solution to a text file, in
   printable format.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"read_ipt",E"read_ipt(glp_prob, filename)

   Reads the current interior-point solution from a text file, in the
   format used by \"write_ipt\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_ipt",E"write_ipt(glp_prob, filename)

   Writes the current interior-point solution from a text file, in a
   format which can be read by \"read_ipt\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"print_mip",E"print_mip(glp_prob, filename)

   Writes the current MIP solution to a text file, in printable
   format.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"read_mip",E"read_mip(glp_prob, filename)

   Reads the current MIP solution from a text file, in the format used
   by \"write_mip\".

   返回0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"write_mip",E"write_mip(glp_prob, filename)

   Writes the current MIP solution from a text file, in a format which
   can be read by \"read_mip\".

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"print_ranges",E"print_ranges(glp_prob, [[len,] list,] [flags,] filename)

   Performs sensitivity analysis of current optimal basic solution and
   writes the analysis report in human-readable format to a text file.
   \"list\" is a vector specifying the rows/columns to analyze (if 1
   <= list[i] <= rows, analyzes row list[i]; if rows+1 <= list[i] <=
   rows+cols, analyzes column list[i]-rows). \"len\" is the number of
   elements of \"list\" which will be consideres, and must be smaller
   or equal to the length of the list. In Julia, \"len\" is optional
   (it's inferred from \"len\" if not given). \"list\" can be empty of
   \"nothing\" or not given at all, implying all indices will be
   analyzed. \"flags\" is optional, and must be 0 if given.

   To call this function, the current basic solution must be optimal,
   and the basis factorization must exist.

   返回 0 upon success, non-zero otherwise.

"),

(E"GLPK",E"GLPK",E"bf_exists",E"bf_exists(glp_prob)

   返回non-zero if the basis fatorization for the current basis exists,
   0 otherwise.

"),

(E"GLPK",E"GLPK",E"factorize",E"factorize(glp_prob)

   Computes the basis factorization for the current basis.

   返回 0 if successful, otherwise: \"GLPK.EBADB\" (invalid matrix),
   \"GLPK.ESING\" (singluar matrix), \"GLPK.ECOND\" (ill-conditioned
   matrix).

"),

(E"GLPK",E"GLPK",E"bf_updated",E"bf_updated(glp_prob)

   返回 0 if the basis factorization was computed from scratch, non-zero
   otherwise.

"),

(E"GLPK",E"GLPK",E"get_bfcp",E"get_bfcp(glp_prob, glp_param)

   Retrieves control parameters, which are used on computing and
   updating the basis factorization associated with the problem
   object, and stores them in the \"GLPK.BasisFactParam\" object
   \"glp_param\".

"),

(E"GLPK",E"GLPK",E"set_bfcp",E"set_bfcp(glp_prob[, glp_param])

   Sets the control parameters stored in the \"GLPK.BasisFactParam\"
   object \"glp_param\" into the problem object. If \"glp_param\" is
   \"nothing\" or is omitted, resets the parameters to their defaults.

   The \"glp_param\" should always be retreived via \"get_bfcp\"
   before changing its values and calling this function.

"),

(E"GLPK",E"GLPK",E"get_bhead",E"get_bhead(glp_prob, k)

   返回the basis header information for the current basis. \"k\" is a
   row index.

   返回either i such that 1 <= i <= rows, if \"k\" corresponds to i-th
   auxiliary variable, or rows+j such that 1 <= j <= columns, if \"k\"
   corresponds to the j-th structural variable.

"),

(E"GLPK",E"GLPK",E"get_row_bind",E"get_row_bind(glp_prob, row)

   返回the index of the basic variable \"k\" which is associated with
   the specified row, or \"0\" if the variable is non-basic. If
   \"GLPK.get_bhead(glp_prob, k) == row\", then
   \"GLPK.get_bind(glp_prob, row) = k\".

"),

(E"GLPK",E"GLPK",E"get_col_bind",E"get_col_bind(glp_prob, col)

   返回the index of the basic variable \"k\" which is associated with
   the specified column, or \"0\" if the variable is non-basic. If
   \"GLPK.get_bhead(glp_prob, k) == rows+col\", then
   \"GLPK.get_bind(glp_prob, col) = k\".

"),

(E"GLPK",E"GLPK",E"ftran",E"ftran(glp_prob, v)

   Performs forward transformation (FTRAN), i.e. it solves the system
   Bx = b, where B is the basis matrix, x is the vector of unknowns to
   be computed, b is the vector of right-hand sides. At input, \"v\"
   represents the vector b; at output, it contains the vector x. \"v\"
   must be a \"Vector{Float64}\" whose length is the number of rows.

"),

(E"GLPK",E"GLPK",E"btran",E"btran(glp_prob, v)

   Performs backward transformation (BTRAN), i.e. it solves the system
   \"B'x = b\", where \"B\" is the transposed of the basis matrix,
   \"x\" is the vector of unknowns to be computed, \"b\" is the vector
   of right-hand sides. At input, \"v\" represents the vector \"b\";
   at output, it contains the vector \"x\". \"v\" must be a
   \"Vector{Float64}\" whose length is the number of rows.

"),

(E"GLPK",E"GLPK",E"warm_up",E"warm_up(glp_prob)

   \"Warms up\" the LP basis using current statuses assigned to rows
   and columns, i.e. computes factorization of the basis matrix (if it
   does not exist), computes primal and dual components of basic
   solution, and determines the solution status.

   返回 0 if successful, otherwise: \"GLPK.EBADB\" (invalid matrix),
   \"GLPK.ESING\" (singluar matrix), \"GLPK.ECOND\" (ill-conditioned
   matrix).

"),

(E"GLPK",E"GLPK",E"eval_tab_row",E"eval_tab_row(glp_prob, k, ind, val)
eval_tab_row(glp_prob, k)

   Computes a row of the current simplex tableau which corresponds to
   some basic variable specified by the parameter \"k\". If 1 <= \"k\"
   <= rows, uses \"k\"-th auxiliary variable; if rows+1 <= \"k\" <=
   rows+cols, uses (\"k\"-rows)-th structural variable. The basis
   factorization must exist.

   In the first form, stores the result in the provided vectors
   \"ind\" and \"val\", which must be of type \"Vector{Int32}\" and
   \"Vector{Float64}\", respectively, and returns the length of the
   outcome; in Julia, the vectors will be resized as needed to hold
   the result.

   In the second, simpler form, \"ind\" and \"val\" are returned in a
   tuple as the output of the function.

"),

(E"GLPK",E"GLPK",E"eval_tab_col",E"eval_tab_col(glp_prob, k, ind, val)
eval_tab_col(glp_prob, k)

   Computes a column of the current simplex tableau which corresponds
   to some non-basic variable specified by the parameter \"k\". See
   \"eval_tab_row\".

"),

(E"GLPK",E"GLPK",E"transform_row",E"transform_row(glp_prob[, len], ind, val)

   Performs the same operation as \"eval_tab_row\" with the exception
   that the row to be transformed is specified explicitly as a sparse
   vector. The parameter \"len\" is the number of elements of \"ind\"
   and \"val\" which will be used, and must be smaller or equal to the
   length of both vectors; in Julia it is optional (and the \"ind\"
   and \"val\" must have the same length). The vectors \"int\" and
   \"val\" must be of type \"Vector{Int32}\" and \"Vector{Float64}\",
   respectively, since they will also hold the result; in Julia, they
   will be resized to the resulting required length.

   返回the length if the resulting vectors \"ind\" and \"val\".

"),

(E"GLPK",E"GLPK",E"transform_col",E"transform_col(glp_prob[, len], ind, val)

   Performs the same operation as \"eval_tab_col\" with the exception
   that the row to be transformed is specified explicitly as a sparse
   vector. See \"transform_row\".

"),

(E"GLPK",E"GLPK",E"prim_rtest",E"prim_rtest(glp_prob[, len], ind, val, dir, eps)

   Performs the primal ratio test using an explicitly specified column
   of the simplex table. The current basic solution must be primal
   feasible. The column is specified in sparse format by \"len\"
   (length of the vector), \"ind\" and \"val\" (indices and values of
   the vector). \"len\" is the number of elements which will be
   considered and must be smaller or equal to the length of both
   \"ind\" and \"val\"; in Julia, it can be omitted (and then \"ind\"
   and \"val\" must have the same length). The indices in \"ind\" must
   be between 1 and rows+cols; they must correspond to basic
   variables. \"dir\" is a direction parameter which must be either +1
   (increasing) or -1 (decreasing). \"eps\" is a tolerance parameter
   and must be positive. See the GLPK manual for a detailed
   explanation.

   返回the position in \"ind\" and \"val\" which corresponds to the
   pivot element, or 0 if the choice cannot be made.

"),

(E"GLPK",E"GLPK",E"dual_rtest",E"dual_rtest(glp_prob[, len], ind, val, dir, eps)

   Performs the dual ratio test using an explicitly specified row of
   the simplex table. The current basic solution must be dual
   feasible. The indices in \"ind\" must correspond to non-basic
   variables. Everything else is like in \"prim_rtest\".

"),

(E"GLPK",E"GLPK",E"analyze_bound",E"analyze_bound(glp_prob, k)

   Analyzes the effect of varying the active bound of specified non-
   basic variable. See the GLPK manual for a detailed explanation. In
   Julia, this function has a different API then C. It returns
   \"(limit1, var1, limit2, var2)\" rather then taking them as
   pointers in the argument list.

"),

(E"GLPK",E"GLPK",E"analyze_coef",E"analyze_coef(glp_prob, k)

   Analyzes the effect of varying the objective coefficient at
   specified basic variable. See the GLPK manual for a detailed
   explanation. In Julia, this function has a different API then C. It
   returns \"(coef1, var1, value1, coef2, var2, value2)\" rather then
   taking them as pointers in the argument list.

"),

(E"GLPK",E"GLPK",E"init_env",E"init_env()

   Initializes the GLPK environment. Not normally needed.

   返回 0 (initilization successful), 1 (environment already
   initialized), 2 (failed, insufficient memory) or 3 (failed,
   unsupported programming model).

"),

(E"GLPK",E"GLPK",E"version",E"version()

   返回the GLPK version number. In Julia, instead of returning a string
   as in C, it returns a tuple of integer values, containing the major
   and the minor number.

"),

(E"GLPK",E"GLPK",E"free_env",E"free_env()

   Frees all resources used by GLPK routines (memory blocks, etc.)
   which are currently still in use. Not normally needed.

   返回 0 if successful, 1 if envirnoment is inactive.

"),

(E"GLPK",E"GLPK",E"term_out",E"term_out(flag)

   Enables/disables the terminal output of glpk routines. \"flag\" is
   either \"GLPK.ON\" (output enabled) or \"GLPK.OFF\" (output
   disabled).

   返回the previous status of the terminal output.

"),

(E"GLPK",E"GLPK",E"open_tee",E"open_tee(filename)

   Starts copying all the terminal output to an output text file.

   返回 0 if successful, 1 if already active, 2 if it fails creating the
   output file.

"),

(E"GLPK",E"GLPK",E"close_tee",E"close_tee()

   Stops copying the terminal output to the output text file
   previously open by the \"open_tee\".

   返回 0 if successful, 1 if copying terminal output was not started.

"),

(E"GLPK",E"GLPK",E"malloc",E"malloc(size)

   Replacement of standard C \"malloc\". Allocates uninitialized
   memeory which must freed with \"free\".

   返回a pointer to the allocated memory.

"),

(E"GLPK",E"GLPK",E"calloc",E"calloc(n, size)

   Replacement of standard C \"calloc\", but does not initialize the
   memeory. Allocates uninitialized memeory which must freed with
   \"free\".

   返回a pointer to the allocated memory.

"),

(E"GLPK",E"GLPK",E"free",E"free(ptr)

   Deallocates a memory block previously allocated by \"malloc\" or
   \"calloc\".

"),

(E"GLPK",E"GLPK",E"mem_usage",E"mem_usage()

   Reports some information about utilization of the memory by the
   routines \"malloc\", \"calloc\", and \"free\". In Julia, this
   function has a different API then C. It returns \"(count, cpeak,
   total, tpeak)\" rather then taking them as pointers in the argument
   list.

"),

(E"GLPK",E"GLPK",E"mem_limit",E"mem_limit(limit)

   Limits the amount of memory avaliable for dynamic allocation to a
   value in megabyes given by the integer parameter \"limit\".

"),

(E"GLPK",E"GLPK",E"time",E"time()

   返回the current universal time (UTC), in milliseconds.

"),

(E"GLPK",E"GLPK",E"difftime",E"difftime(t1, t0)

   返回the difference between two time values \"t1\" and \"t0\",
   expressed in seconds.

"),

(E"GLPK",E"GLPK",E"sdf_open_file",E"sdf_open_file(filename)

   Opens a plain data file.

   If successful, returns a \"GLPK.Data\" object, otherwise throws an
   error.

"),

(E"GLPK",E"GLPK",E"sdf_read_int",E"sdf_read_int(glp_data)

   Reads an integer number from the plain data file specified by the
   \"GLPK.Data\" parameter \"glp_data\", skipping initial whitespace.

"),

(E"GLPK",E"GLPK",E"sdf_read_num",E"sdf_read_num(glp_data)

   Reads a floating point number from the plain data file specified by
   the \"GLPK.Data\" parameter \"glp_data\", skipping initial
   whitespace.

"),

(E"GLPK",E"GLPK",E"sdf_read_item",E"sdf_read_item(glp_data)

   Reads a data item (a String) from the plain data file specified by
   the \"GLPK.Data\" parameter \"glp_data\", skipping initial
   whitespace.

"),

(E"GLPK",E"GLPK",E"sdf_read_text",E"sdf_read_text(glp_data)

   Reads a line of text from the plain data file specified by the
   \"GLPK.Data\" parameter \"glp_data\", skipping initial and final
   whitespace.

"),

(E"GLPK",E"GLPK",E"sdf_line",E"sdf_line(glp_data)

   返回the current line in the \"GLPK.Data\" object \"glp_data\"

"),

(E"GLPK",E"GLPK",E"sdf_close_file",E"sdf_close_file(glp_data)

   Closes the file associated to \"glp_data\" and frees the resources.

"),

(E"GLPK",E"GLPK",E"read_cnfsat",E"read_cnfsat(glp_prob, filename)

   Reads the CNF-SAT problem data in DIMACS format from a text file.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"check_cnfsat",E"check_cnfsat(glp_prob)

   Checks if the problem object encodes a CNF-SAT problem instance, in
   which case it returns 0, otherwise returns non-zero.

"),

(E"GLPK",E"GLPK",E"write_cnfsat",E"write_cnfsat(glp_prob, filename)

   Writes the CNF-SAT problem data in DIMACS format into a text file.

   返回 0 upon success; throws an error in case of failure.

"),

(E"GLPK",E"GLPK",E"minisat1",E"minisat1(glp_prob)

   The routine \"minisat1\" is a driver to MiniSat, a CNF-SAT solver
   developed by Niklas Eén and Niklas Sörensson, Chalmers University
   of Technology, Sweden.

   返回 0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EDATA\" (problem is not CNF-SAT),
   \"GLPK.EFAIL\" (solver failure).

"),

(E"GLPK",E"GLPK",E"intfeas1",E"intfeas1(glp_prob, use_bound, obj_bound)

   The routine \"glp_intfeas1\" is a tentative implementation of an
   integer feasibility solver based on a CNF-SAT solver (currently
   MiniSat). \"use_bound\" is a flag: if zero, any feasible solution
   is seeked, otherwise seraches for an integer feasible solution.
   \"obj_bound\" is used only if \"use_bound\" is non-zero, and
   specifies an upper/lower bound (for maximization/minimazion
   respectively) to the objective function.

   All variables (columns) must either be binary or fixed. All
   constraint and objective coeffient must be integer.

   返回 0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EDATA\" (problem data is not valid),
   \"GLPK.ERANGE\" (integer overflow occurred), \"GLPK.EFAIL\" (solver
   failure).

"),

(E"GZip",E"GZip",E"gzopen",E"gzopen(fname[, gzmode[, buf_size]])

   Opens a file with mode (default \"\"r\"\"), setting internal buffer
   size to buf_size (default \"Z_DEFAULT_BUFSIZE=8192\"), and returns
   a the file as a \"GZipStream\".

   \"gzmode\" must contain one of

   +------+-----------------------------------+
   | r    | read                              |
   +------+-----------------------------------+
   | w    | write, create, truncate           |
   +------+-----------------------------------+
   | a    | write, create, append             |
   +------+-----------------------------------+

   In addition, gzmode may also contain

   +-------+-----------------------------------+
   | x     | create the file exclusively       |
   +-------+-----------------------------------+
   | 0-9   | compression level                 |
   +-------+-----------------------------------+

   and/or a compression strategy:

   +------+-----------------------------------+
   | f    | filtered data                     |
   +------+-----------------------------------+
   | h    | Huffman-only compression          |
   +------+-----------------------------------+
   | R    | run-length encoding               |
   +------+-----------------------------------+
   | F    | fixed code compression            |
   +------+-----------------------------------+

   Note that \"+\" is not allowed in gzmode.

   If an error occurs, \"gzopen\" throws a \"GZError\"

"),

(E"GZip",E"GZip",E"gzdopen",E"gzdopen(fd[, gzmode[, buf_size]])

   Create a \"GZipStream\" object from an integer file descriptor. See
   \"gzopen()\" for \"gzmode\" and \"buf_size\" descriptions.

"),

(E"GZip",E"GZip",E"gzdopen",E"gzdopen(s[, gzmode[, buf_size]])

   Create a \"GZipStream\" object from \"IOStream\" \"s\".

"),

(E"GZip",E"GZip",E"GZipStream",E"type GZipStream(name, gz_file[, buf_size[, fd[, s]]])

   Subtype of \"IO\" which wraps a gzip stream.  Returned by
   \"gzopen()\" and \"gzdopen()\".

"),

(E"GZip",E"GZip",E"GZError",E"type GZError(err, err_str)

   gzip 错误值和字符串。可能的错误值：

   +-----------------------+------------------------------------------+
   | \\\"Z_OK\\\"              | No error                                 |
   +-----------------------+------------------------------------------+
   | \\\"Z_ERRNO\\\"           | Filesystem error (consult \\\"errno()\\\")   |
   +-----------------------+------------------------------------------+
   | \\\"Z_STREAM_ERROR\\\"    | Inconsistent stream state                |
   +-----------------------+------------------------------------------+
   | \\\"Z_DATA_ERROR\\\"      | Compressed data error                    |
   +-----------------------+------------------------------------------+
   | \\\"Z_MEM_ERROR\\\"       | Out of memory                            |
   +-----------------------+------------------------------------------+
   | \\\"Z_BUF_ERROR\\\"       | Input buffer full/output buffer empty    |
   +-----------------------+------------------------------------------+
   | \\\"Z_VERSION_ERROR\\\"   | zlib library version is incompatible     |
   +-----------------------+------------------------------------------+

"),


(E"OptionsMod",E"OptionsMod",E"@options",E"@options([check_flag], assignments...)

   Use the \"@options\" macro to set the value of optional parameters
   for a function that has been written to use them (see
   \"defaults()\" to learn how to write such functions).  The syntax
   is:

      opts = @options a=5 b=7

   For a function that uses optional parameters \"a\" and \"b\", this
   will override the default settings for these parameters. You would
   likely call that function in the following way:

      myfunc(requiredarg1, requiredarg2, ..., opts)

   Most functions written to use optional arguments will probably
   check to make sure that you are not supplying parameters that are
   never used by the function or its sub-functions. Typically,
   supplying unused parameters will result in an error. You can
   control the behavior this way:

      # throw an error if a or b is not used (the default)
      opts = @options CheckError a=5 b=2
      # issue a warning if a or b is not used
      opts = @options CheckWarn a=5 b=2
      # don't check whether a and b are used
      opts = @options CheckNone a=5 b=2

   As an alternative to the macro syntax, you can also say:

      opts = Options(CheckWarn, :a, 5, :b, 2)

   The check flag is optional.

"),

(E"OptionsMod",E"OptionsMod",E"@set_options",E"@set_options(opts, assigments...)

   The \"@set_options\" macro lets you add new parameters to an
   existing options structure.  For example:

      @set_options opts d=99

   would add \"d\" to the set of parameters in \"opts\", or re-set its
   value if it was already supplied.

"),

(E"OptionsMod",E"OptionsMod",E"@defaults",E"@defaults(opts, assignments...)

   The \"@defaults\" macro is for writing functions that take optional
   parameters.  The typical syntax of such functions is:

      function myfunc(requiredarg1, requiredarg2, ..., opts::Options)
          @defaults opts a=11 b=2a+1 c=a*b d=100
          # The function body. Use a, b, c, and d just as you would
          # any other variable. For example,
          k = a + b
          # You can pass opts down to subfunctions, which might supply
          # additional defaults for other variables aa, bb, etc.
          y = subfun(k, opts)
          # Terminate your function with check_used, then return values
          @check_used opts
          return y
      end

   Note the function calls \"@check_used()\" at the end.

   It is possible to have more than one Options parameter to a
   function, for example:

      function twinopts(x, plotopts::Options, calcopts::Options)
          @defaults plotopts linewidth=1
          @defaults calcopts n_iter=100
          # Do stuff
          @check_used plotopts
          @check_used calcopts
      end

   Within a given scope, you should only have one call to
   \"@defaults\" per options variable.

"),

(E"OptionsMod",E"OptionsMod",E"@check_used",E"@check_used(opts)

   The \"@check_used\" macro tests whether user-supplied parameters
   were ever accessed by the \"@defaults()\" macro. The test is
   performed at the end of the function body, so that subfunction
   handling parameters not used by the parent function may be
   \"credited\" for their usage. Each sub-function should also call
   \"@check_used\", for example:

      function complexfun(x, opts::Options)
          @defaults opts parent=3 both=7
          println(parent)
          println(both)
          subfun1(x, opts)
          subfun2(x, opts)
          @check_used opts
      end

      function subfun1(x, opts::Options)
          @defaults opts sub1=\"sub1 default\" both=0
          println(sub1)
          println(both)
          @check_used opts
      end

      function subfun2(x, opts::Options)
          @defaults opts sub2=\"sub2 default\" both=22
          println(sub2)
          println(both)
          @check_used opts
      end

"),

(E"OptionsMod",E"OptionsMod",E"Options",E"type Options(OptionsChecking, param1, val1, param2, val2, ...)

   \"Options\" is the central type used for handling optional
   arguments. Its fields are briefly described below.

   key2index

      A \"Dict\" that looks up an integer index, given the symbol for
      a variable (e.g., \"key2index[:a]\" for the variable \"a\")

   vals

      \"vals[key2index[:a]]\" 是要赋给变量 \"a\" 的值

   used

      A vector of booleans, one per variable, with
      \"used[key2index[:a]]\" representing the value for variable
      \"a\". These all start as \"false\", but access by a
      \"@defaults\" command sets the corresponding value to \"true\".
      This marks the variable as having been used in the function.

   check_lock

      A vector of booleans, one per variable. This is a \"lock\" that
      prevents sub-functions from complaining that they did not access
      variables that were intended for the parent function.
      \"@defaults()\" sets the lock to true for any options variables
      that have already been defined; new variables added through
      \"@set_options()\" will start with their \"check_lock\" set to
      \"false\", to be handled by a subfunction.

"),

(E"profile.jl",E"",E"@profile",E"@profile()

   Profiling is controlled via the \"@profile\" macro. Your first step
   is to determine which code you want to profile and encapsulate it
   inside a \"@profile begin ... end\" block, like this:

      @profile begin
      function f1(x::Int)
        z = 0
        for j = 1:x
          z += j^2
        end
        return z
      end

      function f1(x::Float64)
        return x+2
      end

      function f1{T}(x::T)
        return x+5
      end

      f2(x) = 2*x
      end     # @profile begin

   Now load the file and execute the code you want to profile, e.g.:

      f1(215)
      for i = 1:100
        f1(3.5)
      end
      for i = 1:150
        f1(uint8(7))
      end
      for i = 1:125
        f2(11)
      end

   To view the execution times, type \"@profile report\".

   Here are the various options you have for controlling profiling:

   * \"@profile report\": display cumulative profiling results

   * \"@profile clear\": clear all timings accumulated thus far (start
     from zero)

   * \"@profile off\": turn profiling off (there is no need to remove
     \"@profile begin ... end\" blocks)

   * \"@profile on\": turn profiling back on

"),

(E"Base.Sort",E"Base.Sort",E"sort",E"sort(v[, alg[, ord]])

   按升序对向量排序。 \"alg\" 为特定的排序算法（ \"Sort.InsertionSort\",
   \"Sort.QuickSort\", \"Sort.MergeSort\", 或 \"Sort.TimSort\" ），
   \"ord\" 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

"),

(E"Base.Sort",E"Base.Sort",E"sort!",E"sort!(...)

   原地排序。

"),

(E"Base.Sort",E"Base.Sort",E"sortby",E"sortby(v, by[, alg])

   根据 \"by(v)\" 对向量排序。 \"alg\" 为特定的排序算法（ \"Sort.InsertionSort\",
   \"Sort.QuickSort\", \"Sort.MergeSort\", 或 \"Sort.TimSort\" ）。

"),

(E"Base.Sort",E"Base.Sort",E"sortby!",E"sortby!(...)

   \"sortby\" 的原地版本

"),

(E"Base.Sort",E"Base.Sort",E"sortperm",E"sortperm(v[, alg[, ord]])

   返回排序向量，可用它对输入向量 \"v\" 进行排序。 \"alg\" 为特定的排序算法（
   \"Sort.InsertionSort\", \"Sort.QuickSort\", \"Sort.MergeSort\", 或
   \"Sort.TimSort\" ）， \"ord\" 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

"),

(E"Base.Sort",E"Base.Sort",E"issorted",E"issorted(v[, ord])

   判断向量是否为已经为升序排列。 \"ord\" 为自定义的排序顺序。

"),

(E"Base.Sort",E"Base.Sort",E"searchsorted",E"searchsorted(a, x[, ord])

   返回 \"a\" 中排序顺序不小于 \"x\" 的第一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

   \"searchsortedfirst()\" 的别名

"),

(E"Base.Sort",E"Base.Sort",E"searchsortedfirst",E"searchsortedfirst(a, x[, ord])

   返回 \"a\" 中排序顺序不小于 \"x\" 的第一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

(E"Base.Sort",E"Base.Sort",E"searchsortedlast",E"searchsortedlast(a, x[, ord])

   返回 \"a\" 中排序顺序不大于 \"x\" 的最后一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

(E"Base.Sort",E"Base.Sort",E"select",E"select(v, k[, ord])

   找到排序好的向量 \"v\" 中第 \"k\" 个位置的元素，在未排序时的索引值。 \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

(E"Base.Sort",E"Base.Sort",E"select!",E"select!(v, k[, ord])

   \"select\" 的原地版本

"),

(E"Sound",E"Sound",E"wavread",E"wavread(io[, options])

   Reads and returns the samples from a RIFF/WAVE file. The samples
   are converted to floating point values in the range from -1.0 to
   1.0 by default. The \"io\" argument accepts either an \"IO\" object
   or a filename (\"String\"). The options are passed via an
   \"Options\" object (see the \"OptionsMod\" module).

   The available options, and the default values, are:

   * \"format\" (default = \"double\"): changes the format of the
     returned samples. The string \"double\" returns double precision
     floating point values in the range -1.0 to 1.0. The string
     \"native\" returns the values as encoded in the file. The string
     \"size\" returns the number of samples in the file, rather than
     the actual samples.

   * \"subrange\" (default = \"Any\"): controls which samples are
     returned. The default, \"Any\" returns all of the samples.
     Passing a number (\"Real\"), \"N\", will return the first \"N\"
     samples of each channel. Passing a range (\"Range1{Real}\"),
     \"R\", will return the samples in that range of each channel.

   The returned values are:

   * \"y\": The acoustic samples; A matrix is returned for files that
     contain multiple channels.

   * \"Fs\": The sampling frequency

   * \"nbits\": The number of bits used to encode each sample

   * \"extra\": Any additional bytes used to encode the samples (is
     always \"None\")

   The following functions are also defined to make this function
   compatible with MATLAB:

      wavread(filename::String) = wavread(filename, @options)
      wavread(filename::String, fmt::String) = wavread(filename, @options format=fmt)
      wavread(filename::String, N::Int) = wavread(filename, @options subrange=N)
      wavread(filename::String, N::Range1{Int}) = wavread(filename, @options subrange=N)
      wavread(filename::String, N::Int, fmt::String) = wavread(filename, @options subrange=N format=fmt)
      wavread(filename::String, N::Range1{Int}, fmt::String) = wavread(filename, @options subrange=N format=fmt)

"),

(E"Sound",E"Sound",E"wavwrite",E"wavwrite(samples, io[, options])

      Writes samples to a RIFF/WAVE file io object. The \"io\"
      argument accepts either an \"IO\" object or a filename
      (\"String\"). The function assumes that the sample rate is 8 kHz
      and uses 16 bits to encode each sample. Both of these values can
      be changed with the options parameter. Each column of the data
      represents a different channel. Stereo files should contain two
      columns. The options are passed via an \"Options\" object (see
      the \"OptionsMod\" module).

      The available options, and the default values, are:

   * \"sample_rate\" (default = \"8000\"): sampling frequency

   * \"nbits\" (default = \"16\"): number of bits used to encode each
     sample

   * \"compression\" (default = \"WAVE_FORMAT_PCM\"): The desired
     compression technique; accepted values are: WAVE_FORMAT_PCM,
     WAVE_FORMAT_IEEE_FLOAT

   The type of the input array, samples, also affects the generated
   file. \"Native\" WAVE files are written when integers are passed
   into wavwrite. This means that the literal values are written into
   the file. The input ranges are as follows for integer samples.

   +--------+-------------+------------------------+---------------+
   | N Bits | y Data Type | y Data Range           | Output Format |
   +========+=============+========================+===============+
   | 8      | uint8       | 0 <= y <= 255          | uint8         |
   +--------+-------------+------------------------+---------------+
   | 16     | int16       | –32768 <= y <= +32767  | int16         |
   +--------+-------------+------------------------+---------------+
   | 24     | int32       | –2^23 <= y <= 2^23 – 1 | int32         |
   +--------+-------------+------------------------+---------------+

   If samples contains floating point values, the input data ranges
   are the following.

   +--------+------------------+-------------------+---------------+
   | N Bits | y Data Type      | y Data Range      | Output Format |
   +========+==================+===================+===============+
   | 8      | single or double | –1.0 <= y < +1.0  | uint8         |
   +--------+------------------+-------------------+---------------+
   | 16     | single or double | –1.0 <= y < +1.0  | int16         |
   +--------+------------------+-------------------+---------------+
   | 24     | single or double | –1.0 <= y < +1.0  | int32         |
   +--------+------------------+-------------------+---------------+
   | 32     | single or double | –1.0 <= y <= +1.0 | single        |
   +--------+------------------+-------------------+---------------+

   The following functions are also defined to make this function
   compatible with MATLAB:

      wavwrite(y::Array) = wavwrite(y, @options)
      wavwrite(y::Array, Fs::Real, filename::String) = wavwrite(y, filename, @options sample_rate=Fs)
      wavwrite(y::Array, Fs::Real, N::Real, filename::String) = wavwrite(y, filename, @options sample_rate=Fs nbits=N)

"),

(E"strpack.jl",E"",E"pack",E"pack(io, composite[, strategy])

   Create a packed buffer representation of \"composite\" in stream
   \"io\", using data alignment coded by \"strategy\". This buffer is
   suitable to pass as a \"struct\" argument in a \"ccall\".

"),

(E"strpack.jl",E"",E"unpack",E"unpack(io, T[, strategy])

   Extract an instance of the Julia composite type \"T\" from the
   packed representation in the stream \"io\". \"io\" must be
   positioned at the beginning (using \"seek\"). This allows you to
   read C \"struct\" outputs from \"ccall\".

"),

(E"TextWrap",E"TextWrap",E"wrap",E"wrap(string[, options])

   Returns a string in which newlines are inserted as appropriate in
   order for each line to fit within a specified width.

   The options are passed via an \"Options\" object (provided by the
   \"OptionsMod\" module). The available options, and their default
   values, are:

   * \"width\" (default = \"70\"): the maximum width of the wrapped
     text, including indentation.

   * \"initial_indent\" (default = \"\"\"\"): indentation of the first
     line. This can be any string (shorter than \"width\"), or it can
     be an integer number (lower than \"width\").

   * \"subsequent_indent\" (default = \"\"\"\"): indentation of all
     lines except the first. Works the same as \"initial_indent\".

   * \"break_on_hyphens\" (default = \"true\"): this flag determines
     whether words can be broken on hyphens, e.g. whether \"high-
     precision\" can be split into \"high-\" and \"precision\".

   * \"break_long_words\" (default = \"true\"): this flag determines
     what to do when a word is too long to fit in any line. If
     \"true\", the word will be broken, otherwise it will go beyond
     the desired text width.

   * \"replace_whitespace\" (default = \"true\"): if this flag is
     true, all whitespace characters in the original text (including
     newlines) will be replaced by spaces.

   * \"expand_tabs\" (default = \"true\"): if this flag is true, tabs
     will be expanded in-place into spaces. The expansion happens
     before whitespace replacement.

   * \"fix_sentence_endings\" (default = \"false\"): if this flag is
     true, the wrapper will try to recognize sentence endings in the
     middle of a paragraph and put two spaces before the next sentence
     in case only one is present.

"),

(E"TextWrap",E"TextWrap",E"println_wrapped",E"print_wrapped(text...[, options])
print_wrapped(io, text...[, options])
println_wrapped(text...[, options])
println_wrapped(io, text...[, options])

   These are just like the standard \"print()\" and \"println()\"
   functions (they print multiple arguments and accept an optional
   \"IO\" first argument), except that they wrap the result, and
   accept an optional last argument with the options to pass to
   \"wrap()\".

"),

(E"Zlib",E"Zlib",E"compress_bound",E"compress_bound(input_size)

   返回the maximum size of the compressed output buffer for a given
   uncompressed input size.

"),

(E"Zlib",E"Zlib",E"compress",E"compress(source[, level])

   Compresses source using the given compression level, and returns
   the compressed buffer (\"Array{Uint8,1}\").  \"level\" is an
   integer between 0 and 9, or one of \"Z_NO_COMPRESSION\",
   \"Z_BEST_SPEED\", \"Z_BEST_COMPRESSION\", or
   \"Z_DEFAULT_COMPRESSION\".  It defaults to
   \"Z_DEFAULT_COMPRESSION\".

   If an error occurs, \"compress\" throws a \"ZError\" with more
   information about the error.

"),

(E"Zlib",E"Zlib",E"compress_to_buffer",E"compress_to_buffer(source, dest, level=Z_DEFAULT_COMPRESSION)

   Compresses the source buffer into the destination buffer, and
   returns the number of bytes written into dest.

   If an error occurs, \"uncompress\" throws a \"ZError\" with more
   information about the error.

"),

(E"Zlib",E"Zlib",E"uncompress",E"uncompress(source[, uncompressed_size])

   Allocates a buffer of size \"uncompressed_size\", uncompresses
   source to this buffer using the given compression level, and
   returns the compressed buffer.  If \"uncompressed_size\" is not
   given, the size of the output buffer is estimated as
   \"2*length(source)\".  If the uncompressed_size is larger than
   uncompressed_size, the allocated buffer is grown and the
   uncompression is retried.

   If an error occurs, \"uncompress\" throws a \"ZError\" with more
   information about the error.

"),

(E"Zlib",E"Zlib",E"uncompress_to_buffer",E"uncompress_to_buffer(source, dest)

   Uncompresses the source buffer into the destination buffer. 返回the
   number of bytes written into dest.  An error is thrown if the
   destination buffer does not have enough space.

   If an error occurs, \"uncompress_to_buffer\" throws a \"ZError\"
   with more information about the error.

"),


}
