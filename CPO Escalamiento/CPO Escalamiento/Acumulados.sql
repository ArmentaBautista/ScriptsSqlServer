

-- TABLAS DE ACUMULADOS 
/*

IF EXISTS(SELECT name FROM [iERP_OBL_HST].sys.tables t WHERE t.name='tPLDDacumuladoDepositosEfectivoMesCalendario')
BEGIN
	GOTO TablaExiste
END

CREATE TABLE iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario(
	IdPeriodo INT,
	IdSocio INT,
	Fecha DATE,
	AcumuladoMesCalendario numeric(18,2)
)

--CREATE INDEX IX_tPLDDacumuladoDepositosEfectivoMesCalendario_IdPerodo_IdSocio_Fecha ON iERP_OBL_HST.dbo.tPLDacumuladosDiarios (IdPerodo,IdSocio,Fecha)

TablaExiste:
--select 'Tabla Existe'

*/
GO
/*
 --CONSULTA DE LLENADO DIARIO 

--DECLARE @IdSocio AS INTEGER=58440 --12931
--DECLARE @fecha AS DATE ='20220831'
DECLARE @fecha AS DATE ='20221231' --GETDATE()
DECLARE @fechaInicial AS DATE = DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 
DECLARE @MontoSuma AS numeric(18,2)
DECLARE @idPeriodo AS INT=0

		
		SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
		
		DELETE FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario WHERE idperiodo=@idPeriodo

		INSERT INTO iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario (IdPeriodo,IdSocio,Fecha,AcumuladoMesCalendario)
		SELECT 
		o.IdPeriodo, o.IdSocio, @fecha AS Fecha
		--, o.Fecha
		, SUM(t.Monto) AS AcumuladoDiario
		--,COUNT(1)
		FROM dbo.tGRLoperaciones o With (nolock)
		JOIN dbo.tSDOtransaccionesD t With (nolock) ON o.IdOperacion = t.IdOperacion
													AND t.EsCambio=0 
													AND t.IdMetodoPago IN (-2) 
													AND t.IdTipoSubOperacion=500
		WHERE o.IdSocio!=0 
		--AND o.IdSocio=@idsocio 
		--AND o.Fecha BETWEEN @fechaFinal AND o.Fecha
		--AND (o.Fecha >= @fechaInicial AND o.Fecha<=@fecha)
		AND o.IdPeriodo=@idPeriodo
		AND NOT o.IdTipoOperacion IN (4,22,0) 
		AND o.IdEstatus!=18 
		GROUP BY o.IdPeriodo, o.IdSocio--, o.Fecha
		--ORDER BY COUNT(1) DESC

*/
GO	

/* Consulta para el alertamiento


DECLARE @fecha AS DATE =GETDATE()
DECLARE @idPeriodo AS INT=0

		
SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
		
SELECT acu.*
FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario acu
WHERE IdPeriodo<>13
--acu.IdSocio=@IdSocio
--AND (acu.Fecha >= @fechaFinal AND acu.Fecha<=@fecha)
AND IdPeriodo=@idPeriodo
*/	

GO