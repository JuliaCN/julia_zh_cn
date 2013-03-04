.. currentmodule:: Base

杂项
----

.. function:: exit([code])

   退出（或在会话中按下 control-D ）。默认退出代码为 0 ，表示进程正常结束。

.. function:: whos([Module,] [pattern::Regex])

   打印information about global variables in a module, optionally restricted
   to those matching ``pattern``.

.. function:: edit(file::String, [line])

   Edit a file optionally providing a line number to edit at. 返回to the julia prompt when you quit the editor. If the file name ends in ".jl" it is reloaded when the editor closes the file.

.. function:: edit(function, [types])

   Edit the definition of a function, optionally specifying a tuple of types to indicate which method to edit. When the editor exits, the source file containing the definition is reloaded.

.. function:: require(file::String...)

   对源文件内容求值。

.. function:: help(name)

   获得函数帮助。 ``name`` 可以是对象或字符串。

.. function:: apropos(string)

   查询文档中与 ``string`` 相关的函数。

.. function:: which(f, args...)

   Show which method of ``f`` will be called for the given arguments.

.. function:: methods(f)

   Show all methods of ``f`` with their argument types.

所有对象
--------

.. function:: is(x, y)

   Determine whether ``x`` and ``y`` are identical, 依据为程序不能区分它们。

.. function:: isa(x, type)

   Determine whether ``x`` is of the given type.

.. function:: isequal(x, y)

   True if and only if ``x`` and ``y`` have the same contents. Loosely speaking, this means ``x`` and ``y`` would look the same when printed.

.. function:: isless(x, y)

   Test whether ``x`` is less than ``y``. Provides a total order consistent with ``isequal``. Values that are normally unordered, such as ``NaN``, are ordered in an arbitrary but consistent fashion. This is the default comparison used by ``sort``. Non-numeric types that can be ordered should implement this function.

.. function:: typeof(x)

   返回 ``x`` 的具体类型。

.. function:: tuple(xs...)

   构造给定的对象的多元组。

.. function:: ntuple(n, f::Function)

   构造a tuple of length ``n``, computing each element as ``f(i)``, where ``i`` is the index of the element.

.. function:: object_id(x)

   Get a unique integer id for ``x``. ``object_id(x)==object_id(y)`` if and only if ``is(x,y)``.

.. function:: hash(x)

   计算an integer hash code such that ``isequal(x,y)`` implies ``hash(x)==hash(y)``.

.. function:: finalizer(x, function)

   Register a function ``f(x)`` to be called when there are no program-accessible references to ``x``. The behavior of this function is unpredictable if ``x`` is of a bits type.

.. function:: copy(x)

   构造a shallow copy of ``x``: the outer structure is copied, but not all internal values. For example, copying an array produces a new array with identically-same elements as the original.

.. function:: deepcopy(x)

   构造a deep copy of ``x``: everything is copied recursively, resulting in a fully independent object. For example, deep-copying an array produces a new array whose elements are deep-copies of the original elements.

   As a special case, functions can only be actually deep-copied if they are anonymous, otherwise they are just copied. The difference is only relevant in the case of closures, i.e. functions which may contain hidden internal references.

   While it isn't normally necessary, user-defined types can override the default ``deepcopy`` behavior by defining a specialized version of the function ``deepcopy_internal(x::T, dict::ObjectIdDict)`` (which shouldn't otherwise be used), where ``T`` is the type to be specialized for, and ``dict`` keeps track of objects copied so far within the recursion. Within the definition, ``deepcopy_internal`` should be used in place of ``deepcopy``, and the ``dict`` variable should be updated as appropriate before returning.

.. function:: convert(type, x)

   Try to convert ``x`` to the given type.

.. function:: promote(xs...)

   Convert all arguments to their common promotion type (if any), and return them all (as a tuple).

类型
----

.. function:: subtype(type1, type2)

   True if and only if all values of ``type1`` are also of ``type2``. Can also be written using the ``<:`` infix operator as ``type1 <: type2``.

.. function:: typemin(type)

   The lowest value representable by the given (real) numeric type.

.. function:: typemax(type)

   The highest value representable by the given (real) numeric type.

.. function:: realmin(type)

   The smallest in absolute value non-denormal value representable by the given floating-point type

.. function:: realmax(type)

   The highest finite value representable by the given floating-point type

.. function:: maxintfloat(type)

   The largest integer losslessly representable by the given floating-point type

.. function:: sizeof(type)

   Size, in bytes, of the canonical binary representation of the given type, if any.

.. function:: eps([type])

   The distance between 1.0 and the next larger representable floating-point value of ``type``. The only types that are sensible arguments are ``Float32`` and ``Float64``. If ``type`` is omitted, then ``eps(Float64)`` is returned.

.. function:: eps(x)

   The distance between ``x`` and the next larger representable floating-point value of the same type as ``x``.

.. function:: promote_type(type1, type2)

   Determine a type big enough to hold values of each argument type without loss, whenever possible. In some cases, where no type exists which to which both types can be promoted losslessly, some loss is tolerated; for example, ``promote_type(Int64,Float64)`` returns ``Float64`` even though strictly, not all ``Int64`` values can be represented exactly as ``Float64`` values.

通用函数
--------

.. function:: method_exists(f, tuple) -> Bool

   Determine whether the given generic function has a method matching the given tuple of argument types.

   **例子** ： ``method_exists(length, (Array,)) = true``

.. function:: applicable(f, args...)

   Determine whether the given generic function has a method applicable to the given arguments.

.. function:: invoke(f, (types...), args...)

   Invoke a method for the given generic function matching the specified types (as a tuple), on the specified arguments. The arguments must be compatible with the specified types. This allows invoking a method other than the most specific matching method, which is useful when the behavior of a more general definition is explicitly needed (often as part of the implementation of a more specific method of the same function).

.. function:: |
   
   Applies a function to the preceding argument which allows for easy function chaining.

   **例子** ： ``[1:5] | x->x.^2 | sum | inv``

迭代
----

序贯迭代是通过 ``start``, ``done``, 及 ``next`` 方法实现的。通用 ``for`` 循环： ::

    for i = I
      # body
    end

可以重写为： ::

    state = start(I)
    while !done(I, state)
      (i, state) = next(I, state)
      # body
    end

``state`` 对象可为任何东西，每个迭代类型都应选取与其相适应的。

.. function:: start(iter) -> state

   Get initial iteration state for an iterable object

.. function:: done(iter, state) -> Bool

   Test whether we are done iterating

.. function:: next(iter, state) -> item, state

   For a given iterable object and iteration state, return the current item and the next iteration state

.. function:: zip(iters...)

   For a set of iterable objects, returns an iterable of tuples, where the ``i``th tuple contains the ``i``th component of each input iterable.

   Note that ``zip`` is it's own inverse: [zip(zip(a...)...)...] == [a...]


Fully implemented by: ``Range``, ``Range1``, ``NDRange``, ``Tuple``, ``Real``, ``AbstractArray``, ``IntSet``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``EachLine``, ``String``, ``Set``, ``Task``.

通用集合
--------

