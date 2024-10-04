
USE IERP_OBL
GO

/* DATOS DE PRUEBA
IdPeriodo	IdSocio	Fecha		Acumulado		fAcumulado
439			438196	2022-10-10	405000.00000000	405,000.00
439			57007	2022-10-10	306500.00000000	306,500.00
439			497808	2022-10-10	251001.00000000	251,001.00
439			105931	2022-10-10	225900.00000000	225,900.00
439			46673	2022-10-10	200000.00000000	200,000.00
*/

DECLARE @idSocio AS INT=497808

SELECT sc.IdSocio, sc.Codigo, per.Nombre  FROM dbo.tSCSsocios sc  WITH(NOLOCK)
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona WHERE sc.IdSocio=@idSocio

DECLARE @fecha AS DATE=GETDATE()
DECLARE @monto AS NUMERIC(10,2)='50000'

DECLARE @idPeriodo AS INT=0
SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
SELECT * FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario acu  WITH(NOLOCK) WHERE acu.IdSocio=@IdSocio AND IdPeriodo=@idPeriodo

SELECT dbo.fPLDvalidarEscalamientoOperacionestest(@idSocio,@fecha,@monto)


