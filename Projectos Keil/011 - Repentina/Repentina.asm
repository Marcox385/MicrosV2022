/* 
	727576 - 		   Guzmán Claustro Edgar
	727272 - Cordero Hernández Marco Ricardo
	727366 - Rodríguez Castro Carlos Eduardo
	
	--------------------------- REPENTINA ---------------------------
	Tomando como base un sistema basado en un 8052, diseñar un reloj
	despertador de la manera más similar al reloj de números rojos de
	tu recámara.
	
	Especificaciones para el software
		a.	Un programa principal en el que se hacen las
		    inicializaciones (registros y localidades de memoria),
			se verifica si lo que se va a desplegar es la hora real o
			la hora de alarma (pudiéndose utilizar en su lugar una
			interrupción) y esperar las interrupciones que hacen
			funcionar el dispositivo
			
		b.	Una subrutina de interrupción para el tic de un segundo y
			actualización de la hora real en BCD y en 7 segmentos
		
		c.	Una subrutina de interrupción para la multiplexación de
			los displays
		
		d.	Una o dos subrutinas de interrupción para poner a tiempo
			el reloj dependiendo de si se emplean uno o dos
			interruptores para el ajuste del tiempo (hora y minuto)
	-----------------------------------------------------------------
*/

		MIL15 EQU 3CB0H ; 15mils
		MIL60 EQU 0FC18H ; 60mils
		
		
		; Constantes para reloj (orden descendente)
		HORS1 EQU 55H
		HORS0 EQU 54H
		MINS1 EQU 53H
		MINS0 EQU 52H
		SEGS1 EQU 51H
		SEGS0 EQU 50H
			
		; Constantes para alarma (orden descendente)
		HORS1_A EQU 65H
		HORS0_A EQU 64H
		MINS1_A EQU 63H
		MINS0_A EQU 62H
		SEGS1_A EQU 61H
		SEGS0_A EQU 60H

; ---------------- INTERRUPCIONES ----------------
		ORG 0000H
		JMP MAIN

		; Timer 0 | Segundos
		ORG 000BH
		JMP SEC_VER

		; Timer 1 | Multiplexado
		ORG 001BH
		JMP MUX
; ------------------------------------------------

		ORG 0040H
		
MAIN:	MOV DPTR, #385H+7BH ; Tabla de representación en displays
		MOV R0, #14H		; Constante 20D para segundo
		MOV P2, #0FFH 		; Se usa P2 para habilitar cada display
		MOV IE, #8AH		; Interrupciones habilitadas, T1 y T0
				
		; Pines para interrupciones
		SETB P3.2 			; Aumento
		SETB P3.3 			; Modo
		
		; 12:00:00 para reloj en reset
		MOV HORS1, #1H
		MOV HORS0, #2H
		MOV MINS1, #0
		MOV MINS0, #0
		MOV SEGS1, #0
		MOV SEGS0, #0
		
		; 00:00:00 para alarma en reset
		MOV HORS1_A, #0
		MOV HORS0_A, #0
		MOV MINS1_A, #0
		MOV MINS0_A, #0
		MOV SEGS1_A, #0
		MOV SEGS0_A, #0 		
		
		MOV TMOD, #11H 		; Temporizadores de 16 bits (ambos)
		
		MOV TH0, #HIGH MIL15 
		MOV TL0, #LOW MIL15
		SETB TR0
		
		MOV TH1, #HIGH MIL60
		MOV TL1, #LOW MIL60
		SETB TR1
		
		; Variables para multiplexar displays en ambos modos
		MOV R2, #6H 		; Reloj
		MOV R3, #6H 		; Alarma
		
; Comprobación para buzzer (reloj == alarma)	
ALARM_LOOP:	MOV A, MINS0
		CJNE A, MINS0_A, ALARM_OFF
		MOV A, MINS1
		CJNE A, MINS1_A, ALARM_OFF
		MOV A, HORS0
		CJNE A, HORS0_A, ALARM_OFF
		MOV A, HORS1
		CJNE A, HORS1_A, ALARM_OFF
		
		; Prender buzzer y repetir comprobación (1min)
		CLR P0.0
		SJMP ALARM_LOOP

; Apagar buzzer
ALARM_OFF: SETB P0.0
		SJMP ALARM_LOOP

; Interrupción T0
SEC_VER: CLR TR0
		MOV TH0, #HIGH MIL15
		MOV TL0, #HIGH MIL15
		SETB TR0
		DJNZ R0, RETURN
		SJMP SEC_ADD

END_SEG: MOV R0, #14H ; Reinicio de segundo

RETURN: RETI
	
ALARM_VERIFY: INC MINS0_A
		MOV A, MINS0_A
		CJNE A, #0AH, ADD_SEC	; Decenas de segundos
		
		MOV MINS0_A, #0
		INC MINS1_A
		MOV A, MINS1_A
		CJNE A, #6H, ADD_SEC	; Minuto
		
		MOV MINS1_A, #0
		INC HORS0_A
		MOV A, HORS0_A
		CJNE A, #4H, ADD_HR_A ; Hora
		
		MOV A, HORS1_A
		CJNE A, #2H, ADD_HR_A ; Día
		
		MOV HORS0_A, #0
		MOV HORS1_A, #0
		SJMP ADD_SEC

; Verificar interrupciones
SEC_ADD: JB P3.2, ADD_SEC
		JNB P3.3, ADD_MIN
		SJMP ALARM_VERIFY

; Para hora > 9 en alarma
ADD_HR_A: MOV A, HORS0_A
		CJNE A, #0AH, ADD_SEC
		MOV HORS0_A, #0
		INC HORS1_A
		SJMP ADD_SEC

; Aumento de segundo propagado
ADD_SEC: INC SEGS0
		MOV A, SEGS0
		CJNE A, #0AH, END_SEG	; Aumentar segundo
		MOV SEGS0, #0
		
		INC SEGS1
		MOV A, SEGS1
		CJNE A, #6H, END_SEG	; Aumentar decena
		MOV SEGS1, #0
		
		INC MINS0
		MOV A, MINS0
		CJNE A, #0AH, END_SEG	; Aumentar minuto
		MOV MINS0, #0
		
		INC MINS1
		MOV A, MINS1
		CJNE A, #0AH, END_SEG	; Aumentar decena de minuto
		MOV MINS1, #0
		
		INC HORS0
		MOV A, HORS0
		CJNE A, #04D, ADD_HR ; Aumentar hora
		
		MOV A, HORS1
		CJNE A, #2H, ADD_HR
		MOV HORS0, #0
		MOV HORS1, #0

; Para hora > 9 en reloj
ADD_HR: MOV A, HORS0
		CJNE A, #0AH, END_SEG
		MOV HORS0, #0
		INC HORS1
		JMP END_SEG

; Aumento de minuto propagado
ADD_MIN: INC MINS0
		MOV A, MINS0
		CJNE A, #0AH, ADD_SEC
		
		MOV MINS0, #0
		INC MINS1
		MOV A, MINS1
		CJNE A, #6H, ADD_SEC
		
		MOV MINS1, #0
		INC HORS0
		MOV A, HORS0
		CJNE A, #4H, ADD_HR_SC
		
		MOV A, HORS1
		CJNE A, #2H, ADD_HR_SC
		
		MOV HORS0, #0
		MOV HORS1_A, #0
		SJMP ADD_SEC

; Modificación de aumento cuando hora < 24
ADD_HR_SC: MOV A, HORS0
		CJNE A, #0AH, ADD_SEC
		MOV HORS0, #0
		INC HORS1
		SJMP ADD_SEC

; ------ MULTIPLEXADO DE DISPLAYS ------

/*
	DISPLAY's
	6-5 	4-3 	  2-1
	HR1-HR0 MIN1-MIN0 SEG1-SEG0
*/

DISP_SHOW: MOVC A, @A + DPTR
		MOV P1, A
		RET

MUX:	CLR TR1
		MOV TH1, #HIGH MIL60
		MOV TL1, #LOW MIL60
		SETB TR1
		JNB P3.3, DSP1

DSP1_A: CLR P0.1
		CJNE R3, #6H, DSP2_A
		MOV A, SEGS0_A 
		ACALL DISP_SHOW
		MOV P2, #1H
		JMP ALARM_MOD

DSP1: 	SETB P0.1
		CJNE R2, #6H, DSP2
		MOV A, SEGS0
		ACALL DISP_SHOW
		MOV P2, #1H
		JMP CLOCK_MOD
		JNB P3.3, DSP2
	
DSP2_A: CLR P0.1 
		CJNE R3, #5H, DSP3_A
		MOV A, SEGS1_A 
		ACALL DISP_SHOW
		MOV P2, #2H 
		JMP ALARM_MOD 

DSP2: 	SETB P0.1
		CJNE R2, #5H, DSP3
		MOV A, SEGS1
		ACALL DISP_SHOW
		MOV P2, #2H
		JMP CLOCK_MOD
		JNB P3.3, DSP3

DSP3_A: CLR P0.1
		CJNE R3, #4H, DSP4_A
		MOV A, MINS0_A 
		ACALL DISP_SHOW
		MOV P2, #4H
		JMP ALARM_MOD
	
DSP3: 	SETB P0.1
		CJNE R2, #4H, DSP4
		MOV A, MINS0
		ACALL DISP_SHOW
		MOV P2, #4H
		SJMP CLOCK_MOD 
		JNB P3.3, DSP4

DSP4_A: CLR P0.1
		CJNE R3, #3H, DSP5_A
		MOV A, MINS1_A
		ACALL DISP_SHOW
		MOV P2, #8H
		SJMP ALARM_MOD

DSP4: 	SETB P0.1
		CJNE R2, #3H, DSP5
		MOV A, MINS1
		ACALL DISP_SHOW
		MOV P2, #8H
		SJMP CLOCK_MOD
		JNB P3.3, DSP5

DSP5_A: CLR P0.1
		CJNE R3, #2H, DSP6_A
		MOV A, HORS0_A
		ACALL DISP_SHOW
		MOV P2, #10H
		SJMP ALARM_MOD

DSP5: 	SETB P0.1
		CJNE R2, #2H, DSP6
		MOV A, HORS0
		ACALL DISP_SHOW
		MOV P2, #10H
		SJMP CLOCK_MOD
		JNB P3.3, DSP6

DSP6_A: CLR P0.1
		CJNE R3, #1H, ALARM_MOD
		MOV A, HORS1_A
		ACALL DISP_SHOW
		MOV P2, #20H
		MOV R3, #7H		; Para resetear a 6H después de DEC
		SJMP ALARM_MOD

DSP6: 	SETB P0.1
		CJNE R2, #1H, CLOCK_MOD
		MOV A, HORS1
		ACALL DISP_SHOW
		MOV P2, #20H
		MOV R2, #7H		; Para resetear a 6H después de DEC

CLOCK_MOD: DEC R2
		RETI

ALARM_MOD: DEC R3
		RETI

; --------------------------------------

; -- Valores codificados para display -- 

	ORG 0400H
	DB 81H 		; 0
	DB 0F3H		; 1
	DB 49H		; 2
	DB 61H		; 3
	DB 33H 		; 4
	DB 25H 		; 5
	DB 5H 		; 6
	DB 71H 		; 7
	DB 1H 		; 8
	DB 21H 		; 9
		
; ---------------------------------------

	END