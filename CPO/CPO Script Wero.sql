

USE IERP_OBL;
GO
SELECT * FROM dbo.vAYCcuentaBasica WHERE Cuenta = '0-059768';



SELECT Operacion.IdOperacion, Transaccion.IdTransaccion, Operacion.IdTipoOperacion, Transaccion.IdCuenta, Transaccion.Fecha, Transaccion.CapitalGenerado, CapitalPagado = ISNULL(Transaccion.CapitalPagado, 0)+ISNULL(Transaccion.CapitalPagadoVencido, 0), InteresOrdinarioPagado = ISNULL(Transaccion.InteresOrdinarioPagado, 0)+ISNULL(Transaccion.InteresOrdinarioPagadoVencido, 0), InteresMoratorioPagado = ISNULL(Transaccion.InteresMoratorioPagado, 0)+ISNULL(Transaccion.InteresMoratorioPagadoVencido, 0), IVAPagado = ISNULL(Transaccion.IVAInteresOrdinarioPagado, 0)+ISNULL(Transaccion.IVAInteresMoratorioPagado, 0), Transaccion.TotalPagado
FROM dbo.tSDOtransaccionesFinancieras Transaccion WITH(NOLOCK)
INNER JOIN dbo.tGRLoperaciones Operacion WITH(NOLOCK)ON Operacion.IdOperacion = Transaccion.IdOperacion
WHERE NOT Operacion.IdTipoOperacion IN (38,46) AND NOT Transaccion.IdTipoSubOperacion IN ( 515) AND Transaccion.IdEstatus = 1 AND Transaccion.IdCuenta = 1378195;

SELECT IdTransaccionFinanciera, IdParcialidad, IdTipoDconcepto, Fecha, InteresDiario, Devengado, Pagado, Condonado, IVAdevengado, IVApagado, IVAcondonado, TotalDevengado, TotalPagado, IdEstatus
FROM dbo.tSDOtransaccionesFinancierasD
WHERE IdTransaccionFinanciera = 63506348;


SELECT IdParcialidad, IdCuenta, NumeroParcialidad, EstaPagada, Inicio, Vencimiento, CapitalInicial, Capital, CapitalFinal, CapitalPagado, InteresOrdinario,InteresOrdinarioCuentasOrden, InteresOrdinarioPagado, InteresMoratorio, InteresMoratorioPagado, IVAInteresOrdinario, IVAInteresOrdinarioPagado, IVAInteresMoratorio, IVAInteresMoratorioPagado
FROM dbo.tAYCparcialidades WITH(NOLOCK)
WHERE IdCuenta = 1378195
ORDER BY NumeroParcialidad;


SELECT 2.74986600 * DATEDIFF(DAY, '2020-09-04', CURRENT_TIMESTAMP);

BEGIN TRANSACTION
--COMMIT
--ROLLBACK
select FechaUltimoCalculo, *
--UPDATE cuenta SET cuenta.FechaUltimoCalculo = '20200924'
from tayccuentas cuenta
where cuenta.idcuenta = 1378195

select *
from dbo.fAYCcalcularCarteraOperacion(CURRENT_TIMESTAMP,2,1378195,0,'DEVPAG')