; IS727272 - Cordeo Hernández Marco Ricardo

; Introduciendo los comentarios multilínea...
/*
    Diseñe un sistema basado en el 89S52 que cumple con las siguientes especificaciones:
        - Tiene 16Kb de memoria de código y 12Kb de memoria de datos.
        - Cuenta con ROM de 4Kb únicamente (las que necesite).
        - También posee memoria RAM de 4Kb (las que necesite).
        - Las ROM deben localizarse a partir de la dirección 8000H.
        - La memoria de datos inicia en la 4000H.
        - Por necesidad especial del sistema, una RAM debe iniciar en 0000H.

    Realice:
        - Mapas de memoria del sistema.
        - Decodificador de memorias del sistema (138 o compuertas lógicas).
        - Realice el diagrama esquemático correspondiente.
*/

/*
    Notas iniciales:
        - Código --> ROM ; Datos --> RAM
        - Código: 16Kb = 4Kb * 4 ∴ 4 memorias requeridas
        - Datos: 12Kb = 4Kb * 3 ∴ 3 memorias requeridas
        - Se asume una cota superior de FFFFH

    Nota acerca de instrucciones:
        El último par de instrucciones se contradicen, ya que primero se indica el inicio
        de las RAM en la posición 4000H y luego se indica su inicio en 0000H.
        Para el propósito de la tarea, se tomará esto como una confusión válida.
*/



/*  ----------------- MAPAS DE MEMORIA SUMARIZADOS -----------------
    ROMs
    Inicio: 8000H
    Libre: [0000H, 7FFFH] ∪ [C000H, FFFFH]

    ROM1 -> 8000H - 8FFFH
    ROM2 -> 9000H - 9FFFH
    ROM3 -> A000H - AFFFH
    ROM4 -> B000H - BFFFH


    RAMs
    Inicio: 0000H con salto hacía 4000H
    Libre: [1000H, 3FFFH] ∪ [6000H, FFFFH]

    RAM1 -> 0000H - 0FFFH
    RAM2 -> 4000H - 4FFFH
    RAM3 -> 5000H - 5FFFH
*/



/*  ----------------- PROPUESTAS DE DECODIFICADORES -----------------
    Circuito a utilizar: 74LS138

    ROMs
    Posiciones: A16, A15, A14 y A13
    Salidas: y0 (ROM1), y1 (ROM2), y2 (ROM3), y3 (ROM4)

    A16' = P2.7' -> A
    A14 = P2.5 -> B
    A13 = P2.4 -> C
    A15 = P2.6 -> G2A
    

    RAMs
    Posiciones: A16, A15, A14 y A13
    Salidas: y0 (RAM1), y4 (RAM2), y5 (RAM3)

    A15 = P2.6 -> A
    A14 = P2.5 -> B
    A13 = P2.4 -> C
    A16 = P2.7 -> G2A
*/

; Esquemático en este mismo directorio