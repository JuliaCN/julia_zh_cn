.. currentmodule:: Base

杂项
----

.. function:: exit([code])

   退出（或在会话中按下 control-D ）。默认退出代码为 0 ，表示进程正常结束。

.. function:: whos([Module,] [pattern::Regex])

   打印模块中全局变量的信息，可选择性地限制打印匹配 ``pattern`` 的变量。

.. function:: edit(file::String, [line])

   编辑文件；可选择性地提供要编辑的行号。退出编辑器后返回 Julia 会话。如果文件后缀名为 ".jl" ，关闭文件后会重载该文件。

.. function:: edit(function, [types])

   编辑函数定义，可选择性地提供一个类型多元组以指明要编辑哪个方法。退出编辑器后，包含定义的源文件会被重载。

.. function:: require(file::String...)

   在 ``Main`` 模块的上下文中，对每个活动的节点，通过系统的 ``LOAD_PATH`` 查找文件，并只载入一次。``require`` 是顶层操作，因此它设置当前的 ``include`` 路径，但并不使用它来查找文件（参见 ``include`` 的帮助）。此函数常用来载入库代码； ``using`` 函数隐含使用它来载入扩展包。

.. function:: reload(file::String)

   类似 ``require`` ，但不管是否曾载入过，都要载入文件。常在交互式地开发库时使用。

.. function:: include(path::String)

   在当前上下文中，对源文件的内容求值。在包含的过程中，它将本地任务包含路径设置为包含文件的文件夹。嵌套调用 ``include`` 时会搜索那个路径的相关的路径。并行运行时，所有的路径都指向节点 1 上文件，并从节点 1 上获取文件。此函数常用来交互式地载入源文件，或将分散为多个源文件的扩展包结合起来。

.. function:: include_string(code::String)

   类似 ``include`` ，但它从指定的字符串读取代码，而不是从文件中。由于没有涉及到文件路径，不会进行路径处理或从节点 1 获取文件。

.. function:: evalfile(path::String)

   对指定文件的所有表达式求值，并返回最后一个表达式的值。不会进行其他处理（搜索路径，从节点 1 获取文件等）。

.. function:: help(name)

   获得函数帮助。 ``name`` 可以是对象或字符串。

.. function:: apropos(string)

   查询文档中与 ``string`` 相关的函数。

.. function:: which(f, args...)

   对指定的参数，显示应调用 ``f`` 的哪个方法。

.. function:: methods(f)

   显示 ``f`` 的所有方法及其对应的参数类型。
   
.. function:: methodswith(t)

   显示 ``t`` 类型的所有方法。
   

所有对象
--------

.. function:: is(x, y)

   判断 ``x`` 与 ``y`` 是否相同，依据为程序不能区分它们。

.. function:: isa(x, type)

   判断 ``x`` 是否为指定类型。

.. function:: isequal(x, y)

   当且仅当 ``x`` 和 ``y`` 内容相同是为真。粗略地说，即打印出来的 ``x`` 和 ``y`` 看起来一模一样。

.. function:: isless(x, y)

   判断 ``x`` 是否比 ``y`` 小。它具有与 ``isequal`` 一致的整体排序。不能正常排序的值如 ``NaN`` ，会按照任意顺序排序，但其排序方式会保持一致。它是 ``sort`` 默认使用的比较函数。可进行排序的非数值类型，应当实现此方法。

.. function:: typeof(x)

   返回 ``x`` 的具体类型。

.. function:: tuple(xs...)

   构造指定对象的多元组。

.. function:: ntuple(n, f::Function)

   构造长度为 ``n`` 的多元组，每个元素为 ``f(i)`` ，其中 ``i`` 为元素的索引值。

.. function:: object_id(x)

   获取 ``x`` 唯一的整数值 ID 。当且仅当 ``is(x,y)`` 时， ``object_id(x)==object_id(y)`` 。

.. function:: hash(x)

   计算整数哈希值。因而 ``isequal(x,y)`` 等价于 ``hash(x)==hash(y)`` 。

.. function:: finalizer(x, function)

   当对 ``x`` 的引用处于程序不可用时，注册一个注册可调用的函数 ``f(x)`` 来终结这个引用。当 ``x`` 为位类型时，此函数的行为不可预测。

.. function:: copy(x)

   构造 ``x`` 的浅拷贝：仅复制外层结构，不复制内部值。如，复制数组时，会生成一个元素与原先完全相同的新数组。

.. function:: deepcopy(x)

   构造 ``x`` 的深拷贝：递归复制所有的东西，返回一个完全独立的对象。如，深拷贝数组时，会生成一个元素为原先元素深拷贝的新数组。

   作为特例，匿名函数只能深拷贝，非匿名函数则为浅拷贝。它们的区别仅与闭包有关，例如含有隐藏的内部引用的函数。

   While it isn't normally necessary,自定义类型可通过定义特殊版本的 ``deepcopy_internal(x::T, dict::ObjectIdDict)`` 函数（此函数其它情况下不应使用）来覆盖默认的 ``deepcopy`` 行为，其中 ``T`` 是要指明的类型， ``dict`` 记录迄今为止递归中复制的对象。在定义中， ``deepcopy_internal`` 应当用来代替 ``deepcopy`` ， ``dict`` 变量应当在返回前正确的更新。

.. function:: convert(type, x)

   试着将 ``x`` 转换为指定类型。

.. function:: promote(xs...)

   将所有参数转换为共同的提升类型（如果有的话），并将它们（作为多元组）返回。

类型
----

.. function:: subtype(type1, type2)

   仅在 ``type1`` 的所有值都是 ``type2`` 时为真。也可使用 ``<:`` 中缀运算符，写为 ``type1 <: type2`` 。

.. function:: typemin(type)

   指定（实数）数值类型可表示的最小值。

.. function:: typemax(type)

   指定（实数）数值类型可表示的最大值。

.. function:: realmin(type)

   指定的浮点数类型可表示的非反常值中，绝对值最小的数。

.. function:: realmax(type)

   指定的浮点数类型可表示的最大的有穷数。

.. function:: maxintfloat(type)

   指定的浮点数类型可无损表示的最大整数。

.. function:: sizeof(type)

   指定类型的权威二进制表示（如果有的话）所占的字节大小。

.. function:: eps([type])

   1.0 与下一个稍大的 ``type`` 类型可表示的浮点数之间的距离。有效的类型为 ``Float32`` 和 ``Float64`` 。如果省略 ``type`` ，则返回 ``eps(Float64)`` 。

.. function:: eps(x)

   ``x`` 与下一个稍大的 ``x`` 同类型可表示的浮点数之间的距离。

.. function:: promote_type(type1, type2)

   如果可能的话，给出可以无损表示每个参数类型值的类型。若不存在无损表示时，可以容忍有损；如 ``promote_type(Int64,Float64)`` 返回 ``Float64`` ，尽管严格来说，并非所有的 ``Int64`` 值都可以由 ``Float64`` 无损表示。

通用函数
--------

.. function:: method_exists(f, tuple) -> Bool

   判断指定的通用函数是否有匹配参数类型多元组的方法。

   **例子** ： ``method_exists(length, (Array,)) = true``

.. function:: applicable(f, args...)

   判断指定的通用函数是否有可用于指定参数的方法。

.. function:: invoke(f, (types...), args...)

   对指定的参数，为匹配指定类型（多元组）的通用函数指定要调用的方法。参数应与指定的类型兼容。它允许在最匹配的方法之外，指定一个方法。这对明确需要一个更通用的定义的行为时非常有用（通常作为相同函数的更特殊的方法实现的一部分）。

.. function:: |
   
   对前面的参数应用一个函数，方便写链式函数。

   **例子** ： ``[1:5] | x->x.^2 | sum | inv``

迭代
----

序贯迭代是通过 ``start``, ``done``, 及 ``next`` 方法实现的。通用 ``for`` 循环： ::

    for i = I
      # 代码体
    end

可以重写为： ::

    state = start(I)
    while !done(I, state)
      (i, state) = next(I, state)
      # 代码体
    end

``state`` 对象可为任何东西，每个迭代类型都应选取与其相适应的。

.. function:: start(iter) -> state

   获取可迭代对象的初始迭代状态。

.. function:: done(iter, state) -> Bool

   判断迭代是否完成。

.. function:: next(iter, state) -> item, state

   对指定的可迭代对象和迭代状态，返回当前项和下一个迭代状态。

.. function:: zip(iters...)

   对一组迭代对象，返回一组可迭代多元组，其中第 ``i`` 个多元组包含每个可迭代输入的第 ``i`` 个分量。

   注意 ``zip`` 是它自己的逆操作： [zip(zip(a...)...)...] == [a...]


完全实现的有： ``Range``, ``Range1``, ``NDRange``, ``Tuple``, ``Real``, ``AbstractArray``, ``IntSet``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``EachLine``, ``String``, ``Set``, ``Task``.

通用集合
--------

.. function:: isempty(collection) -> Bool

   判断集合是否为空（没有元素）。

.. function:: empty!(collection) -> collection

   移除集合中的所有元素。

.. function:: length(collection) -> Integer

   对可排序、可索引的集合，用于 ``ref(collection, i)`` 最大索引值 ``i`` 是有效的。对不可排序的集合，结果为元素个数。

.. function:: endof(collection) -> Integer

   返回集合的最后一个索引值。
   
   **例子** ： ``endof([1,2,4]) = 3``

完全实现的有： ``Range``, ``Range1``, ``Tuple``, ``Number``, ``AbstractArray``, ``IntSet``, ``Dict``, ``WeakKeyDict``, ``String``, ``Set``.

可迭代集合
----------

.. function:: contains(itr, x) -> Bool

   判断集合是否包含指定值 ``x`` 。

.. function:: findin(a, b)

   返回曾在集合 ``b`` 中出现的，集合 ``a``  中元素的索引值。

.. function:: unique(itr)

   返回 ``itr`` 中去除多余重复元素的数组。

.. function:: reduce(op, v0, itr)

   使用指定的运算符约简指定集合， ``v0`` 为约简的初始值。一些常用运算符的缩减，有更简便的单参数格式： ``max(itr)``, ``min(itr)``, ``sum(itr)``, ``prod(itr)``, ``any(itr)``, ``all(itr)``.

.. function:: max(itr)

   返回集合中最大的元素。

.. function:: min(itr)

   返回集合中最小的元素。

.. function:: indmax(itr) -> Integer

   返回集合中最大的元素的索引值。

.. function:: indmin(itr) -> Integer

   返回集合中最小的元素的索引值。

.. function:: findmax(itr) -> (x, index)

   返回最大的元素及其索引值。

.. function:: findmin(itr) -> (x, index)

   返回最小的元素及其索引值。

.. function:: sum(itr)

   返回集合中所有元素的和。

.. function:: prod(itr)

   返回集合中所有元素的乘积。

.. function:: any(itr) -> Bool

   判断布尔值集合中是否有为真的元素。

.. function:: all(itr) -> Bool

   判断布尔值集合中是否所有的元素都为真。

.. function:: count(itr) -> Integer

   ``itr`` 中为真的布尔值元素的个数。

.. function:: countp(p, itr) -> Integer

   ``itr`` 中断言 ``p`` 为真的布尔值元素的个数。

.. function:: any(p, itr) -> Bool

   判断 ``itr`` 中是否存在使指定断言为真的元素。

.. function:: all(p, itr) -> Bool

   判断 ``itr`` 中是否所有元素都使指定断言为真。

.. function:: map(f, c) -> collection

   使用 ``f`` 遍历集合 ``c`` 的每个元素。

   **例子** ： ``map((x) -> x * 2, [1, 2, 3]) = [2, 4, 6]``

.. function:: map!(function, collection)

   :func:`map` 的原地版本。

.. function:: mapreduce(f, op, itr)

   使用 ``f`` 遍历集合 ``c`` 的每个元素，然后使用二元函数 ``op`` 对结果进行约简。

   **例子** ： ``mapreduce(x->x^2, +, [1:3]) == 1 + 4 + 9 == 14``

.. function:: first(coll)

   获取可排序集合的第一个元素。

.. function:: last(coll)

   获取可排序集合的最后一个元素。
   
可索引集合
----------

.. function:: ref(collection, key...)
              collection[key...]

   取回集合中存储在指定 key 键或索引值内的值。

.. function:: assign(collection, value, key...)
              collection[key...] = value

   将指定值存储在集合的指定 key 键或索引值内。

完全实现的有： ``Array``, ``DArray``, ``AbstractArray``, ``SubArray``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``String``.

部分实现的有： ``Range``, ``Range1``, ``Tuple``.

关联性集合
----------

