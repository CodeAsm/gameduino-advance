# Gameduino Advanced Makefile
#
# Nico Vijlbrief 
# 8-6-2017


ODIR=obj/
OBJ = main.o
CC 	= avr-gcc
DEVICE = atmega328p
CLOCK = 16000000
CFLAGS= -I lib/ -Os -mmcu=$(DEVICE) -DF_CPU=$(CLOCK)
COMPILE= avr-gcc

#this will take the last connected usb serial, from dmesg.
ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|rev|awk '{print $$1}'|rev)
baud   :=-b 57600

#if verbose = -v, compiling will be verbose
verbose = -v

#if a ttyACM is used, change the tty name (else it will be "device").
#this doesnt work correctly if usb naming is broken
ifneq ($(ttyUSB), /dev/ttyUSB0)
	#gsub is needed to remove the last :(ACM is 4)
	ttyUSB :=$(shell echo -n "/dev/"; dmesg | grep tty|grep USB|tail -1|awk '{gsub(/:/,"");print $$4}')
	# no buad for auto detection
	baud =
endif

all: main.hex

main.hex:main.cpp $(ODIR)blink.o $(ODIR)spi.o
	$(COMPILE) $(verbose) $(CFLAGS) -c main.cpp -o $(ODIR)main.o
#linking
	$(COMPILE) $(verbose) $(CFLAGS)-Wl,-Map,main.map -o $(ODIR)main.elf $(ODIR)main.o $(ODIR)blink.o $(ODIR)spi.o
#converting to hex
	avr-objcopy -j .text -j .data -O ihex $(ODIR)main.elf main.hex


#blink 
obj/blink.o:lib/blink.cpp
	$(COMPILE) $(verbose) $(CFLAGS) -c lib/blink.cpp -o $(ODIR)blink.o
	
#SPI 
obj/spi.o:lib/spi.cpp
	$(COMPILE) $(verbose) $(CFLAGS) -c lib/spi.cpp -o $(ODIR)spi.o
	
#obj/spi.o:lib/spi.cpp
#	avr-gcc -Os $(include) -mmcu=atmega328p -c -o obj/spi.o lib/spi.cpp
	
program:main.hex
	avrdude -v -p m328p -c arduino -P $(ttyUSB) $(baud) -D -U flash:w:main.hex:i
	
test:
	echo $(ttyUSB)


# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter gccversion \
build elf hex eep lss sym coff extcoff \
clean clean_list program debug gdb-config

clean:
	rm -f $(ODIR)*.o $(ODIR)*.elf *.hex