.. function:: isempty(collection) -> Bool

   Determine whether a collection is empty (has no elements).

.. function:: empty!(collection) -> collection

   移除all elements from a collection.

.. function:: length(collection) -> Integer

   For ordered, indexable collections, the maximum index ``i`` for which ``ref(collection, i)`` is valid. For unordered collections, the number of elements.

.. function:: endof(collection) -> Integer

   返回the last index of the collection.
   
   **例子** ： ``endof([1,2,4]) = 3``

Fully implemented by: ``Range``, ``Range1``, ``Tuple``, ``Number``, ``AbstractArray``, ``IntSet``, ``Dict``, ``WeakKeyDict``, ``String``, ``Set``.

可迭代集合
----------

.. function:: contains(itr, x) -> Bool

   Determine whether a collection contains the given value, ``x``.

.. function:: findin(a, b)

   返回the indices of elements in collection ``a`` that appear in collection ``b``

.. function:: unique(itr)

   返回an array containing only the unique elements of the iterable ``itr``.

.. function:: reduce(op, v0, itr)

   Reduce the given collection with the given operator, i.e. accumulate ``v = op(v,elt)`` for each element, where ``v`` starts as ``v0``. Reductions for certain commonly-used operators are available in a more convenient 1-argument form: ``max(itr)``, ``min(itr)``, ``sum(itr)``, ``prod(itr)``, ``any(itr)``, ``all(itr)``.

.. function:: max(itr)

   返回the largest element in a collection

.. function:: min(itr)

   返回the smallest element in a collection

.. function:: indmax(itr) -> Integer

   返回the index of the maximum element in a collection

.. function:: indmin(itr) -> Integer

   返回the index of the minimum element in a collection

.. function:: findmax(itr) -> (x, index)

   返回the maximum element and its index

.. function:: findmin(itr) -> (x, index)

   返回the minimum element and its index

.. function:: sum(itr)

   返回the sum of all elements in a collection

.. function:: prod(itr)

   返回the product of all elements of a collection

.. function:: any(itr) -> Bool

   Test whether any elements of a boolean collection are true

.. function:: all(itr) -> Bool

   Test whether all elements of a boolean collection are true

.. function:: count(itr) -> Integer

   Count the number of boolean elements in ``itr`` which are true.

.. function:: countp(p, itr) -> Integer

   Count the number of elements in ``itr`` for which predicate ``p`` is true.

.. function:: any(p, itr) -> Bool

   Determine whether any element of ``itr`` satisfies the given predicate.

.. function:: all(p, itr) -> Bool

   Determine whether all elements of ``itr`` satisfy the given predicate.

.. function:: map(f, c) -> collection

   Transform collection ``c`` by applying ``f`` to each element.

   **例子** ： ``map((x) -> x * 2, [1, 2, 3]) = [2, 4, 6]``

.. function:: map!(function, collection)

   :func:`map` 的原地版本。

.. function:: mapreduce(f, op, itr)

   Applies function ``f`` to each element in ``itr`` and then reduces the result using the binary function ``op``.

   **例子** ： ``mapreduce(x->x^2, +, [1:3]) == 1 + 4 + 9 == 14``

可索引集合
----------

.. function:: ref(collection, key...)
              collection[key...]

   Retrieve the value(s) stored at the given key or index within a collection.

.. function:: assign(collection, value, key...)
              collection[key...] = value

   Store the given value at the given key or index within a collection.

Fully implemented by: ``Array``, ``DArray``, ``AbstractArray``, ``SubArray``, ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``, ``String``.

Partially implemented by: ``Range``, ``Range1``, ``Tuple``.

关联性集合
----------

``Dict`` is the standard associative collection. Its implementation uses the ``hash(x)`` as the hashing function for the key, and ``isequal(x,y)`` to determine equality. Define these two functions for custom types to override how they are stored in a hash table.

``ObjectIdDict`` is a special hash table where the keys are always object identities. ``WeakKeyDict`` is a hash table implementation where the keys are weak references to objects, and thus may be garbage collected even when referenced in a hash table.

Dicts can be created using a literal syntax: ``{"A"=>1, "B"=>2}``. Use of curly brackets will create a ``Dict`` of type ``Dict{Any,Any}``. Use of square brackets will attempt to infer type information from the keys and values (i.e. ``["A"=>1, "B"=>2]`` creates a ``Dict{ASCIIString, Int64}``). To explicitly specify types use the syntax: ``(KeyType=>ValueType)[...]``. For example, ``(ASCIIString=>Int32)["A"=>1, "B"=>2]``.

As with arrays, ``Dicts`` may be created with comprehensions. For example,
``{i => f(i) for i = 1:10}``.

.. function:: Dict{K,V}()

   构造a hashtable with keys of type K and values of type V

.. function:: has(collection, key)

   Determine whether a collection has a mapping for a given key.

.. function:: get(collection, key, default)

   返回the value stored for the given key, or the given default value if no mapping for the key is present.

.. function:: getkey(collection, key, default)

   返回the key matching argument ``key`` if one exists in ``collection``, otherwise return ``default``.

.. function:: delete!(collection, key)

   删除the mapping for the given key in a collection.

.. function:: empty!(collection)

   删除all keys from a collection.

.. function:: keys(collection)

   返回an array of all keys in a collection.

.. function:: values(collection)

   返回an array of all values in a collection.

.. function:: collect(collection)

   返回an array of all items in a collection. For associative collections, returns (key, value) tuples.

.. function:: merge(collection, others...)

   构造a merged collection from the given collections.

.. function:: merge!(collection, others...)

   Update collection with pairs from the other collections

.. function:: filter(function, collection)

   返回a copy of collection, removing (key, value) pairs for which function is false.

.. function:: filter!(function, collection)

   Update collection, removing (key, value) pairs for which function is false.

.. function:: eltype(collection)

   返回the type tuple of the (key,value) pairs contained in collection.

.. function:: sizehint(s, n)

   Suggest that collection ``s`` reserve capacity for at least ``n`` elements. This can improve performance.
   
Fully implemented by: ``ObjectIdDict``, ``Dict``, ``WeakKeyDict``.

Partially implemented by: ``IntSet``, ``Set``, ``EnvHash``, ``Array``.

类集集合
--------

.. function:: add!(collection, key)

   Add an element to a set-like collection.

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

Fully implemented by: ``IntSet``, ``Set``.

Partially implemented by: ``Array``.

双端队列
--------

.. function:: push!(collection, item) -> collection

   Insert an item at the end of a collection.

.. function:: pop!(collection) -> item

   移除the last item in a collection and return it.

.. function:: unshift!(collection, item) -> collection

   Insert an item at the beginning of a collection.

.. function:: shift!(collection) -> item

   移除the first item in a collection.

.. function:: insert!(collection, index, item)

   Insert an item at the given index.

.. function:: delete!(collection, index) -> item

   移除the item at the given index, and return the deleted item.

.. function:: delete!(collection, range) -> items
   
   移除items at specified range, and return a collection containing the deleted items.

.. function:: resize!(collection, n) -> collection

   Resize collection to contain ``n`` elements.

