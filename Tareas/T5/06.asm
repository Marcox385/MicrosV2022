/* 6)	Hacer un programa para que en el acumulador aparezca la siguiente secuencia: 10H-11H-22H-33H-44H-55H-66H-33H-11H-10H
        y luego se repita el proceso. Se puede utilizar cualquier conjunto de instrucciones, pero NINGUNA repetida- */
		
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

		END