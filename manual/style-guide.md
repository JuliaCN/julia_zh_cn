# 代码风格指南

<!-- # Style Guide -->

本文介绍了一些写出地道的 Julia 语言代码风格的注意事项。这些规则并不是绝对的，它们只是一些建议，从而帮助你更好地熟悉这门语言，并帮助你能在各种代码设计中有所选择。

<!-- The following sections explain a few aspects of idiomatic Julia coding style. None of these rules
are absolute; they are only suggestions to help familiarize you with the language and to help
you choose among alternative designs. -->

## 写函数，而不是仅仅写脚本

<!-- ## Write functions, not just scripts -->

在程序的最外层（top level）写一系列步骤的代码，确实是一种开始解决问题的快速方法，但更推荐的做法是把程序尽可能地分解成函数。函数有更强的复用性和可测试性，并且能更清楚地让人知道哪些步骤做完了，以及每一步骤的输入输出分别是什么。不仅如此，由于 Julia 编译器的工作方式，写在函数中的代码往往也比最外层代码运行得更快。

<!-- Writing code as a series of steps at the top level is a quick way to get started solving a problem,
but you should try to divide a program into functions as soon as possible. Functions are more
reusable and testable, and clarify what steps are being done and what their inputs and outputs
are. Furthermore, code inside functions tends to run much faster than top level code, due to how
Julia's compiler works. -->

还有值得一提的是，函数应当接受参数，而不是直接使用全局变量（ [`pi`](@ref) 等常数除外）进行操作。

<!-- It is also worth emphasizing that functions should take arguments, instead of operating directly
on global variables (aside from constants like [`pi`](@ref)). -->

## 避免写过于特定的类型

<!-- ## Avoid writing overly-specific types -->

代码应该尽可能的通用。出现过于特定的类型的语句比如：

<!-- Code should be as generic as possible. Instead of writing: -->

```julia
convert(Complex{Float64}, x)
```

就不如像这样使用可用的通用函数：

<!-- it's better to use available generic functions: -->

```julia
complex(float(x))
```

第二个版本的代码会把 `x` 转换成一个合适的类型，而不是总是相同的类型。

<!-- The second version will convert `x` to an appropriate type, instead of always the same type. -->