字典 ``Dict`` 是标准关联性集合。它的实现中，key 键使用 ``hash(x)`` 作为其哈希函数，使用 ``isequal(x,y)`` 判断是否相等。为自定义类型定义这两个函数，可覆盖它们如何存储在哈希表中的细节。

``ObjectIdDict`` 是个特殊的哈希表，它的 key 是对象的 ID 。 ``WeakKeyDict`` 是一种哈希表实现，它的 key 是对象的弱引用，因此即使在哈希表中被引用，它也可能被垃圾回收机制处理。

字典可通过文本化语法构造： ``{"A"=>1, "B"=>2}`` 。使用花括号可以构造 ``Dict{Any,Any}`` 类型的 ``Dict`` 。使用方括号会尝试从 key 和值中推导类型信息（如 ``["A"=>1, "B"=>2]`` 可构造 ``Dict{ASCIIString, Int64}`` ）。使用 ``(KeyType=>ValueType)[...]`` 来指明类型。如 ``(ASCIIString=>Int32)["A"=>1, "B"=>2]`` 。

至于数组， ``Dicts`` 可使用内涵式语法来构造。如 ``{i => f(i) for i = 1:10}`` 。

.. function:: Dict{K,V}()

   使用 K 类型的 key 和 V 类型的值来构造哈希表。

.. function:: has(collection, key)

   判断集合是否含有指定 key 的映射。

.. function:: get(collection, key, default)

   返回指定 key 存储的值；当前没有 key 的映射时，返回默认值。

.. function:: getkey(collection, key, default)

   如果参数 ``key`` 匹配 ``collection`` 中的 key ，将其返回；否在返回 ``default`` 。

.. function:: delete!(collection, key)

   删除集合中指定 key 的映射。

.. function:: empty!(collection)

   删除集合中所有的 key 。

.. function:: keys(collection)

   返回集合中所有 key 组成的数组。

.. function:: values(collection)

   返回集合中所有值组成的数组。

.. function:: collect(collection)

   返回集合中的所有项。对关联性集合，返回 (key, value) 多元组。

.. function:: merge(collection, others...)

   使用指定的集合构造归并集合。

.. function:: merge!(collection, others...)

   将其它集合中的对儿更新进 ``collection`` 。

.. function:: filter(function, collection)

   返回集合的浅拷贝，移除使 ``function`` 函数为假的 (key, value) 对儿。

.. function:: filter!(function, collection)

   更新集合，移除使 ``function`` 函数为假的 (key, value) 对儿。

.. function:: eltype(collection)

   返回集合中包含的 (key,value) 对儿的类型多元组。

.. function:: sizehint(s, n)

   使集合 ``s`` 保留最少 ``n`` 个元素的容量。这样可提高性能。
   
完全实现的有： ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``.

部分实现的有： ``IntSet``, ``Set``, ``EnvHash``, ``Array``.

类集集合
--------

.. function:: add!(collection, key)

   向类集集合添加元素。

.. function:: add_each!(collection, iterable)

   Adds each element in iterable to the collection.

.. function:: Set(x...)

   构造a ``Set`` with the given elements. Should be used instead of ``IntSet`` for sparse integer sets.

.. function:: IntSet(i...)

   构造an ``IntSet`` of the given integers. Implemented as a bit string, and therefore good for dense integer sets.

.. function:: union(s1,s2...)

   构造the union of two or more sets. Maintains order with arrays.

.. function:: union!(s1,s2)

   Constructs the union of IntSets s1 and s2, stores the result in ``s1``.

.. function:: intersect(s1,s2...)

   构造the intersection of two or more sets. Maintains order with arrays.

.. function:: setdiff(s1,s2)

   构造the set of elements in ``s1`` but not ``s2``. Maintains order with arrays.

.. function:: symdiff(s1,s2...)

   构造the symmetric difference of elements in the passed in sets or arrays. Maintains order with arrays.

.. function:: symdiff!(s, n)

   IntSet s is destructively modified to toggle the inclusion of integer ``n``.

.. function:: symdiff!(s, itr)

   For each element in ``itr``, destructively toggle its inclusion in set ``s``.

.. function:: symdiff!(s1, s2)

   构造the symmetric difference of IntSets ``s1`` and ``s2``, storing the result in ``s1``.

.. function:: complement(s)

   返回the set-complement of IntSet s.

.. function:: complement!(s)

   Mutates IntSet s into its set-complement.

.. function:: del_each!(s, itr)

   删除each element of itr in set s in-place.

.. function:: intersect!(s1, s2)

   Intersects IntSets s1 and s2 and overwrites the set s1 with the result. If needed, s1 will be expanded to the size of s2.

完全实现的有： ``IntSet``, ``Set``.

部分实现的有： ``Array``.

双端队列
--------

.. function:: push!(collection, item) -> collection

   在集合尾端插入一项。

.. function:: pop!(collection) -> item

   移除集合的最后一项，并将其返回。

.. function:: unshift!(collection, item) -> collection

   在集合首端插入一项。

.. function:: shift!(collection) -> item

   移除集合首项。

.. function:: insert!(collection, index, item)

   在指定索引值处插入一项。

.. function:: delete!(collection, index) -> item

   移除指定索引值处的项，并返回删除项。

.. function:: delete!(collection, range) -> items
   
   移除指定范围内的项，并返回包含删除项的集合。

.. function:: resize!(collection, n) -> collection

   改变集合的大小，使其可包含 ``n`` 个元素。

.. function:: append!(collection, items) -> collection

   将 ``items`` 元素附加到集合末尾。

完全实现的有： ``Vector`` （即 1 维 ``Array`` ）

字符串
------

.. function:: length(s)

   字符串 ``s`` 中的字符数。

.. function:: collect(string)

   返回 ``string`` 中的字符数组。

.. function:: *
              string(strs...)

   连接字符串。

   **例子** ： ``"Hello " * "world" == "Hello world"``

.. function:: ^

   重复字符串。

   **例子** ： ``"Julia "^3 == "Julia Julia Julia "``

.. function:: string(char...)

   使用指定字符构造字符串。

.. function:: string(x)

   使用 ``print`` 函数的值构造字符串。

.. function:: repr(x)

   使用 ``show`` 函数的值构造字符串。

.. function:: bytestring(::Ptr{Uint8})

   从 C （以 0 结尾的）格式字符串的地址构造一个字符串。它使用了浅拷贝；可以安全释放指针。

.. function:: bytestring(s)

   将字符串转换为连续的字节数组，从而可将它传递给 C 函数。

.. function:: ascii(::Array{Uint8,1})

   从字节数组构造 ASCII 字符串。

.. function:: ascii(s)

   将字符串转换为连续的 ASCII 字符串（所有的字符都是有效的 ASCII 字符）。

.. function:: utf8(::Array{Uint8,1})

   从字节数组构造 UTF-8 字符串。

.. function:: utf8(s)

   将字符串转换为连续的 UTF-8 字符串（所有的字符都是有效的 UTF-8 字符）。

.. function:: is_valid_ascii(s) -> Bool

   如果字符串是有效的 ASCII ，返回真；否则返回假。

.. function:: is_valid_utf8(s) -> Bool

   如果字符串是有效的 UTF-8 ，返回真；否则返回假。

.. function:: check_ascii(s)

   对字符串调用 :func:`is_valid_ascii` 。如果它不是有效的，则抛出错误。

.. function:: check_utf8(s)

   对字符串调用 :func:`is_valid_utf8` 。如果它不是有效的，则抛出错误。

.. function:: byte_string_classify(s)

   如果字符串不是有效的 ASCII 或 UTF-8 ，则返回 0 ；如果是有效的 ASCII，则返回 1 ；如果是有效的 UTF-8，则返回 2 。

.. function:: search(string, char, [i])

   返回 ``string`` 中 ``char`` 的索引值；如果没找到，则返回 0 。第二个参数也可以是字符向量或集合。第三个参数是可选的，它指明起始索引值。

.. function:: ismatch(r::Regex, s::String)

   判断字符串是否匹配指定的正则表达式。
   
.. function:: lpad(string, n, p)

   在字符串左侧填充一系列 ``p`` ，以保证字符串至少有 ``n`` 个字符。

.. function:: rpad(string, n, p)

   在字符串右侧填充一系列 ``p`` ，以保证字符串至少有 ``n`` 个字符。

.. function:: search(string, chars, [start])

   在指定字符串中查找指定字符。第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式（但正则表达式仅用来处理连续字符串，如 ASCII 或 UTF-8 字符串）。第三个参数是可选的，它指明起始索引值。返回值为所找到的匹配序列的索引值范围，它满足 ``s[search(s,x)] == x`` 。如果没有匹配，则返回值为 ``0:-1`` 。

.. function:: replace(string, pat, r[, n])

   查找指定模式 ``pat`` ，并替换为 ``r`` 。如果提供 ``n`` ，则最多替换 ``n`` 次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

.. function:: replace(string, pat, f[, n])

   查找指定模式 ``pat`` ，并替换为 ``f(pat)`` 。如果提供 ``n`` ，则最多替换 ``n`` 次。搜索时，第二个参数可以是单字符、字符向量或集合、字符串、或正则表达式。

.. function:: split(string, [chars, [limit,] [include_empty]])

   返回由指定字符分割符所分割的指定字符串的字符串数组。分隔符可由 ``search`` 的第二个参数所允许的任何格式所指明（如单字符、字符集合、字符串、或正则表达式）。如果省略 ``chars`` ，则它默认为整个空白字符集，且 ``include_empty`` 默认为假。最后两个参数是可选的：它们是结果的最大长度，且由标志位决定是否在结果中包括空域。

.. function:: strip(string, [chars])

   返回去除头部、尾部空白的 ``string`` 。如果提供了字符串 ``chars`` ，则去除字符串中包含的字符。

.. function:: lstrip(string, [chars])

   返回去除头部空白的 ``string`` 。如果提供了字符串 ``chars`` ，则去除字符串中包含的字符。

.. function:: rstrip(string, [chars])

   返回去除尾部空白的 ``string`` 。如果提供了字符串 ``chars`` ，则去除字符串中包含的字符。

.. function:: begins_with(string, prefix)

   如果 ``string`` 以 ``prefix`` 开始，则返回 ``true`` 。

.. function:: ends_with(string, suffix)

   如果 ``string`` 以 ``suffix`` 结尾，则返回 ``true`` 。

.. function:: uppercase(string)

   返回所有字符转换为大写的 ``string`` 。

.. function:: lowercase(string)

   返回所有字符转换为小写的 ``string`` 。

.. function:: join(strings, delim)

   Join an array of strings into a single string, inserting the given delimiter between adjacent strings.

.. function:: chop(string)

   移除字符串的最后一个字符。

.. function:: chomp(string)

   移除字符串最后的换行符。

.. function:: ind2chr(string, i)

   Convert a byte index to a character index

.. function:: chr2ind(string, i)

   Convert a character index to a byte index

.. function:: isvalid(str, i)

   判断指定字符串的第 ``i`` 个索引值处是否是有效字符。

.. function:: nextind(str, i)

   Get the next valid string index after ``i``. 返回``endof(str)+1`` at
   the end of the string.

.. function:: prevind(str, i)

   Get the previous valid string index before ``i``. 返回``0`` at
   the beginning of the string.

.. function:: thisind(str, i)

   Adjust ``i`` downwards until it reaches a valid index for the given string.

.. function:: randstring(len)

   构造a random ASCII string of length ``len``, consisting of upper- and lower-case letters and the digits 0-9

.. function:: charwidth(c)

   Gives the number of columns needed to print a character.

.. function:: strwidth(s)

   Gives the number of columns needed to print a string.
   
.. function:: isalnum(c::Char)

   判断字符是否为字母或数字。

.. function:: isalpha(c::Char)

   判断字符是否为字母。

.. function:: isascii(c::Char)

   判断字符是否属于 ASCII 字符集。

.. function:: isblank(c::Char)

   判断字符是否为 tab 或空格。

.. function:: iscntrl(c::Char)

   判断字符是否为控制字符。

.. function:: isdigit(c::Char)

   判断字符是否为一位数字（0-9）。

.. function:: isgraph(c::Char)

   判断字符是否可打印，且不是空白字符。

.. function:: islower(c::Char)

   判断字符是否为小写字母。

.. function:: isprint(c::Char)

   判断字符是否可打印，包括空白字符。

.. function:: ispunct(c::Char)

   判断字符是否可打印，且既非空白字符也非字母或数字。

.. function:: isspace(c::Char)

   判断字符是否为任意空白字符。

.. function:: isupper(c::Char)

   判断字符是否为大写字母。

.. function:: isxdigit(c::Char)

   判断字符是否为有效的十六进制字符。

I/O
---

.. data:: STDOUT

   指向标准输出流的全局变量。

