
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaCuentaDeposito')
BEGIN
	DROP PROC pEMbusquedaCuentaDeposito
	SELECT 'pEMbusquedaCuentaDeposito BORRADO' AS info
END
GO

CREATE PROC pEMbusquedaCuentaDeposito
@cuenta AS VARCHAR(50)='',
@TipoCuenta AS VARCHAR(3)=''--PSV Personales cuentas de ahorro, PDD Personales cuentas de depósitos ,PIN Personales cuentas de inversión 
AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN
		
		DECLARE @IdCuenta AS INT=0
		

		SET @IdCuenta =ISNULL((SELECT c.IdCuenta FROM dbo.tAYCcuentas c With (nolock) WHERE c.Codigo=@cuenta),0)
		
		
		SELECT c.IdCuenta, c.Codigo AS CuentaCodigo,@TipoCuenta AS TipoCuenta,pf.Descripcion AS CuentaDescripcion
		,YEAR(c.FechaUltimaTransaccion) AS FechaUltimaTransaccionAño,
		LEFT (REPLACE(STR(MONTH(c.FechaUltimaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimaTransaccionMes
		,LEFT (REPLACE(STR(DAY(c.FechaUltimaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimaTransaccionDia
		,'Avail' AS TipoSaldo,CAST( IIF(sd.MontoDisponible=0,0,(sd.MontoDisponible -pf.SaldoMinimo) ) AS NUMERIC(38,2)) AS Saldo
		,YEAR(tf.FechaTransaccion) AS FechaUltimoDepositoAño,
		LEFT (REPLACE(STR(MONTH(tf.FechaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimoDepositoMes
		,LEFT (REPLACE(STR(DAY(tf.FechaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimoDepositoDia
		,CAST( tf.TotalCargos  AS NUMERIC(38,2)) AS MontoUltimoDeposito
		,YEAR(inte.FechaTransaccion) AS FechaUltimoPagoInteresAño,
		LEFT (REPLACE(STR(MONTH(inte.FechaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimoPagoInteresMes
		,LEFT (REPLACE(STR(DAY(inte.FechaTransaccion), 2), ' ', '0'),2 ) AS FechaUltimoPagoInteresDia
		
		,YEAR(c.FechaActivacion) AS FechaAperturaAño,
		LEFT (REPLACE(STR(MONTH(c.FechaActivacion), 2), ' ', '0'),2 ) AS FechaAperturaMes
		,LEFT (REPLACE(STR(DAY(c.FechaActivacion), 2), ' ', '0'),2 ) AS FechaAperturaDia
		,CASE c.IdEstatus
			WHEN 1 THEN 'Open'
			WHEN 7 THEN 'Closed'
			WHEN 61 THEN 'Block'
			ELSE 'Other' END AS EstatusCuenta,'' AS FechaUltimoEstadoCuentaAño,'' AS FechaUltimoEstadoCuentaMes,'' AS FechaUltimoEstadoCuentaDia,'MXN' AS CodigoMoneda
		,soc.Codigo AS CodigoSocio,per.Nombre AS NombreSocio,'MXN' AS CodigoMonedaUltimoDeposito
		,YEAR(c.VencimientoCapital) AS FechaVencimientoAño,
		LEFT (REPLACE(STR(MONTH(c.VencimientoCapital), 2), ' ', '0'),2 ) AS FechaVencimientoMes
		,LEFT (REPLACE(STR(DAY(c.VencimientoCapital), 2), ' ', '0'),2 ) AS FechaVencimientoDia
		,ISNULL(clabe.CLABE,'') AS Clabe
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tAYCproductosFinancieros pf WITH (NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		JOIN dbo.tSCSsocios soc WITH(NOLOCK)ON soc.IdSocio = c.IdSocio
		JOIN dbo.tGRLpersonas per WITH(NOLOCK)ON per.IdPersona = soc.IdPersona
		JOIN dbo.tSDOsaldos sd WITH(NOLOCK)ON sd.IdSaldo = c.IdSaldo
		LEFT JOIN dbo.tAYCcuentasCLABE clabe With (nolock) ON clabe.IdCuenta = c.IdCuenta
		--JOIN dbo.tAYCproductosFinancierosMontosEntumovil pme With (nolock) ON pme.IdProductoFinanciero = pf.IdProductoFinanciero 
		--LEFT JOIN dbo.fAYCsaldo( 0) s ON s.idcuenta=c.idcuenta
		LEFT JOIN (SELECT tf.IdCuenta, tf.TotalCargos,tf.Fecha AS FechaTransaccion,ROW_NUMBER()OVER(PARTITION BY tf.IdCuenta ORDER BY fecha DESC) AS numero
					FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
					WHERE  tf.IdTipoSubOperacion=500 AND tf.IdCuenta=@IdCuenta
					) AS tf ON tf.IdCuenta=c.IdCuenta AND tf.numero=1
		LEFT JOIN (
					SELECT tf.IdCuenta, tf.TotalCargos,tf.Fecha AS FechaTransaccion,ROW_NUMBER()OVER(PARTITION BY tf.IdCuenta ORDER BY fecha DESC) AS numero
					FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
					WHERE  tf.IdTipoSubOperacion=4 AND tf.IdCuenta=@IdCuenta
					) AS inte ON inte.IdCuenta=c.IdCuenta AND inte.numero = 1
		WHERE c.IdCuenta=@IdCuenta AND c.IdTipoDProducto!=143
		AND c.IdEstatus=1 AND c.EsMancomunada=0
		--AND pme.IdEstatus=1 --AND pme.EsVisibleMovil=1
	END
 











GO

