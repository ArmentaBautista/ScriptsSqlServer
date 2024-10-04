
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fATMexisteTarjeta')
BEGIN
	DROP FUNCTION fATMexisteTarjeta
	SELECT 'fATMexisteTarjeta BORRADO' AS info
END
GO

CREATE FUNCTION fATMexisteTarjeta 
	(
		@NumeroTDD AS VARCHAR(19)
	)
	RETURNS VARCHAR(28)
	AS
	BEGIN
		
		DECLARE @NumeroCuenta AS VARCHAR(28)=''				
		Set @NumeroCuenta=ISNULL((SELECT TOP 1 vsg.CuentaCodigo FROM vSCStarjetasGUI vsg WITH(NOLOCK) WHERE vsg.NumeroTDD=@NumeroTDD ),'')
		rETURN @NumeroCuenta				
		
	END 


GO

