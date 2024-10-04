

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCavalados')
BEGIN
	DROP PROC pCnAYCavalados
END
GO

CREATE PROC pCnAYCavalados
	@Nombre AS VARCHAR(80)
AS

SELECT 
sc.Codigo AS NoSocio, ps.Nombre, c.Codigo AS NoCuenta, c.Descripcion AS Producto
, c.FechaEntrega, c.Monto, c.SaldoCapital
, pa.Nombre AS NombreAval, avales.PorcentajeAmparado
FROM dbo.tAYCavalesAsignados avales  WITH(nolock) 
INNER JOIN dbo.tGRLpersonas pa  WITH(nolock) ON pa.IdPersona = avales.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(nolock) ON c.IdCuenta = avales.RelAvales
											AND c.IdEstatus=1
INNER JOIN dbo.tSCSsocios sc  WITH(nolock) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas ps  WITH(nolock) ON ps.IdPersona = sc.IdPersona
WHERE avales.EsAval=1 and pa.Nombre LIKE '%' + @Nombre + '%'
ORDER BY pa.Nombre
GO

