; NOTA: Se intuye un cristal de 11.0592MHz (Erróneo)
; NOTA: Este examen fue acreedor a un 64.7 en conjunto de otros entregables, no basarse en él como punto de referencia.

			LUZ EQU P1.7	; Comunicación con conmutador
			DLT EQU 30H		; Desfase para ASCII
			DIG EQU 0D1H	; Bandera para ASCII's
			HUM EQU P2		; Sensor de humedad
			CMP EQU 0D5H	; Bandera para comprobación
			DBL EQU R2		; Doble envío

			ORG 0000H
			JMP MAIN

; ------------ INTERRUPCIÓN PARA LUMINARIA ------------ 
			ORG 000BH
			JMP L_ON_OFF
; -----------------------------------------------------

			ORG 001BH
			RETI

; ------------ INTERRUPCIÓN PARA SERIAL --------------- 
			ORG 0023H
			JMP DATA_SEND
; -----------------------------------------------------

			ORG 0040H

; Subrutina para encender/apagar luminaria
L_ON_OFF:	CLR TR0
			CPL LUZ
			JB LUZ, L_OFF
			MOV TH0, #0FFH
			MOV TL0, #0BBH	; Para 75us
			SJMP L_END
L_OFF:		MOV TH0, #0FFH
			MOV TL0, #08DH	; Para 125us
			SJMP L_END
L_END:		SETB TR0
			RETI

; Subrutina para comunicaciones serial
DATA_SEND:	SETB P1.0
			MOV DBL, #0
			MOV A, HUM
			ACALL ASCII_CONV ; Convertir valor
DI_0:		JNB TI, $
			CLR TI
			
			JB DIG, ASC_2
			MOV A, 41H		; Primer caracter
			SETB DIG
			SJMP ASC_C
			
ASC_2:		MOV A, 42H		; Segundo caracter
			CLR DIG
			SETB CMP
			
ASC_C:		MOV SBUF, A
			JNB CMP, DI_0	; ¿Se transmitieron ambos caracteres?
			CLR CMP
			INC DBL
			CJNE DBL, #2H, DATA_SEND
			
DI_1:		JNB RI, $
			CLR RI
			MOV A, SBUF
			
			JB DIG, ASC_3
			MOV 43H, A			; Primer caracter
			SETB DIG
			SJMP ASC_C_2
			
ASC_3:		MOV 44H, A			; Segundo caracter con complemento
			CLR DIG
			SETB CMP
			
ASC_C_2:	JNB CMP, DI_1
			CLR CMP
			ACALL INV_CA2
			CJNE A, 42H, ERROR		
DS_END:		RETI
ERROR:		CLR P1.0
			SJMP DS_END

; Subrutina para convertir un byte en dos ASCII's
ASCII_CONV:	MOV A, 40H		; Dígito en 8 bits
			MOV B, #0AH		; Decenas
			DIV AB
			ADD A, #DLT		; Desfase para ASCII
			MOV 41H, A
			MOV A, B		; Unidades
			ADD A, #DLT		; Mismo desfase
			MOV 42H, A
			RET

; Subrutina para convertir de complemento a 2
INV_CA2:	CPL A
			INC A
			RET

MAIN:		MOV IE, #8AH
			MOV SCON, #42H
			MOV TMOD, #21H
			
			MOV TH0, #0FFH
			MOV TL0, #08DH	; Para 125us
			SETB TR0		; Temporizador de luminaria
			
			MOV TH1, #0EDH
			MOV TL1, #0EDH	; Para 1500 baudios (aprox. 1516)
			SETB TR1		; Temporizador para serial
			
			SJMP $			; Loop principal
			
			END