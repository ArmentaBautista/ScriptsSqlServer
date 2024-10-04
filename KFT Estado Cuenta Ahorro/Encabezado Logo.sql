
/* ฅ^•ﻌ•^ฅ   JCA.18/09/2023.11:55 p. m. Nota: Encabezado
El subreporte no devuelve más que el logo, por lo demás no se usa*/

SELECT tCTLempresas.IdEmpresa,
       tel.Telefono,
       tel.Extension,
       tel.CodigoPais,
       tCATlistasD.Descripcion,
       tel.CodigoArea,
       tCTLempresas.Logotipo
FROM ( dbo.tCATtelefonos tel
		INNER JOIN (
					(
						dbo.tCTLempresas tCTLempresas
					INNER JOIN dbo.tGRLpersonas tGRLpersonas ON tCTLempresas.IdPersona = tGRLpersonas.IdPersona
						)
					INNER JOIN dbo.tCTLrelaciones tCTLrelaciones ON tGRLpersonas.IdRelTelefonos = tCTLrelaciones.IdRel
			) ON tel.IdRel = tCTLrelaciones.IdRel
	)
INNER JOIN dbo.tCATlistasD tCATlistasD
    ON tel.IdListaD = tCATlistasD.IdListaD
WHERE tCTLempresas.IdEmpresa = 1;

-- Sustituir por...
select Logotipo from tctlempresas  WITH(NOLOCK) where IdEmpresa=1

