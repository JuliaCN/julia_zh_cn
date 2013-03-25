# automatically generated -- do not edit

{

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
   查找文件，并只载入一次。\"require\" 是顶层操作，因此它设置当前的 \"include\"
   路径，但并不使用它来查找文件（详见 \"include\" ）。此函数常用来载入库代码； \"using\"
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

   正常情况都不必这么做：自定义类型可通过定义特殊版本的 \"deepcopy_internal(x::T,
   dict::ObjectIdDict)\" 函数（此函数其它情况下不应使用）来覆盖默认的 \"deepcopy\" 行为，其中
   \"T\" 是要指明的类型， \"dict\" 记录迄今为止递归中复制的对象。在定义中， \"deepcopy_internal\"
   应当用来代替 \"deepcopy\" ， \"dict\" 变量应当在返回前正确的更新。

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

("迭代","Base","enumerate","enumerate(iter)

   返回生成 \"(i, x)\" 的迭代器，其中 \"i\" 是从 1 开始的索引， \"x\" 是指定迭代器的第 \"i\" 个值。

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

   取回集合中存储在指定键或索引值内的值。语法 \"a[i,j,...]\" 由编译器转换为 \"getindex(a, i, j,
   ...)\" 。

"),

("可索引集合","Base","setindex!","setindex!(collection, value, key...)

   将指定值存储在集合的指定键或索引值内。语法 \"a[i,j,...] = x\" 由编译器转换为 \"setindex!(a, x,
   i, j, ...)\" 。

"),

