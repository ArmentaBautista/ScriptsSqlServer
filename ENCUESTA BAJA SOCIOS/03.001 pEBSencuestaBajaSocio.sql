
/* JCA.18/4/2024.21:24 
Nota: Procedimiento que soporta la operación del módulo de encuestas para la baja de Socios
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEBSencuestaBajaSocio')
BEGIN
	DROP PROC pEBSencuestaBajaSocio
	SELECT 'pEBSencuestaBajaSocio BORRADO' AS info
END
GO

CREATE PROC pEBSencuestaBajaSocio
@pTipoOperacion			VARCHAR(24)='',
@pIdEncuestaBajaSocio	INT=0 OUTPUT,
@pIdSocio				INT=0,
@pFecha					DATE='19000101',
@pRespuestas			tpRespuestasEncuestaBajaSocio NULL READONLY,
@pFechaInicial			DATE='19000101',
@pFechaFinal			DATE='19000101'
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
			FROM tEBSencuestaBajaSocios e WHERE e.IdSocio=@IdSocio

			UPDATE r SET r.IdEstatus=2
			FROM tGRLrespuestasCuestionario r WHERE r.IdCuestionario=@IdCuestionario 
				AND r.IdTipoDdominio=@IdTipoDdominio
				AND r.IdSocio=@IdSocio

			/* ฅ^•ﻌ•^ฅ   JCA.24/08/2023.11:18 a. m. Nota: Primero insertamos la encuesta para el ID   */
			INSERT INTO dbo.tEBSencuestaBajaSocios (IdSocio,Fecha,IdSesion)
			SELECT @IdSocio, @Fecha,@IdSesion 
			
			SET @IdEncuestaBajaSocio=SCOPE_IDENTITY();

			/*  (◕ᴥ◕)    JCA.24/08/2023.11:48 a. m. Nota: Insertar plantilla de respuestas  */
			INSERT INTO dbo.tGRLrespuestasCuestionario
			(IdReactivo,IdCuestionario,IdTipoDdominio,IdDominio,IdEstatus,IdSocio)
			SELECT 
			t.IdReactivo,
            t.IdCuestionario,
            t.IdTipoDdominio,
            t.IdEncuestaBajaSocio,
            t.IdEstatus,
            t.IdSocio 
			FROM (
				SELECT 
				pr.IdReactivo,
				pr.IdCuestionario,
				[IdTipoDdominio]		= @IdTipoDdominio,
				[IdEncuestaBajaSocio]	= @IdEncuestaBajaSocio,
				[IdEstatus]				= 1,
				[IdSocio]				= @IdSocio
				FROM dbo.fnEBSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) pr
				) AS t
			GROUP BY
				t.IdReactivo,
				t.IdCuestionario,
				t.IdTipoDdominio,
				t.IdEncuestaBajaSocio,
				t.IdEstatus,
				t.IdSocio 
	
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
			FROM dbo.fnEBSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) pyr

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
		FROM  dbo.fnEBSpreguntasYrespuestasEncuestaBajaSocio(@IdCuestionario) c

		RETURN 1
	END

	IF @TipoOperacion='ENC_X_SOC'
	BEGIN
				SELECT 
				[Sucursal] = suc.Descripcion,
				enc.Fecha,
				[Folio] = enc.IdEncuestaBajaSocios,
				[NoSocio]	= sc.Codigo,
				p.Nombre,
				[Pregunta]	= reac.Enunciado,
				[Respuesta]	= r.TextoRespuesta
				FROM dbo.tGRLrespuestasCuestionario r  WITH(NOLOCK) 
				INNER JOIN dbo.tEBSencuestaBajaSocios enc  WITH(NOLOCK)
					ON enc.IdEncuestaBajaSocios=r.IdDominio
						and enc.IdEstatus=1
				INNER JOIN dbo.tGRLreactivos reac  WITH(NOLOCK) 
					ON reac.IdReactivo = r.IdReactivo
				INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
					ON sc.IdSocio = enc.IdSocio
						AND sc.IdSocio = @IdSocio
				INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
					ON p.IdPersona = sc.IdPersona
				INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
					ON suc.IdSucursal = sc.IdSucursal
				WHERE r.IdEstatus=1 
					AND r.IdTipoDdominio=@IdTipoDdominio
				ORDER BY suc.IdSucursal, enc.IdEncuestaBajaSocios

		RETURN 1
	END 

	IF @TipoOperacion='ENC_X_FECHA'
	BEGIN
		IF @pFechaInicial='19000101' OR @pFechaFinal='19000101'
		BEGIN
			RAISERROR (N'Se requieren parametros de Socio y Fecha', 16, 1);
			RETURN -1
		END

		SELECT
		[Sucursal] = suc.Descripcion,
		enc.Fecha,
		[Folio] = enc.IdEncuestaBajaSocios,
		[NoSocio]	= sc.Codigo,
		p.Nombre,
		[Pregunta]	= reac.Enunciado,
		[Respuesta]	= r.TextoRespuesta
		FROM dbo.tGRLrespuestasCuestionario r  WITH(NOLOCK) 
		INNER JOIN dbo.tEBSencuestaBajaSocios enc  WITH(NOLOCK)
			ON enc.IdEncuestaBajaSocios=r.IdDominio
				and enc.IdEstatus=1
				AND enc.Fecha BETWEEN @pFechaInicial and @pFechaFinal
		INNER JOIN dbo.tGRLreactivos reac  WITH(NOLOCK) 
			ON reac.IdReactivo = r.IdReactivo
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = enc.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
					ON suc.IdSucursal = sc.IdSucursal
		WHERE r.IdEstatus=1 
					AND r.IdTipoDdominio=@IdTipoDdominio
		ORDER BY suc.IdSucursal, enc.IdEncuestaBajaSocios
		
		RETURN 1
    END


END
GO
SELECT 'pEBSencuestaBajaSocio CREADO' AS info
GO







