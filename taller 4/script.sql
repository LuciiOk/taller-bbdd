-- ejercicio 1 --
select nombre from personas
join propiedades on rut = dueno
group by nombre having count (id_propiedad) > 1;

-- ejercicio 2 --
select provincias.provincia, t.tipo_propiedad, top.tipo_operacion, min(precio) as "precio minimo" from operaciones
inner join propiedades on propiedades.id_propiedad = operaciones.id_propiedad
inner join provincias on propiedades.provincia = provincias.id_provincia
inner join tipos_propiedades as t on t.id_tipo = propiedades.tipo_propiedad
inner join tipos_operaciones as top on top.id_tipooperacion = operaciones.tipo_operacion
group by provincias.provincia, t.tipo_propiedad, top.tipo_operacion;

-- ejercicio 3 --
select nombre
from personas 
inner join operaciones on personas.rut = comprador
inner join tipos_operaciones on (tipos_operaciones.id_tipooperacion = operaciones.tipo_operacion)
where tipos_operaciones.tipo_operacion = 'Alquiler'
group by nombre, rut
except
select nombre from personas
inner join propiedades on propiedades.dueno = personas.rut;
