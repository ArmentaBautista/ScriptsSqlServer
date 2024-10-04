
USE iERP_KFT
go



select u.Usuario, ss.FechaTrabajo,ss.Version
, pf.Codigo, pf.Descripcion
, b.*
FROM dbo.tADMbitacora b  WITH(NOLOCK)  
INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion=b.IdSesion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = ss.IdUsuario
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero=b.IdRegistro
WHERE b.Tabla = 'tAYCproductosFinancieros' AND b.Campo='DisponibleParaGarantia'
ORDER BY b.Id



