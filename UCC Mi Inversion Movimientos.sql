
USE iERP_UCC
GO

DECLARE @noSocio AS VARCHAR(25)='101-000059'

SELECT sc.Codigo AS NoSocio, p.Nombre, c.IdCuenta, c.Codigo AS NoCuenta, c.Descripcion, pf.Codigo AS ProductoCodigo, pf.Descripcion AS ProductoDescripcion, CONCAT(td.Descripcion,' ',c.Dias,' dias') AS Plazo, c.FechaAlta, c.Vencimiento, c.TasaIva, c.InteresOrdinarioAnual, c.SaldoCapital
FROM tayccuentas c  WITH(nolock) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLtiposD td  WITH(nolock) ON td.IdTipoD = c.IdTipoDPlazo
INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (398) AND sc.Codigo=@noSocio

DECLARE @noCuenta AS VARCHAR(25)='101-000421'
DECLARE @idcuentaEje AS INT=0
-- Cuenta Eje
SELECT @idcuentaEje=c.IdCuenta FROM tayccuentas c  WITH(nolock) 
INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (398) AND c.Codigo=@noCuenta

SELECT c.IdCuenta, c.Codigo, c.Descripcion FROM tayccuentas c  WITH(nolock) 
INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (398) AND c.IdCuenta=@idcuentaEje

-- drop de la tabla temporal
IF OBJECT_ID('tempdb..#tmpInverMov') IS NOT NULL DROP TABLE #tmpInverMov

-- Movimientos de la cuenta Eje
SELECT * INTO #tmpInverMov FROM (
									SELECT o.IdTipoOperacion, o.IdOperacion, tf.IdCuenta
									, tf.Alta AS FechaHora, tope.Codigo AS Operacion, o.folio AS Folio,  
											CASE
												WHEN tf.IdTipoSubOperacion = 500 THEN 'DEP'
												WHEN tf.IdTipoSubOperacion = 501 THEN 'RET'
												ELSE ''
											END AS Movimiento,
											CASE
												WHEN tf.InteresOrdinarioDevengado<>0 THEN 'Generación de Interés'
												WHEN tf.InteresOrdinarioPagado<>0 THEN 'Pago de Interés'
												WHEN tf.InteresCapitalizado<>0 THEN 'Capitalización de Interés - REINVERSIÓN'
												ELSE tf.Concepto
											END AS Concepto
									, tf.Referencia, tf.SaldoCapitalAnterior, 
											CASE
												WHEN tf.IdTipoSubOperacion in (500,501) THEN tf.CapitalGenerado - tf.CapitalPagado
												ELSE 0
												END AS Monto
									,tf.SaldoCapital, tf.InteresOrdinarioPagado AS InteresOrdinarioBruto ,tf.RetencionISR, tf.InteresCapitalizado, tf.InteresRetirado
									FROM dbo.tGRLoperaciones o  WITH(nolock) 
									INNER JOIN dbo.tCTLtiposOperacion tope  WITH(nolock) ON tope.IdTipoOperacion = o.IdTipoOperacion 
									INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(nolock) ON tf.IdOperacion = o.IdOperacion
																								AND tf.IdCuenta=@idcuentaEje
																								AND tf.IdEstatus=1
																								AND (tf.IdTipoSubOperacion IN (500,501) OR (tf.IdTipoSubOperacion=4 AND tf.InteresOrdinarioPagado>0))
									INNER JOIN dbo.tAYCcuentas c  WITH(nolock) ON c.IdCuenta = tf.IdCuenta
									WHERE o.IdEstatus=1 
									-- ORDER BY tf.Alta asc					
								) AS InverMov

-- Movimientos de la cuenta Eje
SELECT tim.FechaHora,tim.Operacion,tim.Folio,tim.Movimiento,tim.Concepto,tim.Referencia,tim.SaldoCapitalAnterior
,tim.Monto,tim.SaldoCapital,tim.InteresOrdinarioBruto,tim.RetencionISR,tim.InteresCapitalizado,tim.InteresRetirado 
FROM #tmpInverMov tim ORDER BY tim.FechaHora ASC

-- cuentas relacionadas 1,10,22
SELECT tim.FechaHora, c.Codigo AS NoCuenta, tim.Operacion,tim.Folio,
	CASE
	WHEN tf.IdTipoSubOperacion = 500 THEN 'DEP'
	WHEN tf.IdTipoSubOperacion = 501 THEN 'RET'
	ELSE ''
	END AS Movimiento
,tf.Concepto,tf.Referencia,tf.SaldoCapitalAnterior,
	CASE
	WHEN tf.IdTipoSubOperacion in (500,501) THEN tf.CapitalGenerado - tf.CapitalPagado
	ELSE 0
	END AS Monto
,tf.SaldoCapital, tf.InteresOrdinarioPagado AS InteresOrdinarioBruto ,tf.RetencionISR, tf.InteresCapitalizado, tf.InteresRetirado
FROM #tmpInverMov tim 
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(nolock) ON tf.IdOperacion = tim.IdOperacion
INNER JOIN dbo.tAYCcuentas c  WITH(nolock) ON c.IdCuenta = tf.IdCuenta
WHERE tim.IdTipoOperacion IN (1,10,22) AND tf.IdCuenta<>@idcuentaEje ORDER BY tim.FechaHora ASC