.. function:: append!(collection, items) -> collection

   Add the elements of ``items`` to the end of a collection.

Fully implemented by: ``Vector`` (aka 1-d ``Array``).

字符串
------

.. function:: length(s)

   The number of characters in string ``s``.

.. function:: collect(string)

   返回an array of the characters in ``string``.

.. function:: *
              string(strs...)

   Concatenate strings.

   **例子** ： ``"Hello " * "world" == "Hello world"``

.. function:: ^

   Repeat a string.

   **例子** ： ``"Julia "^3 == "Julia Julia Julia "``

.. function:: string(char...)

   构造a string with the given characters.

.. function:: string(x)

   构造a string from any value using the ``print`` function.

.. function:: repr(x)

   构造a string from any value using the ``show`` function.

.. function:: bytestring(::Ptr{Uint8})

   构造a string from the address of a C (0-terminated) string.

.. function:: bytestring(s)

   Convert a string to a contiguous byte array representation appropriate for passing it to C functions.

.. function:: ascii(::Array{Uint8,1})

   构造an ASCII string from a byte array.

.. function:: ascii(s)

   Convert a string to a contiguous ASCII string (all characters must be valid ASCII characters).

.. function:: utf8(::Array{Uint8,1})

   构造a UTF-8 string from a byte array.

.. function:: utf8(s)

   Convert a string to a contiguous UTF-8 string (all characters must be valid UTF-8 characters).

.. function:: is_valid_ascii(s) -> Bool

   返回true if the string is valid ASCII, false otherwise.

.. function:: is_valid_utf8(s) -> Bool

   返回true if the string is valid UTF-8, false otherwise.

.. function:: check_ascii(s)

   调用 :func:`is_valid_ascii` on string. Throws error if it is not valid.

.. function:: check_utf8(s)

   调用 :func:`is_valid_utf8` on string. Throws error if it is not valid.

.. function:: byte_string_classify(s)

   返回 0 if the string is neither valid ASCII nor UTF-8, 1 if it is valid ASCII, and 2 if it is valid UTF-8.

.. function:: search(string, char, [i])

   返回the index of ``char`` in ``string``, giving 0 if not found. The second argument may also be a vector or a set of characters. The third argument optionally specifies a starting index.

.. function:: lpad(string, n, p)

   Make a string at least ``n`` characters long by padding on the left with copies of ``p``.

.. function:: rpad(string, n, p)

   Make a string at least ``n`` characters long by padding on the right with copies of ``p``.

.. function:: search(string, chars, [start])

   查找the given characters within the given string. The second argument may be a single character, a vector or a set of characters, a string, or a regular expression (but regular expressions are only allowed on contiguous strings, such as ASCII or UTF-8 strings). The third argument optionally specifies a starting index. The return value is a range of indexes where the matching sequence is found, such that ``s[search(s,x)] == x``. The return value is ``0:-1`` if there is no match.

.. function:: replace(string, pat, r[, n])

   查找the given pattern ``pat``, and replace each occurance with ``r``. If ``n`` is provided, replace at most ``n`` occurances.  As with search, the second argument may be a single character, a vector or a set of characters, a string, or a regular expression.

.. function:: replace(string, pat, f[, n])

   查找the given pattern ``pat``, and replace each occurance with ``f(pat)``. If ``n`` is provided, replace at most ``n`` occurances.  As with search, the second argument may be a single character, a vector or a set of characters, a string, or a regular expression.

.. function:: split(string, [chars, [limit,] [include_empty]])

   返回an array of strings by splitting the given string on occurrences of the given character delimiters, which may be specified in any of the formats allowed by ``search``'s second argument (i.e. a single character, collection of characters, string, or regular expression). If ``chars`` is omitted, it defaults to the set of all space characters, and ``include_empty`` is taken to be false. The last two arguments are also optional: they are are a maximum size for the result and a flag determining whether empty fields should be included in the result.

.. function:: strip(string, [chars])

   返回 ``string`` with any leading and trailing whitespace removed. If a string ``chars`` is provided, instead remove characters contained in that string.

.. function:: lstrip(string, [chars])

   返回 ``string`` with any leading whitespace removed. If a string ``chars`` is provided, instead remove characters contained in that string.

.. function:: rstrip(string, [chars])

   返回 ``string`` with any trailing whitespace removed. If a string ``chars`` is provided, instead remove characters contained in that string.

.. function:: begins_with(string, prefix)

   返回 ``true`` if ``string`` starts with ``prefix``.

.. function:: ends_with(string, suffix)

   返回 ``true`` if ``string`` ends with ``suffix``.

.. function:: uppercase(string)

   返回 ``string`` with all characters converted to uppercase.

.. function:: lowercase(string)

   返回 ``string`` with all characters converted to lowercase.

.. function:: join(strings, delim)

   Join an array of strings into a single string, inserting the given delimiter between adjacent strings.

.. function:: chop(string)

   移除the last character from a string

.. function:: chomp(string)

   移除a trailing newline from a string

.. function:: ind2chr(string, i)

   Convert a byte index to a character index

.. function:: chr2ind(string, i)

   Convert a character index to a byte index

.. function:: isvalid(str, i)

   Tells whether index ``i`` is valid for the given string

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

I/O
---

.. data:: STDOUT

   指向标准输出流的全局变量

.. data:: STDERR

   指向标准错误流的全局变量

.. data:: STDIN

   指向标准输入流的全局变量

.. function:: open(file_name, [read, write, create, truncate, append]) -> IOStream

   Open a file in a mode specified by five boolean arguments. The default is to open files for reading only. 返回a stream for accessing the file.

.. function:: open(file_name, [mode]) -> IOStream

   Alternate syntax for open, where a string-based mode specifier is used instead of the five booleans. The values of ``mode`` correspond to those from ``fopen(3)`` or Perl ``open``, and are equivalent to setting the following boolean groups:

   ==== =================================
    r    read
    r+   read, write
    w    write, create, truncate
    w+   read, write, create, truncate
    a    write, create, append
    a+   read, write, create, append
   ==== =================================


.. function:: open(file_name) -> IOStream

   Open a file in read mode.

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

   Tests whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return ``false``. Therefore it is always safe to read one byte after seeing ``eof`` return ``false``.

文本 I/O
--------

.. function:: show(x)

   Write an informative text representation of a value to the current output stream. New types should overload ``show(io, x)`` where the first argument is a stream.

.. function:: print(x)

   Write (to the default output stream) a canonical (un-decorated) text representation of a value if there is one, otherwise call ``show``.

.. function:: println(x)

   打印(using :func:`print`) ``x`` followed by a newline

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

   构造an array whose values are linked to a file, using memory-mapping. This provides a convenient way of working with data too large to fit in the computer's memory.

   The type determines how the bytes of the array are interpreted (no format conversions are possible), and dims is a tuple containing the size of the array.  

   The file is specified via the stream.  When you initialize the stream, use "r" for a "read-only" array, and "w+" to create a new array used to write values to disk. Optionally, you can specify an offset (in bytes) if, for example, you want to skip over a header in the file.

   **例子** ：  A = mmap_array(Int64, (25,30000), s)

   This would create a 25-by-30000 array of Int64s, linked to the file associated with stream s.

