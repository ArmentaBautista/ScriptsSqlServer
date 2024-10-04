
-- [10] GetAccountMovements

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountMovements')
BEGIN
	DROP PROC pBKGgetAccountMovements
	SELECT 'pBKGgetAccountMovements BORRADO' AS info
END
GO

CREATE PROC pBKGgetAccountMovements
@ProductBankIdentifier AS VARCHAR(32),
@DateFromFilter	AS DATE='19000101',
@DateToFilter AS DATE='19000101',
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=0,
@PageSize AS INT=0
AS
BEGIN
		DECLARE @fechaHoy AS DATE=GETDATE();
		IF @DateToFilter='19000101'
			SET @DateToFilter=@fechaHoy
		
		-- Establecer datos de la paginación
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Dterminación de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='MovementId DESC'

		-- Consulta en Inserción en la tabla
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
		isDebit 				= IIF(tf.IdTipoSubOperacion=500,0,1),
		Balance 				= tf.SaldoCapital,
		MovementTypeId 			= tm.IdMovementType,
		TypeDescription 		= mov.Descripcion,
		CheckId					= 1,
		-- VoucherId				= CONCAT(tipop.Codigo,'-', o.Folio)
		VoucherId				= o.Folio
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
		AND o.Fecha BETWEEN @DateFromFilter AND @DateToFilter 
		
		-- Implementación de Ordenamiento dinámico
		DECLARE @query AS nVARCHAR(MAX)=CONCAT('SELECT * FROM @tabla ',
												'ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,'ROWS ONLY')
			
		EXEC sys.sp_executesql @query, N'@Tabla BKGaccountMovements readonly',@tabla	

END
GO
