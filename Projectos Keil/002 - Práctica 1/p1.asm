/*
	727576 - Guzmán Claustro Edgar
	727272 - Cordero Hernández Marco Ricardo
	727366 - Rodríguez Castro Carlos Eduardo
*/
			
			ORG		0000H
			SJMP	RETORNO
			ORG		0040H


RETORNO:	MOV		R4, #00H		; Para conteo de secuencia
INICIO:		MOV		A, P1			; Leer valor de los pines del puerto 1
									; Me interesa saber qué valor tienen los bits 0 y 1 del p1
			ANL		A, #00000011B	; Máscara para obtener bits de P1.0 y P1.1
			JZ		LED_ON
			
			MOV		R7, A			; Guardar contenido del acumulador
			XRL		A, #01H			; Máscara para obtener bit P1.0
			JZ		PARPADEO
			
			MOV 	A, R7			; Recuperar valor anterior del acumulador
			; PUSH	0E0H			; Guardar valor en stack
			SUBB	A, #02H
			JZ		OCHON
			; POP		0E0H		; Recuperar de stack
			
			SJMP	SECUENCIA
			
		
		
/*RETARDO:	MOV		R6, #251
			DJNZ	R6, $
			RET*/

RETARDO:	MOV		R5, #251
CICLO_EXT:	MOV		R6, #251
CICLO:		NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DJNZ	R6, CICLO
			DJNZ	R5, CICLO_EXT
			RET

		
LED_ON:		CLR		P3.7
			SJMP	INICIO
			

PARPADEO:	CPL		P3.6
			ACALL	RETARDO
			SJMP	INICIO

OCHON:		MOV		P2, #00000001B	; Escribe un 8 en display con nomenclatura xabcdefg
			SJMP	INICIO
			

SECUENCIA:	MOV		A, R4			; Cargar la cuenta al acumulador para comparar (ALU)
			JZ		CERO
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a uno
			XRL		A, #01
			JZ		UNO
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a dos
			XRL		A, #02
			JZ		DOS
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a tres
			XRL		A, #03
			JZ		TRES
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a cuatro
			XRL		A, #04
			JZ		CUATRO
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a cinco
			XRL		A, #05
			JZ		CINCO
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a seis
			XRL		A, #06
			JZ		SEIS
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a siete
			XRL		A, #07
			JZ		SIETE
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a ocho
			XRL		A, #08
			JZ		OCHO
			
			MOV		A, R4			; Recuperar valor del acumulador para comparar a nueve
			XRL		A, #09
			JZ		NUEVE
			
			SJMP 	RETORNO
			
			
CERO:		MOV		P2, #10000001B
			SJMP	FIN_SEC
			
UNO:		MOV		A, R4
			MOV		P2, #11110011B
			SJMP	FIN_SEC
			
DOS:		MOV		A, R4
			MOV		P2, #01001001B
			SJMP	FIN_SEC
			
TRES:		MOV		A, R4
			MOV		P2, #01100001B
			SJMP	FIN_SEC

CUATRO:		MOV		A, R4
			MOV		P2, #00110011B
			SJMP	FIN_SEC
			
CINCO:		MOV		A, R4
			MOV		P2, #00100101B
			SJMP	FIN_SEC

SEIS:		MOV		A, R4
			MOV		P2, #00000101B
			SJMP	FIN_SEC
			
SIETE:		MOV		A, R4
			MOV		P2, #01110001B
			SJMP	FIN_SEC

OCHO:		MOV		A, R4
			MOV		P2, #00000001B
			SJMP	FIN_SEC
			
NUEVE:		MOV		A, R4
			MOV		P2, #00100001B
			SJMP	FIN_SEC			
			
FIN_SEC:	ACALL	RETARDO
			INC		R4
			JMP		INICIO
						
			
			END
				
/*
	Números para display (orden inverso)
	
		. a b c d e f g
	0	1 0 0 0 0 0 0 1	 = 	81H
	1	1 1 0 0 1 1 1 1	 = 	CFH
	2	1 0 0 1 0 0 1 0  = 	92H
	3	1 0 0 0 0 1 1 0  = 	86H
	4	1 1 0 0 1 1 0 0  = 	CCH
	5	1 0 1 0 0 1 0 0  = 	A4H
	6	1 0 1 0 0 0 0 0  = 	A0H
	7	1 0 0 0 1 1 1 0  = 	8EH
	8	1 0 0 0 0 0 0 0  = 	80H
	9	1 0 0 0 0 1 0 0  = 	84H
*/