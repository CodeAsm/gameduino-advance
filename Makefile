# Gameduino Advanced Makefile
#
# Nico Vijlbrief 
# 8-6-2017

#this will take the last connected usb serial, from dmesg.
ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|rev|awk '{print $$1}'|rev)

main:main.cpp blink.o
	avr-gcc -Os -mmcu=atmega328p -c -o main.o main.cpp 
	avr-gcc -mmcu=atmega328p main.o blink.o -o main
	avr-objcopy -O ihex -R .eeprom main main.hex
	
blink.o:lib/blink.cpp
	avr-gcc -Os -mmcu=atmega328p -c -o blink.o lib/blink.cpp
	
program:main.hex main.cpp lib/blink.cpp
	avrdude -v -p m328p -c arduino -P $(ttyUSB) -b 57600 -D -U flash:w:main.hex:i
	
clean:
	rm *.o main *.hex
