
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--	Se tomo el codigo de vFMTticketTransaccionFinanciera y se modifico de la siguiente manera:
-- convertir a funcion y validar el resultado, si es correcto modificar el ticket para usar dicha funcion
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */


DECLARE @idOperacion AS INT=2033258545

SELECT 
SocioCodigo = Socio.Codigo,
       Cuenta = Cuenta.Codigo,
       Descripcion = Producto.Descripcion,
       Operacion = TipoOp.Descripcion,
       Socio = Persona.Nombre,
       Monto = CASE
                   WHEN TF.Naturaleza = 1 THEN
                       TF.TotalCargos
                   ELSE
                       TF.TotalAbonos
               END,

       --Abonos =	CASE WHEN NOT TF.IdTransaccion IS NULL THEN 
       --				CASE WHEN TF.Naturaleza = - 1 THEN 
       --					TF.TotalAbonos 
       --				ELSE 
       --					0 
       --				END 
       --			END,
       TF.IdOperacion,
       TF.IdTipoSubOperacion,
       TF.IdEstatus,
       CargosPagados = TF.CargosPagados - IIF(TF.IdBienServicio <> 0 
								AND ISNULL(impuesto.TasaIVA,0)<>0 
								AND TF.IVACargosPagado = 0 
								AND TF.CargosPagados <> 0,
								ROUND(TF.CargosPagados * impuesto.TasaIVA,2)
								,0),
       (TF.CapitalPagado + TF.CapitalPagadoVencido) AS CapitalPagado,
       (TF.InteresOrdinarioPagado + TF.InteresOrdinarioPagadoVencido) AS InteresOrdinarioPagado,
       (TF.InteresMoratorioPagado + TF.InteresMoratorioPagadoVencido) AS InteresMoratorioPagado,
       IVApagado = TF.IVAPagado,-- + IIF(TF.IdBienServicio <> 0 
								--AND ISNULL(impuesto.TasaIVA,0)<>0 
								--AND TF.IVACargosPagado = 0 
								--AND TF.CargosPagados <> 0,
								--ROUND(TF.CargosPagados * impuesto.TasaIVA,2)
								--,0),
       Cuenta.IdTipoDProducto,
       FechaSiguientePago = ISNULL(sigpag.FechaSiguientePago, ''),
       TF.SaldoCapital AS Saldo,
       TF.SaldoCapitalAnterior AS SaldoAnterior,
       TF.SaldoAnterior AS SalAnteriorConInteres,
       TF.Saldo AS SaldoConIntereses,
       TF.Fecha,
       sucsoc.Descripcion AS Sucursal,
       Cuenta.IdCuenta,
	   IVACargosPagado = IIF(TF.IdBienServicio <> 0 
								AND ISNULL(impuesto.TasaIVA,0)<>0 
								AND TF.IVACargosPagado = 0 
								AND TF.CargosPagados <> 0,
								ROUND(TF.CargosPagados * impuesto.TasaIVA,2)
								,TF.IVACargosPagado)
FROM dbo.tGRLoperaciones ope  WITH(NOLOCK)  
INNER JOIN tSDOtransaccionesFinancieras TF WITH (NOLOCK) ON TF.IdOperacion = ope.IdOperacion AND TF.IdOperacion > 0
INNER JOIN dbo.tSDOtransaccionesFinancierasEstadisticas tfEstadisticas WITH (NOLOCK) ON tfEstadisticas.IdTransaccion = TF.IdTransaccion
LEFT JOIN dbo.tSDOestadisticasSiguientePago sigpag WITH (NOLOCK) ON sigpag.IdTransaccion = tfEstadisticas.IdTransaccion 
																						AND sigpag.FechaSiguientePago >= '20211101'
INNER JOIN tAYCcuentas Cuenta WITH (NOLOCK) ON Cuenta.IdCuenta = TF.IdCuenta
INNER JOIN tCTLtiposOperacion TipoOp WITH (NOLOCK) ON TipoOp.IdTipoOperacion = TF.IdTipoSubOperacion 
														AND NOT (TipoOp.IdTipoOperacion IN ( 503, 4 ))
INNER JOIN tSCSsocios Socio WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
INNER JOIN tGRLpersonas Persona WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
INNER JOIN tAYCproductosFinancieros Producto WITH (NOLOCK) ON Producto.IdProductoFinanciero = Cuenta.IdProductoFinanciero
INNER JOIN tCTLsucursales sucsoc WITH (NOLOCK) ON sucsoc.IdSucursal = Socio.IdSucursal
LEFT JOIN dbo.tGRLbienesServicios bServicio WITH(NOLOCK) ON bServicio.IdBienServicio = TF.IdBienServicio
LEFT JOIN dbo.tIMPimpuestos impuesto WITH(NOLOCK) ON impuesto.IdImpuesto = bServicio.IdImpuesto
WHERE ope.IdOperacion=@idOperacion AND TF.IdEstatus IN ( 1, 25, 31 )

