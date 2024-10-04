

SELECT t.name AS tabla, c.name AS columna
FROM sys.columns c
INNER JOIN sys.tables t  WITH(NOLOCK) ON t.object_id = c.object_id 
WHERE c.name LIKE 'valor'

/*

tCATlistasD
tCTLtiposD
tCTLmunicipios
tCTLestados

tPLDpropiedadesDominioPonderables
tCTLvaloresCampos
*/

SELECT * FROM tPLDpropiedadesDominioPonderables

SELECT * FROM tCTLvaloresCampos

SELECT * FROM dbo.tCTLtiposD td  WITH(NOLOCK) 
WHERE td.IdTipoD = 208



