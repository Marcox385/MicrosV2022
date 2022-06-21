; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 14)	Hacer un programa para que ordene una lista de números binarios de 8 bits con signo en orden ascendente (menor a mayor).
        La longitud de la lista está en la localidad de memoria 1B00H y la lista misma comienza en la localidad de memoria 1B01H.
        Los números están en complemento a dos. */

        NUM EQU 20H
	STOPH EQU 21H
	STOPL EQU 22H
        
	ORG 0000H
	SJMP INICIO
	ORG 0040H

INICIO:	MOV DPTR, #1B00H
        MOVX A, @DPTR
        MOV NUM, A ;R0 tiene la longitud de la lista
        MOV STOPH, #1BH
        MOV STOPL, #01H
        MOV A, NUM
        ADDC A, STOPL
        MOV STOPL, A
        DEC STOPL
        MOV A, #00H
        ADDC A, STOPH
        MOV STOPH, A
        INC DPTR ;DPTR = 1B01H

CICLO:	MOVX A, @DPTR 
        MOV R1, A ;R1 = Primer elemento de la lista
        MOV R3, DPH
        MOV R4, DPL
        INC DPTR
        MOVX A, @DPTR 
        MOV R5, DPH
        MOV R6, DPL
        MOV R2, A ;R2 =Contiene el segundo numero 
        MOV A, R1
        SUBB A, R2
        JC OTRA
        MOV A, R1
        MOV DPH, R5
        MOV DPL, R6
        MOVX @DPTR, A
        MOV DPH, R3
        MOV DPL, R4
        MOV A, R2
        MOVX @DPTR, A
        ;XCH A, R2
        ;MOV R1, A

MAYOR:	INC DPTR
        MOV A, DPH
        CJNE A, STOPH, CICLO
        MOV A, DPL
        CJNE A, STOPL, CICLO
        SJMP $

OTRA: 	MOV A, R2
        MOV R1, A
        MOV A, R5
        MOV R3, A
        MOV A, R6
        MOV R4, A
        SJMP CICLO
        
        END