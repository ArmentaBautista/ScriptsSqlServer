

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCcolocacion')
BEGIN
	DROP PROC pCnAYCcolocacion
END
GO

CREATE PROC pCnAYCcolocacion
@Sucursal VARCHAR(100),
@Estatus VARCHAR(100) ,
@FechaInicial DATE,
@FechaFinal DATE
AS	

SELECT 1 AS Conteo, 
SucursalCodigo			= suc.Codigo,
Sucursal				= suc.Descripcion,
NoSocio					= socio.Codigo,
Nombre					= pSocio.Nombre,
NoCuenta				= c.Codigo,
Producto				= pf.Descripcion,
TipoCredito				= td.Descripcion,
Division				= division.Descripcion,
Finalidad				= Finalidades.Descripcion,
FechaApertura			= c.FechaAlta,
FechaAutorizada			= c.FechaAutorizacion,
FechaInstrumentacion	= c.FechaInstrumentacion,
FechaEntrega			= c.FechaEntrega,
MontoSolicitado			= c.MontoSolicitado,
MontoAutorizado			= c.Monto,
SaldoCapital			= c.SaldoCapital,
Estatus					= ecuenta.Descripcion
FROM dbo.tAYCcuentas c  WITH(nolock) 
INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas pSocio  WITH(nolock) ON pSocio.IdPersona = socio.IdPersona
INNER JOIN dbo.tAYCfinalidades Finalidades  WITH(nolock) ON Finalidades.IdFinalidad = c.IdFinalidad
INNER JOIN dbo.tCTLtiposD td  WITH(nolock) ON td.IdTipoD = c.IdTipoDAIC
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLsucursales suc  WITH(nolock) ON suc.IdSucursal = c.IdSucursal
INNER JOIN dbo.tCTLestatus ecuenta  WITH(nolock) ON ecuenta.IdEstatus = c.IdEstatus
INNER JOIN dbo.tCNTdivisiones division  WITH(nolock) ON division.IdDivision = c.IdDivision
WHERE  c.IdTipoDProducto=143
AND (@Sucursal='*'OR suc.Codigo = @Sucursal)
AND ( c.FechaAlta BETWEEN @FechaInicial AND @FechaFinal)



GO

