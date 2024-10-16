
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSCSsociosHuellas')
BEGIN
	DROP PROC pSCSsociosHuellas
	SELECT 'pSCSsociosHuellas BORRADO' AS info
END
GO

CREATE PROC [dbo].[pSCSsociosHuellas]
@tipoOperacion AS VARCHAR(20)='',
@idSocioHuella AS INT=0 OUTPUT,
@noSocio AS VARCHAR(20)='',
@huella AS VARBINARY(max)=NULL,
@fingerMask AS INT=0,
@numeroDedo AS INT=0
AS
BEGIN

	IF @tipoOperacion IS NULL OR @tipoOperacion=''
	BEGIN
		SET @idSocioHuella=0
		RETURN 0
	END

	IF @tipoOperacion='GET'
	BEGIN
		SELECT @idSocioHuella=ISNULL(h.Id,0) FROM dbo.tAYCsociosHuellas h  WITH(NOLOCK) 
		WHERE h.NoSocio=@noSocio AND h.Huella=@huella
		
		RETURN 1
	END

	IF @tipoOperacion='GETALL'
	BEGIN
		SELECT h.Id,h.NoSocio,h.Huella, h.FingerMask, h.NumeroDedo FROM dbo.tAYCsociosHuellas h  WITH(NOLOCK) 
		WHERE h.NoSocio=@noSocio
		
		RETURN 1
	END

	IF @tipoOperacion='GETDUPLICATE'
	BEGIN
		SELECT @idSocioHuella=ISNULL(h.Id,0) FROM dbo.tAYCsociosHuellas h  WITH(NOLOCK) 
		WHERE h.NoSocio=@noSocio AND h.Huella=@huella AND h.NumeroDedo<>@numeroDedo
		
		--RETURN 1
	END

	IF @tipoOperacion='ADD'
	BEGIN
		INSERT INTO [dbo].[tAYCsociosHuellas] (NoSocio,Huella,FingerMask,NumeroDedo) VALUES (@noSocio,@huella,@fingerMask,@numeroDedo)
		SET @idSocioHuella = SCOPE_IDENTITY()
		RETURN 1
	END
	
	IF @tipoOperacion='DEL'
	BEGIN
		DELETE FROM [dbo].[tAYCsociosHuellas] WHERE NoSocio=@noSocio AND Huella= @huella
		
		SELECT @idSocioHuella=h.Id FROM dbo.tAYCsociosHuellas h  WITH(NOLOCK) 
		WHERE h.NoSocio=@noSocio AND h.Huella=@huella

		RETURN 1
	END

END
