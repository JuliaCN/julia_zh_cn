.. currentmodule:: Base

杂项
----

.. function:: exit([code])

   退出（或在会话中按下 control-D ）。默认退出代码为 0 ，表示进程正常结束。

.. function:: whos([Module,] [pattern::Regex])

   打印模块中全局变量的信息，可选择性地限制打印匹配 ``pattern`` 的变量。

.. function:: edit(file::String, [line])

   编辑文件；可选择性地提供要编辑的行号。退出编辑器后返回 Julia 会话。 
   如果文件后缀名为 ".jl" ，关闭文件后会重载该文件。

.. function:: edit(function, [types])

   编辑函数定义，可选择性地提供一个类型多元组以指明要编辑哪个方法。 
   退出编辑器后，包含定义的源文件会被重载。

.. function:: require(file::String...)

   在 ``Main`` 模块的上下文中，对每个活动的节点，通过系统的 ``LOAD_PATH`` 
   查找文件，并只载入一次。``require`` 是顶层操作，因此它设置当前的 
   ``include`` 路径，但并不使用它来查找文件（详见 ``include`` ）。 
   此函数常用来载入库代码； ``using`` 函数隐含使用它来载入扩展包。

.. function:: reload(file::String)

   类似 ``require`` ，但不管是否曾载入过，都要载入文件。
   常在交互式地开发库时使用。

.. function:: include(path::String)

   在当前上下文中，对源文件的内容求值。在包含的过程中，它将本地任务 
   包含的路径设置为包含文件的文件夹。嵌套调用 ``include`` 时会搜索 
   那个路径的   相关路径。并行运行时，所有的路径都指向节点 1 上文件， 
   并从节点 1 上获取文件。此函数常用来交互式地载入源文件，或将分散为 
   多个源文件的扩展包结合起来。

.. function:: include_string(code::String)

   类似 ``include`` ，但它从指定的字符串读取代码，而不是从文件中。 
   由于没有涉及到文件路径，不会进行路径处理或从节点 1 获取文件。

.. function:: evalfile(path::String)

   对指定文件的所有表达式求值，并返回最后一个表达式的值。 
   不会进行其他处理（搜索路径，从节点 1 获取文件等）。

.. function:: help(name)

   获得函数帮助。 ``name`` 可以是对象或字符串。

.. function:: apropos(string)

   查询文档中与 ``string`` 相关的函数。

.. function:: which(f, args...)

   对指定的参数，显示应调用 ``f`` 的哪个方法。

.. function:: methods(f)

   显示 ``f`` 的所有方法及其对应的参数类型。
   
.. function:: methodswith(typ[, showparents])

   显示 ``typ`` 类型的所有方法。若可选项 ``showparents`` 为 ``true`` ， 
   则额外显示 ``typ`` 除 ``Any`` 类型之外的父类型的方法。
   

所有对象
--------

.. function:: is(x, y)

   判断 ``x`` 与 ``y`` 是否相同，依据为程序不能区分它们。

.. function:: isa(x, type)

   判断 ``x`` 是否为指定类型。

.. function:: isequal(x, y)

   当且仅当 ``x`` 和 ``y`` 内容相同是为真。粗略地说，即打印出来的
   ``x`` 和 ``y`` 看起来一模一样。

.. function:: isless(x, y)

   判断 ``x`` 是否比 ``y`` 小。它具有与 ``isequal`` 一致的整体排序。 
   不能正常排序的值如 ``NaN`` ，会按照任意顺序排序，但其排序方式会保持一致。 
   它是 ``sort`` 默认使用的比较函数。可进行排序的非数值类型，应当实现此方法。

.. function:: typeof(x)

   返回 ``x`` 的具体类型。

.. function:: tuple(xs...)

   构造指定对象的多元组。

.. function:: ntuple(n, f::Function)

   构造长度为 ``n`` 的多元组，每个元素为 ``f(i)`` ，其中 ``i`` 为元素的索引值。

.. function:: object_id(x)

   获取 ``x`` 唯一的整数值 ID 。当且仅当 ``is(x,y)`` 时，
   ``object_id(x) == object_id(y)`` 。

.. function:: hash(x)

   计算整数哈希值。因而 ``isequal(x,y)`` 等价于 ``hash(x) == hash(y)`` 。

.. function:: finalizer(x, function)

   当对 ``x`` 的引用处于程序不可用时，注册一个注册可调用的函数 ``f(x)`` 
   来终结这个引用。当 ``x`` 为位类型时，此函数的行为不可预测。

.. function:: copy(x)

   构造 ``x`` 的浅拷贝：仅复制外层结构，不复制内部值。如，复制数组时， 
   会生成一个元素与原先完全相同的新数组。

.. function:: deepcopy(x)

   构造 ``x`` 的深拷贝：递归复制所有的东西，返回一个完全独立的对象。 
   如，深拷贝数组时，会生成一个元素为原先元素深拷贝的新数组。

   作为特例，匿名函数只能深拷贝，非匿名函数则为浅拷贝。它们的区别仅与闭包有关， 
   例如含有隐藏的内部引用的函数。

   正常情况都不必这么做：自定义类型可通过定义特殊版本的 
   ``deepcopy_internal(x::T, dict::ObjectIdDict)`` 函数（此函数其它情况下 
   不应使用）来覆盖默认的 ``deepcopy`` 行为，其中 ``T`` 是要指明的类型， 
   ``dict`` 记录迄今为止递归中复制的对象。在定义中， ``deepcopy_internal`` 
   应当用来代替 ``deepcopy`` ， ``dict`` 变量应当在返回前正确的更新。

.. function:: convert(type, x)

   试着将 ``x`` 转换为指定类型。

.. function:: promote(xs...)

   将所有参数转换为共同的提升类型（如果有的话），并将它们（作为多元组）返回。

类型
----

.. function:: subtype(type1, type2)

   仅在 ``type1`` 的所有值都是 ``type2`` 时为真。也可使用 ``<:`` 中缀运算符， 
   写为 ``type1 <: type2`` 。

.. function:: <:(T1, T2)

   子类型运算符，等价于 ``subtype(T1,T2)`` 。

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

   1.0 与下一个稍大的 ``type`` 类型可表示的浮点数之间的距离。有效的类型为 
   ``Float32`` 和 ``Float64`` 。如果省略 ``type`` ，则返回 ``eps(Float64)`` 。

.. function:: eps(x)

   ``x`` 与下一个稍大的 ``x`` 同类型可表示的浮点数之间的距离。

.. function:: promote_type(type1, type2)

   如果可能的话，给出可以无损表示每个参数类型值的类型。若不存在无损表示时， 
   可以容忍有损；如 ``promote_type(Int64,Float64)`` 返回 ``Float64`` ， 
   尽管严格来说，并非所有的 ``Int64`` 值都可以由 ``Float64`` 无损表示。

.. function:: getfield(value, name::Symbol)

   从复合类型的 value 中提取命名域。 ``a.b`` 语法调用 ``getfield(a, :b)`` ，
   ``a.(b)`` 语法调用 ``getfield(a, b)`` 。

.. function:: setfield(value, name::Symbol, x)

   为复合类型的 ``value`` 中的命名域赋值 ``x`` 。
   ``a.b = c`` 语法调用 ``setfield(a, :b, c)`` ，
   ``a.(b) = c`` 语法调用 ``setfield(a, b, c)``.

.. function:: fieldtype(value, name::Symbol)

   返回复合类型的 ``value`` 中的命名域 ``name`` 的类型。

   
通用函数
--------

.. function:: method_exists(f, tuple) -> Bool

   判断指定的通用函数是否有匹配参数类型多元组的方法。

   **例子** ： ``method_exists(length, (Array,)) = true``

.. function:: applicable(f, args...)

   判断指定的通用函数是否有可用于指定参数的方法。

.. function:: invoke(f, (types...), args...)

   对指定的参数，为匹配指定类型（多元组）的通用函数指定要调用的方法。 
   参数应与指定的类型兼容。它允许在最匹配的方法之外，指定一个方法。 
   这对明确需要一个更通用的定义的行为时非常有用 
   （通常作为相同函数的更特殊的方法实现的一部分）。

.. function:: |(x, f)
   
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

   对一组迭代对象，返回一组可迭代多元组，其中第 ``i`` 个多元组 
   包含每个可迭代输入的第 ``i`` 个分量。

   注意 ``zip`` 是它自己的逆操作： ``[zip(zip(a...)...)...] == [a...]`` 。
   
.. function:: enumerate(iter)

   返回生成 ``(i, x)`` 的迭代器，其中 ``i`` 是从 1 开始的索引， 
   ``x`` 是指定迭代器的第 ``i`` 个值。

完全实现的有： ``Range``, ``Range1``, ``NDRange``, ``Tuple``, ``Real``, ``AbstractArray``, ``IntSet``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``EachLine``, ``String``, ``Set``, ``Task``.

通用集合
--------

.. function:: isempty(collection) -> Bool

   判断集合是否为空（没有元素）。

.. function:: empty!(collection) -> collection

   移除集合中的所有元素。

.. function:: length(collection) -> Integer

   对可排序、可索引的集合，用于 ``getindex(collection, i)`` 最大索引值 
   ``i`` 是有效的。对不可排序的集合，结果为元素个数。

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

   使用指定的运算符约简指定集合， ``v0`` 为约简的初始值。一些常用运算符的缩减， 
   有更简便的单参数格式： ``max(itr)``, ``min(itr)``, ``sum(itr)``, 
   ``prod(itr)``, ``any(itr)``, ``all(itr)``.

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

.. function:: collect(collection)

   返回集合中的所有项的数组。对关联性集合，返回 (key, value) 多元组。
   
可索引集合
----------

.. function:: getindex(collection, key...)

   取回集合中存储在指定键或索引值内的值。 
   语法 ``a[i,j,...]`` 由编译器转换为 ``getindex(a, i, j, ...)`` 。

.. function:: setindex!(collection, value, key...)

   将指定值存储在集合的指定键或索引值内。 
   语法 ``a[i,j,...] = x`` 由编译器转换为 ``setindex!(a, x, i, j, ...)`` 。

完全实现的有： ``Array``, ``DArray``, ``AbstractArray``, ``SubArray``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``String``.

