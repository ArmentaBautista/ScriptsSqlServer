
USE iERP_KFT
GO

SELECT per.Nombre, u.Usuario, ss.FechaTrabajo,ss.Version
,b.IdRegistro,b.Fecha, b.Hora, b.Tabla, b.PK , b.Id, b.Campo, b.ValorOriginal, b.ValorNuevo, b.IdSesion, ss.Host
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion = b.IdSesion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = ss.IdUsuario
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersonaFisica = u.IdPersonaFisica
WHERE b.Tabla LIKE '%tAYCdomiciliaciones%' AND b.IdRegistro IN (7082,7808)

SELECT d.* 
FROM dbo.tAYCdomiciliaciones d 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = d.IdSocio
WHERE sc.Codigo='105-000314'

SELECT u.Usuario, p.Nombre, sc.IdSocio, sc.Codigo, per.Nombre,c.IdCuenta, c.Codigo, c.Descripcion , c.Alta, c.FechaAlta
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = c.IdUsuarioAlta
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = u.IdPersonaFisica
WHERE c.IdCuenta IN (88326,90724,88302,90723)

SELECT ss.Version FROM dbo.tCTLsesiones ss WHERE ss.FechaTrabajo='20220324' GROUP BY ss.Version