.. function:: msync(array)

   Forces synchronization between the in-memory version of a memory-mapped array and the on-disk version. You may not need to call this function, because synchronization is performed at intervals automatically by the operating system. Hower, you can call this directly if, for example, you are concerned about losing the result of a long-running calculation.

.. function:: mmap(len, prot, flags, fd, offset)

   Low-level interface to the mmap system call. See the man page.

.. function:: munmap(pointer, len)

   Low-level interface for unmapping memory (see the man page). With mmap_array you do not need to call this directly; the memory is unmapped for you when the array goes out of scope.

标准数值类型
------------

``Bool`` ``Int8`` ``Uint8`` ``Int16`` ``Uint16`` ``Int32`` ``Uint32`` ``Int64`` ``Uint64`` ``Float32`` ``Float64`` ``Complex64`` ``Complex128``

数学函数
--------

.. function:: -

   一元减

.. function:: + - * / \\ ^

   二元加、减、乘、左除、右除、指数运算符

.. function:: .* ./ .\\ .^

   The element-wise binary addition, subtraction, multiplication, left division, right division, and exponentiation operators

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

   Rational division

.. function:: num(x)

   Numerator of the rational representation of ``x``

.. function:: den(x)

   Denominator of the rational representation of ``x``

.. function:: << >>

   左移、右移运算符

.. function:: == != < <= > >=

   Comparison operators to test equals, not equals, less than, less than or equals, greater than, and greater than or equals

.. function:: cmp(x,y)

   返回-1, 0, or 1 depending on whether ``x<y``, ``x==y``, or ``x>y``, respectively

.. function:: !

   逻辑非

.. function:: ~

   Boolean or bitwise not

.. function:: &

   逻辑与

.. function:: |

   逻辑或

.. function:: $

   Bitwise exclusive or

.. function:: sin(x)

   计算sine of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: cos(x)

   计算cosine of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: tan(x)

   计算tangent of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: sind(x)

   计算sine of ``x`` ，其中 ``x`` 的单位为度数

.. function:: cosd(x)

   计算cosine of ``x`` ，其中 ``x`` 的单位为度数

.. function:: tand(x)

   计算tangent of ``x`` ，其中 ``x`` 的单位为度数

.. function:: sinh(x)

   计算hyperbolic sine of ``x``

.. function:: cosh(x)

   计算hyperbolic cosine of ``x``

.. function:: tanh(x)

   计算hyperbolic tangent of ``x``

.. function:: asin(x)

   计算the inverse sine of ``x`` ，结果的单位为弧度

.. function:: acos(x)

   计算the inverse cosine of ``x`` ，结果的单位为弧度

.. function:: atan(x)

   计算the inverse tangent of ``x`` ，结果的单位为弧度

.. function:: atan2(y, x)

   计算the inverse tangent of ``y/x``, using the signs of both ``x`` and ``y`` to determine the quadrant of the return value.

.. function:: asind(x)

   计算the inverse sine of ``x`` ，结果的单位为度数

.. function:: acosd(x)

   计算the inverse cosine of ``x`` ，结果的单位为度数

.. function:: atand(x)

   计算the inverse tangent of ``x`` ，结果的单位为度数

.. function:: sec(x)

   计算the secant of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: csc(x)

   计算the cosecant of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: cot(x)

   计算the cotangent of ``x`` ，其中 ``x`` 的单位为弧度

.. function:: secd(x)

   计算the secant of ``x`` ，其中 ``x`` 的单位为度数

.. function:: cscd(x)

   计算the cosecant of ``x`` ，其中 ``x`` 的单位为度数

.. function:: cotd(x)

   计算the cotangent of ``x`` ，其中 ``x`` 的单位为度数

.. function:: asec(x)

   计算the inverse secant of ``x`` ，结果的单位为弧度

.. function:: acsc(x)

   计算the inverse cosecant of ``x`` ，结果的单位为弧度

.. function:: acot(x)

   计算the inverse cotangent of ``x`` ，结果的单位为弧度

.. function:: asecd(x)

   计算the inverse secant of ``x`` ，结果的单位为度数

.. function:: acscd(x)

   计算the inverse cosecant of ``x`` ，结果的单位为度数

.. function:: acotd(x)

   计算the inverse cotangent of ``x`` ，结果的单位为度数

.. function:: sech(x)

   计算the hyperbolic secant of ``x``

.. function:: csch(x)

   计算the hyperbolic cosecant of ``x``

.. function:: coth(x)

   计算the hyperbolic cotangent of ``x``

.. function:: asinh(x)

   计算the inverse hyperbolic sine of ``x``

.. function:: acosh(x)

   计算the inverse hyperbolic cosine of ``x``

.. function:: atanh(x)

   计算the inverse hyperbolic cotangent of ``x``

.. function:: asech(x)

   计算the inverse hyperbolic secant of ``x``

.. function:: acsch(x)

   计算the inverse hyperbolic cosecant of ``x``

.. function:: acoth(x)

   计算the inverse hyperbolic cotangent of ``x``

.. function:: sinc(x)

   计算:math:`sin(\pi x) / x`

.. function:: cosc(x)

   计算:math:`cos(\pi x) / x`

.. function:: degrees2radians(x)

   Convert ``x`` from degrees to radians

.. function:: radians2degrees(x)

   Convert ``x`` from radians to degrees

.. function:: hypot(x, y)

   计算the :math:`\sqrt{(x^2+y^2)}` without undue overflow or underflow

.. function:: log(x)
   
   计算the natural logarithm of ``x``

.. function:: log2(x)

   计算the natural logarithm of ``x`` to base 2

.. function:: log10(x)

   计算the natural logarithm of ``x`` to base 10

.. function:: log1p(x)

   Accurate natural logarithm of ``1+x``

.. function:: logb(x)

   返回the exponent of x, represented as a floating-point number

.. function:: ilogb(x) 

   返回the exponent of x, represented as a signed integer value

.. function:: frexp(val, exp)

   返回a number ``x`` such that it has a magnitude in the interval ``[1/2, 1)`` or 0,
   and val = :math:`x \times 2^{exp}`.

.. function:: exp(x)

   计算:math:`e^x`

.. function:: exp2(x)

   计算:math:`2^x`

.. function:: ldexp(x, n)

   计算:math:`x \times 2^n`

.. function:: modf(x)

   返回a tuple (fpart,ipart) of the fractional and integral parts of a
   number. 两部分都与参数同正负号。

.. function:: expm1(x)

   Accurately compute :math:`e^x-1`

.. function:: square(x)

   计算:math:`x^2`

.. function:: round(x, [digits, [base]]) -> FloatingPoint

   ``round(x)`` returns the nearest integer to ``x``. ``round(x, digits)`` rounds to the specified number of digits after the decimal place, or before if negative, e.g., ``round(pi,2)`` is ``3.14``. ``round(x, digits, base)`` rounds using a different base, defaulting to 10, e.g., ``round(pi, 3, 2)`` is ``3.125``.

