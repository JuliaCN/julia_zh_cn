
.. currentmodule:: Base

文件系统
--------

.. function:: isblockdev(path) -> Bool

   如果 ``path`` 是块设备，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: ischardev(path) -> Bool

   如果 ``path`` 是字符设备，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: isdir(path) -> Bool

   如果 ``path`` 是文件夹，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: isexecutable(path) -> Bool

   如果当前用户对 ``path`` 有执行权限，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: isfifo(path) -> Bool

   如果 ``path`` 是 FIFO ，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: isfile(path) -> Bool

   如果 ``path`` 是文件，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: islink(path) -> Bool

   如果 ``path`` 是符号链接，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: ispath(path) -> Bool

   如果 ``path`` 是有效的文件系统路径，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: isreadable(path) -> Bool

   如果当前用户对 ``path`` 有读权限，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: issetgid(path) -> Bool

   如果 ``path`` 设置了 setgid 标识符，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: issetuid(path) -> Bool

   如果 ``path`` 设置了 setuid 标识符，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: issocket(path) -> Bool

   如果 ``path`` 是 socket，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: issticky(path) -> Bool

   如果 ``path`` 设置了粘着位，则返回 ``true`` ；否则返回 ``false`` 。

.. function:: iswriteable(path) -> Bool

   如果当前用户对 ``path`` 有写权限，则返回 ``true`` ；否则返回 ``false`` 。

