

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCdesagregadoOperacionesProductosFinancieros')
	DROP PROC pAYCdesagregadoOperacionesProductosFinancieros
GO 

CREATE PROC pAYCdesagregadoOperacionesProductosFinancieros 
@FechaIncial AS DATE='19000101',
@FechaFinal AS DATE ='19000101',
@NoSocio AS VARCHAR(30) ='*'
AS

	IF @FechaIncial='19000101' OR @FechaIncial IS NULL OR @FechaFinal='19000101' OR @FechaFinal IS NULL 
	BEGIN
		SELECT 'Fechas no validas' AS Error
		RETURN
	END

	IF @NoSocio='*' OR @NoSocio IS NULL OR @NoSocio=''
	BEGIN
			SELECT 
					 operacion.Fecha
					 ,sucursal.Codigo AS SucursalDeLaOperacion,tipoOp.Codigo AS TipoOperacion,operacion.Folio
					 , CASE financiera.IdTipoSubOperacion WHEN 500 THEN 'Depósito' WHEN 501 THEN 'Retiro' END AS TipoMovimiento
					 , financiera.MontoSubOperacion
					 , usuario.Usuario
					 , producto.Descripcion AS Producto, c.Codigo AS NoCuenta,  socio.Codigo AS NoSocio, p.Nombre
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			INNER JOIN dbo.tSDOtransaccionesFinancieras financiera  WITH(NOLOCK) ON financiera.IdCuenta = c.IdCuenta
																					AND financiera.Fecha BETWEEN @FechaIncial AND @FechaFinal -- filtro
																					AND financiera.IdEstatus=1 -- filtro
			INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK)ON operacion.IdOperacion = financiera.IdOperacion
			INNER JOIN dbo.tCTLtiposOperacion tipoOp  WITH(NOLOCK) ON tipoOp.IdTipoOperacion = operacion.IdTipoOperacion
			INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
			INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = c.IdProductoFinanciero
			INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = operacion.IdSucursal
			INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = operacion.IdUsuarioAlta
			WHERE c.IdTipoDProducto IN (144,398,143) -- filtro
	END
    ELSE
    BEGIN
			DECLARE @IdSocio AS INT
			SELECT @IdSocio=s.IdSocio FROM dbo.tSCSsocios s  WITH(NOLOCK) WHERE s.Codigo=@NoSocio
			IF @IdSocio=0  
			BEGIN
				SELECT 'NoSocio no encontrado' AS Error
				RETURN
			END 

			SELECT 
					 operacion.Fecha
					 ,sucursal.Codigo AS SucursalDeLaOperacion,tipoOp.Codigo AS TipoOperacion,operacion.Folio
					 , CASE financiera.IdTipoSubOperacion WHEN 500 THEN 'Depósito' WHEN 501 THEN 'Retiro' END AS TipoMovimiento
					 , financiera.MontoSubOperacion
					 , usuario.Usuario
					 , producto.Descripcion AS Producto, c.Codigo AS NoCuenta,  socio.Codigo AS NoSocio, p.Nombre
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			INNER JOIN dbo.tSDOtransaccionesFinancieras financiera  WITH(NOLOCK) ON financiera.IdCuenta = c.IdCuenta
																					AND financiera.Fecha BETWEEN @FechaIncial AND @FechaFinal -- filtro
																					AND financiera.IdEstatus=1 -- filtro
			INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK)ON operacion.IdOperacion = financiera.IdOperacion
			INNER JOIN dbo.tCTLtiposOperacion tipoOp  WITH(NOLOCK) ON tipoOp.IdTipoOperacion = operacion.IdTipoOperacion
			INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
															AND socio.IdSocio = @IdSocio -- filtro
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
			INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = c.IdProductoFinanciero
			INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = operacion.IdSucursal
			INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = operacion.IdUsuarioAlta
			WHERE c.IdTipoDProducto IN (144,398,143) -- filtro
	END 