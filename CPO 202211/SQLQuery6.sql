

DECLARE @FechaAltaInicial AS DATE='20221124'
DECLARE @FechaAltaFinal AS DATE='20221124'

SELECT mt.Sucursal ,mt.NoSocio ,mt.Socio ,mt.NumeroTDD ,mt.NoCuenta ,mt.Producto ,mt.Operacion ,mt.Folio ,mt.Fecha ,mt.TipoMovimiento 
                    ,mt.Concepto ,mt.Monto ,mt.Origen ,mt.idsucursal ,mt.IdPersona ,mt.IdSocio ,mt.IdCuenta ,mt.IdCuentaABCD 
FROM fCnATMmovimientosTDD() mt WHERE mt.Fecha BETWEEN @FechaAltaInicial AND @FechaAltaFinal





EXEC dbo.pAYCcalcularCarteraDiaria

SELECT *   FROM dbo.fAYCcalcularCarteraOperacion(@FechaCalculo, 2,@IdCuenta, 0, 'DEVPAG') AS carteraOperacion;
