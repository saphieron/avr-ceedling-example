/*
 * unity_config.h
 *
 *  Created on: Sep 18, 2017
 *      Author: saphieron
 */

#ifndef UNITY_CONFIG_H
#define UNITY_CONFIG_H

#include <stddef.h>
#include "uart_output.h"

#define UNITY_INT_WIDTH 16
#define UNITY_OUTPUT_START() uart_init(F_CPU, BAUD)
#define UNITY_OUTPUT_CHAR(a) uart_putchar(a)
#define UNITY_OUTPUT_COMPLETE() uart_complete()

#endif
