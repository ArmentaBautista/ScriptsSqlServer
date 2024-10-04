
	SELECT 
	p.IdPersona, p.Nombre, p.Codigo AS NoSocio
	,numD.Descripcion
	,ROUND(numD.RangoFin/2,0) AS PromedioNumD
	,se.NumeroDepositos
--	UPDATE se SET se.NumeroDepositos=CAST(ROUND(numD.RangoFin/2,0) AS INTEGER)
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
		INNER JOIN dbo.tCATlistasD numD WITH (NOLOCK) 
			ON numD.IdListaD = se.IdListaDnumeroDepositos
				and numD.IdListaD<>0
		WHERE se.NumeroRetiros IS NULL

		