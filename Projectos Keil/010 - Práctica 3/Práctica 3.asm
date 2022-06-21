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

; Almacenamiento: R2 = A_Row; R3 = A_Col; R4 = B_Row; R5 = B_Col
MAIN:		MOV R0, #2H
			MOV B, #4H
			MOV DPTR, #INICIO_DIM
CICLO_RD:	MOVX A, @DPTR			; Ciclo de lectura de dimensiones
			MOV @R0, A
			INC DPTR
			INC R0
			DJNZ B, CICLO_RD
			
			SJMP CMP_DIM


CMP_DIM:	MOV A, R3 				; Comprobación de dimensiones (A_Col == B_Row)
			SUBB A, R4				; Resta para comprobar igualdad
			JNZ FIN					; Terminar programa en caso contrario
			MOV A, R2				; Comprobación de orientación (vertical | horizontal)
									; con el fin de trabajar siempre con A = vertical y B = horizontal | cuadradas
			SUBB A, R4				; Resta para comprobar orientación
			JB 0D7H, CALCUL0		; Continuar si las orientaciones son correctas (AxB)
			JZ CALCUL0				; Continuar si son cuadradas (AxB)
			
			SJMP CALCUL1			; Ir a versión BxA


CALCUL0:	MOV DPTR, #INICIO_A
			PUSH 

CALCUL1:	NOP

FIN:		SJMP $

			END
			