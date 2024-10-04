


SELECT fin.IdFinalidad, fin.Codigo, fin.Descripcion AS Finalidad
,fin.AplicaConsumo, divcon.Descripcion AS DivisionConsumo
,fin.AplicaComercio, divcom.Descripcion AS DivisionComercio
,fin.AplicaVivienda, divviv.Descripcion AS DivisionVivienda
FROM taycfinalidades fin 
left JOIN dbo.tCNTdivisiones divcon  WITH(NOLOCK) ON divcon.IdDivision = fin.IdDivisionConsumo
left JOIN dbo.tCNTdivisiones divcom  WITH(NOLOCK) ON divcom.IdDivision = fin.IdDivisionComercio
left JOIN dbo.tCNTdivisiones divviv  WITH(NOLOCK) ON divviv.IdDivision = fin.IdDivisionVivienda
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = fin.IdEstatusActual AND ea.IdEstatus=1
--WHERE fin.Descripcion LIKE '%vehicu%'
ORDER BY fin.Descripcion
