/*	
	727576 - 		   Guzmán Claustro Edgar
	727272 - Cordero Hernández Marco Ricardo
	727366 - Rodríguez Castro Carlos Eduardo
	
	--------------------------- PRÁCTICA 4 ---------------------------
	
	Requerimientos:
	- Desplegar en display los caracteres presionados en un teclado
	  matricial (rebotes filtrados mediante MM74C922).
	- Al llegar al final de la primera línea, continuar en la inferior.
	- Al llenar todas las posiciones, borrar todo y regresar a la
	  primera posición de la primera línea.
	- Input de teclado detectado por interrupciones.
	- Función ALT para interpretar dos inputs de teclado como ASCII. 
	  Después de pulso en botón, leer dos caracteres y desplegarlos.	
	- Función SEND para enviar la información desplegada en pantalla
	  mediante bluetooth a través de comunicación serial. También debe
	  ser detectado por interrupción. Considerar debouncing.
	
	------------------------------------------------------------------
*/
			
			RS 	   EQU P1.4				; Resister Select de LCD
			E  	   EQU P1.5				; Enable de LCD
			LCD    EQU P2				; Bus para LCD
			KEYS   EQU P1				; Tecla codificada
			ALT    EQU P1.7				; Botón ALT
			ALT_EN EQU 0D5H				; ALT activado
			KYSC   EQU 0D1H				; Contador de teclas ingresadas para ALT
			CHARR  EQU 030H				; Inicio de arreglo para caracteres a enviar
				
			CHR_P  EQU R0				; Posición de delimitador de arreglo
			CH_P_B EQU R1				; Posición de arreglo para bluetooth
			CCNT   EQU R2				; Contador de caracteres para display (max. 32 | 20H)
			KYSB   EQU R3				; Almacenamiento de teclas presionadas para ALT


			ORG 0000H					
			JMP LCD_INIT

; ------------------ INTERRUPCIÓN TECLADO ------------------
			ORG 0003H
			JMP KEY_IN
; ----------------------------------------------------------


; ------------------- INTERRUPCIÓN ALT ---------------------
			ORG 000BH	
			JMP ALT_IN
; ----------------------------------------------------------


; ----------------- INTERRUPCIÓN BLUETOOTH -----------------
			ORG 0013H		
			JMP SEND_ND
; ----------------------------------------------------------


; -------------------- FLUJO PRINCIPAL ---------------------
			ORG 0040H
/* --------------------- SUBRUTINAS --------------------- */
; Para interrupción externa 0 | Detección de tecla o ASCII
KEY_IN:		MOV A, KEYS
			JNB ALT_EN, KEY_SGL
			
			JB KYSC, ALT_1				; Primer caracter
			SUBB A, #'1'				; Comprobaciones para
			JZ KEY_END					; saltar caracteres
			ADD A, #'1'					; inválidos según
			SUBB A, #'8'				; datasheets (1X, 8X, 9X)
			JZ KEY_END
			ADD A, #'8'
			SUBB A, #'9'
			JZ KEY_END
			ADD A, #'9'
			
			SWAP A
			ANL A, #0F0H
			MOV KYSB, A
			SETB KYSC
			SJMP KEY_END
			
ALT_1:		ANL A, #0FH					; Segundo caracter
			ADD A, KYSB					
			CLR KYSC
			SJMP KEY_SHW				; Enviar ASCII
			CLR ALT_EN

			
KEY_SGL:	ANL A, #0FH
			MOVC A, @A + DPTR			; Decodificar caracter
KEY_SHW:	ACALL LCD_CHR				; Enviar caracter a LCD
KEY_END:	RETI


; Para interrupción externa 1 | Envío a bluetooth
SEND_ND:	MOV CHR_P, #0
			MOV TH1, #0FDH
			MOV TL0, #0FDH				; Estándar de 9600 baudios
			SETB TR1

SN_L0:		JNB TI, SN_L0
			CLR TI
			MOV A, #CHARR
			ADD A, CHR_P
			MOV CH_P_B, A
			MOV SBUF, @CH_P_B
			INC CHR_P
			INC CH_P_B
			
			CJNE CH_P_B, #10H, SN_L0
			CLR TR0
			RETI


