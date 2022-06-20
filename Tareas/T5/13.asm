/* 13)	Hacer un programa para que encuentre el elemento más pequeño de una lista de números de 16 bits sin signo
        que están en localidades consecutivas de memoria. La dirección del primer elemento de la lista se encuentra
        en las localidades 1900H y 1901H, el número de elementos del arreglo está en la localidad 1902H. El elemento
        más pequeño encontrado debe guardarse en la localidad 1903H. */

        ORG 0000H
        SJMP MAIN
        ORG 0040H

MAIN: