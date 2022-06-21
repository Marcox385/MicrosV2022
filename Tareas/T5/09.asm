; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 9)   Hacer un programa para determinar la cantidad de ceros, de números positivos (aquellos cuyo bit más significativo es cero)
        y de números negativos (aquellos cuyo bit más significativo es uno) que hay en un bloque de memoria externa.
        La dirección inicial del bloque está en las localidades 1940H y 1941H, la longitud del bloque está en la localidad 1942H.
        El número de elementos negativos debe colocarse en la localidad 1943H, el número de ceros en la 1944H y el número de elementos
        positivos en la localidad 1945H. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV DPTR, #1940H		; Posicionar apuntador a inicio de datos
		MOVX A, @DPTR
		MOV R0, A				; Guardar 8 MSB en registro 0 (1940)
		INC DPTR
		MOVX A, @DPTR
		MOV R1, A				; Guardar 8 LSB en registro 1 (1941)
		INC DPTR
		MOVX A, @DPTR
		MOV R2, A				; Guardar longitud de datos (1942)
		
		MOV DPH, R0
		MOV DPL, R1

CICLO:	MOV R3, #8H				; Variable para rotaciones de número
		MOVX A, @DPTR
		JB 0E7H, NEGATIVO		; Aumentar negativos (1943)
PASS1:	MOVX A, @DPTR
		JNB 0E7H, POSITIVO		; Aumentar positivos (1945)
PASS2:	MOVX A, @DPTR
		ACALL CEROS				; Contar ceros
		INC DPTR
		DJNZ R2, CICLO			; Repetir hasta que no se haya alcanzado la cantidad de 1942
		SJMP $

NEGATIVO: PUSH DPL				; Guardar dirección de apuntador				
		PUSH DPH
		MOV DPTR, #1943H		; Mover a contador de negativos
		MOVX A, @DPTR
		INC A
		MOVX @DPTR, A
		POP DPH					; Recuperar dirección de apuntador
		POP DPL
		SJMP PASS1

POSITIVO: PUSH DPL				; Guardar dirección de apuntador
		PUSH DPH
		MOV DPTR, #1945H		; Mover a contador de positivos
		MOVX A, @DPTR
		INC A
		MOVX @DPTR, A
		POP DPH					; Recuperar dirección de apuntador
		POP DPL
		SJMP PASS2

CEROS:	PUSH DPL				; Guardar dirección de apuntador
		PUSH DPH
		MOVX A, @DPTR
		MOV DPTR, #1944H
CC0:	JB 0E0H, CC2			; Si el bit menos significativo del contador está activo, rotar
CC1:	MOV R4, A				; Caso contrario, aumentar cantidad de ceros
		MOVX A, @DPTR
		INC A
		MOVX @DPTR, A
		MOV A, R4
CC2:	RR A					; Rotación a la derecha
		DJNZ R3, CC0			; Repetir ocho veces
		POP DPH					; Recuperar dirección de apuntador
		POP DPL
		RET

		END