部分实现的有： ``Range``, ``Range1``, ``Tuple``.

关联性集合
----------

字典 ``Dict`` 是标准关联性集合。它的实现中，键使用 ``hash(x)`` 作为其哈希函数，使用 ``isequal(x,y)`` 判断是否相等。为自定义类型定义这两个函数，可覆盖它们如何存储在哈希表中的细节。

``ObjectIdDict`` 是个特殊的哈希表，它的键是对象的 ID 。 ``WeakKeyDict`` 是一种哈希表实现，它的键是对象的弱引用，因此即使在哈希表中被引用，它也可能被回收机制处理。

字典可通过文本化语法构造： ``{"A"=>1, "B"=>2}`` 。使用花括号可以构造 ``Dict{Any,Any}`` 类型的 ``Dict`` 。使用方括号会尝试从键和值中推导类型信息（如 ``["A"=>1, "B"=>2]`` 可构造 ``Dict{ASCIIString, Int64}`` ）。使用 ``(KeyType=>ValueType)[...]`` 来指明类型。如 ``(ASCIIString=>Int32)["A"=>1, "B"=>2]`` 。

至于数组， ``Dicts`` 可使用内涵式语法来构造。如 ``{i => f(i) for i = 1:10}`` 。

.. function:: Dict{K,V}()

   使用 K 类型的键和 V 类型的值来构造哈希表。

.. function:: has(collection, key)

   判断集合是否含有指定键的映射。

.. function:: get(collection, key, default)

   返回指定键存储的值；当前没有键的映射时，返回默认值。

.. function:: getkey(collection, key, default)

   如果参数 ``key`` 匹配 ``collection`` 中的键，将其返回；否在返回 ``default`` 。

.. function:: delete!(collection, key)

   删除集合中指定键的映射，返回被删的键的值。

.. function:: keys(collection)

   返回集合中所有键组成的数组。

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

   向集合逐个添加 ``iterable`` 中的元素。

.. function:: Set(x...)

   使用指定元素来构造 ``Set`` 。构造稀疏整数集时应使用此函数，而非 ``IntSet`` 。

.. function:: IntSet(i...)

   使用指定元素来构造 ``IntSet`` 。它是由位字符串实现的，因而适合构造稠密整数集。如果为稀疏集合(例如集合内容为几个非常大的整数), 请使用 ``Set``.

.. function:: union(s1,s2...)

   构造两个及两个以上集的共用体。保持原数组中的顺序。

.. function:: union!(s1,s2)

   构造 ``IntSet`` s1 和 s2 的共用体，将结果保存在 ``s1`` 中。

.. function:: intersect(s1,s2...)

   构造两个及两个以上集的交集。保持原数组中的顺序。

.. function:: setdiff(s1,s2)

   使用存在于 ``s1`` 且不在 ``s2`` 的元素来构造集合。保持原数组中的顺序。

.. function:: symdiff(s1,s2...)

   构造由集合或数组中不同的元素构成的集。保持原数组中的顺序。

.. function:: symdiff!(s, n)

   向 ``IntSet`` s 中插入整数元素 ``n`` 。

.. function:: symdiff!(s, itr)

   向 set s 中插入 ``itr`` 中的元素。

.. function:: symdiff!(s1, s2)

   构造由 ``IntSets`` 类型的 ``s1`` 和 ``s2`` 中不同的元素构成的集， 
   结果保存在 ``s1`` 中。

.. function:: complement(s)

   返回 ``IntSet`` s 的补集。

.. function:: complement!(s)

   将 ``IntSet`` s 转换为它的补集。

.. function:: del_each!(s, itr)

   在原地将集合 s 中 itr 的元素删除。

.. function:: intersect!(s1, s2)

   构造 `Inset` s1 和 s2 的交集，并将结果覆写到 s1 。 
   s1 根据需要来决定是否扩展到 s2 的大小。

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

   移除指定索引值处的项，返回删除项。

.. function:: delete!(collection, range) -> items
   
   移除指定范围内的项，返回包含删除项的集合。

.. function:: resize!(collection, n) -> collection

   改变集合的大小，使其可包含 ``n`` 个元素。

.. function:: append!(collection, items) -> collection

   将 ``items`` 元素附加到集合末尾。

完全实现的有： ``Vector`` （即 1 维 ``Array`` ）

字符串
------

.. function:: length(s)

   字符串 ``s`` 中的字符数。

.. function:: *(s, t)

   连接字符串。

   **例子** ： ``"Hello " * "world" == "Hello world"``

.. function:: ^(s, n)

   将字符串 ``s`` 重复 ``n`` 次。

   **例子** ： ``"Julia "^3 == "Julia Julia Julia "``

.. function:: string(xs...)

   使用 ``print`` 函数的值构造字符串。

.. function:: repr(x)

   使用 ``show`` 函数的值构造字符串。

.. function:: bytestring(::Ptr{Uint8})

   从 C （以 0 结尾的）格式字符串的地址构造一个字符串。 
   它使用了浅拷贝；可以安全释放指针。

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

   如果字符串或字节向量是有效的 ASCII ，返回真；否则返回假。

.. function:: is_valid_utf8(s) -> Bool

   如果字符串或字节向量是有效的 UTF-8 ，返回真；否则返回假。

.. function:: is_valid_char(c) -> Bool

   如果指定的字符或整数是有效的 Unicode 码位，则返回真。

.. function:: ismatch(r::Regex, s::String)

   判断字符串是否匹配指定的正则表达式。
   
.. function:: lpad(string, n, p)

   在字符串左侧填充一系列 ``p`` ，以保证字符串至少有 ``n`` 个字符。

.. function:: rpad(string, n, p)

   在字符串右侧填充一系列 ``p`` ，以保证字符串至少有 ``n`` 个字符。

.. function:: search(string, chars, [start])

   在指定字符串中查找指定字符。第二个参数可以是单字符、字符向量或集合、 
   字符串、或正则表达式（但正则表达式仅用来处理连续字符串，如 ASCII 或 
   UTF-8 字符串）。第三个参数是可选的，它指明起始索引值。 
   返回值为所找到的匹配序列的索引值范围，它满足 ``s[search(s,x)] == x`` 。 
   如果没有匹配，则返回值为 ``0:-1`` 。

.. function:: replace(string, pat, r[, n])

   查找指定模式 ``pat`` ，并替换为 ``r`` 。如果提供 ``n`` ，
   则最多替换 ``n`` 次。搜索时，第二个参数可以是单字符、字符向量或集合、
   字符串、或正则表达式。如果 ``r`` 为函数，替换后的结果为 ``r(s)`` ，
   其中 ``s`` 是匹配的子字符串。

.. function:: split(string, [chars, [limit,] [include_empty]])

   返回由指定字符分割符所分割的指定字符串的字符串数组。 
   分隔符可由 ``search`` 的第二个参数所允许的任何格式所指明（如单字符、 
   字符集合、字符串、或正则表达式）。如果省略 ``chars`` ， 
   则它默认为整个空白字符集，且 ``include_empty`` 默认为假。 
   最后两个参数是可选的：它们是结果的最大长度，且由标志位决定是否在结果中包括空域。

.. function:: strip(string, [chars])

   返回去除头部、尾部空白的 ``string`` 。如果提供了字符串 ``chars`` ，
   则去除字符串中包含的字符。

.. function:: lstrip(string, [chars])

   返回去除头部空白的 ``string`` 。如果提供了字符串 ``chars`` ，
   则去除字符串中包含的字符。

.. function:: rstrip(string, [chars])

   返回去除尾部空白的 ``string`` 。如果提供了字符串 ``chars`` ， 
   则去除字符串中包含的字符。

.. function:: beginswith(string, prefix)

   如果 ``string`` 以 ``prefix`` 开始，则返回 ``true`` 。

.. function:: endswith(string, suffix)

   如果 ``string`` 以 ``suffix`` 结尾，则返回 ``true`` 。

.. function:: uppercase(string)

   返回所有字符转换为大写的 ``string`` 。

.. function:: lowercase(string)

   返回所有字符转换为小写的 ``string`` 。

.. function:: join(strings, delim)

   将字符串数组合并为一个字符串，在邻接字符串间添加分隔符 ``delim`` 。

.. function:: chop(string)

   移除字符串的最后一个字符。

.. function:: chomp(string)

   移除字符串最后的换行符。

.. function:: ind2chr(string, i)

   给出字符串中索引值为 i 的字节所在的字符的索引值。

.. function:: chr2ind(string, i)

   给出字符串中索引为 i 的字符对应的（第一个）字节的索引值。

.. function:: isvalid(str, i)

   判断指定字符串的第 ``i`` 个索引值处是否是有效字符。

.. function:: nextind(str, i)

   获取索引值 ``i`` 处之后的有效字符的索引值。如果在字符串末尾， 
   则返回 ``endof(str)+1`` 。

.. function:: prevind(str, i)

   获取索引值 ``i`` 处之前的有效字符的索引值。如果在字符串开头，则返回 ``0`` 。

.. function:: thisind(str, i)

   返回索引值 ``i`` 处所在的有效字符的索引值。

.. function:: randstring(len)

   构造长度为 ``len`` 的随机 ASCII 字符串。有效的字符为大小写字母和数字 0-9 。

.. function:: charwidth(c)

   给出需要多少列来打印此字符。

.. function:: strwidth(s)

   给出需要多少列来打印此字符串。
   
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

.. data:: OUTPUT_STREAM

   用于文本输出的默认流，如在 ``print`` 和 ``show`` 函数中的流。

.. function:: open(file_name, [read, write, create, truncate, append]) -> IOStream

   按五个布尔值参数指明的模式打开文件。默认以只读模式打开文件。 
   返回操作文件的流。

.. function:: open(file_name, [mode]) -> IOStream

   另一种打开文件的语法，它使用字符串样式的标识符：

   ==== =================================
    r    读（默认）
    r+   读、写
    w    写、新建、清空重写
    w+   读写、新建、清空重写
    a    写、新建、追加
    a+   读、写、新建、追加
   ==== =================================

.. function:: open(f::function, args...)

   将函数 ``f`` 映射到 ``open(args...)`` 的返回值上，完成后关闭文件描述符。

   **例子** ： ``open(readall, "file.txt")``

