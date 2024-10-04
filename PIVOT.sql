


    SELECT --s.IdRel,
	ld.IdListaD
    FROM dbo.tSCSserviciosFinancierosMediosAsignados s
    INNER JOIN dbo.tCATlistasD ld WITH(NOLOCK) ON ld.IdListaD = s.IdListaD
    WHERE s.IdEstatus = 1
	GROUP BY ld.IdListaD
	ORDER BY ld.IdListaD

SELECT *
FROM (
	SELECT s.IdRel,s.IdTipoD, ld.IdListaD  
	FROM tSCSserviciosFinancierosMediosAsignados s  WITH(NOLOCK) 
	INNER JOIN dbo.tCATlistasD ld WITH(NOLOCK) ON ld.IdListaD = s.IdListaD
) AS SourceTable
PIVOT
(
  COUNT(IdTipoD)  -- Función de agregación
  FOR IdListaD -- Columna que deseas pivotar
  IN ([-1412],[-1411],[-1410],[-1409],[-1408],[-1407],[-1406],[-1405],[-1402],[-1401],[-1400],[-1399]
,[-1398],[-40],[-39],[-38],[-37],[-36],[499],[539],[540]) 
) AS PivotTable;