函数的参数和这一点代码风格尤其相关。例如，当一个参数可以是任何整数时，不要声明它的类型是 `Int` 或 [`Int32`](@ref)，而要使用抽象类型（abstract type）[`Integer`](@ref) 来表示。事实上，除非有需要和其它的方法定义区分，很多情况下你可以干脆完全省略掉参数的类型，因为如果你的操作中有不支持某种参数类型的话，反正都会抛出 [`MethodError`](@ref) 的。这也被叫做 [鸭子类型](https://zh.wikipedia.org/wiki/%E9%B8%AD%E5%AD%90%E7%B1%BB%E5%9E%8B)）

<!-- This style point is especially relevant to function arguments. For example, don't declare an argument
to be of type `Int` or [`Int32`](@ref) if it really could be any integer, expressed with the abstract
type [`Integer`](@ref). In fact, in many cases you can omit the argument type altogether,
unless it is needed to disambiguate from other method definitions, since a
[`MethodError`](@ref) will be thrown anyway if a type is passed that does not support any
of the requisite operations. (This is known as
[duck typing](https://en.wikipedia.org/wiki/Duck_typing).) -->

例如，考虑这样的一个叫做 `addone` 的函数，返回它的参数加上 1 的结果，可以有下面这样的定义：

<!-- For example, consider the following definitions of a function `addone` that returns one plus its
argument: -->

```julia
addone(x::Int) = x + 1                 # works only for Int
addone(x::Integer) = x + oneunit(x)    # any integer type
addone(x::Number) = x + oneunit(x)     # any numeric type
addone(x) = x + oneunit(x)             # any type supporting + and oneunit
```

最后一种定义可以处理所有支持 [`oneunit`](@ref) （返回和 `x` 相同类型的 1，以避免不需要的类型提升（type promotion））以及 [`+`](@ref) 函数的类型。关键之处在于需要意识到，**只**定义通用的 `addone(x) = x + oneunit(x)` 并**不会**带来性能上的损失，因为 Julia 会在需要的时候自动编译特定的版本。比如说，当你第一次调用 `addone(12)` 时，Julia 会自动编译一个特定的 `addone` 函数，它接受一个 `x::Int` 的参数，并把调用的 `oneunit` 替换为内连的值 `1`。因此，上述的前三种 `addone` 的定义对于第四种来说是完全多余的。

<!-- The last definition of `addone` handles any type supporting [`oneunit`](@ref) (which returns 1 in
the same type as `x`, which avoids unwanted type promotion) and the [`+`](@ref) function with
those arguments. The key thing to realize is that there is *no performance penalty* to defining
*only* the general `addone(x) = x + oneunit(x)`, because Julia will automatically compile specialized
versions as needed. For example, the first time you call `addone(12)`, Julia will automatically
compile a specialized `addone` function for `x::Int` arguments, with the call to `oneunit`
replaced by its inlined value `1`. Therefore, the first three definitions of `addone` above are
completely redundant with the fourth definition. -->

## 让调用者处理多余的参数多样性

<!-- ## Handle excess argument diversity in the caller -->

如下的代码：

<!-- Instead of: -->

```julia
function foo(x, y)
    x = Int(x); y = Int(y)
    ...
end
foo(x, y)
```

请写成这样：

<!-- use: -->

```julia
function foo(x::Int, y::Int)
    ...
end
foo(Int(x), Int(y))
```

这种风格更好，因为 `foo` 函数其实不需要接受所有类型的数，而只需要接受 `Int`。

<!-- This is better style because `foo` does not really accept numbers of all types; it really needs
`Int` s. -->

这里的关键在于，如果一个函数需要处理的是整数，强制让调用者来决定非整数如何被转换（比如说向下还是向上取整）会更好。同时，把类型声明得具体一些的话可以为以后的方法定义留有更多的空间。

<!-- One issue here is that if a function inherently requires integers, it might be better to force
the caller to decide how non-integers should be converted (e.g. floor or ceiling). Another issue
is that declaring more specific types leaves more "space" for future method definitions. -->

## 在会修改自身参数的函数名字后加 `!`

<!-- ## Append `!` to names of functions that modify their arguments -->

如下的代码：

<!-- Instead of: -->

```julia
function double(a::AbstractArray{<:Number})
    for i = firstindex(a):lastindex(a)
        a[i] *= 2
    end
    return a
end
```

请写成这样：

<!-- use: -->

```julia
function double!(a::AbstractArray{<:Number})
    for i = firstindex(a):lastindex(a)
        a[i] *= 2
    end
    return a
end
```

Julia 的 Base 模块中的函数都遵循了这种规范，且包含很多例子：有的函数同时有拷贝和修改的形式（比如 [`sort`](@ref) 和 [`sort!`](@ref)），还有一些只有修改（比如 [`push!`](@ref)，[`pop!`](@ref) 和 [`splice!`](@ref)）。为了方便起见，这类函数通常也会把修改后的数组作为返回值。

<!-- Julia Base uses this convention throughout and contains examples of functions
with both copying and modifying forms (e.g., [`sort`](@ref) and [`sort!`](@ref)), and others
which are just modifying (e.g., [`push!`](@ref), [`pop!`](@ref), [`splice!`](@ref)).  It
is typical for such functions to also return the modified array for convenience. -->

## 避免使用奇怪的 `Union` 类型

<!-- ## Avoid strange type `Union`s -->

使用 `Union{Function,AbstractString}` 这样的类型的时候通常意味着设计还不够清晰。

<!-- Types such as `Union{Function,AbstractString}` are often a sign that some design could be cleaner. -->

## 避免在域中使用合并类型

<!-- ## Avoid type Unions in fields -->

当创建这样一种类型的时候：

<!-- When creating a type such as: -->

```julia
mutable struct MyType
    ...
    x::Union{Nothing,T}
end
```

请三思让 `x` 的值为 `nothing`（`Nothing` 类型的值）是否真的是必要的。这里有几种值得考虑的替代方法：

  * 找一个能让 `x` 初始化的安全默认值
  * 引入另一个不含 `x` 的类型
  * 如果有很多类似 `x` 的域，把他们存入一个字典
  * 判断当 `x` 为 `nothing` 时是否有一种简单的规则。比如说，这个域通常一开始为 `nothing`，但在某个明确的点时会被初始化。这种情况下，可以考虑一开始就保留未定义的状态。

<!-- ask whether the option for `x` to be `nothing` (of type `Nothing`) is really necessary. Here are
some alternatives to consider:

  * Find a safe default value to initialize `x` with
  * Introduce another type that lacks `x`
  * If there are many fields like `x`, store them in a dictionary
  * Determine whether there is a simple rule for when `x` is `nothing`. For example, often the field
    will start as `nothing` but get initialized at some well-defined point. In that case, consider
    leaving it undefined at first. -->

## 避免复杂的容器类型

<!-- ## Avoid elaborate container types -->

通常构建如下的数组并不会起到多少帮助：

<!-- It is usually not much help to construct arrays like the following: -->

```julia
a = Vector{Union{Int,AbstractString,Tuple,Array}}(uninitialized, n)
```

在这种情况下，使用 `Vector{Any}(uninitialized, n)` 会更好。同时，比起试图把很多不同的类型包成一个类型，在使用时标注类型（如 `a[i]::Int`）会对编译器帮助更大。

<!-- In this case `Vector{Any}(uninitialized, n)` is better. It is also more helpful to the compiler to annotate specific
uses (e.g. `a[i]::Int`) than to try to pack many alternatives into one type. -->

## 使用和 Julia 的 `base/` 一致的命名习惯

<!-- ## Use naming conventions consistent with Julia's `base/` -->

  * 模块和类型名使用大写开头的驼峰命名法：`module SparseArrays`，`struct UnitRange`。
  * 函数名使用小写字母，且当可读时可以将多个单词拼在一起。必要的时候，可以使用下划线作为单词分隔符。下划线也被用于指明概念的组合（比如 [`remotecall_fetch`](@ref) 作为 `fetch(remotecall(...))` 的一个更高效的实现）或者变化。
  * 虽然简洁性很重要，但避免使用缩写（用 [`indexin`](@ref) 而不是 `indxin`），因为这会让记住单词有没有被缩写或如何被缩写变得十分困难。

<!-- * modules and type names use capitalization and camel case: `module SparseArrays`, `struct UnitRange`.
  * functions are lowercase ([`maximum`](@ref), [`convert`](@ref)) and, when readable, with multiple
    words squashed together ([`isequal`](@ref), [`haskey`](@ref)). When necessary, use underscores
    as word separators. Underscores are also used to indicate a combination of concepts ([`remotecall_fetch`](@ref)
    as a more efficient implementation of `fetch(remotecall(...))`) or as modifiers.
  * conciseness is valued, but avoid abbreviation ([`indexin`](@ref) rather than `indxin`) as
    it becomes difficult to remember whether and how particular words are abbreviated. -->

如果一个函数名需要多个单词，请考虑这个函数是否代表了超过一个概念，是不是分成几个更小的部分更好。

<!-- If a function name requires multiple words, consider whether it might represent more than one
concept and might be better split into pieces. -->

## 使用与 Julia 的 Base 模块类似的参数顺序

<!-- ## Write functions with argument ordering similar to Julia's Base -->

作为一般规律，Base 库使用以下的函数参数顺序（如适用）：

<!-- As a general rule, the Base library uses the following order of arguments to functions,
as applicable: -->

1. **Function 参数**。把作为参数的函数放在第一位可以方便使用 [`do`](@ref)，以传递多行匿名函数。

<!-- 1. **Function argument**.
   Putting a function argument first permits the use of [`do`](@ref) blocks for passing
   multiline anonymous functions. -->

2. **I/O 流**。把 `IO` 对象放在第一位，可以方便将函数传递给 [`sprint`](@ref) 之类的函数，例如 `sprint(show, x)`。

<!-- 2. **I/O stream**.
   Specifying the `IO` object first permits passing the function to functions such as
   [`sprint`](@ref), e.g. `sprint(show, x)`. -->

3. **要被修改的输入**。比如，在 [`fill!(x, v)`](@ref fill!) 中，`x` 是要被修改的对象，所以放在要被插入 `x` 中的值前面。

<!-- 3. **Input being mutated**.
   For example, in [`fill!(x, v)`](@ref fill!), `x` is the object being mutated and it
   appears before the value to be inserted into `x`. -->

4. **类型**。把类型传入通常意味着要输出的值有着那种类型。在 [`parse(Int, "1")`](@ref parse) 中，类型在需要解析的字符串之前。还有很多类似的把类型放在第一位的例子，但是同时也需要注意到例如 [`read(io, String)`](@ref read) 这样的函数中，会把 `IO` 参数放在类型的更前面，这样还是保持着这里描述的顺序。

<!-- 4. **Type**.
   Passing a type typically means that the output will have the given type.
   In [`parse(Int, "1")`](@ref parse), the type comes before the string to parse.
   There are many such examples where the type appears first, but it's useful to note that
   in [`read(io, String)`](@ref read), the `IO` argument appears before the type, which is
   in keeping with the order outlined here. -->

5. **不被修改的输入**。比如在 `fill!(x, v)` 中的**不**被修改的 `v`，会放在 `x` 之后传入。

<!-- 5. **Input not being mutated**.
   In `fill!(x, v)`, `v` is *not* being mutated and it comes after `x`. -->

6. **键（Key）**。对于关联集合来说，指的是键值对的键。对于其它有索引的集合来说，指的是索引。

<!-- 6. **Key**.
   For associative collections, this is the key of the key-value pair(s).
   For other indexed collections, this is the index. -->

7. **值（Value）**。对于关联集合来说，指的是键值对的值。在类似于 `fill!(x, v)` 的情况中，指的是 `v`。

<!-- 7. **Value**.
   For associative collections, this is the value of the key-value pair(s).
   In cases like `fill!(x, v)`, this is `v`. -->

8. **其它的所有**。任何的其它参数。

<!-- 8. **Everything else**.
   Any other arguments. -->

9. **可变参数（Vararg）**。指的是在函数调用时可以被无限列在后面的参数。比如在 `Matrix{T}(uninitialized, dims)` 中，维数（dims）可以作为 [`Tuple`](@ref) 被传入（如 `Matrix{T}(uninitialized, (1,2))`），也可以作为可变参数（[`Vararg`](@ref)，如 `Matrix{T}(uninitialized, 1, 2)`。

<!-- 9. **Varargs**.
   This refers to arguments that can be listed indefinitely at the end of a function call.
   For example, in `Matrix{T}(uninitialized, dims)`, the dimensions can be given as a
   [`Tuple`](@ref), e.g. `Matrix{T}(uninitialized, (1,2))`, or as [`Vararg`](@ref)s,
   e.g. `Matrix{T}(uninitialized, 1, 2)`. -->

10. **关键字参数**。在 Julia 中，关键字参数本来就不得不定义在函数定义的最后，列在这里仅仅是为了完整性。

<!-- 10. **Keyword arguments**.
   In Julia keyword arguments have to come last anyway in function definitions; they're
   listed here for the sake of completeness. -->

大多数函数并不会接受上述所有种类的参数，这些数字仅仅是表示当适用时的优先权。

<!-- The vast majority of functions will not take every kind of argument listed above; the
numbers merely denote the precedence that should be used for any applicable arguments
to a function. -->

当然，在一些情况下有例外。例如，[`convert`](@ref) 函数总是把类型作为第一个参数。[`setindex!`](@ref) 函数的值参数在索引参数之前，这样可以让索引作为可变参数传入。

<!-- There are of course a few exceptions.
For example, in [`convert`](@ref), the type should always come first.
In [`setindex!`](@ref), the value comes before the indices so that the indices can be
provided as varargs. -->

设计 API 时，尽可能秉承着这种一般顺序会让函数的使用者有一种更一致的体验。

<!-- When designing APIs, adhering to this general order as much as possible is likely to give
users of your functions a more consistent experience. -->

## 不要过度使用 try-catch

<!-- ## Don't overuse try-catch -->

比起依赖于捕获错误，更好的是避免错误。

<!-- It is better to avoid errors than to rely on catching them. -->

## 不要给条件语句加括号

<!-- ## Don't parenthesize conditions -->

Julia 不要求在 `if` 和 `while` 后的条件两边加括号。使用如下写法：

<!-- Julia doesn't require parens around conditions in `if` and `while`. Write: -->

```julia
if a == b
```

而不是:

```julia
if (a == b)
```

## 不要过度使用 `...`

<!-- ## Don't overuse `...` -->

拼接函数参数是会上瘾的。请用简单的 `[a; b]` 来代替 `[a..., b...]`，因为前者已经是被拼接的数组了。[`collect(a)`](@ref) 也比 `[a...]` 更好，但因为 `a` 已经是一个可迭代的变量了，通常不把它转换成数组就直接使用甚至更好。

<!-- Splicing function arguments can be addictive. Instead of `[a..., b...]`, use simply `[a; b]`,
which already concatenates arrays. [`collect(a)`](@ref) is better than `[a...]`, but since `a`
is already iterable it is often even better to leave it alone, and not convert it to an array. -->

## 不要使用不必要的静态参数

<!-- ## Don't use unnecessary static parameters -->

如下的函数签名：

<!-- A function signature: -->

```julia
foo(x::T) where {T<:Real} = ...
```

应当被写作：

<!-- should be written as: -->

```julia
foo(x::Real) = ...
```

尤其是当 `T` 没有被用在函数体中时格外有意义。即使 `T` 被用到了，通常也可以被替换为 [`typeof(x)`](@ref)，后者不会导致性能上的差别。注意这并不是针对静态参数的一般警告，而仅仅是针对那些不必要的情况。

<!-- instead, especially if `T` is not used in the function body. Even if `T` is used, it can be replaced
with [`typeof(x)`](@ref) if convenient. There is no performance difference. Note that this is
not a general caution against static parameters, just against uses where they are not needed. -->

同样需要注意的是，容器类型在函数调用中可能明确地需要类型参数。详情参见[避免使用抽象容器的域](@ref)。

<!-- Note also that container types, specifically may need type parameters in function calls. See the
FAQ [Avoid fields with abstract containers](@ref) for more information. -->

## 避免判断变量是实例还是类型的混乱

<!-- ## Avoid confusion about whether something is an instance or a type -->

如下的一组定义容易令人困惑：

<!-- Sets of definitions like the following are confusing: -->

```julia
foo(::Type{MyType}) = ...
foo(::MyType) = foo(MyType)
```

请决定问题里的概念应当是 `MyType` 还是 `MyType()`，然后坚持使用其一。

<!-- Decide whether the concept in question will be written as `MyType` or `MyType()`, and stick to
it. -->

默认使用实例是比较受推崇的风格，然后只在为了解决一些问题必要时添加涉及到 `Type{MyType}` 的方法。

<!-- The preferred style is to use instances by default, and only add methods involving `Type{MyType}`
later if they become necessary to solve some problem. -->

如果一个类型实际上是个枚举，它应该被定义成一个单一的类型（理想的情况是不可变结构或原始类型），把枚举值作为它的实例。构造器和转换器可以检查那些值是否有效。这种设计比把枚举做成抽象类型，并把“值”做成子类型来得更受推崇。

<!-- If a type is effectively an enumeration, it should be defined as a single (ideally immutable struct or primitive)
type, with the enumeration values being instances of it. Constructors and conversions can check
whether values are valid. This design is preferred over making the enumeration an abstract type,
with the "values" as subtypes. -->

## 不要过度使用宏

<!-- ## Don't overuse macros -->

请注意有的宏实际上可以被写成一个函数。

<!-- Be aware of when a macro could really be a function instead. -->

在宏内部调用 [`eval`](@ref) 是一个特别危险的警告标志，它意味着这个宏仅在被最外层调用时起作用。如果这样的宏被写成函数，它会自然地访问得到它所需要的运行时值。

<!-- Calling [`eval`](@ref) inside a macro is a particularly dangerous warning sign; it means the
macro will only work when called at the top level. If such a macro is written as a function instead,
it will naturally have access to the run-time values it needs. -->

## 不要把不安全的操作暴露在接口层

<!-- ## Don't expose unsafe operations at the interface level -->

如果你有一个使用本地指针的类型：

<!-- If you have a type that uses a native pointer: -->

```julia
mutable struct NativeType
    p::Ptr{UInt8}
    ...
end
```

不要定义类似如下的函数：

<!-- don't write definitions like the following: -->

```julia
getindex(x::NativeType, i) = unsafe_load(x.p, i)
```

这里的问题在于，这个类型的用户可能在意识不到操作时不安全的情况下写出 `x[i]`，然后容易遇到内存错误。

<!-- The problem is that users of this type can write `x[i]` without realizing that the operation is
unsafe, and then be susceptible to memory bugs. -->

在这样的函数中，可以加上对操作的检查来确保安全，或者可以在名字的某处加上 `unsafe` 来警告调用者。

<!-- Such a function should either check the operation to ensure it is safe, or have `unsafe` somewhere
in its name to alert callers. -->

## 不要重载基础容器类型的方法

<!-- ## Don't overload methods of base container types -->

有时可能会想要写这样的定义：

<!-- It is possible to write definitions like the following: -->

```julia
show(io::IO, v::Vector{MyType}) = ...
```

这样可以提供对特定的某种新元素类型的向量的自定义显示。这种做法虽然很诱人，但应当被避免。这里的问题在于用户会想着一个像 `Vector()` 这样熟知的类型以某种方式表现，但过度自定义的行为会让使用变得更难。

<!-- This would provide custom showing of vectors with a specific new element type. While tempting,
this should be avoided. The trouble is that users will expect a well-known type like `Vector()`
to behave in a certain way, and overly customizing its behavior can make it harder to work with. -->

## 避免类型盗版

<!-- ## Avoid type piracy -->

“类型盗版”（type piracy）指的是扩展或是重定义 Base 或其它包中的并不是你所定义的类型的方法。在某些情况下，你可以几乎毫无副作用地逃避类型盗版。但在极端情况下，你甚至会让 Julia 崩溃（比如说你的方法扩展或重定义造成了对 `ccall` 传入了无效的输入）。类型盗版也让代码推导变得更复杂，且可能会引入难以预料和诊断的不兼容性。

<!-- "Type piracy" refers to the practice of extending or redefining methods in Base
or other packages on types that you have not defined. In some cases, you can get away with
type piracy with little ill effect. In extreme cases, however, you can even crash Julia
(e.g. if your method extension or redefinition causes invalid input to be passed to a
`ccall`). Type piracy can complicate reasoning about code, and may introduce
incompatibilities that are hard to predict and diagnose. -->

例如，你也许想在一个模块中定义符号上的乘法：

<!-- As an example, suppose you wanted to define multiplication on symbols in a module: -->

```julia
module A
import Base.*
*(x::Symbol, y::Symbol) = Symbol(x,y)
end
```

这里的问题时现在其它用到 `Base.*` 的模块同样会看到这个定义。由于 `Symbol` 是定义在 Base 里再被其它模块所使用的，这可能不可预料地改变无关代码的行为。这里有几种替代的方式，包括使用一个不同的函数名称，或是把 `Symbol` 给包在另一个你自己定义的类型中。

<!-- The problem is that now any other module that uses `Base.*` will also see this definition.
Since `Symbol` is defined in Base and is used by other modules, this can change the
behavior of unrelated code unexpectedly. There are several alternatives here, including
using a different function name, or wrapping the `Symbol`s in another type that you define. -->

有时候，耦合的包可能会使用类型盗版，以此来从定义分隔特性，尤其是当那些包是一些合作的作者设计的时候，且那些定义是可重用的时候。例如，一个包可能提供一些对处理色彩有用的类型，另一个包可能为那些类型定义色彩空间之间转换的方法。再举一个例子，一个包可能是一些 C 代码的简易包装，另一个包可能就“盗版”来实现一些更高级别的、对 Julia 友好的 API。

<!-- Sometimes, coupled packages may engage in type piracy to separate features from definitions,
especially when the packages were designed by collaborating authors, and when the
definitions are reusable. For example, one package might provide some types useful for
working with colors; another package could define methods for those types that enable
conversions between color spaces. Another example might be a package that acts as a thin
wrapper for some C code, which another package might then pirate to implement a
higher-level, Julia-friendly API. -->

## 注意类型相等

<!-- ## Be careful with type equality -->

通常会用 [`isa`](@ref) 和 [`<:`](@ref) 来对类型进行测试，而不会用到 `==`。检测类型的相等通常只对和一个已知的具体类型比较有意义（例如 `T == Float64`），或者你**真的真的**知道自己在做什么。

<!-- You generally want to use [`isa`](@ref) and [`<:`](@ref) for testing types,
not `==`. Checking types for exact equality typically only makes sense when comparing to a known
concrete type (e.g. `T == Float64`), or if you *really, really* know what you're doing. -->

## 不要写 `x->f(x)`

<!-- ## Do not write `x->f(x)` -->

因为调用高阶函数时经常会用到匿名函数，很容易认为这是合理甚至必要的。但任何函数都可以被直接传递，并不需要被“包"在一个匿名函数中。比如 `map(x->f(x), a)` 应当被写成 [`map(f, a)`](@ref)。

<!-- Since higher-order functions are often called with anonymous functions, it is easy to conclude
that this is desirable or even necessary. But any function can be passed directly, without being
"wrapped" in an anonymous function. Instead of writing `map(x->f(x), a)`, write [`map(f, a)`](@ref). -->

## 尽可能避免使用浮点数作为通用代码的字面量

<!-- ## Avoid using floats for numeric literals in generic code when possible -->

当写处理数字，且可以处理多种不同数字类型的参数的通用代码时，请使用对参数影响（通过类型提升）尽可能少的类型的字面量。

<!-- If you write generic code which handles numbers, and which can be expected to run with many different
numeric type arguments, try using literals of a numeric type that will affect the arguments as
little as possible through promotion. -->

例如，

<!-- For example, -->

```jldoctest
julia> f(x) = 2.0 * x
f (generic function with 1 method)

julia> f(1//2)
1.0

julia> f(1/2)
1.0

julia> f(1)
2.0
```

而

<!-- while -->

```jldoctest
julia> g(x) = 2 * x
g (generic function with 1 method)

julia> g(1//2)
1//1

julia> g(1/2)
1.0

julia> g(1)
2
```

如你所见，使用了 `Int` 字面量的第二个版本保留了输入参数的类型，而第一个版本没有。这是因为例如 `promote_type(Int, Float64) == Float64`，且做乘法时会需要类型提升。类似地，[`Rational`](@ref) 字面量比 [`Float64`](@ref) 字面量对类型有着更小的破坏性，但比 `Int` 大。

<!-- As you can see, the second version, where we used an `Int` literal, preserved the type of the
input argument, while the first didn't. This is because e.g. `promote_type(Int, Float64) == Float64`,
and promotion happens with the multiplication. Similarly, [`Rational`](@ref) literals are less type disruptive
than [`Float64`](@ref) literals, but more disruptive than `Int`s: -->

```jldoctest
julia> h(x) = 2//1 * x
h (generic function with 1 method)

julia> h(1//2)
1//1

julia> h(1/2)
1.0

julia> h(1)
2//1
```

所以，可能时尽量使用 `Int` 字面量，对非整数字面量使用 `Rational{Int}`，这样可以让代码变得更容易使用。

<!-- Thus, use `Int` literals when possible, with `Rational{Int}` for literal non-integer numbers,
in order to make it easier to use your code. -->
