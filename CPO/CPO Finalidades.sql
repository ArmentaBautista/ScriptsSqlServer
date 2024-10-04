
USE IERP_OBL
GO

SELECT fin.Codigo AS FinalidadCodigo, fin.Descripcion AS FinalidadDescripcion
, fin.AplicaConsumo, divcon.Codigo AS DivisionConsumoCodigo, divcon.Descripcion AS DivisionConsumoDescripcion
, fin.AplicaComercio, divcom.Codigo AS DivisionComercioCodigo, divcom.Descripcion AS DivisionComercioDescripcion
, fin.AplicaVivienda, divviv.Codigo AS DivisionViviendaCodigo, divviv.Descripcion AS DivisionViviendaDescripcion
FROM dbo.tAYCfinalidades fin  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = fin.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN dbo.tCNTdivisiones divcon  WITH(nolock) ON divcon.IdDivision = fin.IdDivisionConsumo
INNER JOIN dbo.tCNTdivisiones divcom  WITH(nolock) ON divcom.IdDivision = fin.IdDivisionComercio
INNER JOIN dbo.tCNTdivisiones divviv  WITH(nolock) ON divviv.IdDivision = fin.IdDivisionVivienda
