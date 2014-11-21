.. _man-dates:

*********
日期和时间
*********

``Dates`` 模块提供了两种关于时间的数据类型: ``Date`` 和 ``DateTime``, 精度分别为天和毫秒, 都是抽象数据类型 ``TimeType`` 的子类型. 使用两种数据类型的原因很简单: 某些操作本身很简单, 无论是从代码上看还是逻辑上, 使用高精度的数据类型是完全没有必要的. 例如, ``Date`` 只精确到天 (也就是说, 没有小时, 分钟或者秒), 所以使用时就不需要考虑时区, 夏令时和闰秒.

``Date`` 和 ``DateTime`` 都不过是 ``Int64`` 的简单封装, 仅有的一个成员变量 ``instant`` 实际上的类型是 ``UTInstant{P}``, 代表的是基于世界时的机器时间 [1]_. ``Datetime`` 类型是 *不考虑时区* 的 (根据 Python 的讲法), 或者说是 Java 8 里面的 *本地时间*. 额外的时间日期操作可以通过 `Timezones.jl 扩展包 <https://github.com/quinnj/Timezones.jl/>`_ 来获取, 其中的数据来自 `Olsen Time Zone Database <http://www.iana.org/time-zones>`_. ``Date`` 和 ``DateTime`` 遵循 ISO 8601 标准. 值得注意的一点是, ISO 8601 关于公元前日期的处理比较特殊. 简单来说, 公元前的最后一天是公元前 1-12-31, 接下来第二天是公元 1-1-1, 所以是没有 0 年存在的. 而 ISO 标准认定, 公元前 1 年是 0 年, 所以 ``0000-12-21`` 是 ``0001-01-01`` 的前一天, ``-0001`` 是公元前 2 年, ``-0003`` 是公元前 3 年, 等等.

.. [1] 一般来说有两种常用的时间表示法, 一种是基于地球的自转状态 (地球转一整圈 = 1 天), 另一种基于 SI 秒 (固定的常量). 这两种表示方法是不一样的. 试想一下, 因为地球自转, 基于世界时的的秒可能是不等长的. 但总得来说, 基于世界时的 ``Date`` 和 ``DateTime`` 是一种简化的方案, 例如闰秒的情况不需要考虑. 这种表示时间的方案的正式名称为 `世界时 <http://en.wikipedia.org/wiki/Universal_Time>`_. 这意味着, 每一分钟有 60 秒, 每一天有 60 小时, 这样使得关于时间的计算更自然, 简单.

构造函数
-------

``Date`` 和 ``DateType`` 可以通过整数或者 ``Period`` 构造, 通过直接传入, 或者作为与特定时间的差值::

  julia> DateTime(2013)
  2013-01-01T00:00:00

  julia> DateTime(2013,7)
  2013-07-01T00:00:00

  julia> DateTime(2013,7,1)
  2013-07-01T00:00:00

  julia> DateTime(2013,7,1,12)
  2013-07-01T12:00:00

  julia> DateTime(2013,7,1,12,30)
  2013-07-01T12:30:00

  julia> DateTime(2013,7,1,12,30,59)
  2013-07-01T12:30:59

  julia> DateTime(2013,7,1,12,30,59,1)
  2013-07-01T12:30:59.001

  julia> Date(2013)
  2013-01-01

  julia> Date(2013,7)
  2013-07-01

  julia> Date(2013,7,1)
  2013-07-01

  julia> Date(Dates.Year(2013),Dates.Month(7),Dates.Day(1))
  2013-07-01

  julia> Date(Dates.Month(7),Dates.Year(2013))
  2013-07-01

``Date`` 和 ``DateTime`` 解析是通过格式化的字符串实现的. 格式化的字符串是指 *分隔* 的或者 *固定宽度* 的 "字符段" 来表示一段时间, 然后传递给 ``Date`` 或者 ``DateTime`` 的构造函数.

使用分隔的字符段方法, 需要显示指明分隔符, 所以 ``"y-m-d"`` 告诉解析器第一个和第二个字符段中间有一个 ``-``, 例如 ``"2014-07-16"``, ``y``, ``m`` 和 ``d`` 字符告诉解析器每个字符段的含义.

固定宽度字符段是使用固定宽度的字符串来表示时间. 所以 ``"yyyymmdd"`` 相对应的时间字符串为 ``"20140716"``.

