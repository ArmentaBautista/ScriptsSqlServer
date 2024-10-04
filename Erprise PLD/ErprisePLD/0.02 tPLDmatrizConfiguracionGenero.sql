


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionGenero')
BEGIN
	
	-- DROP TABLE tPLDmatrizConfiguracionGenero

		CREATE TABLE [dbo].tPLDmatrizConfiguracionGenero
		(
			Id 				int NOT NULL PRIMARY KEY IDENTITY,
			Genero			CHAR(1) NOT null DEFAULT '' CHECK (Genero IN ('M','F')) UNIQUE,
			Descripcion		VARCHAR(24) NOT NULL,
			Puntos			NUMERIC(5,2) NOT NULL DEFAULT 0,
			Alta			DATETIME NOT NULL default GetDate(),
			IdEstatus 		int NOT NULL DEFAULT 1
		) ON [PRIMARY]

		INSERT INTO tPLDobjetosModulo(Nombre) 
		SELECT 'tPLDmatrizConfiguracionGenero'

		SELECT 'Tabla Creada' AS info
END
GO

