/* Crear un programa que llame a una subrutina
   que realice un delay de exactamente 100ms */

		ORG 0000H
		SJMP MAIN
		ORG 0040H
	
MAIN:	MOV R1, #10D
MAIN_C:	MOV R0, #100D
		ACALL DELAY
		DJNZ R1, MAIN_C
		SJMP $
		
DELAY:	NOP
		DJNZ R0, DELAY
		RET
		
		END