# 栈跟踪

<!-- # Stack Traces -->

`栈跟踪`模块提供了一个返回信息易于理解和能够在程序编写过程中使用的简单的栈跟踪功能。

<!-- The `StackTraces` module provides simple stack traces that are both human readable and
easy to use programmatically. -->

## 查看栈跟踪信息

<!-- ## Viewing a stack trace -->

获取栈跟踪信息的主要函数是 [`stacktrace()`](@ref):

<!-- The primary function used to obtain a stack trace is [`stacktrace`](@ref): -->

```julia-repl
julia> stacktrace()
4-element Array{StackFrame,1}:
 eval(::Module, ::Any) at boot.jl:236
 eval_user_input(::Any, ::Base.REPL.REPLBackend) at REPL.jl:66
 macro expansion at REPL.jl:97 [inlined]
 (::Base.REPL.##1#2{Base.REPL.REPLBackend})() at event.jl:73
```

调用 [`stacktrace()`](@ref) 将会返回一个由 [`StackFrame`](@ref) 组成的向量。为方便起见，可以用 [`StackTrace`](@ref) 来替代 `Vector{StackFrame}` 。（ `[...]` 说明输出结果可能因代码运行方式而异。）

<!-- Calling [`stacktrace()`](@ref) returns a vector of [`StackFrame`](@ref) s. For ease of use, the
alias [`StackTrace`](@ref) can be used in place of `Vector{StackFrame}`. (Examples with `[...]`
indicate that output may vary depending on how the code is run.) -->

```julia-repl
julia> example() = stacktrace()
example (generic function with 1 method)

julia> example()
5-element Array{StackFrame,1}:
 example() at REPL[1]:1
 eval(::Module, ::Any) at boot.jl:236
[...]

julia> @noinline child() = stacktrace()
child (generic function with 1 method)

julia> @noinline parent() = child()
parent (generic function with 1 method)

julia> grandparent() = parent()
grandparent (generic function with 1 method)

julia> grandparent()
7-element Array{StackFrame,1}:
 child() at REPL[3]:1
 parent() at REPL[4]:1
 grandparent() at REPL[5]:1
[...]
```

注意当调用 [`stacktrace()`](@ref) 时，一般将会看到一个包含有 `eval(...) at boot.jl` 的栈帧。同样的，当从 REPL 调用 [`stacktrace()`](@ref) 时，也会看到从 `REPL.jl` 来的一些额外的栈帧，一般来说看起来像这样：

<!-- Note that when calling [`stacktrace()`](@ref) you'll typically see a frame with `eval(...) at boot.jl`.
When calling [`stacktrace()`](@ref) from the REPL you'll also have a few extra frames in the stack
from `REPL.jl`, usually looking something like this: -->

```julia-repl
julia> example() = stacktrace()
example (generic function with 1 method)

julia> example()
5-element Array{StackFrame,1}:
 example() at REPL[1]:1
 eval(::Module, ::Any) at boot.jl:236
 eval_user_input(::Any, ::Base.REPL.REPLBackend) at REPL.jl:66
 macro expansion at REPL.jl:97 [inlined]
 (::Base.REPL.##1#2{Base.REPL.REPLBackend})() at event.jl:73
```

## 获取有用信息

<!-- ## Extracting useful information -->

每一个 [`StackFrame`](@ref) 都包含函数名，文件名，行号， lambda 信息，一个指示栈帧是否被内联的标志位，一个指示是否是 C 语言函数的标志位（默认情况下， C 语言函数并不会出现在栈跟踪中。），以及一个表示 [`backtrace`](@ref) 返回指针的整数：

<!-- Each [`StackFrame`](@ref) contains the function name, file name, line number, lambda info, a flag
indicating whether the frame has been inlined, a flag indicating whether it is a C function (by
default C functions do not appear in the stack trace), and an integer representation of the pointer
returned by [`backtrace`](@ref): -->

```julia-repl
julia> top_frame = stacktrace()[1]
eval(::Module, ::Expr) at REPL.jl:3

julia> top_frame.func
:eval

julia> top_frame.file
Symbol("./boot.jl")

julia> top_frame.line
236

julia> top_frame.linfo
MethodInstance for eval(::Module, ::Expr)

julia> top_frame.inlined
false

julia> top_frame.from_c
false
```

