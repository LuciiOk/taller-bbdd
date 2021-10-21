# Taller 8: TRIGGERS

### Objetivo:
Manejo de Triggers.

### Realice  los siguientes triggers:

1.- Triggers de Auditoría: Cree una tabla llamada “transacciones” que contenga los campos “tabla”, “accion”, “fecha-hora”, “usuario” , “camposinsertados” y “camposmodificados”. En dicha tabla se almacenará en forma automática usando un triggers cada acción que se realice sobre las tabla “propiedades” y  “operaciones”. (camposinsertdos y camposmodificados es un string donde almacena los  valores nuevos o antiguos separados por coma)
   

2.- Triggers de Sumarización: Realice una tabla llamada “ventasxmes” que contenga los siguientes campos: mes-año, vendedor, transacción (venta o arriendo), cantidad de transacciones, montototaltransacciones. Dicha tabla deberá irse modificando mediante triggers cada vez que se realice una transacción sobre la tabla “operaciones” (se realice una nueva venta / arriendo, o se cancele (modifique) una venta / arriendo.


3.- Triggers de validación: Realice triggers que permitan validar que se cumplan las siguientes restricciones dados por los planes reguladores de cada provincia a todos los nuevos registros: 

| Provincia | Tipo Propiedad | Restricción                                      |
|-----------|-------------|---------------------------------------------------  |
| Lleida    | Parking     | Superficie mínima 100                               | 
| Taragona  | Casa        | Superficie construida <= 3 veces superficie suelo   |
| Girona    | Suelo       | Superficie mínima 200                               |
| Barcelona | Todas       | Superficie construida no puede exceder doble terreno|
| Todas     | Industrial  | Superficie mínima 500                               |
		
_Ayuda: Le podrá ser útil las variables del sistema USER, TG_OP, TG_TABLENAME y la función now()._
