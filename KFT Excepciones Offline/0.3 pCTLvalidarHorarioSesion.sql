
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLvalidarHorarioSesion')
BEGIN
	DROP PROC pCTLvalidarHorarioSesion
	SELECT 'pCTLvalidarHorarioSesion BORRADO' AS info
END
GO

CREATE PROC pCTLvalidarHorarioSesion
@idSucursal AS INT = 0,
@IdUsuario AS INT = 0
AS
BEGIN

DECLARE @Fecha AS DATETIME = CURRENT_TIMESTAMP
DECLARE @HoraSistema AS VARCHAR(25)  =''

IF( @IdUsuario = -1 OR @IdUsuario IN (SELECT ex.IdUsuario FROM dbo.tCTLexcepcionesOffLine ex  WITH(NOLOCK)))
BEGIN
    RETURN;
END

SELECT  @HoraSistema = Configuracion.Valor
FROM dbo.tCTLconfiguracion Configuracion
WHERE Configuracion.IdConfiguracion = 321 AND Configuracion.IdSucursal = @idSucursal


IF (   @HoraSistema  <    SUBSTRING(CAST(CAST(CURRENT_TIMESTAMP AS TIME) AS VARCHAR(30)),1,8) )
BEGIN
    RAISERROR('No permite el acceso al sistema con un  horario mayor al configurado en el parametro Hora Off Line del sistema',16,8) 
END

END

GO