```julia-repl
julia> top_frame.pointer
0x00007f390d152a59
```

这就使得栈跟踪信息能以编程方式用于日志记录，错误处理等等。

<!-- This makes stack trace information available programmatically for logging, error handling, and
more. -->

## 错误处理

<!-- ## Error handling -->

虽然能够方便的获取调用栈当前状态在很多场合都有用，但最显而易见的应用是错误处理和程序调试。

<!-- While having easy access to information about the current state of the callstack can be helpful
in many places, the most obvious application is in error handling and debugging. -->

```julia-repl
julia> @noinline bad_function() = undeclared_variable
bad_function (generic function with 1 method)

julia> @noinline example() = try
           bad_function()
       catch
           stacktrace()
       end
example (generic function with 1 method)

julia> example()
5-element Array{StackFrame,1}:
 example() at REPL[2]:4
 eval(::Module, ::Any) at boot.jl:236
[...]
```

要注意在上个例子里，第一个栈帧指向了 [`stacktrace`](@ref) 所在的第四行，而不是 **bad_function** 所在的第二行。不仅如此，`bad_function`的栈帧甚至整个都消失了。这个问题不难理解，因为 [`stacktrace`](@ref) 是在 **catch** 中被调用的。只是看这个简单的小例子的话，似乎问题的影响并不大，因为就算不依赖栈追踪，也能一眼看出`bad_function`在哪。但在复杂情况下，前边的问题就会使排查程序错误变得非常麻烦。

<!-- You may notice that in the example above the first stack frame points points at line 4, where
[`stacktrace`](@ref) is called, rather than line 2, where *bad_function* is called, and `bad_function`'s
frame is missing entirely. This is understandable, given that [`stacktrace`](@ref) is called
from the context of the *catch*. While in this example it's fairly easy to find the actual source
of the error, in complex cases tracking down the source of the error becomes nontrivial. -->

这个问题可以通过把 [`catch_backtrace`](@ref) 的结果传递给 [`stacktrace`](@ref) 来解决。原因在于 [`catch_backtrace`](@ref) 返回的是最近发生异常的上下文的栈信息，而不是返回当前上下文的调用栈。

<!-- This can be remedied by passing the result of [`catch_backtrace`](@ref) to [`stacktrace`](@ref).
Instead of returning callstack information for the current context, [`catch_backtrace`](@ref)
returns stack information for the context of the most recent exception: -->

```julia-repl
julia> @noinline bad_function() = undeclared_variable
bad_function (generic function with 1 method)

julia> @noinline example() = try
           bad_function()
       catch
           stacktrace(catch_backtrace())
       end
example (generic function with 1 method)

julia> example()
6-element Array{StackFrame,1}:
 bad_function() at REPL[1]:1
 example() at REPL[2]:2
[...]
```

请注意现在栈跟踪指示的是正确的行号和本应消失的栈帧。

<!-- Notice that the stack trace now indicates the appropriate line number and the missing frame. -->

```julia-repl
julia> @noinline child() = error("Whoops!")
child (generic function with 1 method)

julia> @noinline parent() = child()
parent (generic function with 1 method)

julia> @noinline function grandparent()
           try
               parent()
           catch err
               println("ERROR: ", err.msg)
               stacktrace(catch_backtrace())
           end
       end
grandparent (generic function with 1 method)

julia> grandparent()
ERROR: Whoops!
7-element Array{StackFrame,1}:
 child() at REPL[1]:1
 parent() at REPL[2]:1
 grandparent() at REPL[3]:3
[...]
```

## 与 [`backtrace`](@ref) 比较

<!-- ## Comparison with [`backtrace`](@ref) -->

调用 [`backtrace`](@ref) 返回一个 `Ptr{Cvoid}` 向量。这个向量接下来可能会被传递到 [`stacktrace`](@ref) 中来进行转换：

<!-- A call to [`backtrace`](@ref) returns a vector of `Ptr{Cvoid}`, which may then be passed into
[`stacktrace`](@ref) for translation: -->

