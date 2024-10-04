

USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionTransaccionalidad')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionTransaccionalidad
	SELECT 'Tabla existente tPLDmatrizConfiguracionTransaccionalidad' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tPLDmatrizConfiguracionTransaccionalidad
(
	Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
	Tipo			 INT NOT null , -- Monto Dep Mes Menores = 1,  Monto Ret Mes Menores = 2,
									-- Monto Dep Mes Mayores = 3,  Monto Ret Mes Mayores = 4,
									-- Monto Dep Mes Morales = 5,  Monto Ret Mes Morales = 6
	IdValor1		 INT NOT NULL ,
	IdValor2		 INT NULL ,
	ValorDescripcion VARCHAR(128) NULL,
	Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		 INT NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: