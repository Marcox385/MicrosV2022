		ORG 0000H
		SJMP MAIN

		ORG 0040H
MAIN:	MOV SCON, #42H		; #01000010B
		MOV TMOD, #20H		; #00100000b
		MOV TH1, #0FDH
		MOV TL1, #(-3)
		SETB TR1
		MOV A, #21
		
ESPERA:	JNB TI, ESPERA
		CLR TI
		MOV SBUF, A
		INC A
		SJMP ESPERA
		
		END