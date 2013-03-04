:mod:`TextWrap` --- 文本封装模块
================================

.. module:: TextWrap
   :synopsis: TextWrap 模块

.. note:: 位于 ``textwrap.jl``

此模块提供 ``wrap`` 函数，它解析输入文本，重组空白，使其打印时有固定屏幕宽度，缩进是可选的。它提供两个便利的函数： ``print_wrapped`` 和 ``println_wrapped`` 。

例子： ::

    julia> require("textwrap")

    julia> using TextWrap

    julia> using OptionsMod

    julia> text = "This text is going to be wrapped around in lines no longer than 20 characters.";

    julia> println_wrapped(text, @options(width=>20))
    This text is going
    to be wrapped around
    in lines no longer
    than 20 characters.

它类似于 Python 的 textwrap 模块，但接口略有不同。

.. function:: wrap(string , [options])

    Returns a string in which newlines are inserted as appropriate in order for each line
    to fit within a specified width.

    The options are passed via an ``Options`` object (provided by the :mod:`OptionsMod` module).
    The available options, and their default values, are:

    * ``width`` (default = ``70``): the maximum width of the wrapped text, including indentation.
    * ``initial_indent`` (default = ``""``): indentation of the first line. This can be any string (shorter than ``width``),
      or it can be an integer number (lower than ``width``).
    * ``subsequent_indent`` (default = ``""``): indentation of all lines except the first. Works the same as ``initial_indent``.
    * ``break_on_hyphens`` (default = ``true``): this flag determines whether words can be broken on hyphens, e.g. whether
      "high-precision" can be split into "high-" and "precision".
    * ``break_long_words`` (default = ``true``): this flag determines what to do when a word is too long to fit in any line.
      If ``true``, the word will be broken, otherwise it will go beyond the desired text width.
    * ``replace_whitespace`` (default = ``true``): if this flag is true, all whitespace characters in the original text
      (including newlines) will be replaced by spaces.
    * ``expand_tabs`` (default = ``true``): if this flag is true, tabs will be expanded in-place into spaces. The expansion
      happens before whitespace replacement.
    * ``fix_sentence_endings`` (default = ``false``): if this flag is true, the wrapper will try to recognize sentence endings
      in the middle of a paragraph and put two spaces before the next sentence in case only one is present.

.. function:: print_wrapped(text... , [options])
              print_wrapped(io, text... , [options])
              println_wrapped(text... , [options])
              println_wrapped(io, text... , [options])

    These are just like the standard :func:`print` and :func:`println` functions (they print multiple arguments and
    accept an optional ``IO`` first argument), except that they wrap the result, and accept an optional
    last argument with the options to pass to :func:`wrap`.
