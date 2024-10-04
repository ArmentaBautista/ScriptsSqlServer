

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCdesagregadoAplicacionOperacionesProductosFinancieros')
BEGIN
	DROP PROC pAYCdesagregadoAplicacionOperacionesProductosFinancieros
	SELECT 'pAYCdesagregadoAplicacionOperacionesProductosFinancieros BORRADO' AS info
END
GO

CREATE PROC pAYCdesagregadoAplicacionOperacionesProductosFinancieros
@FechaInicial AS DATE,
@FechaFinal AS DATE,
@NoSocio AS VARCHAR(20)=''
AS
BEGIN

DECLARE @pDEBUG AS INT = 0
DECLARE @IdOperacion AS INT= 0
DECLARE @IdSocio AS INT=0

/* ฅ^•ﻌ•^ฅ   JCA.17/10/2023.06:52 p. m. Nota: Cuentas y Socios   */
DECLARE @ctas TABLE(
	IdCuenta			INT,
	IdSocio				INT,
	IdPersona			INT,
	NoSocio				VARCHAR(24),
	Nombre				VARCHAR(128),
	NoCuenta			VARCHAR(24),
	Producto			VARCHAR(80),
	RFC					VARCHAR(30),
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
	PagadoCapital				NUMERIC(18,2),
	PagadoIO					NUMERIC(18,2),
	PagadoIM					NUMERIC(18,2),
	PagadoIVA					NUMERIC(18,2),

	INDEX IX_IdTransaccion (IdTransaccion),
	INDEX IX_IdOperacion (IdOperacion),
	INDEX IX_IdCuenta (IdCuenta)
)

/* INFO (⊙_☉) JCA.26/10/2023.07:08 p. m. 
Nota: Validar si se proporciona NoSocio para que en ese caso primero se obtengan las cuentas de este, en caso contrario lo primero será obtener las TF del periodo
*/
IF @NoSocio<>''
BEGIN
	SELECT @IdSocio=sc.IdSocio FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.Codigo=@NoSocio	
END

IF @IdSocio<>0
BEGIN
	
		INSERT INTO @ctas
		SELECT 
		c.IdCuenta, c.IdSocio, p.IdPersona, sc.Codigo, p.Nombre, c.Codigo, pf.Descripcion,p.RFC, tp.Descripcion
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
			ON c.IdTipoDProducto=tp.IdTipoD
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
				AND sc.IdSocio=@IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		
		INSERT INTO @tf
		SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta, tf.IdTipoSubOperacion,tt.Descripcion, tf.MontoSubOperacion,tf.SaldoCapitalAnterior,tf.SaldoCapital
		, tf.CapitalPagado + tf.CapitalPagadoVencido
		, tf.InteresOrdinarioPagado + tf.InteresOrdinarioPagadoVencido
		, tf.InteresMoratorioPagado + tf.InteresMoratorioPagadoVencido
		, tf.IVAinteresOrdinarioPagado + tf.IVAinteresMoratorioPagado
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN @ctas cta
			ON cta.IdCuenta = tf.IdCuenta
		INNER JOIN dbo.tCTLtiposOperacion tt  WITH(NOLOCK) 
			ON tt.IdTipoOperacion = tf.IdTipoSubOperacion
				AND tt.IdTipoOperacion IN (500,501) --NOT IN (4,503)
		INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
			ON op.IdOperacion = tf.IdOperacion
				AND op.IdTipoOperacion NOT IN (25,507,506,38,49)
		WHERE tf.IdEstatus=1
			AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal

END
ELSE
BEGIN
	
		INSERT INTO @tf
		SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta, tf.IdTipoSubOperacion,tt.Descripcion, tf.MontoSubOperacion,tf.SaldoCapitalAnterior,tf.SaldoCapital
		, tf.CapitalPagado + tf.CapitalPagadoVencido
		, tf.InteresOrdinarioPagado + tf.InteresOrdinarioPagadoVencido
		, tf.InteresMoratorioPagado + tf.InteresMoratorioPagadoVencido
		, tf.IVAinteresOrdinarioPagado + tf.IVAinteresMoratorioPagado
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposOperacion tt  WITH(NOLOCK) 
			ON tt.IdTipoOperacion = tf.IdTipoSubOperacion
				AND tt.IdTipoOperacion IN (500,501) --NOT IN (4,503)
		INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
			ON op.IdOperacion = tf.IdOperacion
				AND op.IdTipoOperacion NOT IN (25,507,506,38,49)
		WHERE tf.IdEstatus=1
		AND tf.IdCuenta>0
		AND tf.IdOperacion>0
		AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal

		INSERT INTO @ctas
		SELECT 
		c.IdCuenta, c.IdSocio, p.IdPersona, sc.Codigo, p.Nombre, c.Codigo, pf.Descripcion,p.RFC, tp.Descripcion
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
			ON c.IdTipoDProducto=tp.IdTipoD
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
				 pf.Descripcion,
				 p.RFC, 
				 tp.Descripcion 

