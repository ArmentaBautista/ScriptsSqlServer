SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROC dbo.pAgregarAlerta
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
		--				   m.concpeto,
		--				   m.referencia,
		--			FROM dbo.tCTLmensajes m  WITH(NOLOCK) 
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--

		DECLARE @TipoInstruccion AS INT=0
		IF @Bloqueo=1
			SET @TipoInstruccion=1542
		ELSE
			SET @TipoInstruccion=1543

		DECLARE @Alta AS DATETIME = CURRENT_TIMESTAMP;
		



		IF @TipoOperacion='CTASSINMOV6MESES'
		BEGIN
				SET @IdtipoDdominio=208;

				IF @Mensaje=''
					SET @Mensaje='FAVOR DE CANALIZAR CON UN ASESOR FINANCIERO, PARA LA ACTUALIZACIÓN DE EXPEDIENTE'

				INSERT INTO dbo.tCTLmensajes 
				(Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
				SELECT @Mensaje, 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,s.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
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
				 WHERE s.IdSocio NOT IN (
						SELECT iddominio
						FROM dbo.tCTLmensajes msg  WITH(NOLOCK) 
						WHERE msg.IdTipoDdominio=208
							  AND msg.IdEstatus=1
					    )
			RETURN;
		END 

		IF @TipoOperacion='EXPNOVIGPLD'
		BEGIN
				--SET @IdtipoDdominio=208;

				IF @Mensaje=''
					SET @Mensaje='FAVOR DE CANALIZAR CON UN ASESOR FINANCIERO, PARA LA ACTUALIZACIÓN DE EXPEDIENTE'
					DECLARE @fechaAltaMenorAseisMeses AS DATE =(select DATEADD(Month,-6,GETDATE()))
					DECLARE @fechaMenorunAñodeFechaActual AS DATE =(select DATEADD(Month,-12,GETDATE()))
				

				INSERT INTO dbo.tCTLmensajes 
				(Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
			--SELECT @Mensaje, 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,s.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
			 SELECT @Mensaje,1537,@Bloqueo,1544,-1,-1,@IdtipoDdominio,ex.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
		FROM dbo.vPLDexpedientesNoVigentes ex
			GROUP BY ex.IdSocio

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
					--SET @IdtipoDdominio=208;

					IF @Mensaje=''
						SET @Mensaje='SOCIO EN MORA - '
					
					DECLARE @agrupador AS VARCHAR(30)='SOCIOSENMORA'
					--DECLARE @concepto AS VARCHAR(30)=''
					
					DECLARE @fechaCartera AS DATE='19000101'

					-- Determinar cartera más reciente
					SELECT @fechaCartera=MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(nolock) 


					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					 DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador --'EL SOCIO PRESENTA ATRASO EN SU PAGO DE CRÉDITO'

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja,Concepto,Referencia,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socio.Codigo,' Cuenta: ',cuentas.Codigo), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,cuentas.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101','',CONCAT('Socio: ',socio.Codigo) AS Concepto,CONCAT('Cuenta: ',cuentas.Codigo) AS Referencia,@agrupador
					FROM dbo.tAYCcartera cartera  WITH(nolock) 
					INNER JOIN dbo.tAYCcuentas cuentas  WITH(nolock) ON cuentas.IdCuenta = cartera.IdCuenta
					INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = cuentas.IdSocio
					WHERE cartera.FechaCartera=@fechaCartera AND cartera.DiasMoraCapital>0
				
				
		END

		IF @TipoOperacion='SOCIOSCARTERAVENCIDA'
		BEGIN
					--SET @IdtipoDdominio=208;

					IF @Mensaje=''
						SET @Mensaje='SOCIO EN CARTERA VENCIDA - '
					
					SET @agrupador ='SOCIOSCARTERAVENCIDA'
					--DECLARE @concepto AS VARCHAR(30)=''
					
					SET @fechaCartera ='19000101'

					-- Determinar cartera más reciente
					SELECT @fechaCartera=MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(nolock) 


					-- PONER A BAJA LOS MENSAJES ANTERIORES
					 --SELECT m.IdMensaje FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.agrupador=@agrupador
					 DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador 

					INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja,Concepto,Referencia,Agrupador)
				    SELECT CONCAT(@Mensaje,'Socio: ',socio.Codigo,' Cuenta: ',cuentas.Codigo), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,cuentas.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101','',CONCAT('Socio: ',socio.Codigo) AS Concepto,CONCAT('Cuenta: ',cuentas.Codigo) AS Referencia,@agrupador
					FROM dbo.tAYCcartera cartera  WITH(nolock) 
					INNER JOIN dbo.tAYCcuentas cuentas  WITH(nolock) ON cuentas.IdCuenta = cartera.IdCuenta
					INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = cuentas.IdSocio
					WHERE cartera.FechaCartera=@fechaCartera AND cartera.IdEstatusCartera=29
					
		END
		
		-- Alertas con el nombre del socio y sus cuentas activas
		IF @TipoOperacion='SOCIOCUENTASACTIVAS'
		BEGIN
					begin -- Seccion inicial
					IF @Mensaje=''
						SET @Mensaje='SOCIO CUENTAS ACTIVAS - '
					
					SET @agrupador ='SOCIOCUENTASACTIVAS'
					SET @fechaCartera ='19000101'
					SELECT @fechaCartera=MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(nolock) 
					DELETE FROM dbo.tCTLmensajes WHERE agrupador=@agrupador 

					end

					begin -- Cursor
								-- Tabla de socios y cuentas concatenados para mensajes
								DECLARE @tt_cuentas TABLE(
								IdSocio INT,
								Socio VARCHAR(100),
								Cuenta VARCHAR(100)
								)
								-- insertado de los valores para los mensajes
								INSERT INTO @tt_cuentas (IdSocio,Socio,Cuenta)
								SELECT c.IdSocio, sc.Codigo + ' - ' + p.Nombre, c.Codigo + ' - ' + c.Descripcion 
								FROM tayccuentas c  WITH(nolock) 
								INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
								INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
								WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (143)

									/* declare variables */
									DECLARE @idSocioCursor INT=0
									DECLARE @Socio VARCHAR(50)='';

									DECLARE cur_sociosCuentas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR (SELECT tt.IdSocio, tt.Socio FROM @tt_cuentas tt GROUP BY tt.IdSocio, tt.Socio)
									OPEN cur_sociosCuentas
									FETCH NEXT FROM cur_sociosCuentas INTO @idSocioCursor,@Socio
									WHILE @@FETCH_STATUS = 0
									BEGIN
    
										DECLARE @msg AS VARCHAR(max)='';

												/* declare variables */
												DECLARE @variable VARCHAR(150);
												DECLARE cur_cuentas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT cc.Cuenta  FROM @tt_cuentas cc WHERE cc.IdSocio=@idSocioCursor
												OPEN cur_cuentas
												FETCH NEXT FROM cur_cuentas INTO @variable
												WHILE @@FETCH_STATUS = 0
												BEGIN
													SET @msg=@msg + ' ' + @variable
	
													FETCH NEXT FROM cur_cuentas INTO @variable
												END
												CLOSE cur_cuentas
												DEALLOCATE cur_cuentas
										
										/* INSERTAR ALERTA*/
										PRINT @Socio + ' - ' + @msg


										FETCH NEXT FROM cur_sociosCuentas INTO @idSocioCursor, @Socio
									END
									CLOSE cur_sociosCuentas
									DEALLOCATE cur_sociosCuentas

					End

		END

	
END
	
 




GO

