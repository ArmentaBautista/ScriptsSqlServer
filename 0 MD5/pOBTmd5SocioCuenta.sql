

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pOBTmd5SocioCuenta')
BEGIN
	DROP PROC pOBTmd5SocioCuenta
	SELECT 'pOBTmd5SocioCuenta BORRADO' AS info
END
GO

CREATE PROC pOBTmd5SocioCuenta
@Socio AS VARCHAR(100),
@Cuenta AS VARCHAR(100),
@Clave AS VARCHAR(100)
AS
BEGIN

	DECLARE @cadenaOriginal AS VARCHAR(max)= CONCAT(@Socio,'|',@Cuenta,'|',@Clave)

	-- SELECT @cadenaOriginal
	SELECT HASHBYTES('MD5',@cadenaOriginal) AS md5
END