.. function:: ceil(x, [digits, [base]]) -> FloatingPoint

   返回the nearest integer not less than ``x``. ``digits`` and ``base`` work as above.

.. function:: floor(x, [digits, [base]]) -> FloatingPoint

   返回the nearest integer not greater than ``x``. ``digits`` and ``base`` work as above.

.. function:: trunc(x, [digits, [base]]) -> FloatingPoint

   返回the nearest integer not greater in magnitude than ``x``. ``digits`` and ``base`` work as above.

.. function:: iround(x) -> Integer

   返回the nearest integer to ``x``.

.. function:: iceil(x) -> Integer

   返回the nearest integer not less than ``x``.

.. function:: ifloor(x) -> Integer

   返回the nearest integer not greater than ``x``.

.. function:: itrunc(x) -> Integer

   返回the nearest integer not greater in magnitude than ``x``.

.. function:: signif(x, digits, [base]) -> FloatingPoint

   Rounds (in the sense of ``round``) ``x`` so that there are ``digits`` significant digits, under a base ``base`` representation, default 10. E.g., ``signif(123.456, 2)`` is ``120.0``, and ``signif(357.913, 4, 2)`` is ``352.0``. 

.. function:: min(x, y)

   返回the minimum of ``x`` and ``y``

.. function:: max(x, y)

   返回the maximum of ``x`` and ``y``

.. function:: clamp(x, lo, hi)

   返回 x if ``lo <= x <= y``. If ``x < lo``, return ``lo``. If ``x > hi``, return ``hi``.

.. function:: abs(x)

   Absolute value of ``x``

.. function:: abs2(x)

   Squared absolute value of ``x``

.. function:: copysign(x, y)

   返回 ``x`` such that it has the same sign as ``y``

.. function:: sign(x)

   返回 ``+1`` if ``x`` is positive, ``0`` if ``x == 0``, and ``-1`` if ``x`` is negative.

.. function:: signbit(x)

   返回 ``1`` if the value of the sign of ``x`` is negative, otherwise ``0``.

.. function:: flipsign(x, y)

   返回 ``x`` with its sign flipped if ``y`` is negative. For example ``abs(x) = flipsign(x,x)``.

.. function:: sqrt(x)
   
   返回 :math:`\sqrt{x}`

.. function:: cbrt(x)

   返回 :math:`x^{1/3}`

.. function:: erf(x)

   计算the error function of ``x``, defined by
   :math:`\frac{2}{\sqrt{\pi}} \int_0^x e^{-t^2} dt`
   for arbitrary complex ``x``.

.. function:: erfc(x)

   计算the complementary error function of ``x``,
   defined by :math:`1 - \operatorname{erf}(x)`.

.. function:: erfcx(x)

   计算the scaled complementary error function of ``x``,
   defined by :math:`e^{x^2} \operatorname{erfc}(x)`.  Note
   also that :math:`\operatorname{erfcx}(-ix)` computes the
   Faddeeva function :math:`w(x)`.

.. function:: erfi(x)

   计算the imaginary error function of ``x``,
   defined by :math:`-i \operatorname{erf}(ix)`.

.. function:: dawson(x)

   计算the Dawson function (scaled imaginary error function) of ``x``,
   defined by :math:`\frac{\sqrt{\pi}}{2} e^{-x^2} \operatorname{erfi}(x)`.

.. function:: real(z)

   返回the real part of the complex number ``z``

.. function:: imag(z)

   返回the imaginary part of the complex number ``z``

.. function:: reim(z)

   返回both the real and imaginary parts of the complex number ``z``

.. function:: conj(z)

   计算the complex conjugate of a complex number ``z``

.. function:: angle(z)

   计算the phase angle of a complex number ``z``   

.. function:: cis(z)

   返回 ``cos(z) + i*sin(z)`` if z is real. 返回``(cos(real(z)) + i*sin(real(z)))/exp(imag(z))`` if ``z`` is complex

.. function:: binomial(n,k)

   Number of ways to choose ``k`` out of ``n`` items

.. function:: factorial(n)

   Factorial of n

.. function:: factorial(n,k)

   计算 ``factorial(n)/factorial(k)``

.. function:: factor(n)

   计算the prime factorization of an integer ``n``. 返回a dictionary. The keys of the dictionary correspond to the factors, and hence are of the same type as ``n``. The value associated with each key indicates the number of times the factor appears in the factorization.

   **例子** ： :math:`100=2*2*5*5`; then, ``factor(100) -> [5=>2,2=>2]``

.. function:: gcd(x,y)

   Greatest common divisor

.. function:: lcm(x,y)

   Least common multiple

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

   计算 ``mod(x^p, m)``

.. function:: gamma(x)

   计算the gamma function of ``x``

.. function:: lgamma(x)

   计算the logarithm of ``gamma(x)``

.. function:: lfact(x)

   计算the logarithmic factorial of ``x``

.. function:: digamma(x)

   计算the digamma function of ``x`` (the logarithmic derivative of ``gamma(x)``)

.. function:: airy(x)
              airyai(x)

   Airy function :math:`\operatorname{Ai}(x)`.

.. function:: airyprime(x)
              airyaiprime(x)

   Airy function derivative :math:`\operatorname{Ai}'(x)`.

.. function:: airybi(x)

   Airy function :math:`\operatorname{Bi}(x)`.

.. function:: airybiprime(x)

   Airy function derivative :math:`\operatorname{Bi}'(x)`.

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

   Dirichlet eta 函数 :math:`\eta(s) = \sum^\infty_{n=1}(-)^{n-1}/n^{s}`.

.. function:: zeta(x)

   Riemann zeta 函数 :math:`\zeta(s)`.

.. function:: bitmix(x, y)

   Hash two integers into a single integer. Useful for constructing hash
   functions.

.. function:: ndigits(n, b)

   计算the number of digits in number ``n`` written in base ``b``.

数据格式
--------

.. function:: bin(n, [pad])

   Convert an integer to a binary string, optionally specifying a number of digits to pad to.

.. function:: hex(n, [pad])

   Convert an integer to a hexadecimal string, optionally specifying a number of digits to pad to.

.. function:: dec(n, [pad])

   Convert an integer to a decimal string, optionally specifying a number of digits to pad to.

.. function:: oct(n, [pad])

   Convert an integer to an octal string, optionally specifying a number of digits to pad to.

.. function:: base(b, n, [pad])

   Convert an integer to a string in the given base, optionally specifying a number of digits to pad to.

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

   Convert a number or numeric array to boolean

.. function:: isbool(x)

   Test whether number or array is boolean

.. function:: int(x)

   Convert a number or array to the default integer type on your platform. Alternatively, ``x`` can be a string, which is parsed as an integer.

.. function:: uint(x)

   Convert a number or array to the default unsigned integer type on your platform. Alternatively, ``x`` can be a string, which is parsed as an unsigned integer.

.. function:: integer(x)

   Convert a number or array to integer type. If ``x`` is already of integer type it is unchanged, otherwise it converts it to the default integer type on your platform.

.. function:: isinteger(x)

   Test whether a number or array is of integer type

.. function:: signed(x)

   Convert a number to a signed integer

