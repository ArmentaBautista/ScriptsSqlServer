
DECLARE @IdSocio AS INTEGER=58440 --12931
DECLARE @fecha AS DATE ='20220830'
DECLARE @fechaFinal AS DATE = DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 
DECLARE @MontoSuma AS numeric(18,2)



		SELECT @MontoSuma=SUM(t.Monto) FROM dbo.tSDOtransaccionesD t With (nolock) 
		JOIN dbo.tGRLoperaciones o With (nolock) ON o.IdOperacion = t.IdOperacion
		WHERE o.IdSocio=@idsocio AND t.EsCambio=0 AND NOT o.IdTipoOperacion IN (4,22,0) 
		AND o.IdEstatus!=18 AND t.IdMetodoPago IN (-2) AND t.IdTipoSubOperacion=500
		--AND o.Fecha>=@fechaFinal 
		AND (o.Fecha >= @fechaFinal AND o.Fecha<=@fecha)

		SELECT @MontoSuma

		SELECT @MontoSuma=SUM(t.Monto) 
		FROM dbo.tGRLoperaciones o With (nolock)
		JOIN dbo.tSDOtransaccionesD t With (nolock) ON o.IdOperacion = t.IdOperacion
													AND t.EsCambio=0 
													AND t.IdMetodoPago IN (-2) 
													AND t.IdTipoSubOperacion=500
		JOIN dbo.tSCSsocios sc ON sc.IdSocio = o.IdSocio
								AND sc.IdSocio = @IdSocio
		WHERE 
		NOT o.IdTipoOperacion IN (4,22,0) 
		AND o.IdEstatus=1 
		AND (o.Fecha >= @fechaFinal AND o.Fecha<=@fecha)

		SELECT @MontoSuma