; Para detección de ALT
ALT_IN:		JNB ALT, ALT_END
			SETB ALT_EN
ALT_END:	RETI


; Subrutina de atraso para dejar libres temporizadores
DELAY: 		MOV R7, #30H
D_0: 		MOV R6, #0FFH
D_1: 		DJNZ R6, D_1
			DJNZ R7, D_0
			RET

LCD_CLR:	MOV A, #1H					; 20H a cada posición | Limpiar pantalla
			ACALL LCD_CMD
			
LCD_FL:		MOV A, #80H					; Cursor en primera línea, primera posición
			ACALL LCD_CMD


; Subrutina para enviar comandos a LCD
LCD_CMD: 	MOV LCD, A					; Posicionar comando
			CLR RS 						; Modo comando
			SETB E
			ACALL DELAY
			CLR E 						; Enviar comando
			ACALL DELAY
			RET


; Subrutina para enviar datos/caracteres a LCD
LCD_CHR: 	PUSH 0E0H					; Guardar dato a desplegar

LCD_ESL:	CJNE CCNT, #20H, LCD_EFL	; Fin de segunda línea
			ACALL LCD_CLR				; Limpiar pantalla
			ACALL LCD_FL				; y resetear a primera posición
			MOV CCNT, #0				; Resetear conteo de caracteres
			
LCD_EFL:	CJNE CCNT, #10H, LCD_SND	; Fin de primera línea
			MOV A, #0C0H				; Cursor en segunda línea, primera posición
			ACALL LCD_CMD
			
LCD_SND:	POP 0E0H					; Recuperar dato a desplegar
			MOV LCD, A 					; Posicionar datos
			SETB RS 					; Modo datos
			SETB E
			ACALL DELAY
			CLR E						; Enviar datos
			ACALL DELAY
			ACALL ARR_SAVE
			RET


; Subrutina para almacenar o resetear arreglo de caracteres
; Delimitador de arreglo: 10H (por omisión en datasheet)
; Inicio de arreglo: 30H
ARR_SAVE:	MOV A, #CHARR
			ADD A, CCNT
			MOV CHR_P, A
			MOV @CHR_P, LCD
			INC CCNT
			INC CHR_P
			MOV @CHR_P, #10H
			RET

/* ------------------------------------------------------ */

LCD_INIT:	ACALL DELAY
			ACALL DELAY
			
			MOV B, #4H
			MOV A, #38H					; Modo de 8 bits, 2 líneas (4 veces)
LI_0:		ACALL LCD_CMD
			ACALL DELAY
			DJNZ B, LI_0
			
			MOV A, #0FH 				; Display, cursor y parpadeo encendidos
			ACALL LCD_CMD
			
			; Se incluye el siguiente comando por aseguramiento pero es omisible
			; Incrementar posición, desplazamiento desactivado
			MOV A, #6H
			ACALL LCD_CMD
			
			ACALL LCD_CLR				; Limpiar LCD
			ACALL LCD_FL				; Cursor inicial


MAIN:		MOV DPTR, #0A8H * 0AH		; Posicionar apuntador en tabla de valores
			CLR P1.7					; Limpiar para detección de ALT
			
			MOV SCON, #42H				; Habilitación de comunicación serial
			
			; MOV IE, #97H				; Interrupciones para serial, externas y T0
			MOV IE, #87H
			MOV TMOD, #22H				; T0 modo autorrecarga | T1 modo autorrecarga
			
			MOV TH0, #0
			MOV TL0, #0FBH				; Contar 500 nanosegundos
			
			SETB TR0
			
			SJMP $						; Continuar ejecución
				
; ----------------------------------------------------------



; ------------- TABLAS PARA DECODIFICAR TECLAS -------------

			ORG 0690H
			
			DB 	'1', '2', '3', 'A'
			DB	'4', '5', '6', 'B'
			DB	'7', '8', '9', 'C'
			DB	'E', '0', 'F', 'D'

; ----------------------------------------------------------

			END