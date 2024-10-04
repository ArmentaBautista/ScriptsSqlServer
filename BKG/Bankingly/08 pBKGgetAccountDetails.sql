
-- [8] Cuentas - GetAccountDetails


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountDetails')
BEGIN
	DROP PROC pBKGgetAccountDetails
	SELECT 'pBKGgetAccountDetails BORRADO' AS info
END
GO

CREATE PROC pBKGgetAccountDetails
@ProductBankIdentifier AS VARCHAR(32)
AS
BEGIN	

--#region  
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
--  DEFINICIONES
AccountBankIdentifier						string	Identificador de la cuenta
AccountOfficerName							String	Nombre del oficial de cuenta
AccountCountableBalance						Decimal	Saldo o balance contable de la cuenta
AccountAvailableBalance						Decimal	Saldo o balance disponible de la cuenta
AccountBalance24Hrs							Decimal	Saldo o balance hace 24 hs
AccountBalance48Hrs							Decimal	Saldo o balance hace 48 hs
AccountBalance48MoreHrs						Decimal	Saldo o balance hace más de 48 hs
MonthlyAverageBalance						Decimal	Saldo o balance promedio mensual
PendingChecks								Int		Cheques pendientes de acreditación/débito de la cuenta
ChecksToReleaseToday						Int		Cheques a liberar en el día
ChecksToReleaseTomorrow						Int		Cheques a liberar en el día siguiente
CancelledChecks								Int		Cheques cancelados
CertifiedChecks								Int		Cheques certificados
RejectedChecks								Int		Cheques rechazados
BlockedAmount								Decimal	Monto bloqueado de uso
MovementsOfTheMonth							Int		Cantidad de movimientos del mes.
ChecksDrawn									Int		Cheques firmados
Overdrafts									Decimal	Sobregiro de la cuenta
ProductBranchName							string	Nombre de la sucursal de la cuenta
ProductOwnerName							string	Nombre del responsable de la cuenta
ShowCurrentAccountChecksInformation			bool	Despliega la información de cheques para las cuentas corrientes
*/
--#endregion

DECLARE @fechaActual AS DATE=GETDATE();
DECLARE @fechaHoy AS DATE=DATEADD(DAY,-1,@fechaActual);
DECLARE @fecha24antes AS DATE=DATEADD(DAY,-2,@fechaActual);
DECLARE @fecha48antes AS DATE=DATEADD(DAY,-3,@fechaActual);
DECLARE @fecha48mas AS DATE=DATEADD(DAY,-4,@fechaActual);
DECLARE @FechaInicioMes AS DATE= DATEADD(month, DATEDIFF(month, 0, @fechaActual), 0)

DECLARE @cuenta AS TABLE(
	IdCuenta			INT,
	Nocuenta			VARCHAR(30),
	IdSocio				INT,
	Nombre				VARCHAR(250),
	IdUsuarioAlta		INT,
	UsuarioAlta			VARCHAR(40),
	IdSucusal			INT,
	Sucursal			VARCHAR(80),
	IdEstatus			INT,
	IdTipoDproducto		INT
)

INSERT INTO @cuenta
(
    IdCuenta,
    Nocuenta,
    IdSocio,
    Nombre,
    IdUsuarioAlta,
    UsuarioAlta,
    IdSucusal,
    Sucursal,
	IdEstatus,
	IdTipoDproducto
)
SELECT c.IdCuenta,c.Codigo, sc.IdSocio, p.Nombre, u.IdUsuario, u.Usuario, suc.IdSucursal, suc.Descripcion, c.IdEstatus, c.IdTipoDProducto 
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = c.IdUsuarioAlta
WHERE c.Codigo=@ProductBankIdentifier

