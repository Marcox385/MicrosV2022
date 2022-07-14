; NOTA: Las X no se toman en cuenta ya que son directivas dse compilador y no afectan en el HEX generado

								; DIR		OPCODE
		ORG 0000H				; X			X
		SJMP MAIN				; 0000		80 3E
		
		ORG 0040H				; X			X
MAIN:	MOV A, #55H				; 0040		74 55
		MOV A, #55H				; 0042		74 55
		MOV A, #55H				; 0044		74 55
		MOV A, #55H				; 0046		74 55
		MOV A, #55H				; 0048		74 55
		MOV A, #55H				; 004A		74 55
		MOV A, #55H				; 004C		74 55
		MOV A, #55H				; 004E		74 55
		NOP						; 0050		00
		NOP						; 0051		00
		NOP						; 0052		00
		NOP						; 0053		00
		NOP						; 0054		00
		NOP						; 0055		00
		NOP						; 0056		00
		NOP						; 0057		00

CICLO:	MOV A, #55H				; 0058		74 55
		MOV A, #55H				; 005A		74 55
		MOV A, #55H				; 005C		74 55
		MOV A, #55H				; 005E		74 55
		MOV R0, #05H			; 0060		78 05
		DJNZ R0, CICLO			; 0062		D8 F4

CICLO2:	NOP						; 0064		00
		NOP						; 0066		00
		NOP						; 0068		00
		NOP						; 006A		00
		MOV R0, #07H			; 006B		78 07
		DJNZ R0, CICLO2			; 006D		D8 F8
		SJMP MAIN				; 0070		80 D2
		
		END						; X			X

/*
	HEX
	:02000000803E40
	:100040007455745574557455745574557455745568
	:10005000000000000000000074557455745574557C
	:0E0060007805D8F4000000007807D8F880D2A8
	:00000001FF
*/