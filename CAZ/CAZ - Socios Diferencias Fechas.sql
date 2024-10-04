
USE iERP_CAZ
GO

-- DROP TABLE ##JCAsociosCambioFechaAlta

SELECT sc.IdSocio, sc.Codigo, p.Nombre, c.Codigo AS NoCuenta, sc.FechaAlta, CAST(c.Alta AS DATE) AS Alta, DATEDIFF(DAY,sc.FechaAlta,CAST(c.Alta AS DATE)) AS Dias
INTO ##JCAsociosCambioFechaAlta
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdProductoFinanciero=41 AND c.IdEstatus=1
WHERE sc.EsSocioValido=1
AND CAST(c.Alta AS DATE)<>sc.FechaAlta 
ORDER BY Dias



SELECT * 
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
INNER JOIN ##JCAsociosCambioFechaAlta t  ON t.idsocio=b.IdRegistro
WHERE b.Tabla LIKE '%socios%'
AND b.Campo ='Fechaalta'

