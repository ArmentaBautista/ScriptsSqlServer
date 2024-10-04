
/* INFO (?_?) 
	JCA 20230727 Actualiza las Etapas de Crédito estableciendo su órden
*/

UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=3
	WHERE IdTipoD=2756;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=4
	WHERE IdTipoD=1547;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=11
	WHERE IdTipoD=2241;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=9
	WHERE IdTipoD=2592;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=7
	WHERE IdTipoD=2591;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=10
	WHERE IdTipoD=2240;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=8
	WHERE IdTipoD=2683;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=5
	WHERE IdTipoD=2239;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=1
	WHERE IdTipoD=1546;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=6
	WHERE IdTipoD=1548;
UPDATE intelixDEV.dbo.tCTLtiposD
	SET Orden=2
	WHERE IdTipoD=2236;

GO