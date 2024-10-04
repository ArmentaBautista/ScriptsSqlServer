
SELECT 
	p.IdPersona, p.Nombre, p.Codigo AS NoSocio
	,montoR.Descripcion
	,	montoR.RangoFin/2 AS PromedioMontoR
	, se.MontoRetiros
	-- UPDATE se SET se.MontoRetiros=CAST(montoR.RangoFin/2 AS NUMERIC(18,2))
	FROM (
		SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre,p.IdSocioeconomico
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		) p 
		INNER JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) 
			ON se.IdSocioeconomico = p.IdSocioeconomico
		INNER JOIN dbo.tCTLestatusActual ea WITH (NOLOCK) 
			ON ea.IdEstatusActual = se.IdEstatusActual 
				AND ea.IdEstatus = 1
		INNER JOIN dbo.tCATlistasD montoR WITH (NOLOCK) 
			ON montoR.IdListaD = se.IdListaDmontoRetiros
				AND montoR.IdListaD<>0
		WHERE se.MontoRetiros IS NULL