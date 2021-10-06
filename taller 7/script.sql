-- ejercicio 1 --
create type propiedades_disponibles as (
	tipoprop character varying(30),
	tipoopera character varying(30),
	provincia character varying(50),
	tamconstruido integer,
	tamterreno integer,
	precio integer
);

create or replace function propiedadDisponibles(tipopropiedad varchar, tipooperacion varchar, provincia varchar, minconstruido integer, minterreno integer, preciomax integer) 
returns setof propiedades_disponibles as 
$$
declare
	micursor cursor for (
		select tipoprop.tipo_propiedad, tipoop.tipo_operacion, prov.provincia, prop.superficieconstruida, prop.superficie, op.precio 
		from operaciones as op
		inner join tipos_operaciones as tipoop on op.tipo_operacion = tipoop.id_tipooperacion
		inner join propiedades as prop on op.id_propiedad = prop.id_propiedad
		inner join provincias as prov on prop.provincia = prov.id_provincia
		inner join tipos_propiedades as tipoprop on prop.tipo_propiedad = tipoprop.id_tipo
		where comprador is null);
	propiedades propiedades_disponibles;
	flags boolean;
begin
	open micursor;
		loop
			flags := true;
			fetch next from micursor into propiedades;
			exit when not found;
			
			if (lower(propiedades.provincia) not similar to lower(provincia)) then
				flags := false;
			end if;
			if (lower(propiedades.tipoopera) not similar to lower(tipooperacion)) then
				flags := false;
			end if;
			if (lower(propiedades.tipoprop) not similar to lower(tipopropiedad)) then
				flags := false;
			end if;
			if (propiedades.tamconstruido is null or propiedades.tamconstruido < minconstruido) then
				flags := false;
			end if;
			if (propiedades.tamterreno is null or propiedades.tamterreno < minterreno) then
				flags := false;
			end if;
			if (propiedades.precio is null or  propiedades.precio > preciomax) then
				flags := false;
			end if;
			
			if (flags = true) then
				return next propiedades;
			end if;
		end loop;
	close micursor;
end;
$$ language plpgsql;

select * from propiedadDisponibles('casa', 'alquiler', 'barcelona', 0, 0, 2000000);

-- ejercicio 2 --
create type comisiones as (
	fechaalta date,
	vendedor varchar,
	precio integer,
	tipo varchar,
	comision numeric
);

create type vendedor as (
	vendedor varchar,
	comision numeric
);

create or replace function ComisionesAPagar(fechaInicio date, fechaFin date)
returns  setof comisiones as 
$$
declare
	micursor cursor for
		(
			select fechaalta, vendedores.nombre, precio, tipop.tipo_operacion
			from operaciones
			inner join vendedores on operaciones.vendedor = id_vendedor
			inner join tipos_operaciones tipop on (operaciones.tipo_operacion = id_tipooperacion)
		);
	reg comisiones;
begin
	open micursor;
		loop	
			fetch next from micursor into reg;
			exit when not found;
			if(reg.fechaalta between fechaInicio and fechaFin) then
			
				if(reg.tipo similar to 'Venta') then
					reg.comision := (reg.precio * 0.04) + (reg.precio * 0.02);
				end if;
				if(reg.tipo similar to 'Alquiler') then
					reg.comision := (reg.precio * 0.08) + (reg.precio * 0.01);
				end if;
				return next reg;
			end if;
		end loop;
	close micursor;
end;
$$ language plpgsql;

select * from ComisionesAPagar('2004-09-10', '2004-09-11');