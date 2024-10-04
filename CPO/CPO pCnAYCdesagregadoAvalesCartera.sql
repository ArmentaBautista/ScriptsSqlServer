

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCdesagregadoAvalesCartera')
BEGIN
	DROP PROC pCnAYCdesagregadoAvalesCartera
	SELECT 'pCnAYCdesagregadoAvalesCartera BORRADO' AS info
END
GO

CREATE PROC pCnAYCdesagregadoAvalesCartera
@FechaInicial AS DATE='',
@FechaFinal AS DATE=''
AS
BEGIN

	if @FechaInicial='' OR @FechaInicial='19000101'
	BEGIN
		SET @FechaFinal=GETDATE()
		SET @FechaInicial=DATEADD(YEAR,-1,@FechaFinal)
	END


	SELECT c.FechaAlta, estatus.Descripcion AS Estatus, c.Codigo AS NoCuenta, c.Descripcion AS Producto, socio.Codigo AS NoSocio, perSocio.Nombre AS Socio 
	, perAval.Nombre AS AvalObligadoSolidacio, aa.EsAval, aa.EsObligatorioSolidario
	FROM dbo.tAYCcuentas c  WITH(NOLOCK)
	INNER JOIN dbo.tCTLestatus estatus  WITH(NOLOCK) ON estatus.IdEstatus = c.IdEstatus
	INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas perSocio  WITH(NOLOCK) ON perSocio.IdPersona = socio.IdPersona 
	INNER JOIN dbo.tAYCavalesAsignados aa  WITH(NOLOCK) ON aa.RelAvales = c.RelAvales AND aa.IdEstatus=1 AND aa.EsSolicitanteCredito=0
	INNER JOIN dbo.tGRLpersonas perAval  WITH(NOLOCK) ON perAval.IdPersona = aa.IdPersona
	WHERE c.FechaAlta BETWEEN @FechaInicial AND @FechaFinal
	AND c.IdEstatus IN (1,7,53,73)
	ORDER BY c.IdCuenta

END