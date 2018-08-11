---
layout: youtube-post
title: "Let's Build a Temperature Sensor with a Raspberry Pi Part 2"
---

{:.flow-text}
This is part two of the two part temperature sensor project. Make sure you check out [Part 1](/youtube_projects/01_raspberry-pi-temperature-sensor-part-1.html) first. 

{:.flow-text}
In part 2, we setup the pi to emit the temperature and humidity data using BLE. We also made an iPhone app that can read that data.


## YouTube Video

{% youtube Ti8MXgTFI7s %}

## How To Build

### Steps

{% action
First, follow the instructions in [Part 1](/youtube_projects/01_raspberry-pi-temperature-sensor-part-1.html)
%}

The raspberry pi will be acting as the bluetooth peripheral (the thing advertising it's data). Later on, we will setup the iPhone app which acts as the central device (the thing that reads data from the peripheral)

#### Bluetooth Peripheral (Raspberry Pi)

I used [bleno](https://github.com/noble/bleno), a Node.js module for implementing BLE (Bluetooth Low Energy) peripherals. Before you can use bleno, you need to install some prerequisite software.

{% action
Use the following command to install the bleno system prerequisites on your raspberry pi:
}

```shell
sudo apt-get install bluetooth bluez libbluetooth-dev libudev-dev
```

{% action
Add bleno to your project.
}

```shell
npm install bleno
```

{% action
Add the following code to your project. Probably in a new file, but that's up to you:
}

```js
const bleno = require('bleno');

// bleno.state must be poweredOn before advertising is started. 
let state;
bleno.on('stateChange', (s) => {
  state = s;
  if (state !== 'poweredOn') {
    bleno.stopAdvertising();    
  }
});

/**
 * Start or restart advertising with custom data.
 * @param {A 31 byte buffer compatible with the ble advertising spec} buffer 
 */
function startAdvertising(buffer) { 
  return new Promise((resolve, reject) => {
    bleno.stopAdvertising();  
    if (state !== 'poweredOn') {
      reject(new Error("not powered on"));
      return;
    }
    bleno.startAdvertisingWithEIRData(buffer, (error) => {
      if (error) {
        reject(error);
        return;
      } 
      resolve("😎");
    });
  });
}
```

To start advertising, all we have to do is call `startAdvertising` with a 31 byte buffer. If you're interested, heres some data on how the 31 bytes should be setup. 

* [Custom GAP advertising packet](https://docs.mbed.com/docs/ble-intros/en/latest/Advanced/CustomGAP/)
* [GAP Data Types](https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile)

{% action
Add the following function to your project:
}

```js
/**
 * Create a new 31 byte buffer with temperature and humidity data.
 * For more information about how this function works, check out the following links:
 * https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile
 * https://www.silabs.com/community/wireless/bluetooth/knowledge-base.entry.html/2017/02/10/bluetooth_advertisin-hGsf
 * @param {A Double} temperature 
 * @param {A Double} humidity 
 */
function advertisementData(temperature, humidity) {
  if (typeof temperature !== 'number' || typeof humidity !== 'number') {
    throw 'a fit';
  }

  const buffer = Buffer.alloc(31); // maximum 31 bytes

  let bufferIndex = 0;

  // flags
  buffer.writeUInt8(2, bufferIndex++);
  buffer.writeUInt8(0x01, bufferIndex++);
  buffer.writeUInt8(0x06, bufferIndex++);

  // Complete Local Name
  const name = "Sensei" // Change this
  buffer.writeUInt8(1+name.length, bufferIndex++);
  buffer.writeUInt8(0x09, bufferIndex++);
  buffer.write(name, bufferIndex);
  bufferIndex += name.length;
  
  // Manufacturer Specific Data
  // 4 bytes for each number
  buffer.writeUInt8(1+8+8, bufferIndex++);
  buffer.writeUInt8(0xFF, bufferIndex++);
  buffer.writeDoubleLE(temperature, bufferIndex);
  bufferIndex+=8;
  buffer.writeDoubleLE(humidity, bufferIndex);
  bufferIndex+=8;

  return buffer;
}
```

This will create a new 31 byte buffer with temperature and humidity data assigned to the Manufacturer Specific Data. https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile

```
Manufacturer Specific Data: 0xFF
temperature: 8 byte little endian double
humidity: 8 byte little endian double
```

To start advertising temperature and humidity, you could call the function like this:

```js
const buffer = advertisementData(24.4, 65.6);
startAdvertising(buffer);
```

> I'll let you figure out how you want to connect this to the real temperature data. My version of the peripheral code for this can be found here: https://github.com/Sam-Meech-Ward/Sensei-Peripheral-JS

Then you can use an app like [LightBlue® Explorer](https://itunes.apple.com/ca/app/lightblue-explorer/id557428110?mt=8) to verify that it's advertising. 

#### Bluetooth Central (iOS)