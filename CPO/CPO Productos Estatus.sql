
USE IERP_OBL
GO


SELECT  
ea.Alta, ualta.Usuario AS UsuarioAlta
, e.Codigo AS EstatusCodigo, e.Descripcion AS Estatus
, ucambio.Usuario AS UsuarioUltimoCambio, ea.UltimoCambio
, pf.Codigo AS ProductoCodigo, pf.Descripcion AS Producto
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = pf.IdEstatusActual
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = ea.IdEstatus
INNER JOIN dbo.tCTLusuarios ualta  WITH(NOLOCK) ON ualta.IdUsuario = ea.IdUsuarioAlta
INNER JOIN dbo.tCTLusuarios ucambio  WITH(NOLOCK) ON ucambio.IdUsuario = ea.IdUsuarioCambio
WHERE pf.IdProductoFinanciero<>0
ORDER BY ea.Alta asc

