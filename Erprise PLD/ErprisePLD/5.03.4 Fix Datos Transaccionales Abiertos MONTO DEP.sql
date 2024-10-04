


SELECT 
	p.IdPersona, p.Nombre, p.Codigo AS NoSocio
	,montoD.IdListaD
	,montoD.Descripcion AS RangoMontoD
	,montoD.RangoFin/2 AS PromedioMontoD
	, se.MontoDepositos
--  UPDATE se SET se.MontoDepositos=CAST(montoD.RangoFin/2 AS NUMERIC(18,2)) 
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
		INNER JOIN dbo.tCATlistasD montoD WITH (NOLOCK) 
			ON montoD.IdListaD = se.IdListaDmontoDepositos
				AND montoD.IdListaD<>0
	WHERE se.MontoDepositos IS NULL	