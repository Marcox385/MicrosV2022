/* 727272 - Cordero Hernández Marco Ricardo
   Calcular la velocidad de una banda cada 50ms */

		ORG 000H
		SJMP MAIN
		ORG 000BH

ONSET:	CPL P3.5		; Flanco de subida/bajada
		RETI
		
		ORG 0040H

; GATE T1 = 0, C/T T1 = Contador, Modo T1 = 13 bits
; GATE T0 = 0, C/T = Temporizador, Modo T0 = 16 bits
MAIN:	MOV TMOD, #41H
		MOV TH0, #-54
		MOV TL0, #0		; T0 = -5400
		SETB TR0		; Encender T0
		SETB TR1		; Encender T1
		CLR TF0			; Limpiar bandera de desbordamiento
		SJMP WATCH
	
WATCH:	JB TF0, ONSET	; Contar si se desbordó T0
		SJMP WATCH
			
		END