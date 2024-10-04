
USE iERP_DRA_TEST
GO

/* INSERT DUMMY TRANSACCIONALIDAD */
-- SELECT FLOOR(rand()*101)
-- Monto Dep Mes Menores = 1,  Monto Ret Mes Menores = 2,
-- Monto Dep Mes Mayores = 3,  Monto Ret Mes Mayores = 4,
-- Monto Dep Mes Morales = 5,  Monto Ret Mes Morales = 6

-- SELECT * FROM tPLDmatrizConfiguracionTransaccionalidad
 TRUNCATE TABLE tPLDmatrizConfiguracionTransaccionalidad

 /* RANGOS MENORES*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,1,5000,'Monto Dep Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,5001,15000,'Monto Dep Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,15001,50000,'Monto Dep Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,50001,500000,'Monto Dep Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,1,5000,'Monto Ret Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,5001,15000,'Monto Ret Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,15001,50000,'Monto Ret Mes Menores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,50001,500000,'Monto Ret Mes Menores',FLOOR(rand()*101))
 GO

  /* RANGOS MAYOR*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,1,5000,'Monto Dep Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,5001,15000,'Monto Dep Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,15001,50000,'Monto Dep Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,50001,500000,'Monto Dep Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,1,5000,'Monto Ret Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,5001,15000,'Monto Ret Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,15001,50000,'Monto Ret Mes Mayores',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,50001,500000,'Monto Ret Mes Mayores',FLOOR(rand()*101))
 GO

   /* RANGOS MORAL*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,1,50000,'Monto Dep Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,50001,150000,'Monto Dep Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,150001,500000,'Monto Dep Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,500001,5000000,'Monto Dep Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,1,50000,'Monto Ret Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,50001,150000,'Monto Ret Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,150001,500000,'Monto Ret Mes Morales',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidad (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,500001,5000000,'Monto Ret Mes Morales',FLOOR(rand()*101))
 GO