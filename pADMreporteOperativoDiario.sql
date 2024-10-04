

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pADMreporteOperativoDiario')
BEGIN
	DROP PROC pADMreporteOperativoDiario
	SELECT 'pADMreporteOperativoDiario BORRADO' AS info
END
GO

CREATE PROC pADMreporteOperativoDiario
AS
BEGIN	

DECLARE @fecha AS DATE=GETDATE();
DECLARE @operaciones AS TABLE (Sucursal VARCHAR(50),TipoOperacion VARCHAR(30));

INSERT INTO @operaciones (Sucursal,TipoOperacion)
SELECT suc.Descripcion, tip.Descripcion
FROM tgrloperaciones op  WITH(NOLOCK) 
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = op.IdSucursal
INNER JOIN dbo.tCTLtiposOperacion tip  WITH(NOLOCK) ON tip.IdTipoOperacion = op.IdTipoOperacion
WHERE op.Fecha=@fecha


SELECT sucursal, COUNT(1) AS operaciones
FROM @operaciones o
GROUP BY o.Sucursal  ORDER BY operaciones desc

SELECT o.TipoOperacion, COUNT(1) AS operaciones
FROM @operaciones o
GROUP BY o.TipoOperacion ORDER BY operaciones desc

/* Estadisticas de Cuentas*/
DECLARE @cuentas AS TABLE(
	IdCuenta INT,
	IdTipo INT
)

-- Inserción de cuentas del día
INSERT INTO @cuentas (IdCuenta,IdTipo)
SELECT c.IdCuentaInteres,c.IdTipoDProducto
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.FechaAlta=@fecha

-- SELECT  COUNT(1) AS Desembolsos FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.FechaEntrega=@fecha

SELECT tipo.Descripcion AS TipoCuenta, COUNT(1)  AS NoCuentasNuevas
FROM @cuentas c
INNER JOIN dbo.tCTLtiposD tipo  WITH(NOLOCK) ON tipo.IdTipoD=c.IdTipo
GROUP BY tipo.Descripcion

-- Cierres

SELECT [Código Sucursal] = Sucursal.Codigo,
		   Sucursal = Sucursal.Descripcion,
		   Número = Cierre.IdCierre,
		   Fecha = FechaTrabajo,
		   Tipo = CASE WHEN Cierre.IdCuentaABCD = 0 THEN 'Ventanilla' ELSE 'Móvil' END,
		   Móvil = Movil.Descripcion,
		   Contabilizado = Cierre.Contabilizado,
		   Estatus = Estatus.Descripcion,
		   DomicilioSucursales.Estado,
		   FORMAT(EstatusActual.Alta,'HH:mm:ss') AS [Inicio Jornada],
		   FORMAT(EstatusActual.UltimoCambio,'HH:mm:ss') AS [Fin Jornada]
	FROM tVENcierres Cierre WITH ( NOLOCK )
	INNER JOIN tCTLsucursales Sucursal WITH ( NOLOCK ) ON Sucursal.IdSucursal = Cierre.IdSucursal
	INNER JOIN tCTLestatusActual EstatusActual WITH ( NOLOCK ) ON EstatusActual.IdEstatusActual = Cierre.IdEstatusActual
	INNER JOIN dbo.tCTLestatus Estatus WITH(NOLOCK) ON Estatus.IdEstatus = EstatusActual.IdEstatus
	INNER JOIN tGRLcuentasABCD Movil WITH ( NOLOCK ) ON Movil.IdCuentaABCD = Cierre.IdCuentaABCD
	LEFT JOIN vCTLdomicilioSucursales DomicilioSucursales WITH ( NOLOCK ) ON DomicilioSucursales.IdDomicilio = Sucursal.IdDomicilio
	WHERE Cierre.FechaTrabajo =@fecha
	ORDER BY   Estatus.IdEstatus,DomicilioSucursales.Estado, Sucursal.Descripcion

END