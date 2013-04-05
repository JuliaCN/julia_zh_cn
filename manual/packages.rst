============
Julia 扩展包
============

到哪儿找 Julia 扩展包
---------------------

- 官方列表详见 :ref:`available-packages` 。

- 新扩展包的声明也可以去 `julia-users Google Groups <https://groups.google.com/forum/?fromgroups=#!forum/julia-users>`_ 找。

安装新 Julia 扩展包
-------------------

Julia 的 `Pkg` 模块提供了安装、管理第三方扩展包的工具。它能在安装扩展包时解决依赖关系。更新扩展包列表： ::

    Pkg.update()

使用 ``Pkg.add()`` 安装扩展包，其中 ``MY_PACKAGE_NAME`` 为实际扩展包的名字： ::

   Pkg.add("MY_PACKAGE_NAME")

扩展包被安装到 ``$HOME/.julia/MY_PACKAGE_NAME`` 。删除扩展包： ::

   Pkg.rm("MY_PACKAGE_NAME")

实际上，每个 Julia 扩展包都是一个 ``git`` 仓库， Julia 使用 ``git`` 来管理扩展包。

发布新 Julia 扩展包
-------------------

以下应将 ``MY_PACKAGE_NAME``, ``MY_GITHUB_USER`` 等替换为实际想要的名字。

新建 Julia 扩展包
~~~~~~~~~~~~~~~~~

1. 在 Julia 中初始化你的扩展包： ::

    Pkg.new("MY_PACKAGE_NAME")

它会在 ``$HOME/.julia/MY_PACKAGE_NAME`` 中初始化一个新扩展包的框架。

.. note::
   此命令会覆盖 ``$HOME/.julia/MY_PACKAGE_NAME`` 中的所有已存在的文件和 git 仓库。

2. 如果已经为你的扩展包创建了仓库，可以使用复制或符号链接来覆盖这个框架。如： ::

    rm -r $HOME/.julia/MY_PACKAGE_NAME
    ln -s /path/to/existing/repo/MY_PACKAGE_NAME $HOME/.julia/MY_PACKAGE_NAME

3. 在 ``REQUIRE`` 文件中，列出你的新扩展包所依赖的所有扩展包的名字。每个扩展包一行。

4. 在扩展包里添加帮助文档 ``README.md`` 和许可协议 ``LICENSE.md`` ，把源代码放在 ``src/`` 中，测试放在 ``test/`` 中。确保每个测试文档的开头都包含这两行： ::

    using Test
    using MY_PACKAGE_NAME

5. 为扩展包添加公开访问远程仓库 URL 。如，在 Github 上新建一个仓库，名为 ``MY_PACKAGE_NAME.jl`` ，然后运行： ::

    cd $HOME/.julia/MY_PACKAGE_NAME
    git remote add github https://github.com/MY_GITHUB_USER/MY_PACKAGE_NAME.jl
 
6. 至少添加一个 git commit ，并把它提交到远程仓库。

.. code:: bash

    # Do some stuff
    git add #new files
    git commit
    git push remote github

分发 Julia 扩展包
~~~~~~~~~~~~~~~~~

设置（每个用户仅设置一次）
--------------------------

1. fork METADATA.jl 。fork 后的仓库 URL 为 `https://github.com/MY_GITHUB_USER/METADATA.jl` 。

2. 更新 fork 的 METADATA： ::

    cd $HOME/.julia/METADATA
    git remote add github https://github.com/MY_GITHUB_USER/METADATA.jl

分发新扩展包或扩展包的新版本
----------------------------

1. 在 Julia 中定位本地 METADATA ： ::

    Pkg.pkg_origin("MY_PACKAGE_NAME")
    Pkg.patch("MY_PACKAGE_NAME")

2. 更新 fork 的仓库的 URL ，并提交： ::

    cd $HOME/.julia/METADATA
    git branch MY_PACKAGE_NAME
    git checkout MY_PACKAGE_NAME
    git add MY_PACKAGE_NAME #Ensure that only the latest hash is committed
    git commit

3. Push 到远程 METADATA 仓库： ::

    git push github MY_PACKAGE_NAME

4. 用浏览器打开 `https://github.com/MY_GITHUB_USER/METADATA.jl/tree/MY_PACKAGE_NAME` 。点击 'Pull Request' 按钮。

.. image:: ../images/github_metadata_pullrequest.png

5. 提交 pull request 。确保提交到 devel 分支而不是 master 分支。

.. image:: ../images/github_metadata_develbranch.png

6. pull request 被接受后，向位于 `julia-users Google Groups <https://groups.google.com/forum/?fromgroups=#!forum/julia-users>`_ 的 Julia 社区宣布你的新扩展包。 
