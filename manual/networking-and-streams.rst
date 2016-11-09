.. _man-networking-and-streams:

**********
 网络和流  
**********

Julia 提供了一个丰富的接口处理终端、管道、tcp套接字等等I/O流对象。
接口在系统层的实现是异步的，开发者以同步的方式调用该接口、一般无需关注底层异步实现。
接口实现主要基于Julia支持的协程(coroutine)功能。


基本流 I/O
----------

所有Julia流都至少提供一个`read`和一个`write`方法，且第一个参数都是流对象，例如::

    julia> write(STDOUT,"Hello World")
    Hello World
    
    julia> read(STDIN,Char)

    '\n'

注意我又输入了一次回车，这样Julia会读入换行符。现在，由例子可见，
`write`方法的第二个参数是将要写入的数据，`read`方法的第二个参数是即将读入的数据类型。
例如，要读入一个简单的字节数组，我们可以::

    julia> x = zeros(Uint8,4)
    4-element Uint8 Array:
     0x00
     0x00
     0x00
     0x00

    julia> read(STDIN,x)
    abcd 
    4-element Uint8 Array:
     0x61
     0x62
     0x63
     0x64

不过像上面这么写有点麻烦，还提供了一些简化的方法。例如，我们可以将上例重写成::
    
    julia> readbytes(STDIN,4)
    abcd 
    4-element Uint8 Array:
     0x61
     0x62
     0x63
     0x64   

或者直接读入整行数据::

    julia> readline(STDIN)
    abcd
    "abcd\n"

注意这取决于你的终端配置，你的TTY可能是行缓冲、需要多输入一个回车才会把数据传给julia。

如果想要读入 STDIN 中的每一行，你可以使用 eachline 函数::

    for line in eachline(STDIN)
        print("Found $line")
    end

当然，你有可能会想一个字符一个字符地读::

    while !eof(STDIN)
        x = read(STDIN, Char)
        println("Found: $x")
    end


文本 I/O
--------

注意上面所说的write方法是用来操作二进制流的，也就是说读入的值不会转换成任何其他格式，即使输出的时候看起来好像转换了一样::

    
    julia> write(STDOUT,0x61)
    a

对于字符 I/O，应该使用`print`或`show`方法 (关于它们有什么区别，你可以去看看标准库的文档)::

    julia> print(STDOUT,0x61)
    97

处理文件
------------------

很自然地，Julia也会有一个`open`函数，可以输入一个文件名，返回一个`IOStream`对象。
你可以用这个对象来对文件进行输入输出，比如说我们打开了一个文件`hello.txt`，里面就一行"Hello, World!"::

    julia> f = open("hello.txt")
    IOStream(<file hello.txt>)

    julia> readlines(f)
    1-element Array{Union(ASCIIString,UTF8String),1}:
     "Hello, World!\n"
    
如果你想往里面输出些东西，你需要在打开的时候加上一个(`"w"`)::

    julia> f = open("hello.txt","w")
    IOStream(<file hello.txt>)
    
    julia> write(f,"Hello again.")
    12
    
如果你这时手动点开`hello.txt`你会看到并没有东西被写进去，这是因为IOStream被关闭之后，真正的写入才会完成::

    julia> close(f)
    
现在你可以去点开看看，此时文件已经写入了内容。

打开一个文件，对其内容做出一些修改，然后关闭它，这是很常用的操作流程。
为了简化这个常用操作，我们有另一个使用`open`的方式，你可以传入一个函数作为第一个参数，然后文件名作为第二个参数。打开文件后，文件将会传入你的函数，做一点微小的工作，然后自动`close`。
比如说我们写出下面这个函数::

    function read_and_capitalize(f::IOStream)
        return uppercase(readall(f))
    end
    
你可以这样用::

    julia> open(read_and_capitalize, "hello.txt")
    "HELLO AGAIN."
    
