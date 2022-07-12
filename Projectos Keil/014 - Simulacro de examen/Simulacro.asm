/*	
	Ejercicio práctico   
	Puede emplear computadora, libro, apuntes, reportes de sus prácticas, etc.

	Se debe incluir para la entrega: enunciado (favor de tomar fotografía con su teléfono móvil), diagrama esquemático detallado de hardware,
	mapas de memoria, diagrama de flujo de los programas, software en ensamblador con COMENTARIOS RELEVANTES y el archivo.hex.
	Es requisito emplear al menos una interrupción distinta al RESET.

	Enunciado:
	La unión de cañeros CNC  desea contar con un sistema para monitorear la humedad del suelo de sus parcelas.
	Para ello cuenta con un sensor de humedad conectado a un convertidor analógico-digital de 8 bits y salida serial compatible con el estándar RS232
	a 9,600 baudios. El microcontrolador tomará esa información, la convertirá en ASCII y la enviará a un módulo de transmisión por radiofrecuencia el
	cual recibe  también palabras seriales a la velocidad antes mencionada.

	El monitor contará además con una pantalla de cristal líquido en la cual mostrará el dato. Si el nivel de humedad es mayor a 150, el monitor
	encenderá un led rojo y en la segunda línea aparecerá la palabra MOJADO (es decir no se puede cosechar), la cual desaparecerá cuando el nivel
	baje de dicho valor. Así mismo, pasada la contingencia el led deberá apagarse. Otro tanto ocurrirá si la humedad es menor a 50, en cuyo caso
	aparecerá la palabra SECO.

	Indique los componentes de hardware que empleará. La computadora y le convertidor serán vistos como cajas negra que cumple con los estándares de
	comunicación antes mencionados.
*/