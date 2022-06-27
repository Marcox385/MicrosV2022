/* 
	727576 - 		   Guzmán Claustro Edgar
	727272 - Cordero Hernández Marco Ricardo
	727366 - Rodríguez Castro Carlos Eduardo
	
	-------------------------- Práctica 3 --------------------------
	Implementa un programa que haga la multiplicación de dos matrices.
	Los datos de entrada son:
		1. # de renglones de A -> 1000H de RAM
		2. # de columnas de A -> 1001H de RAM
		3. # de renglones de B -> 1002H de RAM
		4. # de columnas de B -> 1003H de RAM
	
	- A partir de la localidad 2000H de RAM se encuentra la matriz A:
		a_11, a_12, ..., a_1n, a_21, a_22, ..., a_mn.
	- A partir de la localidad 3000H de RAM se encuentra la amtriz B:
		b_11, b_12, ..., b_1n, b_21, b_22, ..., b_mn.
		
	Se espera que la multiplicación de matrices se encuentre a partir de
	la localidad 5000H de RAM.
	Los datos son de 4 bits con signo.
	----------------------------------------------------------------
	
	Mínimo a entregar: capacidad de 6x6 para dimensiones de matrices
*/

			INICIO_DIM EQU 1000H
			INICIO_A   EQU 2000H
			INICIO_B   EQU 3000H
			INICIO_RES EQU 5000H

			ORG 0000H
			SJMP MAIN
			ORG 0040H

FIN:		SJMP $

; Almacenamiento: R2 = A_Row; R3 = A_Col; R4 = B_Row; R5 = B_Col
MAIN:		MOV R0, #2H				; Apuntador a registros
			MOV B, #4H				; Cantidad de variables
			MOV DPTR, #INICIO_DIM
CICLO_RD:	MOVX A, @DPTR			; Ciclo de lectura de dimensiones
			JZ FIN					; Terminar programa si algún dato == 0
			MOV @R0, A
			INC DPTR
			INC R0
			DJNZ B, CICLO_RD

			MOV A, R3 				; Comprobación de dimensiones (A_Col == B_Row)
			SUBB A, R4				; Resta para comprobar igualdad
			JNZ FIN					; Terminar programa en caso contrario

CALCUL0:	MOV A, R2
			MOV B, R5
			MUL AB
			MOV R6, A				; Longitud de matriz resultante (A_Row x B_Col) == Cantidad de ciclo externo
		
			MOV 20H, #0				; Variable para iteraciones de matriz A (selección de filas)
			MOV 21H, #0				; Variable para iteraciones de matriz B (selección de filas)
			MOV 22H, #0				; Variable para iteraciones de matriz de resultado			
			MOV 23H, #0				; Variable para iteraciones de matriz A (selección de columnas)
			MOV 24H, #0				; Variable para iteraciones de matriz B (selección de columnas)
		
L1:			ACALL DESP_A_R			; Ajuste de filas para A
L2:			MOV 24H, #0
L3:			MOV 23H, #0
L4:			ACALL DESP_A_R
			ACALL DESP_A_C			; Ajuste de columnas para A
			MOVX A, @DPTR
			PUSH 0E0H	
			ACALL DESP_B_C			; Ajuste columnas para B
			ACALL DESP_B_R			; Ajuste filas para B
			MOVX A, @DPTR
			MOV B, A
			POP 0E0H
			MUL AB
			ACALL DESP_RES			; Almacenar resultado en matriz resultante
			
			INC 21H
			INC 23H
			MOV A, R3
			CJNE A, 23H, L4
			MOV 21H, #0
			
			INC 22H
			INC 24H
			MOV A, R5
			CJNE A, 24H, L3
			
			INC 20H
			MOV A, R2
			CJNE A, 20H, L2
			
			SJMP FIN

; ---------------------------------------------------------------------------------------
DESP_A_R:	MOV DPTR, #INICIO_A
			PUSH 0E0H
			PUSH 0F0H
			MOV A, 20H
			MOV B, R3
			MUL AB
			JZ DAR_RET
DAR_LI:		INC DPTR
			DJNZ 0E0H, DAR_LI
DAR_RET:	POP 0F0H
			POP 0E0H
			RET			
; ---------------------------------------------------------------------------------------
DESP_A_C:	PUSH 0E0H
			MOV A, 23H
			JZ DAC_RET
DAC_LI:		INC DPTR
			DJNZ 0E0H, DAC_LI
DAC_RET:	POP 0E0H
			RET					
; ---------------------------------------------------------------------------------------			
DESP_B_C: 	MOV DPTR, #INICIO_B	
			PUSH 0E0H
			MOV A, 24H
			JZ DBC_RET
DBC_LI:		INC DPTR
			DJNZ 0E0H, DBC_LI
DBC_RET:	POP 0E0H
			RET
; ---------------------------------------------------------------------------------------
DESP_B_R: 	PUSH 0E0H
			PUSH 0F0H
			MOV A, 21H
			JZ DBR_RET
DBR_LI1:	MOV B, R5
DBR_LI2:	INC DPTR
			DJNZ 0F0H, DBR_LI2
			DJNZ 0E0H, DBR_LI1
DBR_RET:	POP 0F0H
			POP 0E0H
			RET
; ---------------------------------------------------------------------------------------
DESP_RES:	MOV DPTR, #INICIO_RES
			PUSH 0F0H
			PUSH 0E0H
			MOV A, 22H
			JZ DESP_RET
DESP_LI:	INC DPTR
			DJNZ 0E0H, DESP_LI
DESP_RET:	MOVX A, @DPTR
			MOV B, A
			POP 0E0H
			ADD A, B
			MOVX @DPTR, A
			POP 0F0H
			RET
; ---------------------------------------------------------------------------------------

			END
			