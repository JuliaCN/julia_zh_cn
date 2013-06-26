============
Julia 扩展包
============

到哪儿找 Julia 扩展包
---------------------

- 官方列表详见 :ref:`available-packages` 。

- 新扩展包的发布也可以去 `julia-users Google Groups <https://groups.google.com/forum/?fromgroups=#!forum/julia-users>`_ 找。

.. _pkg-install:

如何使用 Julia 扩展包
-----------------------

Julia 的 `Pkg` 模块提供了安装、管理第三方扩展包的工具。它能在安装扩展包时解决依赖关系。

更新扩展包列表： ::

    Pkg.update()

使用 ``Pkg.add()`` 安装扩展包，其中 ``MY_PACKAGE_NAME`` 为实际扩展包的名字： ::

   Pkg.add("MY_PACKAGE_NAME")

扩展包被安装到 ``$HOME/.julia/MY_PACKAGE_NAME`` 。删除扩展包： ::

   Pkg.rm("MY_PACKAGE_NAME")

包管理系统仍然处在快速开发中. 因此有时会出现错误. 删除 ``$HOME/.julia``
文件夹将会清除包管理器的所有内容. 执行上面的步骤, 可以将 Julia 重置到一
个干净的状态.

发布新 Julia 扩展包
-------------------

Internally, every Julia package is a ``git`` repository, and Julia uses ``git``
for its package management.

.. caution::
   The following instructions are provided in the hopes that most package
   developers will be able to use them with minimal fuss.
   Contributors who are new to ``git`` are **strongly** encouraged to work
   through at least `a tutorial <http://try.github.io/levels/1/challenges/1>`_ to
   become familiar with how to use ``git`` and to understand the various issues
   that may arise.
   
   As individual situations may vary, contributors should bear in mind that
   these instructions are meant as guidelines and not absolute commandments.
   Contributors, especially those new to ``git``, are encouraged to seek help
   from `the Julia community <http://julialang.org/community>`_ and to
   `file issues <https://github.com/JuliaLang/julia/issues>`_ with suggestions
   for improving these instructions or documenting situations in which they do
   not work.

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
 
6. 至少添加一个 git commit ，并把它提交到远程仓库： ::

    # Do some stuff
    git add #要追踪的文件
    #也可以使用下面的命令来追踪所有的新文件和更改过的文件
    #git add -A
    git commit
    git push -u github master

分发 Julia 扩展包
~~~~~~~~~~~~~~~~~

Information about Julia packages is distributed through the
`METADATA.jl repository on GitHub <https://github.com/JuliaLang/METADATA.jl>`_,
which serves as a master list for available packages. Contributors are
encouraged to register their packages by updating this repository, so that their
packages will work with Julia's built-in package handling mechanism as described
in :ref:`pkg-install`.

Currently, updates are only accepted via the ``devel`` branch. Contributors
should ensure that their local METADATA has the ``devel`` branch checked out and
that the latest developments are on this branch.

设置（每个用户仅设置一次）
--------------------------

1. Fork a copy of METADATA.jl, if you haven't done so already.
   To do so, go to the `master METADATA.jl repository on GitHub <https://github.com/JuliaLang/METADATA.jl>`_
   in your web browser and click on the `Fork` button.

.. image:: ../images/github_metadata_fork.png

fork 后的仓库 URL 为 `https://github.com/MY_GITHUB_USER/METADATA.jl` 。

2. 更新 fork 的 METADATA： ::

    cd $HOME/.julia/METADATA
    git remote add github https://github.com/MY_GITHUB_USER/METADATA.jl

3. If you have started development based off of the ``master`` branch, you will
need to migrate the changes to the ``devel`` branch. Try this instead of Step 1
of the next section.::

    cd $HOME/.julia/METADATA
    git stash                          #Save any local changes
    git branch -m old-master           #Move local master branch 
    git reset --hard origin/master     #Get a fresh copy of the master branch
    git checkout -b MY_PACKAGE_NAME devel #Start a new branch to work on from devel
    git rebase --onto MY_PACKAGE_NAME old-master #Migrate commits from old local master
    git stash pop                      #Apply any local changes


分发新扩展包或扩展包的新版本
----------------------------
1. 确认在 Github 上 fork 了 METADATA.jl ，且本地也有 METADATA 仓库。如果没有，就用你的更新版本创建个新分支： ::

    cd $HOME/.julia/METADATA
    git stash                          #Save any local changes
    git fetch --all                 #Get the latest updates but don't apply them yet
    git checkout devel              #Change to devel branch
    git rebase origin/devel         #Updates local working repo
    git push github devel           #Update remote forked repo
    git checkout -b MY_PACKAGE_NAME devel #Put all existing and new development in its own branch
    git stash pop                      #Apply any local changes

2. 在 Julia 中定位本地 METADATA ： ::

    Pkg.pkg_origin("MY_PACKAGE_NAME")
    Pkg.patch("MY_PACKAGE_NAME")

3. 更新 fork 的仓库的 URL ，并提交： ::

    cd $HOME/.julia/METADATA
    git branch MY_PACKAGE_NAME
    git checkout MY_PACKAGE_NAME
    git add MY_PACKAGE_NAME #Ensure that only the latest hash is committed
    git commit

4. Push 到远程 METADATA 仓库： ::

    git push github MY_PACKAGE_NAME

5. 用浏览器打开 `https://github.com/MY_GITHUB_USER/METADATA.jl/tree/MY_PACKAGE_NAME` 。点击 'Pull Request' 按钮。

.. image:: ../images/github_metadata_pullrequest.png

6. 提交 pull request 。确保提交到 devel 分支而不是 master 分支。

.. image:: ../images/github_metadata_develbranch.png

7. pull request 被接受后，向位于 `julia-users Google Groups <https://groups.google.com/forum/?fromgroups=#!forum/julia-users>`_ 的 Julia 社区宣布你的新扩展包。

8. The newly made branch ``MY_PACKAGE_NAME`` can now be safely deleted.::

    cd $HOME/.julia/METADATA
    git checkout devel      #Change back to devel branch
    git branch -d MY_PACKAGE_NAME
    git pull --rebase       #Update local METADATA

9. 如果 ``MY_PACKAGE_NAME`` 是新近提交的并且被接纳, 列表 
   :ref:`available-packages` 会在一周左右自动更新. 
