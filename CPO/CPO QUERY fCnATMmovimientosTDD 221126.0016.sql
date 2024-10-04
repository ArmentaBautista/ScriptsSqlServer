

DECLARE @FechaAltaInicial AS DATE='20200322'
DECLARE @FechaAltaFinal AS DATE='20200322'

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- OBTENCIÓN DE CUENTAS CON TARJETAS

		DECLARE @ctasT AS TABLE(
			idsucursal INT,
			IdPersona INT,
			IdSocio INT,
			IdCuenta INT,
			SucursalCodigo VARCHAR(50),
			Sucursal VARCHAR(50),
			NoSocio VARCHAR(50),
			Socio VARCHAR(50),
			NumeroTDD VARCHAR(50),
			NoCuenta VARCHAR(50),
			Producto VARCHAR(50)
		)

		INSERT INTO @ctasT (
			idsucursal ,
			IdPersona ,
			IdSocio ,
			IdCuenta ,
			SucursalCodigo ,
			Sucursal ,
			NoSocio ,
			Socio ,
			NumeroTDD ,
			NoCuenta ,
			Producto
		) 
		SELECT 
		  suc.idsucursal
		, p.IdPersona
		, sc.IdSocio
		, c.IdCuenta
		, suc.Codigo AS SucursalCodigo
		, suc.Descripcion AS Sucursal
		, sc.codigo AS NoSocio
		, p.nombre AS Socio
		, t.NumeroTDD
		, c.Codigo AS NoCuenta
		, pf.Descripcion AS Producto
		FROM dbo.tSCStarjetas t  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c ON t.IdCuenta = c.IdCuenta
										AND c.IdTipoDProducto=144
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
		INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) ON td.IdTipoD = c.IdTipoDProducto 
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- JOIN CON TRANSACCIONES FINANCIERAS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

			SELECT
			ct.idsucursal,
            ct.IdPersona,
            ct.IdSocio,
            ct.IdCuenta,
            --ct.SucursalCodigo,
            ct.Sucursal,
            ct.NoSocio,
            ct.Socio,
            ct.NumeroTDD,
            ct.NoCuenta,
            ct.Producto,
			tope.Codigo AS Operacion
			, o.Folio
			, tf.Fecha
			, CASE tf.IdTipoSubOperacion
								WHEN 500 THEN 'DEPOSITO'
								WHEN 501 THEN 'RETIRO'
			END TipoMovimiento
			, o.Concepto
			, tf.MontoSubOperacion AS Monto
			,ab.Descripcion AS Origen
			FROM @ctasT ct 
			INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta=ct.IdCuenta
																		AND tf.IdOperacion <> 0
																		AND tf.Fecha BETWEEN @FechaAltaInicial AND @FechaAltaFinal
			INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = tf.IdOperacion
															AND o.IdTipoOperacion <> 4  
			INNER JOIN dbo.tCTLtiposOperacion tope  WITH(NOLOCK) ON tope.IdTipoOperacion = o.IdTipoOperacion 
			INNER JOIN dbo.tSDOtransacciones ts  WITH(NOLOCK) ON ts.IdOperacion = o.IdOperacion
			INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) ON sdo.IdSaldo=ts.IdSaldoDestino
			INNER JOIN dbo.tGRLcuentasABCD ab  WITH(NOLOCK) ON ab.IdCuentaABCD=sdo.IdCuentaABCD
			
			






			







 