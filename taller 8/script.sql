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

insert into propiedades (superficie, superficieconstruida, dueno, tipo_propiedad, provincia) select 250, 100, '20319956-2', 2, 3;
update propiedades set superficie = 230 where dueno = '20319956-2' and tipo_propiedad = 2;

delete from propiedades where dueno = '20319956-2';

select * from transacciones;

-- ejercicio 2 --
--creación tabla ventasxmes
--creación tabla ventasxmes
DROP TABLE if exists ventasxmes;
create table ventasxmes(
	mesAnio timestamp not null,
	vendedor varchar not null,
	transaccion varchar not null,
	cant_transaccion varchar,
	monto_transaccion varchar
);


--funcion trigger
create or replace function sumarizacion() returns trigger as
$$
	begin
		insert into ventasxmes (mesAnio,vendedor,transaccion,cant_transaccion,monto_transaccion)
			values(now(),current_user,new.tipo_operacion,new.id_propiedad,new.precio);
		return(new);	
	end;
$$
language plpgsql;

create trigger upd_precios after update on operaciones
	for each row
	execute procedure sumarizacion();

update operaciones set precio = '43432'
where id_propiedad = '29' and comprador ='28883432-6';

select * from operaciones where id_propiedad='29'; 
select * from ventasxmes;

-- ejercicio 3 --
drop function  if exists validarPropiedad cascade;
create or replace function validarPropiedad() returns trigger as
$$	
	declare
		provinc varchar;
		tipo varchar;
	begin
		provinc :=  provincia from provincias where new.provincia = id_provincia;
		tipo :=  tipo_propiedad from tipos_propiedades where new.tipo_propiedad = id_tipo;

		if (provinc = 'Lleida' and tipo = 'Parking' and new.superficie >= 100) then	
			return new;
		elsif (provinc = 'Tarragona' and tipo = 'Casa' and new.superficieconstruida <= new.superficie) then
			return new;
		elsif (provinc = 'Girona' and tipo = 'Suelo' and new.superficie >= 200) then
			return new;
		elsif (provinc = 'Barcelona' and new.superficieconstruida <= new.superficie * 2 )then
			return new;
		elsif (tipo = 'Industrial' and new.superficie >= 500) then
			return new;
		else 
			raise exception 'El registro ingresado no cumple con las restricciones establecidas por los reguladores.';
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

insert into propiedades (superficie, superficieconstruida, dueno, tipo_propiedad, provincia) values (500, 40, '20319956-2', 1, 2);




