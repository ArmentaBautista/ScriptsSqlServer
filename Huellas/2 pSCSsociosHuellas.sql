

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSCSsociosHuellas')
BEGIN
	DROP PROC pSCSsociosHuellas
	SELECT 'pSCSsociosHuellas BORRADO' AS info
END
GO

CREATE PROC pSCSsociosHuellas
@tipoOperacion AS VARCHAR(20)='',
@idSocioHuella AS INT=0 OUTPUT,
@noSocio AS VARCHAR(20)='',
@huella AS VARBINARY(max)=null
AS
BEGIN

	IF @tipoOperacion IS NULL OR @tipoOperacion=''
	BEGIN
		SET @idSocioHuella=0
		RETURN 0
	END

	IF @tipoOperacion='ADD'
	BEGIN
		INSERT INTO [dbo].[tAYCsociosHuellas] (NoSocio,Huella) VALUES (@noSocio,@huella)
		SET @idSocioHuella = SCOPE_IDENTITY()
		RETURN 1
	END
	
END
GO


