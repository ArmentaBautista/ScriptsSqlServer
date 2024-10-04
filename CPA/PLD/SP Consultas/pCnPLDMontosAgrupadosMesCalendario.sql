

IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnPLDMontosAgrupadosMesCalendario')
	DROP PROC pCnPLDMontosAgrupadosMesCalendario
GO

CREATE PROC pCnPLDMontosAgrupadosMesCalendario
@Fecha AS DATE,
@MontoAcumulado AS NUMERIC(16,2)
AS
-- Alerta por Montos Agrupados en Efectivo por Mes Calendario

DECLARE @montoAgrupado AS NUMERIC(12,2)=@MontoAcumulado

DECLARE @fechaInicial AS DATE=(SELECT DATEADD(DAY,1,EOMONTH(@Fecha,-1)))
DECLARE @fechaFinal AS DATE=(SELECT EOMONTH(@Fecha))


SELECT --p.IdPersona, 
sc.Codigo , p.Nombre--, td.Monto
, SUM(td.Monto) AS MontoAcumulado
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
INNER JOIN (
				SELECT f.IdOperacion, c.IdSocio
				FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK)
				INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta
				INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = f.IdOperacion AND o.Fecha BETWEEN @fechaInicial AND @fechaFinal 
				GROUP BY f.IdOperacion, c.IdSocio 
			) AS f ON f.IdOperacion = td.IdOperacion
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = f.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
GROUP BY  sc.Codigo , p.Nombre
HAVING SUM(td.Monto) >= @montoAgrupado


