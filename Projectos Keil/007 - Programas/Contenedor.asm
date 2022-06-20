/*
	Tarea práctica de programación en ensamblador

	IS727272 - Cordero Hernández, Marco Ricardo
	SI727576 - Guzmán Claustro, Edgar
	IS727366 - Rodríguez Castro, Carlos Eduardo
*/



; 1)	Hacer un programa para cargar los registros con los siguientes valores: A 0FH, R0 12H, R1 34H, R2 56H, R3 78H, R4 09H, R5 ACC.
/*
        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, #0FH
        MOV R0, #12H
        MOV R1, #34H
        MOV R2, #56H
        MOV R3, #78H
        MOV R4, #09H
        MOV R5, ACC		; ACC = Acumulador = 0E0H

        SJMP $
		
		END */
	
	
	
/* 2)	Hacer un programa para que el acumulador cuente del 25H al 31H, de uno en uno,
    se decremente de la misma forma hasta llegar al valor inicial. 

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
		
        END	*/
		
		
		
; 3)	Hacer un programa para que el acumulador pase de 0 a 10 de uno en uno y luego se repita el proceso.
/*
        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   CLR A
MEIN:	INC A
		CJNE A, #0AH, MEIN
		SJMP MAIN
		
		END */
		
		
		
; 4)	Hacer un programa para sumar el contenido de R4 con el contenido de R6 y colocar el resultado en R2.
/*
        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN: 	ADD A, R4
		ADD A, R6
		MOV R2, A
		SJMP $
		
		END */
		


/* 5)	Hacer un programa que sume 10 datos que están en la RAM interna a partir de la dirección 30H
        y guarde el resultado en la dirección 40H.

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:	MOV R0, #30H
EXEC:   ADD A, @R0
		INC R0
		CJNE R0, #3AH, EXEC
		MOV 40H, A
		SJMP $
			
		END */
		
		
		
/* 6)	Hacer un programa para que en el acumulador aparezca la siguiente secuencia: 10H-11H-22H-33H-44H-55H-66H-33H-11H-10H
        y luego se repita el proceso. Se puede utilizar cualquier conjunto de instrucciones, pero NINGUNA repetida- 
		
		ORG 0000H		; ** No cuenta como repetido **
		SJMP MAIN
		ORG 0040H		; ** No cuenta como repetido **
			
MAIN:	MOV A, #10H
		ORL 00H, #5H
		ACALL FASE1
		SJMP FASE2

FASE1:	INC A
CICLO:	ADD A, #11H
		DJNZ R0, CICLO
		RET	

FASE2:	XRL B, #2H
		DIV AB
		ANL A, #11H
		LJMP MAIN

		END */
		
		
		
/* 7)	Hacer un programa para separar el contenido del R0 en dos grupos de 4 bits.
        Guardar el grupo de los 4 bits más significativos del registro R1 y los  bits menos significativos
        en los 4 bits menos significativos del registro R2. Los 4 bits más significativos de R1 y R2, deben quedar en cero. 

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R0
		SWAP A
		ANL A, #0FH
		MOV R1, A
		
		MOV A, R0
		ANL A, #0FH
		MOV R2, A
		
		SJMP $
		
		END */
		
		
		
/* 8)	Hacer un programa para combinar los 4 bits menos significativos del registro R2 y los 4 bits menos significativos
        del registro R1 en una sola localidad de 8 bits y guardarla en el registro R0. Los 4 bits menos significativos de R2
        deberán ocupar los 4 bits menos significativos de R0. 

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R2
		ANL A, #0FH
		SWAP A
		ANL 01H, #0FH
		ORL A, R1
		SWAP A
		MOV R0, A
		SJMP $
			
		END */
		
		
		
/* 9)   Hacer un programa para determinar la cantidad de ceros, de números positivos (aquellos cuyo bit más significativo es cero)
        y de números negativos (aquellos cuyo bit más significativo es uno) que hay en un bloque de memoria externa.
        La dirección inicial del bloque está en las localidades 1940H y 1941H, la longitud del bloque está en la localidad 1942H.
        El número de elementos negativos debe colocarse en la localidad 1943H, el número de ceros en la 1944H y el número de elementos
        positivos en la localidad 1945H. 

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
		DJNZ R2, CICLO			; Repetir hasta que no se hayan alcanzado la cantidad de 1942
		SJMP $

NEGATIVO: PUSH DPL
		PUSH DPH
		MOV DPTR, #1943H
		MOVX A, @DPTR
		INC A
		MOVX @DPTR, A
		POP DPH
		POP DPL
		SJMP PASS1

POSITIVO: PUSH DPL
		PUSH DPH
		MOV DPTR, #1945H
		MOVX A, @DPTR
		INC A
		MOVX @DPTR, A
		POP DPH
		POP DPL
		SJMP PASS2

CEROS:	PUSH DPL
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
		POP DPH
		POP DPL
		RET

		END */
		
		
		
/* 10)	Hacer un programa que calcule la suma de los N primeros números pares. El rango N es de 1 a 15.
        El número N se encuentra en el registro R0. El resultado debe guardarse en R1.

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN:   MOV A, R0
		JNB 0E0H, SUMA
COND:	DJNZ R0, MAIN
		SJMP $

SUMA:	ADD A, R1
		MOV R1, A
		SJMP COND
			
		END */
		
		
		
/* 11)	Hacer un programa para mover el bloque de memoria que comienza en la dirección 1A00H y termina en la dirección 1BFFH
        a la sección de memoria que comienza en la 1C00H. El programa debe terminar cuando se haya transferido todo el bloque
        o cuando se encuentre con valor FFH. 

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

		END */
		
		
		
/* 12)	Hacer un programa que multiplique el contenido binario del registro R0 (<20H) por 7 y guarde el resultado
        en el registro R1. Hacer en dos versiones, con y sin utilizar la instrucción de multiplicación. 

        ORG 0000H
        SJMP MAIN
        ORG 0040H

/*MAIN:   MOV A, R0
		MOV B, #7D
		MUL AB
		MOV R1, A
		SJMP $ 
		
MAIN:	MOV B, #7D
CICLO:	ADD A, B
		DJNZ R0, CICLO
		MOV R1, A
		SJMP $
			
		END */
		
		
		
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
		
		SJMP $

SOLVE:	CLR C
		MOVX A, @DPTR
		DJNZ R2, SOLVE

		END
		