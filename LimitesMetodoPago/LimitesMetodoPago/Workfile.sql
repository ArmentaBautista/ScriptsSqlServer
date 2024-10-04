

SELECT td.Descripcion, mp.* 
FROM dbo.tCATmetodosPago mp	  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) 
	ON td.IdTipoD = mp.IdTipoD


SELECT *
FROM dbo.tCTLrecursos r  WITH(NOLOCK) 
WHERE r.Descripcion LIKE '%ventanilla%'
OR r.Descripcion LIKE '%bancarios%'

SELECT * FROM dbo.tCTLtiposOperacion


SELECT dbo.fnCTLvalidarLimitesMetodoPago(-1,942,10,501,60000)

