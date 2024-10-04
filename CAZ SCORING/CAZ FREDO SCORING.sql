
DECLARE @fechaConsulta AS DATE=GETDATE()
DECLARE @fechaInicio AS DATE=DATEADD(MONTH,-36,@fechaConsulta)

DECLARE @parcialidades TABLE(
	IdParcialidad			INT,
	IdCuenta				INT,
	NumeroParcialidad		INT, 
	Vencimiento				DATE, 
	PagadoCapital			DATE, 
	EstaPagada				BIT
)

INSERT INTO @parcialidades
SELECT p.IdParcialidad,p.IdCuenta, p.NumeroParcialidad, p.Vencimiento, p.PagadoCapital, p.EstaPagada
FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
WHERE p.IdEstatus=1

DECLARE @p1 TABLE(
	IdParcialidad			INT,
	IdCuenta				INT,
	NumeroParcialidad		INT, 
	Vencimiento				DATE, 
	PagadoCapital			DATE, 
	EstaPagada				BIT	,
	DiasMora				INT,
	Filtro					VARCHAR(30)
)

INSERT INTO @p1
SELECT p.IdParcialidad,p.IdCuenta, p.NumeroParcialidad, p.Vencimiento, p.PagadoCapital, p.EstaPagada
, DATEDIFF(DAY,p.Vencimiento,p.PagadoCapital)
,'por rango fecha'
FROM @parcialidades p  
WHERE p.PagadoCapital BETWEEN @fechaInicio AND @fechaConsulta

INSERT INTO @p1
SELECT p.IdParcialidad,p.IdCuenta, p.NumeroParcialidad, p.Vencimiento, @fechaConsulta, p.EstaPagada
, DATEDIFF(DAY,p.Vencimiento,@fechaConsulta)
,'no pagadas x vencimiento'
FROM @parcialidades p  
INNER JOIN  dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = p.IdCuenta
		AND c.IdEstatus IN (1, 53, 73)
WHERE p.EstaPagada=0
AND p.Vencimiento BETWEEN @fechaInicio and @fechaConsulta

SELECT 
[NoSocio]			= sc.Codigo ,
per.Nombre,
[NoCuenta]			= c.Codigo,
[Producto]			= c.Descripcion,
c.FechaActivacion,
[Estatus]			= e.Descripcion,
--p.NumeroParcialidad,
--p.Vencimiento,
--p.PagadoCapital,
--p.EstaPagada,
[MoraMaxima]		= MAX(p.DiasMora)
--MAX(p.DiasMora) OVER(PARTITION BY c.IdCuenta) AS MoraMaxima 
FROM @p1 p  
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta=p.IdCuenta
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
	ON e.IdEstatus = c.IdEstatus
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) 
	ON per.IdPersona = sc.IdPersona
GROUP BY sc.Codigo,per.Nombre,c.Codigo,c.Descripcion,c.FechaActivacion,e.Descripcion


