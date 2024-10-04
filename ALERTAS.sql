
USE TIC_CAZ
GO

-- INNER JOIN
SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersona
	
-- LEFT
SELECT 
p.IdPersona, p.Nombre,
sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
LEFT Excluding JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersona

-- Filtrado de registros nulos del resultado
SELECT COUNT(1) as NoPersonasNoSocios
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersona
WHERE idsocio IS NULL

-- Alternativa con SubConsultas
SELECT 
p.IdPersona, p.Nombre
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
WHERE p.IdPersona NOT IN (SELECT sc.IdPersona FROM dbo.tSCSsocios sc  WITH(NOLOCK))

-- RIGHT JOIN
SELECT 
p.IdEmpleado, p.Codigo,
sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta 
FROM dbo.tPERempleados p  WITH(NOLOCK) 
RIGHT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersonaFisica
WHERE NOT (p.IdEmpleado IS NULL) AND p.IdEmpleado<>0

SELECT 
p.IdEmpleado, p.Codigo,
sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta 
FROM dbo.tPERempleados p  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
ON sc.IdPersona = p.IdPersonaFisica
WHERE  p.IdEmpleado<>0

-- Full
SELECT pf.IdProductoFinanciero, pf.Codigo, c.IdCuenta, c.Descripcion 
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
FULL OUTER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdProductoFinanciero = pf.IdProductoFinanciero

-- CROSS JOIN
SELECT p.Nombre, pf.Descripcion
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
CROSS JOIN dbo.tAYCproductosFinancieros pf WITH(NOLOCK) 
WHERE p.Nombre LIKE '%armenta%' AND pf.IdTipoDDominioCatalogo=144

