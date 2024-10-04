

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDmontosAgrupadosEfectivoPorFecha')
BEGIN
	DROP PROC pCnPLDmontosAgrupadosEfectivoPorFecha
	SELECT 'pCnPLDmontosAgrupadosEfectivoPorFecha BORRADO' AS info
END
GO

CREATE PROC pCnPLDmontosAgrupadosEfectivoPorFecha
@pFechaInicial DATE = '19000101',
@pFechaFinal DATE = '19000101',
@pMontoAcumulado NUMERIC(18,2)=0
AS
BEGIN
		IF @pFechaInicial='19000101' OR @pFechaFinal='19000101'
		BEGIN
			SELECT 'El valor de las fechas no puede ser 19000101' AS INFO
			RETURN -1
		END

		IF @pFechaInicial > @pFechaFinal
		BEGIN
			SELECT 'La fecha inicial no puede ser mayor a la fecha final' AS INFO
			RETURN -1
		END

		IF @pMontoAcumulado<=0
		BEGIN
			SELECT 'El monto acumulado no puede ser igual o menor a CERO' AS INFO
			RETURN -1
		END

		
		DECLARE @fechaInicial DATE = @pFechaInicial
		DECLARE @fechaFinal DATE = @pFechaFinal
		DECLARE @montoAcumulado NUMERIC(18,2)=@pMontoAcumulado


		SELECT 
		 tf.NoSocio		
		,tf.Nombre
		,Acumulado		= FORMAT(SUM(td.Monto),'N2','es-MX')
		FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
		INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON op.IdOperacion = td.IdOperacion
		AND op.IdEstatus= 1
		AND td.IdMetodoPago IN (-2,-10)
		AND td.EsCambio=0
		INNER JOIN (
				SELECT tf.IdOperacion, sc.Codigo AS NoSocio, p.Nombre 
				FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
				INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta
				INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
				INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
				WHERE tf.IdEstatus=1
				AND tf.Fecha BETWEEN @fechaInicial and @fechaFinal
				AND tf.IdTipoSubOperacion=500
				GROUP BY tf.IdOperacion, sc.Codigo, p.Nombre 
		) tf ON tf.IdOperacion = op.IdOperacion 
		WHERE op.IdEstatus=1
		GROUP BY tf.NoSocio, tf.Nombre, td.IdTransaccionD
		HAVING SUM(td.Monto)>=@montoAcumulado


END



