; IS727272 - Cordero Hernández, Marco Ricardo
; Acceso individual a pines de cada puerto

; Sintaxis: SETB X.Y | CLR X.Y
;           CPL X.Y

; Terminología: SET Bit; CLeaR; ComPLement
; Recordar indexación inicial en 0 para número de puertos

; Cambiar puerto P1.2 ciclicamente
BACK:   CPL     P1.2
        ACALL   DELAY
        SJMP    BACK

; Variación más explícita
AGAIN:  SETB    P1.2
        ACALL   DELAY
        CLR     P1.2
        ACALL   DELAY
        SHMP    AGAIN

; OBSERVACIÓN: SETB se puede utilizar para habilitar un bit como INPUT sin necesidad de MOV ..., #0FFH