


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionEdades')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionEdades

	CREATE TABLE [dbo].[tPLDmatrizConfiguracionEdades]
	(
		Id 				int NOT NULL PRIMARY KEY IDENTITY,
		Edad			INT NOT null DEFAULT 0,
		Puntos			NUMERIC(5,2) DEFAULT 0,
		Alta			DateTime default GetDate(),
		IdEstatus 		int NOT NULL DEFAULT 1
	) ON [PRIMARY]

	INSERT INTO tPLDobjetosModulo(Nombre) VALUES('tPLDmatrizConfiguracionEdades')

	SELECT 'Tabla Creada' AS info	
END
GO

select
    *
from dbo.tPLDmatrizConfiguracionEdades
