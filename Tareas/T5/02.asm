/* 2)	Hacer un programa para que el acumulador cuente del 25H al 31H, de uno en uno,
    se decremente de la misma forma hasta llegar al valor inicial. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, #25H
LOOP:	JBC PSW.1, DECR
		SJMP INCR
		
INCR:	INC A
		CJNE A, #31H, INCR
		SETB PSW.1
		SJMP LOOP
		
		
DECR:	DEC A
		CJNE A, #25H, DECR
		SJMP LOOP
		
        END	