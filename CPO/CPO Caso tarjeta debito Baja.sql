

SELECT suc.Descripcion, u.Usuario, s.Host, s.FechaTrabajo,
t.* 
-- begin tran update t SET t.IdEstatus=1
FROM dbo.tSCStarjetas t  WITH(NOLOCK) 
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = t.IdUsuarioCambio
INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK) ON s.IdSesion = t.IdSesion
INNER JOIN  dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = s.IdSucursal
WHERE t.NumeroTarjeta='506350002019'
AND t.Consecutivo='6004'


SELECT a.Folio, c.* FROM dbo.tAYCcuentas c  WITH(NOLOCK)
INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) ON a.IdApertura = c.IdApertura
WHERE c.IdCuenta=1700327