.. data:: STDERR

   指向标准错误流的全局变量。

.. data:: STDIN

   指向标准输入流的全局变量。

.. function:: open(file_name, [read, write, create, truncate, append]) -> IOStream

   Open a file in a mode specified by five boolean arguments. The default is to open files for reading only. 返回a stream for accessing the file.

.. function:: open(file_name, [mode]) -> IOStream

   Alternate syntax for open, where a string-based mode specifier is used instead of the five booleans. The values of ``mode`` correspond to those from ``fopen(3)`` or Perl ``open``, and are equivalent to setting the following boolean groups:

   ==== =================================
    r    读
    r+   读、写
    w    写、新建、truncate
    w+   读写、新建、truncate
    a    写、新建、追加
    a+   读、写、新建、追加
   ==== =================================


.. function:: open(file_name) -> IOStream

   以只读模式打开文件。

.. function:: open(f::function, args...)

   Apply the function ``f`` to the result of ``open(args...)`` and close the resulting file descriptor upon completion.

   **例子** ： ``open(readall, "file.txt")``

.. function:: memio([size[, finalize::Bool]]) -> IOStream

   构造an in-memory I/O stream, optionally specifying how much initial space is needed.

.. function:: fdio(fd::Integer, [own::Bool]) -> IOStream
              fdio(name::String, fd::Integer, [own::Bool]]) -> IOStream

   构造an ``IOStream`` object from an integer file descriptor. If ``own`` is true, closing this object will close the underlying descriptor. By default, an ``IOStream`` is closed when it is garbage collected. ``name`` allows you to associate the descriptor with a named file.

.. function:: flush(stream)

   Commit all currently buffered writes to the given stream.

.. function:: close(stream)

   Close an I/O stream. Performs a ``flush`` first.

.. function:: write(stream, x)

   Write the canonical binary representation of a value to the given stream.

.. function:: read(stream, type)

   Read a value of the given type from a stream, in canonical binary representation.

.. function:: read(stream, type, dims)

   Read a series of values of the given type from a stream, in canonical binary representation. ``dims`` is either a tuple or a series of integer arguments specifying the size of ``Array`` to return.

.. function:: position(s)

   Get the current position of a stream.

.. function:: seek(s, pos)

   Seek a stream to the given position.

.. function:: seek_end(s)

   Seek a stream to the end.

.. function:: skip(s, offset)

   Seek a stream relative to the current position.

.. function:: eof(stream)

   判断 whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return ``false``. Therefore it is always safe to read one byte after seeing ``eof`` return ``false``.

文本 I/O
--------

.. function:: show(x)

   Write an informative text representation of a value to the current output stream. New types should overload ``show(io, x)`` where the first argument is a stream.

.. function:: print(x)

   Write (to the default output stream) a canonical (un-decorated) text representation of a value if there is one, otherwise call ``show``.

.. function:: println(x)

   使用 :func:`print` 打印 ``x`` ，并接一个换行符。

.. function:: showall(x)

   Show x, printing all elements of arrays

.. function:: dump(x)

   Write a thorough text representation of a value to the current output stream.

.. function:: readall(stream)

   Read the entire contents of an I/O stream as a string.

.. function:: readline(stream)

   Read a single line of text, including a trailing newline character (if one is reached before the end of the input).

.. function:: readuntil(stream, delim)

   Read a string, up to and including the given delimiter byte.

.. function:: readlines(stream)

   Read all lines as an array.

.. function:: each_line(stream)

   构造an iterable object that will yield each line from a stream.

.. function:: readdlm(filename, delim::Char)

   Read a matrix from a text file where each line gives one row, with elements separated by the given delimeter. If all data is numeric, the result will be a numeric array. If some elements cannot be parsed as numbers, a cell array of numbers and strings is returned.

.. function:: readdlm(filename, delim::Char, T::Type)

   Read a matrix from a text file with a given element type. If ``T`` is a numeric type, the result is an array of that type, with any non-numeric elements as ``NaN`` for floating-point types, or zero. Other useful values of ``T`` include ``ASCIIString``, ``String``, and ``Any``.

.. function:: writedlm(filename, array, delim::Char)

   Write an array to a text file using the given delimeter (defaults to comma).

.. function:: readcsv(filename, [T::Type])

   Equivalent to ``readdlm`` with ``delim`` set to comma.

.. function:: writecsv(filename, array)

   Equivalent to ``writedlm`` with ``delim`` set to comma.

内存映射 I/O
------------

.. function:: mmap_array(type, dims, stream, [offset])

   使用内存映射构造数组，数组的值连接到文件。它提供了处理对计算机内存来说过于庞大数据的简便方法。

   ``type`` 决定了如何解释数组中的字节（不使用格式转换）。 ``dims`` 是包含字节大小的多元组。

   文件是由 ``stream`` 指明的。初始化流时，对“只读”数组使用 “r” ，使用 "w+" 新建用于向硬盘写入值的数组。可以选择指明偏移值（单位为字节），用来跳过文件头等。

   **例子** ：  A = mmap_array(Int64, (25,30000), s)

   它将构造一个 25 x 30000 的 Int64 类型的数列，它链接到与流 s 有关的文件上。

.. function:: msync(array)

   对内存映射数组的内存中的版本和硬盘上的版本强制同步。程序员可能不需要调用此函数，因为操作系统在休息时自动同步。但是，如果你担心丢失一个需要很长时间来运算的结果，就可以直接调用此函数。

.. function:: mmap(len, prot, flags, fd, offset)

   mmap 系统调用的低级接口。

.. function:: munmap(pointer, len)

   取消内存映射的低级接口。对于 mmap_array 则不需要直接调用此函数；当数组离开作用域时，会自动取消内存映射。

标准数值类型
------------

``Bool`` ``Int8`` ``Uint8`` ``Int16`` ``Uint16`` ``Int32`` ``Uint32`` ``Int64`` ``Uint64`` ``Float32`` ``Float64`` ``Complex64`` ``Complex128``

数学函数
--------

.. function:: -

   一元减。

.. function:: + - * / \\ ^

   二元加、减、乘、左除、右除、指数运算符。

.. function:: .+ .- .* ./ .\\ .^

   逐元素二元加、减、乘、左除、右除、指数运算符。

.. function:: div(a,b)

   计算 a/b, truncating to an integer

.. function:: fld(a,b)

   Largest integer less than or equal to a/b

.. function:: mod(x,m)

   Modulus after division, returning in the range [0,m)

.. function:: rem
              %

   Remainder after division

.. function:: mod1(x,m)

   Modulus after division, returning in the range (0,m]

.. function:: //

   分数除法。

.. function:: num(x)

   分数 ``x`` 的分子。

.. function:: den(x)

   分数 ``x`` 的分母。

.. function:: << >>

   左移、右移运算符。

.. function:: == != < <= > >=

   比较运算符，用于判断是否相等、不等、小于、小于等于、大于、大于等于。

.. function:: cmp(x,y)

   返回-1, 0, or 1 depending on whether ``x<y``, ``x==y``, or ``x>y``, respectively

.. function:: !

   逻辑非。

.. function:: ~

   Boolean or bitwise not

.. function:: &

   逻辑与。

.. function:: |

   逻辑或。

.. function:: $

   Bitwise exclusive or

.. function:: sin(x)

   计算 ``x`` 的正弦值，其中 ``x`` 的单位为弧度。

.. function:: cos(x)

   计算 ``x`` 的余弦值，其中 ``x`` 的单位为弧度。

.. function:: tan(x)

   计算 ``x`` 的正切值，其中 ``x`` 的单位为弧度。

.. function:: sind(x)

   计算 ``x`` 的正弦值，其中 ``x`` 的单位为度数。

.. function:: cosd(x)

   计算 ``x`` 的余弦值，其中 ``x`` 的单位为度数。

.. function:: tand(x)

   计算 ``x`` 的正切值，其中 ``x`` 的单位为度数。

.. function:: sinh(x)

   计算 ``x`` 的双曲正弦值。

.. function:: cosh(x)

   计算 ``x`` 的双曲余弦值。

.. function:: tanh(x)

   计算 ``x`` 的双曲正切值。

.. function:: asin(x)

   计算 ``x`` 的反正弦值，结果的单位为弧度。

.. function:: acos(x)

   计算 ``x`` 的反余弦值，结果的单位为弧度。

.. function:: atan(x)

   计算 ``x`` 的反正切值，结果的单位为弧度。

.. function:: atan2(y, x)

   计算 ``y/x`` 的反正切值，由 ``x`` 和 ``y`` 的正负号来确定返回值的象限。

.. function:: asind(x)

   计算 ``x`` 的反正弦值，结果的单位为度数。

.. function:: acosd(x)

   计算 ``x`` 的反余弦值，结果的单位为度数。

.. function:: atand(x)

   计算 ``x`` 的反正切值，结果的单位为度数。

.. function:: sec(x)

   计算 ``x`` 的正割值，其中 ``x`` 的单位为弧度。

.. function:: csc(x)

   计算 ``x`` 的余割值，其中 ``x`` 的单位为弧度。

.. function:: cot(x)

   计算 ``x`` 的余切值，其中 ``x`` 的单位为弧度。

.. function:: secd(x)

   计算 ``x`` 的正割值，其中 ``x`` 的单位为度数。

.. function:: cscd(x)

   计算 ``x`` 的余割值，其中 ``x`` 的单位为度数。

.. function:: cotd(x)

   计算 ``x`` 的余切值，其中 ``x`` 的单位为度数。

.. function:: asec(x)

   计算 ``x`` 的反正割值，结果的单位为弧度。

.. function:: acsc(x)

   计算 ``x`` 的反余割值，结果的单位为弧度。

.. function:: acot(x)

   计算 ``x`` 的反余切值，结果的单位为弧度。

.. function:: asecd(x)

   计算 ``x`` 的反正割值，结果的单位为度数。

.. function:: acscd(x)

   计算 ``x`` 的反余割值，结果的单位为度数。

.. function:: acotd(x)

   计算 ``x`` 的反余切值，结果的单位为度数。

.. function:: sech(x)

   计算 ``x`` 的双曲正割值。

.. function:: csch(x)

   计算 ``x`` 的双曲余割值。

.. function:: coth(x)

   计算 ``x`` 的双曲余切值。

.. function:: asinh(x)

   计算 ``x`` 的反双曲正弦值。

.. function:: acosh(x)

   计算 ``x`` 的反双曲余弦值。

.. function:: atanh(x)

   计算 ``x`` 的反双曲正切值。

.. function:: asech(x)

   计算 ``x`` 的反双曲正割值。

.. function:: acsch(x)

   计算 ``x`` 的反双曲余割值。

.. function:: acoth(x)

   计算 ``x`` 的反双曲余切值。

.. function:: sinc(x)

   计算 :math:`sin(\pi x) / x` 。

.. function:: cosc(x)

   计算 :math:`cos(\pi x) / x` 。

.. function:: degrees2radians(x)

   将 ``x`` 度数转换为弧度。

.. function:: radians2degrees(x)

   将 ``x`` 弧度转换为度数。

.. function:: hypot(x, y)

   计算 ``sqrt( (x^2+y^2) )`` ，计算过程不会出现上溢、下溢。

.. function:: log(x)
   
   计算 ``x`` 的自然对数。

.. function:: log2(x)

   计算 ``x`` 以 2 为底的对数。

.. function:: log10(x)

   计算 ``x`` 以 10 为底的对数。

.. function:: log1p(x)

   ``1+x`` 自然对数的精确值。

.. function:: logb(x)

   返回浮点数 ``trunc( log2( abs(x) ) )`` 。

.. function:: ilogb(x) 

   :func:`logb` 的返回值为整数的版本。

.. function:: frexp(val, exp)

   返回a number ``x`` such that it has a magnitude in the interval ``[1/2, 1)`` or 0,
   and val = :math:`x \times 2^{exp}`.

.. function:: exp(x)

   计算 ``e^x`` 。

.. function:: exp2(x)

   计算 ``2^x`` 。

.. function:: ldexp(x, n)

   计算 :math:`x \times 2^n` 。

.. function:: modf(x)

   返回一个数的小数部分和整数部分的多元组。两部分都与参数同正负号。

.. function:: expm1(x)

   ``e^x-1`` 的精确值。

.. function:: square(x)

   计算 ``x^2`` 。

.. function:: round(x, [digits, [base]]) -> FloatingPoint

   ``round(x)`` 返回离 ``x`` 最近的整数。 ``round(x, digits)`` rounds to the specified number of digits after the decimal place, or before if negative, e.g., ``round(pi,2)`` is ``3.14``. ``round(x, digits, base)`` rounds using a different base, defaulting to 10, e.g., ``round(pi, 3, 2)`` is ``3.125``.

