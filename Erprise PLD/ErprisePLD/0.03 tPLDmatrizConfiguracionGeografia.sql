



IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionGeografia')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionGeografia
	CREATE TABLE [dbo].[tPLDmatrizConfiguracionGeografia]
	(
		Id 				INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			INT NOT NULL DEFAULT 4, -- Asentamiento=1, Ciudad=2, Municipio=3, Estado=4, Pais=5, Nacionalidad=6
		IdUbicacion		INT NOT NULL ,
		Descripcion		VARCHAR(128) NULL,
		Puntos			NUMERIC(5,2) NOT NULL DEFAULT 0,
		Alta			DateTime	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		int NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionGeografia')

END
GO
