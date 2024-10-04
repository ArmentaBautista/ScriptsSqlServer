

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pATNScatalogosF3')
BEGIN
	DROP PROC pATNScatalogosF3
	SELECT 'pATNScatalogosF3 BORRADO' AS info
END
GO

CREATE PROC pATNScatalogosF3
@RETURN_MESSAGE VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion		VARCHAR(16),
@pCadenaBusqueda	VARCHAR(20)='',
@pIdSocio			INT = 0,
@pIdTipoCausa		INT=0
AS
BEGIN
	DECLARE @TipoOperacion AS VARCHAR(16) = @pTipoOperacion;
	DECLARE @CadenaBusqueda AS VARCHAR(20) = @pCadenaBusqueda;
	DECLARE @IdTipoCausa AS INT = @pIdTipoCausa; 
	DECLARE @IdSocio AS INT = @pIdSocio

	IF @TipoOperacion='EMP'
	BEGIN
		SELECT 
		[Identificador]	= IdEmpleado,
		[ClaveEmpleado]	= emp.Codigo,
		p.Nombre,
		[Puesto]		= pt.Descripcion
		FROM dbo.tPERempleados emp  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = emp.IdEstatusActual
				AND ea.IdEstatus=1
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersonaFisica = emp.IdPersonaFisica
		INNER JOIN dbo.tPERpuestos pt  WITH(NOLOCK) 
			ON pt.IdPuesto = emp.IdPuesto
		WHERE emp.IdPersonaFisica<>0
		AND (emp.codigo LIKE '%' + @CadenaBusqueda + '%'
			OR p.Nombre LIKE '%' + @CadenaBusqueda +'%')

		RETURN 0
	END

		IF @TipoOperacion='SUC'
		BEGIN
			SELECT 
			[Identificador]	= suc.IdSucursal,
			suc.Codigo,
			[Sucursal]		= suc.Descripcion
			FROM dbo.tCTLsucursales suc  WITH(NOLOCK) 
			INNER JOIN  dbo.tCTLestatusActual es  WITH(NOLOCK) 
				ON es.IdEstatusActual = suc.IdEstatusActual
					AND es.IdEstatus=1
			WHERE suc.Codigo LIKE '%' + @CadenaBusqueda + '%'
				AND suc.Descripcion LIKE '%' + @CadenaBusqueda + '%'

			RETURN 0
		END
	
		/* INFO (⊙_☉) JCA.29/08/2023.08:46 a. m. 
		Nota: Para el F3 de Socios, usar el procedimiento pF3socios con el @pTipoOperacion 'MIN'
		*/
		

		IF @TipoOperacion='TIPATEN'
		BEGIN
			SELECT 
			[Identificador]		= ta.IdTipoAtencion,
			ta.Codigo,
			[TipoDeAtencion]	= ta.Descripcion
			FROM dbo.tATNStiposAtencion ta  WITH(NOLOCK) 
			WHERE ta.IdEstatus=1
			AND (ta.Codigo LIKE '%' + @CadenaBusqueda + '%'
				OR ta.Descripcion LIKE '%' + @CadenaBusqueda + '%')
			
			RETURN 0
		END
	
		IF @TipoOperacion='OPER'
		BEGIN
		    	IF @CadenaBusqueda=''
                BEGIN
                    SET @RETURN_MESSAGE = 'Por favor proporcione el Folio o parte de el para la búsqueda'
                    RETURN -1
                END

			SELECT
			[Identificador]	= op.IdOperacion,
			[Folio]			= CONCAT(tope.Codigo,'-',CAST(op.Folio AS VARCHAR(9))),
			[Descripción]	= CONCAT(op.Fecha,' ',op.Concepto,' ',op.Total),
			[Sucursal]		= suc.Descripcion
			FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLtiposOperacion tope  WITH(NOLOCK) 
				ON tope.IdTipoOperacion = op.IdTipoOperacion
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK)
				ON suc.IdSucursal = op.IdSucursal
			WHERE op.IdEstatus=1
			AND CONCAT(tope.Codigo,'-',CAST(op.Folio AS VARCHAR(9))) LIKE '%' + @CadenaBusqueda + '%' 

			RETURN 0
		END
	
		IF @TipoOperacion='CTAS'
		BEGIN

			SELECT 
			[Identificador]	= c.IdCuenta,
			[NoCuenta]		= c.Codigo,
			[CodigoProducto]= CONCAT(pf.Codigo,' ',pf.Descripcion)
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
				ON pf.IdProductoFinanciero = c.IdProductoFinanciero
			WHERE c.IdEstatus=1
				AND c.IdSocio=@IdSocio
			
			RETURN 0
		END
	
		IF @TipoOperacion='MEDNOT'
		BEGIN
			SELECT 
			[Identificador]	= mn.IdMedioNotificacion,
			mn.Codigo,
			[MedioDeNotificacion] = mn.Descripcion,
			mn.Descripcion
			FROM dbo.tATNSmediosNotificacion mn  WITH(NOLOCK) 
			WHERE mn.Codigo LIKE '%' + @CadenaBusqueda + '%'
				OR mn.Descripcion LIKE '%' + @CadenaBusqueda + '%'
			
			RETURN 0
		END
	
		IF @TipoOperacion='TIPCAUSA'
		BEGIN
			SELECT 
			[Identificador]	= tc.IdTipoCausa,
			tc.Codigo,
			[TipoCausa] = tc.Descripcion,
			tc.Descripcion
			FROM dbo.tATNStiposCausa tc  WITH(NOLOCK) 
			WHERE tc.Codigo LIKE '%' + @CadenaBusqueda + '%'
				OR tc.Descripcion LIKE '%' + @CadenaBusqueda + '%'
			
			RETURN 0
		END

		IF @TipoOperacion='SUBTCAUSA'
		BEGIN
			SELECT 
			[Identificador]	= stc.IdSubtipoCausa,
			stc.Codigo,
			[TipoCausa] = stc.Descripcion,
			stc.Descripcion
			FROM dbo.tATNSsubtiposCausa stc  WITH(NOLOCK) 
			WHERE stc.IdTipoCausa=@IdTipoCausa
			AND (stc.Codigo LIKE '%' + @CadenaBusqueda + '%'
				OR stc.Descripcion LIKE '%' + @CadenaBusqueda + '%')
			
			RETURN 0
		END

END
GO