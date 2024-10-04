
IF(object_id('pCnGrldesagregadoPersonasConCorreo') is not null)
BEGIN
	DROP PROC pCnGrldesagregadoPersonasConCorreo
	SELECT 'pCnGrldesagregadoPersonasConCorreo BORRADO' AS info
END
GO

CREATE PROC pCnGrldesagregadoPersonasConCorreo
AS
BEGIN
	
	IF OBJECT_ID('tempdb..#mails', 'U') IS NOT NULL
		DROP TABLE #mails

	CREATE table #mails (
		IdRel	int,
		IdListaD SMALLINT,
		EsCorporativo BIT,
		Mail VARCHAR(49) 
	)

	INSERT INTO #mails
	(
	    IdRel,
	    IdListaD,
	    EsCorporativo,
	    Mail
	)
	SELECT 
	t.idrel,
	t.IdListaD,
	t.EsCorporativo,
	t.email
	FROM dbo.tCATemails t  WITH(NOLOCK) 	
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = t.IdEstatusActual
			AND ea.IdEstatus=1
	WHERE t.IdRel<>0
		--57,745
	SELECT
	suc.Descripcion as Sucursal,
	sc.Codigo AS NoSocio,
	sc.EsSocioValido AS TieneAportacionSocial,
	p.Nombre,
	ld.Descripcion AS Tipo,
	t.EsCorporativo,
	t.Mail
	,rep.VecesRepetido
	FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
	INNER JOIN #mails t
		ON p.IdRelEmails=t.IdRel		
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) 
		ON ld.IdListaD=t.IdListaD
	LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		on sc.IdPersona = p.IdPersona
	LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
		ON suc.IdSucursal = sc.IdSucursal
	LEFT JOIN (
			SELECT 
			Mail,
			COUNT(1) VecesRepetido
			FROM #mails
			GROUP BY Mail
			HAVING COUNT(1)>1
			) rep ON rep.Mail = t.Mail
			
END
GO

