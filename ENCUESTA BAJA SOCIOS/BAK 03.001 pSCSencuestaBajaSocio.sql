

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSCSencuestaBajaSocio')
BEGIN
	DROP PROC pSCSencuestaBajaSocio
	SELECT 'pSCSencuestaBajaSocio BORRADO' AS info
END
GO

CREATE PROC pSCSencuestaBajaSocio
@pTipoOperacion			AS VARCHAR(24),
@pIdEncuestaBajaSocio	INT=0 OUTPUT,
@pIdSocio				INT=0,
@pFecha					DATE='19000101',
@pRespuestas			tpRespuestasEncuestaBajaSocio NULL READONLY
AS
BEGIN
	
	DECLARE @TipoOperacion AS VARCHAR(24)=@pTipoOperacion
	/* ฅ^•ﻌ•^ฅ   JCA.23/08/2023.10:06 a. m. Nota: CAMBIAR POR UN PARÁMETRO DE CONFIGURACIÓN PARA ESTABLECER EL CUESTIONARIO DE LA BAJA DE SOCIO   */
	DECLARE @IdTipoDdominio AS INT=2869
	DECLARE @IdCuestionario AS INT=1006
	DECLARE @IdSocio AS INT = @pIdSocio;
	DECLARE @Fecha AS DATE=@pFecha;
	DECLARE @IdSesion AS INT=(SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD())
	DECLARE @IdEncuestaBajaSocio AS INT=0 --OUTPUT

	IF @pTipoOperacion='ADD'
	BEGIN
		
		IF @IdSocio=0 OR @Fecha='19000101'
		BEGIN
			RAISERROR (N'Se requieren parametros de Socio y Fecha', 16, 1);
			RETURN -1
		END

		BEGIN TRY
			BEGIN TRANSACTION;
			UPDATE e SET e.IdEstatus=2
			FROM tSCSencuentaBajaSocios e WHERE e.IdSocio=@IdSocio

			UPDATE r SET r.IdEstatus=2
			FROM tGRLrespuestasCuestionario r WHERE r.IdCuestionario=@IdCuestionario 
				AND r.IdTipoDdominio=@IdTipoDdominio
				AND r.IdSocio=@IdSocio

			/* ฅ^•ﻌ•^ฅ   JCA.24/08/2023.11:18 a. m. Nota: Primero insertamos la encuesta para el ID   */
			INSERT INTO dbo.tSCSencuentaBajaSocios (IdSocio,Fecha,IdSesion)
			SELECT @IdSocio, @Fecha,@IdSesion 
			
			SET @IdEncuestaBajaSocio=SCOPE_IDENTITY();

			/*  (◕ᴥ◕)    JCA.24/08/2023.11:48 a. m. Nota: Insertar plantilla de respuestas  */
			INSERT INTO dbo.tGRLrespuestasCuestionario
			(IdReactivo,IdRespuesta,IdCuestionario,IdTipoDdominio,IdDominio,IdEstatus,TextoRespuesta,IdSocio)
			SELECT 
			pr.IdReactivo,
			pr.IdRespuesta,
			pr.IdCuestionario,
            @IdTipoDdominio,
			@IdEncuestaBajaSocio,
			1,
            pr.Respuesta,
			@IdSocio
			FROM dbo.fnSCSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) pr
	
			COMMIT TRANSACTION;		
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			DECLARE @err AS VARCHAR(max)= (SELECT ERROR_MESSAGE())
			RAISERROR (@err, 16, 1);
			RETURN -1
		END CATCH;
		
		/* ฅ^•ﻌ•^ฅ   JCA.24/08/2023.06:17 p. m. Nota: Devolvemos los reactivos para no hacer 2 conexiones   */
			SET @pIdEncuestaBajaSocio=@IdEncuestaBajaSocio

			SELECT pyr.IdCuestionario,
                   pyr.IdReactivo,
                   pyr.IdTipoDreactivo,
                   pyr.TipoReactivo,
                   pyr.Enunciado,
                   pyr.IdRespuesta,
                   pyr.Respuesta,
                   pyr.Elegida
			FROM dbo.fnSCSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) pyr

		RETURN 1
    END

	IF @pTipoOperacion='UPD'
	BEGIN

		UPDATE r SET r.IdRespuesta=t.IdRespuesta, r.TextoRespuesta=t.TextoRespuesta
		FROM dbo.tGRLrespuestasCuestionario r 
		INNER JOIN @pRespuestas t 
			ON t.IdReactivo = r.IdReactivo
				AND t.IdDominio = r.IdDominio
				AND t.IdSocio = r.IdSocio
		WHERE r.IdTipoDdominio=@IdTipoDdominio


		RETURN 1
	END

	IF @TipoOperacion='CUESTIONARIOS'
	BEGIN
				/* ฅ^•ﻌ•^ฅ   JCA.22/08/2023.04:49 p. m. Nota: Cuestionarios   */
				SELECT 
				quiz.IdCuestionario,
				quiz.Codigo,
				quiz.Descripcion
				FROM dbo.tGRLcuestionarios quiz  WITH(NOLOCK) 
				WHERE quiz.IdCuestionario=@IdCuestionario
		RETURN 1
	END 

	IF @TipoOperacion='REACTIVOS'
	BEGIN
				
				SET @IdCuestionario = 1006

				/*  (◕ᴥ◕)    JCA.22/08/2023.04:49 p. m. Nota: Reactivos de un cuestionario  */
				SELECT 
				reac.IdReactivo,
				reac.Enunciado,
				reac.IdListaDcategoria,
				[Categoria]		= cat.Descripcion,
				reac.Ponderacion,
				reac.IdTipoDreactivo,
				[Tipo]			= tipo.Descripcion,
				reac.IdCuestionario
				FROM dbo.tGRLreactivos reac  WITH(NOLOCK) 
				LEFT JOIN dbo.tCATlistasD cat  WITH(NOLOCK) 
					ON cat.IdListaD = reac.IdListaDcategoria
						AND cat.IdListaD<>0
				LEFT JOIN dbo.tCTLtiposD tipo  WITH(NOLOCK) 
					ON tipo.IdTipoD = reac.IdTipoDreactivo
				WHERE reac.IdCuestionario=@IdCuestionario
					AND reac.IdEstatus=1
		RETURN 1
	END 

	IF @TipoOperacion='PyR'
	BEGIN
		SELECT c.IdCuestionario,
               c.IdReactivo,
               c.IdTipoDreactivo,
               c.TipoReactivo,
               c.Enunciado,
               c.IdRespuesta,
               c.Respuesta,
               c.Elegida 
		FROM  dbo.fnSCSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) c

		RETURN 1
	END

	IF @TipoOperacion='RESPUSR'
	BEGIN
				/*  (◕ᴥ◕)    JCA.22/08/2023.07:03 p. m. Nota: Respuestas del Socio  */
				SELECT 
				respU.Id,
				respU.IdCuestionario,
				respU.IdReactivo,
				respU.IdRespuesta
				FROM dbo.tGRLrespuestasCuestionario respU  WITH(NOLOCK) 
				INNER JOIN  dbo.tGRLrespuestas resp  WITH(NOLOCK) 
					ON resp.IdRespuesta = respU.IdRespuesta
				INNER JOIN dbo.tGRLreactivos reac  WITH(NOLOCK) 
					ON reac.IdReactivo = resp.IdReactivo
				WHERE respU.IdSocio=@IdSocio

		RETURN 1
	END 

END
GO