```julia-repl
julia> trace = backtrace()
21-element Array{Ptr{Cvoid},1}:
 Ptr{Cvoid} @0x00007f10049d5b2f
 Ptr{Cvoid} @0x00007f0ffeb4d29c
 Ptr{Cvoid} @0x00007f0ffeb4d2a9
 Ptr{Cvoid} @0x00007f1004993fe7
 Ptr{Cvoid} @0x00007f10049a92be
 Ptr{Cvoid} @0x00007f10049a823a
 Ptr{Cvoid} @0x00007f10049a9fb0
 Ptr{Cvoid} @0x00007f10049aa718
 Ptr{Cvoid} @0x00007f10049c0d5e
 Ptr{Cvoid} @0x00007f10049a3286
 Ptr{Cvoid} @0x00007f0ffe9ba3ba
 Ptr{Cvoid} @0x00007f0ffe9ba3d0
 Ptr{Cvoid} @0x00007f1004993fe7
 Ptr{Cvoid} @0x00007f0ded34583d
 Ptr{Cvoid} @0x00007f0ded345a87
 Ptr{Cvoid} @0x00007f1004993fe7
 Ptr{Cvoid} @0x00007f0ded34308f
 Ptr{Cvoid} @0x00007f0ded343320
 Ptr{Cvoid} @0x00007f1004993fe7
 Ptr{Cvoid} @0x00007f10049aeb67
 Ptr{Cvoid} @0x0000000000000000

julia> stacktrace(trace)
5-element Array{StackFrame,1}:
 backtrace() at error.jl:46
 eval(::Module, ::Any) at boot.jl:236
 eval_user_input(::Any, ::Base.REPL.REPLBackend) at REPL.jl:66
 macro expansion at REPL.jl:97 [inlined]
 (::Base.REPL.##1#2{Base.REPL.REPLBackend})() at event.jl:73
```

请注意由 [`backtrace`](@ref) 返回的向量包含21个指针，虽然 [`stacktrace`](@ref) 只返回5个指针。这是因为在默认情况下 [`stacktrace`](@ref) 从栈中移除了所有的底层 C 函数。如果仍想要在栈帧中包含 C 调用，你可以参照以下步骤：

<!-- Notice that the vector returned by [`backtrace`](@ref) had 21 pointers, while the vector returned
by [`stacktrace`](@ref) only has 5. This is because, by default, [`stacktrace`](@ref) removes
any lower-level C functions from the stack. If you want to include stack frames from C calls,
you can do it like this: -->

```julia-repl
julia> stacktrace(trace, true)
27-element Array{StackFrame,1}:
 jl_backtrace_from_here at stackwalk.c:103
 backtrace() at error.jl:46
 backtrace() at sys.so:?
 jl_call_method_internal at julia_internal.h:248 [inlined]
 jl_apply_generic at gf.c:2215
 do_call at interpreter.c:75
 eval at interpreter.c:215
 eval_body at interpreter.c:519
 jl_interpret_toplevel_thunk at interpreter.c:664
 jl_toplevel_eval_flex at toplevel.c:592
 jl_toplevel_eval_in at builtins.c:614
 eval(::Module, ::Any) at boot.jl:236
 eval(::Module, ::Any) at sys.so:?
 jl_call_method_internal at julia_internal.h:248 [inlined]
 jl_apply_generic at gf.c:2215
 eval_user_input(::Any, ::Base.REPL.REPLBackend) at REPL.jl:66
 ip:0x7f1c707f1846
 jl_call_method_internal at julia_internal.h:248 [inlined]
 jl_apply_generic at gf.c:2215
 macro expansion at REPL.jl:97 [inlined]
 (::Base.REPL.##1#2{Base.REPL.REPLBackend})() at event.jl:73
 ip:0x7f1c707ea1ef
 jl_call_method_internal at julia_internal.h:248 [inlined]
 jl_apply_generic at gf.c:2215
 jl_apply at julia.h:1411 [inlined]
 start_task at task.c:261
 ip:0xffffffffffffffff
```

 [`backtrace`](@ref) 返回的每个单独的指针都可以通过传递进 [`StackTraces.lookup`](@ref) 被转换为 [`StackFrame`](@ref) ：

<!-- Individual pointers returned by [`backtrace`](@ref) can be translated into [`StackFrame`](@ref)
s by passing them into [`StackTraces.lookup`](@ref): -->

```julia-repl
julia> pointer = backtrace()[1];

julia> frame = StackTraces.lookup(pointer)
1-element Array{StackFrame,1}:
 jl_backtrace_from_here at stackwalk.c:103

julia> println("The top frame is from $(frame[1].func)!")
The top frame is from jl_backtrace_from_here!
```
