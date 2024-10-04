




IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionProductosServicios')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionProductosServicios
	
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

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionProductosServicios')

	SELECT 'Tabla Creada' AS info
END
GO

