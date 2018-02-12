#define uint8_t byte
#include <avr/io.h>

void InitSPI(void)
{
	 // Set MOSI ,MISO, SCK , and SS output
 DDRB = (1<<DDB3)|(1<<DDB4)|(1<<DDB5)|(1<<DDB2);
//SPCR = ( (1<<SPE)|(1<<MSTR) | (1<<SPR1) |(1<<SPR0));	// Enable SPI, Master, set clock rate fck/128  
//SPCR = 0x50; // smaller for us, less clear.
SPCR = (1<<SPE)|(1<<MSTR);
}

void CloseSPI()
{
SPCR = 0x00;                       // clear SPI enable bit
}

byte TransferSPI(byte data)				// you can use uint8_t for byte
{
SPDR = data;                       // initiate transfer
while (!(SPSR & 0x80));    
									// wait for transfer to complete
return SPDR;
}
