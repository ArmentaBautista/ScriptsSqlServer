


IF EXISTS(SELECT name FROM sys.objects o  WITH(NOLOCK) WHERE o.name='pAYCdesagregadoOperacionesProductosFinancierosMetodoPago')
BEGIN
	DROP PROC pAYCdesagregadoOperacionesProductosFinancierosMetodoPago
	SELECT 'borrado, ya existía'
END
GO

CREATE PROCEDURE pAYCdesagregadoOperacionesProductosFinancierosMetodoPago
@fechainicial DATE='19000101',
@fechafinal DATE='19000101'
AS

		SELECT 
					 operacion.Fecha
					 ,sucursal.Codigo AS SucursalDeLaOperacion,tipoOp.Codigo AS TipoOperacion,operacion.Folio
					 , CASE financiera.IdTipoSubOperacion WHEN 500 THEN 'Depósito' WHEN 501 THEN 'Retiro' END AS TipoMovimiento
					 , financiera.MontoSubOperacion
					 , usuario.Usuario
					 , producto.Descripcion AS Producto, c.Codigo AS NoCuenta,  socio.Codigo AS NoSocio, p.Nombre
					 , p.RFC
					 , mp.Descripcion AS InstrumentoMonetario, td.Monto
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			INNER JOIN dbo.tSDOtransaccionesFinancieras financiera  WITH(NOLOCK) ON financiera.IdCuenta = c.IdCuenta
																					AND financiera.Fecha BETWEEN @FechaInicial AND @FechaFinal -- filtro
																					AND financiera.IdEstatus=1 -- filtro
			INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK)ON operacion.IdOperacion = financiera.IdOperacion
			INNER JOIN dbo.tCTLtiposOperacion tipoOp  WITH(NOLOCK) ON tipoOp.IdTipoOperacion = operacion.IdTipoOperacion
			INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
			INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = c.IdProductoFinanciero
			INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = operacion.IdSucursal
			INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = operacion.IdUsuarioAlta
			-- agregado del método de pago
			INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON td.IdOperacion = operacion.IdOperacion
			INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago
			WHERE c.IdTipoDProducto IN (144,398,143,716) -- filtro
			