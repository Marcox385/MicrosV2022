;  Cordero Hernández Marco Ricardo 727272
;  Guzmán Claustro Edgar 727576
; 1)	Hacer un programa para cargar los registros con los siguientes valores: A 0FH, R0 12H, R1 34H, R2 56H, R3 78H, R4 09H, R5 ACC.

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, #0FH     ;Cargar valores correspondientes al acumulador y registros.
        MOV R0, #12H
        MOV R1, #34H
        MOV R2, #56H
        MOV R3, #78H
        MOV R4, #09H
        MOV R5, ACC     ; ACC = Acumulador = 0E0H

        SJMP $
		
	END