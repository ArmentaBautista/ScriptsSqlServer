


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcaptacion')
BEGIN
	DROP PROC pAYCcaptacion
	SELECT 'pAYCcaptacion BORRADO' AS info
END
GO

CREATE PROC pAYCcaptacion
AS
BEGIN
	
	DECLARE @fecha AS DATE=DATEADD(DAY,-1,GETDATE());
	DECLARE @alta AS DATETIME=GETDATE();
	DECLARE @inicioDeAño DATE= DATEFROMPARTS(YEAR(@fecha), 1, 1)

	DELETE FROM dbo.tAYCcaptacion WHERE fecha<@inicioDeAño

	IF EXISTS(SELECT 1 FROM tAYCcaptacion c  WITH(NOLOCK) WHERE c.fecha=@fecha)
		DELETE FROM dbo.tAYCcaptacion WHERE fecha=@fecha


	INSERT INTO dbo.tAYCcaptacion
	(
		Fecha,
		IdTipoDproducto,
	    IdCuenta,
	    IdSaldo,
	    Capital,
	    InteresOrdinario,
	    InteresPendienteCapitalizar,
	    MontoBloqueado,
	    MontoDisponible,
	    Saldo,
	    SaldoBalanceCuentasOrden,
	    IdEstatus,
		Alta
	)
	SELECT @fecha,
		   c.IdTipoDProducto,
		   sdo.IdCuenta,
           sdo.IdSaldo,
           sdo.Capital,
           sdo.InteresOrdinario,
           sdo.InteresPendienteCapitalizar,
           sdo.MontoBloqueado,
           sdo.MontoDisponible,
           sdo.Saldo,
           sdo.SaldoBalanceCuentasOrden,
           sdo.IdEstatus,
		   @alta
	FROM dbo.fAYCsaldo(0) sdo 
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = sdo.IdCuenta 
	AND c.IdTipoDProducto IN (144,398)
	WHERE sdo.IdCuenta<>0
	
END
GO


