
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnGYCgestores')
BEGIN
	DROP PROC pCnGYCgestores
	SELECT 'pCnGYCgestores BORRADO' AS info
END
GO

CREATE PROC pCnGYCgestores
AS
BEGIN
	SELECT 
	[GestorCodigo]				= g.Codigo,
	p.Nombre,
	[TipoGestor]				= tg.Descripcion,
	g.GestionaCarteraNoAsignada,
	g.PermiteAsignacionCartera,
	[Estatus]					=e.Descripcion
	FROM dbo.tGYCgestores g  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = g.IdPersona
	INNER JOIN dbo.tCTLtiposD tg  WITH(NOLOCK) 
		ON tg.IdTipoD=g.IdTipoDgestor
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = g.IdEstatusActual
	INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
		ON e.IdEstatus = ea.IdEstatus
	WHERE g.IdGestor<>0
	ORDER BY p.Nombre, tg.IdEstatus
END
GO

