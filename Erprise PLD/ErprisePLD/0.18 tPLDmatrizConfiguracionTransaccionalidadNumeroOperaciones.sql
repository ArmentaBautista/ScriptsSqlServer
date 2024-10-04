

if not exists(select name from sys.tables where name='tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones')
begin
	-- DROP TABLE tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
	create table [dbo].tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null , -- Numero Dep Mes Menores = 1,  Numero Ret Mes Menores = 2,
										-- Numero Dep Mes Mayores = 3,  Numero Ret Mes Mayores = 4,
										-- Numero Dep Mes Morales = 5,  Numero Ret Mes Morales = 6
		IdValor1		 INT NOT NULL ,
		IdValor2		 INT NULL ,
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones')

	SELECT 'Tabla Creada' AS info
END
GO

SELECT * FROM dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
