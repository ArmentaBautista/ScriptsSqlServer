
DECLARE @fechaConsulta AS DATE=GETDATE()
DECLARE @fechaInicio AS DATE=DATEADD(MONTH,-36,@fechaConsulta)

DECLARE @ctas AS TABLE(
	IdCuenta		INT,
	NoCuenta		VARCHAR(30),
	Producto		VARCHAR(80),
	IdSocio			INT,
	IdSucursal		INT,
	IdEstatus		INT,
	FechaActivacion	DATE,
	FechaBaja		DATE
)

/* @^•ﻌ•^@   JCA.27/11/2023.11:55 p. m. Nota: Carga de todas las cuentas de la bd   */
INSERT INTO @ctas
SELECT 
c.IdCuenta,
c.Codigo,
c.Descripcion,
c.IdSocio,
c.IdSucursal,
c.IdEstatus,
c.FechaActivacion,
ce.FechaBaja
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) 
	ON ce.IdCuenta = c.IdCuenta

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
,'Fecha Pagado Capital'
FROM @parcialidades p  
WHERE p.PagadoCapital BETWEEN @fechaInicio AND @fechaConsulta

INSERT INTO @p1
SELECT p.IdParcialidad,p.IdCuenta, p.NumeroParcialidad, p.Vencimiento, @fechaConsulta, p.EstaPagada
, DATEDIFF(DAY,p.Vencimiento,@fechaConsulta)
,'Vencimiento Parcialidad '
FROM @parcialidades p  
INNER JOIN  @ctas c 
	ON c.IdCuenta = p.IdCuenta
		AND c.IdEstatus IN (1, 53, 73)
WHERE p.EstaPagada=0
AND p.Vencimiento BETWEEN @fechaInicio and @fechaConsulta

/* ฅ^•ﻌ•^ฅ   JCA.28/11/2023.12:10 a. m. Nota: Cuentas Resultados   */
DECLARE @result AS TABLE(
	Filtro			VARCHAR(50),
	IdCuenta		INT ,
	NoCuenta		VARCHAR(30),
	Producto		VARCHAR(80),
	IdSocio			INT,
	IdSucursal		INT,
	IdEstatus		INT,
	FechaActivacion	DATE,
	FechaBaja		DATE,
	MoraMaxima		SMALLINT
)


/* ฅ^•ﻌ•^ฅ   JCA.28/11/2023.12:31 a. m. Nota: Cuentas basadas en parcialidades   */
INSERT INTO @result
SELECT 
p.Filtro,
c.IdCuenta,
c.NoCuenta,
c.Producto,
c.IdSocio,
c.IdSucursal,
c.IdEstatus,
c.FechaActivacion,
c.FechaBaja,
p.MoraMaxima
FROM @ctas c 
INNER JOIN (
			SELECT 
			p.IdCuenta,
			[MoraMaxima]		= MAX(p.DiasMora),
			p.Filtro
			FROM @p1 p 
			GROUP BY p.IdCuenta, p.Filtro
			) p ON p.IdCuenta = c.IdCuenta 

/* ฅ^•ﻌ•^ฅ   JCA.28/11/2023.12:50 a. m. Nota: Cuentas castigadas que se recuperaron en el periodo de consulta   */
INSERT INTO @result
SELECT 
'Castigadas recuperadas en el lapso de Consulta',
c.IdCuenta,
c.NoCuenta,
c.Producto,
c.IdSocio,
c.IdSucursal,
c.IdEstatus,
c.FechaActivacion,
c.FechaBaja,
COALESCE(cc.DiasMora,-1) 
FROM @ctas c 
INNER JOIN dbo.tAYCcastigosD cc  WITH(NOLOCK) 
	ON cc.IdCuenta = c.IdCuenta
WHERE c.FechaBaja BETWEEN @fechaInicio AND @fechaConsulta



/* INFO (⊙_☉) JCA.28/11/2023.12:50 a. m. 
Nota: Resultados Finales
*/


--SELECT
--r.Filtro,
--[NoSocio]			= sc.Codigo,
--per.Nombre,
--r.NoCuenta,
--r.Producto,
--r.FechaActivacion,
--r.FechaBaja,
--[Estatus]			= e.Descripcion,
--r.[MoraMaxima]	
--INTO ##tFEDOscore
--FROM @result r
--INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
--	ON e.IdEstatus = r.IdEstatus
--INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
--	ON sc.IdSocio = r.IdSocio
--INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) 
--	ON per.IdPersona = sc.IdPersona


SELECT 
c.IdCuenta,
c.NoCuenta,
c.Producto,
sc.Codigo,
per.Nombre,
c.FechaActivacion,
c.FechaBaja,
p.Vencimiento,
p.PagadoCapital
,p.EstaPagada
,p.DiasMora
FROM @p1 p 
INNER JOIN @ctas c 
	on c.IdCuenta = p.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) 
	ON per.IdPersona = sc.IdPersona
GROUP BY 
c.IdCuenta,
c.NoCuenta,
c.Producto,
sc.Codigo,
per.Nombre,
c.FechaActivacion,
c.FechaBaja,
p.Vencimiento,
p.PagadoCapital
,p.EstaPagada
,p.DiasMora