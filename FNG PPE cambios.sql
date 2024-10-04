

DECLARE @nombreBuscado AS VARCHAR(64)='022-000354'

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
, pf.EsPersonaPoliticamenteEspuesta, pf.IdTipoDPPE, p.EsPersonaEnListaOFAC,
                                                    p.EsPersonaEnListaSAT,
                                                    p.EsPersonaEnListaBloqueada
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
	ON pf.IdPersona = p.IdPersona
WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'
	OR sc.codigo LIKE '%' + @nombreBuscado + '%'


SELECT * 
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
WHERE b.Tabla = 'tGRLpersonasFisicas'
	AND b.Campo = 'EsPersonaPoliticamenteEspuesta'
	AND b.IdRegistro='525434'
	
SELECT * 
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
WHERE b.Tabla = 'tGRLpersonasFisicas'
	AND b.IdRegistro='525434'	

SELECT u.Usuario, ss.* 
FROM dbo.tCTLsesiones ss  WITH(NOLOCK) 
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
	ON u.IdUsuario = ss.IdUsuario
WHERE ss.IdSesion=609507
		
		


