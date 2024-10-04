


CREATE UNIQUE CLUSTERED INDEX PK_tSDOtransaccionesFinancieras_N
ON dbo.tSDOtransaccionesFinancieras(IdTransaccion)
WITH (DROP_EXISTING=ON,ONLINE=ON) ON TEST_FG