declare @saldos AS TABLE
(
	Fecha							DATE,
	IdCuenta						INT,
	IdTipoDproducto					INT,
	Capital							NUMERIC(18,2),
	InteresOrdinario 				NUMERIC(18,2),
	InteresMoratorioVigente 		NUMERIC(18,2),
	InteresMoratorioVencido 		NUMERIC(18,2),
	InteresMoratorioCuentasOrden 	NUMERIC(18,2),
	IVAInteresOrdinario 			NUMERIC(18,2),
	IVAinteresMoratorio 			NUMERIC(18,2),
	Cargos 							NUMERIC(18,2),
	CargosImpuestos					NUMERIC(18,2),
	SaldoTotalCredito				AS (Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos),
	InteresPendienteCapitalizar		NUMERIC(18,2),
	MontoBloqueado					NUMERIC(18,2),
	MontoDisponible					NUMERIC(18,2),
	Saldo							NUMERIC(18,2),
	SaldoBalanceCuentasOrden		NUMERIC(18,2),
	IdEstatus						INT
)

	IF EXISTS(SELECT 1 FROM @cuenta WHERE IdTipoDproducto=143)
	BEGIN
		-- Crédito
		INSERT INTO @saldos
		(
			Fecha,
			IdCuenta,
			IdTipoDproducto,
			Capital,
			InteresOrdinario,
			InteresMoratorioVigente,
			InteresMoratorioVencido,
			InteresMoratorioCuentasOrden,
			IVAInteresOrdinario,
			IVAinteresMoratorio,
			Cargos,
			CargosImpuestos,
			IdEstatus
		)
		SELECT 
			cartera.FechaCartera,
			cartera.IdCuenta,
			143,
			cartera.Capital,
			cartera.InteresOrdinario,
			cartera.InteresMoratorioVigente,
			cartera.InteresMoratorioVencido,
			cartera.InteresMoratorioCuentasOrden,
			cartera.IVAInteresOrdinario,
			cartera.IVAinteresMoratorio,
			cartera.Cargos,
			cartera.CargosImpuestos,
			cta.IdEstatus
		FROM dbo.tAYCcartera cartera  WITH(NOLOCK) 
		INNER JOIN @cuenta cta ON cta.IdCuenta = cartera.IdCuenta
		WHERE cartera.FechaCartera IN (@fechaHoy,@fecha24antes,@fecha48antes)
	END
	ELSE	
	BEGIN
		-- Captación
		INSERT INTO @saldos
		(
			Fecha,
			IdCuenta,
			IdTipoDproducto,
			Capital,
			InteresOrdinario,
			InteresPendienteCapitalizar,
			MontoBloqueado,
			MontoDisponible,
			Saldo,
			SaldoBalanceCuentasOrden,
			IdEstatus
		)
		SELECT 
			   c.fecha,
			   c.IdCuenta,
			   c.IdTipoDproducto,
			   c.Capital,
			   c.InteresOrdinario,
			   c.InteresPendienteCapitalizar,
			   c.MontoBloqueado,
			   c.MontoDisponible,
			   c.Saldo,
			   c.SaldoBalanceCuentasOrden,
			   c.IdEstatus 
		FROM dbo.tAYCcaptacion c  WITH(NOLOCK) 
		INNER JOIN @cuenta cta ON cta.IdCuenta = c.IdCuenta
		WHERE c.Fecha IN (@fecha24antes,@fecha48antes,@fecha48mas)

		-- Captación Hoy
		INSERT INTO @saldos
		(
			Fecha,IdCuenta,IdTipoDproducto,Capital,InteresOrdinario,InteresPendienteCapitalizar,MontoBloqueado,MontoDisponible,Saldo,SaldoBalanceCuentasOrden,IdEstatus
		)
		SELECT 
		@fechaHoy,c.IdCuenta,c.IdTipoDproducto,fs.Capital,fs.InteresOrdinario,fs.InteresPendienteCapitalizar,fs.MontoBloqueado,fs.MontoDisponible,fs.Saldo,fs.SaldoBalanceCuentasOrden,c.IdEstatus FROM @cuenta c 
		INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta AND c.IdTipoDproducto <> 143
	END

-- Saldo promedio
DECLARE @saldoPromedio AS NUMERIC(18,2)=0

IF EXISTS(SELECT 1 FROM @cuenta cta WHERE cta.IdTipoDproducto<>143)
BEGIN	
		SELECT @saldoPromedio=AVG(cap.Capital) 
		FROM dbo.tAYCcaptacion cap  WITH(NOLOCK)
		INNER JOIN @cuenta cta ON cta.IdCuenta = cap.IdCuenta
		WHERE cap.Fecha BETWEEN @FechaInicioMes AND @fechaHoy
END

-- Movimientos
DECLARE @movimientosDelMes INT;
SELECT @movimientosDelMes=COUNT(1) FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
									INNER JOIN @cuenta cta ON cta.IdCuenta = tf.IdCuenta
									WHERE tf.IdEstatus=1 AND tf.IdTipoSubOperacion IN (500,501) AND tf.Fecha BETWEEN @FechaInicioMes AND @fechaHoy


SELECT 
AccountBankIdentifier				= ctas.Nocuenta	,
AccountOfficerName					= ctas.UsuarioAlta	,
AccountCountableBalance				= IIF(sdoAct.IdTipoDproducto=143,sdoAct.SaldoTotalCredito,sdoAct.saldo),
AccountAvailableBalance				= IIF(sdoAct.IdTipoDproducto=143,0,sdoAct.MontoDisponible)	,
AccountBalance24Hrs					= IIF(sdo24.IdTipoDproducto=143,sdo24.SaldoTotalCredito,sdo24.saldo)	,
AccountBalance48Hrs					= IIF(sdo48.IdTipoDproducto=143,sdo48.SaldoTotalCredito,sdo48.saldo)	,
AccountBalance48MoreHrs				= IIF(sdo48ant.IdTipoDproducto=143,sdo48ant.SaldoTotalCredito,sdo48ant.saldo)	,
MonthlyAverageBalance				= @saldoPromedio	,
PendingChecks						= 0	,
ChecksToReleaseToday				= 0	,
ChecksToReleaseTomorrow				= 0	,
CancelledChecks						= 0	,
CertifiedChecks						= 0	,
RejectedChecks						= 0	,
BlockedAmount						= IIF(sdoAct.IdTipoDproducto=143,0,sdoAct.MontoBloqueado)	,
MovementsOfTheMonth					= @movimientosDelMes	,
ChecksDrawn							= 1	,
Overdrafts							= 1	,
ProductBranchName					= ctas.Sucursal	,
ProductOwnerName					= ctas.Nombre	,
ShowCurrentAccountChecksInformation	= 0	
FROM @cuenta ctas  
LEFT JOIN @saldos sdoAct  ON sdoAct.IdCuenta = ctas.IdCuenta AND sdoAct.Fecha=@fechaHoy
LEFT JOIN @saldos sdo24  ON sdo24.IdCuenta = ctas.IdCuenta AND sdo24.Fecha=@fecha24antes
LEFT JOIN @saldos sdo48  ON sdo48.IdCuenta = ctas.IdCuenta AND sdo48.Fecha=@fecha48antes
LEFT JOIN @saldos sdo48ant  ON sdo48ant.IdCuenta = ctas.IdCuenta AND sdo48ant.Fecha=@fecha48mas
WHERE ctas.Nocuenta=@ProductBankIdentifier

END
GO