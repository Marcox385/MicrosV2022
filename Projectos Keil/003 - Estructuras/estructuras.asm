/* 	
	Programa que realiza la suma o resta de dos datos DA1 (78H) y DA2 (79H) dependiendo de si es cero (suma)
	o no (resta) la posición de memoria CHE (77H). El resultado se guarda la localidad de memria 7AH
	Objetivo: Estructura de una decisión. 
*/

		CHE 	EQU	77H
		DA1 	EQU 78H
		DA2 	EQU 79H
		RES		EQU	7AH
		
		ORG		0000H
		SJMP	INICIO
		ORG		0040H

INICIO:	MOV		DA1, #09H
		MOV		DA2, #06H	; Carga los datos en memoria
		MOV		A, CHE		; Lee la posición de memoria 77H
		JNZ		SAL1		; Si es igual a cero realiza la suma, si no, salta a efectuar la resta
		
		MOV		A, DA1		; Realiza la suma y guarda resultado
		ADD		A, DA2
		MOV		RES, A
		MOV		A, CHE
		JZ		SAL2		; Salta código de la resta

SAL1:	MOV		A, DA1
		SUBB	A, DA2
		MOV		RES, A		; Realiza laresta y guarda resultado
		
SAL2:	NOP
		END