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

To read every line from STDIN you can use the eachline method::

    for line in eachline(STDIN)
        print("Found $line")
    end

or if you wanted to read by character instead::

    while !eof(STDIN)
        x = read(STDIN, Char)
        println("Found: $x")
    end

Text I/O
--------

文本 I/O
--------

Note that the write method mentioned above operates on binary streams. In particular, values do not get converted to any canoncical text 
representation but are written out as is::
    
    julia> write(STDOUT,0x61)
    a

For Text I/O, use the `print` or `show` methods, depending on your needs (see the standard library reference for a detailed discussion of
the difference between the two)::

    julia> print(STDOUT,0x61)
    97

Working with Files
------------------

Like many other environments, Julia has an `open` function, which takes a filename and returns an `IOStream` object
that you can use to read and write things from the file. For example if we have a file, `hello.txt`, whose contents
are "Hello, World!"::

    julia> f = open("hello.txt")
    IOStream(<file hello.txt>)

    julia> readlines(f)
    1-element Array{Union(ASCIIString,UTF8String),1}:
     "Hello, World!\n"
    
If you want to write to a file, you can open it with the write (`"w"`) flag::

    julia> f = open("hello.txt","w")
    IOStream(<file hello.txt>)
    
    julia> write(f,"Hello again.")
    12
    
If you examine the contents of `hello.txt` at this point, you will notice that it is empty; nothing has actually
been written to disk yet. This is because the IOStream must be closed before the write is actually flushed to disk::

    julia> close(f)
    
Examining hello.txt again will show it's contents have been changed.

Opening a file, doing something to it's contents, and closing it again is a very common pattern.
To make this easier, there exists another invocation of `open` which takes a function
as it's first argument and filename as it's second, opens the file, calls the function with the file as
an argument, and then closes it again. For example, given a function::

    function read_and_capitalize(f::IOStream)
        return uppercase(readall(f))
    end
    
You can call::

    julia> open(read_and_capitalize, "hello.txt")
    "HELLO AGAIN."
    
to open `hello.txt`, call `read_and_capitalize on it`, close `hello.txt`. and return the capitalized contents.

To avoid even having to define a named function, you can use the `do` syntax, which creates an anonymous
function on the fly::

    julia> open("hello.txt") do f
              uppercase(readall(f))
           end
    "HELLO AGAIN."
    

简单的 TCP 例子
---------------

Let's jump right in with a simple example involving Tcp Sockets. Let's first create a simple server:: 

    julia> @async begin
             server = listen(2000)
             while true
               sock = accept(server)
               println("Hello World\n")
             end
           end
    Task

    julia>

To those familiar with the Unix socket API, the method names will feel familiar, 
though their usage is somewhat simpler than the raw Unix socket API. The first
call to `listen` will create a server waiting for incoming connections on the 
specified port (2000) in this case. The same function may also be used to 
create various other kinds of servers::
    
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

Note that the return type of the last invocation is different. This is because 
this server does not listen on TCP, but rather on a Named Pipe (Windows 
terminology) - also called a Domain Socket (UNIX Terminology). The difference 
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

