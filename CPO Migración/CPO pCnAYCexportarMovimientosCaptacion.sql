

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCexportarMovimientosCaptacion')
BEGIN
	DROP PROC pCnAYCexportarMovimientosCaptacion
	SELECT 'pCnAYCexportarMovimientosCaptacion BORRADO' AS info
END
GO

CREATE PROC dbo.pCnAYCexportarMovimientosCaptacion
@FechaInicial DATE='19000101',
@FechaFinal DATE='19000101',
@BorrarTabla BIT=0
AS
BEGIN
	IF @FechaInicial='19000101' OR @FechaFinal='19000101'
	BEGIN
		SELECT 'Se requieren 2 fechas válidas';
		RETURN 0;
    END

	IF @BorrarTabla=1
		TRUNCATE TABLE iERP_OBL_RPT.cpo.MovimientosCaptacion

	DECLARE @StartDate DATE = @FechaInicial;
	DECLARE @EndDate DATE = @FechaFinal;
	DECLARE @CurrentDate DATE;

	DECLARE DateCursor CURSOR FAST_FORWARD READ_ONLY FOR
			SELECT 
			TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
			DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) - 1, @StartDate) AS DateValue
			FROM master..spt_values;
	OPEN DateCursor;
	FETCH NEXT FROM DateCursor INTO @CurrentDate;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO iERP_OBL_RPT.cpo.MovimientosCaptacion
		(TipoOperacion,Folio,Sucursal,Fecha,Hora,NoSocio,Nombre,NoCuenta,Producto,TipoProducto,TipoMovimiento,MetodoPago,SaldoCapitalAnterior,Monto,SaldoCapital,Usuario)
		EXEC dbo.pAYCdesagregadoOperacionesCaptacionMetodoPagoCPO @FechaInicial=@CurrentDate,
																	@FechaFinal=@CurrentDate

		FETCH NEXT FROM DateCursor INTO @CurrentDate;
	END
	CLOSE DateCursor;
	DEALLOCATE DateCursor;

	SELECT 'Proceso Completado!' AS Info

END
GO



