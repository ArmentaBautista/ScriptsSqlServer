

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pAYCdesagregadoOperacionesProductosFinancierosMetodoPago')
BEGIN
	DROP PROC pAYCdesagregadoOperacionesProductosFinancierosMetodoPago
END
GO

CREATE PROC dbo.pAYCdesagregadoOperacionesProductosFinancierosMetodoPago
@fechainicial DATE='19000101',
@fechafinal DATE='19000101'
AS
BEGIN
		IF @fechainicial='19000101' OR @fechafinal='19000101'
		BEGIN
		    SELECT 'Las fechas de inicio y fin deben contener una fecha válida' AS [Información]
			RETURN 0
		END

		IF @fechainicial  > @fechafinal
		BEGIN
		    SELECT 'Las fechas de inicio debe ser igual o menor que la fecha final' AS [Información]
			RETURN 0
		END
     
		SELECT 
					 operacion.Fecha, CAST(financiera.Alta AS TIME) AS Hora
					 ,sucursal.Codigo AS ClaveSucursal, sucursal.Descripcion AS Sucursal
					 ,tipoOp.Codigo AS TipoOperacion,operacion.Folio
					 --, financiera.IdTipoSubOperacion, financiera.InteresOrdinarioDevengado, financiera.InteresOrdinarioPagado, financiera.InteresAcapitalizar, financiera.InteresRetirado, financiera.InteresCapitalizado, financiera.CapitalGenerado, financiera.CapitalPagado
					 , CASE financiera.IdTipoSubOperacion WHEN 500 THEN 'Depósito' WHEN 501 THEN 'Retiro' END AS TipoMovimiento 
					 , financiera.SaldoAnterior AS SaldoCapitalAnterior
					 , financiera.MontoSubOperacion AS MontoOperacion
					 , financiera.SaldoCapital AS SaldoCapital
					 , divOpe.Descripcion AS Divisa
					 , usuario.Usuario
					 , tprod.Descripcion AS TipoProducto, divcta.Descripcion AS DivisionProducto, producto.Descripcion AS Producto, c.Codigo AS NoCuenta
					 ,  socio.Codigo AS NoSocio, p.Nombre, p.RFC
					 , ISNULL(mp.Descripcion,'TRASPASO') AS InstrumentoMonetario
					 , ISNULL(td.Monto,0.00) AS MontoInstrumentoMovimiento
					 , efinanciera.Descripcion AS EstatusMovimiento
					 , ldNivelRiesgo.Descripcion AS NivelDeRiesgo
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			INNER JOIN dbo.tCTLtiposD tprod  WITH(nolock) ON tprod.IdTipoD = c.IdTipoDProducto
			INNER JOIN dbo.tCNTdivisiones divcta  WITH(nolock) ON divcta.IdDivision = c.IdDivision
			INNER JOIN dbo.tSDOtransaccionesFinancieras financiera  WITH(NOLOCK) ON financiera.IdCuenta = c.IdCuenta
																					AND financiera.IdTipoSubOperacion IN (500,501)
																					AND financiera.Fecha BETWEEN @FechaInicial AND @FechaFinal -- filtro
																					AND financiera.IdEstatus=1 -- filtro
			INNER JOIN dbo.tCTLestatus efinanciera  WITH(nolock) ON efinanciera.IdEstatus = financiera.IdEstatus
			INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK)ON operacion.IdOperacion = financiera.IdOperacion
			INNER JOIN dbo.tCTLdivisas divOpe  WITH(nolock) ON divOpe.IdDivisa = operacion.IdDivisa
			INNER JOIN dbo.tCTLtiposOperacion tipoOp  WITH(NOLOCK) ON tipoOp.IdTipoOperacion = operacion.IdTipoOperacion
			INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
			INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = c.IdProductoFinanciero
			INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = operacion.IdSucursal
			INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = operacion.IdUsuarioAlta
			-- agregado del método de pago
			LEFT JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON td.IdOperacion = operacion.IdOperacion AND td.IdOperacion!=0
			LEFT JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago
			-- agregado del nivel de riesgo
			LEFT JOIN dbo.tCATlistasD ldNivelRiesgo  WITH(nolock) ON ldNivelRiesgo.IdListaD = socio.IdListaDnivelRiesgo
			WHERE c.IdTipoDProducto IN (144,398,143,716) -- filtro
			ORDER BY operacion.Fecha, Hora

END