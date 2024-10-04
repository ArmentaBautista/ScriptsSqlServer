
-- VARIABLES TABLA

DECLARE @IdSocio AS INTEGER=12931
DECLARE @fecha AS DATE ='20220830'
DECLARE @fechaFinal AS DATE = DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 
DECLARE @MontoSuma AS numeric(18,2)

SELECT @fechaFinal AS FechaFinal

DECLARE @operaciones AS TABLE(
	IdOperacion INT PRIMARY KEY
)

INSERT INTO @operaciones (IdOperacion)
SELECT o.IdOperacion 
FROM dbo.tGRLoperaciones o With (nolock)
WHERE o.IdSocio=@idsocio 
AND NOT o.IdTipoOperacion IN (4,22,0) 
AND o.IdEstatus=1 
AND o.Fecha>=@fechaFinal

DECLARE @transacciones AS TABLE(
	IdOperacion INT PRIMARY KEY,
	Monto numeric(10,2)
)

INSERT INTO @transacciones(IdOperacion,Monto)
SELECT t.IdOperacion, t.Monto 
FROM @operaciones o 
JOIN dbo.tSDOtransaccionesD t With(nolock) ON o.IdOperacion = t.IdOperacion
													AND t.EsCambio=0 
													AND t.IdMetodoPago IN (-2) 
													AND t.IdTipoSubOperacion=500


-------------
		SELECT @MontoSuma=SUM(t.Monto) 
		FROM @operaciones o 
		JOIN @transacciones t ON o.IdOperacion = t.IdOperacion
								
		
		SELECT @MontoSuma