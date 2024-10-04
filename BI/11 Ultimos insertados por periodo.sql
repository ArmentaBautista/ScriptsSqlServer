
USE iERP_BI
go

DECLARE @NumeroEmpresa AS TINYINT = 6

DECLARE @mes AS INT=DATEPART(MM,GETDATE()-30)
DECLARE @año AS INT=0

IF @mes=12
BEGIN	
	SET @año=DATEPART(YYYY,GETDATE()-365)
END
ELSE
BEGIN
	SET @año=DATEPART(YYYY,GETDATE())
END

SELECT * FROM dbo.tBSIempresas E  WITH(nolock) WHERE E.IdEmpresa=@NumeroEmpresa

DECLARE @periodo AS VARCHAR(6)=CONCAT(@año,FORMAT(@mes,'00'))       
DECLARE @IdPeriodo AS INT
SELECT TOP 1 @IdPeriodo = IdPeriodo FROM dbo.tSITcatalogoMinimoSaldos WHERE IdEmpresa=@NumeroEmpresa AND Periodo=@periodo 


SELECT @periodo AS 'Período de Inserción'

SELECT 'tSITcatalogoMinimo', t.IdPeriodo, COUNT(1) AS NumeroRegistros FROM dbo.tSITcatalogoMinimo t  WITH(nolock) 
WHERE t.IdEmpresa=@NumeroEmpresa AND t.IdPeriodo=@IdPeriodo GROUP BY t.IdPeriodo ORDER BY t.IdPeriodo DESC

SELECT 'tSITcatalogoMinimoSaldos', IdPeriodo, Periodo , COUNT(1) AS NumeroRegistros FROM dbo.tSITcatalogoMinimoSaldos 
WHERE IdEmpresa=@NumeroEmpresa AND Periodo=@periodo GROUP BY IdPeriodo, Periodo ORDER BY IdPeriodo DESC

SELECT 'tBSIsucursales', Periodo, COUNT(1) AS NumeroRegistros FROM dbo.tBSIsucursales 
WHERE IdEmpresa=@NumeroEmpresa AND Periodo=@periodo GROUP BY  Periodo ORDER BY Periodo DESC

--SELECT TOP 1 idperiodo FROM tBSIhistorialDeudoras  WITH(nolock) WHERE IdEmpresa=@NumeroEmpresa GROUP BY IdPeriodo ORDER BY IdPeriodo DESC



