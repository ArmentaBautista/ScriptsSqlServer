

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAGciclicasResumen')
BEGIN
	DROP PROC pCAPPAGciclicasResumen
	SELECT 'pCAPPAGciclicasResumen BORRADO' AS info
END
GO

CREATE PROCEDURE pCAPPAGciclicasResumen
	@TipoOperacion VARCHAR(10)='',
    @IdCapacidadPago INT = 0,
	@IdCuenta INT = 0
AS
BEGIN
	IF @TipoOperacion=''
		RETURN;

	IF @TipoOperacion='C'
	BEGIN
		-- Borramos lo que ya existe para ese trámite
		DELETE FROM tCAPPAGciclicasResumen WHERE IdCapacidadPago=@IdCapacidadPago
		
		DECLARE @PrecioTotalVenta NUMERIC(11,2);
		DECLARE @CostoProduccionAportacionSocio NUMERIC(11,2);
		DECLARE @FinanciamientoRequerido	NUMERIC(11,2);
		DECLARE @InteresesFinanciamiento	NUMERIC(11,2);
		DECLARE @IvaIntereses				NUMERIC(11,2);
		DECLARE @TotalPagarFinanciamiento	NUMERIC(11,2);

		-- 1. Calcular [PrecioTotalVenta]
		SELECT @PrecioTotalVenta = SUM(Total)
		FROM dbo.tCAPPAGciclicas  WITH(NOLOCK) 
		WHERE Tipo = 0 AND IdCapacidadPago = @IdCapacidadPago;

		-- 2. Calcular [CostoProduccionAportacionSocio]
		SELECT @CostoProduccionAportacionSocio = SUM(Monto)
		FROM dbo.tCAPPAGciclicasAportacionesSocio  WITH(NOLOCK) 
		WHERE IdCapacidadPago = @IdCapacidadPago;

		-- 3. Calcular FinanciamientoRequerido,InteresesFinanciamiento, IvaIntereses, TotalPagarFinanciamiento
		DECLARE @CuentaMontos TABLE(
			IdCuenta					INT,
			IdApertura					INT,
			MontoSolicitado				NUMERIC(11,2),
			Monto						NUMERIC(11,2),
			IdParcialidad				INT,
			Capital						NUMERIC(11,2),
			InteresOrdinarioEstimado	NUMERIC(11,2),
			IVAinteresOrdinarioEstimado NUMERIC(11,2)
		)

		INSERT INTO @CuentaMontos
		SELECT 
		c.idcuenta,
		c.IdApertura,
		c.MontoSolicitado,
		c.Monto,
		po.IdParcialidad,
		po.Capital,
		po.InteresOrdinarioEstimado,
		po.IVAinteresOrdinarioEstimado
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCparcialidadesOriginales po  WITH(NOLOCK) 
			ON po.IdCuenta = c.IdCuenta
				AND po.IdApertura=c.IdApertura
		WHERE c.IdCuenta=@IdCuenta
		
		SELECT 
		@FinanciamientoRequerido	= SUM(cm.Capital),
		@InteresesFinanciamiento	= SUM(cm.InteresOrdinarioEstimado),
		@IvaIntereses				= SUM(cm.IVAinteresOrdinarioEstimado),
		@TotalPagarFinanciamiento	= SUM(cm.Capital) + SUM(cm.InteresOrdinarioEstimado) + SUM(cm.IVAinteresOrdinarioEstimado)
		FROM @CuentaMontos cm 
		GROUP BY cm.IdCuenta

		-- Insertar en tCAPPAGciclicasResumen
		INSERT INTO dbo.tCAPPAGciclicasResumen
		(
			IdCapacidadPago,
			PrecioTotalVenta,
			CostoProduccionAportacionSocio,
			FinanciamientoRequerido,
			InteresesFinanciamiento,
			IvaIntereses,
			TotalPagarFinanciamiento
		)
		VALUES
		(
			@IdCapacidadPago, 
			@PrecioTotalVenta, 
			@CostoProduccionAportacionSocio,
			@FinanciamientoRequerido,
			@InteresesFinanciamiento,
			@IvaIntereses,			
			@TotalPagarFinanciamiento
		 )
		 
		 EXEC pCAPPAGciclicasResumen @TipoOperacion='R',@IdCapacidadPago=@IdCapacidadPago

		 RETURN 1;
	END

	IF @TipoOperacion='R'
	BEGIN
		SELECT 
		cr.IdResumenCiclica,
        cr.IdCapacidadPago,
        cr.PrecioTotalVenta,
        cr.MargenRiesgo,
        cr.PrecioAjustadoVenta,
        cr.CostoProduccionAportacionSocio,
        cr.PrecioAjustadoVentaMenosAportaciónSocio,
        cr.FinanciamientoRequerido,
        cr.InteresesFinanciamiento,
        cr.IvaIntereses,
        cr.TotalPagarFinanciamiento,
        cr.DisponibleActividadCiclica
		FROM dbo.tCAPPAGciclicasResumen cr  WITH(NOLOCK) 
		WHERE cr.IdCapacidadPago=@IdCapacidadPago

		RETURN 1
	END

END;
