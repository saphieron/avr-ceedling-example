/*
 * uart_stdio.c
 *
 *  Created on: Sep 14, 2017
 *      Author: saphieron
 */

#include "uart_output.h"

#include <avr/io.h>

//#define UART_PASTER(TYPE, PORT) TYPE##PORT
//#define UART_EVALUATOR(X,Y) UART_PASTER(X,Y)
//#define UART_CONSTRUCTOR(VAR) UART_EVALUATOR(VAR, UART_PORT)

#define BAUD 9600

#define UART_UBRRn UBRR0
#define UART_UCSRnA UCSR0A
#define UART_UCSRnB UCSR0B
#define UART_UCSRnC UCSR0C
#define UART_TXENn TXEN0
#define UART_RXENn RXEN0
#define UART_TXCIEn TXCIE0
#define UART_RXCIEn RXCIE0
#define UART_UCSZn0 UCSZ00
#define UART_USBSn USBS0
#define UART_RXCn RXC0
#define UART_UDRn UDR0
#define UART_UDREn UDRE0
#define USARTn_TX_vect USART0_TX_vect
#define USARTn_RX_vect USART0_RX_vect

void uart_init(uint32_t f_cpu, uint32_t baud) {
	uint16_t ubrrVal = (f_cpu + 8 * baud) / (16 * baud - 1);
	UART_UBRRn = ubrrVal;
	UART_UCSRnB |= (1 << UART_TXENn);
	UART_UCSRnC |= (3 << UART_UCSZn0) | (1 << UART_USBSn);
}

void uart_putchar(int c) {
	while (!( UART_UCSRnA & (1 << UART_UDREn)))
		;
	UART_UDRn = c;
}

void uart_complete() {
	uart_putchar('S');
	uart_putchar('T');
	uart_putchar('O');
	uart_putchar('P');
	uart_putchar('S');
	uart_putchar('T');
	uart_putchar('O');
	uart_putchar('P');
	uart_putchar('S');
	uart_putchar('T');
	uart_putchar('O');
	uart_putchar('P');
	uart_putchar('\n');
}
