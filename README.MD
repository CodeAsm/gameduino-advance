> To go where I never been before, we go further.
 
# Gameduino Advance

This is a personal project to create a Handheld gameconsole with an Atmega386 MCU (either Arduino bootloader or smaller)
and a Color TFT. More details will come

## Hardware

Detail will come, basicly a Atmega386 and a 2.2'' TFT are required aswell as a PCF8574 for button readout
The ILI9225 TFT with onboard 74HC245 Octal bus transciever is used to convert Arduinos 5v I/O to 3.3 I/O of the TFT
The screen has a 176×220 resolution.

The TFT comes with a MicroSD card slot, we currently dont use it. 

As usual with diferent components that uses SPI, the pin names arent that clear, but its SPI. The ILI9225 is a SPI controller IC by datasheet and so the pins are in fact SPI, but labeled like I2C. it can be confusing sometimes.

The arduino allows for software and hardware SPI. I dont know why people go for the software version, as the hardware version is capable of faster reads and writes wich is visible on the tft.
The Arduino pins are connected as following:
Arduino notation: Chip pin, Name, arduino pin name.

| Arduino  | TFT     | Pin name         |
|----------|---------|------------------|
| 5V       | 1       | VCC              |
| GND      | 2,3 GND | GND              |
| -        | NC      | Not con          |
| 28,PC5,A5| 7       | CLK              |
| 27,PC4,A4| 8       | SDA              |
| 14,D8,PB0| 9       | RS               |
| RESET,P6 | 10      | RST              |
| 15,D9,PB1| 11      | CS (chip select) |
|||

CS could be connected to GND to save a pin and always be selected (we dont like that in our case)
RS is chosen to be 8, to freeup a ADC. 
RST is connected to Reset in our case, but if connected to a I/O you could reset the display at your descretion.
 For Hardware SPI (what we plan to use), CLK and SDA are locked to their pins.

## Code compilation

A make file is included and the following commands are supported:
Making all objects and compile the final executable
```
make 
``` 

To make AND upload the program to the first valid Serialport use:
``` 
make program
```

To clean all objects and compiled executables run:
```
make clean
```

### Libraries
For this project we arent going to use Arduino libs, instead we find or make our own that work as far as Arduino posible.

#### uart
This library is copied from X to enable debugging of the kernel and games over Serial rs232
#### blink
A simple Blink lib, 
#### I2C
This library should still be made, support for I2C devices
#### SPI
This library should allow Communication over SPI bus to devices
#### TFT
The TFT library (requireing the SPI lib) enables us to write to the TFT and draw :D


## Games

A few games are planned to be build into the system, later maybe more options aswell removing the default ones

### TicTacTo
Place your eggs right to win from the computer. The only winning move, is not to play ;)

### Breakout
Simple paddle the ball to a brick for points, clear the field to win. Dont lose the ball tho.

### Another game (Flappy?)
Well, there should be a game more here.

## Future plans

There are non sofar.

## references
http://www.nongnu.org/avr-libc/user-manual/group__demo__project.html
http://maxembedded.com/2013/11/the-spi-of-the-avr/

## TODO
defines (#define byte uint8_t) because we love the simple stuff, yet we still like to understand them
main.h (header locks)
git remote up