
DECLARE @fechaTrabajo AS DATE = '20220222'--CURRENT_TIMESTAMP;
DECLARE @fechaInicioMes AS DATE = DATEADD(dd,-(DAY(@fechaTrabajo)-1),@fechaTrabajo)
DECLARE @IdPeriodo AS INT
SELECT @IdPeriodo=IdPeriodo FROM dbo.tCTLperiodos p WHERE p.EsAjuste=0 AND  @fechaTrabajo BETWEEN p.Inicio AND p.Fin

DECLARE @persona AS VARCHAR(50)='ismael dur'
DECLARE @idSocio AS VARCHAR(50)= 0 -- 16888
DECLARE @idPersona AS INT = 0 
SET @idPersona = (SELECT sc.idpersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.idsocio=@idSocio)

SELECT  TOP 1 p.IdPersona, sc.IdSocio, sc.Codigo AS NoSocio, p.Nombre  FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona WHERE p.Nombre LIKE '%' + @persona + '%'

--SELECT  TOP 1 @idSocio=sc.IdSocio FROM dbo.tSCSsocios sc  WITH(NOLOCK) INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona WHERE p.Nombre LIKE '%' + @persona + '%'




/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE SOCIOS Y PERSONAS

SELECT sc.IdSocio,sc.IdPersona,sc.Edad,sc.IdPersonaFisica,sc.ExentaIVA,sc.IdPersonaMoral,sc.EsSocioValido,sc.Sexo,sc.IdEstadoNacimiento,sc.IdRelDomicilios,sc.IdSucursal,sc.IdListaDOcupacion,
IIF(sc.Edad<18,1,0) AS EsMenor, IIF(sc.Edad>=18 AND sc.IdPersonaFisica IS NOT NULL,1,0) AS EsMayor, IIF(sc.IdPersonaMoral IS NOT NULL,1,0) EsMoral
FROM (
		SELECT sc.IdSocio,	p.IdPersona,	
		IIF(pf.IdPersonaFisica IS NOT NULL
			, DATEDIFF(YEAR,pf.FechaNacimiento,'20230101')
			, IIF(pm.IdPersonaMoral IS NOT NULL,DATEDIFF(YEAR,pm.FechaConstitucion,'20230101'),0)
		) AS Edad,
		pf.IdPersonaFisica,	sc.ExentaIVA,	pm.IdPersonaMoral,	sc.EsSocioValido,	pf.Sexo,	pf.IdEstadoNacimiento,	p.IdRelDomicilios,	sc.IdSucursal,	pf.IdListaDOcupacion

		--EsMenor	
		--EsMayor	
		--EsMoral	
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
		LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
		WHERE sc.IdEstatus=1 
) sc





