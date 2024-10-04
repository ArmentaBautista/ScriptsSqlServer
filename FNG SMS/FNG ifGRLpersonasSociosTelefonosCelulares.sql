
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='ifGRLpersonasSociosTelefonosCelulares')
BEGIN
	DROP FUNCTION dbo.ifGRLpersonasSociosTelefonosCelulares
	SELECT 'ifGRLpersonasSociosTelefonosCelulares BORRADO' AS info
END
GO

CREATE FUNCTION dbo.ifGRLpersonasSociosTelefonosCelulares()
RETURNS TABLE
AS
RETURN (
	SELECT 
	tel.IdRel AS IdRelTelefonos,
	p.IdPersona,
	sc.IdSocio,
	tel.Telefono
	FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK)
		ON sc.IdPersona = p.IdPersona
			AND sc.EsSocioValido=1
	INNER JOIN (
		SELECT t.IdRel,t.Telefono
		FROM dbo.tCATtelefonos t  WITH(NOLOCK)
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = t.IdEstatusActual
				AND ea.IdEstatus=1
		WHERE t.IdRel<>0
			AND t.IdListaD=-1339
		GROUP BY t.IdRel, t.Telefono	 
	) tel ON tel.IdRel = p.IdRelTelefonos
);



 
