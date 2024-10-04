

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnValidarDiaHorarioSesion')
BEGIN
	DROP FUNCTION dbo.fnValidarDiaHorarioSesion
	SELECT 'fnValidarDiaHorarioSesion BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnValidarDiaHorarioSesion(
@pIdSucursal INT)
RETURNS bit
BEGIN
	DECLARE @resultado AS BIT=0

	DECLARE @idSucursal AS INT=@pIdSucursal

	DECLARE @horaEntrada AS TIME='09:00:00'
	DECLARE @horaEntradaNorte AS TIME=DATEADD(HOUR,1,@horaEntrada)
	DECLARE @horaSalida AS TIME='19:45:00'
	DECLARE @horaEntradaFinSemana AS TIME='08:00:00'
	DECLARE @horaSalidaFinSemana AS TIME='14:00:00'

	DECLARE @horaActual AS TIME=GETDATE()
	DECLARE @dia AS INT=DATEPART(WEEKDAY,GETDATE())

	DECLARE @IdSucursalMatriz AS INT;
	SELECT @IdSucursalMatriz = sucursal.IdSucursal
	FROM dbo.tCTLsucursales sucursal
	WHERE sucursal.EsMatriz = 1;

	IF @dia BETWEEN 1 AND 5
	BEGIN
		-- norte
		IF(@idSucursal IN (35,36,40,41,1002,1003,1013,1014,1015,1016,1017,1018,1019,1027))
		BEGIN
			IF @horaActual BETWEEN @horaEntradaNorte AND @horaSalida
			BEGIN
				SET @resultado=1
			END
			ELSE
			BEGIN
				SET @resultado=0
			END
			RETURN @resultado
		END
		ELSE -- occidente
        BEGIN
			IF @horaActual BETWEEN @horaEntrada AND @horaSalida
			BEGIN
				SET @resultado=1
			END
			ELSE
			BEGIN
				SET @resultado=0
			END
			RETURN @resultado
		END
	END

	IF @dia = 6
	BEGIN
		IF @horaActual BETWEEN @horaEntradaFinSemana AND @horaSalidaFinSemana
		BEGIN
			SET @resultado=1
		END
		ELSE
		BEGIN
			SET @resultado=0
		END
		RETURN @resultado
	END
	
	IF @dia = 7 AND @idSucursal=@IdSucursalMatriz
	BEGIN
		IF @horaActual BETWEEN @horaEntradaFinSemana AND @horaSalidaFinSemana
		BEGIN
			SET @resultado=1
		END
		ELSE
		BEGIN
			SET @resultado=0
		END
		RETURN @resultado
	END
	
	RETURN @resultado
END
GO