.. function:: ceil(x, [digits, [base]]) -> FloatingPoint

   将 ``x`` 向 +Inf 取整。 ``digits`` 与 ``base`` 的解释参见 :func:`round` 。

.. function:: floor(x, [digits, [base]]) -> FloatingPoint

   将 ``x`` 向 -Inf 取整。 ``digits`` 与 ``base`` 的解释参见 :func:`round` 。

.. function:: trunc(x, [digits, [base]]) -> FloatingPoint

   将 ``x`` 向 0 取整。 ``digits`` 与 ``base`` 的解释参见 :func:`round` 。

.. function:: iround(x) -> Integer

   结果为整数类型的 :func:`round` 。

.. function:: iceil(x) -> Integer

   结果为整数类型的 :func:`ceil` 。

.. function:: ifloor(x) -> Integer

   结果为整数类型的 :func:`floor` 。

.. function:: itrunc(x) -> Integer

   结果为整数类型的 :func:`trunc` 。

.. function:: signif(x, digits, [base]) -> FloatingPoint

   Rounds (in the sense of ``round``) ``x`` so that there are ``digits`` significant digits, under a base ``base`` representation, default 10. E.g., ``signif(123.456, 2)`` is ``120.0``, and ``signif(357.913, 4, 2)`` is ``352.0``. 

.. function:: min(x, y)

   返回 ``x`` 和 ``y`` 的最小值。

.. function:: max(x, y)

   返回 ``x`` 和 ``y`` 的最大值。

.. function:: clamp(x, lo, hi)

   返回 x if ``lo <= x <= y``. If ``x < lo``, return ``lo``. If ``x > hi``, return ``hi``.

.. function:: abs(x)

   ``x`` 的绝对值。

.. function:: abs2(x)

   ``x`` 绝对值的平方。

.. function:: copysign(x, y)

   返回 ``x`` such that it has the same sign as ``y``

.. function:: sign(x)

   如果 ``x`` 是正数时返回 ``+1`` ， ``x == 0`` 时返回 ``0`` ， ``x`` 是负数时返回 ``-1`` 。

.. function:: signbit(x)

   如果 ``x`` 是负数时返回 ``1`` ，否则返回 ``0`` 。

.. function:: flipsign(x, y)

   如果 ``y`` 为复数，返回 ``x`` 的相反数，否则返回 ``x`` 。如 ``abs(x) = flipsign(x,x)``.

.. function:: sqrt(x)
   
   返回 :math:`\sqrt{x}` 。

.. function:: cbrt(x)

   返回 :math:`x^{1/3}` 。

.. function:: erf(x)

   计算 ``x`` 的误差函数，defined by
   :math:`\frac{2}{\sqrt{\pi}} \int_0^x e^{-t^2} dt`
   for arbitrary complex ``x``.

.. function:: erfc(x)

   计算the complementary error function of ``x``,
   defined by :math:`1 - \operatorname{erf}(x)`.

.. function:: erfcx(x)

   计算the scaled complementary error function of ``x``,
   defined by :math:`e^{x^2} \operatorname{erfc}(x)`.  Note
   also that :math:`\operatorname{erfcx}(-ix)` computes the
   Faddeeva function ``w(x)``.

.. function:: erfi(x)

   计算the imaginary error function of ``x``,
   defined by :math:`-i \operatorname{erf}(ix)`.

.. function:: dawson(x)

   计算the Dawson function (scaled imaginary error function) of ``x``,
   defined by :math:`\frac{\sqrt{\pi}}{2} e^{-x^2} \operatorname{erfi}(x)`.

.. function:: real(z)

   返回复数 ``z`` 的实数部分。

.. function:: imag(z)

   返回复数 ``z`` 的虚数部分。

.. function:: reim(z)

   返回复数 ``z`` 的整数部分和虚数部分。

.. function:: conj(z)

   计算复数 ``z`` 的共轭。

.. function:: angle(z)

   计算复数 ``z`` 的相位角。

.. function:: cis(z)

   如果 ``z`` 是实数，返回 ``cos(z) + i*sin(z)`` 。如果 ``z`` 是实数，返回 ``(cos(real(z)) + i*sin(real(z)))/exp(imag(z))`` 。

.. function:: binomial(n,k)

   从  ``n`` 项中选取 ``k`` 项，有多少种方法。

.. function:: factorial(n)

   n 的阶乘。

.. function:: factorial(n,k)

   计算 ``factorial(n)/factorial(k)``

.. function:: factor(n)

   对 ``n`` 分解质因数。返回a dictionary. The keys of the dictionary correspond to the factors, and hence are of the same type as ``n``. The value associated with each key indicates the number of times the factor appears in the factorization.

   **例子** ： ``100=2*2*5*5`` ，因此 ``factor(100) -> [5=>2,2=>2]`` 

.. function:: gcd(x,y)

   最大公因数。

.. function:: lcm(x,y)

   最小公倍数。

.. function:: gcdx(x,y)

   Greatest common divisor, also returning integer coefficients ``u`` and ``v`` that solve ``ux+vy == gcd(x,y)``

.. function:: ispow2(n)

   Test whether ``n`` is a power of two

.. function:: nextpow2(n)

   Next power of two not less than ``n``

.. function:: prevpow2(n)

   Previous power of two not greater than ``n``

.. function:: nextpow(a, n)

   Next power of ``a`` not less than ``n``

.. function:: prevpow(a, n)

   Previous power of ``a`` not greater than ``n``

.. function:: nextprod([a,b,c], n)

   Next integer not less than ``n`` that can be written ``a^i1 * b^i2 * c^i3`` for integers ``i1``, ``i2``, ``i3``.

.. function:: prevprod([a,b,c], n)

   Previous integer not greater than ``n`` that can be written ``a^i1 * b^i2 * c^i3`` for integers ``i1``, ``i2``, ``i3``.

.. function:: invmod(x,m)

   Inverse of ``x``, modulo ``m``

.. function:: powermod(x, p, m)

   计算 ``mod(x^p, m)`` 。

.. function:: gamma(x)

   计算 ``x`` 的 gamma 函数。

.. function:: lgamma(x)

   计算the logarithm of ``gamma(x)``

.. function:: lfact(x)

   计算the logarithmic factorial of ``x``

.. function:: digamma(x)

   计算the digamma function of ``x`` (the logarithmic derivative of ``gamma(x)``)

.. function:: airy(x)
              airyai(x)

   Airy 函数 :math:`\operatorname{Ai}(x)`.

.. function:: airyprime(x)
              airyaiprime(x)

   Airy 函数 derivative :math:`\operatorname{Ai}'(x)`.

.. function:: airybi(x)

   Airy 函数 :math:`\operatorname{Bi}(x)`.

.. function:: airybiprime(x)

   Airy 函数 derivative :math:`\operatorname{Bi}'(x)`.

.. function:: besselj0(x)

   Bessel 函数 of the first kind of order 0, :math:`J_0(x)`.

.. function:: besselj1(x)

   Bessel 函数 of the first kind of order 1, :math:`J_1(x)`.

.. function:: besselj(nu, x)

   Bessel 函数 of the first kind of order ``nu``, :math:`J_\nu(x)`.

.. function:: bessely0(x)

   Bessel 函数 of the second kind of order 0, :math:`Y_0(x)`.

.. function:: bessely1(x)

   Bessel 函数 of the second kind of order 1, :math:`Y_1(x)`.

.. function:: bessely(nu, x)

   Bessel 函数 of the second kind of order ``nu``, :math:`Y_\nu(x)`.

.. function:: hankelh1(nu, x)

   Bessel 函数 of the third kind of order ``nu``, :math:`H^{(1)}_\nu(x)`.

.. function:: hankelh2(nu, x)

   Bessel 函数 of the third kind of order ``nu``, :math:`H^{(2)}_\nu(x)`.

.. function:: besseli(nu, x)

   Modified Bessel 函数 of the first kind of order ``nu``, :math:`I_\nu(x)`.

.. function:: besselk(nu, x)

   Modified Bessel 函数 of the second kind of order ``nu``, :math:`K_\nu(x)`.

.. function:: beta(x, y)

   Euler integral of the first kind :math:`\operatorname{B}(x,y) = \Gamma(x)\Gamma(y)/\Gamma(x+y)`.

.. function:: lbeta(x, y)

   Natural logarithm of the beta function :math:`\log(\operatorname{B}(x,y))`.

.. function:: eta(x)

   Dirichlet eta 函数 :math:`\eta(s) = \sum^\infty_{n=1}(-)^{n-1}/n^{s}` 。

.. function:: zeta(x)

   Riemann zeta 函数 ``\zeta(s)`` 。

.. function:: bitmix(x, y)

   Hash two integers into a single integer. Useful for constructing hash
   functions.

.. function:: ndigits(n, b)

   计算the number of digits in number ``n`` written in base ``b``.

数据格式
--------

.. function:: bin(n, [pad])

   将整数转换为二进制字符串，可选择性指明空白补位后的位数。

.. function:: hex(n, [pad])

   将整数转换为十六进制字符串，可选择性指明空白补位后的位数。

.. function:: dec(n, [pad])

   将整数转换为十进制字符串，可选择性指明空白补位后的位数。

.. function:: oct(n, [pad])

   将整数转换为八进制字符串，可选择性指明空白补位后的位数。

.. function:: base(b, n, [pad])

   将整数 ``n`` 转换为指定进制 ``b`` 的字符串，可选择性指明空白补位后的位数。

.. function:: bits(n)

   A string giving the literal bit representation of a number.

.. function:: parse_int(type, str, [base])

   Parse a string as an integer in the given base (default 10), yielding a number of the specified type.

.. function:: parse_bin(type, str)

   Parse a string as an integer in base 2, yielding a number of the specified type.

.. function:: parse_oct(type, str)

   Parse a string as an integer in base 8, yielding a number of the specified type.

.. function:: parse_hex(type, str)

   Parse a string as an integer in base 16, yielding a number of the specified type.

.. function:: parse_float(type, str)

   Parse a string as a decimal floating point number, yielding a number of the specified type.

.. function:: bool(x)

   将数或数值数组转换为布尔值类型的。

.. function:: isbool(x)

   判断数或数组是否是布尔值类型的。

.. function:: int(x)

   Convert a number or array to the default integer type on your platform. Alternatively, ``x`` can be a string, which is parsed as an integer.

.. function:: uint(x)

   Convert a number or array to the default unsigned integer type on your platform. Alternatively, ``x`` can be a string, which is parsed as an unsigned integer.

.. function:: integer(x)

   Convert a number or array to integer type. If ``x`` is already of integer type it is unchanged, otherwise it converts it to the default integer type on your platform.

.. function:: isinteger(x)

   判断数或数组是否为整数类型的。

.. function:: signed(x)

   将数转换为有符号整数。

.. function:: unsigned(x)

   将数转换为无符号整数。

.. function:: int8(x)

   将数或数组转换为 ``Int8`` 数据类型。

.. function:: int16(x)

   将数或数组转换为 ``Int16`` 数据类型。

.. function:: int32(x)

   将数或数组转换为 ``Int32`` 数据类型。

.. function:: int64(x)

   将数或数组转换为 ``Int64`` 数据类型。

.. function:: int128(x)

   将数或数组转换为 ``Int128`` 数据类型。

.. function:: uint8(x)

   将数或数组转换为 ``Uint8`` 数据类型。

.. function:: uint16(x)

   将数或数组转换为 ``Uint16`` 数据类型。

.. function:: uint32(x)

   将数或数组转换为 ``Uint32`` 数据类型。

.. function:: uint64(x)

   将数或数组转换为 ``Uint64`` 数据类型。

.. function:: uint128(x)

   将数或数组转换为 ``Uint128`` 数据类型。

.. function:: float32(x)

   将数或数组转换为 ``Float32`` 数据类型。

.. function:: float64(x)

   将数或数组转换为 ``Float64`` 数据类型。

.. function:: float(x)

   将数、数组、或字符串转换为 ``FloatingPoint`` 数据类型。对数值数据，使用最小的恰当 ``FloatingPoint`` 类型。对字符串，它将被转换为 ``Float64`` 类型。

.. function:: significand(x)

   Extract the significand(s) (a.k.a. mantissa), in binary representation, of a floating-point number or array.
   
   例如， ``significand(15.2)/15.2 == 0.125`` 与``significand(15.2)*8 == 15.2`` 。

.. function:: float64_valued(x::Rational)

   如果 ``x`` 能被无损地用 ``Float64`` 数据类型表示，返回真。

.. function:: complex64(r,i)

   构造值为 ``r+i*im`` 的 ``Complex64`` 数据类型。

