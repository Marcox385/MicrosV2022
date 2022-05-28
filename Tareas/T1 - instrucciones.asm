; IS727272 - Cordero Hernández Marco Ricardo
; Corridas de escritorio para conjunto finito de instrucciones

; Se propone el siguiente conjunto de instrucciones
; donde AC = Acumulador y M = memoria

; Instrucción   Código      Operación               Explicación
; ADD           00AAAAAA    AC <- AC + M[AAAAAA]    Se realiza una adición al valor del acumulador del dato en memoria con dirección AAAAAA
; AND           01AAAAAA    AC <- AC ^ M[AAAAAA]    Se realiza la operación lógica AND entre el valor del acumulador y el dato en memoria con dirección AAAAAA
; JMP           10AAAAAA    GOTO AAAAAA             La dirección de memoria actual cambia a AAAAAA (afecta a Program Counter)
; INC           11XXXXXX    AC <- AC + 1            Se realiza un incremento manual al valor del acumulador

; Nótese cómo al ser un conjunto de tamaño 4
; únicamente se necesitan dos bits para identificarlas
; 00 -> ADD; 01 -> AND; 10 -> JMP; 11 -> INC

; Adicional a esto, para la instrucción INC
; se desprecia el valor representado en los
; 6 bits del dato ([2:8])


; Con la información anterior, se propone el siguiente ejercicio:
; Considerando condiciones iniciales después de RESET en una arquitectura Von Neumann
; se cuenta con la siguiente tabla de valores:

; Dirección     Dato        Codificación
; 0             0000 0100   ADD 4
; 1             0100 0101   AND 5
; 2             1100 0000   INC
; 3             1000 0000   JMP 0
; 4             0010 0111   27H | 39D
; 5             0011 1001   39H | 57D

; Ejecutar al menos hasta la primera instrucción de la tercera corrida
; e indicar el valor hasta ese momento de AC.
; Nota: las direcciones 4 y 5 NO DEBEN INTERPRETARSE COMO INSTRUCCIONES
; puesto que, para este programa, estas dos direcciones han sido reservadas
; para almacenar datos numéricos.


; Corrida 1 -> AC = 0000 0000 ; PC = 0
; ADD 4 = ADD M[4] ... AC = 0010 0111 (39D); PC = 1
; AND 5 = AND M[5] ... AC = 0010 0001 (33D); PC = 2
; INC ... AC = 0010 0010 (34D) ; PC = 3
; JMP 0 = JMP M[0] ... AC = 0010 0010 (34D); PC = 0

; Corrida 2 -> AC = 0010 0010 ; PC = 0
; ADD 4 ... AC = 34 + 39 = 73 = 0100 1001; PC = 1
; AND 5 ... AC = 73 ^ 57 = 0000 1001 (9D); PC = 2
; INC ... AC = 0000 1010 (10D); PC = 3
; JMP 0 ... AAC = 0000 1010 (10D); PC = 0

; Corrida 3 -> AC = 000 1010 ; PC = 0
; ADD 4 ... AC = 10 + 39 = 49 = 0011 0001; PC = 1


; ∴ R: PC = 49D | 31H