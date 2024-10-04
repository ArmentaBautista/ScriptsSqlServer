

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionSucursales')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionSucursales
	CREATE TABLE [dbo].tPLDmatrizConfiguracionSucursales
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null DEFAULT 1, -- Sucursal del Socio
		IdValor			 INT NOT NULL UNIQUE,
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 1,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) 

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionSucursales')

	SELECT 'Tabla existente tPLDmatrizConfiguracionSucursales' AS info	

END
GO
