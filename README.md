# Julia 中文文档说明

这是 `Julia` 语言的中文文档，可以 [在线阅读](http://julia-zh-cn.readthedocs.org/en/latest/) 。

欢迎大伙儿来修订文档。仅翻译的话，什么都不用安装，直接找到要修改的文件，点击 `Edit` ，编辑好后提交即可。对 git 熟悉的请使用 git 。

停止支持标准库和扩展包部分的翻译了，多看英文文档会比较好。

本翻译项目追随 [Julia 源代码](https://github.com/JuliaLang/julia) 的 master 分支。对其余分支（如已发行版的维护分支）的支持，暂不能保证（总是忘记 git checkout ）。

## 文件布局

    manual/                         Julia 手册
    stdlib/                         Julia 标准库文档
	packages/packagelist.rst        扩展包文档
	
	conf.py                         Sphinx 配置文件
	
	note/                           暂时存放一些笔记之类的东西，将来很有可能移走

## 生成网页文档及 PDF 文档

### 生成网页文档

`readthedocs.org` 网站可以自动生成在线的网页版本，已经配置好了。除了在线阅读，也可到 [下载页面](https://readthedocs.org/projects/julia_zh_cn/downloads/) 下载最新的网页版文档压缩包。

要在本地生成网页版文档，只需运行：

    $ make helpdb.jl
    $ make html

### 生成 PDF 文档

`readthedocs.org` 网站没有中文字体（它是一老外网站，没有是必然的），因此不能生成 pdf 文件。

要在 `Ubuntu` 上生成 `pdf` 需要下面几个组件：

    python-sphinx
    texlive
    texlive-latex-extra
    texlive-xetex

首先生成所需的 TeX 文档：

    $ make helpdb.jl
    $ make latex

此时 `_build/latex/` 目录下已经自动生成了编译所需的 TeX 文档。但此文档无法支持中文，需要手工打补丁。仿照 [这里](http://bone.twbbs.org.tw/blog/2012-03-23-SphinxXeTex.html) 的说明，进入 `_build/latex/` 目录，修改 `JuliaLanguage.tex`，将引言区的

    \usepackage[utf8]{inputenc}
    
            \DeclareUnicodeCharacter{00A0}{\nobreakspace}
            \DeclareUnicodeCharacter{2203}{\ensuremath{\exists}}
            \DeclareUnicodeCharacter{2200}{\ensuremath{\forall}}
            \DeclareUnicodeCharacter{27FA}{\ensuremath{\Longleftrightarrow}}

语句删去，替换为 `\usepackage[adobefonts]{ctex}` 并保存（使用选项 `adobefonts` 需要在系统中安装 Adobe 的四个简体中文字体，也可使用 ctex 宏包的相应命令自定义中文字体，ctex 宏包说明可以在终端使用命令 `texdoc ctex` 查看）。然后在此目录下执行 `xelatex JuliaLanguage.tex` 两次即可生成中文 PDF 文档。编译过程如果遇到警告，使用回车跳过即可。


## to do
./manual/
        types.rst
        metaprogramming.rst
        networking-and-streams.rst
        parallel-computing.rst
        calling-c-and-fortran-code.rst
        packages.rst
        performance-tips.rst
        style-guide.rst
        faq.rst