
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLauxiliarCuentaABCDVentanilla')
BEGIN
	DROP PROC pGRLauxiliarCuentaABCDVentanilla
	SELECT 'pGRLauxiliarCuentaABCDVentanilla BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pGRLauxiliarCuentaABCDVentanilla
	@pVentanilla VARCHAR(60) = '',
	@FechaInicial AS DATE ='19000101',
	@FechaFinal AS DATE='19000101'
AS 
BEGIN
		DECLARE @IdCuentaABCD AS INT =0
		SELECT @IdCuentaABCD=ISNULL(c.IdCuentaABCD,0) 
		FROM dbo.tGRLcuentasABCD c With (nolock) 
		WHERE c.Codigo=@pVentanilla

		
			
			select
			op.IdCorte AS Corte
			,CAST((tdo.Codigo +'-'+op.Serie + cast(op.Folio as VARCHAR(10)))as varchar(50))  as Operacion
			,t.Fecha
			,t.Concepto
			,t.Referencia
			,FORMAT(t.SaldoAnterior, 'C') AS SaldoAnterior
			,FORMAT(t.TotalAbonos, 'C') as Retiro
			,FORMAT(t.TotalCargos, 'C') as Deposito
			,FORMAT(t.Saldo	, 'C') AS Saldo			
			fROM dbo.tGRLcuentasABCD C  WITH(NOLOCK) 
					INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
						ON suc.IdSucursal = C.IdSucursal
					 INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) 
						ON sdo.IdCuentaABCD = C.IdCuentaABCD
					 INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
						ON ea.IdEstatusActual = C.IdEstatusActual
							AND ea.IdTipoDDominio=851
			inner JOIN tSDOtransacciones t with(NOLOCK)on t.IdSaldoDestino=sdo.IdSaldo
			inner join tGRLoperaciones op with(NOLOCK)on op.IdOperacion=t.IdOperacion
			inner join tCTLtiposOperacion tdo WITH(NOLOCK)on tdo.IdTipoOperacion=op.IdTipoOperacion
			WHERE t.IdEstatus!=18 
			AND c.IdCuentaABCD=@IdCuentaABCD  
			AND(@FechaInicial = '19000101' AND @FechaFinal = '19000101' OR(t.Fecha BETWEEN @FechaInicial AND @FechaFinal AND NOT(@FechaInicial = '19000101' AND @FechaFinal = '19000101')))
			


end

GO