同时字符表示的月份也可以被解析, 通过使用 ``u`` 和 ``U``, 分别是月份的简称和全称. 默认支持英文的月份名称, 所以 ``u`` 对应于 ``Jan``, ``Feb``, ``Mar`` 等等, ``U`` 对应于 ``January``, ``February``, ``March`` 等等. 然而, 同 ``dayname`` 和 ``monthname`` 一样, 本地化的输出也可以实现, 通过向 ``Dates.MONTHTOVALUEABBR`` 和 ``Dates.MONTHTOVALUE`` 字典添加 ``locale=>Dict{UTF8String, Int}`` 类型的映射.

更多的解析和格式化的例子可以参考 ``tests/dates``.

时间间隔/比较
----------

计算两个 ``Date`` 或者 `` DateTime`` 之间的间隔是很直观的, 考虑到他们不过是 ``UTInstant{Day}`` 和 ``UTInstant{Millisecond}`` 的简单封装. 不同点是, 计算两个 ``Date`` 的时间间隔, 返回的是 ``Day``, 而计算 ``DateTime`` 时间间隔返回的是 ``Millisecond``. 同样的, 比较两个 ``TimeType`` 本质上是比较两个 ``Int64`` ::

  julia> dt = Date(2012,2,29)
  2012-02-29

  julia> dt2 = Date(2000,2,1)
  2000-02-01

  julia> dump(dt)
  Date
    instant: UTInstant{Day}
      periods: Day
        value: Int64 734562

  julia> dump(dt2)
  Date
  instant: UTInstant{Day}
    periods: Day
      value: Int64 730151

  julia> dt > dt2
  true

  julia> dt != dt2
  true

  julia> dt + dt2
  Operation not defined for TimeTypes

  julia> dt * dt2
  Operation not defined for TimeTypes

  julia> dt / dt2
  Operation not defined for TimeTypes

  julia> dt - dt2
  4411 days

  julia> dt2 - dt
  -4411 days

  julia> dt = DateTime(2012,2,29)
  2012-02-29T00:00:00

  julia> dt2 = DateTime(2000,2,1)
  2000-02-01T00:00:00

  julia> dt - dt2
  381110402000 milliseconds

访问函数
-------

因为 ``Date`` 和 ``DateTime`` 类型是使用 ``Int64`` 的封装, 具体的某一部分可以通过访问函数来获得. 小写字母的获取函数返回值为整数 ::

  julia> t = Date(2014,1,31)
  2014-01-31

  julia> Dates.year(t)
  2014

  julia> Dates.month(t)
  1

  julia> Dates.week(t)
  5

  julia> Dates.day(t)
  31

大写字母的获取函数返回值为 ``Period`` ::

  julia> Dates.Year(t)
  2014 years

  julia> Dates.Day(t)
  31 days

如果需要一次性获取多个字段, 可以使用符合函数 ::

  julia> Dates.yearmonth(t)
  (2014,1)

  julia> Dates.monthday(t)
  (1,31)

  julia> Dates.yearmonthday(t)
  (2014,1,31)

也可以直接获取底层的 ``UTInstant`` 或 整数数值 ::

  julia> dump(t)
  Date
  instant: UTInstant{Day}
    periods: Day
    value: Int64 735264

  julia> t.instant
  UTInstant{Day}(735264 days)

  julia> Dates.value(t)
  735264

查询函数
-------

查询函数可以用来获得关于 ``TimeType`` 的额外信息, 例如某个日期是星期几 ::

  julia> t = Date(2014,1,31)
  2014-01-31

  julia> Dates.dayofweek(t)
  5

  julia> Dates.dayname(t)
  "Friday"

  julia> Dates.dayofweekofmonth(t)
  5  # 5th Friday of January

月份信息 ::

  julia> Dates.monthname(t)
  "January"

  julia> Dates.daysinmonth(t)
  31

年份信息和季节信息 ::

  julia> Dates.isleapyear(t)
  false

  julia> Dates.dayofyear(t)
  31

  julia> Dates.quarterofyear(t)
  1

  julia> Dates.dayofquarter(t)
  31

``dayname`` 和 ``monthname`` 可以传入可选参数 ``locale`` 来显示本地化的日期显示 ::

  julia> const french_daysofweek =
  [1=>"Lundi",2=>"Mardi",3=>"Mercredi",4=>"Jeudi",5=>"Vendredi",6=>"Samedi",7=>"Dimanche"];

  # Load the mapping into the Dates module under locale name "french"
  julia> Dates.VALUETODAYOFWEEK["french"] = french_daysofweek;

  julia> Dates.dayname(t;locale="french")
  "Vendredi"