.. function:: memio([size[, finalize::Bool]]) -> IOStream

   构造内存中 I/O 流，可选择性指明需要多少初始化空间。

.. function:: fdio([name::String, ]fd::Integer[, own::Bool]) -> IOStream

   用整数文件描述符构造 ``IOStream`` 对象。如果 ``own`` 为真， 
   关闭对象时会关闭底层的描述符。默认垃圾回收时 ``IOStream`` 是关闭的。 
   ``name`` 用文件描述符关联已命名的文件。

.. function:: flush(stream)

   将当前所有的缓冲写入指定流。

.. function:: close(stream)

   关闭 I/O 流。它将在关闭前先做一次 ``flush`` 。

.. function:: write(stream, x)

   将值的标准二进制表示写入指定流。

.. function:: read(stream, type)

   从标准二进制表示的流中读出指定类型的值。

.. function:: read(stream, type, dims)

   从标准二进制表示的流中读出指定类型的一组值。 
   ``dims`` 可以是整数参数的多元组或集合，它指明要返还 ``Array`` 的大小。

.. function:: position(s)

   获取流的当前位置。

.. function:: seek(s, pos)

   将流定位到指定位置。

.. function:: seekstart(s)

   将流定位到开头.

.. function:: seekend(s)

   将流定位到尾端。

.. function:: skip(s, offset)

   相对于当前位置定位流。

.. function:: eof(stream)

   判断 I/O 流是否到达文件尾。如果流还没被耗尽，函数会阻塞并继续等待数据， 
   然后返回 ``false`` 。因此当 ``eof`` 返回 ``false`` 后，可以很安全地读取一个字节。
   
.. function:: ntoh(x)

   将值的字节序从网络序（大端序）转换为本机字节序。

.. function:: hton(x)

   将值的字节序从本机字节序转换为网络序（大端序）。

.. function:: ltoh(x)

   将值的字节序从小端序转换为本机字节序。

.. function:: htol(x)

   将值的字节序从本机字节序转换为小端序。

文本 I/O
--------

.. function:: show(x)

   向当前输出流写入值的信息型文本表示。 
   新构造的类型应重载 ``show(io, x)`` ，其中 ``io`` 为流。

.. function:: print(x)

   如果值有标准（未修饰）的文本表示，则将其写入默认输出流；否则调用 ``show`` 。

.. function:: println(x)

   使用 :func:`print` 打印 ``x`` ，并接一个换行符。

.. function:: @printf([io::IOStream], "%Fmt", args...)

   使用 C 中 ``printf()`` 的样式来打印。 
   第一个参数可选择性指明 IOStream 来重定向输出。

.. function:: @sprintf("%Fmt", args...)
    
   按 ``@printf`` 的样式输出为字符串。

.. function:: showall(x)

   打印数组的所有元素。

.. function:: dump(x)

   向当前输出流写入值的完整文本表示。

.. function:: readall(stream)

   按照字符串读取 I/O 流的所有内容。

.. function:: readline(stream)

   读取一行文本，包括末尾的换行符（不管输入是否结束，遇到换行符就返回）。

.. function:: readuntil(stream, delim)

   读取字符串，直到指定的分隔符为止。字符串包括此分隔符。

.. function:: readlines(stream)

   将读入的所有行返回为数组。

.. function:: eachline(stream)

   构造可迭代对象，它从流中生成每一行文本。

.. function:: readdlm(filename, delim::Char)

   从文本文件中读取矩阵，文本中的每一行是矩阵的行，元素由指定的分隔符隔开。 
   如果所有的数据都是数值，结果为数值矩阵。如果有些元素不能被解析为数， 
   将返回由数和字符串构成的元胞数组。

.. function:: readdlm(filename, delim::Char, T::Type)

   从文本文件中读取指定元素类型的矩阵。如果 ``T`` 是数值类型，结果为此类型的数组： 
   若为浮点数类型，非数值的元素变为 ``NaN`` ；其余类型为 0 。 
   ``T`` 的类型还有 ``ASCIIString``, ``String``, 和 ``Any`` 。

.. function:: writedlm(filename, array, delim::Char)

   使用指定的分隔符（默认为逗号）将数组写入到文本文件。

.. function:: readcsv(filename, [T::Type])

   等价于 ``delim`` 为逗号的 ``readdlm`` 函数。

.. function:: writecsv(filename, array)

   等价于 ``delim`` 为逗号的 ``writedlm`` 函数。

内存映射 I/O
------------

.. function:: mmap_array(type, dims, stream, [offset])

   使用内存映射构造数组，数组的值连接到文件。 
   它提供了处理对计算机内存来说过于庞大数据的简便方法。

   ``type`` 决定了如何解释数组中的字节（不使用格式转换）。 
   ``dims`` 是包含字节大小的多元组。

   文件是由 ``stream`` 指明的。初始化流时，对“只读”数组使用 “r” ， 
   使用 "w+" 新建用于向硬盘写入值的数组。可以选择指明偏移值 
   （单位为字节），用来跳过文件头等。

   **例子** ：  A = mmap_array(Int64, (25,30000), s)

   它将构造一个 25 x 30000 的 Int64 类型的数列，它链接到与流 s 有关的文件上。

.. function:: msync(array)

   对内存映射数组的内存中的版本和硬盘上的版本强制同步。 
   程序员可能不需要调用此函数，因为操作系统在休息时自动同步。但是， 
   如果你担心丢失一个需要很长时间来运算的结果，就可以直接调用此函数。

.. function:: mmap(len, prot, flags, fd, offset)

   mmap 系统调用的低级接口。

.. function:: munmap(pointer, len)

   取消内存映射的低级接口。对于 mmap_array 则不需要直接调用此函数； 
   当数组离开作用域时，会自动取消内存映射。

标准数值类型
------------

``Bool`` ``Int8`` ``Uint8`` ``Int16`` ``Uint16`` ``Int32`` ``Uint32`` ``Int64`` ``Uint64`` ``Float32`` ``Float64`` ``Complex64`` ``Complex128``

数学函数
--------

.. function:: -(x)

   一元减运算符。

.. function:: +(x, y)

   二元加运算符。

.. function:: -(x, y)

   二元减运算符。

.. function:: *(x, y)

   二元乘运算符。

.. function:: /(x, y)

   二元左除运算符。

.. function:: \\(x, y)

   二元右除运算符。

.. function:: ^(x, y)

   二元指数运算符。

.. function:: .+(x, y)

   逐元素二元加运算符。

.. function:: .-(x, y)

   逐元素二元减运算符。

.. function:: .*(x, y)

   逐元素二元乘运算符。

.. function:: ./(x, y)

   逐元素二元左除运算符。

.. function:: .\\(x, y)

   逐元素二元右除运算符。

.. function:: .^(x, y)

   逐元素二元指数运算符。

.. function:: div(a,b)

   截断取整除法；商向 0 舍入。

.. function:: fld(a,b)

   向下取整除法；商向 -Inf 舍入。

.. function:: mod(x,m)

   取模余数；满足 x == fld(x,m)*m + mod(x,m) ，与 m 同号，返回值范围 [0,m) 。

.. function:: rem(x,m)

   除法余数；满足 x == div(x,m)*m + rem(x,m) ，与 x 同号。
   
.. function:: %(x, m)

   除法余数。 ``rem`` 的运算符形式。

.. function:: mod1(x,m)

   整除后取模，返回值范围为 (0,m] 。

.. function:: //(num, den)

   分数除法。

.. function:: num(x)

   分数 ``x`` 的分子。

.. function:: den(x)

   分数 ``x`` 的分母。

.. function:: <<(x, n)

   左移运算符。

.. function:: >>(x, n)

   右移运算符。

.. function:: >>>(x, n)

   无符号右移运算符。

.. function:: :(start, [step], stop)

   范围运算符。 ``a:b`` 构造一个步长为 1 ，从 ``a`` 到 ``b`` 的范围。
   ``a:s:b`` 构造步长为 ``s`` 的范围。此语法调用函数 ``colon`` 。
   冒号也用于索引来选定全部维度。

.. function:: colon(start, [step], stop)

   由 ``:`` 语法调用，用于构造范围。

.. function:: ==(x, y)

   相等运算符。

.. function:: !=(x, y)

   不等运算符。

.. function:: <(x, y)

   小于运算符。

.. function:: <=(x, y)

   小于等于运算符。

.. function:: >(x, y)

   大于运算符。

.. function:: >=(x, y)

   大于等于运算符。

.. function:: .==(x, y)

   逐元素相等运算符。

.. function:: .!=(x, y)

   逐元素不等运算符。

.. function:: .<(x, y)

   逐元素小于运算符。

.. function:: .<=(x, y)

   逐元素小于等于运算符。

.. function:: .>(x, y)

   逐元素大于运算符。

.. function:: .>=(x, y)

   逐元素大于等于运算符。

.. function:: cmp(x,y)

   根据 ``x<y``, ``x==y``, 或 ``x>y`` 三种情况，对应返回 -1, 0, 或 1 。

.. function:: !(x)

   逻辑非。

.. function:: ~(x)

   按位取反。

.. function:: &(x, y)

   逻辑与。

.. function:: |(x, y)

   逻辑或。

.. function:: $(x, y)

   按位异或。

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

   当 :math:`x \neq 0` 时为 :math:`\sin(\pi x) / (\pi x)` ；
   当 :math:`x = 0` 时为 :math:`1` 。

.. function:: cosc(x)

   当 :math:`x \neq 0` 时为 :math:`\cos(\pi x) / x - \sin(\pi x) / (\pi x^2)` ；
   当 :math:`x = 0` 时为 :math:`0` 。此函数由 ``sinc(x)`` 而得。

.. function:: degrees2radians(x)

   将 ``x`` 度数转换为弧度。

.. function:: radians2degrees(x)

   将 ``x`` 弧度转换为度数。

.. function:: hypot(x, y)

   计算 :math:`\sqrt{x^2+y^2}` ，计算过程不会出现上溢、下溢。

.. function:: log(x)
   
   计算 ``x`` 的自然对数。

.. function:: log2(x)

   计算 ``x`` 以 2 为底的对数。

