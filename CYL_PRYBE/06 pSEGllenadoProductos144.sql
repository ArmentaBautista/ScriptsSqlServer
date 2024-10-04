

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSEGllenadoProductos144')
BEGIN
	DROP PROC pSEGllenadoProductos144
	SELECT 'pSEGllenadoProductos144 BORRADO' AS info
END
GO

CREATE PROC pSEGllenadoProductos144
AS
BEGIN

	/* declare variables */
	DECLARE @IdProductoFinanciero	AS INT;
	DECLARE @Producto				NVARCHAR(250);
	DECLARE @Dias					AS INT
	DECLARE @LI						AS NUMERIC(15,2)
	DECLARE @LS						AS NUMERIC(15,2)

		DECLARE prodCap CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT 
																pf.IdProductoFinanciero
																,pf.Codigo
																,30
																,0
																,10000000
																FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
																INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
																	ON ea.IdEstatusActual = pf.IdEstatusActual
																		AND ea.IdEstatus=1
																WHERE pf.IdTipoDDominioCatalogo IN (144,716,2661)
		OPEN prodCap
		FETCH NEXT FROM prodCap INTO @IdProductoFinanciero	,
									 @Producto				,
									 @Dias					,
									 @LI					,	
									 @LS						
		WHILE @@FETCH_STATUS = 0
		BEGIN
    
			IF NOT EXISTS(SELECT 1
						  FROM dbo.tSEGproductos p  WITH(NOLOCK) 
							WHERE p.IdProductoFinanciero=@IdProductoFinanciero
								AND p.Dias=@Dias
								AND p.LimiteInferior=@LI
								AND	p.LimiteSuperior=@LS
						  )
			BEGIN
					PRINT @Producto

					INSERT INTO dbo.tSEGproductos(IdProductoFinanciero,Producto,Dias,LimiteInferior,LimiteSuperior)
					SELECT @IdProductoFinanciero,@Producto,@Dias,@LI,@LS
			END

			FETCH NEXT FROM prodCap INTO @IdProductoFinanciero	,
										 @Producto				,
										 @Dias					,
										 @LI					,	
										 @LS						
		END

		CLOSE prodCap
		DEALLOCATE prodCap

END