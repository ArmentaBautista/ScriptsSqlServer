

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnADMconsultaBitacora')
BEGIN
	DROP PROC pCnADMconsultaBitacora
END
GO

CREATE PROC dbo.pCnADMconsultaBitacora
@fechaInicial AS DATE='19000101',
@fechaFinal AS DATE='19000101',
@usuario AS VARCHAR(64)=''
AS
BEGIN
	IF @fechaInicial='19000101' OR @fechaFinal='19000101'
	BEGIN	
		SELECT 'Las fechas de inicio y fin no deben ser 01-01-1900 o nulas'
		RETURN 0;
	END

	IF @usuario='*' OR @usuario IS NULL
		SET @usuario=''

	DECLARE @query AS VARCHAR(max)=CONCAT(
									'SELECT bit.Fecha,bit.Hora, bit.Tabla, bit.Campo, bit.IdRegistro, bit.ValorOriginal, bit.ValorNuevo, bit.Host, bit.IP, usuario.Usuario
									FROM dbo.tADMbitacora bit  WITH(nolock) 
									INNER JOIN dbo.tCTLsesiones ss  WITH(nolock) ON ss.IdSesion = bit.IdSesion
									INNER JOIN dbo.tCTLusuarios usuario  WITH(nolock) ON usuario.IdUsuario = ss.IdUsuario
									WHERE bit.Fecha BETWEEN ''' , @fechaInicial , ''' AND ''' , @fechaFinal , '''
									AND usuario.usuario LIKE ''%' + @usuario + '%''
									ORDER BY bit.Fecha')
	execute (@query)
END


