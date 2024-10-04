
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnGYCgestores')
BEGIN
	DROP PROC pCnGYCgestores
END
GO

CREATE PROC pCnGYCgestores
AS
BEGIN

	SELECT estatus.Descripcion AS Estatus, tipo.Descripcion AS Tipo, gestor.Codigo, persona.Nombre, gestor.GestionaCarteraNoAsignada, gestor.PermiteAsignacionCartera
	FROM dbo.tGYCgestores gestor  WITH(nolock) 
	INNER JOIN dbo.tGRLpersonas persona  WITH(nolock)  ON persona.IdPersona = gestor.IdPersona AND gestor.IdPersona!=0
	INNER JOIN dbo.tCTLtiposD tipo  WITH(nolock) ON tipo.IdTipoD = gestor.IdTipoDgestor
	INNER JOIN dbo.tCTLestatusActual eagestor  WITH(nolock) ON eagestor.IdEstatusActual = gestor.IdEstatusActual
	INNER JOIN dbo.tCTLestatus estatus  WITH(nolock) ON estatus.IdEstatus = eagestor.IdEstatus

END