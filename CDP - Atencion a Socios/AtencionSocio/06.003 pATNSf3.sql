/* JCA.19/4/2024.03:45 
Nota: Procedimiento con los F3 usados en el módulo ATNS
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pATNSf3')
BEGIN
	DROP PROC dbo.pATNSf3
	SELECT 'pATNSf3 BORRADO' AS info
END
GO

CREATE PROC dbo.pATNSf3
@RETURN_MESSAGE VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion AS VARCHAR(24)='',
@pCadenaBusqueda AS VARCHAR(24)=''
AS
BEGIN
	DECLARE @TipoOperacion AS VARCHAR(24)=@pTipoOperacion;
	DECLARE @CadenaBusqueda AS VARCHAR(24)=@pCadenaBusqueda

	IF @CadenaBusqueda=''
	BEGIN
		SET @RETURN_MESSAGE = 'Por favor proporcione datos para la búsqueda'
		RETURN -1
	END

	IF @TipoOperacion='ACT'
	BEGIN
		
		SELECT sc.IdSocio, sc.Codigo, p.Nombre, p.RFC, pf.CURP, p.Domicilio
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
			ON pf.IdPersona = p.IdPersona
		WHERE sc.IdEstatus=1
			AND (p.Nombre LIKE '%' + @CadenaBusqueda + '%'
					OR sc.Codigo LIKE '%' + @CadenaBusqueda + '%')
		
		RETURN 0
    END

	

END
GO
