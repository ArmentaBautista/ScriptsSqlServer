
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fATMexisteCuenta')
BEGIN
	DROP FUNCTION fATMexisteCuenta
	SELECT 'fATMexisteCuenta BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fATMexisteCuenta] 
	(
		@Codigo AS VARCHAR(150)
	)
	RETURNS bit
	AS
	BEGIN
		
		
		
		IF  EXISTS(SELECT c.IdCuenta FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdEstatus=1 AND c.IdSaldo!=0 AND  c.Codigo=@codigo)
		BEGIN
			RETURN 1
		END
		
		RETURN 0
	END




GO