打开了`hello.txt`，对它施放`read_and_capitalize`，然后关闭掉`hello.txt`，然后返回大写的文字，在REPL显示出来。

为了省去你打函数名的劳累，你还可以使用`do`语法来创建一个匿名函数，此处f是匿名函数的形参::

    julia> open("hello.txt") do f
              uppercase(readall(f))
           end
    "HELLO AGAIN."
    

简单的 TCP 例子
---------------

我们来看看下面这个使用Tcp Sockets的例子，首先创建一个简单的服务器程序:: 

    julia> @async begin
             server = listen(2000)
             while true
               sock = accept(server)
               println("Hello World\n")
             end
           end
    Task

    julia>

对于了解Unix socket API的人来说，我们用到的方法名看起来很熟悉，
尽管它们用起来比Unix socket API简单。首先在这个例子中，`listen`方法将会创建一个监听(2000)端口等待连接的服务器。它还可以用于创建各种各样其他种类的服务器::
    
    julia> listen(2000) # Listens on localhost:2000 (IPv4)
    TcpServer(active)

    julia> listen(ip"127.0.0.1",2000) # Equivalent to the first
    TcpServer(active)

    julia> listen(ip"::1",2000) # Listens on localhost:2000 (IPv6)
    TcpServer(active)

    julia> listen(IPv4(0),2001) # Listens on port 2001 on all IPv4 interfaces
    TcpServer(active)

    julia> listen(IPv6(0),2001) # Listens on port 2001 on all IPv6 interfaces
    TcpServer(active)

    julia> listen("testsocket") # Listens on a domain socket/named pipe
    PipeServer(active)

注意，最后一个调用的返回值是不一样的，这是因为这个服务器并不是监听TCP，而是监听一个Named Pipe(Windows黑科技术语)，也叫Domain Socket(UNIX术语)。The difference 
is subtle and has to do with the `accept` and `connect` methods. The `accept`
method retrieves a connection to the client that is connecting on the server we
just created, while the `connect` function connects to a server using the 
specified method. The `connect` function takes the same arguments as 
`listen`, so, assuming the environment (i.e. host, cwd, etc.) is the same you 
should be able to pass the same arguments to `connect` as you did to listen to 
establish the connection. So let's try that out (after having created the server above)::
    
    julia> connect(2000)
    TcpSocket(open, 0 bytes waiting)

    julia> Hello World

As expected we saw "Hello World" printed. So, let's actually analyze what happened behind the scenes. When we called connect, we connect to the server we had just created. Meanwhile, the accept function returns a server-side connection to the newly created socket and prints "Hello World" to indicate that the connection was successful. 

A great strength of Julia is that since the API is exposed synchronously even though the I/O is actually happening asynchronously, we didn't have to worry callbacks or even making sure that the server gets to run. When we called `connect` the current task waited for the connection to be established and only continued executing after that was done. In this pause, the server task resumed execution (because a connection request was now available), accepted the connection, printed the message and waited for the next client. Reading and writing works in the same way. To see this, consider the following simple echo server::
    
    julia> @async begin
             server = listen(2001)
             while true
               sock = accept(server)
               @async while true
                 write(sock,readline(sock))
               end
             end
           end
    Task

    julia> clientside=connect(2001)
    TcpSocket(open, 0 bytes waiting)

    julia> @async while true
              write(STDOUT,readline(clientside))
           end

    julia> println(clientside,"Hello World from the Echo Server")

    julia> Hello World from the Echo Server

解析 IP 地址
------------

One of the `connect` methods that does not follow the `listen` methods is `connect(host::ASCIIString,port)`, which will attempt to connect to the host 
given by the `host` parameter on the port given by the port parameter. It 
allows you to do things like::
    
    julia> connect("google.com",80)
    TcpSocket(open, 0 bytes waiting)

At the base of this functionality is the getaddrinfo function which will do the appropriate address resolution::
        
    julia> getaddrinfo("google.com")
    IPv4(74.125.226.225)

