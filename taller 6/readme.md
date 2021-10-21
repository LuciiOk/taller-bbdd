# Taller 6: PgPlsql - FUNCIONES QUE RETORNAN ESCALARES

### Objetivo:
Manejo de Procedimientos Almacenados (Funciones) – lenguaje pgplsql

### Desarrollo:
- En el documento anexo se describe el algoritmo usado por el Registro Civil para el cálculo del Dígito Verificador de Patentes de Vehículos Motorizados

### Realice Una función en lenguaje  PlpgSQL, llamada _“DVPATENTE”_ que:

Reciba como parámetro una patente de vehículo motorizado emitida en Chile sin su dígito verificador,, y retorne el dígito verificador que le corresponde a dicha patente:


### La función debe validar:
-	Formato correcto de ingreso de datos. Recuerde que puede ser patente de Motocicleta, de Vehículo antiguo (2 letras y 4 dígitos), o vehículo nuevo (4 letras 2 dígitos)
-	Que las letras ingresadas sean válidas (por ejemplo, si es patente nueva no debe contener vocales).


### Debe entregar:
-	Script para la creación de la función solicitada (si usa funciones separada, entregar el script de creación de todas las funciones)
-	Si utiliza algún objeto adicional (por ejemplo tabla temporal), entregar script de creación y carga de dicho objeto
