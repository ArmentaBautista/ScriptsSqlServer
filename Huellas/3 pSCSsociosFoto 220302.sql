


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSCSsociosFoto')
BEGIN
	DROP PROC pSCSsociosFoto
	SELECT 'pSCSsociosFoto BORRADO' AS info
END
GO

CREATE PROC [dbo].[pSCSsociosFoto]
@tipoOperacion AS VARCHAR(20)='',
@idSocioFoto AS INT=0 OUTPUT,
@noSocio AS VARCHAR(20)='',
@foto AS VARBINARY(max)=NULL
AS
BEGIN

	IF @tipoOperacion IS NULL OR @tipoOperacion=''
	BEGIN
		SET @idSocioFoto=0
		RETURN 0
	END

	IF @tipoOperacion='GET'
	BEGIN
		SELECT f.Id,F.foto FROM dbo.tAYCsociosFoto f  WITH(NOLOCK) 
		WHERE f.NoSocio=@noSocio
		
		RETURN 1
	END

	IF @tipoOperacion='ADD'
	BEGIN
		INSERT INTO [dbo].tAYCsociosFoto (NoSocio,Foto) VALUES (@noSocio,@foto)
		SET @idSocioFoto = SCOPE_IDENTITY()
		RETURN 1
	END
	
	IF @tipoOperacion='DEL'
	BEGIN
		DELETE FROM [dbo].tAYCsociosFoto WHERE NoSocio=@noSocio
		
		SELECT @idSocioFoto=f.Id FROM dbo.tAYCsociosFoto f  WITH(NOLOCK) 
		WHERE f.NoSocio=@noSocio

		RETURN 1
	END

END
