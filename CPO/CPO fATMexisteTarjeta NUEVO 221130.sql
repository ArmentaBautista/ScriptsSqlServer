
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fATMexisteTarjeta')
BEGIN
	DROP FUNCTION fATMexisteTarjeta
	SELECT 'fATMexisteTarjeta BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fATMexisteTarjeta] 
	(
		@NumeroTDD AS VARCHAR(19)
	)
	RETURNS VARCHAR(28)
	AS
	BEGIN
		
		DECLARE @NumeroCuenta AS VARCHAR(28)=''				
		Set @NumeroCuenta=ISNULL((SELECT TOP 1 c.Codigo
									FROM dbo.tSCStarjetas t  WITH(NOLOCK) 
									INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = t.IdCuenta
									AND c.IdEstatus=1 AND c.IdTipoDProducto=144 
									WHERE t.IdEstatus=1 and t.NumeroTDD=@NumeroTDD),'')
		rETURN @NumeroCuenta				
		
	END 


GO

