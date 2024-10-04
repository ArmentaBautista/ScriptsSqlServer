

--DECLARE @IdSocio AS INTEGER=58440 --12931
--DECLARE @fecha AS DATE ='20220831'
DECLARE @fecha AS DATE =GETDATE()
DECLARE @fechaInicial AS DATE = DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 
DECLARE @MontoSuma AS numeric(18,2)
DECLARE @idPeriodo AS INT=0

		
		SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
		

		SELECT 
		o.IdPeriodo, o.IdSocio, @fecha AS Fecha
		,SUM(t.Monto) AS Acumulado
		,FORMAT(SUM(t.Monto),'#,###.00') AS fAcumulado
		--,COUNT(1)
		FROM dbo.tGRLoperaciones o With (nolock)
		JOIN dbo.tSDOtransaccionesD t With (nolock) ON o.IdOperacion = t.IdOperacion
													AND t.EsCambio=0 
													AND t.IdMetodoPago IN (-2) 
													AND t.IdTipoSubOperacion=500
		WHERE o.IdSocio<>0
		AND o.IdPeriodo=@idPeriodo
		AND NOT o.IdTipoOperacion IN (4,22,0) 
		AND o.IdEstatus!=18 
		GROUP BY o.IdPeriodo, o.IdSocio--, o.Fecha
		ORDER BY Acumulado DESC


