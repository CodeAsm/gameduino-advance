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


include := -I lib/ -I lib/arduino -I lib/PDQ_GFX_Libs/PDQ_GFX -I lib/PDQ_GFX_Libs/PDQ_ST7735
#if verbose = -v, compiling will be verbose
verbose = -v
#if a ttyACM is used, change the tty name (else it will be "device").
#this doesnt work correctly if usb naming is broken
ifneq ($(ttyUSB), /dev/ttyUSB0)
	#gsub is needed to remove the last :
	ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|awk '{gsub(/:/,"");print $$5}')
	# no buad for auto detection
	baud =
endif

main.hex:main.cpp obj/blink.o 
	avr-gcc $(verbose) $(include) -Os -mmcu=atmega328p -c -o obj/main.o main.cpp 
	avr-gcc $(verbose) $(include) -mmcu=atmega328p obj/main.o obj/blink.o -o obj/main
	avr-objcopy -O ihex -R .eeprom obj/main main.hex

obj/PDQ_ST7735.o:lib/PDQ_GFX_Libs/PDQ_ST7735/PDQ_ST7735.cpp
	avr-gcc $(verbose) $(include) -Os -mmcu=atmega328p -c -o obj/PDQ_ST7735.o lib/PDQ_GFX_Libs/PDQ_ST7735/PDQ_ST7735.cpp

obj/blink.o:lib/blink.cpp
	avr-gcc -Os $(include) -mmcu=atmega328p -c -o obj/blink.o lib/blink.cpp
	
program:main.hex main.cpp lib/blink.cpp
	avrdude -v -p m328p -c arduino -P $(ttyUSB) $(baud) -D -U flash:w:main.hex:i
	
test:
	echo $(ttyUSB)
clean:
	rm obj/*.o obj/main *.hex


# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter gccversion \
build elf hex eep lss sym coff extcoff \
clean clean_list program debug gdb-config