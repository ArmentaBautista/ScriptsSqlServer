

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSEGllenadoProductos398')
BEGIN
	DROP PROC pSEGllenadoProductos398
	SELECT 'pSEGllenadoProductos398 BORRADO' AS info
END
GO

CREATE PROC pSEGllenadoProductos398
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
																	,pd.Dias
																	,r.li
																	,r.ls 
																	FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)
																	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
																		ON ea.IdEstatusActual = pf.IdEstatusActual
																			AND ea.IdEstatus=1
																	INNER JOIN dbo.tSEGproductosDias pd  WITH(NOLOCK) 
																		ON pd.IdProductoFinanciero = pf.IdProductoFinanciero
																	CROSS JOIN (VALUES(1000,9999.99),
																					  (10000,49999.99),
																					  (50000,10000000)
																				) r(li,ls) 
																	WHERE pf.IdTipoDDominioCatalogo=398
																	ORDER BY pf.Codigo,pd.Dias,r.li
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
GO