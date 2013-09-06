# Julia 中文文档说明

这是 `Julia` 语言的中文文档，可以 [在线阅读](http://julia-zh-cn.readthedocs.org) 。

欢迎大伙儿来修订文档。扩展包部分就暂时不翻译了，反正大家如果要使用，也得看英文文档。

需要翻译的就是 `manual/` 及 `stdlib/` 下的所有文档。仅翻译的话，什么都不用安装，直接找到要修改的文件，点击 `Edit` ，编辑好后提交即可。对 git 熟悉的请使用 git 。

本翻译项目追随 [Julia 源代码](https://github.com/JuliaLang/julia) 的 master 分支。对其余分支（如已发行版的维护分支）的支持，暂不能保证（总是忘记 git checkout ）。

## 文件布局

    manual/                         Julia 手册
    stdlib/                         Julia 标准库文档
	packages/packagelist.rst        扩展包文档（由 listpkg.jl 生成）
	helpdb_zh_CN.jl                 REPL 帮助文档数据库 （由 stdlib/ 中的文档解析生成，不需要手动修改）
						
	conf.py                         Sphinx 配置文件
	listpkg.jl                      生成 packages/packagelist.rst
	
	note/                           暂时存放一些笔记之类的东西，将来很有可能移走

## 生成帮助文档及扩展包文档

### 生成帮助文档

`Ubuntu` 上需要几个组件。安装吧，都很小：

    sudo apt-get install python-setuptools
    sudo easy_install -U Sphinx

然后运行：

    $ make helpdb.jl

好啦，`helpdb_zh_CN.jl` 就生成了。这就是在命令行输入 `help()` 时会调用的帮助文档。

可以将这个文档放在 `$JULIA_HOME/../share/julia/zh_CN/` 中，改名为 `helpdb.jl` ，然后运行：

	julia> Base.locale("zh_CN")
	"zh_CN"

这样 `help()` 应该就可以调用中文帮助文档了。想返回英文帮助文档，输入 `Base.locale("")` 或重启程序即可。

### 生成扩展包文档

运行 Julia ，安装两个扩展包：

	julia> Pkg.add("JSON")
	julia> Pkg.add("Calendar")
	
然后进入 `julia_zh_cn` 文件夹，运行

	julia> require("listpkg.jl")
	
即可生成新的 `packages/packagelist.rst` ，即本文档的 `可用扩展包` 章节。

生成时，有可能会因为 github 提示连接太频繁而运行出错。

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
