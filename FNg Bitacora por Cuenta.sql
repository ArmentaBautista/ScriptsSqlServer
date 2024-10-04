

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
, c.IdCuenta, c.Codigo, c.Descripcion, c.NumeroParcialidades
, a.IdApertura, a.Folio, a.NumeroParcialidades
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio 
INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) ON a.IdApertura = c.IdApertura
AND c.Codigo='004-005926'


SELECT suc.Descripcion AS sucursal, u.Usuario, b.* FROM dbo.tADMbitacora b  WITH(NOLOCK) 
INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion = b.IdSesion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = ss.IdUsuario
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = ss.IdSucursal
WHERE b.Tabla LIKE '%cuentas%'  and b.IdRegistro LIKE '%1984069%'
--AND b.Campo='NumeroParcialidades'
AND b.Fecha='20230405'
ORDER BY b.Fecha, b.Hora

SELECT u.Usuario,* FROM dbo.tADMbitacora b  WITH(NOLOCK) 
INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion = b.IdSesion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = ss.IdUsuario
WHERE b.Tabla LIKE '%aperturas%' AND b.Campo='NumeroParcialidades' and b.IdRegistro LIKE '%115488%'
ORDER BY b.Fecha, b.Hora

