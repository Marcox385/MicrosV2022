/* 8)	Hacer un programa para combinar los 4 bits menos significativos del registro R2 y los 4 bits menos significativos
        del registro R1 en una sola localidad de 8 bits y guardarla en el registro R0. Los 4 bits menos significativos de R2
        deberán ocupar los 4 bits menos significativos de R0. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R2
		ANL A, #0FH
		SWAP A
		ANL 01H, #0FH
		ORL A, R1
		SWAP A
		MOV R0, A
		SJMP $
			
		END