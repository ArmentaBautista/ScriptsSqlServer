

/********  JCA.6/8/2024.10:01 Info: Fix de escala y presición de campos para ponderaciones a solicitud de FNG ¬¬  ********/

/********  JCA.6/8/2024.10:32 Info: 0.01 Edades  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionEdades', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionEdades
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.10:33 Info: 0.02 Genero  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionGenero', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionGenero
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.10:36 Info: 0.03 Geografía  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionGeografia', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionGeografia
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.10:40 Info: 0.04 Ingresos  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionIngresos', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionIngresos
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.10:58 Info: 0.05 Instrumentos  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionInstrumentosCanales', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionInstrumentosCanales
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:00 Info: 0.06 Listas  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionListas', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionListas
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:01 Info: 0.07 Niveles de Riesgo  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionNivelesRiesgo', 
                                           @pCampo = 'Valor1'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionNivelesRiesgo
		ALTER COLUMN Valor1 NUMERIC(10,4)
END
GO

DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionNivelesRiesgo', 
                                           @pCampo = 'Valor2'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionNivelesRiesgo
		ALTER COLUMN Valor2 NUMERIC(10,4)
END
GO

/********  JCA.6/8/2024.11:06 Info: 0.08 tPLDmatrizConfiguracionPonderaciones  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionPonderaciones', 
                                           @pCampo = 'PonderacionFactor'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionPonderaciones
		ALTER COLUMN PonderacionFactor NUMERIC(5,4)
END
GO

/********  JCA.6/8/2024.11:07 Info: 0.09 tPLDmatrizConfiguracionProductosServicios  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionProductosServicios', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionProductosServicios
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:09 Info: 0.10 tPLDmatrizConfiguracionTipoSocio  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionTipoSocio', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionTipoSocio
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:10 Info: 0.11 tPLDmatrizConfiguracionTransaccionalidad  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionTransaccionalidad', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionTransaccionalidad
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:15 Info: 0.13 tPLDmatrizConfiguracionSucursales  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionSucursales', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionSucursales
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:16 Info: 0.14 tPLDmatrizConfiguracionActividad  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionActividad', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionActividad
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:17 Info: 0.16 tPLDmatrizConfiguracionOcupaciones  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionOcupaciones', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionOcupaciones
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:18 Info: 0.18 tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:19 Info: 0.22 tPLDmatrizConfiguracionOrigenDestinoRecursos  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionOrigenDestinoRecursos', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionOrigenDestinoRecursos
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

/********  JCA.6/8/2024.11:20 Info: 0.24 tPLDmatrizConfiguracionPagoAnticipado  ********/
DECLARE @result AS INT
EXEC @result = dbo.pADMeliminarConstraints @pTabla = 'tPLDmatrizConfiguracionPagoAnticipado', 
                                           @pCampo = 'Puntos'  
IF @result=0
BEGIN
	ALTER TABLE dbo.tPLDmatrizConfiguracionPagoAnticipado
		ALTER COLUMN Puntos NUMERIC(7,4)
END
GO