END

IF @pDEBUG=1 SELECT * FROM @tf

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
	Alta					TIME,
	Sucursal				VARCHAR(80),
	CodigoSucursal			VARCHAR(12)


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
    IdSesion,
	Alta,			
	Sucursal,		
	CodigoSucursal
)
SELECT operacion.IdOperacion, operacion.IdTipoOperacion, tipoo.Descripcion, operacion.Folio, operacion.Fecha, operacion.Total, operacion.IdOperacionPadre, u.Usuario,operacion.IdSesion
,operacion.Alta, suc.Descripcion, suc.Codigo
FROM dbo.tGRLoperaciones operacion  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tipoo  WITH(NOLOCK) 
	ON tipoo.IdTipoOperacion = operacion.IdTipoOperacion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
	ON u.IdUsuario = operacion.IdUsuarioAlta
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
	ON suc.IdSucursal = operacion.IdSucursal
INNER JOIN (
	SELECT tf.IdOperacion FROM @tf tf 
	GROUP BY tf.IdOperacion) tf 
	ON tf.IdOperacion = operacion.IdOperacion
WHERE operacion.IdEstatus=1
	
IF @pDEBUG=1 SELECT * FROM @operaciones

/* INFO (⊙_☉) JCA.19/10/2023.07:24 a. m. 
Nota: Cargamos EstatusActual por tipo de dominio en memoria
*/
DECLARE @ea TABLE(
	IdEstatusActual		INT,

	INDEX IX_IdEstatusActual(IdEstatusActual)
)

INSERT INTO @ea
SELECT ea.IdEstatusActual
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
FROM dbo.tSDOtransacciones trn  WITH(NOLOCK) 
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
	ON td.RelTransaccion = trn.IdTransaccion
INNER JOIN dbo.tCTLtiposOperacion t  WITH(NOLOCK) 
	ON t.IdTipoOperacion = td.IdTipoSubOperacion
INNER JOIN @ea ea
	ON ea.IdEstatusActual = td.IdEstatusActual		
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
	ON mp.IdMetodoPago = td.IdMetodoPago
WHERE trn.IdEstatus=1
AND trn.Fecha BETWEEN @fechaInicial AND @fechaFinal
--	AND (td.IdOperacion=@IdOperacion OR @IdOperacion=0)

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
,oa.alta
,oa.CodigoSucursal
,oa.Sucursal
,oa.TipoOperacion
,oa.Folio
,[TipoMovimiento]		= tf.TipoSubOperacion
,[MetodoPago]			= IIF(dg.MetodoPago IS NULL,'Traspaso',dg.MetodoPago)
,[PagadoCapital]		= isnull(tf.PagadoCapital,0)
,[PagadoIO]				= isnull(tf.PagadoIO,0)
,[PagadoIM]				= isnull(tf.PagadoIM,0)
,[PagadoIVA]			= isnull(tf.PagadoIVA,0)
,[SaldoCapitalAnterior]	= isnull(tf.SaldoCapitalAnterior,0)
,oa.Total
,tf.MontoSubOperacion
,tf.SaldoCapital
,c.NoSocio
,c.Nombre
,c.RFC
,c.NoCuenta
,c.Producto
,c.TipoProducto
,oa.Usuario
FROM @operaciones oa
INNER JOIN @tf tf
	ON tf.IdOperacion = oa.IdOperacion
INNER JOIN @ctas c
	ON c.IdCuenta = tf.IdCuenta
LEFT JOIN @dg dg 
	ON dg.IdOperacion = oa.IdOperacion
WHERE (oa.IdOperacion=@IdOperacion OR @IdOperacion=0)
ORDER BY oa.Fecha asc

salida:
END
GO





