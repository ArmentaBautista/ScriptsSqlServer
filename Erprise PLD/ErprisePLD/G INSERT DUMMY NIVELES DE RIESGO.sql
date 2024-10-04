

/* INSERT DUMMY NIVELES DE RIESGO */
-- SELECT FLOOR(rand()*101)
-- 1. Menores, 2. Mayores, 3. Morales
-- 1. Bajo, 2. Medio, 3. Alto
-- SELECT * FROM tPLDmatrizConfiguracionNivelesRiesgo
 TRUNCATE TABLE dbo.tPLDmatrizConfiguracionNivelesRiesgo
GO

 /* RANGOS MENORES */
 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (1,'Nivel Riesgo - Menores',1,'Bajo',1,200)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (1,'Nivel Riesgo - Menores',2,'Medio',201,350)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (1,'Nivel Riesgo - Menores',3,'Alto',351,500)
 GO

 /* RANGOS MAYORES */
 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (2,'Nivel Riesgo - Mayores',1,'Bajo',1,150)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (2,'Nivel Riesgo - Mayores',2,'Medio',151,250)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (2,'Nivel Riesgo - Mayores',3,'Alto',251,900)
 GO

  /* RANGOS MORALES */
 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (3,'Nivel Riesgo - Morales',1,'Bajo',1,100)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (3,'Nivel Riesgo - Morales',2,'Medio',101,200)
 GO

 INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2) VALUES (3,'Nivel Riesgo - Morales',3,'Alto',201,500)
 GO


 SELECT * FROM tPLDmatrizConfiguracionNivelesRiesgo