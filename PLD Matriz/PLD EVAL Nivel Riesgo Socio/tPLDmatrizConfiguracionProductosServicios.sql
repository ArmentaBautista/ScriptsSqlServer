

USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionProductosServicios')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionProductosServicios
	SELECT 'Tabla existente tPLDmatrizConfiguracionProductosServicios' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tPLDmatrizConfiguracionProductosServicios
(
	Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
	Tipo			 INT NOT null , -- Productos = 1,  Servicios = 2,
	IdValor1		 INT NOT NULL ,
	IdValor2		 INT NULL ,
	ValorDescripcion VARCHAR(256) NULL,
	Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		 INT NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: