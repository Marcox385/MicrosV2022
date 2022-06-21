; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 11)	Hacer un programa para mover el bloque de memoria que comienza en la dirección 1A00H y termina en la dirección 1BFFH
        a la sección de memoria que comienza en la 1C00H. El programa debe terminar cuando se haya transferido todo el bloque
        o cuando se encuentre con valor FFH. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV DPTR, #1A00H                ; Mover dptr al inicio del conteo. 
        MOV R1, #1CH
        MOV R2, #00H
MEIN:	MOVX A, @DPTR                   
        CJNE A, #0FFH, COPY             ; Verifica el acumulador sea igual a la condición FFH. 
        SJMP FIN                        
RTR:	MOV P1, DPH                     
        JNB 92H, MEIN
FIN:	SJMP $                          ; Bucle para no acceder a localidades inválidas

COPY:	PUSH DPL                        ; Agrega la parte baja al stack
        PUSH DPH                        ; Agrega la parte alta al stack     
        MOV DPH, R1                     ; Mueve la parte alta de dptr al registro 1
        MOV DPL, R2                     ; Mueve la parte alta de dptr al registro 2
        MOVX @DPTR, A
        INC DPTR                        ; Incrementa dptr
        MOV R1, DPH
        MOV R2, DPL
        POP DPH                         ; Recupera del estack la parte alta  
        POP DPL                         ; Recupera del estack la parte baja
        INC DPTR
        
        SJMP RTR

        END