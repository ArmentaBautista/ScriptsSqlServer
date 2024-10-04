
USE ErpriseExpediente
go

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLusuarios')
BEGIN
	DROP PROC pCTLusuarios
	SELECT 'pCTLusuarios BORRADO' AS info
END
GO

CREATE PROC pCTLusuarios
@pTipoOperacion		VARCHAR(24),
@pUsuario			VARCHAR(32),
@pContraseña		NVARCHAR(24)='',
@pDigitalizacion	BIT=0,
@pReportes			BIT=0,
@pUsuarios			BIT=0,
@pIdEstatus			INT =0
AS
BEGIN

	DECLARE @PASSPHRASE AS NVARCHAR(32)='Intelix'

	IF @pTipoOperacion='F3'
	BEGIN	
		SELECT u.Usuario,u.Digitalizacion,u.Reportes,u.Usuarios 
		FROM dbo.tCTLusuarios u  WITH(NOLOCK) WHERE u.Usuario LIKE '%' + @pUsuario + '%'
		
		RETURN 1
	END

	IF @pTipoOperacion='AGREGAR'
	BEGIN	
		IF EXISTS(SELECT 1 FROM dbo.tCTLusuarios u  WITH(NOLOCK) WHERE u.Usuario=@pUsuario)
		BEGIN
			RAISERROR(N'El usuario ya se existe en la Base de Datos',16,1);
			RETURN -1
		END

		INSERT INTO dbo.tCTLusuarios
		(
		    Usuario,
		    Digitalizacion,
		    Reportes,
			Usuarios,
		    IdEstatus
		)
		VALUES
		(   @pUsuario,      -- Usuario - varchar(32)
		    @pDigitalizacion, -- Digilizacion - bit
		    @pReportes, -- Reportes - bit
			@pUsuarios,
		    0  -- IdEstatus - int
		 )

		 SELECT 'OK'
		 RETURN 1
	END

	IF @pTipoOperacion='UPDATE'
	BEGIN	
		IF NOT EXISTS(SELECT 1 FROM dbo.tCTLusuarios u  WITH(NOLOCK) WHERE u.Usuario=@pUsuario)
		BEGIN
			RAISERROR(N'El usuario NO existe en la Base de Datos',16,1);
			RETURN -1
		END

		UPDATE u SET u.Digitalizacion=@pDigitalizacion, u.Reportes=@pReportes, u.Usuarios=@pUsuarios
		FROM dbo.tCTLusuarios u WHERE u.Usuario=@pUsuario


		SELECT 'OK'
		 RETURN 1
	END

	IF @pTipoOperacion='UPD_ST'
	BEGIN	
		IF NOT EXISTS(SELECT 1 FROM dbo.tCTLusuarios u  WITH(NOLOCK) WHERE u.Usuario=@pUsuario)
		BEGIN
			RAISERROR(N'El usuario NO existe en la Base de Datos',16,1);
			RETURN -1
		END

		UPDATE u SET u.IdEstatus=@pIdEstatus
		FROM dbo.tCTLusuarios u WHERE u.Usuario=@pUsuario

		SELECT 'OK'
		 RETURN 1
	END

	IF @pTipoOperacion='CONTRASEÑA'
	BEGIN
		
		UPDATE u SET u.Contraseña=ENCRYPTBYPASSPHRASE(@PASSPHRASE, @pContraseña), u.IdEstatus=1
		FROM dbo.tCTLusuarios u WHERE Usuario=@pUsuario
		
		SELECT 1 AS Resultado
		RETURN 1
	END



	IF @pTipoOperacion='ESTATUS'
	BEGIN
	
		SELECT u.IdEstatus FROM dbo.tCTLusuarios u  WITH(NOLOCK)  WHERE u.Usuario=@pUsuario
		
		RETURN 1
	END

	IF @pTipoOperacion='LOGIN'
	BEGIN
	
		SELECT u.Usuario,u.Digitalizacion,u.Reportes,u.Usuarios FROM dbo.tCTLusuarios u  WITH(NOLOCK)  
		WHERE u.Usuario=@pUsuario
		AND DECRYPTBYPASSPHRASE(@PASSPHRASE,u.Contraseña) = @pContraseña

		RETURN 1
	END



END