.. function:: log10(x)

   计算 ``x`` 以 10 为底的对数。

.. function:: log1p(x)

   ``1+x`` 自然对数的精确值。

.. function:: frexp(val, exp)

   返回数 ``x`` ，满足 ``x`` 的取值范围为 ``[1/2, 1)`` 或 0 ，
   且 val = :math:`x \times 2^{exp}` 。

.. function:: exp(x)

   计算 :math:`e^x` 。

.. function:: exp2(x)

   计算 :math:`2^x` 。

.. function:: ldexp(x, n)

   计算 :math:`x \times 2^n` 。

.. function:: modf(x)

   返回一个数的小数部分和整数部分的多元组。两部分都与参数同正负号。

.. function:: expm1(x)

   :math:`e^x-1` 的精确值。

.. function:: square(x)

   计算 :math:`x^2` 。

.. function:: round(x, [digits, [base]]) -> FloatingPoint

   ``round(x)`` 返回离 ``x`` 最近的整数 ``round(x, digits)`` 
   若 ``digits`` 为正数时舍入到小数点后对应位数，若为负数， 
   舍入到小数点前对应位数，例子 ``round(pi,2) == 3.14`` 。 
   ``round(x, digits, base)`` 使用指定的进制来舍入，默认进制为 10，
   例如 ``round(pi, 3, 2) == 3.125`` 。

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

   将 ``x`` 舍入（使用 ``round`` 函数）到指定的有效位数。 
   ``digits`` 与 ``base`` 的解释参见 :func:`round` 。 
   例如 ``signif(123.456, 2) == 120.0`` ， ``signif(357.913, 4, 2) == 352.0`` 。 

.. function:: min(x, y)

   返回 ``x`` 和 ``y`` 的最小值。

.. function:: max(x, y)

   返回 ``x`` 和 ``y`` 的最大值。

.. function:: clamp(x, lo, hi)

   如果 ``lo <= x <= y`` 则返回 x 。如果 ``x < lo`` ，返回 ``lo`` 。
   如果 ``x > hi`` ，返回 ``hi`` 。

.. function:: abs(x)

   ``x`` 的绝对值。

.. function:: abs2(x)

   ``x`` 绝对值的平方。

.. function:: copysign(x, y)

   返回 ``x`` ，但其正负号与 ``y`` 相同。

.. function:: sign(x)

   如果 ``x`` 是正数时返回 ``+1`` ， ``x == 0`` 时返回 ``0`` ，
   ``x`` 是负数时返回 ``-1`` 。

.. function:: signbit(x)

   如果 ``x`` 是负数时返回 ``1`` ，否则返回 ``0`` 。

.. function:: flipsign(x, y)

   如果 ``y`` 为复数，返回 ``x`` 的相反数，否则返回 ``x`` 。
   如 ``abs(x) = flipsign(x,x)`` 。

.. function:: sqrt(x)
   
   返回 :math:`\sqrt{x}` 。

.. function:: cbrt(x)

   返回 :math:`x^{1/3}` 。

.. function:: erf(x)

   计算 ``x`` 的误差函数，其定义为 :math:`\frac{2}{\sqrt{\pi}} \int_0^x e^{-t^2} dt` 。

.. function:: erfc(x)

   计算 ``x`` 的互补误差函数， 
   其定义为 :math:`1 - \operatorname{erf}(x) = \frac{2}{\sqrt{\pi}} \int_x^{\infty} e^{-t^2} dt` 。

.. function:: erfcx(x)

   计算 ``x`` 的缩放互补误差函数，其定义为 :math:`e^{x^2} \operatorname{erfc}(x)` 。 
   注意 :math:`\operatorname{erfcx}(-ix)` 即为 Faddeeva 函数 :math:`w(x)` 。

.. function:: erfi(x)

   计算 ``x`` 的虚误差函数，其定义为 :math:`-i \operatorname{erf}(ix)`.

.. function:: dawson(x)

   计算 ``x`` 的 Dawson 函数（缩放虚误差函数）， 
   其定义为 :math:`\frac{\sqrt{\pi}}{2} e^{-x^2} \operatorname{erfi}(x)`.

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

   如果 ``z`` 是实数，返回 ``cos(z) + i*sin(z)`` 。如果 ``z`` 是实数， 
   返回 ``(cos(real(z)) + i*sin(real(z)))/exp(imag(z))`` 。

.. function:: binomial(n,k)

   从  ``n`` 项中选取 ``k`` 项，有多少种方法。

.. function:: factorial(n)

   n 的阶乘。

.. function:: factorial(n,k)

   计算 ``factorial(n)/factorial(k)``

.. function:: factor(n)

   对 ``n`` 分解质因数，返回一个字典。 
   字典的键对应于质因数，与 ``n`` 类型相同。 
   每个键的值显示因式分解中这个质因数出现的次数。

   **例子** ： :math:`100=2*2*5*5` ，因此 ``factor(100) -> [5=>2,2=>2]`` 

.. function:: gcd(x,y)

   最大公因数。

.. function:: lcm(x,y)

   最小公倍数。

.. function:: gcdx(x,y)

   最大公因数，同时返回整数因子 ``u`` 和 ``v`` ，满足 ``u*x+v*y == gcd(x,y)`` 。

.. function:: ispow2(n)

   判断 ``n`` 是否为 2 的幂。

.. function:: nextpow2(n)

   不小于 ``n`` 的值为 2 的幂的数。

.. function:: prevpow2(n)

   不大于 ``n`` 的值为 2 的幂的数。

.. function:: nextpow(a, n)

   不小于 ``n`` 的值为 ``a`` 的幂的数。

.. function:: prevpow(a, n)

   不大于 ``n`` 的值为 ``a`` 的幂的数。

.. function:: nextprod([a,b,c], n)

   不小于 ``n`` 的数，存在整数 ``i1``, ``i2``, ``i3`` ， 
   使这个数等于 ``a^i1 * b^i2 * c^i3`` 。

.. function:: prevprod([a,b,c], n)

   不大于 ``n`` 的数，存在整数 ``i1``, ``i2``, ``i3`` ， 
   使这个数等于 ``a^i1 * b^i2 * c^i3`` 。

.. function:: invmod(n,m)

   ``n``的关于模 ``m`` 的逆，即求满足 ``(x * n ) % m == 1`` 的数 ``x`` 。

.. function:: powermod(x, p, m)

   计算 ``mod(x^p, m)`` 。

.. function:: gamma(x)

   计算 ``x`` 的 gamma 函数。

.. function:: lgamma(x)

   计算 ``gamma(x)`` 的对数。

.. function:: lfact(x)

   计算 ``x`` 阶乘的对数。

.. function:: digamma(x)

   计算 ``x`` 的双伽玛函数（ ``gamma(x)`` 自然对数的导数）

.. function:: airy(x)

   艾里函数的 k 阶导数 :math:`\operatorname{Ai}(x)` 。

.. function:: airyai(x)

   艾里函数 :math:`\operatorname{Ai}(x)` 。

.. function:: airyprime(x)

   艾里函数的导数 :math:`\operatorname{Ai}'(x)` 。

.. function:: airyaiprime(x)

   艾里函数的导数 :math:`\operatorname{Ai}'(x)` 。

.. function:: airybi(x)

   艾里函数 :math:`\operatorname{Bi}(x)` 。

.. function:: airybiprime(x)

   艾里函数的导数 :math:`\operatorname{Bi}'(x)` 。

.. function:: besselj0(x)

   ``0`` 阶的第一类贝塞尔函数， :math:`J_0(x)` 。

.. function:: besselj1(x)

   ``1`` 阶的第一类贝塞尔函数， :math:`J_1(x)` 。

.. function:: besselj(nu, x)

   ``nu`` 阶的第一类贝塞尔函数， :math:`J_\nu(x)` 。

.. function:: bessely0(x)

   ``0`` 阶的第二类贝塞尔函数， :math:`Y_0(x)` 。

.. function:: bessely1(x)

   ``1`` 阶的第二类贝塞尔函数， :math:`Y_1(x)` 。

.. function:: bessely(nu, x)

   ``nu`` 阶的第二类贝塞尔函数， :math:`Y_\nu(x)` 。

.. function:: hankelh1(nu, x)

   ``nu`` 阶的第三类贝塞尔函数， :math:`H^{(1)}_\nu(x)` 。

.. function:: hankelh2(nu, x)

   ``nu`` 阶的第三类贝塞尔函数， :math:`H^{(2)}_\nu(x)` 。

.. function:: besseli(nu, x)

   ``nu`` 阶的变形第一类贝塞尔函数， :math:`I_\nu(x)` 。

.. function:: besselk(nu, x)

   ``nu`` 阶的变形第二类贝塞尔函数， :math:`K_\nu(x)` 。

.. function:: beta(x, y)

   第一型欧拉积分 
   :math:`\operatorname{B}(x,y) = \Gamma(x)\Gamma(y)/\Gamma(x+y)` 。

.. function:: lbeta(x, y)

   贝塔函数的自然对数 :math:`\log(\operatorname{B}(x,y))` 。

.. function:: eta(x)

   狄利克雷 :math:`\eta` 函数 :math:`\eta(s) = \sum^\infty_{n=1}(-)^{n-1}/n^{s}` 。

.. function:: zeta(x)

   黎曼 :math:`\zeta` 函数 :math:``\zeta(s)`` 。

.. function:: bitmix(x, y)

   将两个整数散列为一个整数。用于构造哈希函数。

.. function:: ndigits(n, b)

   计算用 ``b`` 进制表示 ``n`` 时的位数。

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

.. function:: base(base, n, [pad])

   将整数 ``n`` 转换为指定进制 ``base`` 的字符串。 
   可选择性指明空白补位后的位数。进制 ``base`` 可以为整数， 
   也可以是用于表征数字符号的字符值所对应的 ``Uint8`` 数组。

.. function:: bits(n)

   用二进制字符串文本表示一个数。

.. function:: parseint([type], str, [base])

   将字符串解析为指定类型（默认为 ``Int`` ）、指定进制（默认为 10 ）的整数。

.. function:: parsefloat([type], str)

   将字符串解析为指定类型的十进制浮点数。

.. function:: bool(x)

   将数或数值数组转换为布尔值类型的。

