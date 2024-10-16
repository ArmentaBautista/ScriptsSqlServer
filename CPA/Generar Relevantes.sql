
	BEGIN TRAN

	------Operaciones Reelevantes
	
	DECLARE @IdDivisa AS integer=0
	DECLARE @Fecha AS date='19000101'
	DECLARE @monto AS NUMERIC(23,8)=0
	DECLARE @MontoRelevancia NUMERIC(23,8)=0
	DECLARE @IdOperacion AS INT=0;
	DECLARE @metodo AS INT=0
	DECLARE @folio AS INT=0

	SET @MontoRelevancia=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-33)

	SELECT  @IdDivisa=o.IdDivisa,@fecha=o.Fecha,@monto=td.monto, @IdOperacion=td.IdOperacion ,@metodo=td.IdMetodoPago
	, @folio=o.Folio
	FROM tGRLoperaciones o WITH(NOLOCK)
	INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON td.IdOperacion = o.IdOperacion
	WHERE o.Folio=11457
--	JOIN INSERTED i ON i.IdOperacion=o.IdOperacion
	
	DECLARE @DIVISA_DOLAR AS INT=-4

	--SELECT	@IdOperacion, @folio

	
	------------------Operaciones  Reeleventes
	--Pagos por $10 000 dolares o másen efectivo o con vucher o su equivalente a cualquier moneda al tipo del cambio del dia
	IF EXISTS(SELECT IdTransaccionD  FROM dbo.tSDOtransaccionesD td  
			  WHERE td.IdOperacion=@IdOperacion
			  AND IdMetodoPago in (-2,-10) AND  (SELECT  dbo.[fDIVmontoCalculado](@IdDivisa,@DIVISA_DOLAR,@Fecha,Monto))>= @MontoRelevancia
																			   AND  dbo.fnPLDesOperacionDotacionCustodia(IdOperacion)=0 )
	BEGIN	
		--DECLARE @msg2 AS VARCHAR(500)=CONCAT('NO DETECTADA - ',@IdDivisa,' ',@Fecha,' ',@monto,' ',@IdOperacion)
		--RAISERROR(@msg2 ,16,1);
		
		  		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		  		,UltimoCambio,IdTipoDDominio,IdObservacionE,IdObservacionEDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		  		MontoReferencia,IdSocio, IdCuenta,GeneradaDesdeSistema,Texto,IdInusualidad)
				----1594 --- reelevante   68--reportada
				SELECT o.IdPersona,1594 ,68 ,t.MontoSubOperacion,1,t.IdUsuarioAlta,GETDATE(),t.IdUsuarioCambio,
				GETDATE(),1598,0,0,t.IdSesion,td.IdOperacion,td.IdTransaccionD,'MONTO RELEVANTE',@MontoRelevancia,o.IdSocio,0,1,'MONTO RELEVANTE',12
				FROM tSDOtransaccionesD td WITH(NOLOCK)
				INNER JOIN tGRLoperaciones AS o  WITH (NOLOCK) ON o.IdOperacion = td.IdOperacion
				inner JOIN tSDOtransacciones AS t  WITH (NOLOCK) ON t.IdTransaccion = td.RelTransaccion 
				WHERE o.IdOperacion=@IdOperacion

				/*
				IF ((SELECT Valor FROM dbo.tPLDconfiguracion WHERE IdParametro=-34)='True')
				BEGIN
				    INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		  			,UltimoCambio,IdTipoDDominio,IdObservacionE,IdObservacionEDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		  			MontoReferencia,IdSocio, IdCuenta,GeneradaDesdeSistema,Texto,IdInusualidad)
					----1593 --- presunta inusual   46--GNEREDO
					SELECT o.IdPersona,1593 ,46 ,t.MontoSubOperacion,1,t.IdUsuarioAlta,GETDATE(),t.IdUsuarioCambio,
					GETDATE(),1598,0,0,t.IdSesion,td.IdOperacion,td.IdTransaccionD,'INUSUALIDAD POR MONTO RELEVANTE',@MontoRelevancia,o.IdSocio,0,1,'INUSUALIDAD POR MONTO RELEVANTE',17
					FROM INSERTED td WITH(NOLOCK)
					INNER JOIN tGRLoperaciones AS o  WITH (NOLOCK) ON o.IdOperacion = td.IdOperacion
					inner JOIN tSDOtransacciones AS t  WITH (NOLOCK) ON t.IdTransaccion = td.RelTransaccion 
				END
			*/
		  
	END
	/*
	--------------Operaciones Presuntas Inusuales
	--Operaciones en efectivo en moneda extranjera o con cheques de viajero por 500 dolares o mas
	IF EXISTS(SELECT IdTransaccionD  FROM INSERTED  WHERE  IdMetodoPago =-1 AND  (SELECT  dbo.[fDIVmontoCalculado](@IdDivisa,@DIVISA_DOLAR,@Fecha,Monto))>= 500) OR ((SELECT Monto FROM tSDOtransaccionesD tsd WITH (NOLOCK) WHERE  IdMetodoPago IN (-2,-10) AND @IdDivisa =@DIVISA_DOLAR )>500 )
	BEGIN	
		 INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio,UltimoCambio,IdTipoDDominio,IdObservacionE,IdObservacionEDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,GeneradaDesdeSistema)
		  ----1593 ---presunta inusual   46--Estatus Generado
		  SELECT ts.IdPersona,1593 ,46 ,td.monto,1,tf.IdUsuarioAlta,GETDATE(),tf.IdUsuarioCambio,GETDATE(),1598,0,0,tf.IdSesion,td.IdOperacion,td.IdTransaccionD,1
		  FROM INSERTED td WITH(NOLOCK)
		  JOIN tSDOtransaccionesFinancieras tf WITH(NOLOCK)ON tf.Idoperacion!=0 AND tf.IdOperacion=td.IdOperacion AND tf.IdEstatus=1 --AND tf.IdTipoSubOperacion=500
		  INNER JOIN tSDOsaldos ts WITH(NOLOCK)ON ts.IdSaldo=tf.IdSaldoDestino
	END
	
	---Operaciones en un mes calendario, en efectivo por 1,000,000 de pesos o mas , o bien ,en efectivo en dolares o cualquier otra moneda extranjera por 100,000 o mas

	*/

	-- ROLLBACK
	
	-- SELECT * FROM dbo.tPLDoperaciones
	-- DELETE FROM dbo.tPLDoperaciones WHERE IdOperacion=31361

	-- COMMIT







