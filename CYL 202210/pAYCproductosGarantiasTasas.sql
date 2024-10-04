


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCproductosGarantiasTasas')
BEGIN
	DROP PROC pAYCproductosGarantiasTasas
	SELECT 'pAYCproductosGarantiasTasas BORRADO' AS info
END
GO

CREATE PROC pAYCproductosGarantiasTasas
@pTipoOperacion				AS VARCHAR(15)='',
@pIdProductosGarantiasTasas	AS INT =0 OUTPUT,
@pIdProducto					AS INT	=0,
@pPorcentajeGarantia			AS NUMERIC(5,4)=0,
@pInteresOrdinarioAnual		AS NUMERIC(23,8)=0,
@pInteresMoratorioAnual		AS NUMERIC(23,8)=0,
@pIdEstatus 					AS INT=0,
@pIdUsuarioAlta 				AS INT=0,
@pIdSesion 					AS INT=0
AS
BEGIN

	DECLARE @TipoOperacion				VARCHAR(15)=@pTipoOperacion				
	DECLARE @IdProductosGarantiasTasas	INT =@pIdProductosGarantiasTasas	
	DECLARE @IdProducto					INT	=@pIdProducto				
	DECLARE @PorcentajeGarantia			NUMERIC(5,4)=@pPorcentajeGarantia		
	DECLARE @InteresOrdinarioAnual		NUMERIC(23,8)=@pInteresOrdinarioAnual		
	DECLARE @InteresMoratorioAnual		NUMERIC(23,8)=@pInteresMoratorioAnual		
	DECLARE @IdEstatus 					INT=@pIdEstatus 				
	DECLARE @IdUsuarioAlta 				INT=@pIdUsuarioAlta 			
	DECLARE @IdSesion 					INT=@pIdSesion 					

	IF @TipoOperacion='ADD'
	BEGIN
		INSERT INTO dbo.tAYCproductosGarantiasTasas (IdProducto,PorcentajeGarantia,InteresOrdinarioAnual,InteresMoratorioAnual,IdEstatus,IdUsuarioAlta,IdSesion)
		VALUES
		(   @IdProducto,       
		    @PorcentajeGarantia,       
		    @InteresOrdinarioAnual,    
		    @InteresMoratorioAnual,    
		    1,       
		    @IdUsuarioAlta,
		    @IdSesion
		 )
		 
		SET @pIdProductosGarantiasTasas= SCOPE_IDENTITY();
		RETURN 1

	END 

	IF @TipoOperacion='DEL'
	BEGIN
		UPDATE dbo.tAYCproductosGarantiasTasas SET IdEstatus=2 WHERE IdProductosGarantiasTasas=@IdProductosGarantiasTasas
		
		RETURN 1
	END 

	IF @TipoOperacion='LST'
	BEGIN
		
		SELECT pgt.IdProductosGarantiasTasas,
               pgt.IdProducto,
			   pf.Descripcion AS Producto,
               pgt.PorcentajeGarantia,
               pgt.InteresOrdinarioAnual,
               pgt.InteresMoratorioAnual,
               pgt.Alta,
               pgt.IdEstatus,
               pgt.IdUsuarioAlta,
			   usr.Usuario,
               pgt.IdSesion 
		FROM dbo.tAYCproductosGarantiasTasas pgt  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = pgt.IdProducto
		INNER JOIN dbo.tCTLusuarios usr  WITH(NOLOCK) ON usr.IdUsuario = pgt.IdUsuarioAlta
		WHERE pgt.IdEstatus=@IdEstatus	

	END 

		IF @TipoOperacion='OBT'
	BEGIN
		
		SELECT pgt.IdProductosGarantiasTasas,
               pgt.IdProducto,
			   pf.Descripcion AS Producto,
               pgt.PorcentajeGarantia,
               pgt.InteresOrdinarioAnual,
               pgt.InteresMoratorioAnual,
               pgt.Alta,
               pgt.IdEstatus,
               pgt.IdUsuarioAlta,
			   usr.Usuario,
               pgt.IdSesion 
		FROM dbo.tAYCproductosGarantiasTasas pgt  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = pgt.IdProducto
		INNER JOIN dbo.tCTLusuarios usr  WITH(NOLOCK) ON usr.IdUsuario = pgt.IdUsuarioAlta
		WHERE pgt.IdEstatus=1 and pf.IdProductoFinanciero=@IdProducto

	END 

END

