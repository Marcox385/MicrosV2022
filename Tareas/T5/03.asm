; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
; 3)	Hacer un programa para que el acumulador pase de 0 a 10 de uno en uno y luego se repita el proceso.

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   CLR A           ;Limpiar acumulador
MEIN:	INC A           
	CJNE A, #0AH, MEIN      ;Verificar que acumulador sea igual a 10D, si no repite acción.
	SJMP MAIN
        END