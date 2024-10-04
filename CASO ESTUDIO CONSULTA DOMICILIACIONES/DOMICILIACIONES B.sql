

DECLARE @fechaInicial AS DATE='20230101'
DECLARE @fechaFinal AS DATE='20231231'

DECLARE @cuentasDomiciliadas AS	TABLE(
	IdSocio			INT,
	IdCuentaCredito	INT,
	IdCuentaRetiro	INT,
	IdEstatus		INT
)

-- Cuentas con registro activo de domiciliación
INSERT INTO @cuentasDomiciliadas
SELECT 
d.IdSocio, 
d.IdCuentaCredito, 
d.IdCuentaRetiro,
d.IdEstatus
FROM dbo.tAYCdomiciliaciones d  WITH(NOLOCK) 
WHERE d.IdEstatus=1


DECLARE @cuentas AS TABLE(
	IdCuenta INT,
	IdSocio INT,
	NoCuenta VARCHAR(30),
	Producto	VARCHAR(80)
)

-- obtener todas las cuentas de crédito
INSERT INTO @cuentas
SELECT ctas.IdCuenta, ctas.IdSocio,ctas.Codigo, pf.Descripcion
FROM @cuentasDomiciliadas cd 
INNER JOIN dbo.tAYCcuentas ctas  WITH(NOLOCK) 
	ON ctas.IdCuenta = cd.IdCuentaCredito
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = ctas.IdProductoFinanciero

-- obtener todas las cuentas de ahorro
INSERT INTO @cuentas
SELECT ctas.IdCuenta, ctas.IdSocio,ctas.Codigo, pf.Descripcion
FROM @cuentasDomiciliadas cd 
INNER JOIN dbo.tAYCcuentas ctas  WITH(NOLOCK) 
	ON ctas.IdCuenta = cd.IdCuentaRetiro
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = ctas.IdProductoFinanciero
GROUP BY ctas.IdCuenta, ctas.IdSocio,ctas.Codigo, pf.Descripcion


SELECT
f.fecha,
tope.Codigo AS Operacion,
op.Folio,
f.IdTransaccion,
sc.Codigo AS NoSocio,
p.Nombre,
c.NoCuenta,
c.Producto,
f.Referencia,
FORMAT(IIF(f.IdTipoSubOperacion=501,f.MontoSubOperacion * f.Naturaleza,f.MontoSubOperacion),'C','es-MX') AS MontoSubOperacion
FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) 
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
	ON op.IdOperacion = f.IdOperacion
INNER JOIN dbo.tCTLtiposOperacion tope  WITH(NOLOCK) 
	ON tope.IdTipoOperacion = op.IdTipoOperacion
		AND tope.IdTipoOperacion=22
INNER JOIN @cuentas c 
	ON c.IdCuenta = f.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN  dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
WHERE f.IdTipoSubOperacion IN (501,500) 
	AND f.IdEstatus=1 
		AND f.Fecha BETWEEN @fechaInicial AND @fechaFinal
			AND f.Referencia='DOMICILIACIÓN'
ORDER BY f.Fecha,op.IdOperacion, f.IdTransaccion, sc.IdSocio, f.IdCuenta

