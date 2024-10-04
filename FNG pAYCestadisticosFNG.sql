
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCestadisticosFNG')
BEGIN
	DROP PROC pAYCestadisticosFNG
	SELECT 'pAYCestadisticosFNG BORRADO' AS info
END
GO

CREATE PROC pAYCestadisticosFNG
@pFecha AS DATE
AS
BEGIN

DECLARE @fecha AS DATE=@pFecha

DECLARE @cap TABLE(
	--Id						INT IDENTITY,
	Flag					TINYINT,
	Tipo					VARCHAR(64),
	CodigoProducto			VARCHAR(30),
	Producto				VARCHAR(80),
	NoCuentas				INT,
	Capital					NUMERIC(15,2)
)

DECLARE @cred TABLE(
	--Id						INT IDENTITY,
	Flag					TINYINT,
	Tipo					VARCHAR(64),
	CodigoProducto			VARCHAR(30),
	Producto				VARCHAR(80),
	NoCuentas				INT,
	Capital					NUMERIC(15,2)
)

DECLARE @inv TABLE(
	--Id						INT IDENTITY,
	Flag					TINYINT,
	Tipo					VARCHAR(64),
	CodigoProducto			VARCHAR(30),
	Producto				VARCHAR(80),
	NoCuentas				INT,
	Capital					NUMERIC(15,2)
)

DECLARE @result TABLE(
	Flag					TINYINT,
	Tipo					VARCHAR(64),
	CodigoProducto			VARCHAR(30),
	Producto				VARCHAR(80),
	NoCuentas				INT,
	Capital					NUMERIC(15,2)
)

DECLARE @result2 TABLE(
	Flag					TINYINT,
	Tipo					VARCHAR(64),
	CodigoProducto			VARCHAR(30),
	Producto				VARCHAR(80),
	NoCuentas				INT,
	Capital					NUMERIC(15,2)
)

/* @^..^@   JCA.08/12/2023.11:58 a. m. Nota: CAPTACIÓN   */

INSERT INTO @cap (Flag,Tipo,CodigoProducto,Producto,NoCuentas,Capital)
SELECT 
1,
[Tipo]					= tp.Descripcion,
[CodigoProducto]		= pf.Codigo,
[Producto]				= pf.Descripcion,
[NoCuentas]				= COUNT(1),
[Capital]				= SUM(cap.Capital)
FROM tayccaptacion cap  WITH(NOLOCK) 
INNER JOIN tayccuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = cap.IdCuenta
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
	ON tp.IdTipoD = pf.IdTipoDDominioCatalogo
WHERE cap.Fecha=@fecha
GROUP BY 
	tp.Descripcion,
	pf.IdProductoFinanciero,
	pf.Codigo,
	pf.Descripcion

/* @^..^@   JCA.08/12/2023.11:58 a. m. Nota: CRÉDITO   */

INSERT INTO @cred (Flag,Tipo,CodigoProducto,Producto,NoCuentas,Capital)
SELECT 
2,
tp.Descripcion,
[CodigoProducto]	= pf.Codigo,
[Producto]			= pf.Descripcion,
[NoCuentas]			= COUNT(1),
[Capital]			= SUM(car.CapitalAtrasado)
FROM dbo.tAYCcartera car  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = car.IdCuenta
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
	ON tp.IdTipoD = pf.IdTipoDDominioCatalogo
WHERE car.FechaCartera=@fecha
GROUP BY tp.Descripcion,
		pf.IdProductoFinanciero,
		pf.Codigo,
		pf.Descripcion

/* @^..^@   JCA.08/12/2023.11:58 a. m. Nota: INVERSIONES POR RANGOS   */

INSERT INTO @inv (Flag,Tipo,CodigoProducto,Producto,NoCuentas,Capital)
SELECT 
3,
FORMAT(pt.MontoInicial,'000000'),
[CodigoProducto]		= CONCAT_WS('-',pf.Codigo,FORMAT(c.Dias,'000')),
[Producto]				= CONCAT_WS('-',FORMAT(pt.MontoInicial,'C','es-MX'),FORMAT(pt.MontoFinal,'C','es-MX')), 
[NoCuentas]				= COUNT(1),
[Capital]				= SUM(cap.Capital)
FROM tayccaptacion cap  WITH(NOLOCK) 
INNER JOIN tayccuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = cap.IdCuenta
		and c.IdTipoDProducto=398
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLproductosFinancierosTasas pt  WITH(NOLOCK) 
	ON pt.id=c.IdTasa
WHERE cap.Fecha=@fecha
GROUP BY 
	FORMAT(pt.MontoInicial,'000000'),
	CONCAT_WS('-',pf.Codigo,FORMAT(c.Dias,'000')),
	CONCAT_WS('-',FORMAT(pt.MontoInicial,'C','es-MX'),FORMAT(pt.MontoFinal,'C','es-MX'))
ORDER BY 
FORMAT(pt.MontoInicial,'000000'),
CONCAT_WS('-',pf.Codigo,FORMAT(c.Dias,'000'))

/* @^..^@   JCA.08/12/2023.11:59 a. m. Nota: CONSULTA GENERAL   */	

	INSERT INTO @result (Flag,Tipo,Producto,NoCuentas,Capital)
	SELECT 
		c.Flag,
		c.Tipo,
		c.Producto,
		SUM(c.NoCuentas) AS NoCuentas,
		SUM(c.Capital)
	FROM @cap c
	GROUP BY
	ROLLUP(
		   c.Flag,
		   c.Tipo,
		   c.Producto
		   )

	INSERT INTO @result (Flag,Tipo,Producto,NoCuentas,Capital)
	SELECT 
	c.Flag,
	c.Tipo,
	c.Producto,
	SUM(c.NoCuentas) AS NoCuentas,
	SUM(c.Capital)
	FROM @cred c
	GROUP BY
	ROLLUP(
		   c.Flag,
		   c.Tipo,
		   c.Producto
		   )

	INSERT INTO @result (Flag,Tipo,CodigoProducto,Producto,NoCuentas,Capital)
	SELECT 
		c.Flag,
		c.Tipo,
		c.CodigoProducto,
		c.Producto,
		SUM(c.NoCuentas),
		SUM(c.Capital)
	FROM @inv c
	GROUP BY
		c.Flag,
		c.Tipo,
		c.CodigoProducto,
		c.Producto
	ORDER BY
		c.Tipo,
		c.CodigoProducto,
		c.Producto
	
SELECT 
r.Flag,
r.Tipo,
r.CodigoProducto,
r.Producto,
r.NoCuentas,
FORMAT(r.Capital,'C','es-MX') AS Capital
FROM @result r

	
END
GO