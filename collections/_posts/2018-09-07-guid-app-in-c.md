---
layout: blog-post
date: 2018-09-06 12:00:00 -0700
category: Coding
title: "Making a GUI App with C and SDL"
title-short: "Making a GUI App with C"
slug: "making-gui-app-in-c"
---

Wouldn't it be *fun* to build an entire desktop application, with a graphical user interface, entirely using C?

In this post, I'm going to walk you through what happened when I tried to make a ... with C

I did this on my mac, so all examples **will** work on a mac, and **will** need some tweaking to get working on a different OS.

{% note 
This post was written as I made the project, so 
%}

finished project https://github.com/Sam-Meech-Ward/SDL_Hello_World

## SDL

I decided to use SDL for this project, purely because it was mentioned in an [ffmpeg tutorial](http://dranger.com/ffmpeg/tutorial02.html) that I was following, and I wanted to learn a little bit more about it.

Simple DirectMedia Layer (SDL) is a cross platform C library that you can use to create a GUI and detect things like keyboard and mouse input. SDL officially supports Windows, Mac OS X, Linux, iOS, and Android. 

You can find out more about SDL here: `http://wiki.libsdl.org/Introduction`

I used a couple of different resources online. Here's a list of the more helpful ones:

* [lazyfoo.net](http://lazyfoo.net/tutorials/SDL)
* [libsdl.org](http://wiki.libsdl.org/Introduction)

### Installing SDL

Installing the SDL library is pretty easy. 

1. Download the latest version from their website: <http://libsdl.org/>
2. Open the directory that you just downloaded, then navigate to the `docs` folder and follow the instructions for your platform.

I'm following the `cmake` instructions to install the library on my mac. It installed a `libSDL2.a` static library that I'm going to use in my project.

## Hello World

The starting point of all C apps:

```c
#include <stdio.h>
#include <SDL.h> // Include the SDL library

int main(int argc, const char * argv[]) {
  printf("Hello, World!");
  return 0;
}
```

To get things started, I'm going to display an Image on the screen. And since I plan on posting this on my website, I'm going to go with this licence free, rediculously cute image of a Chihuahua in a tea cup that?

{% post_image_large making-gui-app-in-c/animal-chihuahua-cute.jpg %}

I'm currently following _some_ of the instructions on <http://lazyfoo.net/tutorials/SDL/> to figure this part out.

It looks like displaying the image is a pretty simple, 3-step, process. 

1) Create a window to display content to:

```c
int err = 0;

if((err = SDL_Init(SDL_INIT_VIDEO)) < 0) {
  return err;
}

int windowPosition = SDL_WINDOWPOS_UNDEFINED; // Don't care about the x, y position of the window
int width = 800;
int height = 800;
SDL_Window *window = SDL_CreateWindow("Hello", windowPosition, windowPosition, width, height, SDL_WINDOW_SHOWN);
if(window == NULL) {
    return -1;
}
```

2) Render the image to the window:

```c
SDL_Surface *screenSurface = SDL_GetWindowSurface(window); // The window's 2d surface that I can draw to
if(screenSurface == NULL) {
    return -1;
}

SDL_Surface *image = SDL_LoadBMP("/Users/Sam/Desktop/image.bmp");
if(image == NULL) {
  return -1;
}

SDL_BlitSurface(image, NULL, screenSurface, NULL); // Copy the image surface to the window's surface
// Re render the window
if((err = SDL_UpdateWindowSurface(window)) < 0) { 
  return err;
}

SDL_Delay(4000); // Show the window for 4 seconds
```

3) Cleanup:

```c
SDL_FreeSurface(image);
SDL_DestroyWindow(window);
SDL_Quit();
```

{% side_note 
Every time I write C, I think "C really needs better error handling", then I remember that I could have used C++ instead. Oh well, maybe next time.
%}

Here's my project structure so far:

```shell
.
├── assets
│   └── animal-chihuahua-cute.bmp
├── bin
└── src
    └── main.c
```

So to compile my app into `bin/app` using `gcc`, I should be able to run something like this:

```shell
gcc -g -Wall -I/usr/local/lib -I/usr/local/include/SDL2 src/main.c  /usr/local/lib/libSDL2.a -o bin/app
```

But that gives me a `Undefined symbols for architecture x86_64:` error because I forgot about all of the dependencies of `SDL`. For example, on a mac `SDL` needs to be compiled with frameworks like `CoreAudio` and `Cocoa`. So I'm going to look in the Makefile that I used to compile `SDL` at the start of this.

Found it:

```makefile
EXTRA_LDFLAGS =  -lm -liconv  -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal
```

That looks like what I need. So my new gcc command looks like this:

```shell
gcc -g -Wall -I/usr/local/lib -I/usr/local/include/SDL2  src/main.c  /usr/local/lib/libSDL2.a -lm -liconv  -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal -o bin/app
```

You know what, let's just make a `Makefile`:

```makefile
CC = gcc
CFLAGS= -g -Wall 

INCLUDES=-I/usr/local/lib \
-I/usr/local/include/SDL2 

# Include all the c files from the current project
SOURCES=$(wildcard src/*.c) 

# Default location for the libSDL2 on a mac
LIBRARIES=/usr/local/lib/libSDL2.a

# Dependencies of libSDL2
EXTRA_LDFLAGS =  -lm -liconv  -Wl,-framework,CoreAudio -Wl,-framework,AudioToolbox -Wl,-framework,ForceFeedback -lobjc -Wl,-framework,CoreVideo -Wl,-framework,Cocoa -Wl,-framework,Carbon -Wl,-framework,IOKit -Wl,-weak_framework,QuartzCore -Wl,-weak_framework,Metal

TARGET=bin/app

all: build
	$(CC) $(CFLAGS) $(INCLUDES) $(SOURCES) $(LIBRARIES) $(EXTRA_LDFLAGS) -o $(TARGET)

build:
	@mkdir -p bin
```

Ok, that's better. 

Compile and run:

```shell
make
bin/app
```

{% side_note 
Code So Far: <https://github.com/Sam-Meech-Ward/SDL_Hello_World/releases/tag/0.0.1>
%}

It works!! It loaded the image into memory and rendered it to the window, but since my image is much larger than `800x800px`, it got severely cropped. I can only see the top left corner.

{% post_image_large making-gui-app-in-c/app-1.png %}

So how do I fit the image on the screen? Looks like there's a tutorial on stretching an image, so I'll just do the opposite of that 🤗. http://lazyfoo.net/tutorials/SDL/05_optimized_surface_loading_and_soft_stretching/index.php

Looks like all you have to do is use `SDL_BlitScaled()` instead of `SDL_BlitSurface()`.

```c
// SDL_BlitSurface(image, NULL, screenSurface, NULL);
SDL_Rect stretchRect = { .x = 0, .y = 0, .w = width, .h = height};
SDL_BlitScaled(image, NULL, screenSurface, &stretchRect);
```

But I don't want to completely warp the image to fit it on the screen, I would rather scale it's aspect ratio down. So I need to figure out the size of the image. Maybe I can use the surface's `w` and `h` properties. <https://wiki.libsdl.org/SDL_Surface> 

Compile and run:

```shell
make
bin/app
```

{% post_image_large making-gui-app-in-c/app-2.png %}

Yay, it works!! 🤗

I mean, it's good enough.
