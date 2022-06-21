; Cordero Hernández Marco Ricardo 727272
; Guzmán Claustro Edgar 727576
/* 17)	A partir de la localidad 500H de RAM se encuentra una lista de palabras de 16 bits.
        En el registro R4 se encuentra el número de elementos de la lista. Se requiere implementar
        un programa que genere el promedio de los elementos de la lista y que guarde dicho promedio en los registro R6 y R7. */

        ORG 0000H
        JMP main
        ORG 0040H

main: MOV DPTR, #0500H
      MOV A, R4
      MOV B, #02H
      MUL AB
      MOV R4, A
      MOV R5, A
suma: MOVX A, @DPTR
      INC DPTR
      MOV B, A
      MOVX A, @DPTR
      ADD A, R0
      MOV R0, A
      MOV A, B
      ADDC A, R1
      MOV R1, A
      DJNZ R4, suma

promedio:
      MOV A, R0
      SUBB A, R5
      MOV R0, A
      MOV A, R1
      SUBB A, #00H
      MOV R1, A
      INC R4
      CJNE R1, #00H, promedio
      MOV A, R0
      MOV 30H, R5
      CJNE A, 30H, escr
fin:
      MOV A, R4
      MOV R6, A
      MOV A, R0
      MOV R7, A
      JMP $

escr:
      JC fin
      JMP promedio
      
      END