``monthname`` 与之类似的, 这时, ``Dates.VALUETOMONTH`` 需要加载 ``locale=>Dict{Int, UTF8String}``.

时间间隔算术运算
------------

在使用任何一门编程语言/时间日期框架前, 最好了解下时间间隔是怎么处理的, 因为有些地方需要 `特殊的技巧 <http://msmvps.com/blogs/jon_skeet/archive/2010/12/01/the-joys-of-date-time-arithmetic.aspx>`_.

``Dates`` 模块的工作方式是这样的, 在做 ``period`` 算术运算时, 每次都做尽量小的改动. 这种方式被称之为 *日历* 算术, 或者就是平时日常交流中惯用的方式. 这些到底是什么? 举个经典的例子: 2014年1月31号加一月. 答案是什么? JavaScript 会得出 `3月3号 <http://www.markhneedham.com/blog/2009/01/07/javascript-add-a-month-to-a-date/>`_ (假设31天). PHP 会得到 `3月2号 <http://stackoverflow.com/questions/5760262/php-adding-months-to-a-date-while-not-exceeding-the-last-day-of-the-month>`_ (假设30天). 事实上, 这个问题没有正确答案. ``Dates`` 模块会给出 2月28号的答案. 它是怎么得出的? 试想下赌场的 7-7-7 赌博游戏.

设想下, 赌博机的槽不是 7-7-7, 而是年-月-日, 或者在我们的例子中, 2014-01-31. 当你想要在这个日期上增加一个月时, 对应于月份的那个槽会增加1, 所以现在是 2014-02-31, 然后检查年-月-日中的日是否超过了这个月最大的合法的数字 (28). 这种方法有什么后果呢? 我们继续加上一个月, ``2014-02-28 + Month(1) == 2014-03-28``. 什么? 你是不是期望结果是3月的最后一天? 抱歉, 不是的, 想一下 7-7-7. 因为要改变尽量少的槽, 所以我们在月份上加1, 2014-03-28, 然后就没有然后了, 因为这是个合法的日期. 然而, 如果我们在原来的日期(2014-01-31)上加上2个月, 我们会得到预想中的 2014-03-31. 这种方式带来的另一个问题是损失了可交换性, 如果强制加法的顺序的话 (也就是说,用不用的顺序相加会得到不同的结果). 例如 ::

  julia> (Date(2014,1,29)+Dates.Day(1)) + Dates.Month(1)
  2014-02-28

  julia> (Date(2014,1,29)+Dates.Month(1)) + Dates.Day(1)
  2014-03-01

这是怎么回事? 第一个例子中, 我们往1月29号加上一天, 得到 2014-01-30; 然后加上一月, 得到 2014-02-30, 然后被调整到 2014-02-28. 在第二个例子中, 我们 *先* 加一个月, 得到 2014-02-29, 然后被调整到 2014-02-28, *然后* 加一天, 得到 2014-03-01. 在处理这种问题时的一个设计原则是, 如果有多个时间间隔, 操作的顺序是按照间隔的 *类型* 排列的, 而不是按照他们的值大小或者出现顺序; 这就是说, 第一个加的是 ``Year``, 然后是 ``Month``, 然后是 ``Week``, 等等. 所以下面的例子 *是* 符合可交换性的 ::

  julia> Date(2014,1,29) + Dates.Day(1) + Dates.Month(1)
  2014-03-01

  julia> Date(2014,1,29) + Dates.Month(1) + Dates.Day(1)
  2014-03-01

很麻烦? 也许吧. 一个 ``Dates`` 的初级用户该怎么办呢? 最基本的是要清楚, 当操作月份时, 如果强制指明操作的顺序, 可能会产生意想不到的结果, 其他的就没什么了. 幸运的是, 这基本就是所有的特殊情况了 (UT 时间已经免除了夏令时, 闰秒之类的麻烦).

调整函数
-------

时间间隔的算术运算是很方便, 但同时, 有些时间的操作是基于 *日历* 或者 *时间* 本身的, 而不是一个固定的时间间隔. 例如假期的计算, 诸如 ``纪念日 = 五月的最后一个周一``, 或者 ``感恩节 = 十一月的第四个周四``. 这些时间的计算牵涉到基于日历的规则, 例如某个月的第一天或者最后一天, 下一个周四, 或者第一个和第三个周三, 等等.

``Dates`` 模块提供几个了 *调整* 函数, 这样可以简单简洁的描述时间规则. 第一组是关于周, 月, 季度, 年的第一和最后一个元素. 函数参数为  ``TimeType``, 然后按照规则返回或者 *调整* 到正确的日期.