.. function:: complex128(r,i)

   构造值为 ``r+i*im`` 的 ``Complex128`` 数据类型。

.. function:: char(x)

   将数或数组转换为 ``Char`` 数据类型。

.. function:: safe_char(x)

   转换为 ``Char`` ，同时检查是否为有效码位。

.. function:: complex(r,i)

   将实数或数组转换为复数。

.. function:: iscomplex(x) -> Bool

   判断数或数组是否为复数类型。

.. function:: isreal(x) -> Bool

   判断数或数组是否为实数类型。

.. function:: bswap(n)

   Byte-swap an integer

.. function:: num2hex(f)

   Get a hexadecimal string of the binary representation of a floating point number

.. function:: hex2num(str)

   Convert a hexadecimal string to the floating point number it represents

数
--

.. function:: one(x)

   Get the multiplicative identity element for the type of x (x can also specify the type itself). For matrices, returns an identity matrix of the appropriate size and type.

.. function:: zero(x)

   Get the additive identity element for the type of x (x can also specify the type itself).

.. data:: pi

   常量 pi 。

.. function:: isdenormal(f) -> Bool

   Test whether a floating point number is denormal

.. function:: isfinite(f) -> Bool

   判断数是否有限。

.. function:: isinf(f)

   判断数是否为无穷大或无穷小。

.. function:: isnan(f)

   判断浮点数是否为非数值（NaN）。

.. function:: inf(f)

   返回与 ``f`` 相同浮点数类型的无穷大（ ``f`` 也可以为类型）。

.. function:: nan(f)

   返回与 ``f`` 相同浮点数类型的 NaN （ ``f`` 也可以为类型）。

.. function:: nextfloat(f)

   Get the next floating point number in lexicographic order

.. function:: prevfloat(f) -> Float

   Get the previous floating point number in lexicographic order

.. function:: integer_valued(x)

   判断 ``x`` 在数值上是否为整数。

.. function:: real_valued(x)

   判断 ``x`` 在数值上是否为实数。

.. function:: exponent(f)

   Get the exponent of a floating-point number

.. function:: mantissa(f)

   Get the mantissa of a floating-point number

.. function:: BigInt(x)

   构造任意精度的整数。 ``x`` 可以是 ``Int`` （或可以被转换为 ``Int`` 的）或 ``String`` 。可以对其使用常用的数学运算符，结果被提升为 ``BigInt`` 类型。

.. function:: BigFloat(x)

   构造任意精度的浮点数。 ``x`` 可以是 ``Integer``, ``Float64``, ``String`` 或 ``BigInt`` 。可以对其使用常用的数学运算符，结果被提升为 ``BigFloat`` 类型。

整数
~~~~

.. function:: count_ones(x::Integer) -> Integer

   Number of ones in the binary representation of ``x``.
   
   **例子** ： ``count_ones(7) -> 3``

.. function:: count_zeros(x::Integer) -> Integer

   Number of zeros in the binary representation of ``x``.
   
   **例子** ： ``count_zeros(int32(2 ^ 16 - 1)) -> 16``

.. function:: leading_zeros(x::Integer) -> Integer

   Number of zeros leading the binary representation of ``x``.
   
   **例子** ： ``leading_zeros(int32(1)) -> 31``

.. function:: leading_ones(x::Integer) -> Integer

   Number of ones leading the binary representation of ``x``.
   
   **例子** ： ``leading_ones(int32(2 ^ 32 - 2)) -> 31``

.. function:: trailing_zeros(x::Integer) -> Integer

   Number of zeros trailing the binary representation of ``x``.
   
   **例子** ： ``trailing_zeros(2) -> 1``

.. function:: trailing_ones(x::Integer) -> Integer

   Number of ones trailing the binary representation of ``x``.
   
   **例子** ： ``trailing_ones(3) -> 2``

.. function:: isprime(x::Integer) -> Bool

   返回``true`` if ``x`` is prime, and ``false`` otherwise.

   **例子** ： ``isprime(3) -> true``

.. function:: isodd(x::Integer) -> Bool

   返回``true`` if ``x`` is odd (that is, not divisible by 2), and ``false`` otherwise.

   **例子** ： ``isodd(9) -> false``

.. function:: iseven(x::Integer) -> Bool

   返回``true`` is ``x`` is even (that is, divisible by 2), and ``false`` otherwise.

   **例子** ： ``iseven(1) -> false``


随机数
------

Julia 使用 `Mersenne Twister 库 <http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/#dSFMT>`_ 来生成随机数。Julia 默认使用全局随机数生成器 RNG 。Multiple RNGs can be plugged in using the ``AbstractRNG`` object, which can then be used to have multiple streams of random numbers.目前只支持 ``MersenneTwister`` 。

.. function:: srand([rng], seed)

   Seed the RNG with a ``seed``, which may be an unsigned integer or a vector of unsigned integers. ``seed`` can even be a filename, in which case the seed is read from a file. If the argument ``rng`` is not provided, the default global RNG is seeded.

.. function:: MersenneTwister([seed])

   构造a ``MersenneTwister`` RNG object. Different RNG objects can have their own seeds, which may be useful for generating different streams of random numbers.

.. function:: rand()

   生成 (0,1) 内的 ``Float64`` 随机数。

.. function:: rand!([rng], A)

   Populate the array A with random number generated from the specified RNG.

.. function:: rand(rng::AbstractRNG, [dims...])

   Generate a random ``Float64`` number or array of the size specified by dims, using the specified RNG object. Currently, ``MersenneTwister`` is the only available Random Number Generator (RNG), which may be seeded using srand.

.. function:: rand(dims...)

   Generate a random ``Float64`` array of the size specified by dims

.. function:: rand(Int32|Uint32|Int64|Uint64|Int128|Uint128, [dims...])

   Generate a random integer of the given type. Optionally, generate an array of random integers of the given type by specifying dims.

.. function:: rand(r, [dims...])

   Generate a random integer from ``1``:``n`` inclusive. Optionally, generate a random integer array.

.. function:: randbool([dims...])

   Generate a random boolean value. Optionally, generate an array of random boolean values.

.. function:: randbool!(A)

   Fill an array with random boolean values. A may be an ``Array`` or a ``BitArray``.   

.. function:: randn([dims...])

   Generate a normally-distributed random number with mean 0 and standard deviation 1. Optionally generate an array of normally-distributed random numbers.

数组
----

基础函数
~~~~~~~~

.. function:: ndims(A) -> Integer

   返回 A 有几个维度。

.. function:: size(A)

   返回 A 的维度多元组。

.. function:: eltype(A)

   返回 A 中元素的类型。

.. function:: length(A) -> Integer

   返回the number of elements in A (note that this differs from MATLAB where ``length(A)`` is the largest dimension of ``A``)

.. function:: nnz(A)

   A 中非零元素的个数。

.. function:: scale!(A, k)

   Scale the contents of an array A with k (in-place)
   
.. function:: conj!(A)

   Convert an array to its complex conjugate in-place

.. function:: stride(A, k)

   返回the distance in memory (in number of elements) between adjacent elements in dimension k

.. function:: strides(A)

   返回a tuple of the memory strides in each dimension

构造函数
~~~~~~~~

.. function:: Array(type, dims)

   构造an uninitialized dense array. ``dims`` may be a tuple or a series of integer arguments.

.. function:: ref(type)

   构造an empty 1-d array of the specified type. This is usually called with the syntax ``Type[]``. Element values can be specified using ``Type[a,b,c,...]``.

.. function:: cell(dims)

   构造an uninitialized cell array (heterogeneous array). ``dims`` can be either a tuple or a series of integer arguments.
   
.. function:: zeros(type, dims)

   构造指定类型的全零数组。

.. function:: ones(type, dims)

   构造指定类型的全一数组。

.. function:: trues(dims)

   构造元素全为真的布尔值数组。

.. function:: falses(dims)

   构造元素全为假的布尔值数组。

.. function:: fill(v, dims)

   构造数组，元素都初始化为 ``v`` 。

.. function:: fill!(A, x)

   将数组 ``A`` 的元素都改为 ``x`` 。

.. function:: reshape(A, dims)

   构造an array with the same data as the given array, but with different dimensions. An implementation for a particular type of array may choose whether the data is copied or shared.

.. function:: copy(A)

   构造a copy of ``A``

.. function:: similar(array, element_type, dims)

   构造an uninitialized array of the same type as the given array, but with the specified element type and dimensions. The second and third arguments are both optional. The ``dims`` argument may be a tuple or a series of integer arguments.

.. function:: reinterpret(type, A)

   构造an array with the same binary data as the given array, but with the specified element type

.. function:: rand(dims)

   构造a random array with Float64 random values in (0,1)

.. function:: randf(dims)

   构造a random array with Float32 random values in (0,1)

.. function:: randn(dims)

   构造a random array with Float64 normally-distributed random values with a mean of 0 and standard deviation of 1

.. function:: eye(n)

   n x n 单位矩阵。

.. function:: eye(m, n)

   m x n 单位矩阵。

.. function:: linspace(start, stop, n)

   构造a vector of ``n`` linearly-spaced elements from ``start`` to ``stop``.

.. function:: logspace(start, stop, n)

   构造a vector of ``n`` logarithmically-spaced numbers from ``10^start`` to ``10^stop``.

数学运算符和函数
~~~~~~~~~~~~~~~~

数组可以使用所有的数学运算和函数。

.. function:: bsxfun(fn, A, B[, C...])

   对两个或两个以上的数组使用二元函数 ``fn`` ，它会展开单态的维度。

索引，赋值和连接
~~~~~~~~~~~~~~~~

.. function:: ref(A, ind)

   返回a subset of ``A`` as specified by ``ind``, 结果可能是 ``Int``, ``Range``, 或 ``Vector`` 。

.. function:: sub(A, ind)

   返回a SubArray, which stores the input ``A`` and ``ind`` rather than computing the result immediately. Calling ``ref`` on a SubArray computes the indices on the fly.

.. function:: slicedim(A, d, i)

   返回all the data of ``A`` where the index for dimension ``d`` equals ``i``. Equivalent to ``A[:,:,...,i,:,:,...]`` where ``i`` is in position ``d``.

.. function:: assign(A, X, ind)

   Store an input array ``X`` within some subset of ``A`` as specified by ``ind``.

.. function:: cat(dim, A...)

   Concatenate the input arrays along the specified dimension

.. function:: vcat(A...)

   在维度 1 上连接。

.. function:: hcat(A...)

   在维度 2 上连接。

.. function:: hvcat

   Horizontal and vertical concatenation in one call

.. function:: flipdim(A, d)

   Reverse ``A`` in dimension ``d``.

.. function:: flipud(A)

   等价于 ``flipdim(A,1)`` 。

.. function:: fliplr(A)

   等价于 ``flipdim(A,2)`` 。

.. function:: circshift(A,shifts)

   Circularly shift the data in an array. The second argument is a vector giving the amount to shift in each dimension.

.. function:: find(A)

   返回a vector of the linear indexes of the non-zeros in ``A``.

.. function:: findn(A)

   返回a vector of indexes for each dimension giving the locations of the non-zeros in ``A``.
   
.. function:: nonzeros(A)

   Return a vector of the non-zero values in array ``A``.

.. function:: findfirst(A)

   Return the index of the first non-zero value in ``A``.

.. function:: findfirst(A,v)

   Return the index of the first element equal to ``v`` in ``A``.

.. function:: findfirst(predicate, A)

   Return the index of the first element that satisfies the given predicate in ``A``.

.. function:: permutedims(A,perm)

   Permute the dimensions of array ``A``. ``perm`` is a vector specifying a permutation of length ``ndims(A)``. This is a generalization of transpose for multi-dimensional arrays. Transpose is equivalent to ``permute(A,[2,1])``.

.. function:: ipermutedims(A,perm)

   Like :func:`permutedims`, except the inverse of the given permutation is applied.

.. function:: squeeze(A, dims)

   移除the dimensions specified by ``dims`` from array ``A``

.. function:: vec(Array) -> Vector

   Vectorize an array using column-major convention.

数组函数
~~~~~~~~

.. function:: cumprod(A, [dim])

   Cumulative product along a dimension.

.. function:: cumsum(A, [dim])

   Cumulative sum along a dimension.
   
.. function:: cumsum_kbn(A, [dim])

   Cumulative sum along a dimension, using the Kahan-Babuska-Neumaier compensated summation algorithm for additional accuracy.

.. function:: cummin(A, [dim])

   Cumulative minimum along a dimension.

.. function:: cummax(A, [dim])

   Cumulative maximum along a dimension.

.. function:: diff(A, [dim])

   Finite difference operator of matrix or vector.

