

DECLARE @FechaInicio AS DATE='20220101'
DECLARE @FechaFin AS DATE='20220301'

SELECT c.IdCuenta, c.Codigo, c.Descripcion, c.MontoSolicitado, c.Monto, (c.MontoSolicitado - c.Monto) AS DiferenciaMontoAutorizado
, MontoPromedioSolicitado = (SELECT AVG(c.MontoSolicitado) FROM tayccuentas c  WITH(NOLOCK) WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1 and c.Alta BETWEEN @FechaInicio AND @FechaFin)
, CreditosColocados = (SELECT COUNT(1) FROM tayccuentas c  WITH(NOLOCK) WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1 and c.Alta BETWEEN @FechaInicio AND @FechaFin)
, PromedioDiarioColocacion = (SELECT AVG(t.CuentasPorDia) 
								FROM (
										SELECT COUNT(1) CuentasPorDia FROM tayccuentas c  WITH(NOLOCK) 
										WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1 and c.Alta BETWEEN @FechaInicio AND @FechaFin
										GROUP BY c.FechaAlta
									) t)
FROM tayccuentas c  WITH(NOLOCK) 
WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1
AND c.Alta BETWEEN @FechaInicio AND @FechaFin






