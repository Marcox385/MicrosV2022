; 1) Programa para generar una onda cuadrada de 10KHz
/*
		ORG 0000H
		LJMP MAIN
		ORG 000BH

T0ISR:	CPL P1.7
		RETI

		ORG 0040H

MAIN:	MOV TMOD, #2H
		MOV TH0, #-50D
		MOV TL0, #-50D
		SETB TR0
		MOV IE, #82H
		SJMP $
			
		END */
		

/* 2) Generar una señal en P1.7 que cambie cada 71 microsegundos (empieza en alto)
	  y una señal en P2.7 que cambie cada 2 milisegundos (empieza en bajo) */
	  
		ORG 0000H
		LJMP MAIN
		ORG 000BH
		LJMP T0ISR
		ORG 001BH
		LJMP T1ISR
		ORG 0030H
	
MAIN:	MOV TMOD, #12H
		MOV TH0, #-71D
		SETB TR0
		SETB TF1
		MOV IE, #8AH
		SJMP $
	
T0ISR:	CPL P1.7
		RETI
		
T1ISR:	CLR TR1
		MOV TH1, #HIGH(-2000)
		MOV TL1, #LOW(-2000)
		SETB TR1
		CPL P2.7
		RETI
		
		END