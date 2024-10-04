
-- 0.24 tPLDmatrizConfiguracionPagoAnticipado

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionPagoAnticipado')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionPagoAnticipado
	CREATE TABLE [dbo].tPLDmatrizConfiguracionPagoAnticipado
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null , -- Abono = 1,  Liquidación = 2
		IdValor1		 INT NOT NULL ,
		IdValor2		 INT NULL ,
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) 

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionPagoAnticipado')

	SELECT 'Tabla existente tPLDmatrizConfiguracionPagoAnticipado' AS info	
END
GO

/********  JCA.31/3/2024.19:31 Info: Insert de Datos Iniciales  ********/
if (select count(1) from dbo.tPLDmatrizConfiguracionPagoAnticipado)<=2
	truncate table dbo.tPLDmatrizConfiguracionPagoAnticipado
go

insert into dbo.tPLDmatrizConfiguracionPagoAnticipado (Tipo, IdValor1, IdValor2, ValorDescripcion, Puntos)
values
(1, 1,  25, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 1.05),
(1, 26, 74, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 5.25),
(1, 75, 100, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 10.50),
(2, 1, 85, 'Porcentaje del Monto del Crédito Liquidado Anticipadamente', 10.50),
(2, 86, 100, 'Porcentaje del Monto del Crédito Liquidado Anticipadamente', 1.05)
GO
 
 SELECT * FROM tPLDmatrizConfiguracionPagoAnticipado
 GO