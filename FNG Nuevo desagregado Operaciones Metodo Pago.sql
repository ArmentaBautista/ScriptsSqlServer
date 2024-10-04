
DECLARE @pDEBUG AS INT = 0
DECLARE @IdOperacion AS INT= 0
DECLARE @fechaInicial AS DATE='20230901'
DECLARE @fechaFinal AS DATE='20230915'

/*  (◕ᴥ◕)    JCA.17/10/2023.06:32 p. m. Nota: Obtener financieras del periodo  */
DECLARE @tf TABLE(
	IdTransaccion			INT, 
	IdOperacion				INT, 
	IdCuenta				INT, 
	IdTipoSubOperacion		INT, 
	TipoSubOperacion		VARCHAR(30),
	MontoSubOperacion		NUMERIC(18,2),

	INDEX IX_IdTransaccion (IdTransaccion),
	INDEX IX_IdOperacion (IdOperacion),
	INDEX IX_IdCuenta (IdCuenta)
)

INSERT INTO @tf
SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta, tf.IdTipoSubOperacion,tt.Descripcion, tf.MontoSubOperacion
FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tt  WITH(NOLOCK) 
	ON tt.IdTipoOperacion = tf.IdTipoSubOperacion
		AND tt.IdTipoOperacion NOT IN (4,503)
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
	ON op.IdOperacion = tf.IdOperacion
		AND op.IdTipoOperacion NOT IN (25,507,506,38,49)
WHERE tf.IdEstatus=1
AND tf.IdCuenta<>0
AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal
	AND (tf.IdOperacion=@IdOperacion OR @IdOperacion=0)

IF @pDEBUG=1 SELECT * FROM @tf

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.06:52 p. m. Nota: Cuentas y Socios   */
DECLARE @ctas TABLE(
	IdCuenta			INT,
	IdSocio				INT,
	IdPersona			INT,
	NoSocio				VARCHAR(24),
	Nombre				VARCHAR(128),
	NoCuenta			VARCHAR(24),
	Producto			VARCHAR(80)
	--,IdTransaccion		INT
)

INSERT INTO @ctas
SELECT 
c.IdCuenta, c.IdSocio, p.IdPersona, sc.Codigo, p.Nombre, c.Codigo, pf.Descripcion--,tf.IdTransaccion
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN @tf tf
	ON tf.IdCuenta = c.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
GROUP BY c.IdCuenta,
         c.IdSocio,
         p.IdPersona,
         sc.Codigo,
         p.Nombre,
         c.Codigo,
         pf.Descripcion 

IF @pDEBUG=1 SELECT * FROM @ctas --ORDER BY IdTransaccion

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

	INDEX IX_IdOperacion (IdOperacion)
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
    IdSesion
)
SELECT operacion.IdOperacion, operacion.IdTipoOperacion, tipoo.Descripcion, operacion.Folio, operacion.Fecha, operacion.Total, operacion.IdOperacionPadre, u.Usuario,operacion.IdSesion
FROM dbo.tGRLoperaciones operacion  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tipoo  WITH(NOLOCK) 
	ON tipoo.IdTipoOperacion = operacion.IdTipoOperacion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
	ON u.IdUsuario = operacion.IdUsuarioAlta
INNER JOIN (
	SELECT tf.IdOperacion FROM @tf tf 
	GROUP BY tf.IdOperacion) tf 
	ON tf.IdOperacion = operacion.IdOperacion
WHERE operacion.IdEstatus=1
		AND (operacion.IdOperacion=@IdOperacion OR @IdOperacion=0)
	
IF @pDEBUG=1 SELECT * FROM @operaciones

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.05:16 p. m. Nota: Operaciones que no tienen hijas   */
DECLARE @opA TABLE(
	IdOperacion				INT,
	IdTipoOperacion			INT,
	TipoOperacion			VARCHAR(30),
	Folio					INT,
	Fecha					DATE,
	Total					NUMERIC(23,8),
	IdOperacionPadre		INT,
	Usuario					VARCHAR(40),
	IdSesion				INT,

	INDEX IX_IdOperacion (IdOperacion)
)

INSERT INTO @opA
SELECT o.IdOperacion, o.IdTipoOperacion,o.TipoOperacion, o.Folio, o.Fecha, o.Total, o.IdOperacionPadre, o.Usuario,o.IdSesion
FROM @operaciones o 
--WHERE o.IdOperacion=o.IdOperacionPadre



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
FROM dbo.tSDOtransacciones trn  WITH(NOLOCK) 
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
	ON td.RelTransaccion = trn.IdTransaccion
INNER JOIN dbo.tCTLtiposOperacion t  WITH(NOLOCK) 
	ON t.IdTipoOperacion = td.IdTipoSubOperacion
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = td.IdEstatusActual
		AND ea.IdEstatus=1
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
	ON mp.IdMetodoPago = td.IdMetodoPago
WHERE trn.IdEstatus=1
AND trn.Fecha BETWEEN @fechaInicial AND @fechaFinal
AND (td.IdOperacion=@IdOperacion OR @IdOperacion=0)

IF @pDEBUG=1 SELECT * FROM @tranD

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


IF @pDEBUG=1 SELECT * FROM @dg ORDER BY IdOperacion

--IF @pDEBUG=1 GOTO salida

/*  (◕ᴥ◕)    JCA.17/10/2023.07:28 p. m. Nota: Consulta  */

SELECT 
oa.Fecha

,oa.TipoOperacion
,oa.Folio
,oa.Total
,[MetodoPago]			= IIF(dg.MetodoPago IS NULL,'Traspaso',dg.MetodoPago)
,tf.TipoSubOperacion
,tf.MontoSubOperacion
,c.NoSocio
,c.Nombre
,c.NoCuenta
,c.Producto
,oa.IdTipoOperacion
,oa.IdOperacion
,oa.IdOperacionPadre
FROM @opA oa
INNER JOIN @tf tf
	ON tf.IdOperacion = oa.IdOperacion
INNER JOIN @ctas c
	ON c.IdCuenta = tf.IdCuenta
LEFT JOIN @dg dg 
	ON dg.IdOperacion = oa.IdOperacion
WHERE (oa.IdOperacion=@IdOperacion OR @IdOperacion=0)
ORDER BY oa.IdOperacion

/*
SELECT 
tf.IdOperacion, tf.IdTipoSubOperacion, tf.MontoSubOperacion, c.NoSocio, c.Nombre, c.NoCuenta, c.Producto
FROM @tf tf
INNER JOIN @ctas c ON c.IdCuenta = tf.IdCuenta
*/

salida:






