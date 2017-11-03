#define F_CPU 16000000UL
#define USART_BAUDRATE 9600
#define BAUD_PRESCALE (((F_CPU/(USART_BAUDRATE*16UL)))-1)

#include <avr/io.h>      //  IO, cant we use arduino libs or even smaller? (we should, UART and pins)
#include "main.h"
#include "blink.h"

bool doLed = true;
/*
 * Main, here we init the io and kernel
 */
int main() {
   /* set pin 5 of PORTB for output (led)*/
 DDRB |= _BV(DDB5);
 
 // Main loop
 while(1) {
 
  
  // here we do serial TODO: rework to become KD
 char recieved_byte;
  
 UCSR0B |= (1<<RXEN0)  | (1<<TXEN0);
 UCSR0C |= (1<<UCSZ00) | (1<<UCSZ01);
 UBRR0H  = (BAUD_PRESCALE >> 8);
 UBRR0L  = BAUD_PRESCALE;
  
    for(;;){ //This should be bad if no serial right?
//TODO: fix KD
  
  // wait until a byte is ready to read
  //TODO: should be switching or all in this loop?
  while( ( UCSR0A & ( 1 << RXC0 ) ) == 0 ){
               /* set pin 5 high to turn led on */


    if(recieved_byte == 0x30)doLed=false;
    if(recieved_byte == 0x31)doLed=true;
    if(doLed)blink();
}
     // grab the byte from the serial port
     recieved_byte = UDR0;
   
  // wait until the port is ready to be written to
  // Again this is bad I gues
  while( ( UCSR0A & ( 1 << UDRE0 ) ) == 0 ){}
 
  // write the byte to the serial port
  UDR0 = recieved_byte;
    }
    return 0;   /* never reached */
    
    
 }
 
}
