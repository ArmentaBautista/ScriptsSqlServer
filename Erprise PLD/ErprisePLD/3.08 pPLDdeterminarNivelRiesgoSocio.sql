
-- 3.08 pPLDdeterminarNivelRiesgoSocio

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDdeterminarNivelRiesgoSocio')
BEGIN
	DROP PROC pPLDdeterminarNivelRiesgoSocio
	SELECT 'pPLDdeterminarNivelRiesgoSocio BORRADO' AS info
END
GO

CREATE PROC dbo.pPLDdeterminarNivelRiesgoSocio
	@IdPersona AS INTEGER=0,
	@IdSesion AS INTEGER=0,
	@Bloqueado AS BIT= 0  OUTPUT
AS 

	SET NOCOUNT ON 
	SET XACT_ABORT ON

	BEGIN
		
		-- eval param

		EXEC dbo.pPLDdeterminarNivelRiesgoSocio2 @IdPersona = @IdPersona,                -- int
		                                        @IdSesion = 0,                 -- int
		                                        @Bloqueado = @Bloqueado OUTPUT -- bit



		DECLARE @fecha AS DATETIME=GETDATE()
		DECLARE @IdSocio AS INT=0
		declare @IdPeriodo AS INTEGER=0
		

		SELECT @IdSesion=IdSesion
		FROM dbo.vSISsesion
			
		
		SET @IdPeriodo=(SELECT dbo.fObtenerIdPeriodo(@Fecha))
		DECLARE @IdListaDnivelRiesgoSocio AS INT=0

		SELECT TOP 1 @IdSocio=s.IdSocio,@IdListaDnivelRiesgoSocio=ISNULL(s.IdListaDnivelRiesgo,0)
		FROM dbo.tSCSsocios s With (nolock) 
		WHERE s.IdPersona=@IdPersona
		
	IF (@IdSocio!=0)
	BEGIN
	IF NOT EXISTS(SELECT  IdSocio FROM tPLDsociosNivelRiesgo WITH(NOLOCK) WHERE IdSocio=@IdSocio)
	BEGIN
		--Se calcula el nivel de Riesgo de cada socio y se inserta en la tabla de tPLDevaluacionesNivelRiesgoSociosCAZ
		INSERT INTO dbo.tPLDevaluacionesNivelRiesgoSociosCAZ(IdSocio, Antiguedad, Socio, Geografico, Terceros, PersonasBloqueadas, SocioPPE, Vivienda, AsimiladosPPE, ActividadLaboral, ValorOrigenRecursos,
		 Transaccionalidad, ProductosServicios, CanalesDistribucion, suma, NivelRiesgo, IdPeriodo, Fecha,EsManual)
		
		SELECT IdSocio--COUNT(IdSocio)
		, Antiguedad, Socio, Geografico, Terceros,
		 PersonasBloqueadas, SocioPPE, Vivienda, AsimiladosPPE,
		 ActividadLaboral, ValorOrigenRecursos, Transaccionalidad,
		ProductosServicios, CanalesDistribucion ,
		(Antiguedad+Socio+Geografico+Terceros+PersonasBloqueadas+SocioPPE+Vivienda+AsimiladosPPE+ActividadLaboral+ValorOrigenRecursos+Transaccionalidad+ProductosServicios+CanalesDistribucion) AS suma,
		CASE WHEN (Antiguedad+Socio+Geografico+Terceros+PersonasBloqueadas+SocioPPE+Vivienda+AsimiladosPPE+ActividadLaboral+ValorOrigenRecursos+Transaccionalidad+ProductosServicios+CanalesDistribucion)  BETWEEN 0 AND 35 THEN 'BAJO'
		WHEN (Antiguedad+Socio+Geografico+Terceros+PersonasBloqueadas+SocioPPE+Vivienda+AsimiladosPPE+ActividadLaboral+ValorOrigenRecursos+Transaccionalidad+ProductosServicios+CanalesDistribucion)  BETWEEN 35.01 AND 60 THEN 'MEDIO'
		WHEN (Antiguedad+Socio+Geografico+Terceros+PersonasBloqueadas+SocioPPE+Vivienda+AsimiladosPPE+ActividadLaboral+ValorOrigenRecursos+Transaccionalidad+ProductosServicios+CanalesDistribucion)  BETWEEN 60.01 AND 9999 THEN 'ALTO' END AS NivelRiesgo
		,@IdPeriodo,@Fecha,0
		FROM fPLDdeterminarNivelRiesgo(@IdSocio)

		-----------------------------------------------------------------------------------------------
		--------Se actualiza el registro del socio que se esta actualizando----------------------------
		--------Si el socio estaba en nivel de riesgo Alto y con el nuevo calculo queda en ALto ya no se bloquea
		--------se queda con el estatus que tenia, si cambia de nievle de bajo o medio a Alto
		-------entonces si se bloquea al socio--------------------------------------------
		UPDATE s SET s.IdListaDnivelRiesgo=CASE c.NivelRiesgo
											WHEN 'BAJO' THEN -46
											WHEN 'MEDIO' THEN -45
											WHEN 'ALTO' THEN -44
											ELSE 0 END,
					 s.DescripcionNivelRiesgo=c.NivelRiesgo
					 --s.IdEstatus=iif (c.NivelRiesgo='ALTO',IIF(@IdListaDnivelRiesgoSocio=-44,s.IdEstatus,105),s.IdEstatus)
		FROM dbo.tSCSsocios s  WITH (NOLOCK) 
		JOIN dbo.tPLDevaluacionesNivelRiesgoSociosCAZ c WITH (NOLOCK) ON c.IdSocio = s.IdSocio AND c.Fecha=@fecha
		WHERE s.IdSocio=@IdSocio	
		
		-----------------------------------------------------------------------------------------------
		--------Se actualiza el registro del socio que se esta actualizando----------------------------
		-----------------------------------------------------------------------------------------------
		INSERT INTO dbo.tPLDoperaciones(IdPersona, IdTipoDoperacionPLD, IdEstatusAtencion, Monto, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDDominio, Texto,  TipoIndicador, IdSocio, GeneradaDesdeSistema, IdInusualidad,IdSesion,IdCuenta)
		SELECT s.IdPersona,1593,46,0,1,-1,@fecha,-1,GETDATE(),1598,'NIVEL DE RIESGO DEL SOCIO: ALTO','NIVEL DE RIESGO DEL SOCIO: ALTO',S.IdSocio,1,21,@IdSesion,0
		FROM dbo.tSCSsocios s  With (nolock) 
		JOIN dbo.tPLDevaluacionesNivelRiesgoSociosCAZ c With (nolock) ON c.IdSocio = s.IdSocio AND c.Fecha=@fecha
		WHERE s.IdSocio=@IdSocio and c.NivelRiesgo='ALTO' AND @IdListaDnivelRiesgoSocio=-44
		
		-----------------------------------------------------------------------------------------------------------
		SELECT @Bloqueado=IIF(c.NivelRiesgo='ALTO',IIF(@IdListaDnivelRiesgoSocio=-44,0,1),0)--IIF(c.NivelRiesgo='ALTO',1,0)
		FROM dbo.tSCSsocios s  With (nolock) 
		JOIN dbo.tPLDevaluacionesNivelRiesgoSociosCAZ c With (nolock) ON c.IdSocio = s.IdSocio AND c.Fecha=@fecha
		WHERE s.IdSocio=@IdSocio
		
		
		IF (@IdListaDnivelRiesgoSocio =-44)	
		BEGIN
			INSERT INTO dbo.tGRLpersonasBloqueadas (IdSocio,IdPersona,Motivo,IdTipoDbloqueo,IdEstatus,IdSesion,IdSesionCambio,Alta,Cambio)
			VALUES(@IdSocio,@IdPersona,'Socio Bloqueado ALTO RIESGO',2877,1,@IdSesion,@IdSesion,GETDATE(),GETDATE())
        END

		END
	 END
		
		
		
		


	 END;



GO

