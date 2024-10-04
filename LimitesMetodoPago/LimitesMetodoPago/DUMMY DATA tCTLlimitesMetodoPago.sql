

TRUNCATE TABLE dbo.tCTLlimitesMetodosPago

INSERT INTO dbo.tCTLlimitesMetodosPago
(IdMetodoPago,IdRecurso,IdTipoOperacion,IdTipoSubOperacion,LimiteInferior,LimiteSuperior)
VALUES(-1,942,10,501,0,70000)

INSERT INTO dbo.tCTLlimitesMetodosPago
(IdMetodoPago,IdRecurso,IdTipoOperacion,IdTipoSubOperacion,LimiteInferior,LimiteSuperior)
VALUES(-1,320,10,501,0,70000)


SELECT * FROM dbo.tCTLlimitesMetodosPago