.. function:: rot180(A)

   Rotate matrix ``A`` 180 degrees.

.. function:: rotl90(A)

   Rotate matrix ``A`` left 90 degrees.

.. function:: rotr90(A)

   Rotate matrix ``A`` right 90 degrees.

.. function:: reducedim(f, A, dims, initial)

   Reduce 2-argument function ``f`` along dimensions of ``A``. ``dims`` is a
   vector specifying the dimensions to reduce, and ``initial`` is the initial
   value to use in the reductions.
   
.. function:: sum_kbn(A)

   Returns the sum of all array elements, using the Kahan-Babuska-Neumaier compensated summation algorithm for additional accuracy.

稀疏矩阵
--------

稀疏矩阵支持大部分稠密矩阵的对应操作。下列函数仅适用于稀疏矩阵。

.. function:: sparse(I,J,V,[m,n,combine])

   构造a sparse matrix ``S`` of dimensions ``m x n`` such that ``S[I[k], J[k]] = V[k]``. The ``combine`` function is used to combine duplicates. If ``m`` and ``n`` are not specified, they are set to ``max(I)`` and ``max(J)`` respectively. If the ``combine`` function is not supplied, duplicates are added by default.

.. function:: sparsevec(I, V, [m, combine])

   构造a sparse matrix ``S`` of size ``m x 1`` such that ``S[I[k]] = V[k]``. Duplicates are combined using the ``combine`` function, which defaults to `+` if it is not provided. In julia, sparse vectors are really just sparse matrices with one column. Given Julia's Compressed Sparse Columns (CSC) storage format, a sparse column matrix with one column is sparse, whereas a sparse row matrix with one row ends up being dense.

.. function:: sparsevec(D::Dict, [m])

   构造a sparse matrix of size ``m x 1`` where the row values are keys from the dictionary, and the nonzero values are the values from the dictionary.

.. function:: issparse(S)

   返回 ``true`` if ``S`` is sparse, 否则为 ``false`` 。

.. function:: nnz(S)

   返回the number of nonzeros in ``S``.

.. function:: sparse(A)

   将稠密矩阵 ``A`` 转换为稀疏矩阵。

.. function:: sparsevec(A)

   将稠密矩阵 ``A`` 转换为 ``m x 1`` 的稀疏矩阵。在 Julia 中，稀疏向量是只有一列的稀疏矩阵。

.. function:: dense(S)

   将稀疏矩阵 ``S`` 转换为稠密矩阵。

.. function:: full(S)

   将稀疏矩阵 ``S`` 转换为稠密矩阵。

.. function:: spzeros(m,n)

   构造 ``m x n`` 的空稀疏矩阵。

.. function:: speye(type,m[,n])

   构造a sparse identity matrix of specified type of size ``m x m``. In case ``n`` is supplied, create a sparse identity matrix of size ``m x n``.

.. function:: spones(S)

   构造a sparse matrix with the same structure as that of ``S``, but with every nonzero element having the value ``1.0``.

.. function:: sprand(m,n,density[,rng])

   构造a random sparse matrix with the specified density. Nonzeros are sampled from the distribution specified by ``rng``. The uniform distribution is used in case ``rng`` is not specified.

.. function:: sprandn(m,n,density)

   构造a random sparse matrix of specified density with nonzeros sampled from the normal distribution.

.. function:: sprandbool(m,n,density)

   构造a random sparse boolean matrix with the specified density.


线性代数
--------

Julia 中的线性代数函数，大部分调用的是 `LAPACK <http://www.netlib.org/lapack/>`_ 中的函数。

.. function:: *

   矩阵乘法。

.. function:: \

   Matrix division using a polyalgorithm. For input matrices ``A`` and ``B``, the result ``X`` is such that ``A*X == B``. For rectangular ``A``, QR factorization is used. For triangular ``A``, a triangular solve is performed. For square ``A``, Cholesky factorization is tried if the input is symmetric with a heavy diagonal. LU factorization is used in case Cholesky factorization fails or for general square inputs. If ``size(A,1) > size(A,2)``, the result is a least squares solution of ``A*X+eps=B`` using the singular value decomposition. ``A`` does not need to have full rank.

.. function:: dot

   计算点积。

.. function:: cross

   计算the cross product of two 3-vectors

.. function:: norm

   计算 ``Vector`` 或 ``Matrix`` 的模。

.. function:: factors(F)

   返回the factors of a factorization ``F``. For example, in the case of an LU decomposition, factors(LU) -> L, U, P

.. function:: lu(A) -> L, U, P

   计算the LU factorization of ``A``, such that ``A[P,:] = L*U``.

.. function:: lufact(A) -> LUDense

   计算the LU factorization of ``A`` and return a ``LUDense`` object. ``factors(lufact(A))`` returns the triangular matrices containing the factorization. The following functions are available for ``LUDense`` objects: ``size``, ``factors``, ``\``, ``inv``, ``det``.

.. function:: lufact!(A) -> LUDense

   ``lufact!`` 与 ``lufact`` 相同，but saves space by overwriting the input A, instead of creating a copy.

.. function:: chol(A, [LU]) -> F

   计算Cholesky factorization of a symmetric positive-definite matrix ``A`` and return the matrix ``F``. If ``LU`` is ``L`` (Lower), ``A = L*L'``. If ``LU`` is ``U`` (Upper), ``A = R'*R``.

.. function:: cholfact(A, [LU]) -> CholeskyDense

   计算the Cholesky factorization of a symmetric positive-definite matrix ``A`` and return a ``CholeskyDense`` object. ``LU`` may be 'L' for using the lower part or 'U' for the upper part. The default is to use 'U'. ``factors(cholfact(A))`` returns the triangular matrix containing the factorization. The following functions are available for ``CholeskyDense`` objects: ``size``, ``factors``, ``\``, ``inv``, ``det``. A ``LAPACK.PosDefException`` error is thrown in case the matrix is not positive definite.

.. function: cholfact!(A, [LU]) -> CholeskyDense

   ``cholfact!`` 与 ``cholfact`` 相同，but saves space by overwriting the input A, instead of creating a copy.

..  function:: cholpfact(A, [LU]) -> CholeskyPivotedDense

   计算the pivoted Cholesky factorization of a symmetric positive semi-definite matrix ``A`` and return a ``CholeskyDensePivoted`` object. ``LU`` may be 'L' for using the lower part or 'U' for the upper part. The default is to use 'U'. ``factors(cholpfact(A))`` returns the triangular matrix containing the factorization. The following functions are available for ``CholeskyDensePivoted`` objects: ``size``, ``factors``, ``\``, ``inv``, ``det``. A ``LAPACK.RankDeficientException`` error is thrown in case the matrix is rank deficient.

.. function:: cholpfact!(A, [LU]) -> CholeskyPivotedDense

   ``cholpfact!`` 与 ``cholpfact`` 相同，but saves space by overwriting the input A, instead of creating a copy.

.. function:: qr(A) -> Q, R

   计算the QR factorization of ``A`` such that ``A = Q*R``. Also see ``qrd``.

.. function:: qrfact(A)

   计算the QR factorization of ``A`` and return a ``QRDense`` object. ``factors(qrfact(A))`` returns ``Q`` and ``R``. The following functions are available for ``QRDense`` objects: ``size``, ``factors``, ``qmulQR``, ``qTmulQR``, ``\``. 

.. function:: qrfact!(A)

   ``qrfact!`` 与 ``qrfact`` 相同，but saves space by overwriting the input A, instead of creating a copy.

.. function:: qrp(A) -> Q, R, P

   计算the QR factorization of ``A`` with pivoting, such that ``A*I[:,P] = Q*R``, where ``I`` is the identity matrix. Also see ``qrpfact``.

.. function:: qrpfact(A) -> QRPivotedDense

   计算the QR factorization of ``A`` with pivoting and return a ``QRDensePivoted`` object. ``factors(qrpfact(A))`` returns ``Q`` and ``R``. The following functions are available for ``QRDensePivoted`` objects: ``size``, ``factors``, ``qmulQR``, ``qTmulQR``, ``\``. 

.. function:: qrpfact!(A) -> QRPivotedDense

   ``qrpfact!`` 与 ``qrpfact`` 相同，but saves space by overwriting the input A, instead of creating a copy.

.. function:: qmulQR(QR, A)
   
   Perform Q*A efficiently, where Q is a an orthogonal matrix defined as the product of k elementary reflectors from the QR decomposition.

.. function:: qTmulQR(QR, A)

   Perform ``Q'*A`` efficiently, where Q is a an orthogonal matrix defined as the product of k elementary reflectors from the QR decomposition.

.. function:: sqrtm(A)

   计算 ``A`` 的矩阵平方根。如果 ``B = sqrtm(A)`` ，则在误差范围内 ``B*B == A`` 。

.. function:: eig(A) -> D, V

   计算 ``A`` 的特征值和特征向量。

.. function:: eigvals(A)

   返回  ``A`` 的特征值。

.. function:: svdfact(A, [thin]) -> SVDDense

   计算the Singular Value Decomposition (SVD) of ``A`` and return an ``SVDDense`` object. ``factors(svdfact(A))`` returns ``U``, ``S``, and ``Vt``, such that ``A = U*diagm(S)*Vt``. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svdfact!(A, [thin]) -> SVDDense

   ``svdfact!`` 与 ``svdfact`` 相同，but saves space by overwriting the input A, instead of creating a copy. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svd(A, [thin]) -> U, S, V

   对 A 做奇异值分解，返回 ``U`` ，向量 ``S`` ，及 ``V`` ，满足 ``A == U*diagm(S)*V'`` 。如果 ``thin`` 为 ``true`` ，则做节约模式分解。

.. function:: svdt(A, [thin]) -> U, S, Vt

   对 A 做奇异值分解，返回 ``U`` ，向量 ``S`` ，及 ``Vt`` ，满足 ``A = U*diagm(S)*Vt`` 。如果 ``thin`` 为 ``true`` ，则做节约模式分解。

.. function:: svdvals(A)

   返回 ``A`` 的奇异值。

.. function:: svdvals!(A)

   返回 ``A`` 的奇异值，将结果覆写到输入上以节约空间。

.. function:: svdfact(A, B) -> GSVDDense

   计算the generalized SVD of ``A`` and ``B``, returning a ``GSVDDense`` Factorization object. ``factors(svdfact(A,b))`` returns ``U``, ``V``, ``Q``, ``D1``, ``D2``, and ``R0`` such that ``A = U*D1*R0*Q'`` and ``B = V*D2*R0*Q'``.
   
.. function:: svd(A, B) -> U, V, Q, D1, D2, R0

   计算the generalized SVD of ``A`` and ``B``, returning ``U``, ``V``, ``Q``, ``D1``, ``D2``, and ``R0`` such that ``A = U*D1*R0*Q'`` and ``B = V*D2*R0*Q'``.
 
.. function:: svdvals(A, B)

   返回only the singular values from the generalized singular value decomposition of ``A`` and ``B``.

.. function:: triu(M)

   矩阵上三角。

.. function:: tril(M)

   矩阵下三角。

.. function:: diag(M, [k])

   矩阵的第 ``k`` 条对角线，结果为向量。 ``k`` 从 0 开始。

.. function:: diagm(v, [k])

   构造 ``v`` 为第 ``k`` 条对角线的对角矩阵。 ``k`` 从 0 开始。

.. function:: diagmm(matrix, vector)

   Multiply matrices, interpreting the vector argument as a diagonal matrix.
   The arguments may occur in the other order to multiply with the diagonal
   matrix on the left.

.. function:: Tridiagonal(dl, d, du)

   构造a tridiagonal matrix from the lower diagonal, diagonal, and upper diagonal

.. function:: Woodbury(A, U, C, V)

   构造a matrix in a form suitable for applying the Woodbury matrix identity

.. function:: rank(M)

   计算矩阵的秩。

.. function:: norm(A, [p])

   计算the ``p``-norm of a vector or a matrix. ``p`` is ``2`` by default, if not provided. If ``A`` is a vector, ``norm(A, p)`` computes the ``p``-norm. ``norm(A, Inf)`` returns the largest value in ``abs(A)``, whereas ``norm(A, -Inf)`` returns the smallest. If ``A`` is a matrix, valid values for ``p`` are ``1``, ``2``, or ``Inf``. In order to compute the Frobenius norm, use ``normfro``.

.. function:: normfro(A)

   计算the Frobenius norm of a matrix ``A``.

.. function:: cond(M, [p])

   Matrix condition number, computed using the p-norm. ``p`` 如果省略，默认为 2 。 ``p`` 的有效值为 ``1``, ``2``, 和 ``Inf``.

.. function:: trace(M)

   矩阵的迹。

.. function:: det(M)

   矩阵的行列式。

