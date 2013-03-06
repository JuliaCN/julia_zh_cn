中文文档说明
============

这是 Julia 的中文文档，可以 [在线阅读](http://julia_zh_cn.readthedocs.org)
翻译进行中，欢迎群策群力。

文件布局
-----------

    manual/                         Julia 手册
    stdlib/                         Julia 标准库文档
	packages/packagelist.rst        扩展包文档（由 listpkg.jl 生成）
	helpdb_zh_CN.jl                 REPL 帮助文档数据库 （由 stdlib/ 中的文档解析生成，不需要修改）
	
	conf.py                         Sphinx 配置文件
    _themes/                        Sphinx html 主题
    sphinx/                         Sphinx 扩展和插件
    sphinx/jlhelp.py                Sphinx 插件，用于生成 helpdb_zh_CN.jl
	listpkg.jl                      生成 packages/packagelist.rst
	
因此，需要翻译的就是 manual/ 及 stdlib/ 下的所有文档。
	
生成帮助文档及扩展包文档
------------------------

Ubuntu 上安装需要几个组件。安装吧，都很小。

sudo apt-get install python-setuptools
sudo easy_install -U Sphinx

然后运行

    $ make helpdb.jl

好啦，helpdb_zh_CN.jl 就生成了。这就是命令行输入 help() 时会调用的帮助文档。

关于生成扩展包文档，我还没试。改天再说吧。

	
生成文档
--------

readthedocs.org 网站可以自动生成在线的网页版本，我都弄好了。但该网站没有中文字体（丫是一老外网站，没有是必然的），因此不能生成 pdf 文件。老外说要在 Ubuntu 上生成 pdf 需要下面几个组件。我没试，爱捯饬的自个儿弄吧。

    python-sphinx
    texlive
    texlive-latex-extra

然后运行

    $ make helpdb.jl
    $ make html
    $ make latexpdf
