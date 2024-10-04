
use iERP_FNG
go


DECLARE @table TABLE(
	IdTransaccion INT,
	Alta	DATE,
	MontoSubOperacion NUMERIC(23,8)
)

INSERT INTO @table
(
    IdTransaccion,
    Alta,
    MontoSubOperacion
)
select tf.IdTransaccion, tf.alta, tf.MontoSubOperacion
From tsdoTransacciones tf  WITH(NOLOCK) 
Where tf.IdEstatus=108


SELECT DATEPART(YEAR,t.alta) AS año, DATEPART(MONTH,t.alta) AS mes, COUNT(1) AS Num
FROM @table t
GROUP BY DATEPART(YEAR,t.alta), DATEPART(MONTH,t.alta)
ORDER BY DATEPART(YEAR,t.alta), DATEPART(MONTH,t.alta)
