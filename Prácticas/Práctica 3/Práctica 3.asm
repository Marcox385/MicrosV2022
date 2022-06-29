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
	
	Nota: se ha asegurado el funcionamiento con matrices de hsata 6x6
*/

			INICIO_DIM EQU 1000H
			INICIO_A   EQU 2000H
			INICIO_B   EQU 3000H
			INICIO_RES EQU 5000H
				
			A_ROW	   EQU 20H
			A_COL	   EQU 21H
			B_ROW	   EQU 22H
			B_COL	   EQU 23H
			RES_POS    EQU 24H
				
			A_DIR	   EQU 0E0H
			B_DIR	   EQU 0F0H

			ORG 0000H
			SJMP MAIN
			ORG 0040H

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

CALCUL0:	MOV A_ROW, #0
			MOV A_COL, #0
			MOV B_ROW, #0
			MOV B_COL, #0
			MOV RES_POS, #0

L1:			MOV B_COL, #0			; Resetear columnas de B
L2:			MOV A_COL, #0			; Resetear columnas de A
L3:			ACALL DESP_A_R			; Desplazamiento de filas para A
			ACALL DESP_A_C			; Desplazamiento de columnas para A
			MOVX A, @DPTR
			PUSH A_DIR				; Guardar A[A_ROW][A_COL]
			
			ACALL DESP_B_C			; Desplazamiento de columnas para B
			ACALL DESP_B_R			; Desplazamiento de filas para B
			MOVX A, @DPTR
			MOV B, A				; Guardar B[B_ROW][B_COL]
			POP A_DIR
			MUL AB
			
			ACALL DESP_RES			; Almacenar resultado en matriz resultante (Valor anterior + nuevo valor calculado)
			
			INC A_COL				; A[A_ROW][A_COL + 1]
			INC B_ROW				; B[B_ROW + 1][B_COL]
			MOV A, R3
			CJNE A, A_COL, L3		; Verificar si no se ha llegado al fin de columnas actuales de A para fila correspondiente
			MOV B_ROW, #0			; Resetear a B[0][0]
			
			INC RES_POS				; Pasar a siguiente posición en matriz resultante
			INC B_COL				; B[B_ROW][B_COL + 1]
			MOV A, R5
			CJNE A, B_COL, L2		; Verificar si no se ha llegado al fin de columnas totales de B
			
			INC A_ROW				; A[A_ROW + 1][A_COL]
			MOV A, R2
			CJNE A, A_ROW, L1		; Verificar si no se ha llegado al fin de filas totales de A
			
FIN:		SJMP $
	
	
; ---------------------------- DESPLAZAMIENTO PARA FILAS DE A ----------------------------

DESP_A_R:	MOV DPTR, #INICIO_A
			MOV A, A_ROW
			MOV B, R3
			MUL AB
			JZ DAR_RET
DAR_LI:		INC DPTR				; Incrementar hasta encontrar fila actual de A
			DJNZ A_DIR, DAR_LI
DAR_RET:	RET			

; --------------------------- DESPLAZAMIENTO PARA COLUMNAS DE A ---------------------------

DESP_A_C:	MOV A, A_COL
			JZ DAC_RET
DAC_LI:		INC DPTR				; Incrementar hasta encontrar columna actual de A
			DJNZ A_DIR, DAC_LI
DAC_RET:	RET

; ---------------------------- DESPLAZAMIENTO PARA FILAS DE B ----------------------------

DESP_B_R: 	MOV A, B_ROW
			JZ DBR_RET
DBR_LI1:	MOV B, R5
DBR_LI2:	INC DPTR				; Incrementar hasta encontrar fila actual de B
			DJNZ B_DIR, DBR_LI2
			DJNZ A_DIR, DBR_LI1
DBR_RET:	RET

; --------------------------- DESPLAZAMIENTO PARA COLUMNAS DE B ---------------------------

DESP_B_C: 	MOV DPTR, #INICIO_B	
			MOV A, B_COL
			JZ DBC_RET
DBC_LI:		INC DPTR				; Incrementar hasta encontrar columna actual de B
			DJNZ A_DIR, DBC_LI
DBC_RET:	RET

; -------------------------- ANEXO DE SUMA EN MATRIZ RESULTANTE --------------------------

DESP_RES:	MOV DPTR, #INICIO_RES
			PUSH A_DIR				; Guardar multiplicación
			MOV A, RES_POS
			JZ DESP_RET
DESP_LI:	INC DPTR				; Incrementar hasta encontrar posición actual de resultante
			DJNZ A_DIR, DESP_LI
DESP_RET:	MOVX A, @DPTR
			MOV B, A				; Guardar valor actual en resultante
			POP A_DIR
			ADD A, B				; Multiplicación + valor actual
			MOVX @DPTR, A
			RET
; ---------------------------------------------------------------------------------------

			END
			