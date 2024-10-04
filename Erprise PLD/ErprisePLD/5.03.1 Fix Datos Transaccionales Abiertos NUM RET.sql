USE iERP_CYL
go

SELECT 
	p.IdPersona, p.Nombre, p.Codigo AS NoSocio
	,numR.IdListaD
	,numR.Descripcion AS RangoNumeroR
	,numR.RangoFin AS LimiteSuperiorNumeroR
	,ROUND(numR.RangoFin/2,0) AS PromedioNumR
	, se.NumeroRetiros
--  UPDATE se SET se.NumeroRetiros=CAST(numR.RangoFin/2 AS NUMERIC(18,2)) 
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
		INNER JOIN dbo.tCATlistasD numR WITH (NOLOCK) 
			ON numR.IdListaD = se.IdListaDnumeroRetiros
				AND numR.IdListaD<>0
	--WHERE se.NumeroRetiros IS NULL	