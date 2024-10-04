

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDescalamientosOperacionePeriodo')
BEGIN
	DROP PROC pCnPLDescalamientosOperacionePeriodo
	SELECT 'pCnPLDescalamientosOperacionePeriodo BORRADO' AS info
END
GO

CREATE PROC pCnPLDescalamientosOperacionePeriodo
@periodo AS VARCHAR(8)=''
AS
BEGIN

	DECLARE @idPeriodo AS INT = (select p.idperiodo FROM tCTLperiodos p  WITH(NOLOCK) WHERE p.Codigo=@periodo)
	DECLARE @MontoPersonasFisicas AS NUMERIC(18,2)=ISNULL((SELECT valor FROM dbo.tPLDconfiguracion c With (nolock) WHERE c.IdParametro=-29),0)
	DECLARE @MontoPersonasMorales AS NUMERIC(18,2)=ISNULL((SELECT valor FROM dbo.tPLDconfiguracion c With (nolock) WHERE c.IdParametro=-30),0)

	-- Tabla de alertamientos
	DECLARE @alertamientos AS TABLE(
		IdPeriodo						INT,
		Periodo							VARCHAR(10),
		IdSucursal						INT,
		IdPersona						INT,
		IdSocio							INT,
		NoSocio							VARCHAR(30),
		EsPersonaFisica					BIT,
		EsPersonaMoral					BIT,
		ExentaIVA						BIT,
		AcumuladoMesCalendario			NUMERIC(18,2),
		Alertamiento					VARCHAR(128)
	)

	-- PF
	INSERT INTO @alertamientos
	(
		IdPeriodo,
		Periodo,
		IdSucursal,	
		IdPersona,	
		IdSocio,
		NoSocio,
		EsPersonaFisica,
		EsPersonaMoral,
		ExentaIVA,
		AcumuladoMesCalendario,
		Alertamiento
	)
	SELECT acu.IdPeriodo, per.Codigo,sc.IdSucursal, sc.IdPersona, acu.IdSocio, sc.Codigo AS NoSocio, 1, 0, sc.ExentaIVA, acu.AcumuladoMesCalendario
	,CASE 
		WHEN (sc.ExentaIVA=0 AND acu.AcumuladoMesCalendario>=@MontoPersonasFisicas) THEN 'Escalamiento $300k Persona Fisica sin Actividad Empresarial'
		WHEN (sc.ExentaIVA=1 AND acu.AcumuladoMesCalendario>=@MontoPersonasMorales) THEN 'Escalamiento $500k Persona Fisica con Actividad Empresarial'
		ELSE ''
		END AS Alertamiento
	FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario acu
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = acu.IdSocio
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
	INNER JOIN dbo.tCTLperiodos per  WITH(NOLOCK) ON per.IdPeriodo = acu.IdPeriodo
	WHERE acu.AcumuladoMesCalendario>=@MontoPersonasFisicas and  acu.IdPeriodo=@idPeriodo 
	--ORDER BY acu.AcumuladoMesCalendario DESC


	-- PM
	INSERT INTO @alertamientos
	(
		IdPeriodo,
		Periodo,
		IdSucursal,	
		IdPersona,	
		IdSocio,
		NoSocio,
		EsPersonaFisica,
		EsPersonaMoral,
		ExentaIVA,
		AcumuladoMesCalendario,
		Alertamiento
	)
	SELECT acu.IdPeriodo, per.Codigo,sc.IdSucursal, sc.IdPersona,  acu.IdSocio, sc.Codigo AS NoSocio,0, 1, sc.ExentaIVA, acu.AcumuladoMesCalendario
	,IIF(acu.AcumuladoMesCalendario>=@MontoPersonasMorales,'Escalamiento $500k Persona Fisica con Actividad Empresarial','') AS Alertamiento
	FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario acu
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = acu.IdSocio
	INNER JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = sc.IdPersona
	INNER JOIN dbo.tCTLperiodos per  WITH(NOLOCK) ON per.IdPeriodo = acu.IdPeriodo
	WHERE  acu.AcumuladoMesCalendario>=@MontoPersonasMorales AND acu.IdPeriodo=@idPeriodo
	--ORDER BY acu.AcumuladoMesCalendario DESC


	-- Consulta
	SELECT a.Periodo, suc.Descripcion AS SucursalSocio, a.NoSocio, p.Nombre, a.EsPersonaFisica, a.ExentaIVA AS TieneActividadEmpresarial, a.EsPersonaMoral
	,a.AcumuladoMesCalendario, a.Alertamiento AS Escalamiento
	FROM @alertamientos a 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = a.IdPersona
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = a.IdSucursal
	WHERE a.Alertamiento<>''
	ORDER BY a.Periodo

END
