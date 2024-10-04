
IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnPLDMontosAgrupadosMesCalendario')
	DROP PROC pCnPLDMontosAgrupadosMesCalendario
GO

CREATE PROC pCnPLDMontosAgrupadosMesCalendario
@MontoAcumulado AS NUMERIC(16,2)
AS
-- Alerta por montos agrupados en efectivo mes calandario

DECLARE @montoAgrupado AS NUMERIC(12,2)=@MontoAcumulado

DECLARE @fechaInicial AS DATE=(SELECT DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))
DECLARE @fechaFinal AS DATE=(SELECT EOMONTH(GETDATE()))


SELECT --p.IdPersona, 
sc.Codigo , p.Nombre, SUM(td.Monto) AS MontoAcumulado
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
--INNER JOIN dbo.tSDOtransacciones t  WITH(NOLOCK) ON t.IdTransaccion = td.RelTransaccion 
INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = td.IdOperacion AND o.Fecha BETWEEN @fechaInicial AND @fechaFinal
INNER JOIN dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) ON f.IdOperacion = o.IdOperacion
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
GROUP BY p.IdPersona, sc.Codigo , p.Nombre
HAVING SUM(td.Monto) >= @montoAgrupado


