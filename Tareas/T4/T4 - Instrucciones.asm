/* 
    727272 - Cordero Hernández Marco Ricardo
    Capítulo 3 - Conjunto de instrucciones
 */

 /* Al seguir trabajando en torno de los 8051, se está hablando de un pseudoprocesador de 8 bits.
  Siendo esto, se cuentan con 2^8 = 256 instrucciones posibles, sin embargo, solamente están implementadas 255
  (A5 = 10100101 es la instrucción sin definir) 
  139 instrucciones de 1 byte
  92 instrucciones de 2 bytes
  24 instrucciones de 3 bytes */

;  --- MODOS DE DIRECCIONAMIENTO ---
; Existen ocho modos de direccionamiento

    ADD     A, R5       /* Registro -> 00101 nnn
                        Se pueden accesar de R0 a R7 */

    ADD     A, 55H      /* Directo --> 10001001 dddddddd
                        Se pueden accesar a registros de funciones de 80H a FFH */

    ADD     A, @R0      /* Indirecto */

    ADD     A, #44H     /* Inmediato */

    SJMP    ADELANTE    /* Relativo */

    AJMP    ATRAS       /* Absoluto */

    LJMP    LEJOS       /* Largo */

    MOVC    A, @A + PC  /* Indexado */