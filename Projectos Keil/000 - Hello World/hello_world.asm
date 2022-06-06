/*
	Primer programa en ensamblador del 8051
	Verano 2022. Hello World
	Este programa encenderá un LED o DIODO en el puerto 1 bit 0
*/
		
		ORG	0000H 		; Directiva de compilador que indica
						; que el bloque de instrucciones que sigue inicia a partir
						; de la localidad 0000H

		MOV P1, #0FEH 	; # = almohadilla; Asigna FE al puerto 1 bit 0 (1111 1110)
		; Alternativa -> CLR P1.0
		SJMP $			; Brinca a esta misma línea
		END				; Fin de programa