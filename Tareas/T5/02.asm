; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 2)	Hacer un programa para que el acumulador cuente del 25H al 31H, de uno en uno,
    se decremente de la misma forma hasta llegar al valor inicial. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, #25H
LOOP:	JBC PSW.1, DECR		; Verifica si la bandera en D1 está activa
		SJMP INCR
		
INCR:	INC A
		CJNE A, #31H, INCR	; Compara si ya se alcanzó el límite superior para incremento
		SETB PSW.1			; Habilita bandera de propósito general
		SJMP LOOP
		
		
DECR:	DEC A
		CJNE A, #25H, DECR	; Compara si ya se alcanzó el límite inferior para decremento
		SJMP LOOP
		
        END	