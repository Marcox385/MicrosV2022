; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 8)	Hacer un programa para combinar los 4 bits menos significativos del registro R2 y los 4 bits menos significativos
        del registro R1 en una sola localidad de 8 bits y guardarla en el registro R0. Los 4 bits menos significativos de R2
        deberán ocupar los 4 bits menos significativos de R0. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R2
		ANL A, #0FH		; Enmascarar para obtener LB
		SWAP A			; Voltear para dejar HB libre
		ANL 01H, #0FH	; Enmascarar para obtener HB
		ORL A, R1		; Cargar HN
		SWAP A			; Revertir orden a resultado final
		MOV R0, A
		SJMP $
			
		END