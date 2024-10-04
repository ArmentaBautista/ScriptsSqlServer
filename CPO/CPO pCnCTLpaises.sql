

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnCTLpaises')
BEGIN
	DROP PROC pCnCTLpaises
	SELECT 'pCnCTLpaises BORRADO' AS info
END
GO

CREATE PROC pCnCTLpaises
AS
BEGIN

	SELECT 'Nacionalidades' AS Lista, p.Codigo, e.Descripcion AS Nombre, p.ExclusionGAFI, e.Descripcion Estatus
	FROM dbo.tCTLnacionalidades p  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = p.IdEstatus
	WHERE p.IdNacionalidad<>0
	UNION ALL
    SELECT 'Países' AS Lista, p.Codigo, e.Descripcion AS Nombre, p.ExclusionGAFI, e.Descripcion Estatus
	FROM dbo.tCTLpaises p  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = p.IdEstatus
	WHERE p.IdPais<>0
	
END