.. function:: isbool(x)

   判断数或数组是否是布尔值类型的。

.. function:: int(x)

   将数或数组转换为所使用电脑上默认的整数类型。 
   ``x`` 也可以是字符串，使用此函数时会将其解析为整数。

.. function:: uint(x)

   将数或数组转换为所使用电脑上默认的无符号整数类型。 
   ``x`` 也可以是字符串，使用此函数时会将其解析为无符号整数。

.. function:: integer(x)

   将数或数组转换为整数类型。如果 ``x`` 已经是整数类型，则不处理； 
   否则将其转换为所使用电脑上默认的整数类型。

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

   将数、数组、或字符串转换为 ``FloatingPoint`` 数据类型。 
   对数值数据，使用最小的恰当 ``FloatingPoint`` 类型。 
   对字符串，它将被转换为 ``Float64`` 类型。

.. function:: significand(x)

   提取浮点数或浮点数组的二进制表示的有效数字。
   
   例如， ``significand(15.2)/15.2 == 0.125`` 
   ``significand(15.2)*8 == 15.2`` 。
   
.. function:: exponent(x) -> Int

   返回浮点数 ``trunc( log2( abs(x) ) )`` 。

.. function:: float64_valued(x::Rational)

   如果 ``x`` 能被无损地用 ``Float64`` 数据类型表示，返回真。

.. function:: complex64(r,i)

   构造值为 ``r+i*im`` 的 ``Complex64`` 数据类型。

.. function:: complex128(r,i)

   构造值为 ``r+i*im`` 的 ``Complex128`` 数据类型。

.. function:: char(x)

   将数或数组转换为 ``Char`` 数据类型。

.. function:: complex(r,i)

   将实数或数组转换为复数。

.. function:: iscomplex(x) -> Bool

   判断数或数组是否为复数类型。

.. function:: isreal(x) -> Bool

   判断数或数组是否为实数类型。

.. function:: bswap(n)

   给出将一个整数的字节翻转后所得的整数。

.. function:: num2hex(f)

   将浮点数的二进制表示转换为十六进制字符串。

.. function:: hex2num(str)

   将十六进制字符串转换为它所表示的浮点数。

数
--

.. function:: one(x)

   获取与 x 同类型的乘法单位元（ x 也可为类型），即用该类型表示数值 1 。 
   对于矩阵，返回与之大小、类型相匹配的的单位矩阵。

.. function:: zero(x)

   获取与 x 同类型的加法单位元（ x 也可为类型），即用该类型表示数值 0 。 
   对于矩阵，返回与之大小、类型相匹配的的全零矩阵。

.. data:: pi

   常量 pi 。

.. data:: im

   虚数单位。

.. data:: e

   常量 e 。

.. data:: Inf

   正无穷，类型为 Float64 。

.. data:: Inf32

   正无穷，类型为 Float32 。

.. data:: NaN

   表示“它不是数”的值，类型为 Float64 。

.. data:: NaN32

   表示“它不是数”的值，类型为 Float32 。

.. function:: isdenormal(f) -> Bool

   判断浮点数是否为反常值。

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

   获取下一个绝对值稍大的同正负号的浮点数。

.. function:: prevfloat(f) -> Float

   获取下一个绝对值稍小的同正负号的浮点数。

.. function:: integer_valued(x)

   判断 ``x`` 在数值上是否为整数。

.. function:: real_valued(x)

   判断 ``x`` 在数值上是否为实数。

.. function:: BigInt(x)

   构造任意精度的整数。
   ``x`` 可以是 ``Int`` （或可以被转换为 ``Int`` 的）或 ``String`` 。 
   可以对其使用常用的数学运算符，结果被提升为 ``BigInt`` 类型。

.. function:: BigFloat(x)

   构造任意精度的浮点数。
   ``x`` 可以是 ``Integer``, ``Float64``, ``String`` 或 ``BigInt`` 。 
   可以对其使用常用的数学运算符，结果被提升为 ``BigFloat`` 类型。

整数
~~~~

.. function:: count_ones(x::Integer) -> Integer

   ``x`` 的二进制表示中有多少个 1 。
   
   **例子** ： ``count_ones(7) -> 3``

.. function:: count_zeros(x::Integer) -> Integer

   ``x`` 的二进制表示中有多少个 0 。
   
   **例子** ： ``count_zeros(int32(2 ^ 16 - 1)) -> 16``

.. function:: leading_zeros(x::Integer) -> Integer

   ``x`` 的二进制表示中开头有多少个 0 。
   
   **例子** ： ``leading_zeros(int32(1)) -> 31``

.. function:: leading_ones(x::Integer) -> Integer

   ``x`` 的二进制表示中开头有多少个 1 。
   
   **例子** ： ``leading_ones(int32(2 ^ 32 - 2)) -> 31``

.. function:: trailing_zeros(x::Integer) -> Integer

   ``x`` 的二进制表示中末尾有多少个 0 。
   
   **例子** ： ``trailing_zeros(2) -> 1``

.. function:: trailing_ones(x::Integer) -> Integer

   ``x`` 的二进制表示中末尾有多少个 1 。
   
   **例子** ： ``trailing_ones(3) -> 2``

.. function:: isprime(x::Integer) -> Bool

   如果 ``x`` 是质数，返回 ``true`` ；否则为 ``false`` 。

   **例子** ： ``isprime(3) -> true``

.. function:: isodd(x::Integer) -> Bool

   如果 ``x`` 是奇数，返回 ``true`` ；否则为 ``false`` 。

   **例子** ： ``isodd(9) -> false``

.. function:: iseven(x::Integer) -> Bool

   如果 ``x`` 是偶数，返回 ``true`` ；否则为 ``false`` 。

   **例子** ： ``iseven(1) -> false``


随机数
------

Julia 使用 `Mersenne Twister 库 <http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/#dSFMT>`_ 来生成随机数。Julia 默认使用全局随机数生成器 RNG 。可以使用 ``AbstractRNG`` 对象来插入多个 RNG ，用来生成多个随机数流。目前只支持 ``MersenneTwister`` 。

.. function:: srand([rng], seed)

   使用 ``seed`` 为 RNG 的种子，可以是无符号整数或向量。 
   ``seed`` 也可以是文件名，此时从文件中读取种子。 
   如果省略参数 ``rng`` ，则默认为全局 RNG 。

.. function:: MersenneTwister([seed])

   构造一个 ``MersenneTwister`` RNG 对象。 
   不同的 RNG 对象可以有不同的种子，这对于生成不同的随机数流非常有用。

.. function:: rand()

   生成 [0,1) 内均匀分布的 ``Float64`` 随机数。

.. function:: rand!([rng], A)

   向数组 ``A`` 中赋值由指定 RNG 生成的随机数。

.. function:: rand(rng::AbstractRNG, [dims...])

   使用指定的 RNG 对象，生成 ``Float64`` 类型的随机数或数组。 
   目前仅提供 ``MersenneTwister`` 随机数生成器 RNG ， 
   可由 ``srand`` 函数设置随机数种子。

.. function:: rand(dims 或 [dims...])

   生成指定维度的 ``Float64`` 类型的随机数组。

.. function:: rand(Int32|Uint32|Int64|Uint64|Int128|Uint128, [dims...])

   生成指定整数类型的随机数。若指定维度，则生成对应类型的随机数组。

.. function:: rand(r, [dims...])

   从 ``Range1`` r 的范围中产生随机整数（如 ``1:n`` ，包括 1 和 n）。
   也可以生成随机整数数组。

.. function:: randbool([dims...])

   生成随机布尔值。若指定维度，则生成布尔值类型的随机数组。

.. function:: randbool!(A)

   将数组中的元素赋值为随机布尔值。 ``A`` 可以是 ``Array`` 或 ``BitArray`` 。

.. function:: randn(dims 或 [dims...])

   生成均值为 0 ，标准差为 1 的标准正态分布随机数。 
   若指定维度，则生成标准正态分布的随机数组。

数组
----

基础函数
~~~~~~~~

.. function:: ndims(A) -> Integer

   返回 ``A`` 有几个维度。

.. function:: size(A)

   返回 ``A`` 的维度多元组。

.. function:: eltype(A)

   返回 ``A`` 中元素的类型。

.. function:: length(A) -> Integer

   返回 ``A`` 中所有元素的个数。（它与 MATLAB 中的定义不同。）

.. function:: nnz(A)

   数组 ``A`` 中非零元素的个数。可适用于稠密或稀疏数组。

.. function:: scale!(A, k)

   原地将数组 ``A`` 的内容乘以 k 。
   
.. function:: conj!(A)

   原地求数组的复数共轭。

.. function:: stride(A, k)

   返回维度 k 上相邻的两个元素在内存中的距离（单位为元素个数）

.. function:: strides(A)

   返回每个维度上内存距离的多元组。

.. function:: ind2sub(dims, index) -> subscripts

   Returns a tuple of subscripts into an array with dimensions ``dims``, corresponding to the linear index ``index``

   **例子** ``i, j, ... = ind2sub(size(A), indmax(A))`` provides the indices of the maximum element

.. function:: sub2ind(dims, i, j, k...) -> index

   The inverse of ``ind2sub``, returns the linear index corresponding to the provided subscripts

构造函数
~~~~~~~~

.. function:: Array(type, dims)

   构造一个未初始化的稠密数组。 ``dims`` 可以是整数参数的多元组或集合。

.. function:: getindex(type[, elements...])

   构造指定类型的一维数组。它常被 ``Type[]`` 语法调用。 
   元素值可由 ``Type[a,b,c,...]`` 指明。

.. function:: cell(dims)

   构造未初始化的元胞数组（异构数组）。 ``dims`` 可以是整数参数的多元组或集合。
   
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

   构造与指定数组同样数据的新数组，但维度不同。 
   特定类型数组的实现自动选择复制或共享数据。

.. function:: similar(array, [element_type, dims])

   构造与指定数组相同类型的未初始化数组。可选择性指定指定了元素类型和维度。 
   ``dims`` 参数可以是整数参数的多元组或集合。

.. function:: reinterpret(type, A)

   构造与指定数组同样二进制数据的新数组，但为指定的元素类型。

.. function:: eye(n)

   ``n x n`` 单位矩阵。

