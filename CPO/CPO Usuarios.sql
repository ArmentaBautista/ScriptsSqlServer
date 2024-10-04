

SELECT p.Nombre, u.Usuario
FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersonaFisica = u.IdPersonaFisica
WHERE u.IdUsuario IN (2008,3029,3109,4196,4338,4480,4255,4256,4360,4600,-1,4718,4409)