; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 6)	Hacer un programa para que en el acumulador aparezca la siguiente secuencia: 10H-11H-22H-33H-44H-55H-66H-33H-11H-10H
        y luego se repita el proceso. Se puede utilizar cualquier conjunto de instrucciones, pero NINGUNA repetida- */
		
		ORG 0000H		; ** No cuenta como repetido **
		SJMP MAIN
		ORG 0040H		; ** No cuenta como repetido **
			
MAIN:	MOV A, #10H		; Carga de valor inicial de secuencia 10H
		ORL 00H, #5H	; Contador de instrucciones
		ACALL FASE1		; Llamada a aumento 
		SJMP FASE2		; Llamada a decremento

FASE1:	INC A			; Incremento a 11H
CICLO:	ADD A, #11H		; Suma de 11H continua hasta agotar R0
		DJNZ R0, CICLO
		RET	

FASE2:	XRL B, #2H		; Carga de denominador en contador B
		DIV AB			; División para 33H
		ANL A, #11H		; Carga de valor final de secuencia 
		LJMP MAIN		; Repetir proceso

		END