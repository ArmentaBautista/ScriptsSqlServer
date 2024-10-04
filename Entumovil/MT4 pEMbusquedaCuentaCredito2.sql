
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaCuentaCredito2')
BEGIN
	DROP PROC pEMbusquedaCuentaCredito2
	SELECT 'pEMbusquedaCuentaCredito2 BORRADO' AS info
END
GO

CREATE PROC pEMbusquedaCuentaCredito2
@cuenta AS VARCHAR(50)='',
@TipoCuenta AS VARCHAR(3)=''--PLN Personales cuentas de prestamo


AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN

	
	
		DECLARE @CapitalAlDia AS NUMERIC(18,2)=0
		DECLARE @InteresOrdinarioTotal AS NUMERIC(18,2)=0
		DECLARE @InteresMoratorioTotal AS NUMERIC(18,2)=0
		DECLARE @SaldoAlDía AS NUMERIC(18,2)=0
		DECLARE @IdSocio AS INT=0
		DECLARE @IdCuenta AS INT=0
		DECLARE @PrimerVencimientoPendienteCapital AS DATE='19000101'
		DECLARE @MontoProximoPago AS NUMERIC(18,2)=0

		SELECT @IdCuenta =ISNULL(IdCuenta,0),@IdSocio=ISNULL(IdSocio,0),
		@PrimerVencimientoPendienteCapital=PrimerVencimientoPendienteCapital
		FROM dbo.tAYCcuentas With (nolock) 
		WHERE IdEstatus=1 AND IdTipoDProducto =143 and Codigo=@cuenta

		IF @IdCuenta=0
			RETURN 0
			

		SELECT @SaldoAlDía=ISNULL(CAST( TotalALiquidar AS NUMERIC(38,2)),0) 
		,@InteresOrdinarioTotal =ISNULL(CAST( InteresOrdinarioTotal AS NUMERIC(38,2)),0)
		,@InteresMoratorioTotal=ISNULL(CAST( InteresMoratorioTotal AS NUMERIC(38,2)),0)
		,@MontoProximoPago=ISNULL(CAST( SaldoExigible AS NUMERIC(38,2)),0)
		FROM dbo.fAYCcalcularCarteraOperacion(GETDATE(),2,@IdCuenta,@IdSocio,'devpag')

		SELECT c.IdCuenta
		, c.Codigo AS CuentaCodigo
		,@TipoCuenta AS TipoCuenta
		,c.Descripcion AS CuentaDescripcion
		,YEAR(c.FechaUltimaTransaccion) AS FechaUltimaTransaccionAño
		,FORMAT(MONTH(c.FechaUltimaTransaccion), '00') AS FechaUltimaTransaccionMes
		,FORMAT(DAY(c.FechaUltimaTransaccion), '00') AS FechaUltimaTransaccionDia
		,c.InteresOrdinarioAnual AS TasaInteres,
		CASE tp.IdTipoD
			WHEN 296 THEN 'Months'
			WHEN 720 THEN 'Days'
			ELSE 'Indefinite' 
		END AS Plazo
		,c.NumeroParcialidades AS NumeroUnidadesPlazo
		,tp.Descripcion AS UnidadesPlazo
		,'PayoffAmt' AS TipoSaldo
		,@SaldoAlDía AS Saldo
		,@SaldoAlDía AS CapitalAlDia
		,@InteresOrdinarioTotal AS InteresOrdinario
		,@InteresMoratorioTotal AS InteresMoratorio
		,YEAR(c.Vencimiento) AS FechaVencimientoAño
		,FORMAT(MONTH(c.Vencimiento), '00') AS FechaVencimientoMes
		,FORMAT(DAY(c.Vencimiento), '00') AS FechaVencimientoDia
		,YEAR(c.FechaAlta) AS FechaAperturaAño,
		FORMAT(MONTH(c.FechaAlta), '00') AS FechaAperturaMes
		,FORMAT(DAY(c.FechaAlta), '00') AS FechaAperturaDia
		,0 AS NumeroPagosRemanentes
		,'' AS DescripcionGarantia
		,'' AS FechaPagoDeudaAño
		,'' AS FechaPagoDeudaMes
		,'' AS FechaPagoDeudaDia
		,YEAR(tfin.fecha) AS FechaUltimoPagoAño
		,FORMAT(MONTH(tfin.fecha), '00') AS FechaUltimoPagoMes
		,FORMAT(DAY(tfin.fecha), '00') AS FechaUltimoPagoDia
		,CAST( tfin.TotalCargos  AS NUMERIC(38,2)) AS MontoUltimoPago
		,0 AS NumeroPagosMora -- ** Revisar sino son necesarios
		,0 AS DiasMora,			-- ** Revisar sino son necesarios
		'' AS FechaSiguientePagoAño -- ** Revisar sino son necesarios
		,'' AS FechaSiguientePagoMes -- ** Revisar sino son necesarios
		,'' AS FechaSiguientePagoDia -- ** Revisar sino son necesarios
		,s.Codigo AS SocioCodigo
		,p.Nombre AS NombreSocio
		,CASE c.IdEstatus
			WHEN 1 THEN 'Open'
			WHEN 7 THEN 'Closed'
			WHEN 61 THEN 'Block'
			ELSE 'Other' 
		END AS EstatusCuenta
		,'MXN' AS CodigoMoneda
		,@MontoProximoPago as MontoProximoPago
		,c.MontoEntregado as MontoCredito
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio = c.IdSocio 
		JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona = s.IdPersona
		JOIN dbo.tAYCproductosFinancierosMontosEntumovil pme With (nolock) ON pme.IdProductoFinanciero = c.IdProductoFinanciero
		JOIN dbo.tSDOsaldos sd WITH(NOLOCK)ON sd.IdSaldo = c.IdSaldo
		JOIN dbo.tCTLtiposD tp WITH(NOLOCK)ON tp.IdTipoD = c.IdTipoDPlazo
		LEFT JOIN (					
					SELECT  fecha ,tf.IdCuenta,tf.TotalCargos,ROW_NUMBER()OVER(PARTITION BY tf.IdCuenta ORDER BY tf.Fecha,tf.IdTransaccion) AS numero 
					FROM dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)
					WHERE  tf.IdTipoSubOperacion=500 and tf.idcuenta=@idcuenta
					) AS tfin ON tfin .idcuenta=c.idcuenta AND tfin.numero=1
		WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1 AND c.idcuenta=@idcuenta
		AND pme.IdEstatus=1 AND pme.EsVisibleMovil=1
	END
 







  

GO

