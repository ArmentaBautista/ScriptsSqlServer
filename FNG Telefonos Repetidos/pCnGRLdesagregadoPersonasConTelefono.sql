

IF(object_id('pCnGRLdesagregadoPersonasConTelefono') is not null)
BEGIN
	DROP PROC pCnGRLdesagregadoPersonasConTelefono
	SELECT 'pCnGRLdesagregadoPersonasConTelefono BORRADO' AS info
END
GO

CREATE PROC pCnGRLdesagregadoPersonasConTelefono
AS
BEGIN
	
	IF OBJECT_ID('tempdb..#tel', 'U') IS NOT NULL
		DROP TABLE #tel

	CREATE table #tel (
		IdTelefono int,
		IdRel	int,
		IdListaD SMALLINT,
		Telefono VARCHAR(12) 
	)

	INSERT INTO #tel
	(
		IdTelefono,
		IdRel,
		IdListaD,
		Telefono
	)
	SELECT 
	t.IdTelefono,
	t.idrel,
	t.IdListaD,
	t.Telefono
	FROM dbo.tCATtelefonos t  WITH(NOLOCK) 	
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = t.IdEstatusActual
			AND ea.IdEstatus=1
	WHERE t.IdRel<>0
		and NOT t.Telefono IS NULL
		AND t.Telefono<>''

	SELECT
	suc.Descripcion as Sucursal,
	sc.Codigo AS NoSocio,
	sc.EsSocioValido AS TieneAportacionSocial,
	p.Nombre,
	ld.Descripcion AS Tipo,
	t.Telefono
	,rep.VecesRepetido
	FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
	INNER JOIN #tel t
		ON p.IdRelTelefonos=t.IdRel		
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) 
		ON ld.IdListaD=t.IdListaD
	LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		on sc.IdPersona = p.IdPersona
	LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
		ON suc.IdSucursal = sc.IdSucursal
	LEFT JOIN (
			SELECT 
			Telefono,
			COUNT(1) VecesRepetido
			FROM #tel
			GROUP BY telefono
			HAVING COUNT(1)>1
			) rep ON rep.Telefono = t.Telefono 

END
GO
