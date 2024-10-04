
USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionEdades')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionEdades
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tPLDmatrizConfiguracionEdades]
(
	Id 				int NOT NULL PRIMARY KEY IDENTITY,
	Edad			INT NOT null DEFAULT 0,
	Puntos			NUMERIC(5,2) DEFAULT 0,
	Alta			DateTime default GetDate(),
	IdEstatus 		int NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:


