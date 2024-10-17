SELECT * FROM tPLDmatrizConfiguracionPagoAnticipado

--TRUNCATE TABLE tPLDmatrizConfiguracionPagoAnticipado

--INSERT INTO tPLDmatrizConfiguracionPagoAnticipado ( [Tipo], [IdValor1], [IdValor2], [ValorDescripcion], [Puntos], [Alta], [IdEstatus])
--VALUES
--( 1, 0, 0, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 1.0500, N'2024-04-07T03:25:02.773', 1 ),
--( 1, 0, 74, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 5.2500, N'2024-04-07T03:25:02.773', 1 ),
--( 1, 75, 100, 'Porcentaje del Monto del Crédito Abonado Anticipadamente', 10.5000, N'2024-04-07T03:25:02.773', 1 ),
--( 2, 1, 85, 'Porcentaje del Monto del Crédito Liquidado Anticipadamente', 10.5000, N'2024-04-07T03:25:02.773', 1 ),
--( 2, 86, 100, 'Porcentaje del Monto del Crédito Liquidado Anticipadamente', 1.0600, N'2024-04-07T03:25:02.773', 1 )



ALTER TABLE tPLDmatrizConfiguracionPagoAnticipado
ALTER COLUMN IdValor1 DECIMAL(7, 4);

ALTER TABLE tPLDmatrizConfiguracionPagoAnticipado
ALTER COLUMN IdValor2 DECIMAL(7, 4);

SELECT* 
--UPDATE pa SET pa.ValorDescripcion = 'NO EXISTE PREPAGO'
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=1 AND pa.Id=1


SELECT* 
--UPDATE pa SET pa.ValorDescripcion = 'PREPAGO IGUAL O MENOR AL 7.5% DEL MONTO DEL CRÉDITO',pa.IdValor1=1,pa.IdValor2=7.5
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=1 AND pa.Id=2

SELECT* 
--UPDATE pa SET pa.ValorDescripcion = 'PREPAGO MAYOR AL 7.5% Y MENOR AL 15% DEL MONTO DEL CRÉDITO',pa.IdValor1=7.6,pa.IdValor2=15
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=1 AND pa.Id=3

INSERT INTO dbo.tPLDmatrizConfiguracionPagoAnticipado 
(Tipo, IdValor1, IdValor2, ValorDescripcion, Puntos, Alta, IdEstatus) 
VALUES (1,15.1,100,'PREPAGO IGUAL O MAYOR AL 15% DEL MONTO DEL CRÉDITO',1,'20241016',1);
------Tipo 2--------

INSERT INTO dbo.tPLDmatrizConfiguracionPagoAnticipado 
(Tipo, IdValor1, IdValor2, ValorDescripcion, Puntos, Alta, IdEstatus) 
VALUES (2,0,0,'NO EXISTE LIQUIDACION ANTICIPADA',1,'20241016',1);

SELECT* 
--UPDATE pa SET pa.ValorDescripcion = 'LIQUIDACIÓN ANTICIPADA IGUAL O MENOR AL 15% DEL MONTO DEL CRÉDITO',pa.IdValor1=1,pa.IdValor2=15
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=2 AND pa.Id=4

SELECT* 
--UPDATE pa SET pa.ValorDescripcion = 'LIQUIDACIÓN ANTICIPADA IGUAL O MAYOR AL 30% DEL MONTO DEL CRÉDITO',pa.IdValor1=30.1,pa.IdValor2=100
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=2 AND pa.Id=5


INSERT INTO dbo.tPLDmatrizConfiguracionPagoAnticipado 
(Tipo, IdValor1, IdValor2, ValorDescripcion, Puntos, Alta, IdEstatus) 
VALUES (2,15.1,30,'LIQUIDACIÓN ANTICIPADA AL 15% Y MENOR AL 30% DEL MONTO DEL CRÉDITO',1,'20241016',1);


SELECT* 
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=2
SELECT* 
FROM dbo.tPLDmatrizConfiguracionPagoAnticipado pa WHERE pa.Tipo=1