.. function:: eye(m, n)

   ``m x n`` 单位矩阵。

.. function:: linspace(start, stop, n)

   构造从 ``start`` 到 ``stop`` 的 ``n`` 个元素的向量，元素之间的步长为线性。

.. function:: logspace(start, stop, n)

   构造从 ``10^start`` 到 ``10^stop`` 的 ``n`` 个元素的向量，元素之间的步长为对数。

数学运算符和函数
~~~~~~~~~~~~~~~~

数组可以使用所有的数学运算和函数。

.. function:: bsxfun(fn, A, B[, C...])

   对两个或两个以上的数组使用二元函数 ``fn`` ，它会展开单态的维度。

索引，赋值和连接
~~~~~~~~~~~~~~~~

.. function:: getindex(A, ind)

   返回 ``ind`` 位置的数组 ``A`` 的子集，结果可能是 ``Int``, ``Range``, 或 ``Vector`` 。

.. function:: sub(A, ind)

   返回 ``SubArray`` ，它存储 ``A`` 和 ``ind`` ，但不立即计算。 
   对 ``SubArray`` 调用 ``getindex`` 时才计算。

.. function:: slicedim(A, d, i)

   返回 ``A`` 中维度 ``d`` 上索引值为 ``i`` 的所有数据。 
   等价于 ``A[:,:,...,i,:,:,...]`` ，其中 ``i`` 在位置 ``d`` 上。

.. function:: setindex!(A, X, ind)

   在 ``ind`` 指定的 ``A`` 子集上存储 ``X`` 的值。

.. function:: cat(dim, A...)

   在指定维度上连接。

.. function:: vcat(A...)

   在维度 1 上连接。

.. function:: hcat(A...)

   在维度 2 上连接。

.. function:: hvcat(rows::(Int...), values...)

   在水平和垂直上连接。此函数用于块矩阵语法。 
   第一个参数多元组指明每行要连接的参数个数。 
   例如， ``[a b;c d e]`` 调用 ``hvcat((2,3),a,b,c,d,e)`` 。

.. function:: flipdim(A, d)

   在维度 ``d`` 上翻转。

.. function:: flipud(A)

   等价于 ``flipdim(A,1)`` 。

.. function:: fliplr(A)

   等价于 ``flipdim(A,2)`` 。

.. function:: circshift(A,shifts)

   循环移位数组中的数据。第二个参数为每个维度上移位数值的向量。

.. function:: find(A)

   返回数组 ``A`` 中非零值的线性索引值向量。

.. function:: findn(A)

   返回数组 ``A`` 中每个维度上非零值的索引值向量。
   
.. function:: nonzeros(A)

   返回数组 ``A`` 中非零值的向量。

.. function:: findfirst(A)

   返回数组 ``A`` 中第一个非零值的索引值。

.. function:: findfirst(A,v)

   返回数组 ``A`` 中第一个等于 ``v`` 的元素的索引值。

.. function:: findfirst(predicate, A)

   返回数组 ``A`` 中第一个满足指定断言的元素的索引值。

.. function:: permutedims(A,perm)

   重新排列数组 ``A`` 的维度。 
   ``perm`` 为长度为 ``ndims(A)`` 的向量，它指明如何排列。 
   此函数是多维数组的广义转置。转置等价于 ``permute(A,[2,1])`` 。

.. function:: ipermutedims(A,perm)

   类似 :func:`permutedims` ，但它使用指定排列的逆排列。

.. function:: squeeze(A, dims)

   移除 ``A`` 中 ``dims`` 指定的维度。此维度大小应为 1 。

.. function:: vec(Array) -> Vector

   以列序为主序将数组向量化。

数组函数
~~~~~~~~

.. function:: cumprod(A, [dim])

   沿某个维度的累积乘法。

.. function:: cumsum(A, [dim])

   沿某个维度的累积加法。
   
.. function:: cumsum_kbn(A, [dim])

   沿某个维度的累积加法。使用 Kahan-Babuska-Neumaier 的加法补偿算法来提高精度。

.. function:: cummin(A, [dim])

   沿某个维度的累积最小值。

.. function:: cummax(A, [dim])

   沿某个维度的累积最大值。

.. function:: diff(A, [dim])

   沿某个维度的差值（第 2 个减去第 1 个，... ，第 n 个减去第 n-1 个）。

.. function:: rot180(A)

   将矩阵 ``A`` 旋转 180 度。

.. function:: rotl90(A)

   将矩阵 ``A`` 向左旋转 90 度。

.. function:: rotr90(A)

   将矩阵 ``A`` 向右旋转 90 度。

.. function:: reducedim(f, A, dims, initial)

   沿 ``A`` 的某个维度使用 ``f`` 函数进行约简。 
   ``dims`` 指明了约简的维度， ``initial`` 为约简的初始值。
   
.. function:: mapslices(f, A, dims)

   在 ``A`` 的指定维度上应用函数 ``f`` 。 
   ``A`` 的每个切片 ``A[...,:,...,:,...]`` 上都调用函数 ``f`` 。 
   整数向量 ``dims`` 指明了维度信息。结果将沿着未指明的维度进行连接。 
   例如，如果 ``dims`` 为 ``[1,2]`` ， ``A`` 是四维数组， 
   此函数将对每个 ``i`` 和 ```j` 调用 ``f`` 处理 ``A[:,:,i,j]`` 。

.. function:: sum_kbn(A)

   返回数组中所有元素的总和。 
   使用 Kahan-Babuska-Neumaier 的加法补偿算法来提高精度。

排列组合
--------

.. function:: nthperm(v, k)

   按字典顺序返回向量的第 k 种排列。

.. function:: nthperm!(v, k)

   :func:`nthperm` 的原地版本。

.. function:: randperm(n)

   构造指定长度的随机排列。

.. function:: invperm(v)

   返回 v 的逆排列。

.. function:: isperm(v) -> Bool

   如果 v 是有效排列，则返回 ``true`` 。

.. function:: permute!(v, p)

   根据排列 ``p`` 对向量 ``v`` 进行原地排列。此函数不验证 ``p`` 是否为排列。

   使用 ``v[p]`` 返回新排列。对于大向量，它通常比 ``permute!(v,p)`` 快。

.. function:: ipermute!(v, p)

   类似 permute! ，但它使用指定排列的逆排列。

.. function:: randcycle(n)

   构造指定长度的随机循环排列。

.. function:: shuffle(v)

   随机重新排列向量中的元素。

.. function:: shuffle!(v)

   :func:`shuffle` 的原地版本。

.. function:: reverse(v)

   逆序排列向量 ``v`` 。

.. function:: reverse!(v) -> v

   :func:`reverse` 的原地版本。

.. function:: combinations(array, n)

   从指定数组生成 ``n`` 个元素的所有组合。 
   由于组合的个数很多，这个函数应在 Task 内部使用。 
   写成 ``c = @task combinations(a,n)`` 的形式， 
   然后迭代 ``c`` 或对其调用 ``consume`` 。

.. function:: integer_partitions(n, m)

   生成由 ``m`` 个整数加起来等于 ``n`` 的所有数组。 
   由于组合的个数很多，这个函数应在 Task 内部使用。 
   写成 ``c = @task integer_partitions(n,m)`` 的形式， 
   然后迭代 ``c`` 或对其调用 ``consume`` 。

.. function:: partitions(array)

   生成数组中元素所有可能的组合，表示为数组的数组。 
   由于组合的个数很多，这个函数应在 Task 内部使用。 
   写成 ``c = @task partitions(a)`` 的形式， 
   然后迭代 ``c`` 或对其调用 ``consume`` 。

统计
----

.. function:: mean(v[, region])

   计算整个数组 ``v`` 的均值，或按 ``region`` 中列出的维度计算（可选）。

.. function:: std(v[, region])

   计算向量或数组 ``v`` 的样本标准差，可选择按 ``region`` 中列出的维度计算。 
   算法在 ``v`` 中的每个元素都是从某个生成分布中独立同分布地取得的假设下， 
   返回一个此生成分布标准差的估计。 
   它等价于 ``sqrt(sum((v - mean(v)).^2) / (length(v) - 1))`` 。

.. function:: stdm(v, m)

   计算已知均值为 ``m`` 的向量 ``v`` 的样本标准差。

.. function:: var(v[, region])

   计算向量或数组 ``v`` 的样本方差，可选择按 ``region`` 中列出的维度计算。 
   算法在 ``v`` 中的每个元素都是从某个生成分布中独立同分布地取得的假设下， 
   返回一个此生成分布方差的估计。 
   它等价于 ``sum((v - mean(v)).^2) / (length(v) - 1)`` 。

.. function:: varm(v, m)

   计算已知均值为 ``m`` 的向量 ``v`` 的样本方差。

.. function:: median(v)

   计算向量 ``v`` 的中位数。

.. function:: hist(v[, n]) -> e, counts

   计算 ``v`` 的直方图，可以指定划大致分为 ``n`` 个区间。
   返回值为范围 ``e`` ，对应于区间的边缘，
   ``counts`` 为每个区间中 ``v`` 的元素个数。

.. function:: hist(v, e) -> e, counts

   结果为长为 ``length(e)-1`` 的向量，且第 ``i`` 个元素满足
   ``sum(e[i] .< v .<= e[i+1])``

.. function:: histrange(v, n)

   Compute `nice` bin ranges for the edges of a histogram of ``v``, using
   approximately ``n`` bins. The resulting step sizes will be 1, 2 or 5
   multiplied by a power of 10.

.. function:: midpoints(e)

   Compute the midpoints of the bins with edges ``e``. The result is a
    vector/range of length ``length(e) - 1``. 
 
.. function:: quantile(v, p)

   计算向量 ``v`` 在指定概率值集合 ``p`` 处的分位数。

.. function:: quantile(v)

   计算向量 ``v`` 在概率值 ``[.0, .2, .4, .6, .8, 1.0]`` 处的分位数。

.. function:: cov(v1[, v2])

   计算两个向量 ``v1`` 和 ``v2`` 的协方差。 
   如果调用时只有 ``v`` 这一个参数，它计算 ``v`` 中列的协方差。

