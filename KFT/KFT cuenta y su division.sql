

SELECT c.FechaAlta, c.Codigo, c.Descripcion, c.IdTipoDProducto, c.IdTipoDAIC, td1.Descripcion
, c.IdTipoDAICclasificacion, td2.Descripcion, c.IdDivision, d.Descripcion
, a.IdTipoDProducto, a.IdTipoDAIC, td3.Descripcion , a.IdDivision, d2.Descripcion
, c.IdTipoDTablaEstimacion, tt.Descripcion
FROM dbo.tAYCcuentas c  WITH(nolock) 
INNER JOIN dbo.tAYCaperturas a  WITH(nolock) ON a.IdApertura = c.IdApertura
INNER JOIN dbo.tCNTdivisiones d  WITH(nolock) ON d.IdDivision = c.IdDivision
INNER JOIN dbo.tCNTdivisiones d2  WITH(nolock) ON d2.IdDivision = a.IdDivision
INNER JOIN dbo.tCTLtiposD td1  WITH(nolock) ON td1.IdTipoD = c.IdTipoDAIC
INNER JOIN dbo.tCTLtiposD td2  WITH(nolock) ON td2.IdTipoD = c.IdTipoDAICclasificacion
INNER JOIN dbo.tCTLtiposD td3  WITH(nolock) ON td3.IdTipoD = a.IdTipoDAIC
INNER JOIN dbo.tCTLtiposD tt  WITH(nolock) ON tt.IdTipoD = c.IdTipoDTablaEstimacion
WHERE a.Folio=24
