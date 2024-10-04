
IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnPLDLiquidacionesAnticipadasCredito')
	DROP PROC pCnPLDLiquidacionesAnticipadasCredito
GO

CREATE PROC pCnPLDLiquidacionesAnticipadasCredito
@FechaInicial AS DATE,
@FechaFinal AS DATE
AS

-- Alerta por liquidación anticipada de 15 días con respecto de la entrega

DECLARE @diasLicAnticipada AS TINYINT=15

SELECT sc.Codigo AS NoSocio, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion, c.FechaActivacion,  ce.FechaBaja,c.Vencimiento, DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) AS DiasTranscurridos
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE c.IdTipoDProducto=143 AND ce.FechaBaja!='19000101'
AND c.FechaActivacion BETWEEN @FechaInicial AND @FechaFinal
AND DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) <=@diasLicAnticipada
ORDER BY c.IdCuenta