.. function:: cor(v1[, v2])

   计算两个向量 ``v1`` 和 ``v2`` 的 Pearson 相关系数。 
   如果调用时只有 ``v`` 这一个参数，它计算 ``v`` 中列的相关系数。

信号处理
--------

Julia 中的 FFT 函数，大部分调用的是 `FFTW <http://www.fftw.org>`_ 中的函数。

.. function:: fft(A [, dims])

   对数组 ``A`` 做多维 FFT 。可选参数 ``dims`` 指明了关于维度的可迭代集合（如整数、 
   范围、多元组、数组）。如果 ``A`` 要运算的维度上的长度是较小的质数的积， 
   算法会比较高效；详见 :func:`nextprod` 。另见高效的 :func:`plan_fft` 。
   
   一维 FFT 计算一维离散傅里叶变换（DFT），其定义为 
   :math:`\operatorname{DFT}[k] = \sum_{n=1}^{\operatorname{length}(A)} 
   \exp\left(-i\frac{2\pi (n-1)(k-1)}{\operatorname{length}(A)} \right) A[n]` 。 
   多维 FFT 对 ``A`` 的多个维度做此运算。

.. function:: fft!(A [, dims])

   与 :func:`fft` 类似，但在原地对 ``A`` 运算， ``A`` 必须是复数浮点数数组。

.. function:: ifft(A [, dims])

   多维 IFFT 。

   一维反向 FFT 计算 
   :math:`\operatorname{BDFT}[k] =
   \sum_{n=1}^{\operatorname{length}(A)} \exp\left(+i\frac{2\pi
   (n-1)(k-1)}{\operatorname{length}(A)} \right) A[n]` 。 
   多维反向 FFT 对 ``A`` 的多个维度做此运算。IFFT 将其结果除以所运算的维度大小的积。

.. function:: ifft!(A [, dims])

   与 :func:`ifft` 类似，但在原地对 ``A`` 进行运算。

.. function:: bfft(A [, dims])

   类似 :func:`ifft` ，但计算非归一化的（即反向）变换。 
   它的结果需要除以所运算的维度大小的积，才是 IFFT 的结果。 
   （它比 :func:`ifft` 稍微高效一点儿，因为它省略了归一化的步骤； 
   有时归一化的步骤可以与其它地方的其它计算合并在一起做。）

.. function:: bfft!(A [, dims])

   与 :func:`bfft` 类似，但在原地对 ``A`` 进行运算。

.. function:: plan_fft(A [, dims [, flags [, timelimit]]])

   在数组 ``A`` 的指定维度上（ ``dims`` ）制定优化 FFT 的方案。 
   （前两个参数的意义参见 :func:`fft` 。） 
   返回可快速计算 ``fft(A, dims)`` 的函数。

   ``flags`` 参数时按位或的 FFTW 方案标志位，默认为 ``FFTW.ESTIMATE`` 。 
   如果使用 ``FFTW.MEASURE`` 或 ``FFTW.PATIENT`` 会先花几秒钟（或更久） 
   来对不同的 FFT 算法进行分析，选取最快的。有关方案标志位，详见 FFTW 手册。 
   可选参数 ``timelimit`` 指明制定方案时间的粗略上界，单位为秒。 
   如果使用 ``FFTW.MEASURE`` 或 ``FFTW.PATIENT`` 会在制定方案时覆写输入数组 ``A`` 。

   :func:`plan_fft!` 与 :func:`plan_fft` 类似，但它在参数的原地制定方案 
   （参数应为复浮点数数组）。 :func:`plan_ifft` 等类似， 
   但它们指定逆变换  :func:`ifft`  等的方案。

