

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnAYCvalidarAperturaProductoMenores')
BEGIN
	DROP FUNCTION fnAYCvalidarAperturaProductoMenores
	SELECT 'fnAYCvalidarAperturaProductoMenores BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnAYCvalidarAperturaProductoMenores(
@pIdSocio AS INT,
@pProducto AS VARCHAR(24)
)
RETURNS bit
BEGIN	
/* INFO (⊙_☉) 
5	27	AHORRO INFANTIL
6	29	AHORRO INFANTIL 1,500 UDI

** Usar código
*/
DECLARE @IdSocio AS INT=@pIdSocio
DECLARE @Producto AS VARCHAR(24)=@pProducto
DECLARE @IdPersonaTutor AS INT=0
DECLARE @Respuesta AS BIT=0

	SELECT 
	--sc.Codigo, pf.Nombre,pf.ApellidoPaterno, pf.ApellidoMaterno, pr.Nombre, tr.Descripcion, ref.*
	@IdPersonaTutor=ref.IdPersona
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
		ON pf.IdPersona = sc.IdPersona
	INNER JOIN dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK) 
		ON ref.RelReferenciasPersonales= pf.RelReferenciasPersonales
			AND ref.EsTutorPrincipal=1
	INNER JOIN dbo.tCTLtiposD tr  WITH(NOLOCK) 
		ON tr.IdTipoD = ref.IdTipoD
	WHERE sc.IdSocio=@idSocio

	IF @Producto='27' AND EXISTS(SELECT 1 FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.EsSocioValido=1 AND sc.IdPersona=@IdPersonaTutor)
		SET @Respuesta = 1
	ELSE
		SET @Respuesta = 0

	--IF @Producto='29' AND NOT EXISTS(SELECT 1 FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.EsSocioValido=1 AND sc.IdPersona=@IdPersonaTutor)
	--	SET @Respuesta = 1
	--ELSE
	--	SET @Respuesta = 0

	SET @Respuesta = CASE 
						WHEN @Producto='27' AND EXISTS(SELECT 1 FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.EsSocioValido=1 AND sc.IdPersona=@IdPersonaTutor)
							THEN 1
						WHEN @Producto='29' AND NOT EXISTS(SELECT 1 FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.EsSocioValido=1 AND sc.IdPersona=@IdPersonaTutor)
							THEN 1
						ELSE 0
						END

	RETURN @Respuesta;
END
GO	

