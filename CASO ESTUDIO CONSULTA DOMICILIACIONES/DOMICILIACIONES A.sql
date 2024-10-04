
/* INFO (⊙_☉) JCA.21/12/2023.01:05 a. m. 
Nota: Se alento un vez se filtro el tipo de operacion
no se puede omitir el filtro pues aparecen transacciones que no deben ser visibles
*/


DECLARE @fechaInicial AS DATE='20230101'
DECLARE @fechaFinal AS DATE='20231231'


SELECT
DISTINCT
f.fecha,
tope.Codigo AS Operacion,
op.Folio,
f.IdTransaccion,
sc.Codigo AS NoSocio,
p.Nombre,
c.Codigo AS NoCuenta,
pf.Descripcion AS producto,
f.Referencia,
FORMAT(IIF(f.IdTipoSubOperacion=501,f.MontoSubOperacion * f.Naturaleza,f.MontoSubOperacion),'C','es-MX') AS MontoSubOperacion
FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) 
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
	ON op.IdOperacion = f.IdOperacion		
		--AND op.IdTipoOperacion=22
INNER JOIN  dbo.tCTLtiposOperacion tope  WITH(NOLOCK) 
	ON tope.IdTipoOperacion = op.IdTipoOperacion	 
		AND tope.IdTipoOperacion=22
INNER JOIN dbo.tAYCdomiciliaciones ctas 
	ON f.IdCuenta IN (ctas.IdCuentaCredito,ctas.IdCuentaRetiro)
		AND ctas.IdEstatus=1
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = f.IdCuenta
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN  dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
WHERE 
f.Referencia='DOMICILIACIÓN' 
AND f.IdTipoSubOperacion IN (501,500) 
AND f.IdEstatus=1 
AND f.Fecha BETWEEN @fechaInicial AND @fechaFinal
ORDER BY f.Fecha
,op.Folio
,f.IdTransaccion, sc.Codigo




