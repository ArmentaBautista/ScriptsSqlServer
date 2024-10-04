

EXEC pCnPLDescalamientosOperacionePeriodo @periodo='2022-06'



SELECT * FROM dbo.tCTLversiones v  WITH(NOLOCK) ORDER BY v.IdVersion DESC

DECLARE @fecha AS DATE ='20221231' --GETDATE()
DECLARE @fechaInicial AS DATE = DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 
DECLARE @MontoSuma AS numeric(18,2)
DECLARE @idPeriodo AS INT=0
SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
		

SELECT 
		o.IdPeriodo, o.IdSocio, p.EsPersonaMoral,t.IdMetodoPago, mp.Descripcion, SUM(t.Monto) AS AcumuladoDiario
		FROM dbo.tGRLoperaciones o With (nolock)
		JOIN dbo.tSDOtransaccionesD t With (nolock) ON o.IdOperacion = t.IdOperacion
													AND t.EsCambio=0 
													--AND t.IdMetodoPago IN (-2) 
													AND t.IdTipoSubOperacion=500
		INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = t.IdMetodoPago
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = o.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE o.IdSocio!=0 AND o.IdOperacion<>0
		AND o.Fecha BETWEEN '20220101' AND '20221231'
		AND NOT o.IdTipoOperacion IN (4,22,0) 
		AND o.IdEstatus!=18 
		GROUP BY o.IdPeriodo, o.IdSocio, p.EsPersonaMoral, t.IdMetodoPago, mp.Descripcion
