/* 10)	Hacer un programa que calcule la suma de los N primeros números pares. El rango N es de 1 a 15.
        El número N se encuentra en el registro R0. El resultado debe guardarse en R1. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R0
		JNB 0E0H, SUMA
COND:	DJNZ R0, MAIN
		SJMP $

SUMA:	ADD A, R1
		MOV R1, A
		SJMP COND
			
		END