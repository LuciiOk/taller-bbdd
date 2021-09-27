CREATE TABLE Dueno (
	Rut varchar(11) NOT NULL UNIQUE,
	nombre varchar(30) NOT NULL,
	apellidos varchar(30) NOT NULL,
	email varchar(30) NOT NULL,
	celular char(13) NOT NULL,
	
	PRIMARY KEY (RUT)
);

CREATE TABLE Comprador (
	Rut varchar(11) NOT NULL UNIQUE,
	nombre varchar(30) NOT NULL,
	apellidos varchar(30) NOT NULL,
	idVenta int,
	
	PRIMARY KEY (Rut)
);

CREATE TABLE Vendedor (
	idVendedor int NOT NULL UNIQUE ,
	nombre varchar(30) NOT NULL,
	apellidos varchar(30) DEFAULT '',
	idSupervisor int,
	
	PRIMARY KEY (idVendedor),
	FOREIGN KEY (idSupervisor) REFERENCES Vendedor(idVendedor) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Provincia (
	idProvincia smallint UNIQUE,
	nombre varchar(30) NOT NULL,
	
	PRIMARY KEY (idProvincia)
);

CREATE TABLE TipoPropiedad (
	idTipoPropiedad smallint UNIQUE,
	tipo varchar(10) NOT NULL,
	
	PRIMARY KEY (idTipoPropiedad)
);

CREATE TABLE Propiedad (
	idPropiedad smallint NOT NULL UNIQUE,
	superficie smallint NOT NULL,
	construidos smallint DEFAULT 0,
	idTipoPropiedad smallint NOT NULL,
	idProvincia smallint NOT NULL,
	rutDueno varchar(11) NOT NULL,
	
	PRIMARY KEY (idPropiedad),
	FOREIGN KEY (idTipoPropiedad) REFERENCES TipoPropiedad(idTipoPropiedad) ON UPDATE  CASCADE ON DELETE  CASCADE,
	FOREIGN KEY (idProvincia) REFERENCES Provincia(idProvincia) ON UPDATE  CASCADE  ON DELETE  CASCADE,
	FOREIGN KEY (rutDueno) REFERENCES Dueno(Rut) ON UPDATE  CASCADE ON DELETE  CASCADE
);

CREATE TABLE Operacion (
	idOperacion int NOT NULL UNIQUE,
	fechaAlta date NOT NULL,
	tipo varchar(10) NOT NULL,
	idPropiedad int,
	idVendedor int,
	
	PRIMARY KEY (idOperacion),
	FOREIGN KEY (idPropiedad) REFERENCES Propiedad(idPropiedad) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Venta(
	idVenta int NOT NULL UNIQUE,
	fechaVenta date NOT NULL,
	precioVenta int NOT NULL check (precioVenta > 0),
	idOperacion int,
	rutComprador varchar(11),

	PRIMARY KEY (idVenta),
	FOREIGN KEY (idOperacion) REFERENCES Operacion(idOperacion) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (rutComprador) REFERENCES Comprador(Rut) ON UPDATE SET NULL ON DELETE SET NULL
);