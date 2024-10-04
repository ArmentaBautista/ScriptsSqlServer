
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCdesagregadoOperacionesCaptacionMetodoPagoCPO')
BEGIN
	DROP PROC pAYCdesagregadoOperacionesCaptacionMetodoPagoCPO
	SELECT 'pAYCdesagregadoOperacionesCaptacionMetodoPagoCPO BORRADO' AS info
END
GO

CREATE PROC dbo.pAYCdesagregadoOperacionesCaptacionMetodoPagoCPO
@FechaInicial as date,
@FechaFinal as DATE
WITH ENCRYPTION
AS
BEGIN

DECLARE @pDEBUG AS INT = 0

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.06:52 p. m. Nota: Cuentas y Socios   */
DECLARE @ctas TABLE(
	IdCuenta			INT,
	IdSocio				INT,
	IdPersona			INT,
	NoSocio				VARCHAR(24),
	Nombre				VARCHAR(128),
	NoCuenta			VARCHAR(24),
	Producto			VARCHAR(80),
	TipoProducto		VARCHAR(250)
)

DECLARE @ctasAgrupadas TABLE(
	IdCuenta			INT,
	IdSocio				INT,
	IdPersona			INT,
	NoSocio				VARCHAR(24),
	Nombre				VARCHAR(128),
	NoCuenta			VARCHAR(24),
	Producto			VARCHAR(80),
	TipoProducto		VARCHAR(250),
	
	INDEX IX_ctas_IdCuenta (IdCuenta)
)

/*  (◕ᴥ◕)    JCA.17/10/2023.06:32 p. m. Nota: Obtener financieras del periodo  */
DECLARE @tf TABLE(
	IdTransaccion				INT, 
	IdOperacion					INT, 
	IdCuenta					INT, 
	IdTipoSubOperacion			INT, 
	TipoSubOperacion			VARCHAR(30),
	MontoSubOperacion			NUMERIC(18,2),
	SaldoCapitalAnterior		NUMERIC(18,2),
	SaldoCapital				NUMERIC(18,2),
	CapitalPagado				NUMERIC(18,2),
	CapitalGenerado				NUMERIC(18,2),
	InteresRetirado				NUMERIC(18,2)
)

	-- TF DE INVERSION
		INSERT INTO @tf
		SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta, tf.IdTipoSubOperacion,tt.Descripcion, tf.MontoSubOperacion,tf.SaldoCapitalAnterior,tf.SaldoCapital,tf.CapitalPagado, tf.CapitalGenerado, tf.InteresRetirado		
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposOperacion tt  WITH(NOLOCK) 
			ON tt.IdTipoOperacion = tf.IdTipoSubOperacion
				AND tt.IdTipoOperacion IN (500,501) --NOT IN (4,503)
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
			ON c.IdCuenta = tf.IdCuenta
				AND c.IdTipoDProducto = 398
		INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
			ON op.IdOperacion = tf.IdOperacion
				AND op.IdTipoOperacion NOT IN (25,507,506,38,49)
		WHERE tf.IdEstatus=1
			AND tf.IdCuenta>0
				AND tf.IdOperacion>0
					AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal

		IF @pDEBUG=1 SELECT COUNT(1) AS tf FROM @tf

		INSERT INTO @tf
		SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta, tf.IdTipoSubOperacion,tt.Descripcion, tf.MontoSubOperacion,tf.SaldoCapitalAnterior,tf.SaldoCapital,tf.CapitalPagado, tf.CapitalGenerado, tf.InteresRetirado		
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposOperacion tt  WITH(NOLOCK) 
			ON tt.IdTipoOperacion = tf.IdTipoSubOperacion
				AND tt.IdTipoOperacion IN (500,501) --NOT IN (4,503)
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
			ON c.IdCuenta = tf.IdCuenta
				AND c.IdTipoDProducto = 144
		INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
			ON op.IdOperacion = tf.IdOperacion
				AND op.IdTipoOperacion NOT IN (25,507,506,38,49)
		WHERE tf.IdEstatus=1
			AND tf.IdCuenta>0
				AND tf.IdOperacion>0
					AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal

		IF @pDEBUG=1 SELECT COUNT(1) AS tf FROM @tf

		INSERT INTO @ctas
		SELECT 
		c.IdCuenta, c.IdSocio, p.IdPersona, sc.Codigo, p.Nombre, c.Codigo, pf.Descripcion, tp.Descripcion
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
			ON c.IdTipoDProducto=tp.IdTipoD
				AND tp.IdTipoD IN (398,144)
		INNER JOIN @tf tf
			ON tf.IdCuenta = c.IdCuenta
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			ON pf.IdProductoFinanciero = c.IdProductoFinanciero

		IF @pDEBUG=1 SELECT COUNT(1) AS ctas FROM @ctas
		
		INSERT INTO @ctasAgrupadas
		SELECT 
		c.IdCuenta, c.IdSocio, c.IdPersona, c.NoSocio, c.Nombre, c.NoCuenta, c.Producto, c.TipoProducto
		FROM @ctas c
		GROUP BY c.IdCuenta,
				 c.IdSocio,
				 c.IdPersona,
				 c.NoSocio,
				 c.Nombre,
				 c.NoCuenta,
				 c.Producto,
				 c.TipoProducto

		IF @pDEBUG=1 SELECT COUNT(1) AS ctasAgrupadas FROM @ctasAgrupadas



