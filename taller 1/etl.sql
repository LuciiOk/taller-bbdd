-- creacion de una tabla temporal para la carga desde el archivo CSV --
create table Temporal (
	referencia smallint,
	fechaalta date,
	tipoPropiedad varchar(20),
	tipoOperacion varchar(40),
	provincia varchar(20),
	superficie smallint,
	construidos smallint,
	precioventa int,
	fechaventa date,
	vendedor varchar(30),
	supervisor varchar(30),
	dueno varchar(100),
	rutdueno varchar(15),
	celular varchar(15),
	email varchar(150),
	comprador varchar(40),
	rutComprador varchar(15)
);

-- carga de datos --
copy temporal from 'C:\Users\lport\Desktop\inmuebles.csv'
CSV delimiter ',' header encoding 'Latin1';

-- normalizacion de tipos operacion --
update temporal set tipooperacion = 'Venta' where tipooperacion = 'venta';

-- insertar datos en tabla provincias con provinicias de tabla temporal --
insert into provincias (provincia) 
select distinct provincia from temporal;

-- insertar vendedores en tabla vendedores --
insert into vendedores (nombre) 
select distinct vendedor from temporal where vendedor is not null;

-- insertar datos en tipo_propiedades con tipopropiedades --
insert into tipos_propiedades (tipo_propiedad) 
select distinct tipopropiedad from temporal;

-- insertar datos de tipo operacion en tabla tipo_operaciones --
insert into tipos_operaciones (tipo_operacion) 
select distinct tipooperacion from temporal;

-- insertar datos en tabla personas con dueños... --
insert into personas (rut, nombre, celular, email) 
select distinct rutdueno,dueno,celular, email from temporal;

--insertar datos en personas con comprado/arrendador --
insert into personas (rut, nombre) 
select distinct rutcomprador,comprador from temporal where rutcomprador not in (select rut from personas);

-- insertar datos en tabla propiedades --
insert into propiedades (superficie, superficieconstruida, dueno, tipo_propiedad, provincia) 
select distinct tempo.superficie, tempo.construidos, rutdueno, tipo.id_tipo, prov.id_provincia from temporal as tempo
inner join tipos_propiedades as tipo on tempo.tipopropiedad = tipo.tipo_propiedad
inner join provincias as prov on tempo.provincia = prov.provincia;

-- insertar datos operaciones en tabla operaciones --
insert into operaciones (fechaalta, fechaoperacion, precio, id_propiedad, tipo_operacion, vendedor, comprador)
select fechaalta, fechaventa, precioventa, prop.id_propiedad, oper.id_tipooperacion, vend.id_vendedor, rutcomprador from temporal as tempo
inner join propiedades as prop on (prop.superficie = tempo.superficie and prop.dueno = rutdueno)
inner join tipos_operaciones as oper on tempo.tipooperacion = oper.tipo_operacion
left join vendedores as vend on tempo.vendedor = nombre  order by fechaalta;

drop table temporal cascade;

