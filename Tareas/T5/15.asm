; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 15)	Hacer un programa para contar el número de bits con valor 1 que hay en un bloque de memoria cuya dirección inicial
        se encuentra almacenada en las localidades 1A00H y 1A01H y cuya dirección final está almacenada en las localidades
        1A02H y 1A03H. El número total de unos debe guardarse en las localidades 1A04H y la 1A05H. Se sugiere utilizar un
        lazo para contar los unos dentro de cada localidad del bloque, anidado en otro lazo que se encargue de acumular los
        unos resultantes de todas las localidades. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV DPTR, #1A00H
		MOV B, #4H
		MOV R0, #1H
READ:	MOVX A, @DPTR		; Ciclo de lectura de datos (1A00-1A03)
		MOV @R0, A
		INC DPTR
		INC R0
		DJNZ B, READ
				
		MOV DPH, R1			; Verificar DPH final
		MOV A, R2
		DEC A
		XCH A, R2
		MOV DPL, R2			; Verificar DPL final
		
		SJMP CICLO1
		
		
CICLO1:	INC DPTR
		MOVX A, @DPTR
		MOV B, #8D
		
CICLO2: JB ACC.0, AUMENTAR	; Verificar si existe un uno en la primera posición del acumulador
INCL2:	RR A
		DJNZ B, CICLO2
		
		MOV A, R3			; Checar DPH final
		CJNE A, DPH, CICLO1
		MOV A, R4			; Checar DPL final
		CJNE A, DPL, CICLO1
		SJMP $


AUMENTAR: PUSH DPL			; Guardar dirección de apuntador
		PUSH DPH
		PUSH 0E0H
		MOV DPTR, #1A05H
		MOVX A, @DPTR
		INC A
		JB 0D2H, AUMENTARH	; Si se lleno LB de contador (overflow), aumentar HB
		MOVX @DPTR, A
PISICHILLI:	POP 0E0H		; Recuperar dirección de apuntador
		POP DPH
		POP DPL
		SJMP INCL2

AUMENTARH:	MOV DPTR, #1A04H
		MOVX A, @DPTR
		INC A
		CLR 02DH
		MOVX @DPTR, A
		SJMP PISICHILLI

		END