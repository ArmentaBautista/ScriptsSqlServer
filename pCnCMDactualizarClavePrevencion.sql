
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnCMDactualizarClavePrevencion')
	DROP PROC pCnCMDactualizarClavePrevencion
GO

CREATE PROC pCnCMDactualizarClavePrevencion 
@NoSocio AS varchar(20)='',
@Folio AS int=0,
@ClavePrevencion AS varchar(20)=''
AS
	-- SELECT ce.ClavePrevencionSIC
	UPDATE ce SET ce.ClavePrevencionSIC=@ClavePrevencion
	FROM dbo.tAYCcuentas c  WITH(NOLOCK)
	INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tAYCaperturas a ON a.IdApertura = c.IdApertura
									AND a.Folio=@Folio
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = a.IdSocio
												AND sc.Codigo=@NoSocio
	

	SELECT a.Folio, sc.Codigo AS NoSocio, c.Codigo AS NoCuenta, ce.ClavePrevencionSIC
	FROM dbo.tAYCcuentas c  WITH(NOLOCK)
	INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tAYCaperturas a ON a.IdApertura = c.IdApertura
									AND a.Folio=@Folio
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = a.IdSocio
												AND sc.Codigo=@NoSocio


