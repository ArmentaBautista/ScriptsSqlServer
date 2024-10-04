

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTMinistracion')
BEGIN
	DROP PROC pLSTMinistracion
	SELECT 'pLSTMinistracion BORRADO' AS info
END
GO

CREATE PROCEDURE [dbo].[pLSTMinistracion]
@TipoOperacion AS varchar(10) = '',
@IdMinistracion AS int = 0,
@IdCuenta as int = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF(@TipoOperacion='LST')
	BEGIN
		SELECT IdMinistracion=0, IdCuenta=0, CuentaCodigo=''
		, CuentaDescripcion='', CuentaDescripcionLarga='', CuentaFechaAlta='19000101'
		, CuentaFechaActivacion='19000101', Numero=0, FechaInicial='19000101', FechaFinal='19000101'
		, MontoDisponibleEntrega=0.0, MontoMinimo=0.0, MontoMaximo=0.0,MontoEntregado=0.0
		,RetiroAnticipado=0,NumeroCiclo=0,Año=0
		FROM dbo.tCTLempresas WHERE IdEmpresa=-99
	END	
END 
  
GO






