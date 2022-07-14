/*	
	727576 - 		   Guzm�n Claustro Edgar
	727272 - Cordero Hern�ndez Marco Ricardo
	727366 - Rodr�guez Castro Carlos Eduardo
	
	--------------------------- PR�CTICA 4 ---------------------------
	
	Requerimientos:
	- Desplegar en display los caracteres presionados en un teclado
	  matricial (rebotes filtrados mediante MM74C922).
	- Al llegar al final de la primera l�nea, continuar en la inferior.
	- Al llenar todas las posiciones, borrar todo y regresar a la
	  primera posici�n de la primera l�nea.
	- Input de teclado detectado por interrupciones.
	- Funci�n ALT para interpretar dos inputs de teclado como ASCII. 
	  Despu�s de pulso en bot�n, leer dos caracteres y desplegarlos.	
	- Funci�n SEND para enviar la informaci�n desplegada en pantalla
	  mediante bluetooth a trav�s de comunicaci�n serial. Tambi�n debe
	  ser detectado por interrupci�n. Considerar debouncing.
	
	------------------------------------------------------------------
*/
			
			RS 	   EQU P1.4				; Resister Select de LCD
			E  	   EQU P1.5				; Enable de LCD
			LCD    EQU P2				; Bus para LCD
			KEYS   EQU P1				; Tecla codificada
			ALT    EQU P1.7				; Bot�n ALT
			ALT_EN EQU 0D5H				; ALT activado
			KYSC   EQU 0D1H				; Bandera de nibble superior de ASCII (BBBB 0000)
			CHARR  EQU 030H				; Inicio de arreglo para caracteres a enviar
				
			CHR_P  EQU R0				; Apuntador a posici�n de arreglo
			CCNT   EQU R2				; Contador de caracteres para display (max. 32 | 20H)
			KYSB   EQU R3				; Contenedor para ASCII


			ORG 0000H					
			JMP LCD_INIT

; ------------------ INTERRUPCI�N TECLADO ------------------
			ORG 0003H
			JMP KEY_IN
; ----------------------------------------------------------


; ------------------- INTERRUPCI�N ALT ---------------------
			ORG 000BH	
			JMP ALT_IN
; ----------------------------------------------------------


; ----------------- INTERRUPCI�N BLUETOOTH -----------------
			ORG 0013H		
			JMP SEND_ND
; ----------------------------------------------------------


; -------------------- FLUJO PRINCIPAL ---------------------
			ORG 0040H
/* --------------------- SUBRUTINAS --------------------- */
; Para interrupci�n externa 0 | Detecci�n de tecla o ASCII
KEY_IN:		ACALL DEBOUNCER
			ACALL GEN_DEL				; Retraso personalizado +1 retraso
			MOV A, KEYS
			CPL A
			
			JNB ALT_EN, KEY_SGL			; Verificaci�n para ASCII
			SJMP KEY_ALT		
			
KEY_SGL:	ANL A, #0FH
			MOVC A, @A + DPTR			; Decodificar caracter
KEY_SHW:	ACALL LCD_CHR				; Enviar caracter a LCD
KEY_END:	ACALL DEBOUNCER
			RETI

KEY_ALT:	ACALL SND_DT				; Decodificar tecla
			JB KYSC, ALT_1				; Primer caracter
						
ALT_0:		SWAP A						; Posicionar primera mitad del ASCII
			MOV KYSB, A
			SETB KYSC					; Se indica la presencia del nibble inferior
			SJMP KEY_END
			
ALT_1:		ADD A, KYSB					; Posicionar segunda mitad del ASCII
			CLR KYSC					
			CLR ALT_EN					; Resetear banderas para siguiente ASCII
			SJMP KEY_SHW				; Enviar ASCII

SND_DT:		ANL A, #0FH					
			ADD A, #10H					; Desfase para segunda tabla
			MOVC A, @A + DPTR
			RET


; Para interrupci�n externa 1 | Env�o a bluetooth
SEND_ND:	ACALL DEBOUNCER
			
			MOV CHR_P, #CHARR			; Inicio de arreglo
			MOV A, CCNT					; Cantidad de caracteres disponibles
			JZ ALT_END					; Cancelar si no hay caracteres
SN_L0:		MOV SBUF, @CHR_P
			INC CHR_P					; Siguiente caracter
			JNB TI, $
			CLR TI
			DJNZ ACC, SN_L0				; Repetir hasta que se termine arreglo
			ACALL DEBOUNCER
			RETI

; Para detecci�n de ALT
ALT_IN:		JNB ALT, ALT_END
			SETB ALT_EN					; Entrar en modo ALT
ALT_END:	RETI


