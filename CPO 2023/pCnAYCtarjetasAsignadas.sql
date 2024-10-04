

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCtarjetasAsignadas')
BEGIN
	DROP PROC pCnAYCtarjetasAsignadas
	SELECT 'pCnAYCtarjetasAsignadas BORRADO' AS info
END
GO

CREATE PROC pCnAYCtarjetasAsignadas
@fechaInicial AS DATE='19000101',
@fechaFinal AS DATE='19000101'
AS
BEGIN

IF @fechaInicial='19000101' OR @fechaInicial IS NULL
	SELECT 'La fecha inicial no es Válida'

IF @fechaFinal='19000101' OR @fechaFinal IS NULL
	SELECT 'La fecha Final no es Válida'

DECLARE @tarjetas TABLE(
	FechaAsignacion			DATE, 
	SucursalAsignacion		VARCHAR(80),
	NumeroTarjeta			VARCHAR(12), 
	Consecutivo				VARCHAR(4),
	FinVigencia				DATE, 
	EstatusTarjeta			VARCHAR(30), 
	NoCuenta				VARCHAR(30), 
	EstatusCuenta			VARCHAR(30)
)
                    	
INSERT INTO @tarjetas
(
    FechaAsignacion,
    SucursalAsignacion,
    NumeroTarjeta,
    Consecutivo,
    FinVigencia,
    EstatusTarjeta,
    NoCuenta,
    EstatusCuenta
)                 
SELECT t.FechaAsignacion, suc.Descripcion SucursalAsignacion,t.NumeroTarjeta, t.Consecutivo,t.FinVigencia, e.Descripcion AS EstatusTarjeta
, cta.Codigo AS NoCuenta, eCta.Descripcion AS EstatusCuenta
FROM dbo.tSCStarjetas t  WITH(NOLOCK) 
INNER JOIN dbo.tCTLusuarios uAsignacion  WITH(NOLOCK) ON uAsignacion.IdUsuario = t.IdUsuarioAlta
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = t.IdSucursal
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = t.IdEstatus
INNER JOIN dbo.tAYCcuentas cta  WITH(NOLOCK) ON cta.IdCuenta = t.IdCuenta
INNER JOIN dbo.tCTLsucursales sucCta  WITH(NOLOCK) ON sucCta.IdSucursal = cta.IdSucursal
INNER JOIN dbo.tCTLestatus eCta  WITH(NOLOCK) ON eCta.IdEstatus = cta.IdEstatus
WHERE t.FechaAsignacion BETWEEN @fechaInicial AND @fechaFinal

SELECT 
	   DATEPART(YEAR,t.FechaAsignacion) AS Año,
	   DATEPART(MONTH,t.FechaAsignacion) AS Mes,
	   t.FechaAsignacion,
       t.SucursalAsignacion,
       t.NumeroTarjeta,
       t.Consecutivo,
       t.FinVigencia,
       t.EstatusTarjeta,
       t.NoCuenta,
       t.EstatusCuenta,
	   1 AS Conteo
FROM @tarjetas t
ORDER BY FechaAsignacion, t.SucursalAsignacion

END