.. function:: inv(M)

   矩阵的逆。

.. function:: pinv(M)

   Moore-Penrose inverse

.. function:: null(M)

   Basis for null space of M.

.. function:: repmat(A, n, m)

   构造a matrix by repeating the given matrix ``n`` times in dimension 1 and ``m`` times in dimension 2.

.. function:: kron(A, B)

   Kronecker tensor product of two vectors or two matrices.

.. function:: linreg(x, y)

   Determine parameters ``[a, b]`` that minimize the squared error between ``y`` and ``a+b*x``.

.. function:: linreg(x, y, w)

   带权最小二乘法线性回归。

.. function:: expm(A)

   Matrix exponential.

.. function:: issym(A)

   判断是否为对称矩阵。

.. function:: isposdef(A)

   判断是否为正定矩阵。

.. function:: istril(A)

   判断是否为下三角矩阵。

.. function:: istriu(A)

   判断是否为上三角矩阵。

.. function:: ishermitian(A)

   判断是否为 Hamilton 矩阵。

.. function:: transpose(A)

   转置运算符（ ``.'`` ）。

.. function:: ctranspose(A)

   共轭转置运算符（ ``'`` ）。

排列组合
--------

.. function:: nthperm(v, k)

   计算the kth lexicographic permutation of a vector.

.. function:: nthperm!(v, k)

   :func:`nthperm` 的原地版本。

.. function:: randperm(n)

   构造a random permutation of the given length.

.. function:: invperm(v)

   返回the inverse permutation of v.

.. function:: isperm(v) -> Bool

   返回true if v is a valid permutation.

.. function:: permute!(v, p)

   Permute vector ``v`` in-place, according to permutation ``p``.  No
   checking is done to verify that ``p`` is a permutation.

   To return a new permutation, use ``v[p]``.  Note that this is
   generally faster than ``permute!(v,p)`` for large vectors.

.. function:: ipermute!(v, p)

   Like permute!, but the inverse of the given permutation is applied.

.. function:: randcycle(n)

   构造a random cyclic permutation of the given length.

.. function:: shuffle(v)

   Randomly rearrange the elements of a vector.

.. function:: shuffle!(v)

   :func:`shuffle` 的原地版本。

.. function:: reverse(v)

   Reverse vector ``v``.

.. function:: reverse!(v) -> v

   :func:`reverse` 的原地版本。

.. function:: combinations(array, n)

   Generate all combinations of ``n`` elements from a given array. Because
   the number of combinations can be very large, this function runs inside
   a Task to produce values on demand. Write ``c = @task combinations(a,n)``,
   then iterate ``c`` or call ``consume`` on it.

.. function:: integer_partitions(n, m)

   Generate all arrays of ``m`` integers that sum to ``n``. Because
   the number of partitions can be very large, this function runs inside
   a Task to produce values on demand. Write
   ``c = @task integer_partitions(n,m)``, then iterate ``c`` or call
   ``consume`` on it.

.. function:: partitions(array)

   Generate all set partitions of the elements of an array, represented as
   arrays of arrays. Because the number of partitions can be very large, this
   function runs inside a Task to produce values on demand. Write
   ``c = @task partitions(a)``, then iterate ``c`` or call ``consume`` on it.

统计
----

.. function:: mean(v, [dim])

   计算the mean of whole array ``v``, or optionally along dimension ``dim``

.. function:: std(v, [corrected])

   计算the sample standard deviation of a vector ``v``. If the optional argument ``corrected`` is either left unspecified or is explicitly set to the default value of ``true``, then the algorithm will return an estimator of the generative distribution's standard deviation under the assumption that each entry of ``v`` is an IID draw from that generative distribution. This computation is equivalent to calculating ``sqrt(sum((v .- mean(v)).^2) / (length(v) - 1))`` and involves an implicit correction term sometimes called the Bessel correction which insures that the estimator of the variance is unbiased. If, instead, the optional argument ``corrected`` is set to ``false``, then the algorithm will produce the equivalent of ``sqrt(sum((v .- mean(v)).^2) / length(v))``, which is the empirical standard deviation of the sample.

.. function:: std(v, m, [corrected])

   计算the sample standard deviation of a vector ``v`` with known mean ``m``. If the optional argument ``corrected`` is either left unspecified or is explicitly set to the default value of ``true``, then the algorithm will return an estimator of the generative distribution's standard deviation under the assumption that each entry of ``v`` is an IID draw from that generative distribution. This computation is equivalent to calculating ``sqrt(sum((v .- m).^2) / (length(v) - 1))`` and involves an implicit correction term sometimes called the Bessel correction which insures that the estimator of the variance is unbiased. If, instead, the optional argument ``corrected`` is set to ``false``, then the algorithm will produce the equivalent of ``sqrt(sum((v .- m).^2) / length(v))``, which is the empirical standard deviation of the sample.

.. function:: var(v, [corrected])

   计算the sample variance of a vector ``v``. If the optional argument ``corrected`` is either left unspecified or is explicitly set to the default value of ``true``, then the algorithm will return an unbiased estimator of the generative distribution's variance under the assumption that each entry of ``v`` is an IID draw from that generative distribution. This computation is equivalent to calculating ``sum((v .- mean(v)).^2) / (length(v) - 1)`` and involves an implicit correction term sometimes called the Bessel correction. If, instead, the optional argument ``corrected`` is set to ``false``, then the algorithm will produce the equivalent of ``sum((v .- mean(v)).^2) / length(v)``, which is the empirical variance of the sample.

.. function:: var(v, m, [corrected])

   计算the sample variance of a vector ``v`` with known mean ``m``. If the optional argument ``corrected`` is either left unspecified or is explicitly set to the default value of ``true``, then the algorithm will return an unbiased estimator of the generative distribution's variance under the assumption that each entry of ``v`` is an IID draw from that generative distribution. This computation is equivalent to calculating ``sum((v .- m)).^2) / (length(v) - 1)`` and involves an implicit correction term sometimes called the Bessel correction. If, instead, the optional argument ``corrected`` is set to ``false``, then the algorithm will produce the equivalent of ``sum((v .- m)).^2) / length(v)``, which is the empirical variance of the sample.

.. function:: median(v)

   计算the median of a vector ``v``

.. function:: hist(v, [n])

   计算the histogram of ``v``, optionally using ``n`` bins

.. function:: hist(v, e)

   计算the histogram of ``v`` using a vector ``e`` as the edges for the bins

.. function:: quantile(v, p)

   计算the quantiles of a vector ``v`` at a specified set of probability values ``p``.

.. function:: quantile(v)

   计算the quantiles of a vector ``v`` at the probability values ``[.0, .2, .4, .6, .8, 1.0]``.

.. function:: cov(v)

   计算the Pearson covariance between two vectors ``v1`` and ``v2``.

.. function:: cor(v)

   计算the Pearson correlation between two vectors ``v1`` and ``v2``.

信号处理
--------

Julia 中的 FFT 函数，大部分调用的是 `FFTW <http://www.fftw.org>`_ 中的函数。

.. function:: fft(A [, dims])

   Performs a multidimensional FFT of the array ``A``.  The optional ``dims``
   argument specifies an iterable subset of dimensions (e.g. an integer,
   range, tuple, or array) to transform along.  Most efficient if the
   size of ``A`` along the transformed dimensions is a product of small
   primes; see :func:`nextprod`.  See also :func:`plan_fft` for even
   greater efficiency.

   A one-dimensional FFT computes the one-dimensional discrete Fourier
   transform (DFT) as defined by :math:`\operatorname{DFT}[k] = \sum_{n=1}^{\operatorname{length}(A)} \exp\left(-i\frac{2\pi (n-1)(k-1)}{\operatorname{length}(A)} \right) A[n]`.  A multidimensional FFT simply performs this operation
   along each transformed dimension of ``A``.

.. function:: fft!(A [, dims])

   与 :func:`fft` 相同，but operates in-place on ``A``,
   which must be an array of complex floating-point numbers.

.. function:: ifft(A [, dims]), bfft, bfft!

   Multidimensional inverse FFT.

   A one-dimensional backward FFT computes
   :math:`\operatorname{BDFT}[k] =
   \sum_{n=1}^{\operatorname{length}(A)} \exp\left(+i\frac{2\pi
   (n-1)(k-1)}{\operatorname{length}(A)} \right) A[n]`.  A
   multidimensional backward FFT simply performs this operation along
   each transformed dimension of ``A``.  The inverse FFT computes
   the same thing divided by the product of the transformed dimensions.

.. function:: ifft!(A [, dims])

   与 :func:`ifft` 相同，但在原地对 ``A`` 进行运算。

.. function:: bfft(A [, dims])

   类似 :func:`ifft`, but computes an unnormalized inverse
   (backward) transform, which must be divided by the product of the sizes
   of the transformed dimensions in order to obtain the inverse.  (This is
   slightly more efficient than :func:`ifft` because it omits a scaling
   step, which in some applications can be combined with other
   computational steps elsewhere.)

.. function:: bfft!(A [, dims])

   与 :func:`bfft` 相同，但在原地对 ``A`` 进行运算。

.. function:: plan_fft(A [, dims [, flags [, timelimit]]]),  plan_ifft, plan_bfft

   Pre-plan an optimized FFT along given dimensions (``dims``) of arrays
   matching the shape and type of ``A``.  (The first two arguments have
   the same meaning as for :func:`fft`.)  返回a function ``plan(A)``
   that computes ``fft(A, dims)`` quickly.

   The ``flags`` argument is a bitwise-or of FFTW planner flags, defaulting
   to ``FFTW.ESTIMATE``.  e.g. passing ``FFTW.MEASURE`` or ``FFTW.PATIENT``
   will instead spend several seconds (or more) benchmarking different
   possible FFT algorithms and picking the fastest one; see the FFTW manual
   for more information on planner flags.  The optional ``timelimit`` argument
   specifies a rough upper bound on the allowed planning time, in seconds.
   Passing ``FFTW.MEASURE`` or ``FFTW.PATIENT`` may cause the input array ``A``
   to be overwritten with zeros during plan creation.

   :func:`plan_fft!` 与 :func:`plan_fft` 相同，but creates a plan
   that operates in-place on its argument (which must be an array of
   complex floating-point numbers).  :func:`plan_ifft` and so on
   are similar but produce plans that perform the equivalent of
   the inverse transforms :func:`ifft` and so on.

.. function:: plan_fft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_fft` 相同，但在原地对 ``A`` 进行运算。

.. function:: plan_ifft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_ifft` 相同，但在原地对 ``A`` 进行运算。

.. function:: plan_bfft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_bfft` 相同，但在原地对 ``A`` 进行运算。

.. function:: rfft(A [, dims])

   Multidimensional FFT of a real array A, exploiting the fact that
   the transform has conjugate symmetry in order to save roughly half
   the computational time and storage costs compared with :func:`fft`.
   If ``A`` has size ``(n_1, ..., n_d)``, the result has size
   ``(floor(n_1/2)+1, ..., n_d)``.

   The optional ``dims`` argument specifies an iterable subset of one or
   more dimensions of ``A`` to transform, similar to :func:`fft`.  Instead
   of (roughly) halving the first dimension of ``A`` in the result, the
   ``dims[1]`` dimension is (roughly) halved in the same way.

.. function:: irfft(A, d [, dims])

   Inverse of :func:`rfft`: for a complex array ``A``, gives the
   corresponding real array whose FFT yields ``A`` in the first half.
   As for :func:`rfft`, ``dims`` is an optional subset of dimensions
   to transform, defaulting to ``1:ndims(A)``.

   ``d`` is the length of the transformed real array along the ``dims[1]``
   dimension, which must satisfy ``d == floor(size(A,dims[1])/2)+1``.
   (This parameter cannot be inferred from ``size(A)`` due to the 
   possibility of rounding by the ``floor`` function here.)

.. function:: brfft(A, d [, dims])

   类似 :func:`irfft` but computes an unnormalized inverse transform
   (similar to :func:`bfft`), which must be divided by the product
   of the sizes of the transformed dimensions (of the real output array)
   in order to obtain the inverse transform.

.. function:: plan_rfft(A [, dims [, flags [, timelimit]]])

   Pre-plan an optimized real-input FFT, similar to :func:`plan_fft`
   except for :func:`rfft` instead of :func:`fft`.  The first two
   arguments, and the size of the transformed result, are the same as
   for :func:`rfft`.

.. function:: plan_irfft(A, d [, dims [, flags [, timelimit]]]), plan_bfft

   Pre-plan an optimized inverse real-input FFT, similar to :func:`plan_rfft`
   except for :func:`irfft` and :func:`brfft`, respectively.  The first
   three arguments have the same meaning as for :func:`irfft`.

.. function:: dct(A [, dims])

   Performs a multidimensional type-II discrete cosine transform (DCT)
   of the array ``A``, using the unitary normalization of the DCT.
   The optional ``dims`` argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along.  Most efficient if the size of ``A`` along the transformed
   dimensions is a product of small primes; see :func:`nextprod`.  See
   also :func:`plan_dct` for even greater efficiency.

.. function:: dct!(A [, dims])

   与 :func:`dct!` 相同，except that it operates in-place
   on ``A``, which must be an array of real or complex floating-point
   values. 

.. function:: idct(A [, dims])

   Computes the multidimensional inverse discrete cosine transform (DCT)
   of the array ``A`` (technically, a type-III DCT with the unitary
   normalization).
   The optional ``dims`` argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along.  Most efficient if the size of ``A`` along the transformed
   dimensions is a product of small primes; see :func:`nextprod`.  See
   also :func:`plan_idct` for even greater efficiency.

.. function:: idct!(A [, dims])

   与 :func:`idct!` 相同，但在原地对 ``A`` 进行运算。

.. function:: plan_dct(A [, dims [, flags [, timelimit]]])

   Pre-plan an optimized discrete cosine transform (DCT), similar to
   :func:`plan_fft` except producing a function that computes :func:`dct`.
   The first two arguments have the same meaning as for :func:`dct`.

.. function:: plan_dct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_dct` 相同，但在原地对 ``A`` 进行运算。

