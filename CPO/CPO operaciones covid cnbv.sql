
DECLARE @FechaIncial AS DATE='20191201'
DECLARE @FechaFinal AS DATE ='20191231'


			SELECT 
					 operacion.Fecha
					 ,sucursal.Codigo AS CodigoSucursalDeLaOperacion, sucursal.Descripcion AS SucursalDeLaOperacion
					 --,tipoOp.IdTipoOperacion
					 , tipoOp.Descripcion, tipoOp.Codigo AS TipoOperacion,operacion.Folio
					 , CASE financiera.IdTipoSubOperacion WHEN 500 THEN 'Depósito' WHEN 501 THEN 'Retiro' END AS TipoMovimiento
					 , financiera.MontoSubOperacion
					 , usuario.Usuario
					 , tproducto.Descripcion AS TipoProducto, tclasificacion.Descripcion AS Clasificacion, producto.Descripcion AS Producto
					 , c.Codigo AS NoCuenta,  socio.Codigo AS NoSocio, p.Nombre
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			INNER JOIN dbo.tSDOtransaccionesFinancieras financiera  WITH(NOLOCK) ON financiera.IdCuenta = c.IdCuenta
																					AND financiera.Fecha BETWEEN @FechaIncial AND @FechaFinal -- filtro
																					AND financiera.IdEstatus=1 -- filtro
																					AND financiera.MontoSubOperacion>0 -- filtro
			INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK)ON operacion.IdOperacion = financiera.IdOperacion
																	--AND operacion.IdTipoOperacion IN (1,10,20)
			INNER JOIN dbo.tCTLtiposOperacion tipoOp  WITH(NOLOCK) ON tipoOp.IdTipoOperacion = operacion.IdTipoOperacion																
			INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
			INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = c.IdProductoFinanciero
			INNER JOIN dbo.tCTLtiposD tproducto  WITH(NOLOCK) ON tproducto.IdTipoD = c.IdTipoDProducto
			INNER JOIN dbo.tCTLtiposD tclasificacion  WITH(NOLOCK) ON tclasificacion.IdTipoD = c.IdTipoDAIC
			INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = operacion.IdSucursal
			INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = operacion.IdUsuarioAlta
			WHERE c.IdTipoDProducto IN (144,398,143) -- filtro