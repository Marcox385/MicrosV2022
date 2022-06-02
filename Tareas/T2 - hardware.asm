; IS727272 - Cordero Hernández Marco Ricardo
; Datos relevantes acerca del capítulo 2 (MacKenzie)

; Para más información acerca de la parte de pines, consultar T0

; Como se detalló para los pines 18 (XTAL2) y 19 (XTAL1), el oscilador integrado
; funciona a través del uso de un cristal externo (XTAL2 conectado en caso de no usar un cristal TTL).
; Estos cristales usualmetne generan una frecuencia de 12MHz, es decir, 12 millones de ciclos de reloj por segundo.
; La familia 8051 requiere dos ciclos de reloj para realizar una operación discreta, tales como obtener una
; instrucción, decodificarla o ejecutarla.
; La duración de dos ciclos de reloj también se llama estado. Los 8051 requieren entonces de seis estados
; para procesar por completo una instrucción, o sea, 12 ciclos de reloj. A esta duración de seis estados
; también se le conoce como un ciclo máquina.
; Algunas instrucciones más complejas requieren de más ciclos máquina, variando desde uno hasta cuatro.

; Terminología común en diagramas secuenciales:
; Ciclos de reloj del oscilador (P) [P1, P2]
; Estados (S) [S1, S2, S3, S4, S5, S6]
; Ciclo máquina (?) [?]

; Típicamente, el oscilador integrado opera a 12 MHz proporcionados por cristales externos,
; por ende, el periodo de un pulso de reloj = 1/frecuencia de oscilador = 1/12MHz = 83.33 ns.
; Un ciclo máquina consiste de 12 pulsos de reloj, por ende -> 83.33 ns * 12 = 1 µs (microsegundo).

; -------------------------------------------------------------------------------------------

; En cuanto a memoria refiere, el 8051 cuenta con RAM integrada y solo para 8051/8052's se tiene
; también ROM integrada. Los registros y puertos I/O se encuentran mapeados en memoria, es por ello
; que también son accesibles como cualquier otra dirección de memoria. Otro dato a notar es que el stack
; se encuentra dentro de la misma RAM, a diferencia de otros microprocesadores en donde se posiciona en RAM externa.

; La espacio de memoria interna se encuentra dividido en RAM interna (00H-7FH) y registros de funciones especiales (80H-0FFH).
; La RAM a su vez se subdivide en bancos de registro (00H-1FH), RAM direccionable por bits (20H-2FH)
; y RAM de propósito general (30H-7FH).

; Para accesar a la RAM general, se puede acceder mediante los modos directos e indirectos
; Ejemplo: leer los contenidos de la RAM interna hacía el acumulador (directo)
    MOV     A, 5FH

; Uso de R0 para replicar ejemplo anterior (indirecto)
    MOV     R0, #5FH
    MOV     A, @R0 ; @ = puntero

; -------------------------------------------------------------------------------------------

; Secciones y rangos (hex) de memoria interna
;   -> 00 - 07 : Banco default para registros de R0 a R7
;   -> 08 - 0F : Banco 1
;   -> 10 - 17 : Banco 2
;   -> 18 - 1F : Banco 3
;   -> 20 - 2F : direcciones accesables por bit (00 - 7F)
;   -> 30 - 7F : RAM de propósito general
;   -> 80 : P0 (80 - 87)
;   -> 81 : SP - Stack Pointer (no direccionable por bit)
;   -> 82 : DPL (no direccionable por bit)