.. function:: unsigned(x)

   Convert a number to an unsigned integer

.. function:: int8(x)

   Convert a number or array to ``Int8`` 数据类型

.. function:: int16(x)

   Convert a number or array to ``Int16`` 数据类型

.. function:: int32(x)

   Convert a number or array to ``Int32`` 数据类型

.. function:: int64(x)

   Convert a number or array to ``Int64`` 数据类型

.. function:: int128(x)

   Convert a number or array to ``Int128`` 数据类型

.. function:: uint8(x)

   Convert a number or array to ``Uint8`` 数据类型

.. function:: uint16(x)

   Convert a number or array to ``Uint16`` 数据类型

.. function:: uint32(x)

   Convert a number or array to ``Uint32`` 数据类型

.. function:: uint64(x)

   Convert a number or array to ``Uint64`` 数据类型

.. function:: uint128(x)

   Convert a number or array to ``Uint128`` 数据类型

.. function:: float32(x)

   Convert a number or array to ``Float32`` 数据类型

.. function:: float64(x)

   Convert a number or array to ``Float64`` 数据类型

.. function:: float(x)

   Convert a number, array, or string to a ``FloatingPoint`` 数据类型. For numeric data, the smallest suitable ``FloatingPoint`` type is used. For strings, it converts to ``Float64``.

.. function:: significand(x)

   Extract the significand(s) (a.k.a. mantissa), in binary representation, of a floating-point number or array.
   
   For example, ``significand(15.2)/15.2 == 0.125``, and ``significand(15.2)*8 == 15.2``

.. function:: float64_valued(x::Rational)

   True if ``x`` can be losslessly represented as a ``Float64`` 数据类型

.. function:: complex64(r,i)

   Convert to ``r+i*im`` represented as a ``Complex64`` 数据类型

.. function:: complex128(r,i)

   Convert to ``r+i*im`` represented as a ``Complex128`` 数据类型

.. function:: char(x)

   Convert a number or array to ``Char`` 数据类型

.. function:: safe_char(x)

   Convert to ``Char``, checking for invalid code points

.. function:: complex(r,i)

   Convert real numbers or arrays to complex

.. function:: iscomplex(x) -> Bool

   Test whether a number or array is of a complex type

.. function:: isreal(x) -> Bool

   Test whether a number or array is of a real type

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

   The constant pi

.. function:: isdenormal(f) -> Bool

   Test whether a floating point number is denormal

.. function:: isfinite(f) -> Bool

   Test whether a number is finite

.. function:: isinf(f)

   Test whether a number is infinite

.. function:: isnan(f)

   Test whether a floating point number is not a number (NaN)

.. function:: inf(f)

   返回infinity in the same floating point type as ``f`` (or ``f`` can by the type itself)

.. function:: nan(f)

   返回 NaN in the same floating point type as ``f`` (or ``f`` can by the type itself)

.. function:: nextfloat(f)

   Get the next floating point number in lexicographic order

.. function:: prevfloat(f) -> Float

   Get the previous floating point number in lexicographic order

.. function:: integer_valued(x)

   Test whether ``x`` is numerically equal to some integer

.. function:: real_valued(x)

   Test whether ``x`` is numerically equal to some real number

.. function:: exponent(f)

   Get the exponent of a floating-point number

.. function:: mantissa(f)

   Get the mantissa of a floating-point number

.. function:: BigInt(x)

   构造an arbitrary precision integer. ``x`` may be an ``Int`` (or anything that can be converted to an ``Int``) or a ``String``. 
   The usual mathematical operators are defined for this type, and results are promoted to a ``BigInt``. 

.. function:: BigFloat(x)

   构造an arbitrary precision floating point number. ``x`` may be an ``Integer``, a ``Float64``, a ``String`` or a ``BigInt``. The 
   usual mathematical operators are defined for this type, and results are promoted to a ``BigFloat``.

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

Julia 中的随机数生成使用 `Mersenne Twister 库 <http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/#dSFMT>`_ 。Julia 默认使用全局 RNG 。Multiple RNGs can be plugged in using the ``AbstractRNG`` object, which can then be used to have multiple streams of random numbers.目前只支持 ``MersenneTwister`` 。

.. function:: srand([rng], seed)

   Seed the RNG with a ``seed``, which may be an unsigned integer or a vector of unsigned integers. ``seed`` can even be a filename, in which case the seed is read from a file. If the argument ``rng`` is not provided, the default global RNG is seeded.

.. function:: MersenneTwister([seed])

   构造a ``MersenneTwister`` RNG object. Different RNG objects can have their own seeds, which may be useful for generating different streams of random numbers.

.. function:: rand()

   Generate a ``Float64`` random number in (0,1)

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

   返回the number of dimensions of A

.. function:: size(A)

   返回a tuple containing the dimensions of A

.. function:: eltype(A)

   返回the type of the elements contained in A

.. function:: length(A) -> Integer

   返回the number of elements in A (note that this differs from MATLAB where ``length(A)`` is the largest dimension of ``A``)

.. function:: nnz(A)

   Counts the number of nonzero values in A

.. function:: scale!(A, k)

   Scale the contents of an array A with k (in-place)

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

   构造an array of all zeros of specified type

.. function:: ones(type, dims)

   构造an array of all ones of specified type

.. function:: trues(dims)

   构造a Bool array with all values set to true

.. function:: falses(dims)

   构造a Bool array with all values set to false

.. function:: fill(v, dims)

   构造an array filled with ``v``

.. function:: fill!(A, x)

   Fill array ``A`` with value ``x``

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

   n-by-n identity matrix

.. function:: eye(m, n)

   m-by-n identity matrix

.. function:: linspace(start, stop, n)

   构造a vector of ``n`` linearly-spaced elements from ``start`` to ``stop``.

.. function:: logspace(start, stop, n)

   构造a vector of ``n`` logarithmically-spaced numbers from ``10^start`` to ``10^stop``.

数学运算符和函数
~~~~~~~~~~~~~~~~

All mathematical operations and functions are supported for arrays

.. function:: bsxfun(fn, A, B[, C...])

   Apply binary function ``fn`` to two or more arrays, with singleton dimensions expanded.

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

   Concatenate along dimension 1

.. function:: hcat(A...)

   Concatenate along dimension 2

.. function:: hvcat

   Horizontal and vertical concatenation in one call

.. function:: flipdim(A, d)

   Reverse ``A`` in dimension ``d``.

.. function:: flipud(A)

   Equivalent to ``flipdim(A,1)``.

.. function:: fliplr(A)

   Equivalent to ``flipdim(A,2)``.

.. function:: circshift(A,shifts)

   Circularly shift the data in an array. The second argument is a vector giving the amount to shift in each dimension.

.. function:: find(A)

   返回a vector of the linear indexes of the non-zeros in ``A``.

.. function:: findn(A)

   返回a vector of indexes for each dimension giving the locations of the non-zeros in ``A``.

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

   Convert a dense matrix ``A`` into a sparse matrix.

.. function:: sparsevec(A)

   Convert a dense vector ``A`` into a sparse matrix of size ``m x 1``. In julia, sparse vectors are really just sparse matrices with one column.

