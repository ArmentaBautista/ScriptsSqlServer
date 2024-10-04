SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
	ALTER PROC [dbo].[pPLDoperacionesInusualesPreocupantes]
	--
	-- VERSION 2.1.3
	--
	@TipoOperacion VARCHAR(20),
	@IdEmpresa INT,
	@IdPeriodo INT = 0
	AS
	BEGIN
		
		DECLARE @inicio DATE, @fin DATE;
		SELECT @inicio = Inicio, @fin = Fin
		FROM dbo.tCTLperiodos
		WHERE EsAjuste = 0 AND IdPeriodo = @IdPeriodo
		
		DECLARE @db varchar(1000)=(SELECT Valor FROM tCTLconfiguracion WHERE IdConfiguracion=156);


		IF (@TipoOperacion IN ('INU-XLS','PRE-XLS'))
		BEGIN
				DECLARE @command_insert VARCHAR(MAX)=(
				'INSERT INTO [{%DataBaseREG%}].[dbo].[tPLDoperacionesInusuales](	[IdEmpresa],[IdPeriodo],[Folio],[OrganoSuperior],[Localidad],[Sucursal],[TipoOperacion],[InstrumentoMonetario],[NumeroCuenta],[Monto],[Moneda],[FechaOperacion],[FechaDeteccionOperacion],[Nacionalidad],[TipoPersona],[RazonSocial],[Nombre],[Paterno],[Materno],[RFC],[CURP],[FechaNacimiento],[Domicilio],[Colonia],[Ciudad],[Telefono],[ActividadEconomica],'+
				'[NombreAgente],[PaternoAgente],[MaternoAgente],[RFCAgente],[CURPAgente],' +
				'[ConsecutivoCuentaPersonaRelacionada],[NumeroCuentaPersonaRelacionada],[SujetoObligadoPersonaRelacionada],[NombrePersonaRelacionada],[PaternoPersonaRelacionada],[MaternoPersonaRelacionada],[DescripcionOperacion],[Razones])' + CHAR(10) +
				'EXEC dbo.pPLDgenerarReporteOperaciones @TipoOperacion = ''{%TipoOperacion%}'', @IdEmpresa = {%IdEmpresa%}, @IdPeriodo = {%IdPeriodo%},'+
													  ' @FechaInicial = ''{%FechaInicial%}'',  @FechaFinal = ''{%fechaFinal%}''');

				DECLARE @command_delete VARCHAR(MAX)=' DELETE FROM [{%DataBaseREG%}].[dbo].[tPLDoperacionesInusuales] WHERE IdEmpresa = {%IdEmpresa%} AND IdPeriodo = {%IdPeriodo%}';

				SET @command_delete=REPLACE(REPLACE(REPLACE(@command_delete,'{%DataBaseREG%}',@db),'{%IdPeriodo%}',CONCAT(@IdPeriodo,'')),'{%IdEmpresa%}',CONCAT(@IdEmpresa,''));
				EXEC (@command_delete);

				SET @command_insert=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@command_insert,'{%DataBaseREG%}',@db),
																							'{%IdEmpresa%}',CONCAT(@IdEmpresa,'')),
																							'{%IdPeriodo%}',CONCAT(@IdPeriodo,'')),
																							'{%TipoOperacion%}',CONCAT(@TipoOperacion,'')),
																							'{%FechaInicial%}',CONCAT(@inicio,'')),
																							'{%fechaFinal%}',CONCAT(@fin,''));
				PRINT @command_insert
				EXEC (@command_insert);
		END
	END






GO

