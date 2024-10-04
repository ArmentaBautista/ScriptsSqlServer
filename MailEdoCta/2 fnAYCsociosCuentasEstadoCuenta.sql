

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='fnAYCsociosCuentasEstadoCuenta')
BEGIN
	DROP FUNCTION dbo.fnAYCsociosCuentasEstadoCuenta
END
GO

CREATE FUNCTION dbo.fnAYCsociosCuentasEstadoCuenta()
RETURNS TABLE
AS
RETURN
(
	SELECT sc.IdSocio, c.IdCuenta
	FROM dbo.tayccuentas c  WITH(nolock) 
	INNER JOIN dbo.tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
												AND sc.EsSocioValido=1
	INNER JOIN dbo.tAYCproductosFinancierosPermitenEstadosCuenta pfce  WITH(nolock) ON pfce.IdProductoFinanciero = c.IdProductoFinanciero
	WHERE c.IdEstatus=1
)



