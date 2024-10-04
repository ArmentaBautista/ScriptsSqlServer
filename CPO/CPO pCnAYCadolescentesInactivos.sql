

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCadolescentesInactivos')
BEGIN
	DROP PROC pCnAYCadolescentesInactivos
END
GO

CREATE PROC pCnAYCadolescentesInactivos
@FechaInicial AS DATE, 
@FechaFinal AS DATE
AS

	SELECT 
	[Sucursal Socio]		= sucsoc.Descripcion,
	[Numero de Socio]		= soc.Codigo,
	[Nombre Socio]			= per.Nombre, 
	[Sucursal Cuenta]		= succuenta.Descripcion,
	[Numero Cuenta]			= cuenta.Codigo,
	Producto				= cuenta.Descripcion,
	Saldo					= cuenta.SaldoCapital,
	FechaAlta               = cuenta.FechaAlta,
	Estatus					= estatus.Descripcion
	FROM dbo.tSCSsocios soc
	INNER JOIN dbo.tAYCcuentas    cuenta     WITH(NOLOCK) ON cuenta.IdSocio       = soc.IdSocio AND cuenta.IdDivision =-25
	INNER JOIN dbo.tGRLpersonas   per        WITH(NOLOCK) ON per.IdPersona        = soc.IdPersona
	INNER JOIN dbo.tCTLsucursales sucsoc     WITH(NOLOCK) ON sucsoc.IdSucursal    = soc.IdSucursal
	INNER JOIN dbo.tCTLsucursales succuenta  WITH(NOLOCK) ON succuenta.IdSucursal = cuenta.IdSucursal
	INNER JOIN dbo.tCTLestatus    estatus    WITH(nolock) ON estatus.IdEstatus    = cuenta.IdEstatus
WHERE cuenta.FechaAlta BETWEEN @FechaInicial AND @FechaFinal
GO


