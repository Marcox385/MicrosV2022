; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 10)	Hacer un programa que calcule la suma de los N primeros números pares. El rango N es de 1 a 15.
        El número N se encuentra en el registro R0. El resultado debe guardarse en R1. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R0
		JNB 0E0H, SUMA	; Verificar si un número es par a través de su primer bit (LSB) [1 == impar]
						; En caso de serlo, llamar la secuencia de suma a R1
COND:	DJNZ R0, MAIN
		SJMP $

SUMA:	ADD A, R1
		MOV R1, A
		SJMP COND
			
		END