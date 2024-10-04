

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pAYCsociosCuentasEstadoCuenta')
BEGIN
	DROP PROC pAYCsociosCuentasEstadoCuenta
END
GO

CREATE PROC pAYCsociosCuentasEstadoCuenta
@TipoOperacion AS VARCHAR(30)=''
AS
BEGIN
    
	IF @TipoOperacion='SocioEdoCuenta'
	BEGIN
		SELECT sec.IdSocio, sec.IdCuenta FROM dbo.fnAYCsociosCuentasEstadoCuenta() sec

	
	END

END