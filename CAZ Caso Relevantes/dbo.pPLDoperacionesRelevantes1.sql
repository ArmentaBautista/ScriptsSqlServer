SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROC [dbo].[pPLDoperacionesRelevantes]
	@TipoOperacion VARCHAR(20),
	@IdEmpresa INT,
	@IdEjercicio INT = 0,
	@Trimestre INT = 0
	--version 2.1.3
	AS
	BEGIN
		
		DECLARE @IdPeriodo INT, @inicio DATE, @fin DATE;

		SELECT @IdPeriodo = id , @inicio = ini, @fin = fin
		FROM (	SELECT  id = MAX(CASE WHEN Numero IN (3,6,9,12) THEN IdPeriodo ELSE 0 END), ini = MIN(Inicio), fin = MAX(fin)
				FROM dbo.tCTLperiodos
				WHERE Trimestre > 0 AND IdEjercicio = @IdEjercicio AND Trimestre = @Trimestre
				GROUP BY IdEjercicio, Trimestre ) AS tmp;
	
		DECLARE @db varchar(1000)=(SELECT Valor FROM tCTLconfiguracion WHERE IdConfiguracion=156);

		IF (@TipoOperacion = 'REL-XLS')
		BEGIN
				DECLARE @command_insert VARCHAR(MAX)=(
				'INSERT INTO [{%DataBaseREG%}].[dbo].[tPLDoperacionesRelavantes](	[IdEmpresa],[IdPeriodo],[Folio],[OrganoSuperior],[Localidad],[Sucursal],[TipoOperacion],[InstrumentoMonetario],[NumeroCuenta],[Monto],[Moneda],[FechaOperacion],[FechaDeteccionOperacion],[Nacionalidad],[TipoPersona],[RazonSocial],[Nombre],[Paterno],[Materno],[RFC],[CURP],[FechaNacimiento],[Domicilio],[Colonia],[Ciudad],[Telefono],[ActividadEconomica],'+
				'[NombreAgente],[PaternoAgente],[MaternoAgente],[RFCAgente],[CURPAgente],' +
				'[ConsecutivoCuentaPersonaRelacionada],[NumeroCuentaPersonaRelacionada],[SujetoObligadoPersonaRelacionada],[NombrePersonaRelacionada],[PaternoPersonaRelacionada],[MaternoPersonaRelacionada],[DescripcionOperacion],[Razones])' + CHAR(10) +
				'EXEC dbo.pPLDgenerarReporteOperaciones @TipoOperacion = ''{%TipoOperacion%}'', @IdEmpresa = {%IdEmpresa%}, @IdPeriodo = {%IdPeriodo%},'+
													  ' @FechaInicial = ''{%FechaInicial%}'',  @FechaFinal = ''{%fechaFinal%}''');

				DECLARE @command_delete VARCHAR(MAX)=' DELETE FROM [{%DataBaseREG%}].[dbo].[tPLDoperacionesRelavantes] WHERE IdEmpresa = {%IdEmpresa%} AND IdPeriodo = {%IdPeriodo%}';

					SET @command_delete=REPLACE(REPLACE(REPLACE(@command_delete,'{%DataBaseREG%}',@db),'{%IdPeriodo%}',CONCAT(@IdPeriodo,'')),'{%IdEmpresa%}',CONCAT(@IdEmpresa,''));
					EXEC (@command_delete);
	
					SET @command_insert=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@command_insert,'{%DataBaseREG%}',@db),
																								'{%IdEmpresa%}',CONCAT(@IdEmpresa,'')),
																								'{%IdPeriodo%}',CONCAT(@IdPeriodo,'')),
																								'{%TipoOperacion%}',CONCAT(@TipoOperacion,'')),
																								'{%IdEjercicio%}',CONCAT(@IdEjercicio,'')),
																								'{%FechaInicial%}',CONCAT(@inicio,'')),
																								'{%fechaFinal%}',CONCAT(@fin,'')),
																								'{%Trimestre%}',CONCAT(@Trimestre,''));
					PRINT @command_insert
					EXEC (@command_insert);

					DECLARE @sql AS NVARCHAR(max)=CONCAT('[',@db,'].dbo.pPLDeliminarAcentosCaracteresEspecialesEnReportes @TipoOperacion=''', @TipoOperacion,''',@IdPeriodo=''', @IdPeriodo,'''')
					
					PRINT @sql
					--PRINT @params
					EXEC sys.sp_executesql @sql
		END
	END	
GO

