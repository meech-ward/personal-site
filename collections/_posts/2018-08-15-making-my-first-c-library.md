---
layout: blog-post
date: 2018-08-15 12:00:00 -0700
category: Coding
title: "Making My First C Library"
title-short: "Making My First C Library"
slug: "making-my-first-c-library"
---

I've been playing around with `C` code the last couple of weekends. Specifically the [`libav*` libraries from ffmpeg](https://trac.ffmpeg.org/wiki/Using%20libav*). And it occurred to me that i've never made my own C library. 

This bugs me a little bit, because I prefer to make libraries when I build apps in languages like Swift and JavaScript. But I've never done this with `C`, probably because I rarely program in `C`, I mean why would I except for fun?

So today, for fun, I'm going to make my first C library. 

> Note: I am not a professional `C` programmer, so my `C` code will probably not follow best practices.

{% action
  Check out the final code for this post: <https://github.com/meech-ward/smw_socket>
%}

## Unix Domain Socket Stream Server

You can use Unix sockets to communicate between two different applications on the same machine, similar to how you would use sockets to communicate between two applications over TCP.

Setting up a socket server in C isn't super difficult, so I figure it's a good starting point for creating a library. My goal is to make a library that makes setting up a Unix socket server using `<sys/socket.h>` feel more like setting up a socket server using Node's `Net` library (https://nodejs.org/api/net.html).

I mean, why not?

### The Final Code

Here's a look what its like to setup a unix domain socket client using my library:

```c
#include "smw_socket.h"

void onConnect(SMWUnixSocket *socket) {
  // Connected to server

  if (smw_unix_socket_send_data(socket, 6, "Hello") != SMWUnixServerSocketSendDataErrorNone) {
    fprintf(stderr, "Error sending data\n");
  }
}

void onData(SMWUnixSocket *socket, int dataSize, char *data) {
  // Received data
}

void onClose(SMWUnixSocket *socket) {
  // Connection closed
}

int main () {
  SMWUnixSocket *socket;
  char *filePath = "/tmp/socket_server";
  if (smw_unix_client_socket_create(filePath, &socket) != SMWUnixClientSocketConnectErrorNone) {
    fprintf(stderr, "Error creating socket\n");
    return -1;
  }

  // Connect to the server
  if (smw_unix_client_socket_connect(socket, 100, on_connect, on_data, on_close) != SMWUnixClientSocketConnectErrorNone) {
    fprintf(stderr, "Error creating connection\n");
    return -1;
  }

  return 0;
}
```

Not too bad. Now compare that to the Node.js version:

```js
const net = require('net');

const socket = net.connect('/tmp/socket_server');

socket.on('connect', () => {
  // Connected to server

  // Send some data to the server
  socket.write("Hello");
});

socket.on('data', (data) => {
  // Received data from the server
});

socket.on('close', (data) => {
  // Connection closed
});
```


The plan was pretty simple, create a node like interface for C sockets. 

### Errors

The first blocker I had was when handling errors. Handling errors in C has never really been done well, and I didn't like the idea of using `errno` or just returning a number < 0, so I just did what I would do in Swift and used error enums. 

Every function gets an accompanying enum that contains all of the possible errors that can occur in that function. That function then returns an option from the enum, which will hopefully be ErrorNone, which is 0.

### Writing the Code

Once I had the errors decision out of the way, the rest of the programming was pretty simple. I created all of the files for the library and just compiled them directly using a `test.c` file with a `main` function in it. 

```shell
gcc -g *.c -o test
```

I didn't really run into any issues here.

### Makefile

When I was ready to compile the code into a library and link against it, I just googled the correct `gcc` commands and ran them. There were a couple of commands so I just put them into a shell script so I could easily test it out and make changes quickly. 

```shell
#!/bin/bash

LIBRARY_NAME="libsmw_socket.a"

# Build library
echo "Building Library"
gcc -g -c *.c
ar r $LIBRARY_NAME *.o
rm *.o

# Build the examples
echo "Building Examples"
gcc -g ./examples/client.c  $LIBRARY_NAME -I. -o ./examples/client
gcc -g ./examples/server.c  $LIBRARY_NAME -I. -o ./examples/server
```

This works just fine, it compiles the source files into a library named `libsmw_socket.a` and them compiles the examples I had written. But this is not the `C` way of doing things. I shouldn't have a bash script doing the compilation for me, I should have a Makefile doing it for me.

Now, my experience with make and higher level tools like cmake is very limited, but I really wanted this to be complete with it's own Makefile. This actually took way longer than expected because I had a hard time finding exactly what I needed on the internet. Every make tutorial or piece of documentation was either way too basic, the equivilent of running `gcc -g -c *.c`, or way too advanced, like only helpful if I was deciphering the Makefile for opencv or something. 

Anyway, in the end I read a chapter 28 of [learn c the hard way](https://www.safaribooksonline.com/library/view/learn-c-the/9780133124385/) and I completed the Makefile:

```make
CC = gcc
CFLAGS= -g -I./build/ -I./src/ -Wall

SOURCES=$(wildcard src/*.c) 
OBJECTS=$(patsubst %.c,%.o,$(SOURCES))

TARGET=build/libsmw_socket.a

all: $(TARGET) 

$(TARGET): CFLAGS += -fPIC

$(TARGET): build $(OBJECTS)
	ar rcs $@ $(OBJECTS)
	ranlib $@

build:
	@mkdir -p build
	@mkdir -p bin

examples: all
	$(CC) $(CFLAGS) examples/client.c  $(TARGET) -o bin/client_example
	$(CC) $(CFLAGS) examples/server.c  $(TARGET) -o bin/server_example

clean:
	rm -rf build bin $(OBJECTS) $(TESTS)
```

It has separate options for compiling the library, the examples, and cleaning up. It's exactly what I wanted for this project.

## Summary

In the end, I achieved what I set out to do, create a usable C library. Although this library is usable, it is in no way complete. It doesn't handle all of the errors that could arise from using sockets, and absolutely no considerations for multithreading were taken into account. That being said, I am quite happy with this library and I might even use it in a project in the future. 
