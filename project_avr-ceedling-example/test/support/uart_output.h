/*
 * uart_putchar.h
 *
 *  Created on: Sep 14, 2017
 *      Author: saphieron
 */

#ifndef UART_OUTPUT_H_
#define UART_OUTPUT_H_

#include <stdint.h>
#include <stdio.h>

void uart_init(uint32_t f_cpu, uint32_t baud);
void uart_putchar(int c);
void uart_complete();

#endif /* UART_OUTPUT_H_ */
