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
		INSERT INTO transacciones values (TG_TABLE_NAME, TG_OP, now(), user, camposInsertados, camposMod);
		return new;
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