# Julia 中文文档说明

这是 `Julia` 语言的中文文档。

除了 [在线阅读](http://julia-cn.readthedocs.org/zh_CN/latest/)，也可到 [下载页面](https://readthedocs.org/projects/julia-cn/downloads/) 瞧瞧。

欢迎大伙儿来修订文档。仅翻译的话，什么都不用安装，直接找到要修改的文件，点击 `Edit` ，编辑好后提交即可。对 git 熟悉的请使用 git 。

停止支持标准库和扩展包部分的翻译了，多看英文文档会比较好。

本翻译项目追随 [Julia 源代码](https://github.com/JuliaLang/julia) 的 master 分支。对其余分支（如已发行版的维护分支）的支持，暂不能保证（总是忘记 git checkout ）。

## 文件布局

    manual/         Julia 手册
    stdlib/         Julia 标准库文档
	packages/       扩展包文档
	
	conf.py         Sphinx 配置文件
	
	note/           暂时存放一些笔记之类的东西，将来很有可能移走

## to do

    ./manual/
			control-flow.rst
            types.rst
            metaprogramming.rst
            networking-and-streams.rst
            parallel-computing.rst
            calling-c-and-fortran-code.rst
            embedding.rst
            packages.rst
            performance-tips.rst
            style-guide.rst
            faq.rst
            noteworthy-differences.rst
