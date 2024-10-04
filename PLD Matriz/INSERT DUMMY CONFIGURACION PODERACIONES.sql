
/* INSERT DUMMY CONFIGURACION PONDERACIONES */
-- SELECT FLOOR(rand()*101)
-- 1. Socio, 2. Geografía, 3. Listas y Terceros, 4. Ingresos
-- 5. Transaccionalidad, 6. Productos y Servicios, 7. Canales de Distribución

TRUNCATE TABLE dbo.tPLDmatrizConfiguracionPonderaciones
GO

INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(1,'Socio',.1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(2,'Geografía',.1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(3,'Listas y Terceros',.15)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(4,'Ingresos',.1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(5,'Transaccionalidad',.3)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(6,'Productos y Servicios',.15)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionPonderaciones (IdFactor,Factor,PonderacionFactor) VALUES(7,'Canales de Distribución',.1)
GO

