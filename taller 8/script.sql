-- creacion de la tabla transacciones --
DROP TABLE IF EXISTS transacciones; 
create table transacciones(
	tabla varchar not null,
	accion varchar not null,
	fechaHora timestamp not null,
	usuario varchar not null,
	camposInsertados varchar,
	camposModificados varchar
);

-- funcion trigger --
create or replace function auditoria() returns trigger as 
$$
	declare 
		camposInsertados varchar;
		camposMod varchar;
	begin
		camposMod := concat(old.*);
		camposInsertados := concat(new.*);
		if TG_OP = 'DELETE' then
			INSERT INTO transacciones values (TG_TABLE_NAME, TG_OP, now(), user, null, camposMod);
			return old;
		end if;
		if TG_OP = 'INSERT' then
			INSERT INTO transacciones values (TG_TABLE_NAME, TG_OP, now(), user, camposInsertados, null);
			return new;
		end if;
		if TG_OP = 'UPDATE' then
			INSERT INTO transacciones values (TG_TABLE_NAME, TG_OP, now(), user, camposInsertados, camposMod);
			return new;
		end if;
		return null;
	end;
$$ language plpgsql;

-- creacion del trigger para las propiedades --
DROP TRIGGER IF EXISTS tr_mod_propiedades ON propiedades;
create trigger tr_mod_propiedades after update or insert or delete
	on propiedades
	for each row
	execute procedure auditoria();

-- creacion del trigger para las operaciones --
DROP TRIGGER IF EXISTS tr_mod_operaciones ON operaciones;
create trigger tr_mod_operaciones after update or insert or delete
	on operaciones
	for each row
	execute procedure auditoria();

select * from transacciones;

-- ejercicio 2 --
--creación tabla ventasxmes
DROP TABLE if exists ventasxmes;
create table ventasxmes(
	mesAnio varchar not null,
	vendedor varchar not null,
	tipo_transaccion varchar not null,
	cant_transaccion integer,
	monto_transaccion integer
);

-- funcion trigger sumarizacion
create or replace function sumarizacion() returns trigger as
$$
	declare 
		vended varchar;
		tipo varchar;
	begin
		vended := nombre from vendedores where id_vendedor = new.vendedor;
		tipo := tipo_operacion from tipos_operaciones where id_tipooperacion = new.tipo_operacion;
		if exists (select * from ventasxmes 
				   where ventasxmes.vendedor = vended and mesAnio = to_char(new.fechaoperacion, 'MM-YYYY') and tipo = tipo_transaccion) then
			update ventasxmes 
				set monto_transaccion = new.precio + monto_transaccion, cant_transaccion = cant_transaccion + 1 -- se aumenta el monto de la transaccion por mes y la cantidad de transaccion
				where vendedor = vended and mesAnio = to_char(new.fechaoperacion, 'MM-YYYY') and  tipo_transaccion = tipo;
		else 
			insert into ventasxmes (mesAnio,vendedor,tipo_transaccion,cant_transaccion,monto_transaccion)
				values(to_char(new.fechaoperacion, 'MM-YYYY'),vended,tipo, 1, new.precio);
		end if;
		return new;	
	end;
$$ language plpgsql;

-- creacion del trigger para la tabla de operaciones de sumarizacion
create trigger upd_precios 
	after update or insert 
	on operaciones
	for each row
	execute procedure sumarizacion();

select * from ventasxmes;
insert into operaciones(id_propiedad, fechaalta, tipo_operacion, precio, fechaoperacion, vendedor, comprador) 
values(106, '23-11-2021'::date, 1, 1, now(), 3,  '28883432-6');

update operaciones 
	set precio = 1
	where comprador = '28883432-6' and tipo_operacion = 1;

-- ejercicio 3 --
create or replace function validarPropiedad() returns trigger as
$$	
	declare
		provinc varchar;
		tipo varchar;
	begin
		provinc :=  provincia from provincias where new.provincia = id_provincia;
		tipo :=  tipo_propiedad from tipos_propiedades where new.tipo_propiedad = id_tipo;
		
		if (provinc = 'Lleida' and tipo = 'Parking' and new.superficie < 100) then	
			raise exception 'La superficie minima para parking en Lleida es de 100.';
		elsif (provinc = 'Tarragona' and tipo = 'Casa' and new.superficieconstruida > new.superficie * 3) then
			raise exception 'La superficie maxima construida para casa en Tarragona es 3 veces la del suelo.';
		elsif (provinc = 'Girona' and tipo = 'Suelo' and new.superficie < 200) then
			raise exception 'La superficie minima para Suelo en Girona es de 200.';
		elsif (provinc = 'Barcelona' and new.superficieconstruida > new.superficie * 2 )then
			raise exception 'La superficie construida maxima en barcelona es el doble del terreno.';
		elsif (tipo = 'Industrial' and new.superficie < 500) then
			raise exception 'La superficie minima para propiedades Industrial es de 500.';
		end if;
		return new;
	end;
$$ language plpgsql;

-- creacion del trigger de validacion --
drop trigger if exists validar_propiedad on propiedades;
create trigger validar_propiedad before 
	insert on propiedades
	for each row
	execute procedure validarPropiedad();

insert into propiedades(tipo_propiedad, provincia, superficie, superficieconstruida, dueno) values(5, 1, 1, 4, '48479320-4');
select * from propiedades where tipo_propiedad = 5 and  provincia = 1 and superficie = 1 and superficieconstruida = 3 and dueno = '48479320-4'











