

SELECT 
	p.IdPersona
	, p.Nombre
	, p.Codigo AS NoSocio
	, montoD.Descripcion AS MontoDepositosAnt
	, se.MontoDepositos
	, montoR.Descripcion AS MontoRetirosAnt
	, se.MontoRetiros
	, numD.Descripcion AS NumeroDepositosAnt
	, se.NumeroDepositos
	, numR.Descripcion AS NumeroRetirosAnt
	, se.NumeroRetiros
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
		LEFT JOIN dbo.tCATlistasD montoD WITH (NOLOCK) 
			ON montoD.IdListaD = se.IdListaDmontoDepositos
				and montoD.IdListaD<>0
		LEFT JOIN dbo.tCATlistasD montoR WITH (NOLOCK) 
			ON montoR.IdListaD = se.IdListaDmontoRetiros
				and montoR.IdListaD<>0
		LEFT JOIN dbo.tCATlistasD numD WITH (NOLOCK) 
			ON numD.IdListaD = se.IdListaDnumeroDepositos
				AND numD.IdListaD<>0
		LEFT JOIN dbo.tCATlistasD numR WITH (NOLOCK) 
			ON numR.IdListaD = se.IdListaDnumeroRetiros
				AND numR.IdListaD<>0