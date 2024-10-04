
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



SELECT * 
FROM 






