============
Julia 扩展包
============

Julia 拥有丰富的扩展包, 大大扩展了其功能.

到哪儿找 Julia 扩展包
---------------------

- 官方列表详见 :ref:`available-packages` 。

- 新扩展包的发布也可以去 `julia-users Google Groups <https://groups.google.com/forum/?fromgroups=#!forum/julia-users>`_ 找。

.. _pkg-install:

如何使用 Julia 扩展包
---------------------

Julia 的 `Pkg` 模块提供了安装、管理第三方扩展包的工具。它能在安装扩展包时解决依赖关系。

更新扩展包列表列表及已安装的扩展包： ::

    Pkg.update()

使用 ``Pkg.add()`` 安装扩展包，其中 ``MY_PACKAGE_NAME`` 为扩展包的名字： ::

   Pkg.add("MY_PACKAGE_NAME")

扩展包被安装到 ``$HOME/.julia/MY_PACKAGE_NAME`` 。删除扩展包： ::

   Pkg.rm("MY_PACKAGE_NAME")

包管理系统仍然处在快速开发中。因此有时会出现错误。删除 ``$HOME/.julia`` 文件夹将会清除包管理器的所有内容。重新执行上面的步骤, 可以重置到一个干净的状态.

如果扩展包需要一个库，你把它这个库装在了系统非常规的位置，那么你就需要把这个库的路径添加到 ``DL_LOAD_PATH`` 变量中。最简单的做法是把这行代码放进 ~/.juliarc.jl 配置脚本中。例如，我们想调用 ``/opt/local/lib`` 中的库，可以（在载入模块之前）运行下列语句： ::

    push!(DL_LOAD_PATH,"/opt/local/lib")

.. _contrib-existing:

对已有的扩展包做贡献
--------------------

:ref:`available-packages` 列表包含了每个扩展包主页的链接，从而可以给这些扩展包做贡献。你或许对特定的扩展包的存在的问题有兴趣，或者也可以直接贡献你已经写好的代码.

对于在 Github 上的扩展包, 请确保是向扩展包仓库发送 pull 请求，而不是 Julia 的仓库。

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

Note: this documentation is out of date pending further development of version 2 of Julia's package management system – specifically its tools for package developers.

1. 请检查 :ref:`available-packages` 列表，确保你的扩展包不会和已有的扩展包重名。如果你的扩展包和已有的扩展包功能有不少重合，我们希望你和那个软   件包的维护者合作，一起改进。参见 :ref:`contrib-existing` 。

2. 在 Julia 中初始化你的扩展包： ::

    Pkg.generate("MyPackageName", "MIT") # or change MIT to BSD

   它会在 ``$HOME/.julia/MY_PACKAGE_NAME`` 中初始化一个新扩展包的框架。

.. note::
   此命令会覆盖 ``$HOME/.julia/MY_PACKAGE_NAME`` 中的所有已存在的文件和 git 仓库。

3. 如果你已经创建了仓库，可以使用复制或符号链接那个仓库来覆盖这个框架。如： ::

    rm -r $HOME/.julia/MY_PACKAGE_NAME
    ln -s /path/to/existing/repo/MY_PACKAGE_NAME $HOME/.julia/MY_PACKAGE_NAME

4. 在 ``REQUIRE`` 文件中，列出你的新扩展包所依赖的所有扩展包的名字。每个扩展包一行。

5. 在扩展包里添加帮助文档 ``README.md`` 和许可协议 ``LICENSE.md`` ，把源代码放在 ``src/`` 中，测试放在 ``test/`` 中。确保每个测试文档的开头都包含这两行： ::

    using Base.Test
    using MY_PACKAGE_NAME

6. 为扩展包添加公开访问远程仓库 URL 。如，在 Github 上新建一个仓库，名为 ``MY_PACKAGE_NAME.jl`` ，然后运行： ::

    cd $HOME/.julia/MY_PACKAGE_NAME
    git remote add github https://github.com/MY_GITHUB_USER/MY_PACKAGE_NAME.jl
 
7. Add at least one git commit and push it to the remote repository::
7. 至少添加一个 git commit ，并把它提交到远程仓库： ::

    # Do some stuff
    git add #list of files goes here
    #Alternatively, to add all new and changed files, use
    #git add -A
    git commit
    git push -u github master

Setting up continuous integration testing with Travis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `Travis <https://travis-ci.org>`_ continuous integration service provides
convenient testing for open source projects on the `Ubuntu
Linux <http://ubuntu.com>`_ platform.

To set up testing for your package, see the `Getting
Started <http://about.travis-ci.org/docs/user/getting-started/>`_ section of the
Travis manual. Make sure that you enable the Travis service hook for your package on github. Check out the [Example.jl](https://github.com/JuliaLang/Example.jl) package to see this in action.

Here is a sample `.travis.yml` that runs all tests until one fails::

    language: cpp
    compiler: 
        - clang
    notifications:
        email: false
    before_install:
        - sudo add-apt-repository ppa:staticfloat/julia-deps -y
        - sudo add-apt-repository ppa:staticfloat/julianightlies -y
        - sudo apt-get update -qq -y
	- sudo apt-get install libpcre3-dev julia -y
        - git config --global user.name "Travis User"
        - git config --global user.email "travis@example.net"
    script:
        - julia -e "Pkg.init()"
        - mkdir -p ~/.julia/MY_PACKAGE_NAME
        - cp -R ./* ~/.julia/MY_PACKAGE_NAME/
        - julia ~/.julia/MY_PACKAGE_NAME/test/test.jl

Be sure to install `Ubuntu packages <http://packages.ubuntu.com>`_ for all
necessary binary dependencies as well as any Julia package dependencies within
Julia.

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
   
fork 后的仓库 URL 类似于 `https://github.com/MY_GITHUB_USER/METADATA.jl` 。

2. 更新本地仓库的 METADATA： ::

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

1. 确认在 Github 上 fork 了 METADATA.jl ，且本地也有 METADATA 仓库 ::

    cd $HOME/.julia/METADATA
    git stash                          #Save any local changes
    git fetch --all                 #Get the latest updates but don't apply them yet
    git checkout devel              #Change to devel branch
    git rebase origin/devel         #Updates local working repo
    git push github devel           #Update remote forked repo
    git checkout -b MY_PACKAGE_NAME devel #Put all existing and new development in its own branch
    git stash pop                      #Apply any local changes

2. 在 Julia 中生成本地 METADATA ::

    Pkg1.pkg_origin("MY_PACKAGE_NAME")
    Pkg1.patch("MY_PACKAGE_NAME")

3. 更新本地仓库的 METADATA ::

    cd $HOME/.julia/METADATA
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

9. :ref:`available-packages` 是自动生成的。你不需要做什么事儿来更新它。如果你的扩展包是新近提交并且被接纳的，可能要等一两周。
