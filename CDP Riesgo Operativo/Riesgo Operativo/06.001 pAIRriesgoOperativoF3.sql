
-- 06.001 pAIRriesgoOperativoF3
/* JCA.19/4/2024.01:30 
Nota: Riesgo Operativo. Procedimiento que concentra los F3 del módulo
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRriesgoOperativoF3')
BEGIN
	DROP PROC pAIRriesgoOperativoF3
	SELECT 'pAIRriesgoOperativoF3 BORRADO' AS info
END
GO

CREATE PROC pAIRriesgoOperativoF3
@RETURN_MESSAGE                     VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion						VARCHAR(16),
@pCadenaBusqueda					VARCHAR(20)='',
@pIdClasificacionRiesgoCategoria	INT=0,
@pIdClasificacionRiesgoTipo			INT=0
AS
BEGIN
	DECLARE @TipoOperacion AS VARCHAR(16) = @pTipoOperacion;
	DECLARE @CadenaBusqueda AS VARCHAR(20) = @pCadenaBusqueda;
	DECLARE @IdClasificacionRiesgoCategoria INT = @pIdClasificacionRiesgoCategoria
	DECLARE @IdClasificacionRiesgoTipo		INT = @pIdClasificacionRiesgoTipo		

	IF @TipoOperacion='PER'
	BEGIN
		DECLARE @Year int=DATEPART(YEAR,GETDATE())
		DECLARE @Fecha DATE=GETDATE()

	    SELECT
		[Identificador]		= t.IdPeriodo,
		t.Codigo,
		[Categoria]			= t.Descripcion
		FROM dbo.tCTLperiodos t  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLejercicios e  WITH(NOLOCK) 
			ON e.IdEjercicio = t.IdEjercicio
				AND e.Codigo IN (@Year,@Year-1)
		WHERE t.EsAjuste=0 
			AND t.Inicio<=@Fecha
		ORDER BY t.IdPeriodo desc

		RETURN 0
	END

	IF @TipoOperacion='CAT'
	BEGIN
	    SELECT
		[Identificador]		= t.IdClasificacionRiesgoCategoria,
		t.Codigo,
		[Categoria]			= t.Descripcion
		FROM dbo.tAIRclasificacionRiesgoCategoria t  WITH(NOLOCK) 
		WHERE t.IdEstatus=1
		AND (t.Codigo LIKE '%' + @CadenaBusqueda + '%'
		OR t.Descripcion LIKE '%' + @CadenaBusqueda + '%')

		RETURN 0
	END

	IF @TipoOperacion='TIPO'
	BEGIN
	    SELECT
		[Identificador]		= t.IdClasificacionRiesgoTipo,
		t.Codigo,
		[Tipo]				= t.Descripcion
		FROM dbo.tAIRclasificacionRiesgoTipo t  WITH(NOLOCK) 
		WHERE t.IdEstatus=1
		AND t.IdClasificacionRiesgoCategoria=@IdClasificacionRiesgoCategoria

		RETURN 0
	END

	IF @TipoOperacion='SUBT'
	BEGIN
	    SELECT
		[Identificador]		= t.IdClasificacionRiesgoSubtipo,
		t.Codigo,
		[Subtipo]				= t.Descripcion
		FROM dbo.tAIRclasificacionRiesgoSubtipo t  WITH(NOLOCK) 
		WHERE t.IdEstatus=1
		AND t.IdClasificacionRiesgoTipo=@IdClasificacionRiesgoTipo

		RETURN 0
	END


END
GO
SELECT 'pAIRriesgoOperativoF3 CREADO' as Info
GO
