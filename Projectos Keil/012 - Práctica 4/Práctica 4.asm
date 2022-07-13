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
			CHR_S  EQU R2				; Tamaño de arreglo
			CCNT   EQU R3				; Contador de caracteres para display (max. 32 | 20H)
			KYSB   EQU R4				; Almacenamiento de teclas presionadas para ALT


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
KEY_IN:		ACALL DELAY
			ACALL DELAY
			ACALL DELAY
			ACALL DELAY
			MOV A, KEYS
			CPL A
			
			JNB ALT_EN, KEY_SGL
			SJMP KEY_ALT		
			
KEY_SGL:	ANL A, #0FH
			MOVC A, @A + DPTR			; Decodificar caracter
KEY_SHW:	ACALL LCD_CHR				; Enviar caracter a LCD
KEY_END:	ACALL DELAY
			ACALL DELAY
			ACALL DELAY
			RETI

KEY_ALT:	JB KYSC, ALT_1				;  Primer caracter
						
			ACALL SND_DT				; Posicionar primera mitad del ASCII
			SWAP A
			MOV KYSB, A
			SETB KYSC					; Se indica la presencia del primer nibble
			SJMP KEY_END
			
ALT_1:		ACALL SND_DT				; Posicionar segunda mitad del ASCII
			ADD A, KYSB					
			CLR KYSC					
			CLR ALT_EN					; Resetear banderas para siguiente ASCII
			SJMP KEY_SHW				; Enviar ASCII

SND_DT:		ANL A, #0FH					; Valores de segunda tabla
			ADD A, #10H
			MOVC A, @A + DPTR
			RET


; Para interrupción externa 1 | Envío a bluetooth
SEND_ND:	ACALL DELAY
			ACALL DELAY
			ACALL DELAY
			
			MOV CHR_P, #CHARR
			MOV A, CCNT
			JZ ALT_END
SN_L0:		MOV SBUF, @CHR_P
			INC CHR_P
			JNB TI, $
			CLR TI
			DJNZ ACC, SN_L0
			ACALL DELAY
			ACALL DELAY
			ACALL DELAY
			RETI

; Para detección de ALT
ALT_IN:		JNB ALT, ALT_END
			SETB ALT_EN					; Entrar en modo ALT
ALT_END:	RETI


; Atraso genérico para dejar libres temporizadores
DELAY: 		MOV R7, #30H
D_0: 		MOV R6, #0FFH
D_1: 		DJNZ R6, D_1
			DJNZ R7, D_0
			RET


; Limpiar LCD
LCD_CLR:	MOV A, #1H					; 20H a cada posición | Limpiar pantalla
			ACALL LCD_CMD


; Posicionar en primera línea, primera posición de LCD
LCD_FL:		MOV A, #80H					; Cursor en primera línea, primera posición
			ACALL LCD_CMD


; Enviar comandos a LCD
LCD_CMD: 	MOV LCD, A					; Posicionar comando
			CLR RS 						; Modo comando
			SETB E
			ACALL DELAY
			CLR E 						; Enviar comando
			ACALL DELAY
			RET


; Enviar datos/caracteres a LCD
LCD_CHR: 	PUSH ACC					; Guardar dato a desplegar

LCD_ESL:	CJNE CCNT, #20H, LCD_EFL	; Fin de segunda línea
			ACALL LCD_CLR				; Limpiar pantalla
			ACALL LCD_FL				; y resetear a primera posición
			MOV CCNT, #0				; Resetear conteo de caracteres
			
LCD_EFL:	CJNE CCNT, #10H, LCD_SND	; Fin de primera línea
			MOV A, #0C0H				; Cursor en segunda línea, primera posición
			ACALL LCD_CMD
			
LCD_SND:	POP ACC					; Recuperar dato a desplegar
			MOV LCD, A 					; Posicionar datos
			SETB RS 					; Modo datos
			SETB E
			ACALL DELAY
			CLR E						; Enviar datos
			ACALL DELAY
			ACALL ARR_SAVE				; Guardar caracter introducido en arreglo
			RET


; Almacenar en arreglo de caracteres
; Inicio de arreglo: 30H
ARR_SAVE:	MOV A, #CHARR				; Inicio de arreglo
			ADD A, CCNT					; Desplazamiento según caracteres actuales
			MOV CHR_P, A				; Posición actual de arreglo
			MOV @CHR_P, LCD				; Guardar elemento en posición actual
			INC CCNT					; Aumentar cantidad de elementos almacenados actuales
			RET

/* ------------------------------------------------------ */

LCD_INIT:	ACALL DELAY
			ACALL DELAY					; Asegurar espera inicial
			
			MOV B, #4H
			MOV A, #38H					; Modo de 8 bits, 2 líneas (4 veces)
LI_0:		ACALL LCD_CMD
			ACALL DELAY
			DJNZ B, LI_0
			
			ACALL LCD_CLR				; Limpiar LCD
			
			; Se incluye el siguiente comando por recomendación pero es omisible
			; Incrementar posición, desplazamiento desactivado
			MOV A, #6H
			ACALL LCD_CMD
			
			MOV A, #0FH 				; Display, cursor y parpadeo encendidos
			ACALL LCD_CMD
			
			ACALL LCD_FL				; Cursor inicial

			MOV CCNT, #0				; Resetear contador de caracteres en matriz

MAIN:		MOV DPTR, #0A8H * 0AH		; Posicionar apuntador en tabla de valores
			CLR ALT						; Limpiar para detección de ALT
			
			MOV SCON, #42H				; Habilitación de comunicación serial
			
			MOV IE, #87H				; Interrupciones externas y T0 habilitadas
			MOV TMOD, #22H				; T0 y T1 en modo autorrecarga
			
			MOV TH0, #0
			MOV TL0, #0FBH				; Contar 500 nanosegundos
			SETB TR0
			
			MOV TH1, #0FDH
			MOV TL1, #0FDH				; Estándar de 9600 baudios
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