.. function:: dense(S)

   Convert a sparse matrix ``S`` into a dense matrix.   

.. function:: full(S)

   Convert a sparse matrix ``S`` into a dense matrix.   

.. function:: spzeros(m,n)

   构造an empty sparse matrix of size ``m x n``.

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

   Matrix multiplication

.. function:: \

   Matrix division using a polyalgorithm. For input matrices ``A`` and ``B``, the result ``X`` is such that ``A*X == B``. For rectangular ``A``, QR factorization is used. For triangular ``A``, a triangular solve is performed. For square ``A``, Cholesky factorization is tried if the input is symmetric with a heavy diagonal. LU factorization is used in case Cholesky factorization fails or for general square inputs. If ``size(A,1) > size(A,2)``, the result is a least squares solution of ``A*X+eps=B`` using the singular value decomposition. ``A`` does not need to have full rank.

.. function:: dot

   计算the dot product

.. function:: cross

   计算the cross product of two 3-vectors

.. function:: norm

   计算the norm of a ``Vector`` or a ``Matrix``

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

   Perform Q'*A efficiently, where Q is a an orthogonal matrix defined as the product of k elementary reflectors from the QR decomposition.

.. function:: sqrtm(A)

   计算the matrix square root of ``A``. If ``B = sqrtm(A)``, then ``B*B == A`` within roundoff error.

.. function:: eig(A) -> D, V

   计算eigenvalues and eigenvectors of A

.. function:: eigvals(A)

   返回the eigenvalues of ``A``.

.. function:: svdfact(A, [thin]) -> SVDDense

   计算the Singular Value Decomposition (SVD) of ``A`` and return an ``SVDDense`` object. ``factors(svdfact(A))`` returns ``U``, ``S``, and ``Vt``, such that ``A = U*diagm(S)*Vt``. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svdfact!(A, [thin]) -> SVDDense

   ``svdfact!`` 与 ``svdfact`` 相同，but saves space by overwriting the input A, instead of creating a copy. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svd(A, [thin]) -> U, S, V

   计算the SVD of A, returning ``U``, vector ``S``, and ``V`` such that ``A == U*diagm(S)*V'``. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svdt(A, [thin]) -> U, S, Vt

   计算the SVD of A, returning ``U``, vector ``S``, and ``Vt`` such that ``A = U*diagm(S)*Vt``. If ``thin`` is ``true``, an economy mode decomposition is returned.

.. function:: svdvals(A)

   返回the singular values of ``A``.

.. function:: svdvals!(A)

   返回the singular values of ``A``, while saving space by overwriting the input.

.. function:: svdfact(A, B) -> GSVDDense

   计算the generalized SVD of ``A`` and ``B``, returning a ``GSVDDense`` Factorization object. ``factors(svdfact(A,b))`` returns ``U``, ``V``, ``Q``, ``D1``, ``D2``, and ``R0`` such that ``A = U*D1*R0*Q'`` and ``B = V*D2*R0*Q'``.
   
.. function:: svd(A, B) -> U, V, Q, D1, D2, R0

   计算the generalized SVD of ``A`` and ``B``, returning ``U``, ``V``, ``Q``, ``D1``, ``D2``, and ``R0`` such that ``A = U*D1*R0*Q'`` and ``B = V*D2*R0*Q'``.
 
.. function:: svdvals(A, B)

   返回only the singular values from the generalized singular value decomposition of ``A`` and ``B``.

.. function:: triu(M)

   Upper triangle of a matrix

.. function:: tril(M)

   Lower triangle of a matrix

.. function:: diag(M, [k])

   The ``k``-th diagonal of a matrix, as a vector

.. function:: diagm(v, [k])

   构造a diagonal matrix and place ``v`` on the ``k``-th diagonal

.. function:: diagmm(matrix, vector)

   Multiply matrices, interpreting the vector argument as a diagonal matrix.
   The arguments may occur in the other order to multiply with the diagonal
   matrix on the left.

.. function:: Tridiagonal(dl, d, du)

   构造a tridiagonal matrix from the lower diagonal, diagonal, and upper diagonal

.. function:: Woodbury(A, U, C, V)

   构造a matrix in a form suitable for applying the Woodbury matrix identity

.. function:: rank(M)

   计算the rank of a matrix

.. function:: norm(A, [p])

   计算the ``p``-norm of a vector or a matrix. ``p`` is ``2`` by default, if not provided. If ``A`` is a vector, ``norm(A, p)`` computes the ``p``-norm. ``norm(A, Inf)`` returns the largest value in ``abs(A)``, whereas ``norm(A, -Inf)`` returns the smallest. If ``A`` is a matrix, valid values for ``p`` are ``1``, ``2``, or ``Inf``. In order to compute the Frobenius norm, use ``normfro``.

.. function:: normfro(A)

   计算the Frobenius norm of a matrix ``A``.

.. function:: cond(M, [p])

   Matrix condition number, computed using the p-norm. ``p`` 如果省略，默认为 2 。 ``p`` 的有效值为 ``1``, ``2``, 和 ``Inf``.

.. function:: trace(M)

   Matrix trace

.. function:: det(M)

   Matrix determinant

.. function:: inv(M)

   Matrix inverse

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

   Weighted least-squares linear regression.

.. function:: expm(A)

   Matrix exponential.

.. function:: issym(A)

   Test whether a matrix is symmetric.

.. function:: isposdef(A)

   Test whether a matrix is positive-definite.

.. function:: istril(A)

   Test whether a matrix is lower-triangular.

.. function:: istriu(A)

   Test whether a matrix is upper-triangular.

.. function:: ishermitian(A)

   Test whether a matrix is hermitian.

