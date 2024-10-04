

/* JCA.18/4/2024.21:37
Nota: Procedimiento con los F3 usados en el módulo EBS
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEBSf3socios')
BEGIN
	DROP PROC dbo.pEBSf3socios
	SELECT 'pEBSf3socios BORRADO' AS info
END
GO

CREATE PROC dbo.pEBSf3socios
@RETURN_MESSAGE AS VARCHAR(MAX)='' OUTPUT ,
@pTipoOperacion AS VARCHAR(24)='',
@pCadenaBusqueda AS VARCHAR(24)=''
AS
BEGIN
	DECLARE @TipoOperacion AS VARCHAR(24)=@pTipoOperacion;
	DECLARE @CadenaBusqueda AS VARCHAR(24)=@pCadenaBusqueda

	IF @CadenaBusqueda=''
	BEGIN
		SET @RETURN_MESSAGE = 'Por favor proporcione datos para la búsqueda';
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
		
		RETURN 1
    END

	IF @TipoOperacion='TIENE_EBS'
	BEGIN
		
		SELECT
		    sc.IdSocio,
		    sc.Codigo,
		    p.Nombre,
		    p.RFC,
		    pf.CURP,
		    p.Domicilio
		FROM dbo.tSCSsocios sc  WITH(NOLOCK)
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK)
			ON p.IdPersona = sc.IdPersona
		LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
			ON pf.IdPersona = p.IdPersona
		WHERE (p.Nombre LIKE '%' + @CadenaBusqueda + '%'
					OR sc.Codigo LIKE '%' + @CadenaBusqueda + '%')
		        AND exists (SELECT 1
		                    FROM tEBSencuestaBajaSocios e WITH (NOLOCK)
		                    where e.IdSocio=sc.IdSocio)
		
		RETURN 1
    END

END
GO
SELECT 'pEBSf3socios CREADO' AS info
GO
