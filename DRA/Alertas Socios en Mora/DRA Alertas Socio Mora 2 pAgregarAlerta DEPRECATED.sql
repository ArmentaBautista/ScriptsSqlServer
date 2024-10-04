
USE iERP_DRA
go

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pAgregarAlerta')
BEGIN
	DROP PROC pAgregarAlerta
END
GO

CREATE PROC pAgregarAlerta
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
								HAVING DATEDIFF(MM,MAX(tf.Fecha),@Alta) > 6
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
	

		IF @TipoOperacion='SOCIOSENMORA'
		BEGIN
					--SET @IdtipoDdominio=208;

					IF @Mensaje=''
						SET @Mensaje='EL SOCIO PRESENTA ATRASO EN SU PAGO DE CRÉDITO'
					
					DECLARE @agrupador AS VARCHAR(30)='SOCIOSENMORA'
					

					-- BORRAR LOS MENSAJES ANTERIORES
					SELECT * FROM dbo.tCTLmensajes m  WITH(nolock) 

					-- INSERTAR EN BITACORA TODAS LAS QUE SE BORREN
					
					SELECT * FROM dbo.tCTLmensajes m WITH(nolock) WHERE m.agrupador='SOCIOSENMORA' 

					INSERT INTO dbo.tCTLmensajes 
					(Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja)
				--SELECT @Mensaje, 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,s.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101',''
					
					SELECT * FROM


		END 

END
	
 
GO

