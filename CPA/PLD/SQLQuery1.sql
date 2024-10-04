
USE iERP_CPA

-- Alerta por liquidación anticipada de 15 días con respecto de la entrega

DECLARE @diasLicAnticipada AS TINYINT=30

SELECT sc.Codigo AS NoSocio, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion, c.FechaActivacion,  ce.FechaBaja,c.Vencimiento, DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) AS DiasTranscurridos
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE c.IdTipoDProducto=143 AND ce.FechaBaja!='19000101'
AND DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) <=@diasLicAnticipada
AND ce.FechaBaja BETWEEN '20190801' AND '20190816'
ORDER BY c.IdCuenta

