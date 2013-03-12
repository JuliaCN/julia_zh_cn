# automatically generated -- do not edit

{

("ArgParse","ArgParse","parse_args","parse_args([args], settings)

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

("ArgParse","ArgParse","@add_arg_table","@add_arg_table(settings, table...)

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

("ArgParse","ArgParse","add_arg_table","add_arg_table(settings, [arg_name [,arg_options]]...)

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

("ArgParse","ArgParse","add_arg_group","add_arg_group(settings, description[, name[, set_as_default]])

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

("ArgParse","ArgParse","set_default_arg_group","set_default_arg_group(settings[, name])

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

("ArgParse","ArgParse","import_settings","import_settings(settings, other_settings[, args_only])

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

("杂项","Base","exit","exit([code])

   退出（或在会话中按下 control-D ）。默认退出代码为 0 ，表示进程正常结束。

"),

("杂项","Base","whos","whos([Module,] [pattern::Regex])

   打印模块中全局变量的信息，可选择性地限制打印匹配 \"pattern\" 的变量。

"),

("杂项","Base","edit","edit(file::String[, line])

   编辑文件；可选择性地提供要编辑的行号。退出编辑器后返回 Julia 会话。如果文件后缀名为 \".jl\" ，关闭文件后会重载该文件。

"),

("杂项","Base","edit","edit(function[, types])

   编辑函数定义，可选择性地提供一个类型多元组以指明要编辑哪个方法。退出编辑器后，包含定义的源文件会被重载。

"),

("杂项","Base","require","require(file::String...)

   在 \"Main\" 模块的上下文中，对每个活动的节点，通过系统的 \"LOAD_PATH\"
   查找文件，并只载入一次。``require`` 是顶层操作，因此它设置当前的 \"include\"
   路径，但并不使用它来查找文件（参见 \"include\" 的帮助）。此函数常用来载入库代码； \"using\"
   函数隐含使用它来载入扩展包。

"),

("杂项","Base","reload","reload(file::String)

   类似 \"require\" ，但不管是否曾载入过，都要载入文件。常在交互式地开发库时使用。

"),

("杂项","Base","include","include(path::String)

   在当前上下文中，对源文件的内容求值。在包含的过程中，它将本地任务包含路径设置为包含文件的文件夹。嵌套调用 \"include\"
   时会搜索那个路径的相关的路径。并行运行时，所有的路径都指向节点 1 上文件，并从节点 1
   上获取文件。此函数常用来交互式地载入源文件，或将分散为多个源文件的扩展包结合起来。

"),

("杂项","Base","include_string","include_string(code::String)

   类似 \"include\" ，但它从指定的字符串读取代码，而不是从文件中。由于没有涉及到文件路径，不会进行路径处理或从节点 1
   获取文件。

"),

("杂项","Base","evalfile","evalfile(path::String)

   对指定文件的所有表达式求值，并返回最后一个表达式的值。不会进行其他处理（搜索路径，从节点 1 获取文件等）。

"),

("杂项","Base","help","help(name)

   获得函数帮助。 \"name\" 可以是对象或字符串。

"),

("杂项","Base","apropos","apropos(string)

   查询文档中与 \"string\" 相关的函数。

"),

("杂项","Base","which","which(f, args...)

   对指定的参数，显示应调用 \"f\" 的哪个方法。

"),

("杂项","Base","methods","methods(f)

   显示 \"f\" 的所有方法及其对应的参数类型。

"),

("杂项","Base","methodswith","methodswith(t)

   显示 \"t\" 类型的所有方法。

"),

("所有对象","Base","is","is(x, y)

   判断 \"x\" 与 \"y\" 是否相同，依据为程序不能区分它们。

"),

("所有对象","Base","isa","isa(x, type)

   判断 \"x\" 是否为指定类型。

"),

("所有对象","Base","isequal","isequal(x, y)

   当且仅当 \"x\" 和 \"y\" 内容相同是为真。粗略地说，即打印出来的 \"x\" 和 \"y\" 看起来一模一样。

"),

("所有对象","Base","isless","isless(x, y)

   判断 \"x\" 是否比 \"y\" 小。它具有与 \"isequal\" 一致的整体排序。不能正常排序的值如 \"NaN\"
   ，会按照任意顺序排序，但其排序方式会保持一致。它是 \"sort\" 默认使用的比较函数。可进行排序的非数值类型，应当实现此方法。

"),

("所有对象","Base","typeof","typeof(x)

   返回 \"x\" 的具体类型。

"),

("所有对象","Base","tuple","tuple(xs...)

   构造指定对象的多元组。

"),

("所有对象","Base","ntuple","ntuple(n, f::Function)

   构造长度为 \"n\" 的多元组，每个元素为 \"f(i)\" ，其中 \"i\" 为元素的索引值。

"),

("所有对象","Base","object_id","object_id(x)

   获取 \"x\" 唯一的整数值 ID 。当且仅当 \"is(x,y)\" 时， \"object_id(x) ==
   object_id(y)\" 。

"),

("所有对象","Base","hash","hash(x)

   计算整数哈希值。因而 \"isequal(x,y)\" 等价于 \"hash(x) == hash(y)\" 。

"),

("所有对象","Base","finalizer","finalizer(x, function)

   当对 \"x\" 的引用处于程序不可用时，注册一个注册可调用的函数 \"f(x)\" 来终结这个引用。当 \"x\"
   为位类型时，此函数的行为不可预测。

"),

("所有对象","Base","copy","copy(x)

   构造 \"x\" 的浅拷贝：仅复制外层结构，不复制内部值。如，复制数组时，会生成一个元素与原先完全相同的新数组。

"),

("所有对象","Base","deepcopy","deepcopy(x)

   构造 \"x\" 的深拷贝：递归复制所有的东西，返回一个完全独立的对象。如，深拷贝数组时，会生成一个元素为原先元素深拷贝的新数组。

   作为特例，匿名函数只能深拷贝，非匿名函数则为浅拷贝。它们的区别仅与闭包有关，例如含有隐藏的内部引用的函数。

   While it isn't normally necessary,自定义类型可通过定义特殊版本的
   \"deepcopy_internal(x::T, dict::ObjectIdDict)\"
   函数（此函数其它情况下不应使用）来覆盖默认的 \"deepcopy\" 行为，其中 \"T\" 是要指明的类型， \"dict\"
   记录迄今为止递归中复制的对象。在定义中， \"deepcopy_internal\" 应当用来代替 \"deepcopy\" ，
   \"dict\" 变量应当在返回前正确的更新。

"),

("所有对象","Base","convert","convert(type, x)

   试着将 \"x\" 转换为指定类型。

"),

("所有对象","Base","promote","promote(xs...)

   将所有参数转换为共同的提升类型（如果有的话），并将它们（作为多元组）返回。

"),

("类型","Base","subtype","subtype(type1, type2)

   仅在 \"type1\" 的所有值都是 \"type2\" 时为真。也可使用 \"<:\" 中缀运算符，写为 \"type1 <:
   type2\" 。

"),

("类型","Base","typemin","typemin(type)

   指定（实数）数值类型可表示的最小值。

"),

("类型","Base","typemax","typemax(type)

   指定（实数）数值类型可表示的最大值。

"),

("类型","Base","realmin","realmin(type)

   指定的浮点数类型可表示的非反常值中，绝对值最小的数。

"),

("类型","Base","realmax","realmax(type)

   指定的浮点数类型可表示的最大的有穷数。

"),

("类型","Base","maxintfloat","maxintfloat(type)

   指定的浮点数类型可无损表示的最大整数。

"),

("类型","Base","sizeof","sizeof(type)

   指定类型的权威二进制表示（如果有的话）所占的字节大小。

"),

("类型","Base","eps","eps([type])

   1.0 与下一个稍大的 \"type\" 类型可表示的浮点数之间的距离。有效的类型为 \"Float32\" 和
   \"Float64\" 。如果省略 \"type\" ，则返回 \"eps(Float64)\" 。

"),

("类型","Base","eps","eps(x)

   \"x\" 与下一个稍大的 \"x\" 同类型可表示的浮点数之间的距离。

"),

("类型","Base","promote_type","promote_type(type1, type2)

   如果可能的话，给出可以无损表示每个参数类型值的类型。若不存在无损表示时，可以容忍有损；如
   \"promote_type(Int64,Float64)\" 返回 \"Float64\" ，尽管严格来说，并非所有的
   \"Int64\" 值都可以由 \"Float64\" 无损表示。

"),

("通用函数","Base","method_exists","method_exists(f, tuple) -> Bool

   判断指定的通用函数是否有匹配参数类型多元组的方法。

   **例子** ： \"method_exists(length, (Array,)) = true\"

"),

("通用函数","Base","applicable","applicable(f, args...)

   判断指定的通用函数是否有可用于指定参数的方法。

"),

("通用函数","Base","invoke","invoke(f, (types...), args...)

   对指定的参数，为匹配指定类型（多元组）的通用函数指定要调用的方法。参数应与指定的类型兼容。它允许在最匹配的方法之外，指定一个方法。这对
   明确需要一个更通用的定义的行为时非常有用（通常作为相同函数的更特殊的方法实现的一部分）。

"),

("通用函数","Base","|","|(x, f)

   对前面的参数应用一个函数，方便写链式函数。

   **例子** ： \"[1:5] | x->x.^2 | sum | inv\"

"),

("迭代","Base","start","start(iter) -> state

   获取可迭代对象的初始迭代状态。

"),

("迭代","Base","done","done(iter, state) -> Bool

   判断迭代是否完成。

"),

("迭代","Base","next","next(iter, state) -> item, state

   对指定的可迭代对象和迭代状态，返回当前项和下一个迭代状态。

"),

("迭代","Base","zip","zip(iters...)

   对一组迭代对象，返回一组可迭代多元组，其中第 \"i\" 个多元组包含每个可迭代输入的第 \"i\" 个分量。

   注意 \"zip\" 是它自己的逆操作： \"[zip(zip(a...)...)...] == [a...]\" 。

"),

("通用集合","Base","isempty","isempty(collection) -> Bool

   判断集合是否为空（没有元素）。

"),

("通用集合","Base","empty!","empty!(collection) -> collection

   移除集合中的所有元素。

"),

("通用集合","Base","length","length(collection) -> Integer

   对可排序、可索引的集合，用于 \"getindex(collection, i)\" 最大索引值 \"i\"
   是有效的。对不可排序的集合，结果为元素个数。

"),

("通用集合","Base","endof","endof(collection) -> Integer

   返回集合的最后一个索引值。

   **例子** ： \"endof([1,2,4]) = 3\"

"),

("可迭代集合","Base","contains","contains(itr, x) -> Bool

   判断集合是否包含指定值 \"x\" 。

"),

("可迭代集合","Base","findin","findin(a, b)

   返回曾在集合 \"b\" 中出现的，集合 \"a\"  中元素的索引值。

"),

("可迭代集合","Base","unique","unique(itr)

   返回 \"itr\" 中去除多余重复元素的数组。

"),

("可迭代集合","Base","reduce","reduce(op, v0, itr)

   使用指定的运算符约简指定集合， \"v0\" 为约简的初始值。一些常用运算符的缩减，有更简便的单参数格式： \"max(itr)\",
   \"min(itr)\", \"sum(itr)\", \"prod(itr)\", \"any(itr)\",
   \"all(itr)\".

"),

("可迭代集合","Base","max","max(itr)

   返回集合中最大的元素。

"),

("可迭代集合","Base","min","min(itr)

   返回集合中最小的元素。

"),

("可迭代集合","Base","indmax","indmax(itr) -> Integer

   返回集合中最大的元素的索引值。

"),

("可迭代集合","Base","indmin","indmin(itr) -> Integer

   返回集合中最小的元素的索引值。

"),

("可迭代集合","Base","findmax","findmax(itr) -> (x, index)

   返回最大的元素及其索引值。

"),

("可迭代集合","Base","findmin","findmin(itr) -> (x, index)

   返回最小的元素及其索引值。

"),

("可迭代集合","Base","sum","sum(itr)

   返回集合中所有元素的和。

"),

("可迭代集合","Base","prod","prod(itr)

   返回集合中所有元素的乘积。

"),

("可迭代集合","Base","any","any(itr) -> Bool

   判断布尔值集合中是否有为真的元素。

"),

("可迭代集合","Base","all","all(itr) -> Bool

   判断布尔值集合中是否所有的元素都为真。

"),

("可迭代集合","Base","count","count(itr) -> Integer

   \"itr\" 中为真的布尔值元素的个数。

"),

("可迭代集合","Base","countp","countp(p, itr) -> Integer

   \"itr\" 中断言 \"p\" 为真的布尔值元素的个数。

"),

("可迭代集合","Base","any","any(p, itr) -> Bool

   判断 \"itr\" 中是否存在使指定断言为真的元素。

"),

("可迭代集合","Base","all","all(p, itr) -> Bool

   判断 \"itr\" 中是否所有元素都使指定断言为真。

"),

("可迭代集合","Base","map","map(f, c) -> collection

   使用 \"f\" 遍历集合 \"c\" 的每个元素。

   **例子** ： \"map((x) -> x * 2, [1, 2, 3]) = [2, 4, 6]\"

"),

("可迭代集合","Base","map!","map!(function, collection)

   \"map()\" 的原地版本。

"),

("可迭代集合","Base","mapreduce","mapreduce(f, op, itr)

   使用 \"f\" 遍历集合 \"c\" 的每个元素，然后使用二元函数 \"op\" 对结果进行约简。

   **例子** ： \"mapreduce(x->x^2, +, [1:3]) == 1 + 4 + 9 == 14\"

"),

("可迭代集合","Base","first","first(coll)

   获取可排序集合的第一个元素。

"),

("可迭代集合","Base","last","last(coll)

   获取可排序集合的最后一个元素。

"),

("可索引集合","Base","getindex","getindex(collection, key...)

   取回集合中存储在指定 key 键或索引值内的值。语法 \"a[i,j,...]\" 由编译器转换为 \"getindex(a, i,
   j, ...)\" 。

"),

("可索引集合","Base","setindex!","setindex!(collection, value, key...)

   将指定值存储在集合的指定 key 键或索引值内。语法 \"a[i,j,...] = x\" 由编译器转换为
   \"setindex!(a, x, i, j, ...)\" 。

"),

("关联性集合","Base","Dict{K,V}","Dict{K,V}()

   使用 K 类型的 key 和 V 类型的值来构造哈希表。

"),

("关联性集合","Base","has","has(collection, key)

   判断集合是否含有指定 key 的映射。

"),

("关联性集合","Base","get","get(collection, key, default)

   返回指定 key 存储的值；当前没有 key 的映射时，返回默认值。

"),

("关联性集合","Base","getkey","getkey(collection, key, default)

   如果参数 \"key\" 匹配 \"collection\" 中的 key ，将其返回；否在返回 \"default\" 。

"),

("关联性集合","Base","delete!","delete!(collection, key)

   删除集合中指定 key 的映射。

"),

("关联性集合","Base","empty!","empty!(collection)

   删除集合中所有的 key 。

"),

("关联性集合","Base","keys","keys(collection)

   返回集合中所有 key 组成的数组。

"),

("关联性集合","Base","values","values(collection)

   返回集合中所有值组成的数组。

"),

("关联性集合","Base","collect","collect(collection)

   返回集合中的所有项。对关联性集合，返回 (key, value) 多元组。

"),

("关联性集合","Base","merge","merge(collection, others...)

   使用指定的集合构造归并集合。

"),

("关联性集合","Base","merge!","merge!(collection, others...)

   将其它集合中的对儿更新进 \"collection\" 。

"),

("关联性集合","Base","filter","filter(function, collection)

   返回集合的浅拷贝，移除使 \"function\" 函数为假的 (key, value) 对儿。

"),

("关联性集合","Base","filter!","filter!(function, collection)

   更新集合，移除使 \"function\" 函数为假的 (key, value) 对儿。

"),

("关联性集合","Base","eltype","eltype(collection)

   返回集合中包含的 (key,value) 对儿的类型多元组。

"),

("关联性集合","Base","sizehint","sizehint(s, n)

   使集合 \"s\" 保留最少 \"n\" 个元素的容量。这样可提高性能。

"),

("类集集合","Base","add!","add!(collection, key)

   向类集集合添加元素。

"),

("类集集合","Base","add_each!","add_each!(collection, iterable)

   Adds each element in iterable to the collection.

"),

("类集集合","Base","Set","Set(x...)

   使用指定元素来构造 \"Set\" 。Should be used instead of \"IntSet\" for sparse
   integer sets.

"),

("类集集合","Base","IntSet","IntSet(i...)

   使用指定元素来构造 \"IntSet\" 。Implemented as a bit string, and therefore
   good for dense integer sets.

"),

("类集集合","Base","union","union(s1, s2...)

   构造两个及两个以上集合的共用体。Maintains order with arrays.

"),

("类集集合","Base","union!","union!(s1, s2)

   构造 \"IntSet\"  s1 和 s2 的共用体，将结果保存在 \"s1\" 中。

"),

("类集集合","Base","intersect","intersect(s1, s2...)

   构造the intersection of two or more sets. Maintains order with
   arrays.

"),

("类集集合","Base","setdiff","setdiff(s1, s2)

   使用存在于 \"s1\" 且不在 \"s2\" 的元素来构造集合。Maintains order with arrays.

"),

("类集集合","Base","symdiff","symdiff(s1, s2...)

   构造the symmetric difference of elements in the passed in sets or
   arrays. Maintains order with arrays.

"),

("类集集合","Base","symdiff!","symdiff!(s, n)

   IntSet s is destructively modified to toggle the inclusion of
   integer \"n\".

"),

("类集集合","Base","symdiff!","symdiff!(s, itr)

   For each element in \"itr\", destructively toggle its inclusion in
   set \"s\".

"),

("类集集合","Base","symdiff!","symdiff!(s1, s2)

   构造the symmetric difference of IntSets \"s1\" and \"s2\", storing
   the result in \"s1\".

"),

("类集集合","Base","complement","complement(s)

   返回 \"IntSet\" s 的补集。

"),

("类集集合","Base","complement!","complement!(s)

   Mutates IntSet s into its set-complement.

"),

("类集集合","Base","del_each!","del_each!(s, itr)

   删除each element of itr in set s in-place.

"),

("类集集合","Base","intersect!","intersect!(s1, s2)

   Intersects IntSets s1 and s2 and overwrites the set s1 with the
   result. If needed, s1 will be expanded to the size of s2.

"),

("双端队列","Base","push!","push!(collection, item) -> collection

   在集合尾端插入一项。

"),

("双端队列","Base","pop!","pop!(collection) -> item

   移除集合的最后一项，并将其返回。

"),

("双端队列","Base","unshift!","unshift!(collection, item) -> collection

   在集合首端插入一项。

"),

("双端队列","Base","shift!","shift!(collection) -> item

   移除集合首项。

"),

("双端队列","Base","insert!","insert!(collection, index, item)

   在指定索引值处插入一项。

"),

("双端队列","Base","delete!","delete!(collection, index) -> item

   移除指定索引值处的项，并返回删除项。

"),

("双端队列","Base","delete!","delete!(collection, range) -> items

   移除指定范围内的项，并返回包含删除项的集合。

"),

("双端队列","Base","resize!","resize!(collection, n) -> collection

   改变集合的大小，使其可包含 \"n\" 个元素。

"),

("双端队列","Base","append!","append!(collection, items) -> collection

   将 \"items\" 元素附加到集合末尾。

"),

("字符串","Base","length","length(s)

   字符串 \"s\" 中的字符数。

"),

("字符串","Base","collect","collect(string)

   返回 \"string\" 中的字符数组。

"),

("字符串","Base","*","*(s, t)

   连接字符串。

   **例子** ： \"\"Hello \" * \"world\" == \"Hello world\"\"

"),

("字符串","Base","^","^(s, n)

   将字符串 \"s\" 重复 \"n\" 次。

   **例子** ： \"\"Julia \"^3 == \"Julia Julia Julia \"\"

"),

("字符串","Base","string","string(char...)

   使用指定字符构造字符串。

"),

("字符串","Base","string","string(x)

   使用 \"print\" 函数的值构造字符串。

"),

("字符串","Base","repr","repr(x)

   使用 \"show\" 函数的值构造字符串。

"),

("字符串","Base","bytestring","bytestring(::Ptr{Uint8})

   从 C （以 0 结尾的）格式字符串的地址构造一个字符串。它使用了浅拷贝；可以安全释放指针。

"),

("字符串","Base","bytestring","bytestring(s)

   将字符串转换为连续的字节数组，从而可将它传递给 C 函数。

"),

("字符串","Base","ascii","ascii(::Array{Uint8, 1})

   从字节数组构造 ASCII 字符串。

"),

("字符串","Base","ascii","ascii(s)

   将字符串转换为连续的 ASCII 字符串（所有的字符都是有效的 ASCII 字符）。

"),

("字符串","Base","utf8","utf8(::Array{Uint8, 1})

   从字节数组构造 UTF-8 字符串。

"),

("字符串","Base","utf8","utf8(s)

   将字符串转换为连续的 UTF-8 字符串（所有的字符都是有效的 UTF-8 字符）。

"),

("字符串","Base","is_valid_ascii","is_valid_ascii(s) -> Bool

   如果字符串是有效的 ASCII ，返回真；否则返回假。

"),

("字符串","Base","is_valid_utf8","is_valid_utf8(s) -> Bool

   如果字符串是有效的 UTF-8 ，返回真；否则返回假。

"),

("字符串","Base","check_ascii","check_ascii(s)

   对字符串调用 \"is_valid_ascii()\" 。如果它不是有效的，则抛出错误。

"),

("字符串","Base","check_utf8","check_utf8(s)

   对字符串调用 \"is_valid_utf8()\" 。如果它不是有效的，则抛出错误。

"),

("字符串","Base","byte_string_classify","byte_string_classify(s)

   如果字符串不是有效的 ASCII 或 UTF-8 ，则返回 0 ；如果是有效的 ASCII，则返回 1 ；如果是有效的
   UTF-8，则返回 2 。

"),

("字符串","Base","search","search(string, char[, i])

   返回 \"string\" 中 \"char\" 的索引值；如果没找到，则返回 0
   。第二个参数也可以是字符向量或集合。第三个参数是可选的，它指明起始索引值。

"),

("字符串","Base","ismatch","ismatch(r::Regex, s::String)

   判断字符串是否匹配指定的正则表达式。

"),

("字符串","Base","lpad","lpad(string, n, p)

   在字符串左侧填充一系列 \"p\" ，以保证字符串至少有 \"n\" 个字符。

"),

("字符串","Base","rpad","rpad(string, n, p)

   在字符串右侧填充一系列 \"p\" ，以保证字符串至少有 \"n\" 个字符。

"),

("字符串","Base","search","search(string, chars[, start])

   在指定字符串中查找指定字符。第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式（但正则表达式仅用来处理连续字符串，如
   ASCII 或 UTF-8 字符串）。第三个参数是可选的，它指明起始索引值。返回值为所找到的匹配序列的索引值范围，它满足
   \"s[search(s,x)] == x\" 。如果没有匹配，则返回值为 \"0:-1\" 。

"),

("字符串","Base","replace","replace(string, pat, r[, n])

   查找指定模式 \"pat\" ，并替换为 \"r\" 。如果提供 \"n\" ，则最多替换 \"n\"
   次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

"),

("字符串","Base","replace","replace(string, pat, f[, n])

   查找指定模式 \"pat\" ，并替换为 \"f(pat)\" 。如果提供 \"n\" ，则最多替换 \"n\"
   次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

"),

("字符串","Base","split","split(string, [chars, [limit,] [include_empty]])

   返回由指定字符分割符所分割的指定字符串的字符串数组。分隔符可由 \"search\"
   的第二个参数所允许的任何格式所指明（如单字符、字符集合、字符串、或正则表达式）。如果省略 \"chars\"
   ，则它默认为整个空白字符集，且 \"include_empty\"
   默认为假。最后两个参数是可选的：它们是结果的最大长度，且由标志位决定是否在结果中包括空域。

"),

("字符串","Base","strip","strip(string[, chars])

   返回去除头部、尾部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

("字符串","Base","lstrip","lstrip(string[, chars])

   返回去除头部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

("字符串","Base","rstrip","rstrip(string[, chars])

   返回去除尾部空白的 \"string\" 。如果提供了字符串 \"chars\" ，则去除字符串中包含的字符。

"),

("字符串","Base","begins_with","begins_with(string, prefix)

   如果 \"string\" 以 \"prefix\" 开始，则返回 \"true\" 。

"),

("字符串","Base","ends_with","ends_with(string, suffix)

   如果 \"string\" 以 \"suffix\" 结尾，则返回 \"true\" 。

"),

("字符串","Base","uppercase","uppercase(string)

   返回所有字符转换为大写的 \"string\" 。

"),

("字符串","Base","lowercase","lowercase(string)

   返回所有字符转换为小写的 \"string\" 。

"),

("字符串","Base","join","join(strings, delim)

   将字符串数组合并为一个字符串，在邻接字符串间添加分隔符 \"delim\" 。

"),

("字符串","Base","chop","chop(string)

   移除字符串的最后一个字符。

"),

("字符串","Base","chomp","chomp(string)

   移除字符串最后的换行符。

"),

("字符串","Base","ind2chr","ind2chr(string, i)

   给出字符串中递增至索引值 i 的字符数。

"),

("字符串","Base","chr2ind","chr2ind(string, i)

   给出字符串中第 i 个字符的索引值。

"),

("字符串","Base","isvalid","isvalid(str, i)

   判断指定字符串的第 \"i\" 个索引值处是否是有效字符。

"),

("字符串","Base","nextind","nextind(str, i)

   获取索引值 \"i\" 处之后的有效字符的索引值。如果在字符串末尾，则返回 \"endof(str)+1\" 。

"),

("字符串","Base","prevind","prevind(str, i)

   获取索引值 \"i\" 处之前的有效字符的索引值。如果在字符串开头，则返回 \"0\" 。

"),

("字符串","Base","thisind","thisind(str, i)

   返回索引值 \"i\" 处所在的有效字符的索引值。

"),

("字符串","Base","randstring","randstring(len)

   构造长度为 \"len\" 的随机 ASCII 字符串。有效的字符为大小写字母和数字 0-9 。

"),

("字符串","Base","charwidth","charwidth(c)

   Gives the number of columns needed to print a character.

"),

("字符串","Base","strwidth","strwidth(s)

   Gives the number of columns needed to print a string.

"),

("字符串","Base","isalnum","isalnum(c::Char)

   判断字符是否为字母或数字。

"),

("字符串","Base","isalpha","isalpha(c::Char)

   判断字符是否为字母。

"),

("字符串","Base","isascii","isascii(c::Char)

   判断字符是否属于 ASCII 字符集。

"),

("字符串","Base","isblank","isblank(c::Char)

   判断字符是否为 tab 或空格。

"),

("字符串","Base","iscntrl","iscntrl(c::Char)

   判断字符是否为控制字符。

"),

("字符串","Base","isdigit","isdigit(c::Char)

   判断字符是否为一位数字（0-9）。

"),

("字符串","Base","isgraph","isgraph(c::Char)

   判断字符是否可打印，且不是空白字符。

"),

("字符串","Base","islower","islower(c::Char)

   判断字符是否为小写字母。

"),

("字符串","Base","isprint","isprint(c::Char)

   判断字符是否可打印，包括空白字符。

"),

("字符串","Base","ispunct","ispunct(c::Char)

   判断字符是否可打印，且既非空白字符也非字母或数字。

"),

("字符串","Base","isspace","isspace(c::Char)

   判断字符是否为任意空白字符。

"),

("字符串","Base","isupper","isupper(c::Char)

   判断字符是否为大写字母。

"),

("字符串","Base","isxdigit","isxdigit(c::Char)

   判断字符是否为有效的十六进制字符。

"),

("I/O","Base","STDOUT","STDOUT

   指向标准输出流的全局变量。

"),

("I/O","Base","STDERR","STDERR

   指向标准错误流的全局变量。

"),

("I/O","Base","STDIN","STDIN

   指向标准输入流的全局变量。

"),

("I/O","Base","open","open(file_name[, read, write, create, truncate, append]) -> IOStream

   按五个布尔值参数指明的模式打开文件。默认以只读模式打开文件。返回操作文件的流。

"),

("I/O","Base","open","open(file_name[, mode]) -> IOStream

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

("I/O","Base","open","open(file_name) -> IOStream

   以只读模式打开文件。

"),

("I/O","Base","open","open(f::function, args...)

   Apply the function \"f\" to the result of \"open(args...)\" and
   close the resulting file descriptor upon completion.

   **例子** ： \"open(readall, \"file.txt\")\"

"),

("I/O","Base","memio","memio([size[, finalize::Bool]]) -> IOStream

   构造an in-memory I/O stream, optionally specifying how much initial
   space is needed.

"),

("I/O","Base","fdio","fdio(fd::Integer[, own::Bool]) -> IOStream
fdio(name::String, fd::Integer, [own::Bool]]) -> IOStream

   构造an \"IOStream\" object from an integer file descriptor. If
   \"own\" is true, closing this object will close the underlying
   descriptor. By default, an \"IOStream\" is closed when it is
   garbage collected. \"name\" allows you to associate the descriptor
   with a named file.

"),

("I/O","Base","flush","flush(stream)

   Commit all currently buffered writes to the given stream.

"),

("I/O","Base","close","close(stream)

   关闭 I/O 流。它将在关闭前先做一次 \"flush\" 。

"),

("I/O","Base","write","write(stream, x)

   Write the canonical binary representation of a value to the given
   stream.

"),

("I/O","Base","read","read(stream, type)

   Read a value of the given type from a stream, in canonical binary
   representation.

"),

("I/O","Base","read","read(stream, type, dims)

   Read a series of values of the given type from a stream, in
   canonical binary representation. \"dims\" is either a tuple or a
   series of integer arguments specifying the size of \"Array\" to
   return.

"),

("I/O","Base","position","position(s)

   获取流的当前位置。

"),

("I/O","Base","seek","seek(s, pos)

   将流定位到指定位置。

"),

("I/O","Base","seek_end","seek_end(s)

   将流定位到尾端。

"),

("I/O","Base","skip","skip(s, offset)

   Seek a stream relative to the current position.

"),

("I/O","Base","eof","eof(stream)

   判断 I/O 流是否到达文件尾。If the stream is not yet exhausted, this function
   will block to wait for more data if necessary, and then return
   \"false\". Therefore it is always safe to read one byte after
   seeing \"eof\" return \"false\".

"),

("文本 I/O","Base","show","show(x)

   Write an informative text representation of a value to the current
   output stream. New types should overload \"show(io, x)\" where the
   first argument is a stream.

"),

("文本 I/O","Base","print","print(x)

   Write (to the default output stream) a canonical (un-decorated)
   text representation of a value if there is one, otherwise call
   \"show\".

"),

("文本 I/O","Base","println","println(x)

   使用 \"print()\" 打印 \"x\" ，并接一个换行符。

"),

("文本 I/O","Base","@printf","@printf(\"%Fmt\", args...)

   Print arg(s) using C \"printf()\" style format specification
   string.

"),

("文本 I/O","Base","@sprintf","@sprintf(stream::IOStream, \"%Fmt\", args...)

   Write \"@printf\" formatted output arg(s) to stream.

"),

("文本 I/O","Base","showall","showall(x)

   Show x, printing all elements of arrays

"),

("文本 I/O","Base","dump","dump(x)

   Write a thorough text representation of a value to the current
   output stream.

"),

("文本 I/O","Base","readall","readall(stream)

   Read the entire contents of an I/O stream as a string.

"),

("文本 I/O","Base","readline","readline(stream)

   读取一行文本，包括末尾的换行符（不管输入是否结束，遇到换行符就返回）。

"),

("文本 I/O","Base","readuntil","readuntil(stream, delim)

   Read a string, up to and including the given delimiter byte.

"),

("文本 I/O","Base","readlines","readlines(stream)

   将读入的所有行返回为数组。

"),

("文本 I/O","Base","each_line","each_line(stream)

   构造an iterable object that will yield each line from a stream.

"),

("文本 I/O","Base","readdlm","readdlm(filename, delim::Char)

   Read a matrix from a text file where each line gives one row, with
   elements separated by the given delimeter. If all data is numeric,
   the result will be a numeric array. If some elements cannot be
   parsed as numbers, a cell array of numbers and strings is returned.

"),

("文本 I/O","Base","readdlm","readdlm(filename, delim::Char, T::Type)

   Read a matrix from a text file with a given element type. If \"T\"
   is a numeric type, the result is an array of that type, with any
   non-numeric elements as \"NaN\" for floating-point types, or zero.
   Other useful values of \"T\" include \"ASCIIString\", \"String\",
   and \"Any\".

"),

("文本 I/O","Base","writedlm","writedlm(filename, array, delim::Char)

   Write an array to a text file using the given delimeter (defaults
   to comma).

"),

("文本 I/O","Base","readcsv","readcsv(filename[, T::Type])

   Equivalent to \"readdlm\" with \"delim\" set to comma.

"),

("文本 I/O","Base","writecsv","writecsv(filename, array)

   Equivalent to \"writedlm\" with \"delim\" set to comma.

"),

("内存映射 I/O","Base","mmap_array","mmap_array(type, dims, stream[, offset])

   使用内存映射构造数组，数组的值连接到文件。它提供了处理对计算机内存来说过于庞大数据的简便方法。

   \"type\" 决定了如何解释数组中的字节（不使用格式转换）。 \"dims\" 是包含字节大小的多元组。

   文件是由 \"stream\" 指明的。初始化流时，对“只读”数组使用 “r” ，使用 \"w+\"
   新建用于向硬盘写入值的数组。可以选择指明偏移值（单位为字节），用来跳过文件头等。

   **例子** ：  A = mmap_array(Int64, (25,30000), s)

   它将构造一个 25 x 30000 的 Int64 类型的数列，它链接到与流 s 有关的文件上。

"),

("内存映射 I/O","Base","msync","msync(array)

   对内存映射数组的内存中的版本和硬盘上的版本强制同步。程序员可能不需要调用此函数，因为操作系统在休息时自动同步。但是，如果你担心丢失一个
   需要很长时间来运算的结果，就可以直接调用此函数。

"),

("内存映射 I/O","Base","mmap","mmap(len, prot, flags, fd, offset)

   mmap 系统调用的低级接口。

"),

("内存映射 I/O","Base","munmap","munmap(pointer, len)

   取消内存映射的低级接口。对于 mmap_array 则不需要直接调用此函数；当数组离开作用域时，会自动取消内存映射。

"),

("数学函数","Base","-","-(x)

   一元减运算符。

"),

("数学函数","Base","+","+(x, y)

   二元加运算符。

"),

("数学函数","Base","-","-(x, y)

   二元减运算符。

"),

("数学函数","Base","*","*(x, y)

   二元乘运算符。

"),

("数学函数","Base","/","/(x, y)

   二元左除运算符。

"),

("数学函数","Base","\\","\\(x, y)

   二元右除运算符。

"),

("数学函数","Base","^","^(x, y)

   二元指数运算符。

"),

("数学函数","Base","+",".+(x, y)

   逐元素二元加运算符。

"),

("数学函数","Base","-",".-(x, y)

   逐元素二元减运算符。

"),

("数学函数","Base","*",".*(x, y)

   逐元素二元乘运算符。

"),

("数学函数","Base","/","./(x, y)

   逐元素二元左除运算符。

"),

("数学函数","Base","\\",".\\(x, y)

   逐元素二元右除运算符。

"),

("数学函数","Base","^",".^(x, y)

   逐元素二元指数运算符。

"),

("数学函数","Base","div","div(a, b)

   截断取整除法；商向 0 舍入。

"),

("数学函数","Base","fld","fld(a, b)

   向下取整除法；商向 -Inf 舍入。

"),

("数学函数","Base","mod","mod(x, m)

   取模余数；满足 x == fld(x,m)*m + mod(x,m) ，与 m 同号，返回值范围 [0,m) 。

"),

("数学函数","Base","rem","rem(x, m)

   除法余数；满足 x == div(x,m)*m + rem(x,m) ，与 x 同号。

"),

("数学函数","Base","%","%(x, m)

   除法余数。 \"rem\" 的运算符形式。

"),

("数学函数","Base","mod1","mod1(x, m)

   整除后取模，返回值范围为 (0,m] 。

"),

("数学函数","Base","//","//(num, den)

   分数除法。

"),

("数学函数","Base","num","num(x)

   分数 \"x\" 的分子。

"),

("数学函数","Base","den","den(x)

   分数 \"x\" 的分母。

"),

("数学函数","Base","<<","<<(x, n)

   左移运算符。

"),

("数学函数","Base",">>",">>(x, n)

   右移运算符。

"),

("数学函数","Base","==","==(x, y)

   相等运算符。

"),

("数学函数","Base","!=","!=(x, y)

   不等运算符。

"),

("数学函数","Base","<","<(x, y)

   小于运算符。

"),

("数学函数","Base","<=","<=(x, y)

   小于等于运算符。

"),

("数学函数","Base",">",">(x, y)

   大于运算符。

"),

("数学函数","Base",">=",">=(x, y)

   大于等于运算符。

"),

("数学函数","Base","cmp","cmp(x, y)

   根据 \"x<y\", \"x==y\", 或 \"x>y\" 三种情况，对应返回 -1, 0, 或 1 。

"),

("数学函数","Base","!","!(x)

   逻辑非。

"),

("数学函数","Base","~","~(x)

   按位取反。

"),

("数学函数","Base","&","&(x, y)

   逻辑与。

"),

("数学函数","Base","|","|(x, y)

   逻辑或。

"),

("数学函数","Base","\$","\$(x, y)

   按位异或。

"),

("数学函数","Base","sin","sin(x)

   计算 \"x\" 的正弦值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","cos","cos(x)

   计算 \"x\" 的余弦值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","tan","tan(x)

   计算 \"x\" 的正切值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","sind","sind(x)

   计算 \"x\" 的正弦值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","cosd","cosd(x)

   计算 \"x\" 的余弦值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","tand","tand(x)

   计算 \"x\" 的正切值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","sinh","sinh(x)

   计算 \"x\" 的双曲正弦值。

"),

("数学函数","Base","cosh","cosh(x)

   计算 \"x\" 的双曲余弦值。

"),

("数学函数","Base","tanh","tanh(x)

   计算 \"x\" 的双曲正切值。

"),

("数学函数","Base","asin","asin(x)

   计算 \"x\" 的反正弦值，结果的单位为弧度。

"),

("数学函数","Base","acos","acos(x)

   计算 \"x\" 的反余弦值，结果的单位为弧度。

"),

("数学函数","Base","atan","atan(x)

   计算 \"x\" 的反正切值，结果的单位为弧度。

"),

("数学函数","Base","atan2","atan2(y, x)

   计算 \"y/x\" 的反正切值，由 \"x\" 和 \"y\" 的正负号来确定返回值的象限。

"),

("数学函数","Base","asind","asind(x)

   计算 \"x\" 的反正弦值，结果的单位为度数。

"),

("数学函数","Base","acosd","acosd(x)

   计算 \"x\" 的反余弦值，结果的单位为度数。

"),

("数学函数","Base","atand","atand(x)

   计算 \"x\" 的反正切值，结果的单位为度数。

"),

("数学函数","Base","sec","sec(x)

   计算 \"x\" 的正割值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","csc","csc(x)

   计算 \"x\" 的余割值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","cot","cot(x)

   计算 \"x\" 的余切值，其中 \"x\" 的单位为弧度。

"),

("数学函数","Base","secd","secd(x)

   计算 \"x\" 的正割值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","cscd","cscd(x)

   计算 \"x\" 的余割值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","cotd","cotd(x)

   计算 \"x\" 的余切值，其中 \"x\" 的单位为度数。

"),

("数学函数","Base","asec","asec(x)

   计算 \"x\" 的反正割值，结果的单位为弧度。

"),

("数学函数","Base","acsc","acsc(x)

   计算 \"x\" 的反余割值，结果的单位为弧度。

"),

("数学函数","Base","acot","acot(x)

   计算 \"x\" 的反余切值，结果的单位为弧度。

"),

("数学函数","Base","asecd","asecd(x)

   计算 \"x\" 的反正割值，结果的单位为度数。

"),

("数学函数","Base","acscd","acscd(x)

   计算 \"x\" 的反余割值，结果的单位为度数。

"),

("数学函数","Base","acotd","acotd(x)

   计算 \"x\" 的反余切值，结果的单位为度数。

"),

("数学函数","Base","sech","sech(x)

   计算 \"x\" 的双曲正割值。

"),

("数学函数","Base","csch","csch(x)

   计算 \"x\" 的双曲余割值。

"),

("数学函数","Base","coth","coth(x)

   计算 \"x\" 的双曲余切值。

"),

("数学函数","Base","asinh","asinh(x)

   计算 \"x\" 的反双曲正弦值。

"),

("数学函数","Base","acosh","acosh(x)

   计算 \"x\" 的反双曲余弦值。

"),

("数学函数","Base","atanh","atanh(x)

   计算 \"x\" 的反双曲正切值。

"),

("数学函数","Base","asech","asech(x)

   计算 \"x\" 的反双曲正割值。

"),

("数学函数","Base","acsch","acsch(x)

   计算 \"x\" 的反双曲余割值。

"),

("数学函数","Base","acoth","acoth(x)

   计算 \"x\" 的反双曲余切值。

"),

("数学函数","Base","sinc","sinc(x)

   计算 \\sin(\\pi x) / x 。

"),

("数学函数","Base","cosc","cosc(x)

   计算 \\cos(\\pi x) / x 。

"),

("数学函数","Base","degrees2radians","degrees2radians(x)

   将 \"x\" 度数转换为弧度。

"),

("数学函数","Base","radians2degrees","radians2degrees(x)

   将 \"x\" 弧度转换为度数。

"),

("数学函数","Base","hypot","hypot(x, y)

   计算 \\sqrt{x^2+y^2} ，计算过程不会出现上溢、下溢。

"),

("数学函数","Base","log","log(x)

   计算 \"x\" 的自然对数。

"),

("数学函数","Base","log2","log2(x)

   计算 \"x\" 以 2 为底的对数。

"),

("数学函数","Base","log10","log10(x)

   计算 \"x\" 以 10 为底的对数。

"),

("数学函数","Base","log1p","log1p(x)

   \"1+x\" 自然对数的精确值。

"),

("数学函数","Base","exponent","exponent(x)

   返回浮点数 \"trunc( log2( abs(x) ) )\" 。

"),

("数学函数","Base","ilogb","ilogb(x)

   \"logb()\" 的返回值为整数的版本。

"),

("数学函数","Base","frexp","frexp(val, exp)

   返回数 \"x\" ，满足 \"x\" 的取值范围为 \"[1/2, 1)\" 或 0 ，且 val = x \\times
   2^{exp} 。

"),

("数学函数","Base","exp","exp(x)

   计算 e^x 。

"),

("数学函数","Base","exp2","exp2(x)

   计算 2^x 。

"),

("数学函数","Base","ldexp","ldexp(x, n)

   计算 x \\times 2^n 。

"),

("数学函数","Base","modf","modf(x)

   返回一个数的小数部分和整数部分的多元组。两部分都与参数同正负号。

"),

("数学函数","Base","expm1","expm1(x)

   e^x-1 的精确值。

"),

("数学函数","Base","square","square(x)

   计算 x^2 。

"),

("数学函数","Base","round","round(x[, digits[, base]]) -> FloatingPoint

   \"round(x)\" 返回离 \"x\" 最近的整数。 \"round(x, digits)\" 若 digits
   为正数时舍入到小数点后对应位数，若为负数，舍入到小数点前对应位数，例子 \"round(pi,2) == 3.14\" 。
   \"round(x, digits, base)\" 使用指定的进制来舍入，默认进制为 10，例子 \"round(pi, 3, 2)
   == 3.125\" 。

"),

("数学函数","Base","ceil","ceil(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 +Inf 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

("数学函数","Base","floor","floor(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 -Inf 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

("数学函数","Base","trunc","trunc(x[, digits[, base]]) -> FloatingPoint

   将 \"x\" 向 0 取整。 \"digits\" 与 \"base\" 的解释参见 \"round()\" 。

"),

("数学函数","Base","iround","iround(x) -> Integer

   结果为整数类型的 \"round()\" 。

"),

("数学函数","Base","iceil","iceil(x) -> Integer

   结果为整数类型的 \"ceil()\" 。

"),

("数学函数","Base","ifloor","ifloor(x) -> Integer

   结果为整数类型的 \"floor()\" 。

"),

("数学函数","Base","itrunc","itrunc(x) -> Integer

   结果为整数类型的 \"trunc()\" 。

"),

("数学函数","Base","signif","signif(x, digits[, base]) -> FloatingPoint

   将 \"x\" 舍入（使用 \"round\" 函数）到指定的有效位数。 \"digits\" 与 \"base\" 的解释参见
   \"round()\" 。 例如 \"signif(123.456, 2) == 120.0\" ，
   \"signif(357.913, 4, 2) == 352.0\" 。

"),

("数学函数","Base","min","min(x, y)

   返回 \"x\" 和 \"y\" 的最小值。

"),

("数学函数","Base","max","max(x, y)

   返回 \"x\" 和 \"y\" 的最大值。

"),

("数学函数","Base","clamp","clamp(x, lo, hi)

   如果 \"lo <= x <= y\" 则返回 x 。如果 \"x < lo\" ，返回 \"lo\" 。如果 \"x > hi\"
   ，返回 \"hi\" 。

"),

("数学函数","Base","abs","abs(x)

   \"x\" 的绝对值。

"),

("数学函数","Base","abs2","abs2(x)

   \"x\" 绝对值的平方。

"),

("数学函数","Base","copysign","copysign(x, y)

   返回 \"x\" ，但其正负号与 \"y\" 相同。

"),

("数学函数","Base","sign","sign(x)

   如果 \"x\" 是正数时返回 \"+1\" ， \"x == 0\" 时返回 \"0\" ， \"x\" 是负数时返回 \"-1\"
   。

"),

("数学函数","Base","signbit","signbit(x)

   如果 \"x\" 是负数时返回 \"1\" ，否则返回 \"0\" 。

"),

("数学函数","Base","flipsign","flipsign(x, y)

   如果 \"y\" 为复数，返回 \"x\" 的相反数，否则返回 \"x\" 。如 \"abs(x) = flipsign(x,x)\"
   。

"),

("数学函数","Base","sqrt","sqrt(x)

   返回 \\sqrt{x} 。

"),

("数学函数","Base","cbrt","cbrt(x)

   返回 x^{1/3} 。

"),

("数学函数","Base","erf","erf(x)

   计算 \"x\" 的误差函数，其定义为 \\frac{2}{\\sqrt{\\pi}} \\int_0^x e^{-t^2} dt 。

"),

("数学函数","Base","erfc","erfc(x)

   计算 \"x\" 的互补误差函数，其定义为 1 - \\operatorname{erf}(x) =
   \\frac{2}{\\sqrt{\\pi}} \\int_x^{\\infty} e^{-t^2} dt 。

"),

("数学函数","Base","erfcx","erfcx(x)

   计算the scaled complementary error function of \"x\", defined by
   e^{x^2} \\operatorname{erfc}(x).  Note also that
   \\operatorname{erfcx}(-ix) computes the Faddeeva function w(x).

"),

("数学函数","Base","erfi","erfi(x)

   计算the imaginary error function of \"x\", defined by -i
   \\operatorname{erf}(ix).

"),

("数学函数","Base","dawson","dawson(x)

   计算the Dawson function (scaled imaginary error function) of \"x\",
   defined by \\frac{\\sqrt{\\pi}}{2} e^{-x^2}
   \\operatorname{erfi}(x).

"),

("数学函数","Base","real","real(z)

   返回复数 \"z\" 的实数部分。

"),

("数学函数","Base","imag","imag(z)

   返回复数 \"z\" 的虚数部分。

"),

("数学函数","Base","reim","reim(z)

   返回复数 \"z\" 的整数部分和虚数部分。

"),

("数学函数","Base","conj","conj(z)

   计算复数 \"z\" 的共轭。

"),

("数学函数","Base","angle","angle(z)

   计算复数 \"z\" 的相位角。

"),

("数学函数","Base","cis","cis(z)

   如果 \"z\" 是实数，返回 \"cos(z) + i*sin(z)\" 。如果 \"z\" 是实数，返回
   \"(cos(real(z)) + i*sin(real(z)))/exp(imag(z))\" 。

"),

("数学函数","Base","binomial","binomial(n, k)

   从  \"n\" 项中选取 \"k\" 项，有多少种方法。

"),

("数学函数","Base","factorial","factorial(n)

   n 的阶乘。

"),

("数学函数","Base","factorial","factorial(n, k)

   计算 \"factorial(n)/factorial(k)\"

"),

("数学函数","Base","factor","factor(n)

   对 \"n\" 分解质因数。返回a dictionary. The keys of the dictionary correspond
   to the factors, and hence are of the same type as \"n\". The value
   associated with each key indicates the number of times the factor
   appears in the factorization.

   **例子** ： 100=2*2*5*5 ，因此 \"factor(100) -> [5=>2,2=>2]\"

"),

("数学函数","Base","gcd","gcd(x, y)

   最大公因数。

"),

("数学函数","Base","lcm","lcm(x, y)

   最小公倍数。

"),

("数学函数","Base","gcdx","gcdx(x, y)

   Greatest common divisor, also returning integer coefficients \"u\"
   and \"v\" that solve \"ux+vy == gcd(x,y)\"

"),

("数学函数","Base","ispow2","ispow2(n)

   判断 \"n\" 是否为 2 的幂。

"),

("数学函数","Base","nextpow2","nextpow2(n)

   Next power of two not less than \"n\"

"),

("数学函数","Base","prevpow2","prevpow2(n)

   Previous power of two not greater than \"n\"

"),

("数学函数","Base","nextpow","nextpow(a, n)

   Next power of \"a\" not less than \"n\"

"),

("数学函数","Base","prevpow","prevpow(a, n)

   Previous power of \"a\" not greater than \"n\"

"),

("数学函数","Base","nextprod","nextprod([a, b, c], n)

   Next integer not less than \"n\" that can be written \"a^i1 * b^i2
   * c^i3\" for integers \"i1\", \"i2\", \"i3\".

"),

("数学函数","Base","prevprod","prevprod([a, b, c], n)

   Previous integer not greater than \"n\" that can be written \"a^i1
   * b^i2 * c^i3\" for integers \"i1\", \"i2\", \"i3\".

"),

("数学函数","Base","invmod","invmod(x, m)

   Inverse of \"x\", modulo \"m\"

"),

("数学函数","Base","powermod","powermod(x, p, m)

   计算 \"mod(x^p, m)\" 。

"),

("数学函数","Base","gamma","gamma(x)

   计算 \"x\" 的 gamma 函数。

"),

("数学函数","Base","lgamma","lgamma(x)

   计算the logarithm of \"gamma(x)\"

"),

("数学函数","Base","lfact","lfact(x)

   计算the logarithmic factorial of \"x\"

"),

("数学函数","Base","digamma","digamma(x)

   计算the digamma function of \"x\" (the logarithmic derivative of
   \"gamma(x)\")

"),

("数学函数","Base","airyai","airy(x)
airyai(x)

   艾里函数 \\operatorname{Ai}(x) 。

"),

("数学函数","Base","airyaiprime","airyprime(x)
airyaiprime(x)

   艾里函数的导数 \\operatorname{Ai}'(x) 。

"),

("数学函数","Base","airybi","airybi(x)

   艾里函数 \\operatorname{Bi}(x) 。

"),

("数学函数","Base","airybiprime","airybiprime(x)

   艾里函数的导数 \\operatorname{Bi}'(x) 。

"),

("数学函数","Base","besselj0","besselj0(x)

   \"0\" 阶的第一类贝塞尔函数， J_0(x) 。

"),

("数学函数","Base","besselj1","besselj1(x)

   \"1\" 阶的第一类贝塞尔函数， J_1(x) 。

"),

("数学函数","Base","besselj","besselj(nu, x)

   \"nu\" 阶的第一类贝塞尔函数， J_\\nu(x) 。

"),

("数学函数","Base","bessely0","bessely0(x)

   \"0\" 阶的第二类贝塞尔函数， Y_0(x) 。

"),

("数学函数","Base","bessely1","bessely1(x)

   \"1\" 阶的第二类贝塞尔函数， Y_1(x) 。

"),

("数学函数","Base","bessely","bessely(nu, x)

   \"nu\" 阶的第二类贝塞尔函数， Y_\\nu(x) 。

"),

("数学函数","Base","hankelh1","hankelh1(nu, x)

   \"nu\" 阶的第三类贝塞尔函数， H^{(1)}_\\nu(x) 。

"),

("数学函数","Base","hankelh2","hankelh2(nu, x)

   \"nu\" 阶的第三类贝塞尔函数， H^{(2)}_\\nu(x) 。

"),

("数学函数","Base","besseli","besseli(nu, x)

   \"nu\" 阶的变形第一类贝塞尔函数， I_\\nu(x) 。

"),

("数学函数","Base","besselk","besselk(nu, x)

   \"nu\" 阶的变形第二类贝塞尔函数， K_\\nu(x) 。

"),

("数学函数","Base","beta","beta(x, y)

   第一型欧拉积分 \\operatorname{B}(x,y) = \\Gamma(x)\\Gamma(y)/\\Gamma(x+y)
   。

"),

("数学函数","Base","lbeta","lbeta(x, y)

   贝塔函数的自然对数 \\log(\\operatorname{B}(x,y)) 。

"),

("数学函数","Base","eta","eta(x)

   狄利克雷 \\eta 函数 \\eta(s) = \\sum^\\infty_{n=1}(-)^{n-1}/n^{s} 。

"),

("数学函数","Base","zeta","zeta(x)

   黎曼 \\zeta 函数 :math:\"\\zeta(s)\" 。

"),

("数学函数","Base","bitmix","bitmix(x, y)

   Hash two integers into a single integer. Useful for constructing
   hash functions.

"),

("数学函数","Base","ndigits","ndigits(n, b)

   计算the number of digits in number \"n\" written in base \"b\".

"),

("数据格式","Base","bin","bin(n[, pad])

   将整数转换为二进制字符串，可选择性指明空白补位后的位数。

"),

("数据格式","Base","hex","hex(n[, pad])

   将整数转换为十六进制字符串，可选择性指明空白补位后的位数。

"),

("数据格式","Base","dec","dec(n[, pad])

   将整数转换为十进制字符串，可选择性指明空白补位后的位数。

"),

("数据格式","Base","oct","oct(n[, pad])

   将整数转换为八进制字符串，可选择性指明空白补位后的位数。

"),

("数据格式","Base","base","base(b, n[, pad])

   将整数 \"n\" 转换为指定进制 \"b\" 的字符串，可选择性指明空白补位后的位数。

"),

("数据格式","Base","bits","bits(n)

   A string giving the literal bit representation of a number.

"),

("数据格式","Base","parse_int","parse_int(type, str[, base])

   Parse a string as an integer in the given base (default 10),
   yielding a number of the specified type.

"),

("数据格式","Base","parse_bin","parse_bin(type, str)

   Parse a string as an integer in base 2, yielding a number of the
   specified type.

"),

("数据格式","Base","parse_oct","parse_oct(type, str)

   Parse a string as an integer in base 8, yielding a number of the
   specified type.

"),

("数据格式","Base","parse_hex","parse_hex(type, str)

   Parse a string as an integer in base 16, yielding a number of the
   specified type.

"),

("数据格式","Base","parse_float","parse_float(type, str)

   Parse a string as a decimal floating point number, yielding a
   number of the specified type.

"),

("数据格式","Base","bool","bool(x)

   将数或数值数组转换为布尔值类型的。

"),

("数据格式","Base","isbool","isbool(x)

   判断数或数组是否是布尔值类型的。

"),

("数据格式","Base","int","int(x)

   Convert a number or array to the default integer type on your
   platform. Alternatively, \"x\" can be a string, which is parsed as
   an integer.

"),

("数据格式","Base","uint","uint(x)

   Convert a number or array to the default unsigned integer type on
   your platform. Alternatively, \"x\" can be a string, which is
   parsed as an unsigned integer.

"),

("数据格式","Base","integer","integer(x)

   Convert a number or array to integer type. If \"x\" is already of
   integer type it is unchanged, otherwise it converts it to the
   default integer type on your platform.

"),

("数据格式","Base","isinteger","isinteger(x)

   判断数或数组是否为整数类型的。

"),

("数据格式","Base","signed","signed(x)

   将数转换为有符号整数。

"),

("数据格式","Base","unsigned","unsigned(x)

   将数转换为无符号整数。

"),

("数据格式","Base","int8","int8(x)

   将数或数组转换为 \"Int8\" 数据类型。

"),

("数据格式","Base","int16","int16(x)

   将数或数组转换为 \"Int16\" 数据类型。

"),

("数据格式","Base","int32","int32(x)

   将数或数组转换为 \"Int32\" 数据类型。

"),

("数据格式","Base","int64","int64(x)

   将数或数组转换为 \"Int64\" 数据类型。

"),

("数据格式","Base","int128","int128(x)

   将数或数组转换为 \"Int128\" 数据类型。

"),

("数据格式","Base","uint8","uint8(x)

   将数或数组转换为 \"Uint8\" 数据类型。

"),

("数据格式","Base","uint16","uint16(x)

   将数或数组转换为 \"Uint16\" 数据类型。

"),

("数据格式","Base","uint32","uint32(x)

   将数或数组转换为 \"Uint32\" 数据类型。

"),

("数据格式","Base","uint64","uint64(x)

   将数或数组转换为 \"Uint64\" 数据类型。

"),

("数据格式","Base","uint128","uint128(x)

   将数或数组转换为 \"Uint128\" 数据类型。

"),

("数据格式","Base","float32","float32(x)

   将数或数组转换为 \"Float32\" 数据类型。

"),

("数据格式","Base","float64","float64(x)

   将数或数组转换为 \"Float64\" 数据类型。

"),

("数据格式","Base","float","float(x)

   将数、数组、或字符串转换为 \"FloatingPoint\" 数据类型。对数值数据，使用最小的恰当
   \"FloatingPoint\" 类型。对字符串，它将被转换为 \"Float64\" 类型。

"),

("数据格式","Base","significand","significand(x)

   Extract the significand(s) (a.k.a. mantissa), in binary
   representation, of a floating-point number or array.

   例如， \"significand(15.2)/15.2 == 0.125\" 与``significand(15.2)*8 ==
   15.2`` 。

"),

("数据格式","Base","float64_valued","float64_valued(x::Rational)

   如果 \"x\" 能被无损地用 \"Float64\" 数据类型表示，返回真。

"),

("数据格式","Base","complex64","complex64(r, i)

   构造值为 \"r+i*im\" 的 \"Complex64\" 数据类型。

"),

("数据格式","Base","complex128","complex128(r, i)

   构造值为 \"r+i*im\" 的 \"Complex128\" 数据类型。

"),

("数据格式","Base","char","char(x)

   将数或数组转换为 \"Char\" 数据类型。

"),

("数据格式","Base","safe_char","safe_char(x)

   转换为 \"Char\" ，同时检查是否为有效码位。

"),

("数据格式","Base","complex","complex(r, i)

   将实数或数组转换为复数。

"),

("数据格式","Base","iscomplex","iscomplex(x) -> Bool

   判断数或数组是否为复数类型。

"),

("数据格式","Base","isreal","isreal(x) -> Bool

   判断数或数组是否为实数类型。

"),

("数据格式","Base","bswap","bswap(n)

   Byte-swap an integer

"),

("数据格式","Base","num2hex","num2hex(f)

   Get a hexadecimal string of the binary representation of a floating
   point number

"),

("数据格式","Base","hex2num","hex2num(str)

   Convert a hexadecimal string to the floating point number it
   represents

"),

("数","Base","one","one(x)

   获取与 x 同类型的乘法单位元（ x 也可为类型），即用该类型表示数值 1 。对于矩阵，返回与之大小、类型相匹配的的单位矩阵。

"),

("数","Base","zero","zero(x)

   获取与 x 同类型的加法单位元（ x 也可为类型），即用该类型表示数值 0 。对于矩阵，返回与之大小、类型相匹配的的全零矩阵。

"),

("数","Base","pi","pi

   常量 pi 。

"),

("数","Base","isdenormal","isdenormal(f) -> Bool

   判断浮点数是否为反常值。

"),

("数","Base","isfinite","isfinite(f) -> Bool

   判断数是否有限。

"),

("数","Base","isinf","isinf(f)

   判断数是否为无穷大或无穷小。

"),

("数","Base","isnan","isnan(f)

   判断浮点数是否为非数值（NaN）。

"),

("数","Base","inf","inf(f)

   返回与 \"f\" 相同浮点数类型的无穷大（ \"f\" 也可以为类型）。

"),

("数","Base","nan","nan(f)

   返回与 \"f\" 相同浮点数类型的 NaN （ \"f\" 也可以为类型）。

"),

("数","Base","nextfloat","nextfloat(f)

   获取下一个绝对值稍大的同正负号的浮点数。

"),

("数","Base","prevfloat","prevfloat(f) -> Float

   获取下一个绝对值稍小的同正负号的浮点数。

"),

("数","Base","integer_valued","integer_valued(x)

   判断 \"x\" 在数值上是否为整数。

"),

("数","Base","real_valued","real_valued(x)

   判断 \"x\" 在数值上是否为实数。

"),

("数","Base","BigInt","BigInt(x)

   构造任意精度的整数。 \"x\" 可以是 \"Int\" （或可以被转换为 \"Int\" 的）或 \"String\"
   。可以对其使用常用的数学运算符，结果被提升为 \"BigInt\" 类型。

"),

("数","Base","BigFloat","BigFloat(x)

   构造任意精度的浮点数。 \"x\" 可以是 \"Integer\", \"Float64\", \"String\" 或
   \"BigInt\" 。可以对其使用常用的数学运算符，结果被提升为 \"BigFloat\" 类型。

"),

("数","Base","count_ones","count_ones(x::Integer) -> Integer

   \"x\" 的二进制表示中有多少个 1 。

   **例子** ： \"count_ones(7) -> 3\"

"),

("数","Base","count_zeros","count_zeros(x::Integer) -> Integer

   \"x\" 的二进制表示中有多少个 0 。

   **例子** ： \"count_zeros(int32(2 ^ 16 - 1)) -> 16\"

"),

("数","Base","leading_zeros","leading_zeros(x::Integer) -> Integer

   \"x\" 的二进制表示中开头有多少个 0 。

   **例子** ： \"leading_zeros(int32(1)) -> 31\"

"),

("数","Base","leading_ones","leading_ones(x::Integer) -> Integer

   \"x\" 的二进制表示中开头有多少个 1 。

   **例子** ： \"leading_ones(int32(2 ^ 32 - 2)) -> 31\"

"),

("数","Base","trailing_zeros","trailing_zeros(x::Integer) -> Integer

   \"x\" 的二进制表示中末尾有多少个 0 。

   **例子** ： \"trailing_zeros(2) -> 1\"

"),

("数","Base","trailing_ones","trailing_ones(x::Integer) -> Integer

   \"x\" 的二进制表示中末尾有多少个 1 。

   **例子** ： \"trailing_ones(3) -> 2\"

"),

("数","Base","isprime","isprime(x::Integer) -> Bool

   如果 \"x\" 是质数，返回 \"true\" ；否则为 \"false\" 。

   **例子** ： \"isprime(3) -> true\"

"),

("数","Base","isodd","isodd(x::Integer) -> Bool

   如果 \"x\" 是奇数，返回 \"true\" ；否则为 \"false\" 。

   **例子** ： \"isodd(9) -> false\"

"),

("数","Base","iseven","iseven(x::Integer) -> Bool

   如果 \"x\" 是偶数，返回 \"true\" ；否则为 \"false\" 。

   **例子** ： \"iseven(1) -> false\"

"),

("随机数","Base","srand","srand([rng], seed)

   Seed the RNG with a \"seed\", which may be an unsigned integer or a
   vector of unsigned integers. \"seed\" can even be a filename, in
   which case the seed is read from a file. If the argument \"rng\" is
   not provided, the default global RNG is seeded.

"),

("随机数","Base","MersenneTwister","MersenneTwister([seed])

   构造一个 \"MersenneTwister\" RNG 对象。不同的 RNG
   对象可以有不同的种子，这对于生成不同的随机数流非常有用。

"),

("随机数","Base","rand","rand()

   生成 (0,1) 内的 \"Float64\" 随机数。

"),

("随机数","Base","rand!","rand!([rng], A)

   Populate the array A with random number generated from the
   specified RNG.

"),

("随机数","Base","rand","rand(rng::AbstractRNG[, dims...])

   使用指定的 RNG 对象，生成 \"Float64\" 类型的随机数或数组。目前仅提供 \"MersenneTwister\"
   随机数生成器 RNG ，可由 srand 设置随机数种子。

"),

("随机数","Base","rand","rand(dims...)

   生成指定维度的 \"Float64\" 类型的随机数组。

"),

("随机数","Base","rand","rand(Int32|Uint32|Int64|Uint64|Int128|Uint128[, dims...])

   生成指定整数类型的随机数。若指定维度，则生成对应类型的随机数组。

"),

("随机数","Base","rand","rand(r[, dims...])

   Generate a random integer from \"1\":\"n\" inclusive. Optionally,
   generate a random integer array.

"),

("随机数","Base","randbool","randbool([dims...])

   生成随机布尔值。若指定维度，则生成布尔值类型的随机数组。

"),

("随机数","Base","randbool!","randbool!(A)

   Fill an array with random boolean values. A may be an \"Array\" or
   a \"BitArray\".

"),

("随机数","Base","randn","randn([dims...])

   生成均值为 0 ，标准差为 1 的正态分布随机数。若指定维度，则生成正态分布的随机数组。

"),

("数组","Base","ndims","ndims(A) -> Integer

   返回 A 有几个维度。

"),

("数组","Base","size","size(A)

   返回 A 的维度多元组。

"),

("数组","Base","eltype","eltype(A)

   返回 A 中元素的类型。

"),

("数组","Base","length","length(A) -> Integer

   返回the number of elements in A (note that this differs from MATLAB
   where \"length(A)\" is the largest dimension of \"A\")

"),

("数组","Base","nnz","nnz(A)

   A 中非零元素的个数。

"),

("数组","Base","scale!","scale!(A, k)

   Scale the contents of an array A with k (in-place)

"),

("数组","Base","conj!","conj!(A)

   Convert an array to its complex conjugate in-place

"),

("数组","Base","stride","stride(A, k)

   返回the distance in memory (in number of elements) between adjacent
   elements in dimension k

"),

("数组","Base","strides","strides(A)

   返回a tuple of the memory strides in each dimension

"),

("数组","Base","Array","Array(type, dims)

   构造一个未初始化的稠密数组。 \"dims\" 可以是多元组或一组整数参数。

"),

("数组","Base","getindex","getindex(type)

   构造an empty 1-d array of the specified type. This is usually called
   with the syntax \"Type[]\". Element values can be specified using
   \"Type[a,b,c,...]\".

"),

("数组","Base","cell","cell(dims)

   构造an uninitialized cell array (heterogeneous array). \"dims\" can
   be either a tuple or a series of integer arguments.

"),

("数组","Base","zeros","zeros(type, dims)

   构造指定类型的全零数组。

"),

("数组","Base","ones","ones(type, dims)

   构造指定类型的全一数组。

"),

("数组","Base","trues","trues(dims)

   构造元素全为真的布尔值数组。

"),

("数组","Base","falses","falses(dims)

   构造元素全为假的布尔值数组。

"),

("数组","Base","fill","fill(v, dims)

   构造数组，元素都初始化为 \"v\" 。

"),

("数组","Base","fill!","fill!(A, x)

   将数组 \"A\" 的元素都改为 \"x\" 。

"),

("数组","Base","reshape","reshape(A, dims)

   构造an array with the same data as the given array, but with
   different dimensions. An implementation for a particular type of
   array may choose whether the data is copied or shared.

"),

("数组","Base","copy","copy(A)

   构造 \"A\" 的浅拷贝。

"),

("数组","Base","similar","similar(array, element_type, dims)

   构造an uninitialized array of the same type as the given array, but
   with the specified element type and dimensions. The second and
   third arguments are both optional. The \"dims\" argument may be a
   tuple or a series of integer arguments.

"),

("数组","Base","reinterpret","reinterpret(type, A)

   构造an array with the same binary data as the given array, but with
   the specified element type

"),

("数组","Base","rand","rand(dims)

   构造a random array with Float64 random values in (0,1)

"),

("数组","Base","randf","randf(dims)

   构造a random array with Float32 random values in (0,1)

"),

("数组","Base","randn","randn(dims)

   构造a random array with Float64 normally-distributed random values
   with a mean of 0 and standard deviation of 1

"),

("数组","Base","eye","eye(n)

   n x n 单位矩阵。

"),

("数组","Base","eye","eye(m, n)

   m x n 单位矩阵。

"),

("数组","Base","linspace","linspace(start, stop, n)

   构造a vector of \"n\" linearly-spaced elements from \"start\" to
   \"stop\".

"),

("数组","Base","logspace","logspace(start, stop, n)

   构造a vector of \"n\" logarithmically-spaced numbers from
   \"10^start\" to \"10^stop\".

"),

("数组","Base","bsxfun","bsxfun(fn, A, B[, C...])

   对两个或两个以上的数组使用二元函数 \"fn\" ，它会展开单态的维度。

"),

("数组","Base","getindex","getindex(A, ind)

   返回a subset of \"A\" as specified by \"ind\", 结果可能是 \"Int\",
   \"Range\", 或 \"Vector\" 。

"),

("数组","Base","sub","sub(A, ind)

   返回a SubArray, which stores the input \"A\" and \"ind\" rather than
   computing the result immediately. Calling \"getindex\" on a
   SubArray computes the indices on the fly.

"),

("数组","Base","slicedim","slicedim(A, d, i)

   返回all the data of \"A\" where the index for dimension \"d\" equals
   \"i\". Equivalent to \"A[:,:,...,i,:,:,...]\" where \"i\" is in
   position \"d\".

"),

("数组","Base","setindex!","setindex!(A, X, ind)

   Store an input array \"X\" within some subset of \"A\" as specified
   by \"ind\".

"),

("数组","Base","cat","cat(dim, A...)

   Concatenate the input arrays along the specified dimension

"),

("数组","Base","vcat","vcat(A...)

   在维度 1 上连接。

"),

("数组","Base","hcat","hcat(A...)

   在维度 2 上连接。

"),

("数组","Base","hvcat","hvcat()

   Horizontal and vertical concatenation in one call

"),

("数组","Base","flipdim","flipdim(A, d)

   Reverse \"A\" in dimension \"d\".

"),

("数组","Base","flipud","flipud(A)

   等价于 \"flipdim(A,1)\" 。

"),

("数组","Base","fliplr","fliplr(A)

   等价于 \"flipdim(A,2)\" 。

"),

("数组","Base","circshift","circshift(A, shifts)

   Circularly shift the data in an array. The second argument is a
   vector giving the amount to shift in each dimension.

"),

("数组","Base","find","find(A)

   返回a vector of the linear indexes of the non-zeros in \"A\".

"),

("数组","Base","findn","findn(A)

   返回a vector of indexes for each dimension giving the locations of
   the non-zeros in \"A\".

"),

("数组","Base","nonzeros","nonzeros(A)

   Return a vector of the non-zero values in array \"A\".

"),

("数组","Base","findfirst","findfirst(A)

   Return the index of the first non-zero value in \"A\".

"),

("数组","Base","findfirst","findfirst(A, v)

   Return the index of the first element equal to \"v\" in \"A\".

"),

("数组","Base","findfirst","findfirst(predicate, A)

   Return the index of the first element that satisfies the given
   predicate in \"A\".

"),

("数组","Base","permutedims","permutedims(A, perm)

   Permute the dimensions of array \"A\". \"perm\" is a vector
   specifying a permutation of length \"ndims(A)\". This is a
   generalization of transpose for multi-dimensional arrays. Transpose
   is equivalent to \"permute(A,[2,1])\".

"),

("数组","Base","ipermutedims","ipermutedims(A, perm)

   Like \"permutedims()\", except the inverse of the given permutation
   is applied.

"),

("数组","Base","squeeze","squeeze(A, dims)

   移除the dimensions specified by \"dims\" from array \"A\"

"),

("数组","Base","vec","vec(Array) -> Vector

   Vectorize an array using column-major convention.

"),

("数组","Base","cumprod","cumprod(A[, dim])

   Cumulative product along a dimension.

"),

("数组","Base","cumsum","cumsum(A[, dim])

   Cumulative sum along a dimension.

"),

("数组","Base","cumsum_kbn","cumsum_kbn(A[, dim])

   Cumulative sum along a dimension, using the Kahan-Babuska-Neumaier
   compensated summation algorithm for additional accuracy.

"),

("数组","Base","cummin","cummin(A[, dim])

   Cumulative minimum along a dimension.

"),

("数组","Base","cummax","cummax(A[, dim])

   Cumulative maximum along a dimension.

"),

("数组","Base","diff","diff(A[, dim])

   Finite difference operator of matrix or vector.

"),

("数组","Base","rot180","rot180(A)

   Rotate matrix \"A\" 180 degrees.

"),

("数组","Base","rotl90","rotl90(A)

   Rotate matrix \"A\" left 90 degrees.

"),

("数组","Base","rotr90","rotr90(A)

   Rotate matrix \"A\" right 90 degrees.

"),

("数组","Base","reducedim","reducedim(f, A, dims, initial)

   Reduce 2-argument function \"f\" along dimensions of \"A\".
   \"dims\" is a vector specifying the dimensions to reduce, and
   \"initial\" is the initial value to use in the reductions.

"),

("数组","Base","sum_kbn","sum_kbn(A)

   Returns the sum of all array elements, using the Kahan-Babuska-
   Neumaier compensated summation algorithm for additional accuracy.

"),

("稀疏矩阵","Base","sparse","sparse(I, J, V[, m, n, combine])

   构造a sparse matrix \"S\" of dimensions \"m x n\" such that \"S[I[k],
   J[k]] = V[k]\". The \"combine\" function is used to combine
   duplicates. If \"m\" and \"n\" are not specified, they are set to
   \"max(I)\" and \"max(J)\" respectively. If the \"combine\" function
   is not supplied, duplicates are added by default.

"),

("稀疏矩阵","Base","sparsevec","sparsevec(I, V[, m, combine])

   构造a sparse matrix \"S\" of size \"m x 1\" such that \"S[I[k]] =
   V[k]\". Duplicates are combined using the \"combine\" function,
   which defaults to *+* if it is not provided. In julia, sparse
   vectors are really just sparse matrices with one column. Given
   Julia's Compressed Sparse Columns (CSC) storage format, a sparse
   column matrix with one column is sparse, whereas a sparse row
   matrix with one row ends up being dense.

"),

("稀疏矩阵","Base","sparsevec","sparsevec(D::Dict[, m])

   构造a sparse matrix of size \"m x 1\" where the row values are keys
   from the dictionary, and the nonzero values are the values from the
   dictionary.

"),

("稀疏矩阵","Base","issparse","issparse(S)

   如果 \"S\" 为稀疏矩阵，返回 \"true\" ；否则为 \"false\" 。

"),

("稀疏矩阵","Base","nnz","nnz(S)

   返回 \"S\" 中非零元素的个数。

"),

("稀疏矩阵","Base","sparse","sparse(A)

   将稠密矩阵 \"A\" 转换为稀疏矩阵。

"),

("稀疏矩阵","Base","sparsevec","sparsevec(A)

   将稠密矩阵 \"A\" 转换为 \"m x 1\" 的稀疏矩阵。在 Julia 中，稀疏向量是只有一列的稀疏矩阵。

"),

("稀疏矩阵","Base","dense","dense(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

("稀疏矩阵","Base","full","full(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

("稀疏矩阵","Base","spzeros","spzeros(m, n)

   构造 \"m x n\" 的空稀疏矩阵。

"),

("稀疏矩阵","Base","speye","speye(type, m[, n])

   构造a sparse identity matrix of specified type of size \"m x m\". In
   case \"n\" is supplied, create a sparse identity matrix of size \"m
   x n\".

"),

("稀疏矩阵","Base","spones","spones(S)

   构造a sparse matrix with the same structure as that of \"S\", but
   with every nonzero element having the value \"1.0\".

"),

("稀疏矩阵","Base","sprand","sprand(m, n, density[, rng])

   构造a random sparse matrix with the specified density. Nonzeros are
   sampled from the distribution specified by \"rng\". The uniform
   distribution is used in case \"rng\" is not specified.

"),

("稀疏矩阵","Base","sprandn","sprandn(m, n, density)

   构造a random sparse matrix of specified density with nonzeros sampled
   from the normal distribution.

"),

("稀疏矩阵","Base","sprandbool","sprandbool(m, n, density)

   构造a random sparse boolean matrix with the specified density.

"),

("线性代数","Base","*","*(A, B)

   矩阵乘法。

"),

("线性代数","Base","\\","\\(A, B)

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

("线性代数","Base","dot","dot(x, y)

   计算点积。

"),

("线性代数","Base","cross","cross(x, y)

   计算the cross product of two 3-vectors

"),

("线性代数","Base","norm","norm(a)

   计算 \"Vector\" 或 \"Matrix\" 的模。

"),

("线性代数","Base","factors","factors(F)

   返回the factors of a factorization \"F\". For example, in the case of
   an LU decomposition, factors(LU) -> L, U, P

"),

("线性代数","Base","lu","lu(A) -> L, U, P

   计算 \"A\" 的 LU 分解，满足 \"A[P,:] = L*U\" 。

"),

("线性代数","Base","lufact","lufact(A) -> LUDense

   计算the LU factorization of \"A\" and return a \"LUDense\" object.
   \"factors(lufact(A))\" returns the triangular matrices containing
   the factorization. The following functions are available for
   \"LUDense\" objects: \"size\", \"factors\", \"\\\", \"inv\",
   \"det\".

"),

("线性代数","Base","lufact!","lufact!(A) -> LUDense

   \"lufact!\" 与 \"lufact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

("线性代数","Base","chol","chol(A[, LU]) -> F

   计算Cholesky factorization of a symmetric positive-definite matrix
   \"A\" and return the matrix \"F\". If \"LU\" is \"L\" (Lower), \"A
   = L*L'\". If \"LU\" is \"U\" (Upper), \"A = R'*R\".

"),

("线性代数","Base","cholfact","cholfact(A[, LU]) -> CholeskyDense

   计算the Cholesky factorization of a symmetric positive-definite
   matrix \"A\" and return a \"CholeskyDense\" object. \"LU\" may be
   'L' for using the lower part or 'U' for the upper part. The default
   is to use 'U'. \"factors(cholfact(A))\" returns the triangular
   matrix containing the factorization. The following functions are
   available for \"CholeskyDense\" objects: \"size\", \"factors\",
   \"\\\", \"inv\", \"det\". A \"LAPACK.PosDefException\" error is
   thrown in case the matrix is not positive definite.

"),

("线性代数","Base","cholpfact","cholpfact(A[, LU]) -> CholeskyPivotedDense

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

("线性代数","Base","cholpfact!","cholpfact!(A[, LU]) -> CholeskyPivotedDense

   \"cholpfact!\" 与 \"cholpfact\" 相同，but saves space by overwriting
   the input A, instead of creating a copy.

"),

("线性代数","Base","qr","qr(A) -> Q, R

   计算 \"A\" 的 QR 分解，满足 \"A = Q*R\" 。也可参见 \"qrd\" 。

"),

("线性代数","Base","qrfact","qrfact(A)

   计算the QR factorization of \"A\" and return a \"QRDense\" object.
   \"factors(qrfact(A))\" returns \"Q\" and \"R\". The following
   functions are available for \"QRDense\" objects: \"size\",
   \"factors\", \"qmulQR\", \"qTmulQR\", \"\\\".

"),

("线性代数","Base","qrfact!","qrfact!(A)

   \"qrfact!\" 与 \"qrfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

("线性代数","Base","qrp","qrp(A) -> Q, R, P

   计算the QR factorization of \"A\" with pivoting, such that \"A*I[:,P]
   = Q*R\", where \"I\" is the identity matrix. Also see \"qrpfact\".

"),

("线性代数","Base","qrpfact","qrpfact(A) -> QRPivotedDense

   计算the QR factorization of \"A\" with pivoting and return a
   \"QRDensePivoted\" object. \"factors(qrpfact(A))\" returns \"Q\"
   and \"R\". The following functions are available for
   \"QRDensePivoted\" objects: \"size\", \"factors\", \"qmulQR\",
   \"qTmulQR\", \"\\\".

"),

("线性代数","Base","qrpfact!","qrpfact!(A) -> QRPivotedDense

   \"qrpfact!\" 与 \"qrpfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy.

"),

("线性代数","Base","qmulQR","qmulQR(QR, A)

   Perform Q*A efficiently, where Q is a an orthogonal matrix defined
   as the product of k elementary reflectors from the QR
   decomposition.

"),

("线性代数","Base","qTmulQR","qTmulQR(QR, A)

   Perform \"Q'*A\" efficiently, where Q is a an orthogonal matrix
   defined as the product of k elementary reflectors from the QR
   decomposition.

"),

("线性代数","Base","sqrtm","sqrtm(A)

   计算 \"A\" 的矩阵平方根。如果 \"B = sqrtm(A)\" ，则在误差范围内 \"B*B == A\" 。

"),

("线性代数","Base","eig","eig(A) -> D, V

   计算 \"A\" 的特征值和特征向量。

"),

("线性代数","Base","eigvals","eigvals(A)

   返回  \"A\" 的特征值。

"),

("线性代数","Base","svdfact","svdfact(A[, thin]) -> SVDDense

   计算the Singular Value Decomposition (SVD) of \"A\" and return an
   \"SVDDense\" object. \"factors(svdfact(A))\" returns \"U\", \"S\",
   and \"Vt\", such that \"A = U*diagm(S)*Vt\". If \"thin\" is
   \"true\", an economy mode decomposition is returned.

"),

("线性代数","Base","svdfact!","svdfact!(A[, thin]) -> SVDDense

   \"svdfact!\" 与 \"svdfact\" 相同，but saves space by overwriting the
   input A, instead of creating a copy. If \"thin\" is \"true\", an
   economy mode decomposition is returned.

"),

("线性代数","Base","svd","svd(A[, thin]) -> U, S, V

   对 A 做奇异值分解，返回 \"U\" ，向量 \"S\" ，及 \"V\" ，满足 \"A == U*diagm(S)*V'\"
   。如果 \"thin\" 为 \"true\" ，则做节约模式分解。

"),

("线性代数","Base","svdt","svdt(A[, thin]) -> U, S, Vt

   对 A 做奇异值分解，返回 \"U\" ，向量 \"S\" ，及 \"Vt\" ，满足 \"A = U*diagm(S)*Vt\"
   。如果 \"thin\" 为 \"true\" ，则做节约模式分解。

"),

("线性代数","Base","svdvals","svdvals(A)

   返回 \"A\" 的奇异值。

"),

("线性代数","Base","svdvals!","svdvals!(A)

   返回 \"A\" 的奇异值，将结果覆写到输入上以节约空间。

"),

("线性代数","Base","svdfact","svdfact(A, B) -> GSVDDense

   计算the generalized SVD of \"A\" and \"B\", returning a \"GSVDDense\"
   Factorization object. \"factors(svdfact(A,b))\" returns \"U\",
   \"V\", \"Q\", \"D1\", \"D2\", and \"R0\" such that \"A =
   U*D1*R0*Q'\" and \"B = V*D2*R0*Q'\".

"),

("线性代数","Base","svd","svd(A, B) -> U, V, Q, D1, D2, R0

   计算the generalized SVD of \"A\" and \"B\", returning \"U\", \"V\",
   \"Q\", \"D1\", \"D2\", and \"R0\" such that \"A = U*D1*R0*Q'\" and
   \"B = V*D2*R0*Q'\".

"),

("线性代数","Base","svdvals","svdvals(A, B)

   返回only the singular values from the generalized singular value
   decomposition of \"A\" and \"B\".

"),

("线性代数","Base","triu","triu(M)

   矩阵上三角。

"),

("线性代数","Base","tril","tril(M)

   矩阵下三角。

"),

("线性代数","Base","diag","diag(M[, k])

   矩阵的第 \"k\" 条对角线，结果为向量。 \"k\" 从 0 开始。

"),

("线性代数","Base","diagm","diagm(v[, k])

   构造 \"v\" 为第 \"k\" 条对角线的对角矩阵。 \"k\" 从 0 开始。

"),

("线性代数","Base","diagmm","diagmm(matrix, vector)

   Multiply matrices, interpreting the vector argument as a diagonal
   matrix. The arguments may occur in the other order to multiply with
   the diagonal matrix on the left.

"),

("线性代数","Base","Tridiagonal","Tridiagonal(dl, d, du)

   构造a tridiagonal matrix from the lower diagonal, diagonal, and upper
   diagonal

"),

("线性代数","Base","Woodbury","Woodbury(A, U, C, V)

   构造a matrix in a form suitable for applying the Woodbury matrix
   identity

"),

("线性代数","Base","rank","rank(M)

   计算矩阵的秩。

"),

("线性代数","Base","norm","norm(A[, p])

   计算the \"p\"-norm of a vector or a matrix. \"p\" is \"2\" by
   default, if not provided. If \"A\" is a vector, \"norm(A, p)\"
   computes the \"p\"-norm. \"norm(A, Inf)\" returns the largest value
   in \"abs(A)\", whereas \"norm(A, -Inf)\" returns the smallest. If
   \"A\" is a matrix, valid values for \"p\" are \"1\", \"2\", or
   \"Inf\". In order to compute the Frobenius norm, use \"normfro\".

"),

("线性代数","Base","normfro","normfro(A)

   计算the Frobenius norm of a matrix \"A\".

"),

("线性代数","Base","cond","cond(M[, p])

   Matrix condition number, computed using the p-norm. \"p\" 如果省略，默认为
   2 。 \"p\" 的有效值为 \"1\", \"2\", 和 \"Inf\".

"),

("线性代数","Base","trace","trace(M)

   矩阵的迹。

"),

("线性代数","Base","det","det(M)

   矩阵的行列式。

"),

("线性代数","Base","inv","inv(M)

   矩阵的逆。

"),

("线性代数","Base","pinv","pinv(M)

   矩阵的 Moore-Penrose （广义）逆

"),

("线性代数","Base","null","null(M)

   Basis for null space of M.

"),

("线性代数","Base","repmat","repmat(A, n, m)

   构造a matrix by repeating the given matrix \"n\" times in dimension 1
   and \"m\" times in dimension 2.

"),

("线性代数","Base","kron","kron(A, B)

   两个向量或两个矩阵的 Kronecker 张量积。

"),

("线性代数","Base","linreg","linreg(x, y)

   Determine parameters \"[a, b]\" that minimize the squared error
   between \"y\" and \"a+b*x\".

"),

("线性代数","Base","linreg","linreg(x, y, w)

   带权最小二乘法线性回归。

"),

("线性代数","Base","expm","expm(A)

   Matrix exponential.

"),

("线性代数","Base","issym","issym(A)

   判断是否为对称矩阵。

"),

("线性代数","Base","isposdef","isposdef(A)

   判断是否为正定矩阵。

"),

("线性代数","Base","istril","istril(A)

   判断是否为下三角矩阵。

"),

("线性代数","Base","istriu","istriu(A)

   判断是否为上三角矩阵。

"),

("线性代数","Base","ishermitian","ishermitian(A)

   判断是否为 Hamilton 矩阵。

"),

("线性代数","Base","transpose","transpose(A)

   转置运算符（ \".'\" ）。

"),

("线性代数","Base","ctranspose","ctranspose(A)

   共轭转置运算符（ \"'\" ）。

"),

("排列组合","Base","nthperm","nthperm(v, k)

   计算the kth lexicographic permutation of a vector.

"),

("排列组合","Base","nthperm!","nthperm!(v, k)

   \"nthperm()\" 的原地版本。

"),

("排列组合","Base","randperm","randperm(n)

   构造a random permutation of the given length.

"),

("排列组合","Base","invperm","invperm(v)

   返回the inverse permutation of v.

"),

("排列组合","Base","isperm","isperm(v) -> Bool

   返回true if v is a valid permutation.

"),

("排列组合","Base","permute!","permute!(v, p)

   Permute vector \"v\" in-place, according to permutation \"p\".  No
   checking is done to verify that \"p\" is a permutation.

   To return a new permutation, use \"v[p]\".  Note that this is
   generally faster than \"permute!(v,p)\" for large vectors.

"),

("排列组合","Base","ipermute!","ipermute!(v, p)

   Like permute!, but the inverse of the given permutation is applied.

"),

("排列组合","Base","randcycle","randcycle(n)

   构造a random cyclic permutation of the given length.

"),

("排列组合","Base","shuffle","shuffle(v)

   随机重新排列向量中的元素。

"),

("排列组合","Base","shuffle!","shuffle!(v)

   \"shuffle()\" 的原地版本。

"),

("排列组合","Base","reverse","reverse(v)

   逆序排列向量 \"v\" 。

"),

("排列组合","Base","reverse!","reverse!(v) -> v

   \"reverse()\" 的原地版本。

"),

("排列组合","Base","combinations","combinations(array, n)

   Generate all combinations of \"n\" elements from a given array.
   Because the number of combinations can be very large, this function
   runs inside a Task to produce values on demand. Write \"c = @task
   combinations(a,n)\", then iterate \"c\" or call \"consume\" on it.

"),

("排列组合","Base","integer_partitions","integer_partitions(n, m)

   Generate all arrays of \"m\" integers that sum to \"n\". Because
   the number of partitions can be very large, this function runs
   inside a Task to produce values on demand. Write \"c = @task
   integer_partitions(n,m)\", then iterate \"c\" or call \"consume\"
   on it.

"),

("排列组合","Base","partitions","partitions(array)

   Generate all set partitions of the elements of an array,
   represented as arrays of arrays. Because the number of partitions
   can be very large, this function runs inside a Task to produce
   values on demand. Write \"c = @task partitions(a)\", then iterate
   \"c\" or call \"consume\" on it.

"),

("统计","Base","mean","mean(v[, dim])

   计算整个数组 \"v\" 的均值，或按某一维 \"dim\" 计算（可选）。

"),

("统计","Base","std","std(v[, corrected])

   计算向量 \"v\" 的样本标准差。如果未设定可选参数 \"corrected\" 或显式设定为默认值 \"true\" ，则算法将在
   \"v\" 中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布标准差的估计。计算结果等价于
   \"sqrt(sum((v .- mean(v)).^2) / (length(v) - 1))\"
   并且引入了一个有时被称为贝赛尔修正的隐含修正项，这样就能保证方差的估计是无偏的。反之，如果可选参数 \"corrected\"
   被设定为 \"false\" ，则算法将给出等价于 \"sqrt(sum((v .- mean(v)).^2) /
   length(v))\" 的结果，即样本的经验标准差。

"),

("统计","Base","std","std(v, m[, corrected])

   计算已知均值为 \"m\" 的向量 \"v\" 的样本标准差。如果未设定可选参数 \"corrected\" 或显式设定为默认值
   \"true\" ，则算法将在 \"v\"
   中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布标准差的估计。计算结果等价于 \"sqrt(sum((v
   .- m).^2) / (length(v) - 1))\"
   并且引入了一个有时被称为贝赛尔修正的隐含修正项，这样就能保证方差的估计是无偏的。反之，如果可选参数 \"corrected\"
   被设定为 \"false\" ，则算法将给出等价于 \"sqrt(sum((v .- m).^2) / length(v))\"
   的结果，即样本的经验标准差。

"),

("统计","Base","var","var(v[, corrected])

   计算向量 \"v\" 的样本方差。如果未设定可选参数 \"corrected\" 或显式设定为默认值 \"true\" ，则算法将在
   \"v\" 中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布方差的估计。计算结果等价于 \"sum((v
   .- mean(v)).^2) / (length(v) - 1)\"
   并且引入了一个有时被称为贝赛尔修正的隐含修正项，这样就能保证方差的估计是无偏的。反之，如果可选参数 \"corrected\"
   被设定为 \"false\" ，则算法将给出等价于 \"sum((v .- mean(v)).^2) / length(v)\"
   的结果，即样本的经验方差。

"),

("统计","Base","var","var(v, m[, corrected])

   计算已知均值为 \"m\" 的向量 \"v\" 的样本方差。如果未设定可选参数 \"corrected\" 或显式设定为默认值
   \"true\" ，则算法将在 \"v\"
   中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布方差的估计。计算结果等价于 \"sum((v .-
   m)).^2) / (length(v) - 1)\"
   并且引入了一个有时被称为贝赛尔修正的隐含修正项，这样就能保证方差的估计是无偏的。反之，如果可选参数 \"corrected\"
   被设定为 \"false\" ，则算法将给出等价于 \"sum((v .- m)).^2) / length(v)\"
   的结果，即样本的经验方差。

"),

("统计","Base","median","median(v)

   计算向量 \"v\" 的中位数。

"),

("统计","Base","hist","hist(v[, n])

   计算 \"v\" 的直方图，可以指定划分为 \"n\" 个区间。

"),

("统计","Base","hist","hist(v, e)

   计算 \"v\" 的直方图，使用向量 \"e\" 指定区间的边界。

"),

("统计","Base","quantile","quantile(v, p)

   计算向量 \"v\" 在指定概率值集合 \"p\" 处的分位数。

"),

("统计","Base","quantile","quantile(v)

   计算向量 \"v\" 在概率值 \"[.0, .2, .4, .6, .8, 1.0]\" 处的分位数。

"),

("统计","Base","cov","cov(v)

   计算两个向量 \"v1\" 和 \"v2\" 的协方差。

"),

("统计","Base","cor","cor(v)

   计算两个向量 \"v1\" 和 \"v2\" 的 Pearson 相关系数。

"),

("信号处理","Base","fft","fft(A[, dims])

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

("信号处理","Base","fft!","fft!(A[, dims])

   与 \"fft()\" 相同，but operates in-place on \"A\", which must be an
   array of complex floating-point numbers.

"),

("信号处理","","ifft(A [, dims]), bfft, bfft!","ifft(A [, dims]), bfft, bfft!

   Multidimensional inverse FFT.

   A one-dimensional backward FFT computes \\operatorname{BDFT}[k] =
   \\sum_{n=1}^{\\operatorname{length}(A)} \\exp\\left(+i\\frac{2\\pi
   (n-1)(k-1)}{\\operatorname{length}(A)} \\right) A[n].  A
   multidimensional backward FFT simply performs this operation along
   each transformed dimension of \"A\".  The inverse FFT computes the
   same thing divided by the product of the transformed dimensions.

"),

("信号处理","Base","ifft!","ifft!(A[, dims])

   与 \"ifft()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","bfft","bfft(A[, dims])

   类似 \"ifft()\", but computes an unnormalized inverse (backward)
   transform, which must be divided by the product of the sizes of the
   transformed dimensions in order to obtain the inverse.  (This is
   slightly more efficient than \"ifft()\" because it omits a scaling
   step, which in some applications can be combined with other
   computational steps elsewhere.)

"),

("信号处理","Base","bfft!","bfft!(A[, dims])

   与 \"bfft()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","","plan_fft(A [, dims [, flags [, timelimit]]]),  plan_ifft, plan_bfft","plan_fft(A [, dims [, flags [, timelimit]]]),  plan_ifft, plan_bfft

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

("信号处理","Base","plan_fft!","plan_fft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_ifft!","plan_ifft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_ifft()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_bfft!","plan_bfft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_bfft()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","rfft","rfft(A[, dims])

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

("信号处理","Base","irfft","irfft(A, d[, dims])

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

("信号处理","Base","brfft","brfft(A, d[, dims])

   类似 \"irfft()\" but computes an unnormalized inverse transform
   (similar to \"bfft()\"), which must be divided by the product of
   the sizes of the transformed dimensions (of the real output array)
   in order to obtain the inverse transform.

"),

("信号处理","Base","plan_rfft","plan_rfft(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized real-input FFT, similar to \"plan_fft()\"
   except for \"rfft()\" instead of \"fft()\".  The first two
   arguments, and the size of the transformed result, are the same as
   for \"rfft()\".

"),

("信号处理","","plan_irfft(A, d [, dims [, flags [, timelimit]]]), plan_bfft","plan_irfft(A, d [, dims [, flags [, timelimit]]]), plan_bfft

   Pre-plan an optimized inverse real-input FFT, similar to
   \"plan_rfft()\" except for \"irfft()\" and \"brfft()\",
   respectively.  The first three arguments have the same meaning as
   for \"irfft()\".

"),

("信号处理","Base","dct","dct(A[, dims])

   Performs a multidimensional type-II discrete cosine transform (DCT)
   of the array \"A\", using the unitary normalization of the DCT. The
   optional \"dims\" argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along.  Most efficient if the size of \"A\" along the transformed
   dimensions is a product of small primes; see \"nextprod()\".  See
   also \"plan_dct()\" for even greater efficiency.

"),

("信号处理","Base","dct!","dct!(A[, dims])

   与 \"dct!()\" 相同，except that it operates in-place on \"A\", which
   must be an array of real or complex floating-point values.

"),

("信号处理","Base","idct","idct(A[, dims])

   Computes the multidimensional inverse discrete cosine transform
   (DCT) of the array \"A\" (technically, a type-III DCT with the
   unitary normalization). The optional \"dims\" argument specifies an
   iterable subset of dimensions (e.g. an integer, range, tuple, or
   array) to transform along.  Most efficient if the size of \"A\"
   along the transformed dimensions is a product of small primes; see
   \"nextprod()\".  See also \"plan_idct()\" for even greater
   efficiency.

"),

("信号处理","Base","idct!","idct!(A[, dims])

   与 \"idct!()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_dct","plan_dct(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized discrete cosine transform (DCT), similar to
   \"plan_fft()\" except producing a function that computes \"dct()\".
   The first two arguments have the same meaning as for \"dct()\".

"),

("信号处理","Base","plan_dct!","plan_dct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_dct()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_idct","plan_idct(A[, dims[, flags[, timelimit]]])

   Pre-plan an optimized inverse discrete cosine transform (DCT),
   similar to \"plan_fft()\" except producing a function that computes
   \"idct()\". The first two arguments have the same meaning as for
   \"idct()\".

"),

("信号处理","Base","plan_idct!","plan_idct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_idct()\" 相同，但在原地对 \"A\" 进行运算。

"),

("信号处理","","FFTW.r2r(A, kind [, dims]), FFTW.r2r!","FFTW.r2r(A, kind [, dims]), FFTW.r2r!

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

("信号处理","","FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]]), FFTW.plan_r2r!","FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]]), FFTW.plan_r2r!

   Pre-plan an optimized r2r transform, similar to \"plan_fft()\"
   except that the transforms (and the first three arguments)
   correspond to \"FFTW.r2r()\" and \"FFTW.r2r!()\", respectively.

"),

("信号处理","Base","fftshift","fftshift(x)

   Swap the first and second halves of each dimension of \"x\".

"),

("信号处理","Base","fftshift","fftshift(x, dim)

   Swap the first and second halves of the given dimension of array
   \"x\".

"),

("信号处理","Base","ifftshift","ifftshift(x[, dim])

   Undoes the effect of \"fftshift\".

"),

("信号处理","Base","filt","filt(b, a, x)

   Apply filter described by vectors \"a\" and \"b\" to vector \"x\".

"),

("信号处理","Base","deconv","deconv(b, a)

   构造vector \"c\" such that \"b = conv(a,c) + r\". Equivalent to
   polynomial division.

"),

("信号处理","Base","conv","conv(u, v)

   计算两个向量的卷积。使用 FFT 算法。

"),

("信号处理","Base","xcorr","xcorr(u, v)

   计算两个向量的互相关。

"),

("并行计算","Base","addprocs_local","addprocs_local(n)

   Add processes on the local machine. Can be used to take advantage
   of multiple cores.

"),

("并行计算","Base","addprocs_ssh","addprocs_ssh({\"host1\", \"host2\", ...})

   Add processes on remote machines via SSH. Requires julia to be
   installed in the same location on each node, or to be available via
   a shared file system.

"),

("并行计算","Base","addprocs_sge","addprocs_sge(n)

   Add processes via the Sun/Oracle Grid Engine batch queue, using
   \"qsub\".

"),

("并行计算","Base","nprocs","nprocs()

   获取当前可用处理器的个数。

"),

("并行计算","Base","myid","myid()

   获取当前处理器的 ID 。

"),

("并行计算","Base","pmap","pmap(f, c)

   Transform collection \"c\" by applying \"f\" to each element in
   parallel.

"),

("并行计算","Base","remote_call","remote_call(id, func, args...)

   Call a function asynchronously on the given arguments on the
   specified processor. 返回 \"RemoteRef\" 。

"),

("并行计算","Base","wait","wait(RemoteRef)

   Wait for a value to become available for the specified remote
   reference.

"),

("并行计算","Base","fetch","fetch(RemoteRef)

   等待并获取 remote reference 的值。

"),

("并行计算","Base","remote_call_wait","remote_call_wait(id, func, args...)

   Perform \"wait(remote_call(...))\" in one message.

"),

("并行计算","Base","remote_call_fetch","remote_call_fetch(id, func, args...)

   Perform \"fetch(remote_call(...))\" in one message.

"),

("并行计算","Base","put","put(RemoteRef, value)

   Store a value to a remote reference. Implements \"shared queue of
   length 1\" semantics: if a value is already present, blocks until
   the value is removed with \"take\".

"),

("并行计算","Base","take","take(RemoteRef)

   取回 remote reference 的值，removing it so that the reference is empty
   again.

"),

("并行计算","Base","RemoteRef","RemoteRef()

   Make an uninitialized remote reference on the local machine.

"),

("并行计算","Base","RemoteRef","RemoteRef(n)

   Make an uninitialized remote reference on processor \"n\".

"),

("分布式数组","Base","DArray","DArray(init, dims[, procs, dist])

   构造分布式数组。 \"init\" is a function accepting a tuple of index ranges.
   This function should return a chunk of the distributed array for
   the specified indexes. \"dims\" is the overall size of the
   distributed array. \"procs\" optionally specifies a vector of
   processor IDs to use. \"dist\" is an integer vector specifying how
   many chunks the distributed array should be divided into in each
   dimension.

"),

("分布式数组","Base","dzeros","dzeros(dims, ...)

   构造全零的分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

("分布式数组","Base","dones","dones(dims, ...)

   构造全一的分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

("分布式数组","Base","dfill","dfill(x, dims, ...)

   构造值全为 \"x\" 的分布式数组。Trailing arguments are the same as those
   accepted by \"darray\".

"),

("分布式数组","Base","drand","drand(dims, ...)

   构造均匀分布的随机分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

("分布式数组","Base","drandn","drandn(dims, ...)

   构造正态分布的随机分布式数组。Trailing arguments are the same as those accepted by
   \"darray\".

"),

("分布式数组","Base","distribute","distribute(a)

   将本地数组转换为分布式数组。

"),

("分布式数组","Base","localize","localize(d)

   获取分布式数组的本地部分。

"),

("分布式数组","Base","myindexes","myindexes(d)

   A tuple describing the indexes owned by the local processor

"),

("分布式数组","Base","procs","procs(d)

   Get the vector of processors storing pieces of \"d\"

"),

("系统","Base","run","run(command)

   执行命令对象。Throws an error if anything goes wrong, including the
   process exiting with a non-zero status.命令是由倒引号引起来的。

"),

("系统","Base","success","success(command)

   执行命令对象，并判断是否成功（退出代码是否为 0 ）。命令是由倒引号引起来的。

"),

("系统","Base","readsfrom","readsfrom(command)

   Starts running a command asynchronously, and returns a tuple
   (stream,process). The first value is a stream reading from the
   process' standard output.

"),

("系统","Base","writesto","writesto(command)

   Starts running a command asynchronously, and returns a tuple
   (stream,process). The first value is a stream writing to the
   process' standard input.

"),

("系统","Base","readandwrite","readandwrite(command)

   Starts running a command asynchronously, and returns a tuple
   (stdout,stdin,process) of the output stream and input stream of the
   process, and the process object itself.

"),

("系统","","> < >> .>","> < >> .>

   \">\" \"<\" and \">>\" work exactly as in bash, and \".>\"
   redirects STDERR.

   **例子** ： \"run((`ls` > \"out.log\") .> \"err.log\")\"

"),

("系统","Base","gethostname","gethostname() -> String

   获取本机的主机名。

"),

("系统","Base","getipaddr","getipaddr() -> String

   获取本机的 IP 地址，形为 \"x.x.x.x\" 的字符串。

"),

("系统","Base","pwd","pwd() -> String

   获取当前的工作目录。

"),

("系统","Base","cd","cd(dir::String)

   Set the current working directory. 返回the new current directory.

"),

("系统","Base","cd","cd(f[, \"dir\"])

   Temporarily changes the current working directory (HOME if not
   specified) and applies function f before returning.

"),

("系统","Base","mkdir","mkdir(path[, mode])

   Make a new directory with name \"path\" and permissions \"mode\".
   \"mode\" defaults to 0o777, modified by the current file creation
   mask.

"),

("系统","Base","rmdir","rmdir(path)

   移除the directory named \"path\".

"),

("系统","Base","getpid","getpid() -> Int32

   获取 Julia 的进程 ID 。

"),

("系统","Base","time","time()

   获取系统自 1970-01-01 00:00:00 UTC 起至今的秒数。结果是高解析度（一般为微秒 10^{-6} ）的。

"),

("系统","Base","time_ns","time_ns()

   获取时间，单位为纳秒 10^{-9} 。对应于 0 的时间是未定义的，计时时间 5.8 年为最长周期。

"),

("系统","Base","tic","tic()

   设置计时器， \"toc()\" 或 \"toq()\" 会调用它所计时的时间。也可以使用 \"@time expr\"
   宏来计算时间。

"),

("系统","Base","toc","toc()

   打印并返回最后一个 \"tic()\" 计时器的时间。

"),

("系统","Base","toq","toq()

   返回但不打印最后一个 \"tic()\" 计时器的时间。

"),

("系统","Base","EnvHash","EnvHash() -> EnvHash

   给环境变量提供哈希表接口的单态。

"),

("系统","Base","ENV","ENV

   对单态 \"EnvHash\" 的引用。

"),

("C 接口","Base","ccall","ccall((symbol, library), RetType, (ArgType1, ...), ArgVar1, ...)
ccall(fptr::Ptr{Void}, RetType, (ArgType1, ...), ArgVar1, ...)

   Call function in C-exported shared library, specified by (function
   name, library) tuple (String or :Symbol). Alternatively, ccall may
   be used to call a function pointer returned by dlsym, but note that
   this usage is generally discouraged to facilitate future static
   compilation.

"),

("C 接口","Base","cfunction","cfunction(fun::Function, RetType::Type, (ArgTypes...))

   Generate C-callable function pointer from Julia function.

"),

("C 接口","Base","dlopen","dlopen(libfile::String[, flags::Integer])

   载入共享库，返回不透明句柄。

   可选参数为 0 或者是 RTLD_LOCAL, RTLD_GLOBAL, RTLD_LAZY, RTLD_NOW,
   RTLD_NODELETE, RTLD_NOLOAD, RTLD_DEEPBIND, RTLD_FIRST
   等参数的位或。它们被转换为对应的 POSIX dlopen 命令的标志位，如果当前平台不支持某个特性，则忽略。默认值为
   RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL 。在 POSIX
   平台上，这些标志位的重要用途是当共享库之间有依赖关系时，指明 RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL
   来使库的符号可被其它共享库使用。

"),

("C 接口","Base","dlsym","dlsym(handle, sym)

   Look up a symbol from a shared library handle, return callable
   function pointer on success.

"),

("C 接口","Base","dlsym_e","dlsym_e(handle, sym)

   Look up a symbol from a shared library handle, silently return NULL
   pointer on lookup failure.

"),

("C 接口","Base","dlclose","dlclose(handle)

   通过句柄来关闭共享库的引用。

"),

("C 接口","Base","c_free","c_free(addr::Ptr)

   调用 C 标准库中的 ·``free()`` 。

"),

("C 接口","Base","unsafe_ref","unsafe_ref(p::Ptr{T}, i::Integer)

   对指针解引用 \"p[i]\" 或 \"*p\" ，返回类型 T 的值的浅拷贝。

"),

("C 接口","Base","unsafe_assign","unsafe_assign(p::Ptr{T}, x, i::Integer)

   给指针赋值 \"p[i] = x\" 或 \"*p = x\" ，将对象 x 复制进 p 处的内存中。

"),

("错误","Base","error","error(message::String)
error(Exception)

   报错，并显示指定信息。

"),

("错误","Base","throw","throw(e)

   将一个对象作为异常抛出。

"),

("错误","Base","errno","errno()

   获取 C 库 \"errno\" 的值。

"),

("错误","Base","strerror","strerror(n)

   将系统调用错误代码转换为描述字符串。

"),

("错误","Base","assert","assert(cond)

   如果 \"cond\" 为假则报错。也可以使用宏 \"@assert expr\" 。

"),

("任务","Base","Task","Task(func)

   构造 \"Task\" （如线程，协程）来执行指定程序。此函数返回时，任务自动退出。

"),

("任务","Base","yieldto","yieldto(task, args...)

   跳转到指定的任务。第一次跳转到某任务时，使用 \"args\" 参数来调用任务的函数。在后续的跳转时， \"args\"
   被任务的最后一个调用返回到 \"yieldto\" 。

"),

("任务","Base","current_task","current_task()

   获取当前正在运行的任务。

"),

("任务","Base","istaskdone","istaskdone(task)

   判断任务是否已退出。

"),

("任务","Base","consume","consume(task)

   接收由指定任务传递给 \"produce\" 的下一个值。

"),

("任务","Base","produce","produce(value)

   将指定值传递给最近的一次 \"consume\" 调用，然后跳转到消费者任务。

"),

("任务","Base","make_scheduled","make_scheduled(task)

   使用主事件循环来注册任务，任务会在允许的时候自动运行。

"),

("任务","Base","yield","yield()

   对安排好的任务，跳转到安排者来允许运行另一个安排好的任务。

"),

("任务","Base","tls","tls(symbol)

   在当前任务的本地任务存储中查询 \"symbol\" 的值。

"),

("任务","Base","tls","tls(symbol, value)

   给当前任务的本地任务存储中的 \"symbol\" 赋值 \"value\" 。

"),

("BLAS","BLAS","copy!","copy!(n, X, incx, Y, incy)

   Copy \"n\" elements of array \"X\" with stride \"incx\" to array
   \"Y\" with stride \"incy\".返回 \"Y\" 。

"),

("BLAS","BLAS","dot","dot(n, X, incx, Y, incy)

   Dot product of two vectors consisting of \"n\" elements of array
   \"X\" with stride \"incx\" and \"n\" elements of array \"Y\" with
   stride \"incy\".  There are no \"dot\" methods for \"Complex\"
   arrays.

"),

("BLAS","BLAS","nrm2","nrm2(n, X, incx)

   2-norm of a vector consisting of \"n\" elements of array \"X\" with
   stride \"incx\".

"),

("BLAS","BLAS","axpy!","axpy!(n, a, X, incx, Y, incy)

   Overwrite \"Y\" with \"a*X + Y\".返回 \"Y\" 。

"),

("BLAS","BLAS","syrk!","syrk!(uplo, trans, alpha, A, beta, C)

   Rank-k update of the symmetric matrix \"C\" as \"alpha*A*A.' +
   beta*C\" or \"alpha*A.'*A + beta*C\" according to whether \"trans\"
   is 'N' or 'T'.  When \"uplo\" is 'U' the upper triangle of \"C\" is
   updated ('L' for lower triangle).返回 \"C\" 。

"),

("BLAS","BLAS","syrk","syrk(uplo, trans, alpha, A)

   返回either the upper triangle or the lower triangle, according to
   \"uplo\" ('U' or 'L'), of \"alpha*A*A.'\" or \"alpha*A.'*A\",
   according to \"trans\" ('N' or 'T').

"),

("BLAS","BLAS","herk!","herk!(uplo, trans, alpha, A, beta, C)

   Methods for complex arrays only.  Rank-k update of the Hermitian
   matrix \"C\" as \"alpha*A*A' + beta*C\" or \"alpha*A'*A + beta*C\"
   according to whether \"trans\" is 'N' or 'T'.  When \"uplo\" is 'U'
   the upper triangle of \"C\" is updated ('L' for lower triangle). 返回
   \"C\" 。

"),

("BLAS","BLAS","herk","herk(uplo, trans, alpha, A)

   Methods for complex arrays only.  返回either the upper triangle or
   the lower triangle, according to \"uplo\" ('U' or 'L'), of
   \"alpha*A*A'\" or \"alpha*A'*A\", according to \"trans\" ('N' or
   'T').

"),

("BLAS","BLAS","gbmv!","gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)

   Update vector \"y\" as \"alpha*A*x + beta*y\" or \"alpha*A'*x +
   beta*y\" according to \"trans\" ('N' or 'T').  The matrix \"A\" is
   a general band matrix of dimension \"m\" by \"size(A,2)\" with
   \"kl\" sub-diagonals and \"ku\" super-diagonals. 返回更新后的 \"y\" 。

"),

("BLAS","BLAS","gbmv","gbmv(trans, m, kl, ku, alpha, A, x, beta, y)

   返回 \"alpha*A*x\" or \"alpha*A'*x\" according to \"trans\" ('N' or
   'T'). The matrix \"A\" is a general band matrix of dimension \"m\"
   by \"size(A,2)\" with \"kl\" sub-diagonals and \"ku\" super-
   diagonals.

"),

("BLAS","BLAS","sbmv!","sbmv!(uplo, k, alpha, A, x, beta, y)

   Update vector \"y\" as \"alpha*A*x + beta*y\" where \"A\" is a a
   symmetric band matrix of order \"size(A,2)\" with \"k\" super-
   diagonals stored in the argument \"A\".  The storage layout for
   \"A\" is described the reference BLAS module, level-2 BLAS at
   *<http://www.netlib.org/lapack/explore-html/>*.

   返回更新后的 \"y\" 。

"),

("BLAS","BLAS","sbmv","sbmv(uplo, k, alpha, A, x)

   返回 \"alpha*A*x\" where \"A\" is a symmetric band matrix of order
   \"size(A,2)\" with \"k\" super-diagonals stored in the argument
   \"A\".

"),

("BLAS","BLAS","gemm!","gemm!(tA, tB, alpha, A, B, beta, C)

   Update \"C\" as \"alpha*A*B + beta*C\" or the other three variants
   according to \"tA\" (transpose \"A\") and \"tB\".返回更新后的 \"C\" 。

"),

("BLAS","BLAS","gemm","gemm(tA, tB, alpha, A, B)

   返回 \"alpha*A*B\" or the other three variants according to \"tA\"
   (transpose \"A\") and \"tB\".

"),

("常量","Base","OS_NAME","OS_NAME

   表示操作系统名的符号。可能的值有 \":Linux\", \":Darwin\" (OS X), 或 \":Windows\" 。

"),

("cpp.jl","","@cpp","@cpp(ccall_expression)

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

("GLPK","GLPK","set_prob_name","set_prob_name(glp_prob, name)

   Assigns a name to the problem object (or deletes it if \"name\" is
   empty or \"nothing\").

"),

("GLPK","GLPK","set_obj_name","set_obj_name(glp_prob, name)

   Assigns a name to the objective function (or deletes it if \"name\"
   is empty or \"nothing\").

"),

("GLPK","GLPK","set_obj_dir","set_obj_dir(glp_prob, dir)

   Sets the optimization direction, \"GLPK.MIN\" (minimization) or
   \"GLPK.MAX\" (maximization).

"),

("GLPK","GLPK","add_rows","add_rows(glp_prob, rows)

   Adds the given number of rows (constraints) to the problem object;
   returns the number of the first new row added.

"),

("GLPK","GLPK","add_cols","add_cols(glp_prob, cols)

   Adds the given number of columns (structural variables) to the
   problem object; returns the number of the first new column added.

"),

("GLPK","GLPK","set_row_name","set_row_name(glp_prob, row, name)

   Assigns a name to the specified row (or deletes it if \"name\" is
   empty or \"nothing\").

"),

("GLPK","GLPK","set_col_name","set_col_name(glp_prob, col, name)

   Assigns a name to the specified column (or deletes it if \"name\"
   is empty or \"nothing\").

"),

("GLPK","GLPK","set_row_bnds","set_row_bnds(glp_prob, row, bounds_type, lb, ub)

   Sets the type and bounds on a row. \"type\" must be one of
   \"GLPK.FR\" (free), \"GLPK.LO\" (lower bounded), \"GLPK.UP\" (upper
   bounded), \"GLPK.DB\" (double bounded), \"GLPK.FX\" (fixed).

   At initialization, each row is free.

"),

("GLPK","GLPK","set_col_bnds","set_col_bnds(glp_prob, col, bounds_type, lb, ub)

   Sets the type and bounds on a column. \"type\" must be one of
   \"GLPK.FR\" (free), \"GLPK.LO\" (lower bounded), \"GLPK.UP\" (upper
   bounded), \"GLPK.DB\" (double bounded), \"GLPK.FX\" (fixed).

   At initialization, each column is fixed at 0.

"),

("GLPK","GLPK","set_obj_coef","set_obj_coef(glp_prob, col, coef)

   Sets the objective coefficient to a column (\"col\" can be 0 to
   indicate the constant term of the objective function).

"),

("GLPK","GLPK","set_mat_row","set_mat_row(glp_prob, row[, len], ind, val)

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

("GLPK","GLPK","set_mat_col","set_mat_col(glp_prob, col[, len], ind, val)

   Sets (replaces) the content of a column. Everything else is like
   \"set_mat_row\".

"),

("GLPK","GLPK","load_matrix","load_matrix(glp_prob[, numel], ia, ja, ar)
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

("GLPK","GLPK","check_dup","check_dup(rows, cols[, numel], ia, ja)

   Check for duplicates in the indices vectors \"ia\" and \"ja\".
   \"numel\" has the same meaning and (optional) use as in
   \"load_matrix\". 返回0 if no duplicates/out-of-range indices are
   found, or a positive number indicating where a duplicate occurs, or
   a negative number indicating an out-of-bounds index.

"),

("GLPK","GLPK","sort_matrix","sort_matrix(glp_prob)

   Sorts the elements of the problem object's matrix.

"),

("GLPK","GLPK","del_rows","del_rows(glp_prob[, num_rows], rows_ids)

   删除rows from the problem object. Rows are specified in the
   \"rows_ids\" vector. \"num_rows\" is the number of elements of
   \"rows_ids\" which will be considered, and must be less or equal to
   the length id \"rows_ids\". If \"num_rows\" is 0, \"rows_ids\" can
   be \"nothing\". In Julia, \"num_rows\" is optional (it's inferred
   from \"rows_ids\" if not given).

"),

("GLPK","GLPK","del_cols","del_cols(glp_prob, cols_ids)

   删除columns from the problem object. See \"del_rows\".

"),

("GLPK","GLPK","copy_prob","copy_prob(glp_prob_dest, glp_prob, copy_names)

   Makes a copy of the problem object. The flag \"copy_names\"
   determines if names are copied, and must be either \"GLPK.ON\" or
   \"GLPK.OFF\".

"),

("GLPK","GLPK","erase_prob","erase_prob(glp_prob)

   Resets the problem object.

"),

("GLPK","GLPK","get_prob_name","get_prob_name(glp_prob)

   返回the problem object's name. Unlike the C version, if the problem
   has no assigned name, returns an empty string.

"),

("GLPK","GLPK","get_obj_name","get_obj_name(glp_prob)

   返回the objective function's name. Unlike the C version, if the
   objective has no assigned name, returns an empty string.

"),

("GLPK","GLPK","get_obj_dir","get_obj_dir(glp_prob)

   返回the optimization direction, \"GLPK.MIN\" (minimization) or
   \"GLPK.MAX\" (maximization).

"),

("GLPK","GLPK","get_num_rows","get_num_rows(glp_prob)

   返回the current number of rows.

"),

("GLPK","GLPK","get_num_cols","get_num_cols(glp_prob)

   返回the current number of columns.

"),

("GLPK","GLPK","get_row_name","get_row_name(glp_prob, row)

   返回the name of the specified row. Unlike the C version, if the row
   has no assigned name, returns an empty string.

"),

("GLPK","GLPK","get_col_name","get_col_name(glp_prob, col)

   返回the name of the specified column. Unlike the C version, if the
   column has no assigned name, returns an empty string.

"),

("GLPK","GLPK","get_row_type","get_row_type(glp_prob, row)

   返回the type of the specified row: \"GLPK.FR\" (free), \"GLPK.LO\"
   (lower bounded), \"GLPK.UP\" (upper bounded), \"GLPK.DB\" (double
   bounded), \"GLPK.FX\" (fixed).

"),

("GLPK","GLPK","get_row_lb","get_row_lb(glp_prob, row)

   返回the lower bound of the specified row, \"-DBL_MAX\" if unbounded.

"),

("GLPK","GLPK","get_row_ub","get_row_ub(glp_prob, row)

   返回the upper bound of the specified row, \"+DBL_MAX\" if unbounded.

"),

("GLPK","GLPK","get_col_type","get_col_type(glp_prob, col)

   返回the type of the specified column: \"GLPK.FR\" (free), \"GLPK.LO\"
   (lower bounded), \"GLPK.UP\" (upper bounded), \"GLPK.DB\" (double
   bounded), \"GLPK.FX\" (fixed).

"),

("GLPK","GLPK","get_col_lb","get_col_lb(glp_prob, col)

   返回the lower bound of the specified column, \"-DBL_MAX\" if
   unbounded.

"),

("GLPK","GLPK","get_col_ub","get_col_ub(glp_prob, col)

   返回the upper bound of the specified column, \"+DBL_MAX\" if
   unbounded.

"),

("GLPK","GLPK","get_obj_coef","get_obj_coef(glp_prob, col)

   返回 the objective coefficient to a column (\"col\" can be 0 to
   indicate the constant term of the objective function).

"),

("GLPK","GLPK","get_num_nz","get_num_nz(glp_prob)

   返回 the number of non-zero elements in the constraint matrix.

"),

("GLPK","GLPK","get_mat_row","get_mat_row(glp_prob, row, ind, val)
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

("GLPK","GLPK","get_mat_col","get_mat_col(glp_prob, col, ind, val)
get_mat_col(glp_prob, col)

   返回the contents of a column. See \"get_mat_row\".

"),

("GLPK","GLPK","create_index","create_index(glp_prob)

   Creates the name index (used by \"find_row\", \"find_col\") for the
   problem object.

"),

("GLPK","GLPK","find_row","find_row(glp_prob, name)

   Finds the numeric id of a row by name. 返回0 if no row with the given
   name is found.

"),

("GLPK","GLPK","find_col","find_col(glp_prob, name)

   Finds the numeric id of a column by name. 返回0 if no column with the
   given name is found.

"),

("GLPK","GLPK","delete_index","delete_index(glp_prob)

   删除the name index for the problem object.

"),

("GLPK","GLPK","set_rii","set_rii(glp_prob, row, rii)

   Sets the rii scale factor for the specified row.

"),

("GLPK","GLPK","set_sjj","set_sjj(glp_prob, col, sjj)

   Sets the sjj scale factor for the specified column.

"),

("GLPK","GLPK","get_rii","get_rii(glp_prob, row)

   返回the rii scale factor for the specified row.

"),

("GLPK","GLPK","get_sjj","get_sjj(glp_prob, col)

   返回the sjj scale factor for the specified column.

"),

("GLPK","GLPK","scale_prob","scale_prob(glp_prob, flags)

   Performs automatic scaling of problem data for the problem object.
   The parameter \"flags\" can be \"GLPK.SF_AUTO\" (automatic) or a
   bitwise OR of the forllowing: \"GLPK.SF_GM\" (geometric mean),
   \"GLPK.SF_EQ\" (equilibration), \"GLPK.SF_2N\" (nearest power of
   2), \"GLPK.SF_SKIP\" (skip if well scaled).

"),

("GLPK","GLPK","unscale_prob","unscale_prob(glp_prob)

   Unscale the problem data (cancels the scaling effect).

"),

("GLPK","GLPK","set_row_stat","set_row_stat(glp_prob, row, stat)

   Sets the status of the specified row. \"stat\" must be one of:
   \"GLPK.BS\" (basic), \"GLPK.NL\" (non-basic lower bounded),
   \"GLPK.NU\" (non-basic upper-bounded), \"GLPK.NF\" (non-basic
   free), \"GLPK.NS\" (non-basic fixed).

"),

("GLPK","GLPK","set_col_stat","set_col_stat(glp_prob, col, stat)

   Sets the status of the specified column. \"stat\" must be one of:
   \"GLPK.BS\" (basic), \"GLPK.NL\" (non-basic lower bounded),
   \"GLPK.NU\" (non-basic upper-bounded), \"GLPK.NF\" (non-basic
   free), \"GLPK.NS\" (non-basic fixed).

"),

("GLPK","GLPK","std_basis","std_basis(glp_prob)

   构造the standard (trivial) initial LP basis for the problem object.

"),

("GLPK","GLPK","adv_basis","adv_basis(glp_prob[, flags])

   构造an advanced initial LP basis for the problem object. The flag
   \"flags\" is optional; it must be 0 if given.

"),

("GLPK","GLPK","cpx_basis","cpx_basis(glp_prob)

   构造an initial LP basis for the problem object with the algorithm
   proposed by R. Bixby.

"),

("GLPK","GLPK","simplex","simplex(glp_prob[, glp_param])

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

("GLPK","GLPK","exact","exact(glp_prob[, glp_param])

   A tentative implementation of the primal two-phase simplex method
   based on exact (rational) arithmetic. Similar to \"simplex\". The
   optional \"glp_param\" is of type \"GLPK.SimplexParam\".

   The possible return values are \"0\" (success) or \"GLPK.EBADB\",
   \"GLPK.ESING\", \"GLPK.EBOUND\", \"GLPK.EFAIL\", \"GLPK.ITLIM\",
   \"GLPK.ETLIM\" (see \"simplex()\").

"),

("GLPK","GLPK","init_smcp","init_smcp(glp_param)

   Initializes a \"GLPK.SimplexParam\" object with the default values.
   In Julia, this is done at object creation time; this function can
   be used to reset the object.

"),

("GLPK","GLPK","get_status","get_status(glp_prob)

   返回the generic status of the current basic solution: \"GLPK.OPT\"
   (optimal), \"GLPK.FEAS\" (feasible), \"GLPK.INFEAS\" (infeasible),
   \"GLPK.NOFEAS\" (no feasible solution), \"GLPK.UNBND\" (unbounded
   solution), \"GLPK.UNDEF\" (undefined).

"),

("GLPK","GLPK","get_prim_stat","get_prim_stat(glp_prob)

   返回the status of the primal basic solution: \"GLPK.FEAS\",
   \"GLPK.INFEAS\", \"GLPK.NOFEAS\", \"GLPK.UNDEF\" (see
   \"get_status()\").

"),

("GLPK","GLPK","get_dual_stat","get_dual_stat(glp_prob)

   返回the status of the dual basic solution: \"GLPK.FEAS\",
   \"GLPK.INFEAS\", \"GLPK.NOFEAS\", \"GLPK.UNDEF\" (see
   \"get_status()\").

"),

("GLPK","GLPK","get_obj_val","get_obj_val(glp_prob)

   返回the current value of the objective function.

"),

("GLPK","GLPK","get_row_stat","get_row_stat(glp_prob, row)

   返回the status of the specified row: \"GLPK.BS\", \"GLPK.NL\",
   \"GLPK.NU\", \"GLPK.NF\", \"GLPK.NS\" (see \"set_row_stat()\").

"),

("GLPK","GLPK","get_row_prim","get_row_prim(glp_prob, row)

   返回the primal value of the specified row.

"),

("GLPK","GLPK","get_row_dual","get_row_dual(glp_prob, row)

   返回the dual value (reduced cost) of the specified row.

"),

("GLPK","GLPK","get_col_stat","get_col_stat(glp_prob, col)

   返回the status of the specified column: \"GLPK.BS\", \"GLPK.NL\",
   \"GLPK.NU\", \"GLPK.NF\", \"GLPK.NS\" (see \"set_row_stat()\").

"),

("GLPK","GLPK","get_col_prim","get_col_prim(glp_prob, col)

   返回the primal value of the specified column.

"),

("GLPK","GLPK","get_col_dual","get_col_dual(glp_prob, col)

   返回the dual value (reduced cost) of the specified column.

"),

("GLPK","GLPK","get_unbnd_ray","get_unbnd_ray(glp_prob)

   返回the number k of a variable, which causes primal or dual
   unboundedness (if 1 <= k <= rows it's row k; if rows+1 <= k <=
   rows+cols it's column k-rows, if k=0 such variable is not defined).

"),

("GLPK","GLPK","interior","interior(glp_prob[, glp_param])

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

("GLPK","GLPK","init_iptcp","init_iptcp(glp_param)

   Initializes a \"GLPK.InteriorParam\" object with the default
   values. In Julia, this is done at object creation time; this
   function can be used to reset the object.

"),

("GLPK","GLPK","ipt_status","ipt_status(glp_prob)

   返回the status of the interior-point solution: \"GLPK.OPT\"
   (optimal), \"GLPK.INFEAS\" (infeasible), \"GLPK.NOFEAS\" (no
   feasible solution), \"GLPK.UNDEF\" (undefined).

"),

("GLPK","GLPK","ipt_obj_val","ipt_obj_val(glp_prob)

   返回the current value of the objective function for the interior-
   point solution.

"),

("GLPK","GLPK","ipt_row_prim","ipt_row_prim(glp_prob, row)

   返回the primal value of the specified row for the interior-point
   solution.

"),

("GLPK","GLPK","ipt_row_dual","ipt_row_dual(glp_prob, row)

   返回the dual value (reduced cost) of the specified row for the
   interior-point solution.

"),

("GLPK","GLPK","ipt_col_prim","ipt_col_prim(glp_prob, col)

   返回the primal value of the specified column for the interior-point
   solution.

"),

("GLPK","GLPK","ipt_col_dual","ipt_col_dual(glp_prob, col)

   返回the dual value (reduced cost) of the specified column for the
   interior-point solution.

"),

("GLPK","GLPK","set_col_kind","set_col_kind(glp_prob, col, kind)

   Sets the kind for the specified column (for mixed-integer
   programming). \"kind\" must be one of: \"GLPK.CV\" (continuous),
   \"GLPK.IV\" (integer), \"GLPK.BV\" (binary, 0/1).

"),

("GLPK","GLPK","get_col_kind","get_col_kind(glp_prob, col)

   返回the kind for the specified column (see \"set_col_kind()\").

"),

("GLPK","GLPK","get_num_int","get_num_int(glp_prob)

   返回the number of columns marked as integer (including binary).

"),

("GLPK","GLPK","get_num_bin","get_num_bin(glp_prob)

   返回the number of columns marked binary.

"),

("GLPK","GLPK","intopt","intopt(glp_prob[, glp_param])

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

("GLPK","GLPK","init_iocp","init_iocp(glp_param)

   Initializes a \"GLPK.IntoptParam\" object with the default values.
   In Julia, this is done at object creation time; this function can
   be used to reset the object.

"),

("GLPK","GLPK","mip_status","mip_status(glp_prob)

   返回the generic status of the MIP solution: \"GLPK.OPT\" (optimal),
   \"GLPK.FEAS\" (feasible), \"GLPK.NOFEAS\" (no feasible solution),
   \"GLPK.UNDEF\" (undefined).

"),

("GLPK","GLPK","mip_obj_val","mip_obj_val(glp_prob)

   返回the current value of the objective function for the MIP solution.

"),

("GLPK","GLPK","mip_row_val","mip_row_val(glp_prob, row)

   返回the value of the specified row for the MIP solution.

"),

("GLPK","GLPK","mip_col_val","mip_col_val(glp_prob, col)

   返回the value of the specified column for the MIP solution.

"),

("GLPK","GLPK","read_mps","read_mps(glp_prob, format[, param], filename)

   Reads problem data in MPS format from a text file. \"format\" must
   be one of \"GLPK.MPS_DECK\" (fixed, old) or \"GLPK.MPS_FILE\"
   (free, modern). \"param\" is optional; if given it must be
   \"nothing\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_mps","write_mps(glp_prob, format[, param], filename)

   Writes problem data in MPS format from a text file. See
   \"read_mps\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","read_lp","read_lp(glp_prob[, param], filename)

   Reads problem data in CPLEX LP format from a text file. \"param\"
   is optional; if given it must be \"nothing\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_lp","write_lp(glp_prob[, param], filename)

   Writes problem data in CPLEX LP format from a text file. See
   \"read_lp\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","read_prob","read_prob(glp_prob[, flags], filename)

   Reads problem data in GLPK LP/MIP format from a text file.
   \"flags\" is optional; if given it must be 0.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_prob","write_prob(glp_prob[, flags], filename)

   Writes problem data in GLPK LP/MIP format from a text file. See
   \"read_prob\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","mpl_read_model","mpl_read_model(glp_tran, filename, skip)

   Reads the model section and, optionally, the data section, from a
   text file in MathProg format, and stores it in \"glp_tran\", which
   is a \"GLPK.MathProgWorkspace\" object. If \"skip\" is nonzero, the
   data section is skipped if present.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","mpl_read_data","mpl_read_data(glp_tran, filename)

   Reads data section from a text file in MathProg format and stores
   it in \"glp_tran\", which is a \"GLPK.MathProgWorkspace\" object.
   May be called more than once.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","mpl_generate","mpl_generate(glp_tran[, filename])

   Generates the model using its description stored in the
   \"GLPK.MathProgWorkspace\" translator workspace \"glp_tran\". The
   optional \"filename\" specifies an output file; if not given or
   \"nothing\", the terminal is used.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","mpl_build_prob","mpl_build_prob(glp_tran, glp_prob)

   Transfer information from the \"GLPK.MathProgWorkspace\" translator
   workspace \"glp_tran\" to the \"GLPK.Prob\" problem object
   \"glp_prob\".

"),

("GLPK","GLPK","mpl_postsolve","mpl_postsolve(glp_tran, glp_prob, sol)

   Copies the solution from the \"GLPK.Prob\" problem object
   \"glp_prob\" to the \"GLPK.MathProgWorkspace\" translator workspace
   \"glp_tran\" and then executes all the remaining model statements,
   which follow the solve statement.

   The parameter \"sol\" specifies which solution should be copied
   from the problem object to the workspace: \"GLPK.SOL\" (basic),
   \"GLPK.IPT\" (interior-point), \"GLPK.MIP\" (MIP).

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","print_sol","print_sol(glp_prob, filename)

   Writes the current basic solution to a text file, in printable
   format.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","read_sol","read_sol(glp_prob, filename)

   Reads the current basic solution from a text file, in the format
   used by \"write_sol\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_sol","write_sol(glp_prob, filename)

   Writes the current basic solution from a text file, in a format
   which can be read by \"read_sol\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","print_ipt","print_ipt(glp_prob, filename)

   Writes the current interior-point solution to a text file, in
   printable format.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","read_ipt","read_ipt(glp_prob, filename)

   Reads the current interior-point solution from a text file, in the
   format used by \"write_ipt\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_ipt","write_ipt(glp_prob, filename)

   Writes the current interior-point solution from a text file, in a
   format which can be read by \"read_ipt\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","print_mip","print_mip(glp_prob, filename)

   Writes the current MIP solution to a text file, in printable
   format.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","read_mip","read_mip(glp_prob, filename)

   Reads the current MIP solution from a text file, in the format used
   by \"write_mip\".

   返回0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","write_mip","write_mip(glp_prob, filename)

   Writes the current MIP solution from a text file, in a format which
   can be read by \"read_mip\".

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","print_ranges","print_ranges(glp_prob, [[len,] list,] [flags,] filename)

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

("GLPK","GLPK","bf_exists","bf_exists(glp_prob)

   返回non-zero if the basis fatorization for the current basis exists,
   0 otherwise.

"),

("GLPK","GLPK","factorize","factorize(glp_prob)

   Computes the basis factorization for the current basis.

   返回 0 if successful, otherwise: \"GLPK.EBADB\" (invalid matrix),
   \"GLPK.ESING\" (singluar matrix), \"GLPK.ECOND\" (ill-conditioned
   matrix).

"),

("GLPK","GLPK","bf_updated","bf_updated(glp_prob)

   返回 0 if the basis factorization was computed from scratch, non-zero
   otherwise.

"),

("GLPK","GLPK","get_bfcp","get_bfcp(glp_prob, glp_param)

   Retrieves control parameters, which are used on computing and
   updating the basis factorization associated with the problem
   object, and stores them in the \"GLPK.BasisFactParam\" object
   \"glp_param\".

"),

("GLPK","GLPK","set_bfcp","set_bfcp(glp_prob[, glp_param])

   Sets the control parameters stored in the \"GLPK.BasisFactParam\"
   object \"glp_param\" into the problem object. If \"glp_param\" is
   \"nothing\" or is omitted, resets the parameters to their defaults.

   The \"glp_param\" should always be retreived via \"get_bfcp\"
   before changing its values and calling this function.

"),

("GLPK","GLPK","get_bhead","get_bhead(glp_prob, k)

   返回the basis header information for the current basis. \"k\" is a
   row index.

   返回either i such that 1 <= i <= rows, if \"k\" corresponds to i-th
   auxiliary variable, or rows+j such that 1 <= j <= columns, if \"k\"
   corresponds to the j-th structural variable.

"),

("GLPK","GLPK","get_row_bind","get_row_bind(glp_prob, row)

   返回the index of the basic variable \"k\" which is associated with
   the specified row, or \"0\" if the variable is non-basic. If
   \"GLPK.get_bhead(glp_prob, k) == row\", then
   \"GLPK.get_bind(glp_prob, row) = k\".

"),

("GLPK","GLPK","get_col_bind","get_col_bind(glp_prob, col)

   返回the index of the basic variable \"k\" which is associated with
   the specified column, or \"0\" if the variable is non-basic. If
   \"GLPK.get_bhead(glp_prob, k) == rows+col\", then
   \"GLPK.get_bind(glp_prob, col) = k\".

"),

("GLPK","GLPK","ftran","ftran(glp_prob, v)

   Performs forward transformation (FTRAN), i.e. it solves the system
   Bx = b, where B is the basis matrix, x is the vector of unknowns to
   be computed, b is the vector of right-hand sides. At input, \"v\"
   represents the vector b; at output, it contains the vector x. \"v\"
   must be a \"Vector{Float64}\" whose length is the number of rows.

"),

("GLPK","GLPK","btran","btran(glp_prob, v)

   Performs backward transformation (BTRAN), i.e. it solves the system
   \"B'x = b\", where \"B\" is the transposed of the basis matrix,
   \"x\" is the vector of unknowns to be computed, \"b\" is the vector
   of right-hand sides. At input, \"v\" represents the vector \"b\";
   at output, it contains the vector \"x\". \"v\" must be a
   \"Vector{Float64}\" whose length is the number of rows.

"),

("GLPK","GLPK","warm_up","warm_up(glp_prob)

   \"Warms up\" the LP basis using current statuses assigned to rows
   and columns, i.e. computes factorization of the basis matrix (if it
   does not exist), computes primal and dual components of basic
   solution, and determines the solution status.

   返回 0 if successful, otherwise: \"GLPK.EBADB\" (invalid matrix),
   \"GLPK.ESING\" (singluar matrix), \"GLPK.ECOND\" (ill-conditioned
   matrix).

"),

("GLPK","GLPK","eval_tab_row","eval_tab_row(glp_prob, k, ind, val)
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

("GLPK","GLPK","eval_tab_col","eval_tab_col(glp_prob, k, ind, val)
eval_tab_col(glp_prob, k)

   Computes a column of the current simplex tableau which corresponds
   to some non-basic variable specified by the parameter \"k\". See
   \"eval_tab_row\".

"),

("GLPK","GLPK","transform_row","transform_row(glp_prob[, len], ind, val)

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

("GLPK","GLPK","transform_col","transform_col(glp_prob[, len], ind, val)

   Performs the same operation as \"eval_tab_col\" with the exception
   that the row to be transformed is specified explicitly as a sparse
   vector. See \"transform_row\".

"),

("GLPK","GLPK","prim_rtest","prim_rtest(glp_prob[, len], ind, val, dir, eps)

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

("GLPK","GLPK","dual_rtest","dual_rtest(glp_prob[, len], ind, val, dir, eps)

   Performs the dual ratio test using an explicitly specified row of
   the simplex table. The current basic solution must be dual
   feasible. The indices in \"ind\" must correspond to non-basic
   variables. Everything else is like in \"prim_rtest\".

"),

("GLPK","GLPK","analyze_bound","analyze_bound(glp_prob, k)

   Analyzes the effect of varying the active bound of specified non-
   basic variable. See the GLPK manual for a detailed explanation. In
   Julia, this function has a different API then C. It returns
   \"(limit1, var1, limit2, var2)\" rather then taking them as
   pointers in the argument list.

"),

("GLPK","GLPK","analyze_coef","analyze_coef(glp_prob, k)

   Analyzes the effect of varying the objective coefficient at
   specified basic variable. See the GLPK manual for a detailed
   explanation. In Julia, this function has a different API then C. It
   returns \"(coef1, var1, value1, coef2, var2, value2)\" rather then
   taking them as pointers in the argument list.

"),

("GLPK","GLPK","init_env","init_env()

   Initializes the GLPK environment. Not normally needed.

   返回 0 (initilization successful), 1 (environment already
   initialized), 2 (failed, insufficient memory) or 3 (failed,
   unsupported programming model).

"),

("GLPK","GLPK","version","version()

   返回the GLPK version number. In Julia, instead of returning a string
   as in C, it returns a tuple of integer values, containing the major
   and the minor number.

"),

("GLPK","GLPK","free_env","free_env()

   Frees all resources used by GLPK routines (memory blocks, etc.)
   which are currently still in use. Not normally needed.

   返回 0 if successful, 1 if envirnoment is inactive.

"),

("GLPK","GLPK","term_out","term_out(flag)

   Enables/disables the terminal output of glpk routines. \"flag\" is
   either \"GLPK.ON\" (output enabled) or \"GLPK.OFF\" (output
   disabled).

   返回the previous status of the terminal output.

"),

("GLPK","GLPK","open_tee","open_tee(filename)

   Starts copying all the terminal output to an output text file.

   返回 0 if successful, 1 if already active, 2 if it fails creating the
   output file.

"),

("GLPK","GLPK","close_tee","close_tee()

   Stops copying the terminal output to the output text file
   previously open by the \"open_tee\".

   返回 0 if successful, 1 if copying terminal output was not started.

"),

("GLPK","GLPK","malloc","malloc(size)

   Replacement of standard C \"malloc\". Allocates uninitialized
   memeory which must freed with \"free\".

   返回a pointer to the allocated memory.

"),

("GLPK","GLPK","calloc","calloc(n, size)

   Replacement of standard C \"calloc\", but does not initialize the
   memeory. Allocates uninitialized memeory which must freed with
   \"free\".

   返回a pointer to the allocated memory.

"),

("GLPK","GLPK","free","free(ptr)

   Deallocates a memory block previously allocated by \"malloc\" or
   \"calloc\".

"),

("GLPK","GLPK","mem_usage","mem_usage()

   Reports some information about utilization of the memory by the
   routines \"malloc\", \"calloc\", and \"free\". In Julia, this
   function has a different API then C. It returns \"(count, cpeak,
   total, tpeak)\" rather then taking them as pointers in the argument
   list.

"),

("GLPK","GLPK","mem_limit","mem_limit(limit)

   Limits the amount of memory avaliable for dynamic allocation to a
   value in megabyes given by the integer parameter \"limit\".

"),

("GLPK","GLPK","time","time()

   返回the current universal time (UTC), in milliseconds.

"),

("GLPK","GLPK","difftime","difftime(t1, t0)

   返回the difference between two time values \"t1\" and \"t0\",
   expressed in seconds.

"),

("GLPK","GLPK","sdf_open_file","sdf_open_file(filename)

   Opens a plain data file.

   If successful, returns a \"GLPK.Data\" object, otherwise throws an
   error.

"),

("GLPK","GLPK","sdf_read_int","sdf_read_int(glp_data)

   Reads an integer number from the plain data file specified by the
   \"GLPK.Data\" parameter \"glp_data\", skipping initial whitespace.

"),

("GLPK","GLPK","sdf_read_num","sdf_read_num(glp_data)

   Reads a floating point number from the plain data file specified by
   the \"GLPK.Data\" parameter \"glp_data\", skipping initial
   whitespace.

"),

("GLPK","GLPK","sdf_read_item","sdf_read_item(glp_data)

   Reads a data item (a String) from the plain data file specified by
   the \"GLPK.Data\" parameter \"glp_data\", skipping initial
   whitespace.

"),

("GLPK","GLPK","sdf_read_text","sdf_read_text(glp_data)

   Reads a line of text from the plain data file specified by the
   \"GLPK.Data\" parameter \"glp_data\", skipping initial and final
   whitespace.

"),

("GLPK","GLPK","sdf_line","sdf_line(glp_data)

   返回the current line in the \"GLPK.Data\" object \"glp_data\"

"),

("GLPK","GLPK","sdf_close_file","sdf_close_file(glp_data)

   Closes the file associated to \"glp_data\" and frees the resources.

"),

("GLPK","GLPK","read_cnfsat","read_cnfsat(glp_prob, filename)

   Reads the CNF-SAT problem data in DIMACS format from a text file.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","check_cnfsat","check_cnfsat(glp_prob)

   Checks if the problem object encodes a CNF-SAT problem instance, in
   which case it returns 0, otherwise returns non-zero.

"),

("GLPK","GLPK","write_cnfsat","write_cnfsat(glp_prob, filename)

   Writes the CNF-SAT problem data in DIMACS format into a text file.

   返回 0 upon success; throws an error in case of failure.

"),

("GLPK","GLPK","minisat1","minisat1(glp_prob)

   The routine \"minisat1\" is a driver to MiniSat, a CNF-SAT solver
   developed by Niklas Eén and Niklas Sörensson, Chalmers University
   of Technology, Sweden.

   返回 0 in case of success, or a non-zero flag specifying the reason
   for failure: \"GLPK.EDATA\" (problem is not CNF-SAT),
   \"GLPK.EFAIL\" (solver failure).

"),

("GLPK","GLPK","intfeas1","intfeas1(glp_prob, use_bound, obj_bound)

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

("GZip","GZip","gzopen","gzopen(fname[, gzmode[, buf_size]])

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

("GZip","GZip","gzdopen","gzdopen(fd[, gzmode[, buf_size]])

   Create a \"GZipStream\" object from an integer file descriptor. See
   \"gzopen()\" for \"gzmode\" and \"buf_size\" descriptions.

"),

("GZip","GZip","gzdopen","gzdopen(s[, gzmode[, buf_size]])

   Create a \"GZipStream\" object from \"IOStream\" \"s\".

"),

("GZip","GZip","GZipStream","type GZipStream(name, gz_file[, buf_size[, fd[, s]]])

   Subtype of \"IO\" which wraps a gzip stream.  Returned by
   \"gzopen()\" and \"gzdopen()\".

"),

("GZip","GZip","GZError","type GZError(err, err_str)

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


("OptionsMod","OptionsMod","@options","@options([check_flag], assignments...)

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

   如果不想使用宏语法，也可以写成如下这样：

      opts = Options(CheckWarn, :a, 5, :b, 2)

   The check flag is optional.

"),

("OptionsMod","OptionsMod","@set_options","@set_options(opts, assigments...)

   The \"@set_options\" macro lets you add new parameters to an
   existing options structure.  For example:

      @set_options opts d=99

   would add \"d\" to the set of parameters in \"opts\", or re-set its
   value if it was already supplied.

"),

("OptionsMod","OptionsMod","@defaults","@defaults(opts, assignments...)

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

("OptionsMod","OptionsMod","@check_used","@check_used(opts)

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

("OptionsMod","OptionsMod","Options","type Options(OptionsChecking, param1, val1, param2, val2, ...)

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

("profile.jl","","@profile","@profile()

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

("Base.Sort","Base.Sort","sort","sort(v[, alg[, ord]])

   按升序对向量排序。 \"alg\" 为特定的排序算法（ \"Sort.InsertionSort\",
   \"Sort.QuickSort\", \"Sort.MergeSort\", 或 \"Sort.TimSort\" ），
   \"ord\" 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

"),

("Base.Sort","Base.Sort","sort!","sort!(...)

   原地排序。

"),

("Base.Sort","Base.Sort","sortby","sortby(v, by[, alg])

   根据 \"by(v)\" 对向量排序。 \"alg\" 为特定的排序算法（ \"Sort.InsertionSort\",
   \"Sort.QuickSort\", \"Sort.MergeSort\", 或 \"Sort.TimSort\" ）。

"),

("Base.Sort","Base.Sort","sortby!","sortby!(...)

   \"sortby\" 的原地版本

"),

("Base.Sort","Base.Sort","sortperm","sortperm(v[, alg[, ord]])

   返回排序向量，可用它对输入向量 \"v\" 进行排序。 \"alg\" 为特定的排序算法（
   \"Sort.InsertionSort\", \"Sort.QuickSort\", \"Sort.MergeSort\", 或
   \"Sort.TimSort\" ）， \"ord\" 为自定义的排序顺序（如 Sort.Reverse 或一个比较函数）。

"),

("Base.Sort","Base.Sort","issorted","issorted(v[, ord])

   判断向量是否为已经为升序排列。 \"ord\" 为自定义的排序顺序。

"),

("Base.Sort","Base.Sort","searchsorted","searchsorted(a, x[, ord])

   返回 \"a\" 中排序顺序不小于 \"x\" 的第一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

   \"searchsortedfirst()\" 的别名

"),

("Base.Sort","Base.Sort","searchsortedfirst","searchsortedfirst(a, x[, ord])

   返回 \"a\" 中排序顺序不小于 \"x\" 的第一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

("Base.Sort","Base.Sort","searchsortedlast","searchsortedlast(a, x[, ord])

   返回 \"a\" 中排序顺序不大于 \"x\" 的最后一个值的索引值， \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

("Base.Sort","Base.Sort","select","select(v, k[, ord])

   找到排序好的向量 \"v\" 中第 \"k\" 个位置的元素，在未排序时的索引值。 \"ord\" 为自定义的排序顺序（默认为
   \"Sort.Forward\" ）。

"),

("Base.Sort","Base.Sort","select!","select!(v, k[, ord])

   \"select\" 的原地版本

"),

("Sound","Sound","wavread","wavread(io[, options])

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

("Sound","Sound","wavwrite","wavwrite(samples, io[, options])

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

("TextWrap","TextWrap","wrap","wrap(string[, options])

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

("TextWrap","TextWrap","println_wrapped","print_wrapped(text...[, options])
print_wrapped(io, text...[, options])
println_wrapped(text...[, options])
println_wrapped(io, text...[, options])

   These are just like the standard \"print()\" and \"println()\"
   functions (they print multiple arguments and accept an optional
   \"IO\" first argument), except that they wrap the result, and
   accept an optional last argument with the options to pass to
   \"wrap()\".

"),

("Zlib","Zlib","compress_bound","compress_bound(input_size)

   返回the maximum size of the compressed output buffer for a given
   uncompressed input size.

"),

("Zlib","Zlib","compress","compress(source[, level])

   Compresses source using the given compression level, and returns
   the compressed buffer (\"Array{Uint8,1}\").  \"level\" is an
   integer between 0 and 9, or one of \"Z_NO_COMPRESSION\",
   \"Z_BEST_SPEED\", \"Z_BEST_COMPRESSION\", or
   \"Z_DEFAULT_COMPRESSION\".  It defaults to
   \"Z_DEFAULT_COMPRESSION\".

   If an error occurs, \"compress\" throws a \"ZError\" with more
   information about the error.

"),

("Zlib","Zlib","compress_to_buffer","compress_to_buffer(source, dest, level=Z_DEFAULT_COMPRESSION)

   Compresses the source buffer into the destination buffer, and
   returns the number of bytes written into dest.

   If an error occurs, \"uncompress\" throws a \"ZError\" with more
   information about the error.

"),

("Zlib","Zlib","uncompress","uncompress(source[, uncompressed_size])

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

("Zlib","Zlib","uncompress_to_buffer","uncompress_to_buffer(source, dest)

   Uncompresses the source buffer into the destination buffer. 返回the
   number of bytes written into dest.  An error is thrown if the
   destination buffer does not have enough space.

   If an error occurs, \"uncompress_to_buffer\" throws a \"ZError\"
   with more information about the error.

"),


}
