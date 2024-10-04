

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pOBTinformacionTarjeta')
BEGIN
	DROP PROC pOBTinformacionTarjeta
	SELECT 'pOBTinformacionTarjeta BORRADO' AS info
END
GO

CREATE PROC pOBTinformacionTarjeta
    @TipoOperacion AS VARCHAR(15)='',
	@NumeroTarjeta BIGINT = 0
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN

	IF @TipoOperacion='GRAL'
	BEGIN
		SELECT Tarjeta.IdTarjeta,
			   Tarjeta.NumeroTDD,
			   Cuenta.IdCuenta,
			   Socio = Socio.Codigo,
			   Persona = Persona.Nombre,
			   Producto = Producto.Descripcion
		FROM dbo.tSCStarjetas Tarjeta WITH ( NOLOCK )
		INNER JOIN dbo.tAYCcuentas Cuenta WITH ( NOLOCK ) ON Cuenta.IdCuenta = Tarjeta.IdCuenta
		INNER JOIN dbo.tAYCproductosFinancieros Producto WITH ( NOLOCK ) ON Producto.IdProductoFinanciero = Cuenta.IdProductoFinanciero
		INNER JOIN dbo.tSCSsocios Socio WITH ( NOLOCK ) ON Socio.IdSocio = Cuenta.IdSocio
		INNER JOIN dbo.tGRLpersonas Persona ON Persona.IdPersona = Socio.IdPersona
		WHERE Tarjeta.NumeroTDD = @NumeroTarjeta;	    
	END

	IF @TipoOperacion='GRALSDO' -- Datos generales + saldos
	BEGIN

		DECLARE @fechaTrabajo AS DATE=GETDATE();
		DECLARE @idCuenta AS INT=0
		SELECT @idCuenta FROM dbo.tSCStarjetas c  WITH(NOLOCK) WHERE c.NumeroTDD=@NumeroTarjeta


		SELECT Tarjeta.IdTarjeta,
			   Tarjeta.NumeroTDD,
			   Cuenta.IdCuenta,
			   Socio = Socio.Codigo,
			   Persona = Persona.Nombre,
			   Producto = Producto.Descripcion,
			   [Saldo al Día] = saldo.SaldoAlDía,
			   [Saldo Total] = saldo.SaldoTotal,
			   [Fecha de cálculo] = @fechaTrabajo
		FROM dbo.tSCStarjetas Tarjeta WITH ( NOLOCK )
		INNER JOIN dbo.tAYCcuentas Cuenta WITH ( NOLOCK ) ON Cuenta.IdCuenta = Tarjeta.IdCuenta
		INNER JOIN dbo.tAYCproductosFinancieros Producto WITH ( NOLOCK ) ON Producto.IdProductoFinanciero = Cuenta.IdProductoFinanciero
		INNER JOIN dbo.tSCSsocios Socio WITH ( NOLOCK ) ON Socio.IdSocio = Cuenta.IdSocio
		INNER JOIN dbo.tGRLpersonas Persona ON Persona.IdPersona = Socio.IdPersona
		INNER JOIN dbo.fAYCcalcularCarteraOperacion(@fechaTrabajo,2,@idCuenta,0,'DevPag') saldo ON saldo.IdCuenta = Cuenta.IdCuenta
		WHERE Tarjeta.NumeroTDD = @NumeroTarjeta;	
		

		
	END



END;
GO

