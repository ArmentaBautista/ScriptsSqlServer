



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAUTgeneradorCodigoAutorizacion')
BEGIN
	DROP PROC pAUTgeneradorCodigoAutorizacion
	SELECT 'pAUTgeneradorCodigoAutorizacion BORRADO' AS info
END
GO

CREATE PROC dbo.pAUTgeneradorCodigoAutorizacion
@CodigoAutorizacion CHAR(6) OUTPUT
AS
BEGIN
	SET @CodigoAutorizacion= (SELECT LEFT(CAST(NEWID() AS VARCHAR(36)), 6))
END
GO




DECLARE @CodigoAutorizacion CHAR(6);
EXEC dbo.pAUTgeneradorCodigoAutorizacion @CodigoAutorizacion = @CodigoAutorizacion OUTPUT 
SELECT @CodigoAutorizacion




