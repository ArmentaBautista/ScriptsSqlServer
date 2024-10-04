

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnGRLNumeroHuellasPersona')
BEGIN
	DROP PROC pCnGRLNumeroHuellasPersona
	SELECT 'pCnGRLNumeroHuellasPersona BORRADO' AS info
END
GO

CREATE PROC pCnGRLNumeroHuellasPersona
AS
BEGIN
		SELECT 
		[Sucursal]		= suc.Descripcion,
		[NoSocio]		= sc.Codigo,
		p.Nombre, 
		p.RFC, 
		pf.CURP,
		h.NumeroHuellas
		FROM dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
		INNER JOIN (
					SELECT 
					hp.RelHuellasDigitalesPersona, COUNT(1) AS NumeroHuellas
					FROM dbo.tPERhuellasDigitalesPersona hp  WITH(NOLOCK) 
					WHERE hp.IdEstatus=1 
					GROUP BY hp.RelHuellasDigitalesPersona
					) h ON h.RelHuellasDigitalesPersona = pf.RelHuellasDigitalesPersona 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = pf.IdPersona
		LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdPersona = p.IdPersona
		LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = sc.IdSucursal
		ORDER BY suc.IdSucursal, h.NumeroHuellas DESC
END
GO



