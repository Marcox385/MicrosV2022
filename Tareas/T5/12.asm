; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 12)	Hacer un programa que multiplique el contenido binario del registro R0 (<20H) por 7 y guarde el resultado
        en el registro R1. Hacer en dos versiones, con y sin utilizar la instrucción de multiplicación. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

/*MAIN:   MOV A, R0 	; Agrega el contenido de R0 al acumulador
		MOV B, #7D		; Agrega lo que se va a multiplicar en el registro B
		MUL AB	
		MOV R1, A		; Muestra el resultado en el regsitro 1	
		SJMP $ */
		
MAIN:	MOV B, #7D	
CICLO:	ADD A, B		; Multiplicación por medio de sumas repetidas
		DJNZ R0, CICLO	; Verifica que la suma se haga 7 veces
		MOV R1, A
		SJMP $
			
		END