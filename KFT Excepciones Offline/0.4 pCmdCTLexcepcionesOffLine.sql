

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCmdCTLexcepcionesOffLine')
BEGIN
	DROP PROC pCmdCTLexcepcionesOffLine
	SELECT 'pCmdCTLexcepcionesOffLine BORRADO' AS info
END
GO

CREATE PROC pCmdCTLexcepcionesOffLine
@pTipoOperacion CHAR(1),
@pUsuario		VARCHAR(24)=''
AS
BEGIN
	SET @pTipoOperacion= UPPER(@pTipoOperacion);
	
	DECLARE @IdUsuario INT=(SELECT u.IdUsuario FROM dbo.tCTLusuarios u  WITH(NOLOCK) WHERE u.Usuario=@pUsuario)
	DECLARE @IdSesion  INT = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 

	IF @IdUsuario=0
	BEGIN
		SELECT 'Usuario no encontrado' AS INFO
		RETURN -1
	END

	IF @pTipoOperacion='A'
	BEGIN
		UPDATE ex SET ex.IdEstatus=2, ex.UltimoCambio=GETDATE()
		FROM dbo.tCTLexcepcionesOffLine ex WHERE ex.IdUsuario=@IdUsuario

		INSERT INTO dbo.tCTLexcepcionesOffLine (IdUsuario,IdSesion)
		VALUES (@IdUsuario,@IdSesion)

		RETURN 1
    END

	IF @pTipoOperacion='B'
	BEGIN
		UPDATE ex SET ex.IdEstatus=2, ex.UltimoCambio=GETDATE()
		FROM dbo.tCTLexcepcionesOffLine ex WHERE ex.IdUsuario=@IdUsuario

		RETURN 1
    END

END
GO