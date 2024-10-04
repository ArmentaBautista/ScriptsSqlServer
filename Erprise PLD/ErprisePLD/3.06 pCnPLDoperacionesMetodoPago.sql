

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDoperacionesMetodoPago')
BEGIN
	DROP PROC pCnPLDoperacionesMetodoPago
	SELECT 'pCnPLDoperacionesMetodoPago BORRADO' AS info
END
GO

CREATE PROC pCnPLDoperacionesMetodoPago
@pFechaInicial DATE='19000101',
@pFechaFinal DATE='19000101'
AS
BEGIN
	
	DECLARE @tfCuentas TABLE(
		IdOperacion					INT,
		IdTransaccion				INT,
		NoSocio						VARCHAR(24),
		Nombre						VARCHAR(128),
		NoCuenta					VARCHAR(24),
		Producto					VARCHAR(32),
		Socio AS CONCAT(NoSocio,' - ',Nombre),
		Cuenta AS CONCAT(NoCuenta,' - ',Producto)

	)

	INSERT INTO @tfCuentas 
	SELECT 
	tf.IdOperacion, tf.IdTransaccion, sc.Codigo, p.Nombre, c.Codigo, c.Descripcion
	FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		ON c.IdCuenta = tf.IdCuenta
			AND c.IdCuenta = 0
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK)
		ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = sc.IdPersona
	WHERE tf.IdEstatus=1
		AND tf.Fecha BETWEEN @pFechaInicial AND @pFechaFinal

	DECLARE @conceptos TABLE(
		IdOperacion		INT,
		Socios			VARCHAR(MAX),
		Cuentas			VARCHAR(MAX)
	)

	INSERT @conceptos
	SELECT
	t.IdOperacion, 
	[Socios]			= STRING_AGG(CAST(t.Socio AS varchar(MAX)),','),
	[Cuentas]			= STRING_AGG(CAST(Cuenta AS varchar(MAX)),',')
	FROM @tfCuentas t
	GROUP BY t.IdOperacion

	SELECT 
	op.Fecha,
	[TipoOperacion]				= co.Codigo,
	op.Folio,
	[Naturaleza]				= tod.Descripcion,
	[Instrumento]				= mp.Descripcion,
	[Total]						= FORMAT(op.Total,'C','es-MX'),
	c.Socios,
	c.Cuentas
	FROM dbo.tGRLoperaciones op WITH(NOLOCK)
	INNER JOIN dbo.tCTLtiposOperacion co WITH(NOLOCK)
		ON op.IdTipoOperacion = co.IdTipoOperacion
	INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
		ON td.IdOperacion = op.IdOperacion
				AND td.EsCambio=0
	INNER JOIN dbo.tCTLtiposOperacion tod WITH(NOLOCK)
		ON tod.IdTipoOperacion = td.IdTipoSubOperacion
	INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
		ON mp.IdMetodoPago = td.IdMetodoPago
	INNER JOIN @conceptos c
		ON c.IdOperacion = op.IdOperacion
	WHERE op.IdEstatus=1
	  AND op.IdTipoOperacion IN (1,2,6,10,19,20,22,23,32,33,45,52,57,70)
		AND op.Fecha BETWEEN @pFechaInicial AND @pFechaFinal
	ORDER BY op.IdOperacion DESC

END
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pCnPLDoperacionesMetodoPago')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pCnPLDoperacionesMetodoPago')
END
GO