.. function:: transpose(A)

   The transpose operator (.').

.. function:: ctranspose(A)

   The conjugate transpose operator (').

排列组合
--------

.. function:: nthperm(v, k)

   计算the kth lexicographic permutation of a vector.

.. function:: nthperm!(v, k)

   原地version of :func:`nthperm`.

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

   原地version of :func:`shuffle`.

.. function:: reverse(v)

   Reverse vector ``v``.

.. function:: reverse!(v) -> v

   原地version of :func:`reverse`.

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

   与 :func:`ifft` 相同，but operates in-place on ``A``.

.. function:: bfft(A [, dims])

   类似 :func:`ifft`, but computes an unnormalized inverse
   (backward) transform, which must be divided by the product of the sizes
   of the transformed dimensions in order to obtain the inverse.  (This is
   slightly more efficient than :func:`ifft` because it omits a scaling
   step, which in some applications can be combined with other
   computational steps elsewhere.)

.. function:: bfft!(A [, dims])

   与 :func:`bfft` 相同，but operates in-place on ``A``.

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

   与 :func:`plan_fft` 相同，but operates in-place on ``A``.

.. function:: plan_ifft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_ifft` 相同，but operates in-place on ``A``.

.. function:: plan_bfft!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_bfft` 相同，but operates in-place on ``A``.

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

   与 :func:`idct!` 相同，but operates in-place on ``A``.

.. function:: plan_dct(A [, dims [, flags [, timelimit]]])

   Pre-plan an optimized discrete cosine transform (DCT), similar to
   :func:`plan_fft` except producing a function that computes :func:`dct`.
   The first two arguments have the same meaning as for :func:`dct`.

.. function:: plan_dct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_dct` 相同，but operates in-place on ``A``.

.. function:: plan_idct(A [, dims [, flags [, timelimit]]])

   Pre-plan an optimized inverse discrete cosine transform (DCT), similar to
   :func:`plan_fft` except producing a function that computes :func:`idct`.
   The first two arguments have the same meaning as for :func:`idct`.

.. function:: plan_idct!(A [, dims [, flags [, timelimit]]])

   与 :func:`plan_idct` 相同，but operates in-place on ``A``.

.. function:: FFTW.r2r(A, kind [, dims]), FFTW.r2r!

   Performs a multidimensional real-input/real-output (r2r) transform
   of type ``kind`` of the array ``A``, as defined in the FFTW manual.
   ``kind`` specifies either a discrete cosine transform of various types
   (``FFTW.REDFT00``, ``FFTW.REDFT01``,``FFTW.REDFT10``, or
   ``FFTW.REDFT11``), a discrete sine transform of various types 
   (``FFTW.RODFT00``, ``FFTW.RODFT01``, ``FFTW.RODFT10``, or
   ``FFTW.RODFT11``), a real-input DFT with halfcomplex-format output
   (``FFTW.R2HC`` and its inverse ``FFTW.HC2R``), or a discrete
   Hartley transform (``FFTW.DHT``).  The ``kind`` argument may be
   an array or tuple in order to specify different transform types
   along the different dimensions of ``A``; ``kind[end]`` is used
   for any unspecified dimensions.  See the FFTW manual for precise
   definitions of these transform types, at `<http://www.fftw.org/doc>`.

   The optional ``dims``argument specifies an iterable subset of
   dimensions (e.g. an integer, range, tuple, or array) to transform
   along.  ``kind[i]`` is then the transform type for ``dims[i]``,
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

   Convolution of two vectors. Uses FFT algorithm.

.. function:: xcorr(u,v)

   计算the cross-correlation of two vectors.

并行计算
--------

.. function:: addprocs_local(n)

   Add processes on the local machine. Can be used to take advantage of multiple cores.

.. function:: addprocs_ssh({"host1","host2",...})

   Add processes on remote machines via SSH. Requires julia to be installed in the same location on each node, or to be available via a shared file system.

.. function:: addprocs_sge(n)

   Add processes via the Sun/Oracle Grid Engine batch queue, using ``qsub``.

.. function:: nprocs()

   Get the number of available processors.

.. function:: myid()

   Get the id of the current processor.

.. function:: pmap(f, c)

   Transform collection ``c`` by applying ``f`` to each element in parallel.

.. function:: remote_call(id, func, args...)

   Call a function asynchronously on the given arguments on the specified processor. 返回a ``RemoteRef``.

.. function:: wait(RemoteRef)

   Wait for a value to become available for the specified remote reference.

.. function:: fetch(RemoteRef)

   Wait for and get the value of a remote reference.

.. function:: remote_call_wait(id, func, args...)

   Perform ``wait(remote_call(...))`` in one message.

.. function:: remote_call_fetch(id, func, args...)

   Perform ``fetch(remote_call(...))`` in one message.

.. function:: put(RemoteRef, value)

   Store a value to a remote reference. Implements "shared queue of length 1" semantics: if a value is already present, blocks until the value is removed with ``take``.

.. function:: take(RemoteRef)

   Fetch the value of a remote reference, removing it so that the reference is empty again.

.. function:: RemoteRef()

   Make an uninitialized remote reference on the local machine.

.. function:: RemoteRef(n)

   Make an uninitialized remote reference on processor ``n``.

分布式数组
----------

.. function:: DArray(init, dims, [procs, dist])

   构造a distributed array. ``init`` is a function accepting a tuple of index ranges. This function should return a chunk of the distributed array for the specified indexes. ``dims`` is the overall size of the distributed array. ``procs`` optionally specifies a vector of processor IDs to use. ``dist`` is an integer vector specifying how many chunks the distributed array should be divided into in each dimension.

.. function:: dzeros(dims, ...)

   构造a distributed array of zeros. Trailing arguments are the same as those accepted by ``darray``.

.. function:: dones(dims, ...)

   构造a distributed array of ones. Trailing arguments are the same as those accepted by ``darray``.

.. function:: dfill(x, dims, ...)

   构造a distributed array filled with value ``x``. Trailing arguments are the same as those accepted by ``darray``.

.. function:: drand(dims, ...)

   构造a distributed uniform random array. Trailing arguments are the same as those accepted by ``darray``.

.. function:: drandn(dims, ...)

   构造a distributed normal random array. Trailing arguments are the same as those accepted by ``darray``.

.. function:: distribute(a)

   Convert a local array to distributed

.. function:: localize(d)

   Get the local piece of a distributed array

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

   Get the time in seconds since the epoch, with fairly high (typically, microsecond) resolution.

.. function:: time_ns()

   Get the time in nanoseconds. The time corresponding to 0 is undefined, and wraps every 5.8 years.

.. function:: tic()

   Set a timer to be read by the next call to :func:`toc` or :func:`toq`. The macro call ``@time expr`` can also be used to time evaluation.

.. function:: toc()

   打印and return the time elapsed since the last :func:`tic`.

.. function:: toq()

   Return, but do not print, the time elapsed since the last :func:`tic`.

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

   Close shared library referenced by handle.

.. function:: c_free(addr::Ptr)
  
   调用 C 标准库中的 free() 。

错误
----

.. function:: error(message::String)
              error(Exception)

   Raise an error with the given message

.. function:: throw(e)

   Throw an object as an exception

.. function:: errno()

   Get the value of the C library's ``errno``

.. function:: strerror(n)

   Convert a system call error code to a descriptive string

.. function:: assert(cond)

   Raise an error if ``cond`` is false. Also available as the macro ``@assert expr``.

任务
----

.. function:: Task(func)

   构造a ``Task`` (i.e. thread, or coroutine) to execute the given function. The task exits when this function returns.

.. function:: yieldto(task, args...)

   Switch to the given task. The first time a task is switched to, the task's function is called with ``args``. On subsequent switches, ``args`` are returned from the task's last call to ``yieldto``.

.. function:: current_task()

   Get the currently running Task.

.. function:: istaskdone(task)

   Tell whether a task has exited.

.. function:: consume(task)

   Receive the next value passed to ``produce`` by the specified task.

.. function:: produce(value)

   Send the given value to the last ``consume`` call, switching to the consumer task.

.. function:: make_scheduled(task)

   Register a task with the main event loop, so it will automatically run when possible.

.. function:: yield()

   For scheduled tasks, switch back to the scheduler to allow another scheduled task to run.

.. function:: tls(symbol)

   Look up the value of a symbol in the current task's task-local storage.

.. function:: tls(symbol, value)

   Assign a value to a symbol in the current task's task-local storage.