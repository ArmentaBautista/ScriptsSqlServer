
USE iERP_DRA_TEST
go

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionTipoPersona')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionTipoPersona
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tPLDmatrizConfiguracionTipoPersona]
(
	Id 				int NOT NULL PRIMARY KEY IDENTITY,
	TipoPersona		INT NOT null DEFAULT 1 CHECK (TipoPersona IN (1,2,3)) UNIQUE,
	Puntos			NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			DATETIME NOT NULL default GetDate(),
	IdEstatus 		int NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: