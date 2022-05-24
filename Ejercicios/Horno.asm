; IS727272 - Cordero Hernández, Marco Ricardo
; Suponiendo el monitoreo de un horno, se propone un sistema de monitoreo
; que detecte el estado de la temperatura del mismo. La manera de realizar esto
; es mediante un ciclo continuo que monitoree un bit. Cuando el bit se "encienda",
; el sistema deberá enviar un pulso high-to-low a un dispositivo externo.

HERE: JNB   P2.3, HERE
      SETB  P1.5        ; HIGH
      CLR   P1.5        ; LOW
      SJMP  HERE

; Los puertos y pines utilizados son arbitrarios
; La línea 10 indica un ciclo continuo, lo cual podría representarse en una alarma
; que se activa repetitivamente hasta que la temperatura descienda.