
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
		
		
		
		IF  EXISTS(SELECT IdCuenta FROM vATMsaldoCuenta  WHERE CuentaCodigo=@codigo)
		BEGIN
			RETURN 1
		END
		
		RETURN 0
	END




GO