/*  (◕ᴥ◕)    JCA.17/10/2023.05:15 p. m. Nota: Todas las operaciones del periodo requerido  */
DECLARE @operaciones TABLE(
	IdOperacion				INT,
	IdTipoOperacion			INT,
	CodigoOperacion			VARCHAR(10),
	TipoOperacion			VARCHAR(30),
	Folio					INT,
	Fecha					DATE,
	Total					NUMERIC(23,8),
	IdOperacionPadre		INT,
	Usuario					VARCHAR(40),
	IdSesion				INT,
	Alta					TIME,
	Sucursal				VARCHAR(80)
)

INSERT INTO @operaciones
(
    IdOperacion,
    IdTipoOperacion,
    TipoOperacion,
    Folio,
    Fecha,
    Total,
    IdOperacionPadre,
    Usuario,
    IdSesion,
	Alta,			
	Sucursal
)
SELECT operacion.IdOperacion, operacion.IdTipoOperacion, tipoo.Descripcion, operacion.Folio, operacion.Fecha, operacion.Total
, operacion.IdOperacionPadre, u.Usuario,operacion.IdSesion,operacion.Alta, suc.Descripcion
FROM dbo.tGRLoperaciones operacion  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tipoo  WITH(NOLOCK) 
	ON tipoo.IdTipoOperacion = operacion.IdTipoOperacion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
	ON u.IdUsuario = operacion.IdUsuarioAlta
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
	ON suc.IdSucursal = operacion.IdSucursal
INNER JOIN (
	SELECT tf.IdOperacion 
	FROM @tf tf 
	GROUP BY tf.IdOperacion) tf 
	ON tf.IdOperacion = operacion.IdOperacion
WHERE operacion.IdEstatus=1
	
IF @pDEBUG=1 SELECT COUNT(1) AS ops FROM @operaciones

/* INFO (⊙_☉) JCA.19/10/2023.07:24 a. m. 
Nota: Cargamos EstatusActual por tipo de dominio en memoria
*/
DECLARE @ea TABLE(
	IdEstatusActual		INT,
	Alta	DATE,

	INDEX IX_IdEstatusActual(IdEstatusActual)
)

INSERT INTO @ea
SELECT ea.IdEstatusActual, s.FechaTrabajo
FROM dbo.tCTLestatusActual ea  WITH(NOLOCK) 
INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK) 
	ON s.IdSesion = ea.IdSesion
		AND s.FechaTrabajo BETWEEN @FechaInicial AND @FechaFinal
WHERE ea.IdTipoDDominio=1409
	AND ea.IdEstatus=1

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.05:22 p. m. Nota: TD del rango de fechas   */
DECLARE @tranD TABLE(
	IdTransaccionD		INT,
	IdOperacion			INT,
	Monto				NUMERIC(23,8),
	IdMetodoPago		INT,
	MetodoPago			VARCHAR(30),
	EsCambio			BIT,
	IdTipoSubOperacion	INT,
	Naturaleza			INT,

	INDEX IX_IdOperacion (IdOperacion)
)

	INSERT INTO @tranD
	SELECT 
	td.IdTransaccionD, td.IdOperacion, td.Monto, td.IdMetodoPago, mp.Descripcion, td.EsCambio, td.IdTipoSubOperacion, t.Naturaleza
	FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLtiposOperacion t  WITH(NOLOCK) 
		ON t.IdTipoOperacion = td.IdTipoSubOperacion
	INNER JOIN @ea ea
		ON ea.IdEstatusActual = td.IdEstatusActual
			AND ea.Alta BETWEEN @fechaInicial AND @fechaFinal
	INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
		ON mp.IdMetodoPago = td.IdMetodoPago
	
IF @pDEBUG=1 SELECT COUNT(1) AS td FROM @tranD

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.06:18 p. m. Nota: Neteo de las TD   */
DECLARE @dg TABLE(
	IdOperacion			INT,
	MetodoPago			VARCHAR(30),
	Monto				NUMERIC(23,8),

	INDEX IX_IdOperacion (IdOperacion)
)

INSERT INTO @dg
SELECT 
	 IdOperacion
	,MetodoPago
	,SUM(Monto * Naturaleza) AS Monto
FROM @tranD
GROUP BY IdOperacion, MetodoPago

IF @pDEBUG=1 SELECT COUNT(1) AS dg FROM @dg

IF @pDEBUG=1 RETURN 0

IF @pDEBUG=2
BEGIN
	SELECT * FROM @tf
	RETURN 0
END

/*  (◕ᴥ◕)    JCA.17/10/2023.07:28 p. m. Nota: Consulta  */
SELECT 
oa.TipoOperacion
,oa.Folio
,oa.Sucursal
,oa.Fecha
,oa.alta as Hora
,c.NoSocio
,c.Nombre
,c.NoCuenta
,c.Producto
,c.TipoProducto
,[TipoMovimiento]		= tf.TipoSubOperacion
,[MetodoPago]			= IIF(dg.MetodoPago IS NULL,'Traspaso',dg.MetodoPago)
,[SaldoCapitalAnterior]	= isnull(tf.SaldoCapitalAnterior,0)
,[Monto]				= ISNULL(tf.MontoSubOperacion,IIF(tf.IdTipoSubOperacion=500,tf.CapitalGenerado,tf.CapitalPagado+tf.InteresRetirado))
,tf.SaldoCapital
,oa.Usuario
FROM @operaciones oa
INNER JOIN @tf tf
	ON tf.IdOperacion = oa.IdOperacion
INNER JOIN @ctasAgrupadas c
	ON c.IdCuenta = tf.IdCuenta
LEFT JOIN @dg dg 
	ON dg.IdOperacion = oa.IdOperacion
--ORDER BY oa.Fecha asc


END
GO

