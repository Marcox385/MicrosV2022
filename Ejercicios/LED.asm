; IS727272 - Cordero Hernández, Marco Ricardo
; Suponer un switch y un led conectados a puertos arbitrarios.
; Modificar el estado del led dependiendo la entrada del switch

        SETB P1.7; Bit asignado a switch
AGAIN:  MOV C, P1.7; C = Bandera de carry
        MOV P2.7, C; Modificar estado de led
        SJMP AGAIN