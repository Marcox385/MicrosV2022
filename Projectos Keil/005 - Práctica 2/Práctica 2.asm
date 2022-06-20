			MOV	DPTR,#8000H			; Dirección en donde inicia la RAM
			CLR	P1.0 				; Señaliza fase de escritura (prende el led)
			MOV A,#0AAh				; Dato a escribir en la RAM
escribe:	MOVX @DPTR,A			; Escribe el dato en la RAM
			INC	DPTR				; Apunta a la siguiente localidad de la RAM
			MOV R6,83h				; Dirección de la parte alta del DPTR
			CJNE R6,#0A0H,escribe	; Compara la parte alta del DPTR con la parte
									; alta de la primera localidad posterior a la última localidad de la RAM. Repite el ciclo,
									; hasta que termine de escribir toda la RAM
			SETB P1.0				; Señaliza terminación de la fase de escritura
			CLR  P1.1 				; Señaliza fase de verificación (prende el led)
			MOV	DPTR, #8000H		; Dirección en donde inicia la RAM
verifica:	MOVX A,@DPTR			; Lee el dato
			CJNE A,#0AAh,error		; Compáralo con el dato original
									; y si no es igual, es que hay un error
			INC	DPTR				; Apunta a la siguiente localidad de la RAM
			MOV	A,#55h				; Cambia el AAh por cualquier otro valor 
			MOV	R6,83h				; Dirección de la parte alta del DPTR
			CJNE R6,#0A0H,verifica ; Compara la parte alta del DPTR con la parte
									; alta de la primera localidad posterior a la última localidad de la RAM. Repite el ciclo,
									; hasta que termine de leer toda la RAM
			SETB P1.1				; Señaliza terminación de la fase de verificación
			CLR	P1.2				; Señaliza fase final
fin:		MOV	R7,#255d			; Inicia ciclo de retardo
			DJNZ R7,$				;
			CPL	P1.2				; Haz que el led de OK parpadeé
			JMP	fin					; Brinca al final del programa
error:		SETB P1.1				; Señaliza terminación de la fase de verificación
			CLR	P1.3				; Señaliza fase de error
ciclo:		MOV	R7,#255d			; Inicia ciclo de retardo
			DJNZ R7,$				;
			CPL	P1.3				; Haz que el led de error parpadeé
			JMP	ciclo				; Permanece indefinidamente en la fase de error
