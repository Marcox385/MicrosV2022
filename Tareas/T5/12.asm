/* 12)	Hacer un programa que multiplique el contenido binario del registro R0 (<20H) por 7 y guarde el resultado
        en el registro R1. Hacer en dos versiones, con y sin utilizar la instrucción de multiplicación. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

/*MAIN:   MOV A, R0
		MOV B, #7D
		MUL AB
		MOV R1, A
		SJMP $ */
		
MAIN:	MOV B, #7D
CICLO:	ADD A, B
		DJNZ R0, CICLO
		MOV R1, A
		SJMP $
			
		END