.. function:: plan_ifft(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_fft` 类似，但产生逆变换 :func:`ifft` 的方案。

.. function:: plan_bfft(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_fft` 类似，但产生反向变换 :func:`bfft` 的方案。

.. function:: plan_fft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_fft` 类似，但在原地对 ``A`` 进行运算。

.. function:: plan_ifft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_ifft` 类似，但在原地对 ``A`` 进行运算。

.. function:: plan_bfft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_bfft` 类似，但在原地对 ``A`` 进行运算。

.. function:: rfft(A [, dims])

   对实数数组 ``A`` 做多维 FFT 。由于转换具有共轭对称性，相比 :func:`fft` ， 
   可节约将近一半的计算时间和存储空间。 
   如果 ``A`` 的大小为 ``(n_1, ..., n_d)`` ， 
   结果的大小为 ``(floor(n_1/2)+1, ..., n_d)`` 。

   与 :func:`fft` 类似，可选参数 ``dims`` 指明了关于维度的可迭代集合（如整数、范围、 
   多元组、数组）。但结果中 ``dims[1]`` 维度大约只有一半。

.. function:: irfft(A, d [, dims])

   对复数组 ``A`` 做 :func:`rfft`: 的逆运算。 
   它给出 FFT 后可生成 ``A`` 的对应的实数数组的前半部分。 
   与 :func:`rfft` 类似， ``dims`` 是可选项，默认为 ``1:ndims(A)`` 。

   ``d`` 是转换后的实数数组在 ``dims[1]`` 维度上的长度， 
   必须满足 ``d == floor(size(A,dims[1])/2)+1`` 。 
   （此参数不能从 ``size(A)`` 推导出来，因为使用了 ``floor`` 函数。）

.. function:: brfft(A, d [, dims])

   与 :func:`irfft` 类似，但它计算非归一化逆变换（与 :func:`bfft` 类似）。 
   要得到逆变换，需将结果除以除以（实数输出矩阵）所运算的维度大小的积。

.. function:: plan_rfft(A [, dims [, flags [, timelimit]]])

   制定优化实数输入 FFT 的方案。 
   与 :func:`plan_fft` 类似，但它对应于 :func:`rfft` 。 
   前两个参数及变换后的大小，都与 :func:`rfft` 相同。

.. function:: plan_irfft(A, d [, dims [, flags [, timelimit]]])

   制定优化实数输入 FFT 的方案。 
   与 :func:`plan_rfft` 类似，但它对应于 :func:`irfft` 。 
   前三个参数的意义与 :func:`irfft` 相同。
   
.. function:: plan_brfft(A, d [, dims [, flags [, timelimit]]])

   制定优化实数输入 FFT 的方案。 
   与 :func:`plan_rfft` 类似，但它对应于 :func:`brfft` 。 
   前三个参数的意义与 :func:`brfft` 相同。

.. function:: dct(A [, dims])

   对数组 ``A`` 做第二类离散余弦变换（DCT），使用归一化的 DCT 。 
   与 :func:`fft` 类似，可选参数 ``dims`` 指明了关于维度的可迭代集合 
   （如整数、范围、多元组、数组）。 
   如果 ``A`` 要运算的维度上的长度是较小的质数的积，算法会比较高效； 
   详见 :func:`nextprod` 。另见高效的 :func:`plan_dct` 。

.. function:: dct!(A [, dims])

   与 :func:`dct!` 类似，但在原地对 ``A`` 进行运算。 
   ``A`` 必须是实数或复数的浮点数数组。

.. function:: idct(A [, dims])

   对数组 ``A`` 做多维逆离散余弦变换（IDCT）（即归一化的第三类 DCT）。 
   可选参数 ``dims`` 指明了关于维度的可迭代集合（如整数、范围、 
   多元组、数组）。如果 ``A`` 要运算的维度上的长度是较小的质数的积， 
   算法会比较高效；详见 :func:`nextprod` 。另见高效的 :func:`plan_idct` 。

.. function:: idct!(A [, dims])

   与 :func:`idct!` 类似，但在原地对 ``A`` 进行运算。

.. function:: plan_dct(A [, dims [, flags [, timelimit]]])

   制定优化 DCT 的方案。 
   与 :func:`plan_fft` 类似，但对应于 :func:`dct` 。 
   前两个参数的意义与 :func:`dct` 相同。

.. function:: plan_dct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_dct` 类似，但在原地对 ``A`` 进行运算。

.. function:: plan_idct(A [, dims [, flags [, timelimit]]])

   制定优化 IDCT 的方案。 
   与 :func:`plan_fft` 类似，但对应于 :func:`idct` 。 
   前两个参数的意义与 :func:`idct` 相同。

.. function:: plan_idct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_idct` 类似，但在原地对 ``A`` 进行运算。

.. function:: FFTW.r2r(A, kind [, dims])

   对数组 ``A`` 做种类为 ``kind`` 的多维实数输入实数输出（r2r）变换。 
   ``kind`` 指明各类离散余弦变换 （ ``FFTW.REDFT00``, ``FFTW.REDFT01``, 
   ``FFTW.REDFT10``, 或 ``FFTW.REDFT11`` ）、各类离散正弦变换 
   （ ``FFTW.RODFT00``, ``FFTW.RODFT01``, ``FFTW.RODFT10``, 或 
   ``FFTW.RODFT11`` ）、实数输入半复数输出的 DFT （ ``FFTW.R2HC`` 
   及它的逆 ``FFTW.HC2R``)，或离散 Hartley 变换（ ``FFTW.DHT`` ）。 
   参数 ``kind`` 可以为数组或多元组， 
   可用来指明在 ``A`` 的不同维度上做不同种类的变换； 
   对未指明的维度使用 ``kind[end]`` 。 
   有关这些变换类型的精确定义，详见 `FFTW 手册 <http://www.fftw.org/doc>`_ 。

   可选参数 ``dims`` 指明了关于维度的可迭代集合（如整数、范围、多元组、数组）。 
   ``kind[i]`` 是对维度 ``dims[i]`` 的变换种类。 
   当 ``i > length(kind)`` 时使用 ``kind[end]`` 。

   另见 :func:`FFTW.plan_r2r` ，它制定优化 r2r 的方案。

.. function:: FFTW.r2r!(A, kind [, dims])

   :func:`FFTW.r2r!` 与 :func:`FFTW.r2r` 类似，但在原地对 ``A`` 进行运算。 
   ``A`` 必须是实数或复数的浮点数数组。

.. function:: FFTW.plan_r2r(A, kind [, dims [, flags [, timelimit]]])

   制定优化 r2r 的方案。与 :func:`plan_fft` 类似，但它对应于 :func:`FFTW.r2r` 。 

.. function:: FFTW.plan_r2r!(A, kind [, dims [, flags [, timelimit]]])

   与 :func:`plan_fft` 类似，但它对应于 :func:`FFTW.r2r!` 。 

.. function:: fftshift(x)

   交换 ``x`` 每个维度的上半部分和下半部分。

.. function:: fftshift(x,dim)

   交换 ``x`` 指定维度的上半部分和下半部分。

.. function:: ifftshift(x, [dim])

   ``fftshift`` 的逆运算。

.. function:: filt(b,a,x)

   对向量 ``x`` 使用由向量 ``a`` 和 ``b`` 描述的过滤器。

.. function:: deconv(b,a)

   构造向量 ``c`` ，满足 ``b = conv(a,c) + r`` 。等价于多项式除法。

.. function:: conv(u,v)

   计算两个向量的卷积。使用 FFT 算法。

.. function:: xcorr(u,v)

   计算两个向量的互相关。

并行计算
--------

.. function:: addprocs_local(n)

   在当前机器上添加一个进程。适用于多核。

.. function:: addprocs_ssh({"host1","host2",...})

   通过 SSH 在远程机器上添加进程。需要在每个节点的相同位置安装 Julia ， 
   或者通过共享文件系统可以使用 Julia 。

.. function:: addprocs_sge(n)

   通过 Sun/Oracle Grid Engine batch queue 来添加进程，使用 ``qsub`` 。

.. function:: nprocs()

   获取当前可用处理器的个数。

.. function:: myid()

   获取当前处理器的 ID 。

.. function:: pmap(f, c)

   并行地将函数 ``f`` 映射到集合 ``c`` 的每个元素上。

.. function:: remote_call(id, func, args...)

   在指定的处理器上，对指定参数异步调用函数。返回 ``RemoteRef`` 。

.. function:: wait(RemoteRef)

   等待指定的 ``RemoteRef`` 所需的值为可用。

.. function:: fetch(RemoteRef)

   等待并获取 ``RemoteRef`` 的值。

.. function:: remote_call_wait(id, func, args...)

   在一个信息内运行 ``wait(remote_call(...))`` 。

.. function:: remote_call_fetch(id, func, args...)

   在一个信息内运行 ``fetch(remote_call(...))`` 。

.. function:: put(RemoteRef, value)

   把值存储在 ``RemoteRef`` 中。它的实现符合“共享长度为 1 的队列”： 
   如果现在有一个值，除非值由 ``take`` 函数移除，否则一直阻塞。

.. function:: take(RemoteRef)

   取回 ``RemoteRef`` 的值，将其移除，从而清空 ``RemoteRef`` 。

.. function:: RemoteRef()

   在当前机器上生成一个未初始化的 ``RemoteRef`` 。

.. function:: RemoteRef(n)

   在处理器 ``n`` 上生成一个未初始化的 ``RemoteRef`` 。

分布式数组
----------

.. function:: DArray(init, dims, [procs, dist])

   构造分布式数组。 ``init`` 函数接收索引值范围多元组为参数， 
   此函数为指定的索引值返回分布式数组中对应的块。 
   ``dims`` 为整个分布式数组的大小。 
   ``procs`` 为要使用的处理器 ID 的向量。 
   ``dist`` 是整数向量，指明分布式数组在每个维度上需要划分为多少块。

.. function:: dzeros(dims, ...)

   构造全零的分布式数组。尾参数可参见 ``darray`` 。

.. function:: dones(dims, ...)

   构造全一的分布式数组。尾参数可参见 ``DArray`` 。

.. function:: dfill(x, dims, ...)

   构造值全为 ``x`` 的分布式数组。尾参数可参见 ``DArray`` 。

.. function:: drand(dims, ...)

   构造均匀分布的随机分布式数组。尾参数可参见 ``DArray`` 。

.. function:: drandn(dims, ...)

   构造正态分布的随机分布式数组。尾参数可参见 ``DArray`` 。

.. function:: distribute(a)

   将本地数组转换为分布式数组。

.. function:: localize(d)

   获取分布式数组 ``d`` 的本地部分。

.. function:: myindexes(d)

   分布式数组 ``d`` 的本地部分所对应的索引值的多元组。

.. function:: procs(d)

   获取存储分布式数组 ``d`` 的处理器 ID 的向量。

系统
----

.. function:: run(command)

   执行命令对象。如果出错或进程退出时为非零状态，将报错。 
   命令是由倒引号引起来的。

.. function:: spawn(command)

   异步运行命令，返回生成的 ``Process`` 对象。

.. function:: success(command)

   执行命令对象，并判断是否成功（退出代码是否为 0 ）。命令是由倒引号引起来的。

.. function:: readsfrom(command)

   异步运行命令，返回 (stream,process) 多元组。 
   第一个值是从进程的标准输出读出的流。

.. function:: writesto(command)

   异步运行命令，返回 (stream,process) 多元组。 
   第一个值是向进程的标准输入写入的流。

.. function:: readandwrite(command)

   异步运行命令，返回 (stdout,stdin,process) 多元组， 
   分别为进程的输出流、输入流，及进程本身。

.. function:: >

   重定向进程的标准输出流。

   **例子**: ``run(`ls` > "out.log")``

.. function:: <

   重定向进程的标准输入流流。

.. function:: >>

   重定向进程的标准输出流，添加到目标文件尾部。

.. function:: .>

   重定向进程的标准错误流。

.. function:: gethostname() -> String

   获取本机的主机名。

.. function:: getipaddr() -> String

   获取本机的 IP 地址，形为 "x.x.x.x" 的字符串。

.. function:: pwd() -> String

   获取当前的工作目录。

.. function:: cd(dir::String)

   设置当前工作文件夹。返回新的当前文件夹。

.. function:: cd(f, ["dir"])

   临时更改当前工作文件夹（未指明主文件夹），调用 f 函数，然后返回原文件夹。

.. function:: mkdir(path, [mode])

   新建名为 ``path`` 的文件夹，其权限为 ``mode`` 。 ``mode`` 默认为 0o777 ， 
   可通过当前文件创建掩码来修改。

.. function:: mkpath(path, [mode])

   创建指定路径 ``path`` 中的所有文件夹，其权限为 ``mode`` 。
   ``mode`` 默认为 0o777 ，可通过当前文件创建掩码来修改。

.. function:: rmdir(path)

   删除 ``path`` 文件夹。

.. function:: getpid() -> Int32

   获取 Julia 的进程 ID 。

.. function:: time()

   获取系统自 1970-01-01 00:00:00 UTC 起至今的秒数。 
   结果是高解析度（一般为微秒 :math:`10^{-6}` ）的。

.. function:: time_ns()

   获取时间，单位为纳秒 :math:`10^{-9}` 。 
   对应于 0 的时间是未定义的，计时时间 5.8 年为最长周期。

.. function:: tic()

   设置计时器， :func:`toc` 或 :func:`toq` 会调用它所计时的时间。 
   也可以使用 ``@time expr`` 宏来计算时间。

.. function:: toc()

   打印并返回最后一个 :func:`tic` 计时器的时间。

.. function:: toq()

   返回但不打印最后一个 :func:`tic` 计时器的时间。

.. function:: EnvHash() -> EnvHash

   给环境变量提供哈希表接口的单态。

.. data:: ENV

   对单态 ``EnvHash`` 的引用，提供系统环境变量的字典接口。

C 接口
------

.. function:: ccall( (symbol, library), RetType, (ArgType1, ...), ArgVar1, ...)

   调用从 C 导出的共享库的函数，它由 (函数名, 共享库名) 多元组 
   （字符串或 :Symbol ）指明。 ccall 也可用来调用由 dlsym 返回的函数指针， 
   但由于将来想实现静态编译，不提倡这种用法。

.. function:: cfunction(fun::Function, RetType::Type, (ArgTypes...))
   
   使用 Julia 函数生成 C 可调用的函数指针。

.. function:: dlopen(libfile::String [, flags::Integer])

   载入共享库，返回不透明句柄。

   可选参数为 0 或者是 RTLD_LOCAL, RTLD_GLOBAL, RTLD_LAZY, RTLD_NOW, 
   RTLD_NODELETE, RTLD_NOLOAD, RTLD_DEEPBIND, RTLD_FIRST 等参数的位或。 
   它们被转换为对应的 POSIX dlopen 命令的标志位； 
   如果当前平台不支持某个特性，则忽略。 
   默认值为 RTLD_LAZY|RTLD_DEEPBIND|RTLD_LOCAL 。 
   在 POSIX 平台上，这些标志位的重要用途是当共享库之间有依赖关系时， 
   指明 RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL 来使库的符号可被其它共享库使用。

.. function:: dlsym(handle, sym)

   在共享库句柄中查找符号。查找成功时返回可调用的函数指针。

.. function:: dlsym_e(handle, sym)
   
   在共享库句柄中查找符号。如果查找失败，则安静地返回空指针。

.. function:: dlclose(handle)

   通过句柄来关闭共享库的引用。

.. function:: c_free(addr::Ptr)
  
   调用 C 标准库中的 ·``free()`` 。

.. function:: unsafe_ref(p::Ptr{T},i::Integer)

   对指针解引用 ``p[i]`` 或 ``*p`` ，返回类型 T 的值的浅拷贝。

.. function:: unsafe_assign(p::Ptr{T},x,i::Integer)

   给指针赋值 ``p[i] = x`` 或 ``*p = x`` ，将对象 x 复制进 p 处的内存中。

.. function:: pointer(a[, index])

   获取数组元素的原生地址。要确保使用指针时，必须存在 Julia 对 ``a`` 的引用。

.. function:: pointer(type, Uint)

   指向指定元素类型的指针，地址为该无符号整数。

.. function:: pointer_to_array(p, dims[, own])

   将原生指针封装为 Julia 数组对象。指针元素的类型决定了数组元素的类型。 
   ``own`` 可选项指明 Julia 是否可以控制内存， 
   当数组不再被引用时调用 ``free`` 释放指针。

错误
----

.. function:: error(message::String)

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

   跳转到指定的任务。第一次跳转到某任务时，使用 ``args`` 参数来调用任务的函数。 
   在后续的跳转时， ``args`` 被任务的最后一个调用返回到 ``yieldto`` 。

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
