
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- tBKGtipoMovimientoMovementTypes
 TRUNCATE TABLE dbo.tBKGtipoMovimientoMovementTypes
 GO
/*
	SELECT * from tBKGtipoMovimientoMovementTypes	
*/


IF NOT EXISTS(SELECT 1 FROM tBKGtipoMovimientoMovementTypes t  WITH(NOLOCK) WHERE t.IdMovementType=0 AND t.IdTipoMovimiento=500)
	INSERT INTO tBKGtipoMovimientoMovementTypes(IdMovementType,IdTipoMovimiento) VALUES(2,500)
GO

IF NOT EXISTS(SELECT 1 FROM tBKGtipoMovimientoMovementTypes t  WITH(NOLOCK) WHERE t.IdMovementType=0 AND t.IdTipoMovimiento=501)
	INSERT INTO tBKGtipoMovimientoMovementTypes(IdMovementType,IdTipoMovimiento) VALUES(3,501)
GO

SELECT * from tBKGtipoMovimientoMovementTypes	
GO
