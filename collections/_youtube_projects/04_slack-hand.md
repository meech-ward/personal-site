---
layout: youtube-post
date: 2019-03-13 12:00:00 -0700
title: "Internet Controlled Hand for Remote Lectures"
title-short: "Slack Hand for Lectures"
slug: "lecture-hand"
---

By day, I give web lectures to students at Lighthouse Labs Coding Bootcamp in Vancouver. I lecture to students locally in Vancouver, and the lectures get streamed to remote cohorts around Canada. They can watch the lecture live and ask questions through Slack.

A cohort in Calgary was getting upset that I was neglecting them during a lecture, so I made them a present. A hand that connects to slack and waves in front of me every time someone in Calgary has a question. You're welcome neglected Calgary students.


## YouTube Video

{% youtube kegoiIS3tNw %}

## How To Build

I used an arduino UNO knock of board and attached to a high torque servo with a hand on the end. 

### Required Hardware

* [Arduino UNO](https://amzn.to/2UCX91b)
* [High torque servo](https://amzn.to/2TBo1lE)
* Some arts and crafts supplies and an imagination.

### Steps

{% action
Make a hand out of arts and crafts supplies and attach it to the servo
%}

I traced my hand on some paper and taped it to a wooden dowel. Then I taped it to the servo.

{% post_image_large slack-hand/taped-hand.jpg %}

{% action
Connect it to the Arduino
%}

A quick google will show you how to do this. Johnny Five has a good enough example. http://johnny-five.io/examples/servo/

{% action
Write the code
%}

Now here's where the laziness really starts to kick in. First of all, I'm using JavaScript to control the thing, so it always has to be attached to my laptop. Secondly, instead of taking the time to go through Slack's api and do things the *correct* way, I wrote a hacky script that has to be dumped into slacks website using dev tools. 

**Hacky Slacky Script:**

```js
(function() {
  function postMessage(message) {
    $.ajax({
      type: "POST",
      url: 'http://localhost:8008',
      data: { message: message },
    })
    .then((data) => console.log(data))
  }
  let old = $(".c-message__body").last().text();
  setInterval(() => {
      const current = $(".c-message__body").last().text();
      if (old !== current) {
          old = current;
          postMessage(current);
  }
}, 500);
})();
```

Here's how it works:

* Navigate to the slack chat that you want this to work in. Make sure you're in chrome.
* Copy the slack script and paste it into the dev tools console.
* Run a server that will listen for requests now coming from your slack script.
* When a message comes in, `say` the message, and move tha hand. 

All of the code can be found here: The Code: https://github.com/Sam-Meech-Ward/Slack-Hand. It was written in 100% JavaScript with the help of the [johnny-five](http://johnny-five.io/) library.

## Conclusion

This was the least amount of time that I've ever spent on a project, and probably one of the most successful.
