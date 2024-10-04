



/* INSERT DUMMY INGRESOS */
-- SELECT FLOOR(rand()*101)
--  RangoPF=2, RangoPM=3
-- SELECT * FROM tPLDmatrizConfiguracionIngresos
 TRUNCATE TABLE tPLDmatrizConfiguracionIngresos
GO

 /* RANGOS PF*/
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,1,5000,'Ingresos PF',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,5001,15000,'Ingresos PF',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,15001,50000,'Ingresos PF',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,50001,100000,'Ingresos PF',1)
 GO

  /* RANGOS PM*/
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,1,30000,'Ingresos PM',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,30001,100000,'Ingresos PM',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,100001,500000,'Ingresos PM',1)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,500001,3000000,'Ingresos PM',1)
 GO


SELECT * FROM tPLDmatrizConfiguracionIngresos
GO
