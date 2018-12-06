---
layout: youtube-post
title: "Razor Blade Advent Calendar"
slug: "advent-calendar-2018"
---

Problem: Build an advent calendar that automatically unlocks candy each day.
Solution: Use razor blades... Obviously!

This year, I decided to make my girlfriend April an advent calendar full of her favorite candy. But I had to make sure that she wouldn't be able to just open up a door and take candy whenever she wanted. I needed the calendar to lock each door and only unlock one door each day in December.

My semi-successful solution was to tie each door to the calendar using a peice of string. Then I connected a razor blade to some CNC parts and had the stepper motor move the motor and cut the string, releasing the door for that day.

{% post_image_large advent-calendar-2018/calendar_1.png %}

## YouTube Video

{% youtube  %}

## How To Build

### Required Hardware

* [Arduino UNO](https://www.ebay.ca/itm/282789077942)
* [A4988 Stepper Motor Driver](https://www.ebay.com/itm/221921771119)
* [NEMA 17 Stepper motor](https://www.ebay.ca/itm/131622995166)
* [CNC Stepper Motor Coupler Connector](https://www.ebay.ca/itm/131904158434)
* [T8 500mm Lead Screw Rod W/Nut Shaft Coupling Mounting Support for 3d Printer Set](https://www.ebay.ca/itm/182887854654)
* [Lots of hardboard](https://www.homedepot.ca/en/home/p.standard-hardboard-18-x-4-x-8.1000167412.html)

### Steps

{% action
Make the calendar strurcture.
%}

First I cut out a bunch of wood to make the calendar structure. it was supposed to have 26 slots for candy (25 days in december + one bonus day when I showed off the calendar). At the end of the project, only 22 were used because the CNC parts got in the way.

{% post_image_large advent-calendar-2018/calendar_structure_1.jpg %}

{% action
Attatch the CNC parts to razor blades
%}

I didn't want to try controlling 25 separate locks, I wanted it to be simpler than that. I had purchased the following peices to make a small laser cutter, but haven't gotten around to actually making that yet:

* [NEMA 17 Stepper motor](https://www.ebay.ca/itm/131622995166)
* [CNC Stepper Motor Coupler Connector](https://www.ebay.ca/itm/131904158434)

So I attached razor blades to these pieces, with hot glue of course, so that I could just control the stepper motors that would cut some string holding on the calendar doors.

{% post_image_large advent-calendar-2018/razor_glue.jpg %}

I used a cheap plastic rail that I found at home depot, and some blank circuit boards hot glued to the nut. This worked way better than expected to guide the nut in a straight line. 

{% action
Wire up an arduino to the stepper motors.
%}

With the calendar setup and the razor blades in place, I needed to put together the circuit to control the motors from my arduino. I purchased some [A4988 stepper motor drivers](https://www.ebay.com/itm/221921771119) and used the following blog post to help me wire everything and write the first piece of code. https://howtomechatronics.com/tutorials/arduino/how-to-control-stepper-motor-with-a4988-driver-and-arduino/

{% post_image_large advent-calendar-2018/circuit.jpg %}

{% action
Program the arduino
%}

With the calendar setup and the motors and razor blades in place, I needed the code to actually make this thing work.

One big problem I faced with this, is that the arduino won't be able to know the current date and time after it's been powered down. So I needed a way of telling the arduino what the current time is, every time it gets turned on / plugged in.

My original plan was to use an arduino pro mini to keep track of time that could be connected to a 9v battery. So even when the calendar was un plugged, the pro mini would continue running. Then when the arduino UNO needed to know the time, it would just ask the pro mini.

After an hour of failing to get the [SoftwareSerial](https://www.arduino.cc/en/Reference/SoftwareSerial) library to work, I decided to give up and just use my laptop to sync up the date and time to the arduino. The consequence of this is that every time we unplug the calendar, the arduino needs to be plugged into a computer that can run the following script to sync the date: [Computer Serial](https://github.com/Sam-Meech-Ward/Calendar_Computer_Serial) code.

All of the code for the arduino can be found on github: https://github.com/Sam-Meech-Ward/Advent_Calendar_2018

{% action
Add candy and tie up all of the doors
%}

Now that the calendar is pretty much completely setup, the only thing left to do is add candy and tie up the doors.

April's favorite candies right now are the herbaland gummy candies, so I bought a bunch of those. To mix things up, I also got some lint chocolates and a fidget spinner.

{% post_image_large advent-calendar-2018/candy.jpg %}

Putting the candy in the calendar was easy, tying up all of the doors was a long and mundane task. I could never be a sewer, I don't have the patience to thread anything.

{% action
Give the advent calendar to a loved one
%}

Because of bad string tying skills, a limited amount of time until december 1st, and an overall lack of planning and experience; the calendar ended up looking like this:

{% post_image_large advent-calendar-2018/finished.jpg %}

But at least it works... kind of.

That's why you give this calendar to a loved one, they're the ones that appretiate "home made" gifts.

## Conclusion

This calendar is kind of a perfect visualization of any piece of software ever built. Most software engineers start out with a vision for something that's going to look great and work great, and  end up with code that looks and functions like this calendar. 
