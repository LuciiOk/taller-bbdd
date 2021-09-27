-- ejercicio 1 --
select to_char(fechaoperacion, 'MM-YYYY') as fecha, sum(precio) as total from operaciones where fechaoperacion is not null group by  to_char(fechaoperacion, 'MM-YYYY')
having sum(operaciones.precio) >= 
all( select sum(precio) 
	from operaciones  
	where fechaoperacion is not null 
	group by  to_char(fechaoperacion, 'MM-YYYY'));


-- ejercicio 2--
select to_char(fechaoperacion, 'MM-YYYY') as fecha, prov.provincia, sum(precio) as "total"	 
from operaciones
inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
inner join provincias as prov on (prov.id_provincia = prop.provincia)	 
where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
any
		(
		select to_char(fechaoperacion, 'MM-YYYY') from operaciones 
		where fechaoperacion is not null 
		group by  to_char(fechaoperacion, 'MM-YYYY')
		having sum(operaciones.precio) >= 
		all( select sum(precio) from operaciones  
			where fechaoperacion is not null 
			group by  to_char(fechaoperacion, 'MM-YYYY') )	 
	 	) group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia
having sum(precio) >= all
(
	select sum(precio) from operaciones
	inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
	inner join provincias as prov on (prov.id_provincia = prop.provincia)
	where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
	any
		(
			select to_char(fechaoperacion, 'MM-YYYY') from operaciones
			where fechaoperacion is not null
			group by to_char(fechaoperacion, 'MM-YYYY')
			having sum (precio) >= 
			all( select sum(precio) from operaciones  
				where fechaoperacion is not null 
				group by  to_char(fechaoperacion, 'MM-YYYY') )	 
	 	)group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia 
		);




-- ejercicio 3 --
select nombre as vendedor, sum(precio) as monto from operaciones as op
inner join vendedores as vend on op.vendedor = vend.id_vendedor
inner join propiedades as prop on op.id_propiedad = prop.id_propiedad
inner join provincias as prov on prop.provincia = prov.id_provincia
where op.fechaoperacion is not null 
and prov.provincia = all (
	select prov.provincia	 
	from operaciones
	inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
	inner join provincias as prov on (prov.id_provincia = prop.provincia)	 
	where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
	any
			(
			select to_char(fechaoperacion, 'MM-YYYY') from operaciones 
			where fechaoperacion is not null 
			group by  to_char(fechaoperacion, 'MM-YYYY')
			having sum(operaciones.precio) >= 
			all( select sum(precio) from operaciones  
				where fechaoperacion is not null 
				group by  to_char(fechaoperacion, 'MM-YYYY') )	 
			) group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia
	having sum(precio) >= all
	(
		select sum(precio) from operaciones
		inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
		inner join provincias as prov on (prov.id_provincia = prop.provincia)
		where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
		any
			(
				select to_char(fechaoperacion, 'MM-YYYY') from operaciones
				where fechaoperacion is not null
				group by to_char(fechaoperacion, 'MM-YYYY')
				having sum (precio) >= 
				all( select sum(precio) from operaciones  
					where fechaoperacion is not null 
					group by  to_char(fechaoperacion, 'MM-YYYY') )	 
			)group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia 
			)
)
and to_char(fechaoperacion, 'MM-YYYY') = all(select to_char(fechaoperacion, 'MM-YYYY') as fecha 
	from operaciones where fechaoperacion is not null group by  to_char(fechaoperacion, 'MM-YYYY')
		having sum(operaciones.precio) >= 
		all( select sum(precio) 
		from operaciones  
		where fechaoperacion is not null 
		group by  to_char(fechaoperacion, 'MM-YYYY')))
group by nombre having sum(op.precio) >= all(
	select sum(precio) as monto from operaciones as op
	inner join vendedores as vend on op.vendedor = vend.id_vendedor
	inner join propiedades as prop on op.id_propiedad = prop.id_propiedad
	inner join provincias as prov on prop.provincia = prov.id_provincia
		where op.fechaoperacion is not null 
		and prov.provincia = any(
			select prov.provincia	 
				from operaciones
				inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
				inner join provincias as prov on (prov.id_provincia = prop.provincia)	 
				where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
				any
						(
						select to_char(fechaoperacion, 'MM-YYYY') from operaciones 
						where fechaoperacion is not null 
						group by  to_char(fechaoperacion, 'MM-YYYY')
						having sum(operaciones.precio) >= 
						all( select sum(precio) from operaciones  
							where fechaoperacion is not null 
							group by  to_char(fechaoperacion, 'MM-YYYY') )	 
						) group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia
				having sum(precio) >= all
				(
					select sum(precio) from operaciones
					inner join propiedades as prop on (prop.id_propiedad = operaciones.id_propiedad)
					inner join provincias as prov on (prov.id_provincia = prop.provincia)
					where fechaoperacion is not null and to_char(fechaoperacion, 'MM-YYYY') = 
					any
						(
							select to_char(fechaoperacion, 'MM-YYYY') from operaciones
							where fechaoperacion is not null
							group by to_char(fechaoperacion, 'MM-YYYY')
							having sum (precio) >= 
							all( select sum(precio) from operaciones  
								where fechaoperacion is not null 
								group by  to_char(fechaoperacion, 'MM-YYYY') )	 
						)group by to_char(fechaoperacion, 'MM-YYYY'), prov.provincia 
						)
		) 
	   and to_char(op.fechaoperacion, 'MM/YYYY') = any (select to_char (fechaoperacion,'MM/YYYY') as fecha
			from operaciones
			where fechaoperacion is not null 
			group by fecha
			having sum(precio) >= all(
				select sum(precio) from operaciones
					   where fechaoperacion is not null
						group by to_char(operaciones.fechaoperacion , 'MM/YYYY')
				)
			) group by nombre
);