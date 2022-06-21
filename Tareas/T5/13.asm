; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 13)	Hacer un programa para que encuentre el elemento más pequeño de una lista de números de 16 bits sin signo
        que están en localidades consecutivas de memoria. La dirección del primer elemento de la lista se encuentra
        en las localidades 1900H y 1901H, el número de elementos del arreglo está en la localidad 1902H. El elemento
        más pequeño encontrado debe guardarse en la localidad 1903H. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:	MOV DPTR, #1900H
		MOVX A, @DPTR
		MOV R0, A			; Parte alta de apuntador
		INC DPTR
		MOVX A, @DPTR
		MOV R1, A			; Parte baja de apuntador
		INC DPTR
		MOVX A, @DPTR		; Longitud de lista
		MOV R2, A
		
		MOV DPH, R0
		MOV DPL, R1
		
		MOVX A, @DPTR		; Almacena el primer dato en la lista
		
		SJMP SOLVE

SOLVE:	MOV B, A			; Almacena número anterior
		CLR C
		INC DPTR
		MOVX A, @DPTR
		SUBB A, B
		JB 0D7H, REPLACE	; Si la bandera de carry se prende, se encontró un nuevo mínimo
CONTINUE: DJNZ R2, SOLVE
		SJMP $

REPLACE: PUSH DPL			; Almacenar dirección de apuntador
		PUSH DPH
		MOVX A, @DPTR
		MOV DPTR, #1903H
		MOVX @DPTR, A		; Sustituir valor almacenado
		POP DPH				; Recuperar dirección de apuntador
		POP DPL
		SJMP CONTINUE

		END