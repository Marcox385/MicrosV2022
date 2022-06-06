; IS727272 - Cordero Hernández, Marco Ricardo
; Explicación superficial de puertos en la familia de los 8051


; Puerto 0 (Pin 32 a 39) --> Puerto con utilidad para entrada y salida
; También designado como AD0 - AD7 como utilidad para direcciones y datos
; Al reiniciar, P0 es configurado como input

; Alternar todos los bits de P0
BACK:   MOV     A, #55H         ; 55_16 == 01010101_2
        MOV     P0, A
        ACALL   DELAY
        MOV     A, #0AAH        ; AA_16 == 10101010_2
        MOV     P0, A
        ACALL   DELAY
        SJMP BACK

; Con resistores conectados al puerto 0, para volverlo puerto de entrada, se deben
; escribir 1's en todos sus bits
; Obtener un byte desde P0 y mandarlo a P1
        MOV     A, #0FFH
        MOV     P0, A           ; P0 se convierte en input al escribir 1 a todos sus bits

BACK:   MOV     A, P0
        MOV     P1, A
        SJMP    BACK

; -------------------------------------------------------------------------------------------

; Puerto 1 (Pin 1 a 8) --> Puerto con utlidad para entrada y salida
; Diferencia con P0: no necesita resistores, ya que P1 cuenta con resistores internos
; Al reiniciar, P1 es configurado como input

; Alternar todos los bits de P1 usando complemento
        MOV     A, #55H
BACK    MOV     P1, A
        ACALL   DELAY
        CPL     A       ; CPL = complemento
        SJMP    BACL

; Habilitar P1 como input
        MOV     A, #0FFH
        MOV     P1, A

        MOV     A, P1   ; Leer de P1 una vez habilitado como input
        MOV     R7, A
        ACALL   DELAY
        MOV     A, P1
        MOV     R6, A
        ACALL   DELAY
        MOV     A, P1
        MOV     R5, A

; Pin 1 - P1.0 -> T2: Temporizador/Contador 2 input externo
; Pin 2 - P1.1 -> T2EX: Temporizador/Contador captura/recarga

; -------------------------------------------------------------------------------------------

; Puerto 2 (Pin 21 a 28) | Características similares a P1

; Enviar información desde P2 como input a P1
        MOV     A, #0FFH
        MOV     P2, A

BACK:   MOV     A, P2
        MOV     P1, A
        SJMP    BACK

; Adicional a las características I/O de P2, en algunos casos se debe utilizar este puerto
; para la porción posterior de una dirección de memoria externa de 16 bits.
; Dado el caso, P0 proporcionaría los 8 primeros bits y P2 los subsecuentes. Lo anterior
; inhabilitaría la capacidad I/O de P2.

; -------------------------------------------------------------------------------------------

; Puerto 3 (Pin 10 a 17) | Características similares a P1 y P2
; Aunque P3 se configure como input al reiniciar, usualmente no se utiliza como tal
; ya que este ofrece funciones adicionales de suma importancia como interruptores.

; Pin 10 - P3.0 -> RxD: Recibir datos de puerto serial
; Pin 11 - P3.1 -> TxD: Transmitir datos a puerto serial
; Pin 12 - P3.2 -> INT0: Interruptor externo 0
; Pin 13 - P3.3 -> INT1: Interruptor externo 1
; Pin 14 - P3.4 -> T0: Temporizador/Contador 0 input externo
; Pin 15 - P3.5 -> T1: Temporizador/Contador 1 input externo
; Pin 16 - P3.6 -> WR: Señal de escritura para memoria externa
; Pin 17 - P3.7 -> RD: Señal de lectura para memoria externa

; P3.6 y P3.7 se utilizan como I/O en algunnos sistemas

; -------------------------------------------------------------------------------------------

; Los cuatro puertos comprenden 32 pines de los 40 disponibles
; Los 8 restantes son los siguientes
; Pin 40 - VCC: Voltaje/corriente para el chip. La fuente es de +5V.
; Pin 20 - GND/VSS: Tierra; complementario a VCC.
; Pin 19 - XTAL1: Para oscilador integrado. Funciona con un oscilador externo (C1).
; Pin 18 - XTAL2: Para oscilador integrado. Funciona con un oscilador externo (C2). Opcianal.
; Pin 9 - RST: Para reseteo de registros. Power-on reset en high.
; Pin 31 - EA/VPP: External access. Debe conectarse a VCC o a GND obligatoriamente.
; Pin 29 - PSEN: Pin de salida (Program store enable). Se conecta al pin OE de una ROM.
; Pin 30 - ALE/PROG: Pin de salida. Identifica dirección y datos mediante multiplexado en P0.

; Los pines VCC, GND, XTAL1, XTAL2, RST y EA deben estar conectados para que el chip funcione.

; Consideraciones adicionales para XTAL
; Se deben tener en cuenta la velocidad máxima del 8051 a utilizar.
; Esta velocidad indica la frecuencia máxima con la que se debe emparejar el oscilador externo.
; Si la velocidad es de 20MHz, se debe utilizar un oscilador de 20MHz o menos.
; En caso de usar otra fuente de frecuencia (como un oscilador TTL), XTAL2 se deja desconectado.

; Consideraciones adicionalaes para RST
; De utilizar una ROM, las instrucciones deben comenzar en la dirección de memoria 0000,
; ya que al resetear el circuito, el registro Program Counter tomará el valor 0.
; Para que este reset sea exitoso, debe permanecer en high al menos 2 cíclos máquina antes de
; regresar a estado low. Para los 8051, un ciclo máquina se define como 12 periodos de oscilador.

; Consideraciones adicionalas para EA
; Algunos microcontroladores contienen una ROM, para este caso, EA debe conectarse a VCC.
; Caso contrario, deberá conectarse a GND para indicar almaacenamiento externo.

; -------------------------------------------------------------------------------------------

; --- Detalles adicionales ---
; H al final de valores == Hexadecimal
; Se utiliza 0 al inicio de un valor hexadecimal para evitar colisiones con variables de nombre similar