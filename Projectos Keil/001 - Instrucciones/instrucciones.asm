; Programa con ejemplo de instrucciones y modos de direccionamiento

			ORG		0000H			; El código se colocará a partir de la localidad 0
			SJMP 	START
			ORG		0040H

START:		INC		A				; Aritmética
			ADD		A, R5			; Aritmética
			ADD		A, #03			; Aritmética
			; NOP		
			MOV		A, P1			; Transferencia de información
			ANL		A, #0FH			; Lógica dato hexadecimal | direccionamiento inmediato
			MOV		A, #01010101B	; Transferencia dato binario
			JNZ		JMP_EX			; Bifurcación de programa o control de flujo del programa
			SJMP	$

JMP_EX:		MOV		A, #00H
			JZ		START			; Bifurcación de programa o control de flujo del programa
			
			
			END