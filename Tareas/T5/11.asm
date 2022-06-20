/* 11)	Hacer un programa para mover el bloque de memoria que comienza en la dirección 1A00H y termina en la dirección 1BFFH
        a la sección de memoria que comienza en la 1C00H. El programa debe terminar cuando se haya transferido todo el bloque
        o cuando se encuentre con valor FFH. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV DPTR, #1A00H
        MOV R1, #1CH
        MOV R2, #00H
MEIN:	MOVX A, @DPTR
        CJNE A, #0FFH, COPY
        SJMP FIN
RTR:	MOV P1, DPH
        JNB 92H, MEIN
FIN:	SJMP $

COPY:	PUSH DPL
        PUSH DPH
        MOV DPH, R1
        MOV DPL, R2
        MOVX @DPTR, A
        INC DPTR
        MOV R1, DPH
        MOV R2, DPL
        POP DPH
        POP DPL
        INC DPTR
        
        SJMP RTR

        END