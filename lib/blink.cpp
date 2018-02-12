//#define F_CPU 16000000UL
#define BLINK_DELAY_MS 256
#include "blink.h"
#include <avr/io.h>      //  IO, cant we use arduino libs or even smaller? (we should, UART and pins)
#include <util/delay.h>

void blink()
{
    DDRB |= _BV(DDB5);
    PORTB |= _BV(PORTB5);
    _delay_ms(BLINK_DELAY_MS);
 
    /* set pin 5 low to turn led off */
    PORTB &= ~_BV(PORTB5);
    _delay_ms(BLINK_DELAY_MS);
}