; Atraso gen�rico para dejar libres temporizadores
GEN_DEL: 	MOV R7, #30H
G_0: 		MOV R6, #0FFH
G_1: 		DJNZ R6, G_1
			DJNZ R7, G_0
			RET


; M�ltiples retrasos para botones
DEBOUNCER:	ACALL GEN_DEL
			ACALL GEN_DEL
			ACALL GEN_DEL
			RET


; Limpiar LCD
LCD_CLR:	MOV A, #1H					; 20H a cada posici�n | Limpiar pantalla
			ACALL LCD_CMD


; Posicionar en primera l�nea, primera posici�n de LCD
LCD_FL:		MOV A, #80H					; Cursor en primera l�nea, primera posici�n
			ACALL LCD_CMD


; Enviar comandos a LCD
LCD_CMD: 	MOV LCD, A					; Posicionar comando
			CLR RS 						; Modo comando
			SETB E
			ACALL GEN_DEL
			CLR E 						; Enviar comando
			ACALL GEN_DEL
			RET


; Enviar datos/caracteres a LCD
LCD_CHR: 	PUSH ACC					; Guardar dato a desplegar

LCD_ESL:	CJNE CCNT, #20H, LCD_EFL	; Fin de segunda l�nea
			ACALL LCD_CLR				; Limpiar pantalla
			ACALL LCD_FL				; y resetear a primera posici�n
			MOV CCNT, #0				; Resetear conteo de caracteres
			
LCD_EFL:	CJNE CCNT, #10H, LCD_SND	; Fin de primera l�nea
			MOV A, #0C0H				; Cursor en segunda l�nea, primera posici�n
			ACALL LCD_CMD
			
LCD_SND:	POP ACC						; Recuperar dato a desplegar
			MOV LCD, A 					; Posicionar datos
			SETB RS 					; Modo datos
			SETB E
			ACALL GEN_DEL
			CLR E						; Enviar datos
			ACALL GEN_DEL
			ACALL ARR_SAVE				; Guardar caracter introducido en arreglo
			RET


; Almacenar en arreglo de caracteres
; Inicio de arreglo: 30H
ARR_SAVE:	MOV A, #CHARR				; Inicio de arreglo
			ADD A, CCNT					; Desplazamiento seg�n caracteres actuales
			MOV CHR_P, A				; Posici�n actual de arreglo
			MOV @CHR_P, LCD				; Guardar elemento en posici�n actual
			INC CCNT					; Aumentar cantidad de elementos almacenados actuales
			RET

/* ------------------------------------------------------ */

LCD_INIT:	ACALL DEBOUNCER				; Asegurar espera inicial
			
			MOV B, #4H
			MOV A, #38H					; Modo de 8 bits, 2 l�neas (4 veces)
LI_0:		ACALL LCD_CMD
			ACALL GEN_DEL
			DJNZ B, LI_0
			
			ACALL LCD_CLR				; Limpiar LCD
			
			; Se incluye el siguiente comando por recomendaci�n pero es omisible
			; Incrementar posici�n, desplazamiento desactivado
			MOV A, #6H
			ACALL LCD_CMD
			
			MOV A, #0FH 				; Display, cursor y parpadeo encendidos
			ACALL LCD_CMD
			
			ACALL LCD_FL				; Cursor inicial

			MOV CCNT, #0				; Resetear contador de caracteres en matriz

MAIN:		MOV DPTR, #0A8H * 0AH		; Posicionar apuntador en tabla de valores
			CLR ALT						; Limpiar para detecci�n de ALT
			
			MOV SCON, #42H				; Habilitaci�n de comunicaci�n serial
			
			MOV IE, #87H				; Interrupciones externas y T0 habilitadas
			MOV TMOD, #22H				; T0 y T1 en modo autorrecarga
			
			MOV TH0, #0
			MOV TL0, #0FBH				; Contar 500 nanosegundos
			SETB TR0
			
			MOV TH1, #0FDH
			MOV TL1, #0FDH				; Est�ndar de 9600 baudios
			SETB TR1
			
			CLR TI
			
			SJMP $						; Loop principal
				
; ----------------------------------------------------------



; -------------- TABLA PARA DECODIFICAR TECLAS -------------

			ORG 0690H
			
			DB 	'1', '2', '3', 'A'
			DB	'4', '5', '6', 'B'
			DB	'7', '8', '9', 'C'
			DB	'E', '0', 'F', 'D'
			
			DB	01H, 02H, 03H, 0AH
			DB	04H, 05H, 06H, 0BH
			DB	07H, 08H, 09H, 0CH
			DB	0EH, 00H, 0FH, 0DH

; ----------------------------------------------------------

			END