
DECLARE @ProductBankIdentifier AS VARCHAR(32)='101-004156'
DECLARE @DateFromFilter	AS DATE='20200101'
DECLARE @DateToFilter AS DATE='20230401'
DECLARE @OrderByField AS VARCHAR(128)=''
DECLARE @PageStartIndex AS INT=1
DECLARE @PageSize AS INT=9999

		DECLARE @fechaHoy AS DATE=GETDATE();
		IF @DateToFilter='19000101'
			SET @DateToFilter=@fechaHoy

		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize


		DECLARE @campoOrden VARCHAR(128),
				@tipoOrden VARCHAR(128);
--#region DETERMINACIÓN DE ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='Balance DESC'
		
		EXEC dbo.pBKGparseOrderBy @pOrderByField =  @OrderByField, @pCampoOrden = @campoOrden OUTPUT, @pTipoOrden = @tipoOrden OUTPUT    
--#endregion DETERMINACIÓN DE ORDER BY

	DECLARE @tabla AS BKGaccountMovements
	
	INSERT INTO @tabla
	(
	    MovementId,
	    AccountBankIdentifier,
	    MovementDate,
	    Description,
	    Amount,
	    isDebit,
	    Balance,
	    MovementTypeId,
	    TypeDescription,
	    CheckId,
	    VoucherId
	)
	SELECT 
		MovementId 				= o.IdOperacion,
		AccountBankIdentifier	= c.Codigo,
		MovementDate 			= o.Fecha,
		Description 			= c.Descripcion,
		Amount 					= tf.MontoSubOperacion,
		isDebit 				= IIF(c.IdTipoDProducto=143,0,1),
		Balance 				= tf.SaldoCapital,
		MovementTypeId 			= tm.IdMovementType,
		TypeDescription 		= mov.Descripcion,
		CheckId					= 1,
		VoucherId				= CONCAT(tipop.Codigo,'-', o.Folio)
		FROM dbo.tGRLoperaciones o  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposOperacion tipop  WITH(NOLOCK) ON tipop.IdTipoOperacion = o.IdTipoOperacion
		INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = o.IdOperacion
		AND tf.IdEstatus=1 
		AND tf.IdTipoSubOperacion IN (500,501)
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta 
		AND c.Codigo=@ProductBankIdentifier
		INNER JOIN dbo.tBKGtipoMovimientoMovementTypes tm  WITH(NOLOCK) ON tm.IdTipoMovimiento=tf.IdTipoSubOperacion
		INNER JOIN dbo.tBKGcatalogoMovementTypes mov  WITH(NOLOCK) ON mov.Id=tm.IdMovementType
		WHERE o.IdTipoOperacion NOT IN (4) AND  o.IdEstatus=1 
		AND o.Fecha>@DateFromFilter 
		AND o.Fecha<@DateToFilter 

-- Implementación del ordenamiento dinamico		
		DECLARE @query AS nVARCHAR(MAX)=CONCAT('SELECT * FROM @tabla ',
												'ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,'ROWS ONLY')
			
	EXEC sys.sp_executesql @query, N'@Tabla BKGaccountMovements readonly',@tabla

