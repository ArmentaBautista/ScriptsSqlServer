
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLsesionesDiasInhabilesoFestivos')
BEGIN
	DROP PROC pCTLsesionesDiasInhabilesoFestivos
	SELECT 'pCTLsesionesDiasInhabilesoFestivos BORRADO' AS info
END
GO

CREATE PROC pCTLsesionesDiasInhabilesoFestivos
@IdUsuario AS INT = 0,
@IdSucursal AS INT = 0,
@fechaSesion      AS DATE = '19000101'
AS
BEGIN
SET DATEFIRST 1
DECLARE @FechaHabil AS DATE = (SELECT dbo.fObtenerFechaHabil(@fechaSesion,@IdSucursal));
DECLARE @ValorConfiguracion AS VARCHAR(25)  =(SELECT Valor FROM dbo.tCTLconfiguracion WHERE IdConfiguracion = 371)
DECLARE @msg2 as VARCHAR(MAX) = '';
PRINT @fechaSesion;
PRINT @FechaHabil;
SET @msg2 = 'CodEx||pCRUDsesiones| No se permite iniciar sesión en Días inhábiles o festivos.'


IF( @IdUsuario = -1 OR @IdUsuario IN (SELECT ex.IdUsuario FROM dbo.tCTLexcepcionesOffLine ex  WITH(NOLOCK)))
BEGIN
    RETURN;
END;

IF(@ValorConfiguracion = 'True')
BEGIN
    RETURN;
END

  IF ( @FechaHabil <> @fechaSesion)
 BEGIN
RAISERROR(@msg2,16,8) 
END

END
 
GO

