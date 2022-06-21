; Calcular la velocidad de una banda cada 50ms

	ORG 0000H
	SJMP MAIN
		
IN:	INC R0
	CPL P1.0
	
	ORG 0040H
			
MAIN: MOV R0, #0000H
	MOV TMOD, #2H
	MOV TH0, #-50
	SETB TR0
	MOV IE, #82H
	
	SJMP $
		
	END