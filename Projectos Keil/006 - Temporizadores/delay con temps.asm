		/*ORG	0000H
		SJMP MAIN
		ORG 0040H	; Omitir vectores de interrupción*/

; Ejemplo timer 0 disparado por SW modo 1
/*				 ; TF1 TR1 TF0 TR0 X X X X
MAIN:	MOV TCON, #00000000B	; Inicializar temporizador 0 en modo de 16 bits (modo 1) disparado por SW
				 ; Gate C/T' M1 M0 Gate C/T' M1 M0
		MOV TMOD, #00000001B
		ACALL DELAY
		SJMP $
			
DELAY:	MOV	TL0, #LOW(-5000)
		MOV TH0, #HIGH(-5000)
				 ; TF1 TR1 TF0 TR0 X X X X
		MOV	TCON, #00010000B	; Encender conteo del timer 0
		JNB	TF0, $
		CPL TF0
		RET
		
		END */
		
; Ejemplo timer 1 disparado por HW modo 0
/* MAIN:	MOV TMOD, #80H
		SETB TR1		; Iniciar conteo del temporizador
		SJMP $
		END */
		
; Ejemplo timer 0 en modo autorrecarga disparado por software
/*		ORG 0000H
		MOV TMOD, #00000010B ; Modo autorrecarga
		MOV TH0, #06D
		MOV TL0, #06H
		SETB TR0			 ; Encender conteo
CICLO:	JNB TF0, $
		CPL TF0
		SJMP CICLO
	
		END */
		
		
; Ejemplo de counter con T1 disparador por HW en 16 bits
		ORG 0000H
INICIO:	MOV	TMOD, #11010000B
		SETB TR1
		JNB TF1, $
		CPL TF1
		SJMP INICIO
		
		END