("关联性集合","Base","Dict{K,V}","Dict{K,V}()

   使用 K 类型的键和 V 类型的值来构造哈希表。

"),

("关联性集合","Base","has","has(collection, key)

   判断集合是否含有指定键的映射。

"),

("关联性集合","Base","get","get(collection, key, default)

   返回指定键存储的值；当前没有键的映射时，返回默认值。

"),

("关联性集合","Base","getkey","getkey(collection, key, default)

   如果参数 \"key\" 匹配 \"collection\" 中的键，将其返回；否在返回 \"default\" 。

"),

("关联性集合","Base","delete!","delete!(collection, key)

   删除集合中指定键的映射，返回被删的键的值。

"),

("关联性集合","Base","keys","keys(collection)

   返回集合中所有键组成的数组。

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

   向集合逐个添加 \"iterable\" 中的元素。

"),

("类集集合","Base","Set","Set(x...)

   使用指定元素来构造 \"Set\" 。构造稀疏整数集时应使用此函数，而非 \"IntSet\" 。

"),

("类集集合","Base","IntSet","IntSet(i...)

   使用指定元素来构造 \"IntSet\" 。它是由位字符串实现的，因而适合构造稠密整数集。

"),

("类集集合","Base","union","union(s1, s2...)

   构造两个及两个以上集的共用体。保持原数组中的顺序。

"),

("类集集合","Base","union!","union!(s1, s2)

   构造 \"IntSet\" s1 和 s2 的共用体，将结果保存在 \"s1\" 中。

"),

("类集集合","Base","intersect","intersect(s1, s2...)

   构造两个及两个以上集的交集。保持原数组中的顺序。

"),

("类集集合","Base","setdiff","setdiff(s1, s2)

   使用存在于 \"s1\" 且不在 \"s2\" 的元素来构造集合。保持原数组中的顺序。

"),

("类集集合","Base","symdiff","symdiff(s1, s2...)

   构造由集合或数组中不同的元素构成的集。保持原数组中的顺序。

"),

("类集集合","Base","symdiff!","symdiff!(s, n)

   向 \"IntSet\" s 中插入整数元素 \"n\" 。

"),

("类集集合","Base","symdiff!","symdiff!(s, itr)

   向 set s 中插入 \"itr\" 中的元素。

"),

("类集集合","Base","symdiff!","symdiff!(s1, s2)

   构造由 \"IntSets\" 类型的 \"s1\" 和 \"s2\" 中不同的元素构成的集，结果保存在 \"s1\" 中。

"),

("类集集合","Base","complement","complement(s)

   返回 \"IntSet\" s 的补集。

"),

("类集集合","Base","complement!","complement!(s)

   将 \"IntSet\" s 转换为它的补集。

"),

("类集集合","Base","del_each!","del_each!(s, itr)

   在原地将集合 s 中 itr 的元素删除。

"),

("类集集合","Base","intersect!","intersect!(s1, s2)

   构造 *Inset* s1 和 s2 的交集，并将结果覆写到 s1 。s1 根据需要来决定是否扩展到 s2 的大小。

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

   移除指定索引值处的项，返回删除项。

"),

("双端队列","Base","delete!","delete!(collection, range) -> items

   移除指定范围内的项，返回包含删除项的集合。

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

("字符串","Base","*","*(s, t)

   连接字符串。

   **例子** ： \"\"Hello \" * \"world\" == \"Hello world\"\"

"),

("字符串","Base","^","^(s, n)

   将字符串 \"s\" 重复 \"n\" 次。

   **例子** ： \"\"Julia \"^3 == \"Julia Julia Julia \"\"

"),

("字符串","Base","string","string(xs...)

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

   如果字符串或字节向量是有效的 ASCII ，返回真；否则返回假。

"),

("字符串","Base","is_valid_utf8","is_valid_utf8(s) -> Bool

   如果字符串或字节向量是有效的 UTF-8 ，返回真；否则返回假。

"),

("字符串","Base","is_valid_char","is_valid_char(c) -> Bool

   如果指定的字符或整数是有效的 Unicode 码位，则返回真。

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
   次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。如果 \"r\" 为函数，替换后的结果为 \"r(s)\"
   ，其中 \"s\" 是匹配的子字符串。

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

   给出需要多少列来打印此字符。

"),

("字符串","Base","strwidth","strwidth(s)

   给出需要多少列来打印此字符串。

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

("I/O","Base","OUTPUT_STREAM","OUTPUT_STREAM

   用于文本输出的默认流，如在 \"print\" 和 \"show\" 函数中的流。

"),

("I/O","Base","open","open(file_name[, read, write, create, truncate, append]) -> IOStream

   按五个布尔值参数指明的模式打开文件。默认以只读模式打开文件。返回操作文件的流。

"),

("I/O","Base","open","open(file_name[, mode]) -> IOStream

   另一种打开文件的语法，它使用字符串样式的标识符：

   +------+-----------------------------------+
   | r    | 读（默认）                             |
   +------+-----------------------------------+
   | r+   | 读、写                               |
   +------+-----------------------------------+
   | w    | 写、新建、清空重写                         |
   +------+-----------------------------------+
   | w+   | 读写、新建、清空重写                        |
   +------+-----------------------------------+
   | a    | 写、新建、追加                           |
   +------+-----------------------------------+
   | a+   | 读、写、新建、追加                         |
   +------+-----------------------------------+

"),

("I/O","Base","open","open(f::function, args...)

   将函数 \"f\" 映射到 \"open(args...)\" 的返回值上，完成后关闭文件描述符。

   **例子** ： \"open(readall, \"file.txt\")\"

"),

("I/O","Base","memio","memio([size[, finalize::Bool]]) -> IOStream

   构造内存中 I/O 流，可选择性指明需要多少初始化空间。

"),

("I/O","Base","fdio","fdio([name::String], fd::Integer[, own::Bool]) -> IOStream

   用整数文件描述符构造 \"IOStream\" 对象。如果 \"own\" 为真，关闭对象时会关闭底层的描述符。默认垃圾回收时
   \"IOStream\" 是关闭的。 \"name\" 用文件描述符关联已命名的文件。

"),

("I/O","Base","flush","flush(stream)

   将当前所有的缓冲写入指定流。

"),

("I/O","Base","close","close(stream)

   关闭 I/O 流。它将在关闭前先做一次 \"flush\" 。

"),

("I/O","Base","write","write(stream, x)

   将值的标准二进制表示写入指定流。

"),

("I/O","Base","read","read(stream, type)

   从标准二进制表示的流中读出指定类型的值。

"),

("I/O","Base","read","read(stream, type, dims)

   从标准二进制表示的流中读出指定类型的一组值。 \"dims\" 可以是整数参数的多元组或集合，它指明要返还 \"Array\"
   的大小。

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

   相对于当前位置定位流。

"),

("I/O","Base","eof","eof(stream)

   判断 I/O 流是否到达文件尾。如果流还没被耗尽，函数会阻塞并继续等待数据，然后返回 \"false\" 。因此当 \"eof\"
   返回 \"false\" 后，可以很安全地读取一个字节。

"),

("文本 I/O","Base","show","show(x)

   向当前输出流写入值的信息型文本表示。新构造的类型应重载 \"show(io, x)\" ，其中 \"io\" 为流。

"),

("文本 I/O","Base","print","print(x)

   如果值有标准（未修饰）的文本表示，则将其写入默认输出流；否则调用 \"show\" 。

"),

("文本 I/O","Base","println","println(x)

   使用 \"print()\" 打印 \"x\" ，并接一个换行符。

"),

("文本 I/O","Base","@printf","@printf([io::IOStream], \"%Fmt\", args...)

   使用 C 中 \"printf()\" 的样式来打印。第一个参数可选择性指明 IOStream 来重定向输出。

"),

("文本 I/O","Base","@sprintf","@sprintf(\"%Fmt\", args...)

   按 \"@printf\" 的样式输出为字符串。

"),

("文本 I/O","Base","showall","showall(x)

   打印数组的所有元素。

"),

("文本 I/O","Base","dump","dump(x)

   向当前输出流写入值的完整文本表示。

"),

("文本 I/O","Base","readall","readall(stream)

   按照字符串读取 I/O 流的所有内容。

"),

("文本 I/O","Base","readline","readline(stream)

   读取一行文本，包括末尾的换行符（不管输入是否结束，遇到换行符就返回）。

"),

("文本 I/O","Base","readuntil","readuntil(stream, delim)

   读取字符串，直到指定的分隔符为止。字符串包括此分隔符。

"),

("文本 I/O","Base","readlines","readlines(stream)

   将读入的所有行返回为数组。

"),

("文本 I/O","Base","eachline","eachline(stream)

   构造可迭代对象，它从流中生成每一行文本。

"),

("文本 I/O","Base","readdlm","readdlm(filename, delim::Char)

   从文本文件中读取矩阵，文本中的每一行是矩阵的行，元素由指定的分隔符隔开。如果所有的数据都是数值，结果为数值矩阵。如果有些元素不能被解析
   为数，将返回由数和字符串构成的元胞数组。

"),

("文本 I/O","Base","readdlm","readdlm(filename, delim::Char, T::Type)

   从文本文件中读取指定元素类型的矩阵。如果 \"T\" 是数值类型，结果为此类型的数组：若为浮点数类型，非数值的元素变为 \"NaN\"
   ；其余类型为 0 。 \"T\" 的类型还有 \"ASCIIString\", \"String\", 和 \"Any\" 。

"),

("文本 I/O","Base","writedlm","writedlm(filename, array, delim::Char)

   使用指定的分隔符（默认为逗号）将数组写入到文本文件。

"),

("文本 I/O","Base","readcsv","readcsv(filename[, T::Type])

   等价于 \"delim\" 为逗号的 \"readdlm\" 函数。

"),

("文本 I/O","Base","writecsv","writecsv(filename, array)

   等价于 \"delim\" 为逗号的 \"writedlm\" 函数。

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

("数学函数","Base",".+",".+(x, y)

   逐元素二元加运算符。

"),

("数学函数","Base",".-",".-(x, y)

   逐元素二元减运算符。

"),

("数学函数","Base",".*",".*(x, y)

   逐元素二元乘运算符。

"),

("数学函数","Base","./","./(x, y)

   逐元素二元左除运算符。

"),

("数学函数","Base",".\\",".\\(x, y)

   逐元素二元右除运算符。

"),

("数学函数","Base",".^",".^(x, y)

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

("数学函数","Base",".==",".==(x, y)

   逐元素相等运算符。

"),

("数学函数","Base",".!=",".!=(x, y)

   逐元素不等运算符。

"),

("数学函数","Base",".<",".<(x, y)

   逐元素小于运算符。

"),

("数学函数","Base",".<=",".<=(x, y)

   逐元素小于等于运算符。

"),

("数学函数","Base",".>",".>(x, y)

   逐元素大于运算符。

"),

("数学函数","Base",".>=",".>=(x, y)

   逐元素大于等于运算符。

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

   \"round(x)\" 返回离 \"x\" 最近的整数。 \"round(x, digits)\" 若 \"digits\"
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

   计算 \"x\" 的缩放互补误差函数，其定义为 e^{x^2} \\operatorname{erfc}(x) 。注意
   \\operatorname{erfcx}(-ix) 即为 Faddeeva 函数 w(x) 。

"),

("数学函数","Base","erfi","erfi(x)

   计算 \"x\" 的虚误差函数，其定义为 -i \\operatorname{erf}(ix).

"),

("数学函数","Base","dawson","dawson(x)

   计算 \"x\" 的 Dawson 函数（缩放虚误差函数），其定义为 \\frac{\\sqrt{\\pi}}{2} e^{-x^2}
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

   对 \"n\" 分解质因数，返回一个字典。字典的键对应于质因数，与 \"n\"
   类型相同。每个键的值显示因式分解中这个质因数出现的次数。

   **例子** ： 100=2*2*5*5 ，因此 \"factor(100) -> [5=>2,2=>2]\"

"),

("数学函数","Base","gcd","gcd(x, y)

   最大公因数。

"),

("数学函数","Base","lcm","lcm(x, y)

   最小公倍数。

"),

("数学函数","Base","gcdx","gcdx(x, y)

   最大公因数，同时返回整数因子 \"u\" 和 \"v\" ，满足 \"u*x+v*y == gcd(x,y)\" 。

"),

("数学函数","Base","ispow2","ispow2(n)

   判断 \"n\" 是否为 2 的幂。

"),

("数学函数","Base","nextpow2","nextpow2(n)

   不小于 \"n\" 的值为 2 的幂的数。

"),

("数学函数","Base","prevpow2","prevpow2(n)

   不大于 \"n\" 的值为 2 的幂的数。

"),

("数学函数","Base","nextpow","nextpow(a, n)

   不小于 \"n\" 的值为 \"a\" 的幂的数。

"),

("数学函数","Base","prevpow","prevpow(a, n)

   不大于 \"n\" 的值为 \"a\" 的幂的数。

"),

("数学函数","Base","nextprod","nextprod([a, b, c], n)

   不小于 \"n\" 的数，存在整数 \"i1\", \"i2\", \"i3\" 使这个数等于 \"a^i1 * b^i2 *
   c^i3\" 。

"),

("数学函数","Base","prevprod","prevprod([a, b, c], n)

   不大于 \"n\" 的数，存在整数 \"i1\", \"i2\", \"i3\" 使这个数等于 \"a^i1 * b^i2 *
   c^i3\" 。

"),

("数学函数","Base","invmod","invmod(n, m)

   \"n``的关于模 ``m\" 的逆，即求满足 \"(x * n ) % m == 1\" 的数 \"x\" 。

"),

("数学函数","Base","powermod","powermod(x, p, m)

   计算 \"mod(x^p, m)\" 。

"),

("数学函数","Base","gamma","gamma(x)

   计算 \"x\" 的 gamma 函数。

"),

("数学函数","Base","lgamma","lgamma(x)

   计算 \"gamma(x)\" 的对数。

"),

("数学函数","Base","lfact","lfact(x)

   计算 \"x\" 阶乘的对数。

"),

("数学函数","Base","digamma","digamma(x)

   计算 \"x\" 的双伽玛函数（ \"gamma(x)\" 自然对数的导数）

"),

("数学函数","Base","airy","airy(x)

   艾里函数的 k 阶导数 \\operatorname{Ai}(x) 。

"),

("数学函数","Base","airyai","airyai(x)

   艾里函数 \\operatorname{Ai}(x) 。

"),

("数学函数","Base","airyprime","airyprime(x)

   艾里函数的导数 \\operatorname{Ai}'(x) 。

"),

("数学函数","Base","airyaiprime","airyaiprime(x)

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

   将两个整数散列为一个整数。用于构造哈希函数。

"),

("数学函数","Base","ndigits","ndigits(n, b)

   计算用 \"b\" 进制表示 \"n\" 时的位数。

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

("数据格式","Base","base","base(base, n[, pad])

   将整数 \"n\" 转换为指定进制 \"base\" 的字符串，可选择性指明空白补位后的位数。进制 \"base\"
   可以为整数，也可以是用于表征数字符号的字符值所对应的 \"Uint8\" 数组。

"),

("数据格式","Base","bits","bits(n)

   用二进制字符串文本表示一个数。

"),

("数据格式","Base","parse_int","parse_int(type, str[, base])

   将字符串解析为指定类型、指定进制（默认为 10 ）的整数。

"),

("数据格式","Base","parse_bin","parse_bin(type, str)

   将字符串解析为指定类型的二进制整数。

"),

("数据格式","Base","parse_oct","parse_oct(type, str)

   将字符串解析为指定类型的八进制整数。

"),

("数据格式","Base","parse_hex","parse_hex(type, str)

   将字符串解析为指定类型的十六进制整数。

"),

("数据格式","Base","parse_float","parse_float(type, str)

   将字符串解析为指定类型的十进制浮点数。

"),

("数据格式","Base","bool","bool(x)

   将数或数值数组转换为布尔值类型的。

"),

("数据格式","Base","isbool","isbool(x)

   判断数或数组是否是布尔值类型的。

"),

("数据格式","Base","int","int(x)

   将数或数组转换为所使用电脑上默认的整数类型。 \"x\" 也可以是字符串，使用此函数时会将其解析为整数。

"),

("数据格式","Base","uint","uint(x)

   将数或数组转换为所使用电脑上默认的无符号整数类型。 \"x\" 也可以是字符串，使用此函数时会将其解析为无符号整数。

"),

("数据格式","Base","integer","integer(x)

   将数或数组转换为整数类型。如果 \"x\" 已经是整数类型，则不处理；否则将其转换为所使用电脑上默认的整数类型。

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

   提取浮点数或浮点数组的二进制表示的有效数字。

   例如， \"significand(15.2)/15.2 == 0.125\" 与 \"significand(15.2)*8 ==
   15.2\" 。

"),

("数据格式","Base","exponent","exponent(x) -> Int

   返回浮点数 \"trunc( log2( abs(x) ) )\" 。

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

   给出将一个整数的字节翻转后所得的整数。

"),

("数据格式","Base","num2hex","num2hex(f)

   将浮点数的二进制表示转换为十六进制字符串。

"),

("数据格式","Base","hex2num","hex2num(str)

   将十六进制字符串转换为它所表示的浮点数。

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

("数","Base","im","im

   虚数单位。

"),

("数","Base","e","e

   常量 e 。

"),

("数","Base","Inf","Inf

   正无穷，类型为 Float64 。

"),

("数","Base","Inf32","Inf32

   正无穷，类型为 Float32 。

"),

("数","Base","NaN","NaN

   表示“它不是数”的值，类型为 Float64 。

"),

("数","Base","NaN32","NaN32

   表示“它不是数”的值，类型为 Float32 。

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

   使用 \"seed\" 为 RNG 的种子，可以是无符号整数或向量。 \"seed\"
   也可以是文件名，此时从文件中读取种子。如果省略参数 \"rng\" ，则默认为全局 RNG 。

"),

("随机数","Base","MersenneTwister","MersenneTwister([seed])

   构造一个 \"MersenneTwister\" RNG 对象。不同的 RNG
   对象可以有不同的种子，这对于生成不同的随机数流非常有用。

"),

("随机数","Base","rand","rand()

   生成 [0,1) 内均匀分布的 \"Float64\" 随机数。

"),

("随机数","Base","rand!","rand!([rng], A)

   向数组 \"A\" 中赋值由指定 RNG 生成的随机数。

"),

("随机数","Base","rand","rand(rng::AbstractRNG[, dims...])

   使用指定的 RNG 对象，生成 \"Float64\" 类型的随机数或数组。目前仅提供 \"MersenneTwister\"
   随机数生成器 RNG ，可由 \"srand\" 函数设置随机数种子。

"),

("随机数","Base","rand","rand(dims 或 [dims...])

   生成指定维度的 \"Float64\" 类型的随机数组。

"),

("随机数","Base","rand","rand(Int32|Uint32|Int64|Uint64|Int128|Uint128[, dims...])

   生成指定整数类型的随机数。若指定维度，则生成对应类型的随机数组。

"),

("随机数","Base","rand","rand(r[, dims...])

   从 \"Range1\" r 的范围中产生随机整数（如 \"1:n\" ，包括 1 和 n）。也可以生成随机整数数组。

"),

("随机数","Base","randbool","randbool([dims...])

   生成随机布尔值。若指定维度，则生成布尔值类型的随机数组。

"),

("随机数","Base","randbool!","randbool!(A)

   将数组中的元素赋值为随机布尔值。 \"A\" 可以是 \"Array\" 或 \"BitArray\" 。

"),

("随机数","Base","randn","randn(dims 或 [dims...])

   生成均值为 0 ，标准差为 1 的标准正态分布随机数。若指定维度，则生成标准正态分布的随机数组。

"),

("数组","Base","ndims","ndims(A) -> Integer

   返回 \"A\" 有几个维度。

"),

("数组","Base","size","size(A)

   返回 \"A\" 的维度多元组。

"),

("数组","Base","eltype","eltype(A)

   返回 \"A\" 中元素的类型。

"),

("数组","Base","length","length(A) -> Integer

   返回 \"A\" 中所有元素的个数。（它与 MATLAB 中的定义不同。）

"),

("数组","Base","nnz","nnz(A)

   数组 \"A\" 中非零元素的个数。可适用于稠密或稀疏数组。

"),

("数组","Base","scale!","scale!(A, k)

   原地将数组 \"A\" 的内容乘以 k 。

"),

("数组","Base","conj!","conj!(A)

   原地求数组的复数共轭。

"),

("数组","Base","stride","stride(A, k)

   返回维度 k 上相邻的两个元素在内存中的距离（单位为元素个数）

"),

("数组","Base","strides","strides(A)

   返回每个维度上内存距离的多元组。

"),

("数组","Base","Array","Array(type, dims)

   构造一个未初始化的稠密数组。 \"dims\" 可以是整数参数的多元组或集合。

"),

("数组","Base","getindex","getindex(type[, elements...])

   构造指定类型的一维数组。它常被 \"Type[]\" 语法调用。元素值可由 \"Type[a,b,c,...]\" 指明。

"),

("数组","Base","cell","cell(dims)

   构造未初始化的元胞数组（异构数组）。 \"dims\" 可以是整数参数的多元组或集合。

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

   构造与指定数组同样数据的新数组，但维度不同。特定类型数组的实现自动选择复制或共享数据。

"),

("数组","Base","similar","similar(array[, element_type, dims])

   构造与指定数组相同类型的未初始化数组。可选择性指定指定了元素类型和维度。 \"dims\" 参数可以是整数参数的多元组或集合。

"),

("数组","Base","reinterpret","reinterpret(type, A)

   构造与指定数组同样二进制数据的新数组，但为指定的元素类型。

"),

("数组","Base","eye","eye(n)

   \"n x n\" 单位矩阵。

"),

("数组","Base","eye","eye(m, n)

   \"m x n\" 单位矩阵。

"),

("数组","Base","linspace","linspace(start, stop, n)

   构造从 \"start\" 到 \"stop\" 的 \"n\" 个元素的向量，元素之间的步长为线性。

"),

("数组","Base","logspace","logspace(start, stop, n)

   构造从 \"10^start\" 到 \"10^stop\" 的 \"n\" 个元素的向量，元素之间的步长为对数。

"),

("数组","Base","bsxfun","bsxfun(fn, A, B[, C...])

   对两个或两个以上的数组使用二元函数 \"fn\" ，它会展开单态的维度。

"),

("数组","Base","getindex","getindex(A, ind)

   返回 \"ind\" 位置的数组 \"A\" 的子集，结果可能是 \"Int\", \"Range\", 或 \"Vector\" 。

"),

("数组","Base","sub","sub(A, ind)

   返回 \"SubArray\" ，它存储 \"A\" 和 \"ind\" ，但不立即计算。对 \"SubArray\" 调用
   \"getindex\" 时才计算。

"),

("数组","Base","slicedim","slicedim(A, d, i)

   返回 \"A\" 中维度 \"d\" 上索引值为 \"i\" 的所有数据。等价于 \"A[:,:,...,i,:,:,...]\"
   ，其中 \"i\" 在位置 \"d\" 上。

"),

("数组","Base","setindex!","setindex!(A, X, ind)

   在 \"ind\" 指定的 \"A\" 子集上存储 \"X\" 的值。

"),

("数组","Base","cat","cat(dim, A...)

   在指定维度上连接。

"),

("数组","Base","vcat","vcat(A...)

   在维度 1 上连接。

"),

("数组","Base","hcat","hcat(A...)

   在维度 2 上连接。

"),

("数组","Base","hvcat","hvcat(rows::(Int...), values...)

   在水平和垂直上连接。此函数用于块矩阵语法。第一个参数多元组指明每行要连接的参数个数。例如， \"[a b;c d e]\" 调用
   \"hvcat((2,3),a,b,c,d,e)\" 。

"),

("数组","Base","flipdim","flipdim(A, d)

   在维度 \"d\" 上翻转。

"),

("数组","Base","flipud","flipud(A)

   等价于 \"flipdim(A,1)\" 。

"),

("数组","Base","fliplr","fliplr(A)

   等价于 \"flipdim(A,2)\" 。

"),

("数组","Base","circshift","circshift(A, shifts)

   循环移位数组中的数据。第二个参数为每个维度上移位数值的向量。

"),

("数组","Base","find","find(A)

   返回数组 \"A\" 中非零值的线性索引值向量。

"),

("数组","Base","findn","findn(A)

   返回数组 \"A\" 中每个维度上非零值的索引值向量。

"),

("数组","Base","nonzeros","nonzeros(A)

   返回数组 \"A\" 中非零值的向量。

"),

("数组","Base","findfirst","findfirst(A)

   返回数组 \"A\" 中第一个非零值的索引值。

"),

("数组","Base","findfirst","findfirst(A, v)

   返回数组 \"A\" 中第一个等于 \"v\" 的元素的索引值。

"),

("数组","Base","findfirst","findfirst(predicate, A)

   返回数组 \"A\" 中第一个满足指定断言的元素的索引值。

"),

("数组","Base","permutedims","permutedims(A, perm)

   重新排列数组 \"A\" 的维度。 \"perm\" 为长度为 \"ndims(A)\"
   的向量，它指明如何排列。此函数是多维数组的广义转置。转置等价于 \"permute(A,[2,1])\" 。

"),

("数组","Base","ipermutedims","ipermutedims(A, perm)

   类似 \"permutedims()\" ，但它使用指定排列的逆排列。

"),

("数组","Base","squeeze","squeeze(A, dims)

   移除 \"A\" 中 \"dims\" 指定的维度。此维度大小应为 1 。

"),

("数组","Base","vec","vec(Array) -> Vector

   以列序为主序将数组向量化。

"),

("数组","Base","cumprod","cumprod(A[, dim])

   沿某个维度的累积乘法。

"),

("数组","Base","cumsum","cumsum(A[, dim])

   沿某个维度的累积加法。

"),

("数组","Base","cumsum_kbn","cumsum_kbn(A[, dim])

   沿某个维度的累积加法。使用 Kahan-Babuska-Neumaier 的加法补偿算法来提高精度。

"),

("数组","Base","cummin","cummin(A[, dim])

   沿某个维度的累积最小值。

"),

("数组","Base","cummax","cummax(A[, dim])

   沿某个维度的累积最大值。

"),

("数组","Base","diff","diff(A[, dim])

   沿某个维度的差值（第 2 个减去第 1 个，... ，第 n 个减去第 n-1 个）。

"),

("数组","Base","rot180","rot180(A)

   将矩阵 \"A\" 旋转 180 度。

"),

("数组","Base","rotl90","rotl90(A)

   将矩阵 \"A\" 向左旋转 90 度。

"),

("数组","Base","rotr90","rotr90(A)

   将矩阵 \"A\" 向右旋转 90 度。

"),

("数组","Base","reducedim","reducedim(f, A, dims, initial)

   沿 \"A\" 的某个维度使用 \"f\" 函数进行约简。 \"dims\" 指明了约简的维度， \"initial\"
   为约简的初始值。

"),

("数组","Base","mapslices","mapslices(f, A, dims)

   在 \"A\" 的指定维度上应用函数 \"f\" 。  \"A\" 的每个切片 \"A[...,:,...,:,...]\"
   上都调用函数 \"f\" 。整数向量 \"dims\" 指明了维度信息。结果将沿着未指明的维度进行连接。例如，如果 \"dims\"
   为 \"[1,2]\" ， \"A\" 是四维数组，此函数将对每个 \"i\" 和 \"`j` 调用 ``f\" 处理
   \"A[:,:,i,j]\" 。

"),

("数组","Base","sum_kbn","sum_kbn(A)

   返回数组中所有元素的总和。使用 Kahan-Babuska-Neumaier 的加法补偿算法来提高精度。

"),

("排列组合","Base","nthperm","nthperm(v, k)

   按字典顺序返回向量的第 k 种排列。

"),

("排列组合","Base","nthperm!","nthperm!(v, k)

   \"nthperm()\" 的原地版本。

"),

("排列组合","Base","randperm","randperm(n)

   构造指定长度的随机排列。

"),

("排列组合","Base","invperm","invperm(v)

   返回 v 的逆排列。

"),

("排列组合","Base","isperm","isperm(v) -> Bool

   如果 v 是有效排列，则返回 \"true\" 。

"),

("排列组合","Base","permute!","permute!(v, p)

   根据排列 \"p\" 对向量 \"v\" 进行原地排列。此函数不验证 \"p\" 是否为排列。

   使用 \"v[p]\" 返回新排列。对于大向量，它通常比 \"permute!(v,p)\" 快。

"),

("排列组合","Base","ipermute!","ipermute!(v, p)

   类似 permute! ，但它使用指定排列的逆排列。

"),

("排列组合","Base","randcycle","randcycle(n)

   构造指定长度的随机循环排列。

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

   从指定数组生成 \"n\" 个元素的所有组合。由于组合的个数很多，这个函数应在 Task 内部使用。写成 \"c = @task
   combinations(a,n)\" 的形式，然后迭代 \"c\" 或对其调用 \"consume\" 。

"),

("排列组合","Base","integer_partitions","integer_partitions(n, m)

   生成由 \"m\" 个整数加起来等于 \"n\" 的所有数组。由于组合的个数很多，这个函数应在 Task 内部使用。写成 \"c =
   @task integer_partitions(n,m)\" 的形式，然后迭代 \"c\" 或对其调用 \"consume\" 。

"),

("排列组合","Base","partitions","partitions(array)

   生成数组中元素所有可能的组合，表示为数组的数组。由于组合的个数很多，这个函数应在 Task 内部使用。写成 \"c = @task
   partitions(a)\" 的形式，然后迭代 \"c\" 或对其调用 \"consume\" 。

"),

("统计","Base","mean","mean(v[, region])

   计算整个数组 \"v\" 的均值，或按 \"region\" 中列出的维度计算（可选）。

"),

("统计","Base","std","std(v[, region])

   计算向量或数组 \"v\" 的样本标准差，可选择按 \"region\" 中列出的维度计算。算法在 \"v\"
   中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布标准差的估计。它等价于 \"sqrt(sum((v -
   mean(v)).^2) / (length(v) - 1))\" 。

"),

("统计","Base","stdm","stdm(v, m)

   计算已知均值为 \"m\" 的向量 \"v\" 的样本标准差。

"),

("统计","Base","var","var(v[, region])

   计算向量或数组 \"v\" 的样本方差，可选择按 \"region\" 中列出的维度计算。算法在 \"v\"
   中的每个元素都是从某个生成分布中独立同分布地取得的假设下，返回一个此生成分布方差的估计。它等价于 \"sum((v -
   mean(v)).^2) / (length(v) - 1)\" 。

"),

("统计","Base","varm","varm(v, m)

   计算已知均值为 \"m\" 的向量 \"v\" 的样本方差。

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

("统计","Base","cov","cov(v1[, v2])

   计算两个向量 \"v1\" 和 \"v2\" 的协方差。如果调用时只有 \"v\" 这一个参数，它计算 \"v\" 中列的协方差。

"),

("统计","Base","cor","cor(v1[, v2])

   计算两个向量 \"v1\" 和 \"v2\" 的 Pearson 相关系数。如果调用时只有 \"v\" 这一个参数，它计算 \"v\"
   中列的相关系数。

"),

("信号处理","Base","fft","fft(A[, dims])

   对数组 \"A\" 做多维 FFT 。可选参数 \"dims\" 指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。如果
   \"A\" 要运算的维度上的长度是较小的质数的积，算法会比较高效；详见 \"nextprod()\" 。另见高效的
   \"plan_fft()\" 。

   一维 FFT 计算一维离散傅里叶变换（DFT），其定义为 \\operatorname{DFT}[k] =
   \\sum_{n=1}^{\\operatorname{length}(A)} \\exp\\left(-i\\frac{2\\pi
   (n-1)(k-1)}{\\operatorname{length}(A)} \\right) A[n] 。多维 FFT 对
   \"A\" 的多个维度做此运算。

"),

("信号处理","Base","fft!","fft!(A[, dims])

   与 \"fft()\" 类似，但在原地对 \"A\" 运算， \"A\" 必须是复数浮点数数组。

"),

("信号处理","Base","ifft","ifft(A[, dims])

   多维 IFFT 。

   一维反向 FFT 计算 \\operatorname{BDFT}[k] =
   \\sum_{n=1}^{\\operatorname{length}(A)} \\exp\\left(+i\\frac{2\\pi
   (n-1)(k-1)}{\\operatorname{length}(A)} \\right) A[n] 。多维反向 FFT 对
   \"A\" 的多个维度做此运算。IFFT 将其结果除以所运算的维度大小的积。

"),

("信号处理","Base","ifft!","ifft!(A[, dims])

   与 \"ifft()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","bfft","bfft(A[, dims])

   类似 \"ifft()\" ，但计算非归一化的（即反向）变换，它的结果需要除以所运算的维度大小的积，才是 IFFT 的结果。（它比
   \"ifft()\" 稍微高效一点儿，因为它省略了归一化的步骤；有时归一化的步骤可以与其它地方的其它计算合并在一起做。）

"),

("信号处理","Base","bfft!","bfft!(A[, dims])

   与 \"bfft()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_fft","plan_fft(A[, dims[, flags[, timelimit]]])

   在数组 \"A\" 的指定维度上（ \"dims\" ）制定优化 FFT 的方案。（前两个参数的意义参见 \"fft()\"
   。）返回可快速计算 \"fft(A, dims)\" 的函数。

   \"flags\" 参数时按位或的 FFTW 方案标志位，默认为 \"FFTW.ESTIMATE\" 。如果使用
   \"FFTW.MEASURE\" 或 \"FFTW.PATIENT\" 会先花几秒钟（或更久）来对不同的 FFT
   算法进行分析，选取最快的。有关方案标志位，详见 FFTW 手册。可选参数 \"timelimit\"
   指明制定方案时间的粗略上界，单位为秒。如果使用 \"FFTW.MEASURE\" 或 \"FFTW.PATIENT\"
   会在制定方案时覆写输入数组 \"A\" 。

   \"plan_fft!()\" 与 \"plan_fft()\" 类似，但它在参数的原地制定方案（参数应为复浮点数数组）。
   \"plan_ifft()\" 等类似，但它们指定逆变换  \"ifft()\"  等的方案。

"),

("信号处理","Base","plan_ifft","plan_ifft(A[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 类似，但产生逆变换 \"ifft()\" 的方案。

"),

("信号处理","Base","plan_bfft","plan_bfft(A[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 类似，但产生反向变换 \"bfft()\" 的方案。

"),

("信号处理","Base","plan_fft!","plan_fft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_ifft!","plan_ifft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_ifft()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_bfft!","plan_bfft!(A[, dims[, flags[, timelimit]]])

   与 \"plan_bfft()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","rfft","rfft(A[, dims])

   对实数数组 \"A\" 做多维 FFT 。由于转换具有共轭对称性，相比 \"fft()\" ，可节约将近一半的计算时间和存储空间。如果
   \"A\" 的大小为 \"(n_1, ..., n_d)\" ，结果的大小为 \"(floor(n_1/2)+1, ...,
   n_d)\" 。

   与 \"fft()\" 类似，可选参数 \"dims\" 指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。但结果中
   \"dims[1]\" 维度大约只有一半。

"),

("信号处理","Base","irfft","irfft(A, d[, dims])

   对复数组 \"A\" 做 \"rfft()\": 的逆运算，它给出 FFT 后可生成 \"A\" 的对应的实数数组的前半部分。与
   \"rfft()\" 类似， \"dims\" 是可选项，默认为 \"1:ndims(A)\" 。

   \"d\" 是转换后的实数数组在 \"dims[1]\" 维度上的长度，必须满足 \"d ==
   floor(size(A,dims[1])/2)+1\" 。（此参数不能从 \"size(A)\" 推导出来，因为使用了
   \"floor\" 函数。）

"),

("信号处理","Base","brfft","brfft(A, d[, dims])

   与 \"irfft()\" 类似，但它计算非归一化逆变换（与 \"bfft()\"
   类似）。要得到逆变换，需将结果除以除以（实数输出矩阵）所运算的维度大小的积。

"),

("信号处理","Base","plan_rfft","plan_rfft(A[, dims[, flags[, timelimit]]])

   制定优化实数输入 FFT 的方案。与 \"plan_fft()\" 类似，但它对应于 \"rfft()\"
   。前两个参数及变换后的大小，都与 \"rfft()\" 相同。

"),

("信号处理","Base","plan_irfft","plan_irfft(A, d[, dims[, flags[, timelimit]]])

   制定优化实数输入 FFT 的方案。与 \"plan_rfft()\" 类似，但它对应于 \"irfft()\" 。前三个参数的意义与
   \"irfft()\" 相同。

"),

("信号处理","Base","plan_brfft","plan_brfft(A, d[, dims[, flags[, timelimit]]])

   制定优化实数输入 FFT 的方案。与 \"plan_rfft()\" 类似，但它对应于 \"brfft()\" 。前三个参数的意义与
   \"brfft()\" 相同。

"),

("信号处理","Base","dct","dct(A[, dims])

   对数组 \"A\" 做第二类离散余弦变换（DCT），使用归一化的 DCT 。与 \"fft()\" 类似，可选参数 \"dims\"
   指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。如果 \"A\" 要运算的维度上的长度是较小的质数的积，算法会比较高效；详见
   \"nextprod()\" 。另见高效的 \"plan_dct()\" 。

"),

("信号处理","Base","dct!","dct!(A[, dims])

   与 \"dct!()\" 类似，但在原地对 \"A\" 进行运算。 \"A\" 必须是实数或复数的浮点数数组。

"),

("信号处理","Base","idct","idct(A[, dims])

   对数组 \"A\" 做多维逆离散余弦变换（IDCT）（即归一化的第三类 DCT）。可选参数 \"dims\"
   指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。如果 \"A\" 要运算的维度上的长度是较小的质数的积，算法会比较高效；详见
   \"nextprod()\" 。另见高效的 \"plan_idct()\" 。

"),

("信号处理","Base","idct!","idct!(A[, dims])

   与 \"idct!()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_dct","plan_dct(A[, dims[, flags[, timelimit]]])

   制定优化 DCT 的方案。与 \"plan_fft()\" 类似，但对应于 \"dct()\" 。前两个参数的意义与
   \"dct()\" 相同。

"),

("信号处理","Base","plan_dct!","plan_dct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_dct()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","plan_idct","plan_idct(A[, dims[, flags[, timelimit]]])

   制定优化 IDCT 的方案。与 \"plan_fft()\" 类似，但对应于 \"idct()\" 。前两个参数的意义与
   \"idct()\" 相同。

"),

("信号处理","Base","plan_idct!","plan_idct!(A[, dims[, flags[, timelimit]]])

   与 \"plan_idct()\" 类似，但在原地对 \"A\" 进行运算。

"),

("信号处理","Base","FFTW","FFTW.r2r(A, kind[, dims])

   对数组 \"A\" 做种类为 \"kind\" 的多维实数输入实数输出（r2r）变换。 \"kind\" 指明各类离散余弦变换 （
   \"FFTW.REDFT00\", \"FFTW.REDFT01\", \"FFTW.REDFT10\", 或
   \"FFTW.REDFT11\" ）、各类离散正弦变换（ \"FFTW.RODFT00\", \"FFTW.RODFT01\",
   \"FFTW.RODFT10\", 或 \"FFTW.RODFT11\" ）、实数输入半复数输出的 DFT （
   \"FFTW.R2HC\" 及它的逆 \"FFTW.HC2R\")，或离散 Hartley 变换（ \"FFTW.DHT\" ）。参数
   \"kind\" 可以为数组或多元组，可用来指明在 \"A\" 的不同维度上做不同种类的变换；对未指明的维度使用
   \"kind[end]\" 。有关这些变换类型的精确定义，详见 FFTW 手册 。

   可选参数 \"dims\" 指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。 \"kind[i]\" 是对维度
   \"dims[i]\" 的变换种类。当 \"i > length(kind)\" 时使用 \"kind[end]\" 。

   另见 \"FFTW.plan_r2r()\" ，它制定优化 r2r 的方案。

"),

("信号处理","Base","FFTW","FFTW.r2r!(A, kind[, dims])

   \"FFTW.r2r!()\" 与 \"FFTW.r2r()\" 类似，但在原地对 \"A\" 进行运算。 \"A\"
   必须是实数或复数的浮点数数组。

"),

("信号处理","Base","FFTW","FFTW.plan_r2r(A, kind[, dims[, flags[, timelimit]]])

   制定优化 r2r 的方案。与 \"plan_fft()\" 类似，但它对应于 \"FFTW.r2r()\" 。

"),

("信号处理","Base","FFTW","FFTW.plan_r2r!(A, kind[, dims[, flags[, timelimit]]])

   与 \"plan_fft()\" 类似，但它对应于 \"FFTW.r2r!()\" 。

"),

("信号处理","Base","fftshift","fftshift(x)

   交换 \"x\" 每个维度的上半部分和下半部分。

"),

("信号处理","Base","fftshift","fftshift(x, dim)

   交换 \"x\" 指定维度的上半部分和下半部分。

"),

("信号处理","Base","ifftshift","ifftshift(x[, dim])

   \"fftshift\" 的逆运算。

"),

("信号处理","Base","filt","filt(b, a, x)

   对向量 \"x\" 使用由向量 \"a\" 和 \"b\" 描述的过滤器。

"),

("信号处理","Base","deconv","deconv(b, a)

   构造向量 \"c\" ，满足 \"b = conv(a,c) + r\" 。等价于多项式除法。

"),

("信号处理","Base","conv","conv(u, v)

   计算两个向量的卷积。使用 FFT 算法。

"),

("信号处理","Base","xcorr","xcorr(u, v)

   计算两个向量的互相关。

"),

("并行计算","Base","addprocs_local","addprocs_local(n)

   在当前机器上添加一个进程。适用于多核。

"),

("并行计算","Base","addprocs_ssh","addprocs_ssh({\"host1\", \"host2\", ...})

   通过 SSH 在远程机器上添加进程。需要在每个节点的相同位置安装 Julia ，或者通过共享文件系统可以使用 Julia 。

"),

("并行计算","Base","addprocs_sge","addprocs_sge(n)

   通过 Sun/Oracle Grid Engine batch queue 来添加进程，使用 \"qsub\" 。

"),

("并行计算","Base","nprocs","nprocs()

   获取当前可用处理器的个数。

"),

("并行计算","Base","myid","myid()

   获取当前处理器的 ID 。

"),

("并行计算","Base","pmap","pmap(f, c)

   并行地将函数 \"f\" 映射到集合 \"c\" 的每个元素上。

"),

("并行计算","Base","remote_call","remote_call(id, func, args...)

   在指定的处理器上，对指定参数异步调用函数。返回 \"RemoteRef\" 。

"),

("并行计算","Base","wait","wait(RemoteRef)

   等待指定的 \"RemoteRef\" 所需的值为可用。

"),

("并行计算","Base","fetch","fetch(RemoteRef)

   等待并获取 \"RemoteRef\" 的值。

"),

("并行计算","Base","remote_call_wait","remote_call_wait(id, func, args...)

   在一个信息内运行 \"wait(remote_call(...))\" 。

"),

("并行计算","Base","remote_call_fetch","remote_call_fetch(id, func, args...)

   在一个信息内运行 \"fetch(remote_call(...))\" 。

"),

("并行计算","Base","put","put(RemoteRef, value)

   把值存储在 \"RemoteRef\" 中。它的实现符合“共享长度为 1 的队列”：如果现在有一个值，除非值由 \"take\"
   函数移除，否则一直阻塞。

"),

("并行计算","Base","take","take(RemoteRef)

   取回 \"RemoteRef\" 的值，将其移除，从而清空 \"RemoteRef\" 。

"),

("并行计算","Base","RemoteRef","RemoteRef()

   在当前机器上生成一个未初始化的 \"RemoteRef\" 。

"),

("并行计算","Base","RemoteRef","RemoteRef(n)

   在处理器 \"n\" 上生成一个未初始化的 \"RemoteRef\" 。

"),

("分布式数组","Base","DArray","DArray(init, dims[, procs, dist])

   构造分布式数组。 \"init\" 函数接收索引值范围多元组为参数，此函数为指定的索引值返回分布式数组中对应的块。 \"dims\"
   为整个分布式数组的大小。 \"procs\" 为要使用的处理器 ID 的向量。 \"dist\"
   是整数向量，指明分布式数组在每个维度上需要划分为多少块。

"),

("分布式数组","Base","dzeros","dzeros(dims, ...)

   构造全零的分布式数组。尾参数可参见 \"darray\" 。

"),

("分布式数组","Base","dones","dones(dims, ...)

   构造全一的分布式数组。尾参数可参见 \"DArray\" 。

"),

("分布式数组","Base","dfill","dfill(x, dims, ...)

   构造值全为 \"x\" 的分布式数组。尾参数可参见 \"DArray\" 。

"),

("分布式数组","Base","drand","drand(dims, ...)

   构造均匀分布的随机分布式数组。尾参数可参见 \"DArray\" 。

"),

("分布式数组","Base","drandn","drandn(dims, ...)

   构造正态分布的随机分布式数组。尾参数可参见 \"DArray\" 。

"),

("分布式数组","Base","distribute","distribute(a)

   将本地数组转换为分布式数组。

"),

("分布式数组","Base","localize","localize(d)

   获取分布式数组 \"d\" 的本地部分。

"),

("分布式数组","Base","myindexes","myindexes(d)

   分布式数组 \"d\" 的本地部分所对应的索引值的多元组。

"),

("分布式数组","Base","procs","procs(d)

   获取存储分布式数组 \"d\" 的处理器 ID 的向量。

"),

("系统","Base","run","run(command)

   执行命令对象。如果出错或进程退出时为非零状态，将报错。命令是由倒引号引起来的。

"),

("系统","Base","spawn","spawn(command)

   异步运行命令，返回生成的 \"Process\" 对象。

"),

("系统","Base","success","success(command)

   执行命令对象，并判断是否成功（退出代码是否为 0 ）。命令是由倒引号引起来的。

"),

("系统","Base","readsfrom","readsfrom(command)

   异步运行命令，返回 (stream,process) 多元组。第一个值是从进程的标准输出读出的流。

"),

("系统","Base","writesto","writesto(command)

   异步运行命令，返回 (stream,process) 多元组。第一个值是向进程的标准输入写入的流。

"),

("系统","Base","readandwrite","readandwrite(command)

   异步运行命令，返回 (stdout,stdin,process) 多元组，分别为进程的输出流、输入流，及进程本身。

"),

("系统","Base",">",">()

   重定向进程的标准输出流。

   **例子**: \"run(`ls` > \"out.log\")\"

"),

("系统","Base","<","<()

   重定向进程的标准输入流流。

"),

("系统","Base",">>",">>()

   重定向进程的标准输出流，添加到目标文件尾部。

"),

("系统","Base",".>",".>()

   重定向进程的标准错误流。

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

   设置当前工作文件夹。返回新的当前文件夹。

"),

("系统","Base","cd","cd(f[, \"dir\"])

   临时更改当前工作文件夹（未指明主文件夹），调用 f 函数，然后返回原文件夹。

"),

("系统","Base","mkdir","mkdir(path[, mode])

   新建名为 \"path\" 的文件夹，其权限为 \"mode\" 。 \"mode\" 默认为 0o777
   ，可通过当前文件创建掩码来修改。

"),

("系统","Base","rmdir","rmdir(path)

   删除 \"path\" 文件夹。

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

   对单态 \"EnvHash\" 的引用，提供系统环境变量的字典接口。

"),

("C 接口","Base","ccall","ccall((symbol, library), RetType, (ArgType1, ...), ArgVar1, ...)

   调用从 C 导出的共享库的函数，它由 (函数名, 共享库名) 多元组（字符串或 :Symbol ）指明。 ccall 也可用来调用由
   dlsym 返回的函数指针，但由于将来想实现静态编译，不提倡这种用法。

"),

("C 接口","Base","cfunction","cfunction(fun::Function, RetType::Type, (ArgTypes...))

   使用 Julia 函数生成 C 可调用的函数指针。

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

   在共享库句柄中查找符号。查找成功时返回可调用的函数指针。

"),

("C 接口","Base","dlsym_e","dlsym_e(handle, sym)

   在共享库句柄中查找符号。如果查找失败，则安静地返回空指针。

"),

("C 接口","Base","dlclose","dlclose(handle)

   通过句柄来关闭共享库的引用。

"),

("C 接口","Base","c_free","c_free(addr::Ptr)

   调用 C 标准库中的 ·\"free()\" 。

"),

("C 接口","Base","unsafe_ref","unsafe_ref(p::Ptr{T}, i::Integer)

   对指针解引用 \"p[i]\" 或 \"*p\" ，返回类型 T 的值的浅拷贝。

"),

("C 接口","Base","unsafe_assign","unsafe_assign(p::Ptr{T}, x, i::Integer)

   给指针赋值 \"p[i] = x\" 或 \"*p = x\" ，将对象 x 复制进 p 处的内存中。

"),

("C 接口","Base","pointer","pointer(a[, index])

   获取数组元素的原生地址。要确保使用指针时，必须存在 Julia 对 \"a\" 的引用。

"),

("C 接口","Base","pointer","pointer(type, Uint)

   指向指定元素类型的指针，地址为该无符号整数。

"),

("C 接口","Base","pointer_to_array","pointer_to_array(p, dims[, own])

   将原生指针封装为 Julia 数组对象。指针元素的类型决定了数组元素的类型。 \"own\" 可选项指明 Julia
   是否可以控制内存，当数组不再被引用时调用 \"free\" 释放指针。

"),

("错误","Base","error","error(message::String)

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

("常量","Base","OS_NAME","OS_NAME

   表示操作系统名的符号。可能的值有 \":Linux\", \":Darwin\" (OS X), 或 \":Windows\" 。

"),

("常量","Base","ARGS","ARGS

   传递给 Julia 的命令行参数数组，它是个字符串数组。

"),

("常量","Base","C_NULL","C_NULL

   C 空指针常量，有时用于调用外部代码。

"),

("常量","Base","CPU_CORES","CPU_CORES

   系统中 CPU 内核的个数。

"),

("常量","Base","WORD_SIZE","WORD_SIZE

   当前机器的标准字长，单位为位。

"),

("常量","Base","VERSION","VERSION

   描述 Julia 版本的对象。

"),

("常量","Base","LOAD_PATH","LOAD_PATH

   路径的字符串数组， \"require\" 函数在这些路径下查找代码。

"),

("文件系统","Base","isblockdev","isblockdev(path) -> Bool

   如果 \"path\" 是块设备，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","ischardev","ischardev(path) -> Bool

   如果 \"path\" 是字符设备，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","isdir","isdir(path) -> Bool

   如果 \"path\" 是文件夹，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","isexecutable","isexecutable(path) -> Bool

   如果当前用户对 \"path\" 有执行权限，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","isfifo","isfifo(path) -> Bool

   如果 \"path\" 是 FIFO ，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","isfile","isfile(path) -> Bool

   如果 \"path\" 是文件，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","islink","islink(path) -> Bool

   如果 \"path\" 是符号链接，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","ispath","ispath(path) -> Bool

   如果 \"path\" 是有效的文件系统路径，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","isreadable","isreadable(path) -> Bool

   如果当前用户对 \"path\" 有读权限，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","issetgid","issetgid(path) -> Bool

   如果 \"path\" 设置了 setgid 标识符，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","issetuid","issetuid(path) -> Bool

   如果 \"path\" 设置了 setuid 标识符，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","issocket","issocket(path) -> Bool

   如果 \"path\" 是 socket，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","issticky","issticky(path) -> Bool

   如果 \"path\" 设置了粘着位，则返回 \"true\" ；否则返回 \"false\" 。

"),

("文件系统","Base","iswriteable","iswriteable(path) -> Bool

   如果当前用户对 \"path\" 有写权限，则返回 \"true\" ；否则返回 \"false\" 。

"),


("线性代数","","*","*(A, B)

   矩阵乘法。

"),

("线性代数","","\\","\\(A, B)

   使用 polyalgorithm 做矩阵除法。对输入矩阵 \"A\" 和 \"B\" ，当 \"A\" 为方阵时，输出 \"X\"
   满足 \"A*X == B\" 。由 \"A\" 的结构确定使用哪种求解器。对上三角矩阵和下三角矩阵 \"A\" ，直接求解。对
   Hermitian 矩阵 \"A\" （它等价于实对称矩阵）时，使用 BunchKaufman 分解。其他情况使用 LU
   分解。对长方矩阵 \"A\" ，通过将 \"A\"
   约简到双对角线形式，然后使用最小范数最小二乘法来求解双对角线最小二乘问题。对稀疏矩阵 \"A\" ，使用 UMFPACK 中的 LU
   分解。

"),

("线性代数","","dot","dot(x, y)

   计算点积。

"),

("线性代数","","cross","cross(x, y)

   计算三维向量的向量积。

"),

("线性代数","","norm","norm(a)

   计算 \"Vector\" 或 \"Matrix\" 的模。

"),

("线性代数","","lu","lu(A) -> L, U, P

   对 \"A\" 做 LU 分解，满足 \"P*A = L*U\" 。

"),

("线性代数","","lufact","lufact(A) -> LUDense 或 UmfpackLU

   对 \"A\" 做 LU 分解。若 \"A\" 为稠密矩阵，返回 \"LUDense\" 对象；若 \"A\" 为稀疏矩阵，返回
   \"UmfpackLU\" 对象；。分解结果 \"F\" 的独立分量是可以被索引的： \"F[:L]\", \"F[:U]\", 及
   \"F[:P]\" （置换矩阵）或 \"F[:p]\" （置换向量）。 \"UmfpackLU\" 对象还有额外的 \"F[:q]\"
   分量（ left 置换向量）及缩放因子 \"F[:Rs]\" 向量。 \"LUDense\" 对象和 \"UmfpackLU\"
   对象可使用下列函数： \"size\", \"\\\" 和 \"det\" 。 \"LUDense\" 对象还可以使用 \"inv\"
   方法。稀疏 LU 分解中， \"L*U\" 等价于 \"diagmm(Rs,A)[p,q]\" 。

"),

("线性代数","","lufact!","lufact!(A) -> LUDense

   \"lufact!\" 与 \"lufact\" 类似，但它覆写输入 A ，而非构造浅拷贝。对稀疏矩阵 \"A\" ，它并不覆写
   \"nzval\" 域，仅覆写索引值域， \"colptr\" 和 \"rowval\" 在原地缩减，使得从 1 开始的索引改为从 0
   开始的索引。

"),

("线性代数","","chol","chol(A[, LU]) -> F

   计算对称正定矩阵 \"A\" 的 Cholesky 分解，返回 \"F\" 矩阵。如果 \"LU\" 为 \"L\" （下三角），
   \"A = L*L'\" 。如果 \"LU\" 为 \"U\" （下三角）， \"A = R'*R\" 。

"),

("线性代数","","cholfact","cholfact(A[, LU]) -> CholeskyDense

   计算稠密对称正定矩阵 \"A\" 的 Cholesky 分解，返回 \"CholeskyDense\" 对象。 \"LU\" 若为
   'L' 则使用下三角，若为 'U' 则使用上三角。默认使用 'U' 。可从分解结果 \"F\" 中获取三角矩阵： \"F[:L]\"
   和 \"F[:U]\" 。 \"CholeskyDense\" 对象可使用下列函数： \"size\", \"\\\",
   \"inv\", \"det\" 。如果矩阵不是正定，会抛出 \"LAPACK.PosDefException\" 错误。

"),

("线性代数","","cholpfact","cholpfact(A[, LU]) -> CholeskyPivotedDense

   计算对称正定矩阵 \"A\" 的主元 Cholesky 分解，返回 \"CholeskyDensePivoted\" 对象。
   \"LU\" 若为 'L' 则使用下三角，若为 'U' 则使用上三角。默认使用 'U' 。可从分解结果 \"F\" 中获取三角分量：
   \"F[:L]\" 和 \"F[:U]\" ，置换矩阵和置换向量分布为 \"F[:P]\" 和 \"F[:p]\" 。
   \"CholeskyDensePivoted\" 对象可使用下列函数： \"size\", \"\\\", \"inv\",
   \"det\" 。如果矩阵不是满秩，会抛出 \"LAPACK.RankDeficientException\" 错误。

"),

("线性代数","","cholpfact!","cholpfact!(A[, LU]) -> CholeskyPivotedDense

   \"cholpfact!\" 与 \"cholpfact\" 类似，但它覆写输入 A ，而非构造浅拷贝。

"),

("线性代数","","qr","qr(A) -> Q, R

   对 \"A\" 做 QR 分解，满足 \"A = Q*R\" 。也可参见 \"qrfact\" 。

"),

("线性代数","","qrfact","qrfact(A)

   对 \"A\" 做 QR 分解，返回 \"QRDense\" 对象。 \"factors(qrfact(A))\" 返回 \"Q\"
   和 \"R\" 。 \"QRDense\" 对象可使用下列函数： \"size\", \"factors\", \"qmulQR\",
   \"qTmulQR\", \"\\\" 。

"),

("线性代数","","qrfact!","qrfact!(A)

   \"qrfact!\" 与 \"qrfact\" 类似，但它覆写输入 A ，而非构造浅拷贝。

"),

("线性代数","","qrp","qrp(A) -> Q, R, P

   对 \"A\" 做主元 QR 分解，满足 \"A*P = Q*R\" 。另见 \"qrpfact\" 。

"),

("线性代数","","qrpfact","qrpfact(A) -> QRPivotedDense

   对 \"A\" 做主元 QR 分解，返回 \"QRDensePivoted\" 对象。可从分解结果 \"F\" 中获取分量：正交矩阵
   \"Q\" 为 \"F[:Q]\" ，三角矩阵 \"R\" 为 \"F[:R]\" ，置换矩阵和置换向量分布为 \"F[:P]\" 和
   \"F[:p]\" 。 \"QRDensePivoted\" 对象可使用下列函数： \"size\", \"\\\" 。提取的
   \"Q\" 是 \"QRDenseQ\" 对象，且为了支持 \"Q\" 与 \"Q'\" 的高效乘法，重载了 \"*\"
   运算符。可以使用 \"full\" 函数将 \"QRDenseQ\" 矩阵转换为普通矩阵。

"),

("线性代数","","qrpfact!","qrpfact!(A) -> QRPivotedDense

   \"qrpfact!\" 与 \"qrpfact\" 类似，但它覆写 A 以节约空间，而非构造浅拷贝。

"),

("线性代数","","sqrtm","sqrtm(A)

   计算 \"A\" 的矩阵平方根。如果 \"B = sqrtm(A)\" ，满足在误差范围内 \"B*B == A\" 。

"),

("线性代数","","eig","eig(A) -> D, V

   计算 \"A\" 的特征值和特征向量。

"),

("线性代数","","eigvals","eigvals(A)

   返回  \"A\" 的特征值。

"),

("线性代数","","eigfact","eigfact(A)

   对 \"A\" 做特征分解，返回 \"EigenDense\" 对象。可从分解结果 \"F\" 中获取分量：特征值为
   \"F[:values]\" ，特征向量为 \"F[:vectors]\" 。 \"EigenDense\" 对象可使用下列函数：
   \"inv\", \"det\" 。

"),

("线性代数","","eigfact!","eigfact!(A)

   \"eigfact!\" 与 \"eigfact\" 类似，但它覆写输入 A ，而非构造浅拷贝。

"),

("线性代数","","hessfact","hessfact(A)

   对 \"A\" 做 Hessenberg 分解，返回 \"HessenbergDense\" 对象。If \"F\" is the
   factorization object, 酉矩阵为 \"F[:Q]\" ， Hessenberg 矩阵为 \"F[:H]\"
   。提取的 \"Q\" 是 \"HessenbergDenseQ\" 对象，可以使用 \"full\" 函数将其转换为普通矩阵。

"),

("线性代数","","hessfact!","hessfact!(A)

   \"hessfact!\" 与 \"hessfact\" 类似，但它覆写输入 A ，而非构造浅拷贝。

"),

("线性代数","","svdfact","svdfact(A[, thin]) -> SVDDense

   对 \"A\" 做奇异值分解（SVD），返回 \"SVDDense\" 对象。分解结果 \"F\" 的 \"U\", \"S\",
   \"V\" 和 \"Vt\" 可分别通过 \"F[:U]\", \"F[:S]\", \"F[:V]\" 和 \"F[:Vt]\"
   来获得，它们满足 \"A = U*diagm(S)*Vt\" 。如果 \"thin\" 为 \"true\"
   ，则做节约模式分解。此算法先计算 \"Vt\" ，即 \"V\" 的转置，后者是由前者转置得到的。

"),

("线性代数","","svdfact!","svdfact!(A[, thin]) -> SVDDense

   \"svdfact!\" 与 \"svdfact\" 类似，但它覆写 A 以节约空间，而非构造浅拷贝。如果 \"thin\" 为
   \"true\" ，则做节约模式分解。

"),

("线性代数","","svd","svd(A[, thin]) -> U, S, V

   对 \"A\" 做奇异值分解，返回 \"U\" ，向量 \"S\" ，及 \"V\" ，满足 \"A ==
   U*diagm(S)*V'\" 。如果 \"thin\" 为 \"true\" ，则做节约模式分解。

"),

("线性代数","","svdvals","svdvals(A)

   返回 \"A\" 的奇异值。

"),

("线性代数","","svdvals!","svdvals!(A)

   返回 \"A\" 的奇异值，将结果覆写到输入上以节约空间。

"),

("线性代数","","svdfact","svdfact(A, B) -> GSVDDense

   计算 \"A\" 和 \"B\" 的广义 SVD ，返回 \"GSVDDense\" 分解对象。 满足 \"A =
   U*D1*R0*Q'\" 及 \"B = V*D2*R0*Q'\" 。

"),

("线性代数","","svd","svd(A, B) -> U, V, Q, D1, D2, R0

   计算 \"A\" 和 \"B\" 的广义 SVD ，返回 \"U\", \"V\", \"Q\", \"D1\", \"D2\", 和
   \"R0\" ，满足 \"A = U*D1*R0*Q'\" 及 \"B = V*D2*R0*Q'\" 。

"),

("线性代数","","svdvals","svdvals(A, B)

   仅返回 \"A\" 和 \"B\" 广义 SVD 中的奇异值。

"),

("线性代数","","triu","triu(M)

   矩阵上三角。

"),

("线性代数","","tril","tril(M)

   矩阵下三角。

"),

("线性代数","","diag","diag(M[, k])

   矩阵的第 \"k\" 条对角线，结果为向量。 \"k\" 从 0 开始。

"),

("线性代数","","diagm","diagm(v[, k])

   构造 \"v\" 为第 \"k\" 条对角线的对角矩阵。 \"k\" 从 0 开始。

"),

("线性代数","","diagmm","diagmm(matrix, vector)

   矩阵与向量相乘。此函数也可以做向量与矩阵相乘。

"),

("线性代数","","Tridiagonal","Tridiagonal(dl, d, du)

   由下对角线、主对角线、上对角线来构造三对角矩阵

"),

("线性代数","","Woodbury","Woodbury(A, U, C, V)

   构造 Woodbury matrix identity 格式的矩阵。

"),

("线性代数","","rank","rank(M)

   计算矩阵的秩。

"),

("线性代数","","norm","norm(A[, p])

   计算向量或矩阵的 \"p\" 范数。 \"p\" 默认为 2 。如果 \"A\" 是向量， \"norm(A, p)\" 计算
   \"p\" 范数。 \"norm(A, Inf)\" 返回 \"abs(A)\" 中的最大值， \"norm(A, -Inf)\"
   返回最小值。如果 \"A\" 是矩阵， \"p\" 的有效值为 \"1\", \"2\", 和 \"Inf\" 。要计算
   Frobenius 范数，应使用 \"normfro\" 。

"),

("线性代数","","normfro","normfro(A)

   计算矩阵 \"A\" 的 Frobenius 范数。

"),

("线性代数","","cond","cond(M[, p])

   使用 p 范数计算矩阵条件数。 \"p\" 如果省略，默认为 2 。 \"p\" 的有效值为 \"1\", \"2\", 和
   \"Inf\".

"),

("线性代数","","trace","trace(M)

   矩阵的迹。

"),

("线性代数","","det","det(M)

   矩阵的行列式。

"),

("线性代数","","inv","inv(M)

   矩阵的逆。

"),

("线性代数","","pinv","pinv(M)

   矩阵的 Moore-Penrose （广义）逆

"),

("线性代数","","null","null(M)

   矩阵 M 的零空间的基。

"),

("线性代数","","repmat","repmat(A, n, m)

   重复矩阵 \"A\" 来构造新数组，在第一维度上重复 \"n\" 次，第二维度上重复 \"m\" 次。

"),

("线性代数","","kron","kron(A, B)

   两个向量或两个矩阵的 Kronecker 张量积。

"),

("线性代数","","linreg","linreg(x, y)

   最小二乘法线性回归来计算参数 \"[a, b]\" ，使 \"y\" 逼近 \"a+b*x\" 。

"),

("线性代数","","linreg","linreg(x, y, w)

   带权最小二乘法线性回归。

"),

("线性代数","","expm","expm(A)

   矩阵指数。

"),

("线性代数","","issym","issym(A)

   判断是否为对称矩阵。

"),

("线性代数","","isposdef","isposdef(A)

   判断是否为正定矩阵。

"),

("线性代数","","istril","istril(A)

   判断是否为下三角矩阵。

"),

("线性代数","","istriu","istriu(A)

   判断是否为上三角矩阵。

"),

("线性代数","","ishermitian","ishermitian(A)

   判断是否为 Hamilton 矩阵。

"),

("线性代数","","transpose","transpose(A)

   转置运算符（ \".'\" ）。

"),

("线性代数","","ctranspose","ctranspose(A)

   共轭转置运算符（ \"'\" ）。

"),

("BLAS 函数","","copy!","copy!(n, X, incx, Y, incy)

   将内存邻接距离为 \"incx\" 的数组 \"X\" 的 \"n\" 个元素复制到内存邻接距离为 \"incy\" 的数组
   \"Y\" 中。返回 \"Y\" 。

"),

("BLAS 函数","","dot","dot(n, X, incx, Y, incy)

   内存邻接距离为 \"incx\" 的数组 \"X\" 的 \"n\" 个元素组成的向量，与 内存邻接距离为 \"incy\" 的数组
   \"Y\" 的 \"n\" 个元素组成的向量，做点积。 \"Complex\" 数组没有 \"dot\" 方法。

"),

("BLAS 函数","","nrm2","nrm2(n, X, incx)

   内存邻接距离为 \"incx\" 的数组 \"X\" 的 \"n\" 个元素组成的向量的 2 范数。

"),

("BLAS 函数","","axpy!","axpy!(n, a, X, incx, Y, incy)

   将 \"a*X + Y\" 赋值给 \"Y\" 并返回。

"),

("BLAS 函数","","syrk!","syrk!(uplo, trans, alpha, A, beta, C)

   由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*A.' + beta*C\" 或
   \"alpha*A.'*A + beta*C\" ，由参数 \"uplo\" （ 'U' 或 'L' ）确定，用计算的结果更新对称矩阵
   \"C\" 的上三角矩阵或下三角矩阵。返回 \"C\" 。

"),

("BLAS 函数","","syrk","syrk(uplo, trans, alpha, A)

   由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*A.'\" 或 \"alpha*A.'*A\"
   ，由参数 \"uplo\" （ 'U' 或 'L' ）确定，返回计算结果的上三角矩阵或下三角矩阵。

"),

("BLAS 函数","","herk!","herk!(uplo, trans, alpha, A, beta, C)

   此方法只适用于复数数组。由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*A' +
   beta*C\" 或 \"alpha*A'*A + beta*C\" ，由参数 \"uplo\" （ 'U' 或 'L'
   ）确定，用计算的结果更新对称矩阵 \"C\" 的上三角矩阵或下三角矩阵。返回 \"C\" 。

"),

("BLAS 函数","","herk","herk(uplo, trans, alpha, A)

   此方法只适用于复数数组。由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*A'\" 或
   \"alpha*A'*A\" ，由参数 \"uplo\" （ 'U' 或 'L' ）确定，返回计算结果的上三角矩阵或下三角矩阵。

"),

("BLAS 函数","","gbmv!","gbmv!(trans, m, kl, ku, alpha, A, x, beta, y)

   由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*x\" 或 \"alpha*A'*x\"
   ，将结果赋值给 \"y\" 并返回。矩阵 \"A\" 为普通带矩阵 ，其维度 \"m\" 为 \"size(A,2)\" ，
   子对角线为 \"kl\" ，超对角线为 \"ku\" 。

"),

("BLAS 函数","","gbmv","gbmv(trans, m, kl, ku, alpha, A, x, beta, y)

   由参数 \"trans\" （ 'N' 或 'T' ）确定，计算 \"alpha*A*x\" 或 \"alpha*A'*x\" 。矩阵
   \"A\" 为普通带矩阵 ，其维度 \"m\" 为 \"size(A,2)\" ， 子对角线为 \"kl\" ，超对角线为
   \"ku\" 。

"),

("BLAS 函数","","sbmv!","sbmv!(uplo, k, alpha, A, x, beta, y)

   将 \"alpha*A*x + beta*y\" 赋值给 \"y\" 并返回。其中 \"A\" 是对称带矩阵，维度为
   \"size(A,2)\" ，超对角线为 \"k\" 。关于 A 是如何存储的，详见
   http://www.netlib.org/lapack/explore-html/ 的 level-2 BLAS 。

"),

("BLAS 函数","","sbmv","sbmv(uplo, k, alpha, A, x)

   返回 \"alpha*A*x\" 。其中 \"A\" 是对称带矩阵，维度为 \"size(A,2)\" ，超对角线为 \"k\" 。

"),

("BLAS 函数","","gemm!","gemm!(tA, tB, alpha, A, B, beta, C)

   由 \"tA\" （ \"A\" 做转置）和 \"tB\" 确定，计算 \"alpha*A*B + beta*C\"
   或其它对应的三个表达式，将结果赋值给 \"C\" 并返回。

"),

("BLAS 函数","","gemm","gemm(tA, tB, alpha, A, B)

   由 \"tA\" （ \"A\" 做转置）和 \"tB\" 确定，计算 \"alpha*A*B + beta*C\"
   或其它对应的三个表达式。

"),

("标点符号","","punctuation","punctuation

   +-----------+------------------------------------------------------------------+
   | 符号        | 意思                                                               |
   +===========+==================================================================+
   | \\\"@m\\\"    | 调用宏 m ；后面应跟一空格，再跟一表达式                                            |
   +-----------+------------------------------------------------------------------+
   | \\\"!\\\"     | 作为前缀时是“逻辑非”运算符                                                   |
   +-----------+------------------------------------------------------------------+
   | \\\"!\\\"     | 在函数名后时，暗示函数修改了它的参数                                               |
   +-----------+------------------------------------------------------------------+
   | \\\"#\\\"     | 单行注释                                                             |
   +-----------+------------------------------------------------------------------+
   | \\\"\\\$\\\"    | 异或运算符；字符串和表达式内插                                                  |
   +-----------+------------------------------------------------------------------+
   | \\\"%\\\"     | 余数运算符                                                            |
   +-----------+------------------------------------------------------------------+
   | \\\"^\\\"     | 指数运算符                                                            |
   +-----------+------------------------------------------------------------------+
   | \\\"&\\\"     | 位与                                                               |
   +-----------+------------------------------------------------------------------+
   | \\\"*\\\"     | 乘法；矩阵乘法                                                          |
   +-----------+------------------------------------------------------------------+
   | \\\"()\\\"    | 空多元组                                                             |
   +-----------+------------------------------------------------------------------+
   | \\\"~\\\"     | 按位取反运算符                                                          |
   +-----------+------------------------------------------------------------------+
   | \\\"\\\\\\\"    | 反斜杠运算符                                                           |
   +-----------+------------------------------------------------------------------+
   | \\\"a[]\\\"   | 数组索引                                                             |
   +-----------+------------------------------------------------------------------+
   | \\\"[,]\\\"   | 垂直连接                                                             |
   +-----------+------------------------------------------------------------------+
   | \\\"[;]\\\"   | 也是                                                               |
   +-----------+------------------------------------------------------------------+
   | \\\"[  ]\\\"  | 水平连接，使用空格来分割表达式                                                  |
   +-----------+------------------------------------------------------------------+
   | \\\"T{ }\\\"  | 参数类型实例                                                           |
   +-----------+------------------------------------------------------------------+
   | \\\"{  }\\\"  | 构造元胞数组                                                           |
   +-----------+------------------------------------------------------------------+
   | \\\";\\\"     | 语句分隔符                                                            |
   +-----------+------------------------------------------------------------------+
   | \\\",\\\"     | 函数参数或多元组元素分隔符                                                    |
   +-----------+------------------------------------------------------------------+
   | \\\"?\\\"     | 问号表达式运算符                                                         |
   +-----------+------------------------------------------------------------------+
   | \\\"\\\"\\\"\\\"  | 字符串文本定界符                                                         |
   +-----------+------------------------------------------------------------------+
   | \\\"''\\\"    | 字符文本定界符                                                          |
   +-----------+------------------------------------------------------------------+
   | >>``<<    | 外部进程（命令）定界符                                                      |
   +-----------+------------------------------------------------------------------+
   | \\\"...\\\"   | 向一个函数调用插入参数；声明变参函数                                               |
   +-----------+------------------------------------------------------------------+
   | \\\".\\\"     | 获取对象内已命名的域或模块中的命名；它也是前缀逐元素计算的运算符                                 |
   +-----------+------------------------------------------------------------------+
   | \\\"a:b\\\"   | 范围                                                               |
   +-----------+------------------------------------------------------------------+
   | \\\"a:s:b\\\" | 范围                                                               |
   +-----------+------------------------------------------------------------------+
   | \\\":\\\"     | 索引整个维度                                                           |
   +-----------+------------------------------------------------------------------+
   | \\\"::\\\"    | 类型注释                                                             |
   +-----------+------------------------------------------------------------------+
   | \\\":( )\\\"  | 引用表达式                                                            |
   +-----------+------------------------------------------------------------------+

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

("稀疏矩阵","","sparse","sparse(I, J, V[, m, n, combine])

   构造 \"m x n\" 的稀疏矩阵 \"S\" ，满足 \"S[I[k], J[k]] = V[k]\" 。使用
   \"combine\" 函数来处理坐标重复的元素。如果未指明 \"m\" 和 \"n\" ，则默认为 \"max(I)\" 和
   \"max(J)\" 。如果省略 \"combine\" 函数，默认对坐标重复的元素求和。

"),

("稀疏矩阵","","sparsevec","sparsevec(I, V[, m, combine])

   构造 \"m x 1\" 的稀疏矩阵 \"S\" ，满足 \"S[I[k]] = V[k]\" 。使用 \"combine\"
   函数来处理坐标重复的元素，如果它被省略，则默认为 *+* 。在 Julia 中，稀疏向量是只有一列的稀疏矩阵。由于 Julia
   使用列压缩（CSC）存储格式，只有一列的稀疏列矩阵是稀疏的，但只有一行的稀疏行矩阵是稠密的。

"),

("稀疏矩阵","","sparsevec","sparsevec(D::Dict[, m])

   构造 \"m x 1\" 大小的稀疏矩阵，其行值为字典中的键，非零值为字典中的值。

"),

("稀疏矩阵","","issparse","issparse(S)

   如果 \"S\" 为稀疏矩阵，返回 \"true\" ；否则为 \"false\" 。

"),

("稀疏矩阵","","sparse","sparse(A)

   将稠密矩阵 \"A\" 转换为稀疏矩阵。

"),

("稀疏矩阵","","sparsevec","sparsevec(A)

   将稠密矩阵 \"A\" 转换为 \"m x 1\" 的稀疏矩阵。在 Julia 中，稀疏向量是只有一列的稀疏矩阵。

"),

("稀疏矩阵","","dense","dense(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

("稀疏矩阵","","full","full(S)

   将稀疏矩阵 \"S\" 转换为稠密矩阵。

"),

("稀疏矩阵","","spzeros","spzeros(m, n)

   构造 \"m x n\" 的空稀疏矩阵。

"),

("稀疏矩阵","","speye","speye(type, m[, n])

   构造指定类型、大小为 \"m x m\" 的稀疏单位矩阵。如果提供了 \"n\" 则构建大小为 \"m x n\" 的稀疏单位矩阵。

"),

("稀疏矩阵","","spones","spones(S)

   构造与 \"S\" 同样结构的稀疏矩阵，但非零元素值为 \"1.0\" 。

"),

("稀疏矩阵","","sprand","sprand(m, n, density[, rng])

   构造指定密度的随机稀疏矩阵。非零样本满足由 \"rng\" 指定的分布。默认为均匀分布。

"),

("稀疏矩阵","","sprandn","sprandn(m, n, density)

   构造指定密度的随机稀疏矩阵，非零样本满足正态分布。

"),

("稀疏矩阵","","sprandbool","sprandbool(m, n, density)

   构造指定密度的随机稀疏布尔值矩阵。

"),


}