.. function:: plan_idct(A [, dims [, flags [, timelimit]]])

   Pre-plan an optimized inverse discrete cosine transform (DCT), similar to
   :func:`plan_fft` except producing a function that computes :func:`idct`.
   The first two arguments have the same meaning as for :func:`idct`.

.. function:: plan_idct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_idct` 相同，但在原地对 ``A`` 进行运算。

.. function:: FFTW.r2r(A, kind [, dims]), FFTW.r2r!

   Performs a multidimensional real-input/real-output (r2r) transform
   of type ``kind`` of the array ``A``, as defined in the FFTW manual.
   ``kind`` specifies either a discrete cosine transform of various types
   (``FFTW.REDFT00``, ``FFTW.REDFT01``, ``FFTW.REDFT10``, or
   ``FFTW.REDFT11``), a discrete sine transform of various types 
   (``FFTW.RODFT00``, ``FFTW.RODFT01``, ``FFTW.RODFT10``, or
   ``FFTW.RODFT11``), a real-input DFT with halfcomplex-format output
   (``FFTW.R2HC`` and its inverse ``FFTW.HC2R``), or a discrete
   Hartley transform (``FFTW.DHT``).  The ``kind`` argument may be
   an array or tuple in order to specify different transform types
   along the different dimensions of ``A``; ``kind[end]`` is used
   for any unspecified dimensions.  See the FFTW manual for precise
   definitions of these transform types, at `<http://www.fftw.org/doc>`.

   The optional ``dims`` argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along. ``kind[i]`` is then the transform type for ``dims[i]``,
   with ``kind[end]`` being used for ``i > length(kind)``.

   See also :func:`FFTW.plan_r2r` to pre-plan optimized r2r transforms.

   :func:`FFTW.r2r!` 与 :func:`FFTW.r2r` 相同，but operates
   in-place on ``A``, which must be an array of real or complex 
   floating-point numbers.

.. function:: FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]]), FFTW.plan_r2r!

   Pre-plan an optimized r2r transform, similar to :func:`plan_fft`
   except that the transforms (and the first three arguments)
   correspond to :func:`FFTW.r2r` and :func:`FFTW.r2r!`, respectively.

.. function:: fftshift(x)

   Swap the first and second halves of each dimension of ``x``.

.. function:: fftshift(x,dim)

   Swap the first and second halves of the given dimension of array ``x``.

.. function:: ifftshift(x, [dim])

   Undoes the effect of ``fftshift``.

.. function:: filt(b,a,x)

   Apply filter described by vectors ``a`` and ``b`` to vector ``x``.

.. function:: deconv(b,a)

   构造vector ``c`` such that ``b = conv(a,c) + r``. Equivalent to polynomial division.

.. function:: conv(u,v)

   计算两个向量的卷积。使用 FFT 算法。

.. function:: xcorr(u,v)

   计算两个向量的互相关。

并行计算
--------

.. function:: addprocs_local(n)

   Add processes on the local machine. Can be used to take advantage of multiple cores.

.. function:: addprocs_ssh({"host1","host2",...})

   Add processes on remote machines via SSH. Requires julia to be installed in the same location on each node, or to be available via a shared file system.

.. function:: addprocs_sge(n)

   Add processes via the Sun/Oracle Grid Engine batch queue, using ``qsub``.

.. function:: nprocs()

   获取当前可用处理器的个数。

.. function:: myid()

   获取当前处理器的 ID 。

.. function:: pmap(f, c)

   Transform collection ``c`` by applying ``f`` to each element in parallel.

.. function:: remote_call(id, func, args...)

   Call a function asynchronously on the given arguments on the specified processor. 返回 ``RemoteRef`` 。

.. function:: wait(RemoteRef)

   Wait for a value to become available for the specified remote reference.

.. function:: fetch(RemoteRef)

   等待并获取 remote reference 的值。

.. function:: remote_call_wait(id, func, args...)

   Perform ``wait(remote_call(...))`` in one message.

.. function:: remote_call_fetch(id, func, args...)

   Perform ``fetch(remote_call(...))`` in one message.

.. function:: put(RemoteRef, value)

   Store a value to a remote reference. Implements "shared queue of length 1" semantics: if a value is already present, blocks until the value is removed with ``take``.

.. function:: take(RemoteRef)

   取回 remote reference 的值，removing it so that the reference is empty again.

.. function:: RemoteRef()

   Make an uninitialized remote reference on the local machine.

.. function:: RemoteRef(n)

   Make an uninitialized remote reference on processor ``n``.

分布式数组
----------

.. function:: DArray(init, dims, [procs, dist])

   构造分布式数组。 ``init`` is a function accepting a tuple of index ranges. This function should return a chunk of the distributed array for the specified indexes. ``dims`` is the overall size of the distributed array. ``procs`` optionally specifies a vector of processor IDs to use. ``dist`` is an integer vector specifying how many chunks the distributed array should be divided into in each dimension.

.. function:: dzeros(dims, ...)

   构造全零的分布式数组。Trailing arguments are the same as those accepted by ``darray``.

.. function:: dones(dims, ...)

   构造全一的分布式数组。Trailing arguments are the same as those accepted by ``darray``.

.. function:: dfill(x, dims, ...)

   构造值全为 ``x`` 的分布式数组。Trailing arguments are the same as those accepted by ``darray``.

.. function:: drand(dims, ...)

   构造均匀分布的随机分布式数组。Trailing arguments are the same as those accepted by ``darray``.

.. function:: drandn(dims, ...)

   构造正态分布的随机分布式数组。Trailing arguments are the same as those accepted by ``darray``.

.. function:: distribute(a)

   将本地数组转换为分布式数组。

.. function:: localize(d)

   获取分布式数组的本地部分。

.. function:: myindexes(d)

   A tuple describing the indexes owned by the local processor

.. function:: procs(d)

   Get the vector of processors storing pieces of ``d``

系统
----

.. function:: run(command)

   执行命令对象， constructed with backticks. Throws an error if anything goes wrong, including the process exiting with a non-zero status.

.. function:: success(command)

   执行命令对象， constructed with backticks, and tell whether it was successful (exited with a code of 0).

.. function:: readsfrom(command)

   Starts running a command asynchronously, and returns a tuple (stream,process). The first value is a stream reading from the process' standard output.

.. function:: writesto(command)

   Starts running a command asynchronously, and returns a tuple (stream,process). The first value is a stream writing to the process' standard input.

.. function:: readandwrite(command)

   Starts running a command asynchronously, and returns a tuple (stdout,stdin,process) of the output stream and input stream of the process, and the process object itself.

.. function:: > < >> .>

   ``>`` ``<`` and ``>>`` work exactly as in bash, and ``.>`` redirects STDERR.

   **例子** ： ``run((`ls` > "out.log") .> "err.log")``

.. function:: gethostname() -> String

   Get the local machine's host name.

.. function:: getipaddr() -> String

   Get the IP address of the local machine, as a string of the form "x.x.x.x".

.. function:: pwd() -> String

   Get the current working directory.

.. function:: cd(dir::String)

   Set the current working directory. 返回the new current directory.

.. function:: cd(f, ["dir"])

   Temporarily changes the current working directory (HOME if not specified) and applies function f before returning. 

.. function:: mkdir(path, [mode])

   Make a new directory with name ``path`` and permissions ``mode``.
   ``mode`` defaults to 0o777, modified by the current file creation mask.

.. function:: rmdir(path)

   移除the directory named ``path``.

.. function:: getpid() -> Int32

   Get julia's process ID.

.. function:: time()

   Get the system time in seconds since the epoch, with fairly high (typically, microsecond) resolution.

.. function:: time_ns()

   Get the time in nanoseconds. The time corresponding to 0 is undefined, and wraps every 5.8 years.

.. function:: tic()

   设置计时器， :func:`toc` 或 :func:`toq` 会调用它所计时的时间。The macro call ``@time expr`` can also be used to time evaluation.

.. function:: toc()

   打印并返回最后一个 :func:`tic` 计时器的时间。

.. function:: toq()

   返回但不打印最后一个 :func:`tic` 计时器的时间。

.. function:: EnvHash() -> EnvHash

   A singleton of this type provides a hash table interface to environment variables.

.. data:: ENV

   Reference to the singleton ``EnvHash``.

C 接口
------

.. function:: ccall( (symbol, library), RetType, (ArgType1, ...), ArgVar1, ...)
              ccall( fptr::Ptr{Void}, RetType, (ArgType1, ...), ArgVar1, ...)

   Call function in C-exported shared library, specified by (function name, library) tuple (String or :Symbol). Alternatively, ccall may be used to call a function pointer returned by dlsym, but note that this usage is generally discouraged to facilitate future static compilation.

.. function:: cfunction(fun::Function, RetType::Type, (ArgTypes...))
   
   Generate C-callable function pointer from Julia function.

.. function:: dlopen(libfile::String [, flags::Integer])

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

.. function:: dlsym(handle, sym)

   Look up a symbol from a shared library handle, return callable function pointer on success.

.. function:: dlsym_e(handle, sym)
   
   Look up a symbol from a shared library handle, silently return NULL pointer on lookup failure.

.. function:: dlclose(handle)

   通过句柄来关闭共享库的引用。

.. function:: c_free(addr::Ptr)
  
   调用 C 标准库中的 ·``free()`` 。

.. function:: unsafe_ref(p::Ptr{T},i::Integer)

   对指针解引用 ``p[i]`` 或 ``*p`` ，返回类型 T 的值的浅拷贝。

.. function:: unsafe_assign(p::Ptr{T},x,i::Integer)

   给指针赋值 ``p[i] = x`` 或 ``*p = x`` ，将对象 x 复制进 p 处的内存中。

错误
----

.. function:: error(message::String)
              error(Exception)

   报错，并显示指定信息。

.. function:: throw(e)

   将一个对象作为异常抛出。

.. function:: errno()

   获取 C 库 ``errno`` 的值。

.. function:: strerror(n)

   将系统调用错误代码转换为描述字符串。

.. function:: assert(cond)

   如果 ``cond`` 为假则报错。也可以使用宏 ``@assert expr`` 。

任务
----

.. function:: Task(func)

   构造 ``Task`` （如线程，协程）来执行指定程序。此函数返回时，任务自动退出。

.. function:: yieldto(task, args...)

   跳转到指定的任务。第一次跳转到某任务时，使用 ``args`` 参数来调用任务的函数。在后续的跳转时， ``args`` 被任务的最后一个调用返回到 ``yieldto`` 。

.. function:: current_task()

   获取当前正在运行的任务。

.. function:: istaskdone(task)

   判断任务是否已退出。

.. function:: consume(task)

   接收由指定任务传递给 ``produce`` 的下一个值。

.. function:: produce(value)

   将指定值传递给最近的一次 ``consume`` 调用，然后跳转到消费者任务。

.. function:: make_scheduled(task)

   使用主事件循环来注册任务，任务会在允许的时候自动运行。

.. function:: yield()

   对安排好的任务，跳转到安排者来允许运行另一个安排好的任务。

.. function:: tls(symbol)

   在当前任务的本地任务存储中查询 ``symbol`` 的值。

.. function:: tls(symbol, value)

   给当前任务的本地任务存储中的 ``symbol`` 赋值 ``value`` 。