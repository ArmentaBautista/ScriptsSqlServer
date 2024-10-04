IF EXISTS(SELECT name FROM sys.objects o WHERE o.name ='pLSTcreditosRelacionados')
BEGIN
	DROP PROCEDURE pLSTcreditosRelacionados
	PRINT 'pLSTcreditosRelacionados Borrado'
END
GO

CREATE PROCEDURE dbo.pLSTcreditosRelacionados
	@FechaSolicitud AS DATE ='19000101'
	AS
			SELECT per.Nombre,
			 s.Codigo AS NoSocio,
			 cu.Descripcion Cuenta,
			 cu.Codigo AS NoCuenta,
			 cat.Descripcion
			 FROM  dbo.tAYCcuentas cu WITH(NOLOCK) 
			 JOIN dbo.tSCSsocios s WITH(NOLOCK) ON s.IdSocio=cu.IdSocio
			 JOIN dbo.tGRLpersonas per WITH(NOLOCK) ON per.IdPersona = s.IdPersona
			 JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = per.IdPersona
			 JOIN dbo.tSITcatalogos cat WITH(NOLOCK) ON cat.IdCatalogoSITI = pf.IdCatalogoSITIpersonaRelacionada
			 WHERE cu.IdEstatus=1 AND cu.IdTipoDProducto=143
			 AND pf.IdCatalogoSITIpersonaRelacionada NOT IN (0,1358) 
GO
			 PRINT 'pLSTcreditosRelacionados Creado'

GO



