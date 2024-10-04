



IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionIngresos')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionIngresos
	CREATE TABLE [dbo].tPLDmatrizConfiguracionIngresos
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null DEFAULT 4, --  RangoPF=2, RangoPM=3
		IdValor1		 INT NOT NULL ,
		IdValor2		 INT NULL ,
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionIngresos')
END
GO

