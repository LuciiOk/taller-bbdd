-- ejercicio 1 -- 
set datestyle to 'SQL', DMY;
select CONCAT('Hoy es ', now()::date) as "ejercicio 1";

-- ejercicio 2 --
select fechaalta, tipo_operacion, precio, fechaoperacion, provincias.provincia from operaciones
inner join vendedores on vendedores.id_vendedor = vendedor
inner join propiedades on  propiedades.id_propiedad = operaciones.id_propiedad
inner join provincias on propiedades.provincia = id_provincia
where vendedores.nombre = 'Luisa' order by provincias.provincia, fechaalta, fechaoperacion;

-- ejercicio 3 --
select 
CASE
	when vendedores.id_supervisor is not null then CONCAT('El vendedor ', vendedores.nombre, ' es supervisado por ', v.nombre)
	when vendedores.id_supervisor is null then CONCAT('El vendedor ', vendedores.nombre, ' NO tiene supervisor') 
END as "ejercicio numero cuatro"
from vendedores left join vendedores as v on vendedores.id_supervisor = v.id_vendedor;

-- ejercicio 4 --
select  fechaalta,nombre, precio,
CASE 
	WHEN tipop.tipo_operacion = 'Alquiler' then precio * 0.1
	WHEN tipop.tipo_operacion = 'Venta' then precio * 0.07
END	as comision from operaciones
inner join vendedores on (operaciones.vendedor = id_vendedor)
inner join tipos_operaciones tipop on (operaciones.tipo_operacion = id_tipooperacion)
where fechaalta
between '2005-02-18' and '2005-02-20';