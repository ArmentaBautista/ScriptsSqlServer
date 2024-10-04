
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fFMTticketTransaccionFinancieraBKG')
BEGIN
	DROP FUNCTION fFMTticketTransaccionFinancieraBKG
	SELECT 'fFMTticketTransaccionFinancieraBKG BORRADO' AS info
END
GO

CREATE FUNCTION fFMTticketTransaccionFinancieraBKG
(
	
	@IdOperacion  AS INT =0
)
RETURNS TABLE
AS
RETURN

(
SELECT SocioCodigo = Socio.Codigo,
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
       TF.IdOperacion,
       TF.IdTipoSubOperacion,
       TF.IdEstatus,
       TF.CargosPagados,
       (TF.CapitalPagado + TF.CapitalPagadoVencido) AS CapitalPagado,
       (TF.InteresOrdinarioPagado + TF.InteresOrdinarioPagadoVencido) AS InteresOrdinarioPagado,
       (TF.InteresMoratorioPagado + TF.InteresMoratorioPagadoVencido) AS InteresMoratorioPagado,
       TF.IVAPagado,
       Cuenta.IdTipoDProducto,
       FechaSiguientePago = ISNULL(estadisticaSiguientePago.FechaSiguientePago,''),
       TF.SaldoCapital AS Saldo,
       TF.SaldoCapitalAnterior AS SaldoAnterior,
	   tf.SaldoAnterior AS SalAnteriorConInteres,
	   tf.Saldo AS SaldoConIntereses,
       TF.Fecha,
       sucsoc.Descripcion AS Sucursal,
	   Cuenta.IdCuenta,
	   TF.IdTransaccion
FROM tSDOtransaccionesFinancieras TF WITH (NOLOCK)
INNER JOIN dbo.tSDOtransaccionesFinancierasEstadisticas tfEstadisticas WITH (NOLOCK) ON tfEstadisticas.IdTransaccion = TF.IdTransaccion
LEFT JOIN dbo.tSDOestadisticasSiguientePago estadisticaSiguientePago ON estadisticaSiguientePago.IdTransaccion = tfEstadisticas.IdTransaccion
INNER JOIN tAYCcuentas Cuenta WITH (NOLOCK) ON Cuenta.IdCuenta = TF.IdCuenta
INNER JOIN tCTLtiposOperacion TipoOp WITH (NOLOCK) ON TipoOp.IdTipoOperacion = TF.IdTipoSubOperacion
	AND NOT (TipoOp.IdTipoOperacion IN ( 503, 4 ))
INNER JOIN tSCSsocios Socio WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
INNER JOIN tGRLpersonas Persona WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
INNER JOIN tAYCproductosFinancieros Producto WITH (NOLOCK) ON Producto.IdProductoFinanciero = Cuenta.IdProductoFinanciero
INNER JOIN tCTLsucursales sucsoc WITH (NOLOCK) ON sucsoc.IdSucursal = Socio.IdSucursal
WHERE TF.IdEstatus IN ( 1, 25, 31 ) and TF.IdOperacion=@IdOperacion AND @IdOperacion <> 0

)
GO

