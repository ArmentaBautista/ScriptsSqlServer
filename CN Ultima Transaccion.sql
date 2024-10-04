



DECLARE @TiempoSinActividad INT
DECLARE @ErrCuentasinactividad VARCHAR(MAX) = ''

/*
SELECT @TiempoSinActividad=ISNULL(TRY_CAST(con.ValorCodigo AS INT),0)
FROM dbo.tCTSMconfiguraciones con with(nolock)
WHERE con.IdConfiguracion=9
*/

	SET @TiempoSinActividad=12

	IF @TiempoSinActividad=0
	BEGIN				
		SET @ErrCuentasinactividad = CONCAT('CodEx|00219|pCSMtraspasoCuentasInactividad|', 'Debe de Introducir el tiempo de inactividad de las cuentas ');
		RAISERROR(@ErrCuentasinactividad, 16, 8) ;
		RETURN;
    END 
	
	--SELECT @TiempoSinActividad

	declare @FechaInicio as date = DATEADD(MONTH,- @TiempoSinActividad,GETDATE())

	declare @ctas as table(
		IdCuenta	int primary key,
		IdSocio		INT,
		NoCuenta	VARCHAR(32),
		Producto	VARCHAR(32)
	)

	insert into @ctas
	select 
	c.idcuenta, c.IdSocio, c.codigo, c.Descripcion
	from dbo.tAYCcuentas c with(nolock)
	where c.IdTipoDProducto in (398,144)
		and c.IdEstatus=1
			AND c.SaldoCapital>0

	SELECT 'ctas' AS Info


	declare @tf as table(
		IdTransaccion	INT,
		IdCuenta		INT,
		Fecha			DATE
	)

	INSERT INTO @tf
	select 
	tf.IdTransaccion,
	c.IdCuenta,
	tf.fecha
	from dbo.tSDOtransaccionesFinancieras tf with(nolock)
	inner join dbo.tGRLoperaciones o with(nolock)
		on o.idoperacion=tf.idoperacion
			and o.idtipooperacion in (1,10,18,19,20,22,23,32,33,52,70)
	inner join @ctas c
		on c.idcuenta=tf.idcuenta
	where tf.idestatus=1
		and tf.IdOperacion<>0
			and tf.IdTipoSubOperacion in (500,501)
				and tf.fecha<@FechaInicio
	
	SELECT 'tf' AS Info
	GOTO salida

	declare @ut as table(
		IdCuenta		INT,
		Fecha			DATE
	)

	INSERT INTO @ut
	SELECT
	tf.IdCuenta,
	MAX(tf.Fecha)
	FROM @tf tf
	GROUP BY tf.IdCuenta

	SELECT 'ut' AS Info

	SELECT
	c.IdCuenta,c.IdSocio,c.NoCuenta,c.Producto
	FROM @ctas c
	INNER JOIN @ut u
		ON u.IdCuenta = c.IdCuenta
			AND u.Fecha<=@FechaInicio



salida:


