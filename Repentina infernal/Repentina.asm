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
		
		
		; Constantes para reloj (prioridad ascendente)
		SEGS0 EQU 50H
		SEGS1 EQU 51H
		MINS0 EQU 52H
		MINS1 EQU 53H
		HORS0 EQU 54H
		HORS1 EQU 55H
			
		; Constantes para alarma (prioridad ascendente)
		SEGS0_A EQU 60H
		SEGS1_A EQU 61H
		MINS0_A EQU 62H
		MINS1_A EQU 63H
		HORS0_A EQU 64H
		HORS1_A EQU 65H

; ---------------- INTERRUPCIONES ----------------
		ORG 0000H
		JMP MAIN

		; Timer 0 | Segundos
		ORG 000BH
		JMP COUNT_SEC

		; Timer 1 | Multiplexado
		ORG 001BH
		JMP MUX
; ------------------------------------------------

		ORG 0040H
		
MAIN:	MOV DPTR, #400H		; Tabla de representación en displays
		MOV R0, #14H		; Constante 20D para segundo
		MOV P2, #0FFH 		; Se usa P2 para habilitar cada display
		MOV IE, #8AH		; Interrupciones habiltiadas, T1 y T0
				
		; 12:00:00 para reloj en reset
		MOV SEGS0, #0
		MOV SEGS1, #0
		MOV MINS0, #0
		MOV MINS1, #0
		MOV HORS0, #2H
		MOV HORS1, #1H
		
		; 00:00:00 para alarma en reset
		MOV SEGS0_A, #0
		MOV SEGS1_A, #0 
		MOV MINS0_A, #0
		MOV MINS1_A, #0
		MOV HORS0_A, #0
		MOV HORS1_A, #0
				
		MOV TMOD, #11H 		; Temporizadores de 16 bits (ambos)
		
		MOV TH0, #HIGH MIL15 
		MOV TL0, #LOW MIL15
		SETB TR0
		
		MOV TH1, #HIGH MIL60
		MOV TL1, #LOW MIL60
		SETB TR1
		
		; Variables para multiplexar displays en ambos modos
		MOV R6, #6H 		; Reloj
		MOV R7, #6H 		; Alarma
		
		; Pines para interrupciones
		SETB P3.2 			; Aumento
		SETB P3.3 			; Modo
		
; Comprobación para buzzer (reloj == alarma)	
ALARM_LOOP:	MOV A, MINS0
		CJNE A, MINS0_A, ALARM_OFF
		MOV A, MINS1
		CJNE A, MINS1_A, ALARM_OFF
		MOV A, HORS0
		CJNE A, HORS0_A, ALARM_OFF
		MOV A, HORS1
		CJNE A, HORS1_A, ALARM_OFF
		
		; Prender buzzer y repetir comprobación
		CLR P0.0
		SJMP ALARM_LOOP

; Apagar buzzer
ALARM_OFF: SETB P0.0

; Interrupción T0
COUNT_SEC: CLR TR0
		MOV TH0, #HIGH MIL15
		MOV TL0, #HIGH MIL15
		SETB TR0
		DJNZ R0, INTER_T0
		SJMP INC_SEC

END_SEG: MOV R0, #14H ; Reinicio de segundo

INTER_T0: RETI
	
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

ADD_HR_A: MOV A, HORS0_A
		CJNE A, #0AH, ADD_SEC
		MOV HORS0_A, #0
		INC HORS1_A
		SJMP ADD_SEC

INC_SEC: JB P3.2, ADD_SEC
		JNB P3.3, ADD_MIN
		JB P3.3, ALARM_VERIFY

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

ADD_HR: MOV A, HORS0
		CJNE A, #0AH, END_SEG
		MOV HORS0, #0
		INC HORS1
		JMP END_SEG

ADD_MIN: INC MINS0
		MOV A,MINS0
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

ADD_HR_SC: MOV A, HORS0
		CJNE A, #0AH, ADD_SEC
		MOV HORS0, #0
		INC HORS1
		SJMP ADD_SEC

; ------ MULTIPLEXADO DE DISPLAYS ------

MUX:	CLR TR1
		MOV TH1, #HIGH MIL60
		MOV TL1, #LOW MIL60
		SETB TR1
		JNB P3.3, DSP1

DSP1_A: CLR P0.1
		CJNE R7, #6H, DSP2_A 
		MOV P2, #0
		MOV A, SEGS0_A 
		MOVC A, @A + DPTR
		MOV P1, A 
		MOV P2, #1H
		JMP ALARM_MOD

DSP1: 	SETB P0.1
		CJNE R6, #6H, DSP2
		MOV P2, #0
		MOV A, SEGS0
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #1H
		JMP CLOCK_MOD
		JNB P3.3,DSP2
	
DSP2_A: CLR P0.1 
		CJNE R7, #5H, DSP3_A 
		MOV P2, #0
		MOV A, SEGS1_A 
		MOVC A, @A + DPTR 
		MOV P1, A 
		MOV P2, #2H 
		JMP ALARM_MOD 

DSP2: 	SETB P0.1
		CJNE R6, #5H, DSP3 
		MOV P2, #0
		MOV A, SEGS1
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #2H
		JMP CLOCK_MOD
		JNB P3.3,DSP3

DSP3_A: CLR P0.1
		CJNE R7, #4H, DSP4_A 
		MOV P2, #0H
		MOV A, MINS0_A 
		MOVC A, @A + DPTR 
		MOV P1, A 
		MOV P2, #4H 
		JMP ALARM_MOD
	
DSP3: 	SETB P0.1
		CJNE R6, #4H, DSP4 
		MOV P2, #0
		MOV A, MINS0
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #4H
		SJMP CLOCK_MOD 
		JNB P3.3, DSP4

DSP4_A: CLR P0.1
		CJNE R7, #3H, DSP5_A
		MOV P2, #0
		MOV A, MINS1_A
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #8H
		SJMP ALARM_MOD

DSP4: 	SETB P0.1
		CJNE R6, #3H, DSP5
		MOV P2, #0
		MOV A, MINS1
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #8H
		SJMP CLOCK_MOD
		JNB P3.3, DSP5

DSP5_A: CLR P0.1
		CJNE R7, #2H, DSP6_A
		MOV P2, #0
		MOV A, HORS0_A
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #10H
		SJMP ALARM_MOD

DSP5: 	SETB P0.1
		CJNE R6, #2H, DSP6
		MOV P2, #0
		MOV A, HORS0
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #10H
		SJMP CLOCK_MOD
		JNB P3.3, DSP6

DSP6_A: CLR P0.1
		CJNE R7, #1H, ALARM_MOD
		MOV P2, #0
		MOV A, HORS1_A
		MOVC A, @A + DPTR
		MOV P1, A
		MOV P2, #20H
		MOV R7, #7H
		SJMP ALARM_MOD

DSP6: 	SETB P0.1
		CJNE R6, #1H, CLOCK_MOD
		MOV P2, #0
		MOV A, HORS1
		MOVC A, @A + DPTR
		MOV P1, A 
		MOV P2, #20H
		MOV R6, #7H

CLOCK_MOD: DEC R6
		RETI

ALARM_MOD: DEC R7

; --------------------------------------

; -- Valores codificados para display -- 

	ORG 0400H
	DB 81H 	; 0
	DB 0F3H	; 1
	DB 49H	; 2
	DB 61H	; 3
	DB 33H 	; 4
	DB 25H 	; 5
	DB 5H 	; 6
	DB 71H 	; 7
	DB 1H 	; 8
	DB 21H 	; 9
		
; ---------------------------------------

	END