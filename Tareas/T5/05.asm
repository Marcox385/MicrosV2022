/* 5)	Hacer un programa que sume 10 datos que están en la RAM interna a partir de la dirección 30H
        y guarde el resultado en la dirección 40H. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:	MOV R0, #30H
EXEC:   ADD A, @R0
		INC R0
		CJNE R0, #3AH, EXEC
		MOV 40H, A
		SJMP $
			
		END