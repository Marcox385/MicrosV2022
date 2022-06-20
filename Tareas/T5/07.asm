/* 7)	Hacer un programa para separar el contenido del R0 en dos grupos de 4 bits.
        Guardar el grupo de los 4 bits más significativos del registro R1 y los  bits menos significativos
        en los 4 bits menos significativos del registro R2. Los 4 bits más significativos de R1 y R2, deben quedar en cero. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R0
		SWAP A
		ANL A, #0FH
		MOV R1, A
		
		MOV A, R0
		ANL A, #0FH
		MOV R2, A
		
		SJMP $
		
		END