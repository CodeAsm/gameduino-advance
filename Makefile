# Gameduino Advanced Makefile
#
# Nico Vijlbrief 
# 8-6-2017

#this will take the last connected usb serial, from dmesg.

#OBJS = raycast.cpp
#CC = g++
#COMPILER_FLAGS = -Wall -O3
#LINKER_FLAGS = -lSDL2
#OBJ_NAME = raycast

#all : $(OBJS)
#	$(CC) $(OBJS) $(COMPILER_FLAGS) $(LINKER_FLAGS) -o $(OBJ_NAME)
#	./$(OBJ_NAME)

ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|rev|awk '{print $$1}'|rev)
baud   :=-b 57600

#if verbose = -v, compiling will be verbose
verbose = 
#if a ttyACM is used, change the tty name (else it will be "device").
#this doesnt work correctly if usb naming is broken
ifneq ($(ttyUSB), /dev/ttyUSB0)
	#gsub is needed to remove the last :
	ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|awk '{gsub(/:/,"");print $$4}')
	# no buad for auto detection
	baud =
endif

main.hex:main.cpp blink.o
	avr-gcc $(verbose) -Os -mmcu=atmega328p -c -o main.o main.cpp 
	avr-gcc $(verbose) -mmcu=atmega328p main.o blink.o -o main
	avr-objcopy -O ihex -R .eeprom main main.hex
	
blink.o:lib/blink.cpp
	avr-gcc -Os -mmcu=atmega328p -c -o blink.o lib/blink.cpp
	
program:main.hex main.cpp lib/blink.cpp
	avrdude -v -p m328p -c arduino -P $(ttyUSB) $(baud) -D -U flash:w:main.hex:i
	
test:
	echo $(ttyUSB)
clean:
	rm *.o main *.hex


# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter gccversion \
build elf hex eep lss sym coff extcoff \
clean clean_list program debug gdb-config