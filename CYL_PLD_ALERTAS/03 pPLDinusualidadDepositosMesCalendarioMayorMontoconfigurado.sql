
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDinusualidadDepositosMesCalendarioMayorMontoconfigurado')
BEGIN
	DROP PROC tPLDinusualidadDepositosMesCalendarioMayorMontoconfigurado
	SELECT 'tPLDinusualidadDepositosMesCalendarioMayorMontoconfigurado BORRADO' AS info
END
GO

CREATE PROC tPLDinusualidadDepositosMesCalendarioMayorMontoconfigurado
AS
BEGIN

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- JCA 230620
-- Depósitos en efectivo fraccionados en un mes calendario con un monto mayor o igual a $150,000.00; ** Monto configurable
-- TODO 1. Crear parámetro de configuracion PLD para el monto

	DECLARE @Fecha AS DATE= GETDATE()
	DECLARE @MontoAgrupado AS NUMERIC(12,2)=150000
	DECLARE @FechaInicial AS DATE=(SELECT DATEADD(DAY,1,EOMONTH(@Fecha,-1)))
	DECLARE @FechaFinal AS DATE=(SELECT EOMONTH(@Fecha))

	-- Tabla para transacciones en efectivo
	DECLARE @transaccionesD AS TABLE(
		IdOperacion			INT,
		Fecha				DATE,
		Total				NUMERIC(23,8),
		IdTransaccionD		INT,
		IdMetodoPago		INT,
		Monto				NUMERIC(23,8)
	)

	INSERT INTO @transaccionesD 
	SELECT op.IdOperacion, op.Fecha, op.Total, td.IdTransaccionD, td.IdMetodoPago, td.Monto
	FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK)
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = td.IdEstatusActual
			AND ea.IdEstatus=1
	INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
		ON op.IdOperacion = td.IdOperacion
			AND op.IdEstatus=1
			AND op.Fecha BETWEEN @FechaInicial AND @FechaFinal
	WHERE td.IdMetodoPago IN (-2,-10) 
		AND td.IdTipoSubOperacion=500
		AND td.EsCambio=0
	
	
	-- Tabla para financieras
	DECLARE @financieras AS TABLE(
		IdOperacion		INT,
		IdSocio			INT,
		IdPersona		INT,
		Codigo			VARCHAR(20),
		Nombre			VARCHAR(250)
	)

	INSERT INTO @financieras
	SELECT f.IdOperacion, sc.IdSocio, p.IdPersona, sc.Codigo, p.Nombre
	FROM @transaccionesD td
	INNER JOIN dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) 
		ON f.IdOperacion = td.IdOperacion
			AND f.IdEstatus=1
			AND f.IdTipoSubOperacion=500
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		ON c.IdCuenta = f.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = sc.IdPersona

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	-- Insert Operación PLD 
	-- IdTipoDoperacion 1593 -- IdEstatusAtencion 46 -- IdtipoDdominio 1598

	INSERT INTO dbo.tPLDoperaciones
	(
		IdPersona,
		IdTipoDoperacionPLD,
		IdEstatusAtencion,
		Monto,
		IdEstatus,
		IdUsuarioAlta,
		IdTipoDDominio,
		IdSesion,
		Texto,
		IdOperacionOrigen,
		IdTransaccionD,
		TipoIndicador,
		MontoReferencia,
		IdSocio,
		IdCuenta,
		Descripcion,
		GeneradaDesdeSistema,
		IdInusualidad,
		IdMetodoPago
	)
	SELECT f.IdPersona,1593,46,m.MontoAcumulado,1,-1,1598,0
	,CONCAT('Depósitos en efectivo fraccionados en un mes calendario con un monto mayor o igual a ', m.MontoAcumulado)
	,0,0
	,CONCAT('Depósitos en efectivo fraccionados en un mes calendario con un monto mayor o igual a ', FORMAT(@MontoAgrupado,'C','es-MX'))
	,@MontoAgrupado,f.IdSocio,0
	,CONCAT(f.Codigo,' ',f.Nombre,' Depósitos en efectivo fraccionados en un mes calendario con un monto mayor o igual a ', m.MontoAcumulado)
	,1,101,-2
	FROM @financieras f
	INNER JOIN (
				SELECT f.IdSocio, FORMAT(SUM(d.Monto),'C','es-MX') AS MontoAcumulado
				FROM @transaccionesD d 
				INNER JOIN @financieras f 
					ON f.IdOperacion = d.IdOperacion
				GROUP BY f.IdSocio
				HAVING SUM(d.Monto)>=@MontoAgrupado
				) m
					ON m.IdSocio = f.IdSocio


END -- sp
