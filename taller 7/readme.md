# Taller 6: FUNCIONES QUE RETORNAN MULTIPLES REGISTROS Y CURSORES

### Objetivo:
Manejar Funciones que retornan múltiples registros (set of) y manejo de  Cursores


### Realice las siguientes funciones:


1.	Función Propiedades Disponibles, entrega un listado de todas las propiedades DISPONIBLES según los siguientes parámetros:

```
Tipo Propiedad
Tipo Operación
Provincia
Tamaño Construido Mínimo
Tamaño Terreno Mínimo
Precio Máximo 
```

Los parámetros Tipo Propiedad, Tipo Operación y Provincia debe ingresarse el valor String (Ejemplo, en caso de Provincia ingresar el valor  “Barcelona” y no su índice referencia a la tabla Provincia). Además si se ingresa el valor nulo en cualquiera de los  parámetro indicará que no tienen restricciones por dicho campo.



2.- Función ComisionesAPagar (fecha_inicio, Fecha_final), la cual debe generar un listado con el monto a pagar   por comisiones a cada vendedor entre el rango de fechas dado . Para ello, se sabe que los vendedores reciben un 4% por cada venta y un 8% por cada arriendo, además sus supervisores reciben un  1 % por los arriendos y un 2% por las ventas de los vendedores a su cargo (en el caso de las ventas propias de los supervisores, reciben comisiones como vendedor más las de supervisor).

