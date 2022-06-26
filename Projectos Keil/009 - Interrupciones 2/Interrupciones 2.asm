/* 727272 - Cordero Hernández Marco Ricardo
   Calcular la velocidad de una banda cada 50ms */

		ORG 000H
		SJMP MAIN
		
		ORG 000BH
T0ISR:	MOV A, TL1
		MOV P1, A
		MOV TL1, #0
		MOV TH0, #HIGH(-50000)
		MOV TL0, #LOW(-50000)
		SETB TF0
		RETI
		
		ORG 0040H
MAIN:	MOV TMOD, #51H
		; GATE T1 = 0, C/T T1 = Contador, Modo T1 = 16 bits
		; GATE T0 = 0, C/T = Temporizador, Modo T0 = 16 bits
		
		SETB TR0				; Encender T0
		SETB TR1				; Encender T1
		MOV IE, #82H			; EA, T0
		SETB TF0				; Interrupción de T0
LOOP:	JNB TF0, LOOP			; Pooling
		SJMP $
	
		END