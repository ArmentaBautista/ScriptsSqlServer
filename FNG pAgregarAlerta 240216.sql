
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAgregarAlerta')
BEGIN
	DROP PROC pAgregarAlerta
	SELECT 'pAgregarAlerta BORRADO' AS info
END
GO

CREATE PROC dbo.pAgregarAlerta
@TipoOperacion AS VARCHAR(250),
@Mensaje AS VARCHAR(max),
@Bloqueo AS BIT,
@IdtipoDdominio AS INT,
@IdRegistro AS INT
AS
BEGIN

		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--			SELECT m.IdMensaje,				-- Identity
		--			       m.Mensaje,				-- Mensaje
		--			       m.IdTipoDmensaje,		-- 1537 Alerta | 1539 Instruccion | 1538 Mensaje
		--			       m.IdTipoDinstruccion,	-- 1541 MÉTODOCLASE | 1542 BLOQUEO | 1543 INFORMACIÓN | 1540 STOREDPROCEDURE
		--			       m.IdTipoDdespliegue,		-- 1544 MODAL | 1545 NO MODAL
		--			       m.UsuarioEmisor,			
		--			       m.UsuarioReceptor,
		--			       m.IdTipoDdominio,		-- 208 Socio | 232 CUENTA
		--			       m.IdDominio,				-- Id del Registro
		--			       m.UsaVigencia,
		--			       m.InicioVigencia,
		--			       m.FinVigencia,
		--			       m.IdEstatus,
		--			       m.Alta,
		--			       m.UsuarioBaja,
		--			       m.Baja,
		--			       m.NotaBaja,
		--			       --m.IdTipoDalerta
		--			FROM dbo.tCTLmensajes m  WITH(NOLOCK) 
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--

		DECLARE @TipoInstruccion AS INT=0
		IF @Bloqueo=1
			SET @TipoInstruccion=1542
		ELSE
			SET @TipoInstruccion=1543

		DECLARE @Alta AS DATETIME = CURRENT_TIMESTAMP;
		
		DECLARE @agrupador AS VARCHAR(60)=''


		IF @TipoOperacion='CTASSINMOV6MESES'
		BEGIN
				SET @IdtipoDdominio=208;

				IF @Mensaje=''
					SET @Mensaje='FAVOR DE CANALIZAR CON UN ASESOR FINANCIERO, PARA LA ACTUALIZACIÓN DE EXPEDIENTE'

				SET @agrupador = 'CTASSINMOV6MESES';

				-- PONER A BAJA LOS MENSAJES ANTERIORES
				-- SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
				DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador
				
				-- INSERCIÓN DE MENSAJES
				INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
				SELECT @Mensaje, 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,s.IdSocio
				,0,'19000101','19000101',1,@Alta,0,'19000101',''
				,'Cuentas sin Movimientos'
				, CONCAT('Socio: ',s.Codigo)
				,@agrupador
				FROM dbo.tSCSsocios s  WITH(NOLOCK) 
				INNER JOIN (
								SELECT s.IdSocio --c.IdCuenta , ISNULL(MAX(tf.Fecha),'19000101') AS UltimoMovimiento, DATEDIFF(MM,MAX(tf.Fecha),@Hoy) AS Diff
								FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
								LEFT JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta
								INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio = c.IdSocio
								WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (144,398,143)
								GROUP BY s.IdSocio
								HAVING DATEDIFF(MM,MAX(tf.Fecha),@Alta) > 12
								--ORDER BY Diff DESC
							) ctas  ON  ctas.IdSocio=s.IdSocio
				 

			SET @agrupador='';
			RETURN;
		END 

		IF @TipoOperacion='EXPNOVIGPLD'
		BEGIN
				RETURN;

		END
		
		IF @TipoOperacion ='CTAPRODJUD'
		BEGIN	
			IF @Mensaje=''
				SET @Mensaje='CUENTA EN PROCESO JUDICIAL'

			DECLARE	@IdSocio INT ;
			SELECT @IdSocio=cue.IdSocio
			FROM dbo.tAYCcuentas cue WITH(NOLOCK) 
			WHERE cue.IdCuenta = @IdRegistro

			INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia
											,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
			VALUES(@Mensaje,1537,@TipoInstruccion,1544,-1,-1,208,@IdSocio,0,'19000101','19000101',1,GETDATE(),0,'19000101','')

			INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia
											,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
			VALUES(@Mensaje,1537,@TipoInstruccion,1544,-1,-1,232,@IdRegistro,0,'19000101','19000101',1,GETDATE(),0,'19000101','')

		END	 
		
		IF @TipoOperacion = 'CONVCOBRO'
		BEGIN
			IF @Mensaje=''
				SET @Mensaje='CUENTA EN CONVENIO DE PAGO'
			
			SELECT @IdSocio=cue.IdSocio
			FROM dbo.tAYCcuentas cue WITH(NOLOCK) 
			WHERE cue.IdCuenta = @IdRegistro

			INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia
											,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
			VALUES(@Mensaje,1537,@TipoInstruccion,1544,-1,-1,@IdtipoDdominio,@IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101','')
        END	
        
        IF @TipoOperacion='SOCIOSENMORA'
		BEGIN
					SET @IdtipoDdominio=208;

					IF @Mensaje=''
						SET @Mensaje='SOCIO EN MORA - '
					
					SET @agrupador ='SOCIOSENMORA'
					--DECLARE @concepto AS VARCHAR(30)='SOCIOS EN MORA'
					
					DECLARE @fechaCartera AS DATE='19000101'

					-- Determinar cartera más reciente
					SELECT @fechaCartera=MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(nolock) 


					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					 DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador --'EL SOCIO PRESENTA ATRASO EN SU PAGO DE CRÉDITO'

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
						,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
						,Concepto
						,Referencia
						,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socio.Codigo,' Cuenta: ',cuentas.Codigo), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,cuentas.IdSocio
					,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT('Socio: ',socio.Codigo) AS Concepto
					,CONCAT('Cuenta: ',cuentas.Codigo) AS Referencia
					,@agrupador
					FROM dbo.tAYCcartera cartera  WITH(nolock) 
					INNER JOIN dbo.tAYCcuentas cuentas  WITH(nolock) ON cuentas.IdCuenta = cartera.IdCuenta
					INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = cuentas.IdSocio
					WHERE cartera.FechaCartera=@fechaCartera AND cartera.DiasMoraCapital>0
					
					SET @agrupador=''
					RETURN

		END 

		IF @TipoOperacion='SOCIOSCARTERAVENCIDA'
		BEGIN
					SET @IdtipoDdominio=208;

					IF @Mensaje=''
						SET @Mensaje='SOCIO EN CARTERA VENCIDA - '
					
					SET @agrupador ='SOCIOSCARTERAVENCIDA'
					--DECLARE @concepto AS VARCHAR(30)=''
					
					SET @fechaCartera =GETDATE()

					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					 DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador 

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socio.Codigo,' Cuenta: ',cuentas.Codigo), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,cuentas.IdSocio
					,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT('Socio: ',socio.Codigo) AS Concepto
					,CONCAT('Cuenta: ',cuentas.Codigo) AS Referencia
					,@agrupador
					FROM dbo.tAYCcartera cartera  WITH(nolock) 
					INNER JOIN dbo.tAYCcuentas cuentas  WITH(nolock) ON cuentas.IdCuenta = cartera.IdCuenta
					INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = cuentas.IdSocio
					WHERE cartera.FechaCartera=@fechaCartera AND cartera.IdEstatusCartera=29					

					SET @agrupador=''
					RETURN
		END

		IF @TipoOperacion='PLDSOCIOSDESACTUALIZADOS'
		BEGIN
					SET @IdtipoDdominio=208;
					IF @Mensaje=''
						SET @Mensaje='SOCIO SIN ACTUALIZACIÓN EN LOS ÚLTIMOS 180 DÍAS - '
					
					SET @agrupador ='PLDSOCIOSDESACTUALIZADOS';
					--DECLARE @concepto AS VARCHAR(30)='SOCIOS EN MORA'
					
					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socios.NoSocio,' ',socios.Nombre,' Sucursal: ',socios.Sucursal), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio
					,Socios.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT(@Mensaje,'Socio: ',socios.NoSocio,' ',socios.Nombre,' Sucursal: ',socios.Sucursal) AS Concepto
					,CONCAT('IdSocio: ',socios.idSocio) AS Referencia
					,@agrupador
					FROM dbo.fnPLDsociosSinBitacoraCambiosUltimos180Dias() socios
					
					SET @agrupador=''
					RETURN
		END
		
		/*
		Fecha: 20220405
		Autor: JCA
		Descripción: A solicitud por correo se agrega alerta para quienes tienen cuenta de fondo solcidario y su saldo sea de menos de $95.00
		*/
		IF @TipoOperacion='FONSOL_SDOMIN'
		BEGIN
					SET @IdtipoDdominio=208;
					IF @Mensaje=''
						SET @Mensaje='SOCIO CON FONDO SOLIDARIO CON SALDO MENOR O IGUAL A $95.00 - '
					
					SET @agrupador ='FONDO_SOLIDARIO';
					--DECLARE @concepto AS VARCHAR(30)=''
					
					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socio.codigo,' ',persona.Nombre,' Saldo: ', cuenta.saldocapital), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio
					,socio.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT(@Mensaje,'Socio: ',socio.codigo,' ',persona.Nombre,' Saldo: ', cuenta.saldocapital) AS Concepto
					,CONCAT('IdSocio: ',socio.IdSocio) AS Referencia
					,@agrupador
					FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
					INNER JOIN dbo.tAYCcuentas cuenta  WITH(NOLOCK) ON cuenta.IdProductoFinanciero = pf.IdProductoFinanciero
																	AND cuenta.IdEstatus=1 AND cuenta.SaldoCapital>0
					INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = cuenta.IdSocio
					INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
					WHERE pf.Codigo='6FONSOL'
					
					SET @agrupador=''
					RETURN
		END
		
		/*
		Fecha: 20220412
		Autor: MPH
		Descripción: A solicitud de FNG se agrega alerta para saber qué socios no han actualizado en más de 360 días
		*/

	    IF @TipoOperacion='ACTSOCFNG'
		BEGIN
					SET @IdtipoDdominio=208;
					IF @Mensaje=''
						SET @Mensaje='SOCIOS SIN ACTUALIZACIÓN EN MÁS DE 360 DÍAS - '
					
					SET @agrupador ='ACTSOCFNG';
					--DECLARE @concepto AS VARCHAR(30)='SOCIOS EN MORA'
					
					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
					SELECT CONCAT(@Mensaje,'Socio: ',socios.Codigo,' ',personas.Nombre,' Sucursal: ',sucursal.Descripcion), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio
					,Socios.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT(@Mensaje,'Socio: ',socios.Codigo,' ',personas.Nombre,' Sucursal: ',sucursal.Descripcion) AS Concepto
					,CONCAT('IdSocio: ',socios.idSocio) AS Referencia
					,@agrupador
					FROM dbo.tSCSsocios  socios             WITH (NOLOCK)
					INNER JOIN dbo.tGRLpersonas personas    WITH (NOLOCK)    ON personas.IdPersona = socios.IdPersona
					INNER JOIN dbo.tCTLsucursales  sucursal WITH (NOLOCK) ON sucursal.IdSucursal = socios.IdSucursal
					WHERE socios.EsSocioValido=1 AND socios.IdEstatus=1
					AND DATEDIFF(DAY,socios.UltimoCambio,GETDATE())>360
					
					SET @agrupador=''
					RETURN;
		END
		
		
		/*
		Fecha: 20220926
		Autor: MPH
		Descripción: A solicitud de UPS se agrega alerta para los socios que no cuentan con Huellas en Ingreso
		*/

	    IF @TipoOperacion='SOCSINHUELLAS'
		BEGIN

					SET @IdtipoDdominio=208;
					IF @Mensaje=''
						SET @Mensaje='El socio no cuenta con huellas dactilares cargadas en el sistema, favor de realizar la actualización de la información  - '
					
					SET @agrupador ='SOC_SIN_HUELLAS';

					DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
					SELECT CONCAT(@Mensaje,'Socio: ',socios.Codigo,' ',personas.Nombre,' Sucursal: ',sucursal.Descripcion), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio
					,Socios.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
					,CONCAT(@Mensaje,'Socio: ',socios.Codigo,' ',personas.Nombre,' Sucursal: ',sucursal.Descripcion) AS Concepto
					,CONCAT('IdSocio: ',socios.idSocio) AS Referencia
					,@agrupador
					FROM		dbo.tSCSsocios Socios WITH (NOLOCK)
					JOIN		dbo.tGRLpersonasFisicas pFisica WITH (NOLOCK) ON pFisica.IdPersona = Socios.IdPersona
					JOIN		dbo.tGRLpersonas personas WITH (NOLOCK) ON personas.IdPersona = pFisica.IdPersona
					JOIN		dbo.tCTLsucursales sucursal WITH (NOLOCK) ON sucursal.IdSucursal = Socios.IdSucursal
					WHERE Socios.EsSocioValido=1 AND Socios.IdEstatus=1 
					AND  NOT EXISTS (
										SELECT RelHuellasDigitalesPersona
										FROM dbo.tPERhuellasDigitalesPersona pHuella WITH (NOLOCK)
										WHERE pHuella.RelHuellasDigitalesPersona = pFisica.IdPersonaFisica   AND  pHuella.IdEstatus=1
										GROUP BY pHuella.RelHuellasDigitalesPersona
					) 
				
					
					SET @agrupador=''
					RETURN;

		END 

		/* @^..^@   JCA.09/02/2024.07:02 a. m. Nota: Solicitada por FNG para la auditoria de PLD, evidenciando que si estan desactualizados los socios, no se puede operar con ellos   */
		
		IF @TipoOperacion='CTAS_SIN_MOV_24MESES'
		BEGIN
				SET @IdtipoDdominio=208;

				IF @Mensaje=''
					SET @Mensaje='FAVOR DE CANALIZAR CON UN ASESOR FINANCIERO, PARA LA ACTUALIZACIÓN DE EXPEDIENTE'

				SET @agrupador = 'CTA_SIN_MOV_24MESES';

				-- PONER A BAJA LOS MENSAJES ANTERIORES
				-- SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
				DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador
				
				-- INSERCIÓN DE MENSAJES
				INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
				SELECT @Mensaje, 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,s.IdSocio
				,0,'19000101','19000101',1,@Alta,0,'19000101',''
				,'Bloqueo de Socio por expediente desactualizado y sin operación en últimos 24 Meses'
				--, CONCAT('Socio: ',s.Codigo,'UltMov: ',ctas.UltimoMov)
				, ctas.UltimoMov
				,@agrupador
				FROM dbo.tSCSsocios s  WITH(NOLOCK) 
				INNER JOIN (
								SELECT s.IdSocio,MAX(tf.Fecha) AS UltimoMov --c.IdCuenta , ISNULL(MAX(tf.Fecha),'19000101') AS UltimoMovimiento, DATEDIFF(MM,MAX(tf.Fecha),@Hoy) AS Diff
								FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
								INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
									ON tf.IdCuenta = c.IdCuenta
										AND tf.IdTipoSubOperacion IN (500,501)
											AND tf.IdEstatus=1
												AND tf.IdOperacion>0
								INNER JOIN dbo.tGRLoperaciones op	 WITH(NOLOCK) 
									ON op.IdOperacion = tf.IdOperacion
										AND op.IdTipoOperacion NOT IN (4,5,65)
								INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio = c.IdSocio
								WHERE c.IdTipoDProducto IN (144,398,143)
									AND c.IdEstatus=1
									--AND c.IdSucursal=1
								GROUP BY s.IdSocio
								HAVING DATEDIFF(YEAR,MAX(tf.Fecha),@Alta) > 2
								--ORDER BY Diff DESC
							) ctas  ON  ctas.IdSocio=s.IdSocio
				 

			SET @agrupador='';
			RETURN;
		END 
	
END
	








GO

