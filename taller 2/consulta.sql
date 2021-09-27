select fechaalta, tprop.tipo_propiedad, top.tipo_operacion, prov.provincia,
prop.superficie, prop.superficieconstruida, operaciones.precio, operaciones.fechaoperacion, vend.nombre as vendedor, v.nombre as supervisor,
dueno.rut, dueno.nombre, dueno.celular, dueno.email, compr.nombre as comprador, compr.rut as rutcomprador
from operaciones
inner join propiedades as prop on operaciones.id_propiedad = prop.id_propiedad 
inner join tipos_operaciones as top on operaciones.tipo_operacion = top.id_tipooperacion
inner join tipos_propiedades as tprop on  prop.tipo_propiedad = tprop.id_tipo
inner join provincias as prov on prop.provincia = prov.id_provincia
left join vendedores as vend on operaciones.vendedor = vend.id_vendedor
left join vendedores as v on vend.id_supervisor = v.id_vendedor
inner join personas as dueno on dueno.rut = prop.dueno
left join personas as compr on compr.rut = operaciones.comprador
order by fechaalta, tprop.tipo_propiedad, top.tipo_operacion


select fechaalta, tipopropiedad, tipooperacion, provincia, superficie, construidos, precioventa, fechaventa, vendedor, supervisor, rutdueno, dueno, celular, email, comprador, rutcomprador
from temporal order by fechaalta, tipopropiedad, tipooperacion


copy (select fechaalta, tprop.tipo_propiedad, top.tipo_operacion, prov.provincia,
prop.superficie, prop.superficieconstruida, operaciones.precio, operaciones.fechaoperacion, vend.nombre as vendedor, v.nombre as supervisor,
dueno.rut, dueno.nombre, dueno.celular, dueno.email, compr.nombre as comprador, compr.rut as rutcomprador
from operaciones
inner join propiedades as prop on operaciones.id_propiedad = prop.id_propiedad 
inner join tipos_operaciones as top on operaciones.tipo_operacion = top.id_tipooperacion
inner join tipos_propiedades as tprop on  prop.tipo_propiedad = tprop.id_tipo
inner join provincias as prov on prop.provincia = prov.id_provincia
left join vendedores as vend on operaciones.vendedor = vend.id_vendedor
left join vendedores as v on vend.id_supervisor = v.id_vendedor
inner join personas as dueno on dueno.rut = prop.dueno
left join personas as compr on compr.rut = operaciones.comprador
order by fechaalta, tprop.tipo_propiedad) to 'C:\Users\lport\Desktop\hola.csv' (format CSV)



