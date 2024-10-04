
-- SE ierp_cpa

DECLARE @montoAgrupado AS NUMERIC(12,2)=300000

DECLARE @fechaInicial AS DATE=(SELECT DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))
DECLARE @fechaFinal AS DATE=(SELECT EOMONTH(GETDATE()))


SELECT --p.IdPersona, 
--o.Folio,
sc.Codigo , p.Nombre--, td.Monto
, SUM(td.Monto) AS MontoAcumulado
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
--INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = td.IdOperacion AND o.Fecha BETWEEN @fechaInicial AND @fechaFinal
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
--WHERE p.Nombre='MAYRA ARACELI BARRERA VALDIVIA'
--ORDER BY o.Folio

SELECT o.Folio,td.Monto, p.Nombre,c.Codigo
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = td.IdOperacion AND o.Fecha BETWEEN @fechaInicial AND @fechaFinal
INNER JOIN (
				SELECT f.IdOperacion, f.IdCuenta
				FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) 
				GROUP BY f.IdOperacion, f.IdCuenta 
			) AS f ON f.IdOperacion = o.IdOperacion
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE p.Nombre='ESPERANZA SAHAGUN RODRIGUEZ'
GROUP BY o.Folio,td.Monto, p.Nombre,c.Codigo
ORDER BY o.Folio

EXEC pCnPLDMontosAgrupadosMesCalendario '20190816',300000



