; 3)	Hacer un programa para que el acumulador pase de 0 a 10 de uno en uno y luego se repita el proceso.

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   CLR A
MEIN:	INC A
		CJNE A, #0AH, MEIN
		SJMP MAIN
		
		END