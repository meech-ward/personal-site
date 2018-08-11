---
layout: youtube-post
title: "Let's Build a Temperature Sensor with a Raspberry Pi - Part 1"
title-short: "Raspberry Pi Temperature Sensor - Part 1"
slug: "raspberry-pi-temperature-sensor-part-1"
---

This is a two part project. In part one, we connected a raspberry pi to a temperature & humidity sensor so that we could read the current temperature. In [Part 2](/youtube_projects/02_raspberry-pi-temperature-sensor-part-2.html), we setup the pi to emit the temperature and humidity data using BLE. We also made an iPhone app that can read that data.


## YouTube Video

{% youtube va5JBp5LVE4 %}

## How To Build

### Required Hardware

* Raspberry pi with built in bluetooth. I used a 3b+.
* [DHT22 temperature-humidity sensor](https://www.adafruit.com/product/385)

### Steps

{% action
Install [raspbian](https://www.raspberrypi.org/downloads/raspbian/) onto the raspberry pi.
%}

{% action
Wire up the pi to the sensor.
%}

You can use the diagram and instructions on this page <https://learn.adafruit.com/dht/connecting-to-a-dhtxx-sensor>.

- Plug the left pin (red pin) into 5v.
- Plug the right pin (black pin) into ground.
- Plug the inner left pin (green pin) into a gpio pin, I chose 4.

[Raspberry pi pins](https://www.raspberrypi.org/documentation/usage/gpio/)


{% action
Plug in the pi, and connect to it using ssh.
%}

I used the following link to do this before I plugged in the pi: [Prepare SD card for Wifi on Headless Pi](https://raspberrypi.stackexchange.com/questions/10251/prepare-sd-card-for-wifi-on-headless-pi).

Here's the official documentation on how to connect to a pi using ssh: <https://www.raspberrypi.org/documentation/remote-access/ssh/>

{% action
Install node on the pi.
%}

You can use [nvm Node Version Manager](https://github.com/creationix/nvm) to do this.

You might need to run `source ~/.bashrc` before nvm works.

{% action
Make sure node is working on the pi.
%}

```shell
npm install -g cowsay
cowsay hi
```

{% action
Do the setup for [`node-dht-sensor`](https://www.npmjs.com/package/node-dht-sensor)
%}

Before you can use the `node-dht-sensor` module, you have to do some setup. You can follow the instructions on npm, but here's what I did. On the pi, run the following code:

```shell
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.56.tar.gz
tar zxvf bcm2835-1.56.tar.gz
cd bcm2835-1.56
./configure
make
sudo make check
sudo make install
```

{% action
Make the app and write the code.
%}

- Create a new node project, so just `mkdir sensor` or something.
- Inside that directory, `npm install node-dht-sensor`, might take a while.
- I've included my code below, you can just copy and paste it: 

```js
const sensor = require('node-dht-sensor');

const sensorNumber = 22;
const pinNumber = 4;
sensor.read(sensorNumber, pinNumber, (err, temperature, humidity) => {
  if (err) {
    console.log("AHHHHHHHH error", err);
    return;
  }

  console.log('temp: ' + temperature.toFixed(1) + '°C, ' + 'humidity: ' + humidity.toFixed(1) +  '%');
});
```

{% action
Run the app.
%}

```shell
node app.js
```

🤗
