SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER PROC dbo.pSITreportesPeriodo
	--
	--VERSION 2.13
	--
	@Operacion varchar(20)='',
	@IdPeriodo int,
	@IdReporte int,
	@IdSesion int,
	--El estatus será marcado como 39=Incorrecto, si el proceso termina correctamente será cambiado a 38=Correcto
	@IdEstatus int='' OUTPUT,
	@MSG varchar(MAX)=''
	AS
	BEGIN
		DECLARE @idejercicio int, @trimestre int, @Periodo varchar(30), @abierto bit, @idempresa int, @EsTrimestre BIT,@IdPeriodoActual INT;

		
		SELECT @IdPeriodoActual = IdPeriodo - IIF( Numero = 1, 2, 1)
		FROM dbo.tCTLperiodos 
		WHERE CURRENT_TIMESTAMP BETWEEN Inicio AND Fin AND EsAjuste = 0;

		PRINT @IdPeriodoActual;
		--válidamos que el módulo de ahorro
		SELECT @abierto=abierto, @IdEstatus=38
		FROM vCTLperiodosModulos
		WHERE IdPeriodo=@idperiodo AND IdModulo=7 AND EsAjuste=0

		SELECT TOP 1 @IdEmpresa=IdEmpresa
		FROM tCTLempresas with (nolock)
		WHERE IdEmpresa>0

		SELECT @EsTrimestre=IIF(Numero in (3,6,9,12), 1, 0), @Periodo=Codigo, @idejercicio = IdEjercicio, @trimestre = Trimestre
		FROM tCTLperiodos with (nolock)
		WHERE EsAjuste=0 AND IdPeriodo=@IdPeriodo;
	
		--Periodo invalido
		IF (@Idperiodo=0)
		BEGIN
			SET @MSG='Período inválido o de ajuste'
			RETURN
		END
			--EL periodo para el módulo de ahorro y credito no esta abierto
		IF (@IdPeriodo <> @IdPeriodoActual) AND @IdReporte NOT IN (20,21,22)
		BEGIN
		
			  DECLARE @msg1 as VARCHAR(MAX) = N'CodEx|00219|pSITreportesPeriodo| El período seleccionado se encuentra cerrado' 
		         RAISERROR(@msg1,16,8)
		          RETURN

			RETURN
		END
	
		BEGIN TRY

			EXEC pCRUDperiodosReportes @Operacion='INSERT', @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte, @IdSesion=@IdSesion, @IdEstatus=38	

			--Catalogo minimo
			IF(@IdReporte=1)
			BEGIN
				IF (@Operacion='LST')
				BEGIN
					--Cuando es consulta salimos del stored
					EXEC pSITcatalogoMinimo @tipooperacion='LST', @idempresa=@IdEmpresa, @idperiodo=@idperiodo
				END
				ELSE
				BEGIN	
					EXEC dbo.pSITcatalogoMinimo	
							@TipoOperacion='MIN',    
							@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo;
				END
				RETURN
			END
			IF (@IdReporte = 2)
			BEGIN
				EXEC dbo.pSITinversiones @IdPeriodo = @IdPeriodo, -- int
					@IdEmpresa = @idempresa, -- int
					@TipoOperacion='R03' -- varchar(20)
				RETURN
			END
        
			IF(@IdReporte in (3,4))
			BEGIN
				EXEC dbo.pSITconceptosR04		
						@TipoOperacion='R04',    
						@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo;
				RETURN
			END
		
			IF(@IdReporte in (5,6))
			BEGIN
		
				EXEC dbo.pSITcartera451_453	
						@TipoOperacion='INSERT', 
						@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte;
				RETURN
			END
		
			IF(@IdReporte=7)
			BEGIN
			RETURN

			      EXEC dbo.pSITmesualCaptacion841
			           @TipoOperacion='INSERT', 
						@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte;

					--EXEC dbo.pSITcaptacion841Mensual	
					--	@TipoOperacion='INSERT', 
					--	@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte;

				EXEC dbo.pSITTrimestralcaptacion841	
						@TipoOperacion='INSERT', 
						@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte;
				
				--EXEC dbo.pSITcaptacion841	
				--		@TipoOperacion='INSERT', 
				--		@IdEmpresa=@IdEmpresa, @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte;
				RETURN
			END

			IF (@IdReporte = 8)
			BEGIN
				EXEC dbo.pSITprestamosBancarios @IdPeriodo = @IdPeriodo, -- int
					@IdEmpresa = @idempresa, -- int
					@TipoOperacion = 'R08' -- varchar(20)
				RETURN
			END

        IF (@IdReporte =9 )
			BEGIN
				exec dbo.pSITcoeficienteLiquidez @TipoOperacion = '2011' -- varchar(20)
                               , @IdPeriodo = @IdPeriodo      -- int
				RETURN
			END
            
			 IF (@IdReporte =10 )
			BEGIN
				exec iERP_CAZ_REG.dbo.pREGrequerimientosCapital_A2112_2019 @idperiodo = @IdPeriodo -- int
				

				RETURN
			END
            
			IF(@IdReporte=11)
			BEGIN	
					
				EXEC dbo.pSITinformacionOperativa
						@TipoOperacion='', @Formulario='2422',
						@IdPeriodo=@Idperiodo, @IdEmpresa=@IdEmpresa, @Periodo=@Periodo,
						@idejercicio=@idejercicio, @trimestre=@trimestre
				RETURN
			END

			IF(@IdReporte=12)
			BEGIN
			
				EXEC dbo.pSITinformacionOperativa
						@TipoOperacion='', @Formulario='2441',
						@IdPeriodo=@Idperiodo, @IdEmpresa=@IdEmpresa, @Periodo=@Periodo,
						@idejercicio=@idejercicio, @trimestre=@trimestre
				RETURN
			END

			IF(@IdReporte=13)
			BEGIN
			
				EXEC dbo.pSITinformacionOperativa
						@TipoOperacion='', @Formulario='2442',
						@IdPeriodo=@Idperiodo, @IdEmpresa=@IdEmpresa, @Periodo=@Periodo,
						@idejercicio=@idejercicio, @trimestre=@trimestre
				RETURN
			END
		
			IF(@IdReporte=14)
			BEGIN
			
				EXEC dbo.pSITinformacionOperativa
						@TipoOperacion='', @Formulario='2443',
						@IdPeriodo=@Idperiodo, @IdEmpresa=@IdEmpresa, @Periodo=@Periodo,
						@idejercicio=@idejercicio, @trimestre=@trimestre
				RETURN
			END

			IF(@IdReporte=19)
			BEGIN
			RETURN
				EXEC dbo.pSITinclusionFinanciera @IdPeriodo =  @IdPeriodo,
					@IdEmpresa = @idempresa, -- int
					@TipoOperacion = 'R30' -- varchar(20)

				RETURN
			END
			IF(@IdReporte IN (20))
			BEGIN 
				PRINT 'RELEVANTES'
				EXEC dbo.pPLDoperacionesRelevantes @IdEjercicio = 31, @Trimestre = 2, @IdEmpresa = 1, @TipoOperacion = 'REL-XLS'				
				RETURN
			END

			IF(@IdReporte IN (21,22))
			BEGIN
				DECLARE @tipo VARCHAR(20) = IIF(@IdReporte = 21, 'INU-XLS', 'PRE-XLS');
				EXEC dbo.pPLDoperacionesInusualesPreocupantes @IdEmpresa = @IdEmpresa, @IdPeriodo = @IdPeriodo, @TipoOperacion = @tipo				
				RETURN
			END

		END TRY
		BEGIN CATCH
			 insert into tmpMensajesExcepciones(tabla, nota) 
			 VALUES('pCRUDperiodosReportes',CONCAT(ERROR_NUMBER(),' AS ErrorNumber, ',ERROR_SEVERITY(),' AS ErrorSeverity, ',ERROR_STATE() ,' AS ErrorState, ', ERROR_PROCEDURE() ,' AS ErrorProcedure, ', ERROR_LINE() ,' AS ErrorLine, ', ERROR_MESSAGE(), ' AS ErrorMessage'))
			 EXEC pCRUDperiodosReportes @Operacion='UPDATE', @IdPeriodo=@IdPeriodo, @IdReporte=@IdReporte, @IdSesion=@IdSesion, @IdEstatus=39
			 SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
		END CATCH


	END






GO

