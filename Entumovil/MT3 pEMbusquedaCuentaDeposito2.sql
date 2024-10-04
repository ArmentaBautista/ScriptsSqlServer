
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaCuentaDeposito2')
BEGIN
	DROP PROC pEMbusquedaCuentaDeposito2
	SELECT 'pEMbusquedaCuentaDeposito2 BORRADO' AS info
END
GO

CREATE PROC pEMbusquedaCuentaDeposito2
@cuenta AS VARCHAR(50)='',
@TipoCuenta AS VARCHAR(3)=''--PSV Personales cuentas de ahorro, PDD Personales cuentas de depósitos ,PIN Personales cuentas de inversión 
AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN
		
		DECLARE @IdCuenta AS INT=0
		SET @IdCuenta =ISNULL((SELECT c.IdCuenta FROM dbo.tAYCcuentas c With (nolock) WHERE c.Codigo=@cuenta),0)
		
		DECLARE @TotalCargos AS NUMERIC(38,2)=0.0, @Fecha AS DATE='19000101' 
		SELECT TOP 1 @TotalCargos=tf.TotalCargos,@Fecha=tf.Fecha
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
		WHERE  tf.IdTipoSubOperacion=500 AND tf.IdCuenta=@IdCuenta
		ORDER BY tf.Fecha DESC, tf.IdTransaccion DESC

		SELECT c.IdCuenta, c.Codigo AS CuentaCodigo,@TipoCuenta AS TipoCuenta,c.Descripcion AS CuentaDescripcion
		,YEAR(c.FechaUltimaTransaccion) AS FechaUltimaTransaccionAño,
		LEFT (REPLACE(STR(MONTH(c.FechaUltimaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimaTransaccionMes
		,LEFT (REPLACE(STR(DAY(c.FechaUltimaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimaTransaccionDia
		,'Avail' AS TipoSaldo,
		sd.Saldo AS Saldo
		--CAST( IIF(sd.MontoDisponible=0,0,(sd.MontoDisponible -pf.SaldoMinimo) ) AS NUMERIC(38,2)) AS Saldo
		,YEAR(@Fecha) AS FechaUltimoDepositoAño
		,FORMAT(MONTH(@Fecha),'00') AS FechaUltimoDepositoMes
		,FORMAT(DAY(@Fecha),'00') AS FechaUltimoDepositoDia
		,@TotalCargos AS MontoUltimoDeposito
		,YEAR(cEstadistica.UltimoPagoInteres) AS FechaUltimoPagoInteresAño,
		FORMAT(MONTH(cEstadistica.UltimoPagoInteres), '00') AS FechaUltimoPagoInteresMes
		,FORMAT(DAY(cEstadistica.UltimoPagoInteres), '00') AS FechaUltimoPagoInteresDia
		
		,YEAR(c.FechaActivacion) AS FechaAperturaAño,
		FORMAT(MONTH(c.FechaActivacion),'00') AS FechaAperturaMes
		,FORMAT(DAY(c.FechaActivacion), '00') AS FechaAperturaDia
		,CASE c.IdEstatus
			WHEN 1 THEN 'Open'
			WHEN 7 THEN 'Closed'
			WHEN 61 THEN 'Block'
			ELSE 'Other' END AS EstatusCuenta,'' AS FechaUltimoEstadoCuentaAño,'' AS FechaUltimoEstadoCuentaMes,'' AS FechaUltimoEstadoCuentaDia,'MXN' AS CodigoMoneda
		,soc.Codigo AS CodigoSocio,per.Nombre AS NombreSocio,'MXN' AS CodigoMonedaUltimoDeposito
		,YEAR(c.VencimientoCapital) AS FechaVencimientoAño,
		FORMAT(MONTH(c.VencimientoCapital), '00' ) AS FechaVencimientoMes
		,FORMAT(DAY(c.VencimientoCapital), '00' ) AS FechaVencimientoDia
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tAYCproductosFinancieros pf WITH (NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		JOIN dbo.tSCSsocios soc WITH(NOLOCK)ON soc.IdSocio = c.IdSocio
		JOIN dbo.tGRLpersonas per WITH(NOLOCK)ON per.IdPersona = soc.IdPersona
		JOIN dbo.tSDOsaldos sd WITH(NOLOCK)ON sd.IdSaldo = c.IdSaldo
		INNER JOIN dbo.tAYCcuentasEstadisticas cEstadistica  WITH(NOLOCK) ON cEstadistica.IdCuenta = c.IdCuenta AND cEstadistica.IdApertura = c.IdApertura
		WHERE c.IdCuenta=@IdCuenta AND c.IdTipoDProducto!=143
		AND c.IdEstatus=1
		
END
 
GO

