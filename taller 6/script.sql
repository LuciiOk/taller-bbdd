-- cracion de tablas --
drop table if exists viejos cascade;
create table viejos (
	serie varchar,
	digitos varchar
);
drop table if exists nuevos cascade;
create table nuevos (
	serie varchar,
	digitos varchar
);
drop table if exists motos cascade;
create table motos (
	serie varchar,
	digitos varchar
);

-- insersion de datos en las tablas --
copy viejos from 'C:\Users\lport\Desktop\scripts\taller 6\antiguas.csv'
	CSV delimiter ',' header encoding 'Latin1';

copy nuevos from 'C:\Users\lport\Desktop\scripts\taller 6\nuevos.csv'
	CSV delimiter ',' header encoding 'Latin1';
	
copy motos from 'C:\Users\lport\Desktop\scripts\taller 6\motos.csv'
	CSV delimiter ',' header encoding 'Latin1';

-- IMPLEMENTACION FUNCIONES --
-- FORMATO AA.1000 --
CREATE or replace FUNCTION VIEJA(patente char) RETURNS char as
$$	DECLARE 
	convertir varchar;
	serieNumero varchar;
	
	numero integer;
	suma integer;
	mult integer;
	residuo integer;
	digito integer;
	divill integer;
	dv char;
	BEGIN

	convertir :=  digitos from viejos where serie = substring(patente, 1,2);
	serienumero := concat(convertir, substring(patente, 3,6));
	
	suma := 0;
	numero := serieNumero::integer;
	mult := 2;
	while (numero <> 0) loop
		digito := numero % 10;
		numero := (numero / 10)::integer;
		
		suma := suma + (digito *mult);
		mult := (mult + 1);
		if (mult = 8) then 
			mult := 2;
		end if;
	end loop;
	
	if (11 - mod(suma,11) = 11) then
		return '0';
	end if;
	if (11 - mod(suma,11) = 10) then
		return 'k';
	end if;
	if ( 11 - mod(suma,11) < 10) then
		return 11 - mod(suma,11);
	end if;
	END;
$$ LANGUAGE plpgsql;

-- FORMATO AAAA.DD --
CREATE or replace FUNCTION NUEVOS(patente char) returns char as
$$  DECLARE 
		convertir varchar;
		convertir2 varchar;
		serieNumero varchar;
		
		numero integer;
		suma integer;
		mult integer;
		residuo integer;
		digito integer;
		divill integer;
		dv char;
	BEGIN
	-- se reemplazan los valores --
	convertir := digitos from nuevos where serie = substring(patente,1,1); 
	convertir2 := concat(convertir2, convertir);
	convertir := digitos from nuevos where serie = substring(patente,2,1); 
	convertir2 := concat(convertir2, convertir);
	convertir := digitos from nuevos where serie = substring(patente,3,1); 
	convertir2 := concat(convertir2, convertir);
	convertir := digitos from nuevos where serie = substring(patente,4,1); 
	convertir2 := concat(convertir2, convertir);
	serieNumero := concat(convertir2,substring(patente,5,6));
	-- algoritmo digito verificador --
	suma := 0;
	numero := serieNumero::integer;
	mult := 2;
	while (numero <> 0) loop
		digito := numero % 10;
		numero := (numero / 10)::integer;
		
		suma := suma + (digito *mult);
		mult := (mult + 1);
		if (mult = 8) then 
			mult := 2;
		end if;
	end loop;
	
	if (11 - mod(suma,11) = 11) then
		return '0';
	end if;
	if (11 - mod(suma,11) = 10) then
		return 'k';
	end if;
	if ( 11 - mod(suma,11) < 10) then
		return 11 - mod(suma,11);
	end if;
	return serieNumero;
	END
$$ LANGUAGE plpgsql;

-- FORMATO AAA-BBB
CREATE or replace FUNCTION motos(patente char) returns char as
$$  DECLARE 
		convertir varchar;
		convertir2 varchar;
		serieNumero varchar;
		-- variables para algoritmo --
		numero integer;
		suma integer;
		mult integer;
		residuo integer;
		digito integer;
		divill integer;
		dv char;
	BEGIN
	convertir := digitos from motos where serie = substring(patente,1,1); 
	convertir2 := concat(convertir2, convertir);
	convertir := digitos from motos where serie = substring(patente,2,1); 
	convertir2 := concat(convertir2, convertir);
	convertir := digitos from motos where serie = substring(patente,3,1); 
	convertir2 := concat(convertir2, convertir);
	convertir2 := concat(convertir2, 0);
	serieNumero := concat(convertir2,substring(patente,4,5));
	
	-- algoritmo digito verificador --
	suma := 0;
	numero := serieNumero::integer;
	mult := 2;
	while (numero <> 0) loop
		digito := numero % 10;
		numero := (numero / 10)::integer;
		
		suma := suma + (digito *mult);
		mult := (mult + 1);
		if (mult = 8) then 
			mult := 2;
		end if;
	end loop;
	
	if (11 - mod(suma,11) = 11) then
		return '0';
	end if;
	if (11 - mod(suma,11) = 10) then
		return 'k';
	end if;
	if ( 11 - mod(suma,11) < 10) then
		return 11 - mod(suma,11);
	end if;
	END;
$$ LANGUAGE plpgsql;

-- funcion principal --
CREATE or replace FUNCTION DVPATENTE (patente char) RETURNS char as
$$
	BEGIN
	-- patron de vehiculos viejos --
	IF (upper(patente) SIMILAR TO '[A-Z][A-Z][0-9]{4}') THEN
		return VIEJA(upper(patente));
	END IF;
	
	-- patron de vehiculos nuevos --
	IF (upper(patente) SIMILAR TO '[BCDFGHJKLPRSTVWXYZ]{4}[0-9][0-9]') THEN
		return NUEVOS(upper(patente));
	END IF;

	-- patron de motos --
	IF (upper(patente) SIMILAR TO '[BCDFGHJKLPRSTVWXYZ]{3}[0-9][0-9]') THEN
		return MOTOS(upper(patente));
	END IF;
	return 'No es una patente valida';
	END;
$$ LANGUAGE plpgsql;

-- la patente debe ser ingresada sin puntos --
select DVPATENTE('AA4545');
