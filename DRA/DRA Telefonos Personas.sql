USE iERP_DRA
go

SELECT socio.Codigo AS NoSocio, persona.Nombre, Tel.TipoTelefono, Tel.Telefono
FROM dbo.tSCSsocios socio  WITH(NOLOCK)
INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
left JOIN (
			SELECT b.IdRel --, CONCAT( b.CodigoArea, Telefono) AS Telefono
			, b.Telefono, ld.Descripcion AS TipoTelefono
			 FROM tCATtelefonos b WITH (NOLOCK)
			 JOIN tCTLestatusActual c WITH (NOLOCK) ON c.IdEstatusActual = b.IdEstatusActual AND c.IdEstatus=1
			 INNER JOIN dbo.tCTLrelaciones rel WITH(NOLOCK) ON rel.IdRel = b.IdRel	
			 INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = b.IdListaD
			 WHERE b.IdListaD IN (-1339,-1338)
		   ) AS Tel ON tel.IdRel=persona.IdRelTelefonos 
WHERE socio.EsSocioValido=1
ORDER BY socio.IdSocio
		   
		   
		   
		   -- SELECT * FROM dbo.tCATlistasD ld  WITH(NOLOCK)
		   -- WHERE ld.IdTipoE = 8