::

   # 调整时间到相应的周一
   julia> Dates.firstdayofweek(Date(2014,7,16))
   2014-07-14

   # 调整时间到这个月的最后一天
   julia> Dates.lastdayofmonth(Date(2014,7,16))
   2014-07-31

   # 调整时间到这个季度的最后一天
   julia> Dates.lastdayofquarter(Date(2014,7,16))
   2014-09-30

接下来一组高阶函数, ``tofirst``, ``tolast``, ``tonext``, and ``toprev``, 第一个参数为 ``DateFunction``, 第二个参数 ``TimeType`` 作为起点日期. 一个 ``DateFunction`` 类型的变量是一个函数, 通常是匿名函数, 这个函数接受 ``TimeType`` 作为输入, 返回 ``Bool``, ``true`` 来表示是否满足特定的条件. 例如 ::

  julia> istuesday = x->Dates.dayofweek(x) == Dates.Tuesday  # 如果是周二, 返回 true
  (anonymous function)

  julia> Dates.tonext(istuesday, Date(2014,7,13)) # 2014-07-13 is a 是周日
  2014-07-15

  # 同时也额外提供了一些函数, 使得对星期几之类的操作更加方便
  julia> Dates.tonext(Date(2014,7,13), Dates.Tuesday)
  2014-07-15

如果是复杂的时间表达式, 使用 do-block 会很方便 ::

  julia> Dates.tonext(Date(2014,7,13)) do x
            # 如果是十一月的第四个星期四, 返回 true (感恩节)
            Dates.dayofweek(x) == Dates.Thursday &&
            Dates.dayofweekofmonth(x) == 4 &&
            Dates.month(x) == Dates.November
        end
  2014-11-27

类似的, ``tofirst`` 和 ``tolast`` 第一个参数为  ``DateFunction``, 但是默认的调整范围位当月, 或者可以用关键字参数指明调整范围为当年 ::

  julia> Dates.tofirst(istuesday, Date(2014,7,13)) # 默认位当月
  2014-07-01

  julia> Dates.tofirst(istuesday, Date(2014,7,13); of=Dates.Year)
  2014-01-07

  julia> Dates.tolast(istuesday, Date(2014,7,13))
  2014-07-29

  julia> Dates.tolast(istuesday, Date(2014,7,13); of=Dates.Year)
  2014-12-30

最后一个函数为 ``recur``. ``recur`` 函数是向量化的调整过程, 输入为起始和结束日期 (或者指明 ``StepRange``), 加上一个 ``DateFunction`` 来判断某个日期是否应该返回. 这种情况下,  ``DateFunction`` 又被经常称为 "包括" 函数, 因为它指明了 (通过返回 true) 某个日期是否应该出现在返回的日期数组中.

::
   # 匹兹堡大街清理日期; 从四月份到十一月份每月的第二个星期二
   # 时间范围从2014年1月1号到2015年1月1号
   julia> dr = Dates.Date(2014):Dates.Date(2015);
   julia> recur(dr) do x
              Dates.dayofweek(x) == Dates.Tue &&
              Dates.April <= Dates.month(x) <= Dates.Nov &&
              Dates.dayofweekofmonth(x) == 2
          end
   8-element Array{Date,1}:
    2014-04-08
    2014-05-13
    2014-06-10
    2014-07-08
    2014-08-12
    2014-09-09
    2014-10-14
    2014-11-11

时间间隔
-------

时间间隔是从人的角度考虑的一段时间, 有时是不规则的. 想下一个月; 如果从天数上讲, 不同情况下, 它可能代表 28, 29, 30, 或者 31. 或者一年可以代表 365 或者 366 天. ``Period`` 类型是 ``Int64`` 类型的简单封装, 可以通过任何可以转换成 ``Int64`` 类型的数据构造出来, 比如 ``Year(1)`` 或者 ``Month(3.0)``. 相同类型的时间间隔的行为类似于整数 ::

  julia> y1 = Dates.Year(1)
  1 year

  julia> y2 = Dates.Year(2)
  2 years

  julia> y3 = Dates.Year(10)
  10 years

  julia> y1 + y2
  3 years

  julia> div(y3,y2)
  5 years

  julia> y3 - y2
  8 years

  julia> y3 * y2
  20 years

  julia> y3 % y2
  0 years

  julia> y1 + 20
  21 years

  julia> div(y3,3) # 类似于整数除法
  3 years


另请参考 :mod:`Dates` 模块的 API 索引.
