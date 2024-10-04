/*
SELECT s.Codigo, p.Nombre, c.Codigo, c.Descripcion FROM dbo.tSCSsocios s WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p WITH(NOLOCK) ON p.IdPersona = s.IdPersona
AND p.Nombre LIKE '%martha alejandra gonzal%'
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = s.IdSocio AND c.IdTipoDProducto=143 AND c.IdEstatus=1
*/

DECLARE @Cuenta AS VARCHAR(20)='10-093956'
DECLARE @IdCuenta AS INT
DECLARE @FechaInicio AS VARCHAR(8)='20220801'
DECLARE @FechaFin AS VARCHAR(8)='20220831'

SELECT @IdCuenta=idcuenta FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.Codigo=@Cuenta

EXEC pEstadoDeCuenta @Cuenta, @FechaFin

SELECT dbo.fAYCFechaProximoAbono(@Cuenta, @FechaFin) as FechaProximoAbono

EXEC pFMTmovimientosEstadoCuenta @IdCuenta,@FechaInicio,@FechaFin

--SELECT estadoCuentaSaldoInicial()
-- SELECT dbo.fAYCestadoCuentaSaldoInicial()

EXEC pFMTcargosSegurosPagadosPeriodo @Cuenta,@FechaInicio,@FechaFin

EXEC pFMTcalcularInteresDeudoresPROY @IdCuenta,@FechaFin,0,'CALCULO'

--SELECT * FROM sys.objects WHERE name LIKE '%CuentaSaldo%'
