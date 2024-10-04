
-- 3.07 pPLDevaluacionDeRiesgoDesdeErprise

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDevaluacionDeRiesgoDesdeErprise')
BEGIN
	DROP PROC dbo.pPLDevaluacionDeRiesgoDesdeErprise
	SELECT 'pPLDevaluacionDeRiesgoDesdeErprise BORRADO' AS info
END
GO


CREATE  PROC [dbo].pPLDevaluacionDeRiesgoDesdeErprise
	@IdPersona AS INTEGER=0,
	@IdSesion AS INTEGER=0,
	@Bloqueado AS BIT= 0  OUTPUT
AS 

	SET NOCOUNT ON 
	SET XACT_ABORT ON

	BEGIN
		DECLARE @fecha AS DATETIME=GETDATE()
		DECLARE @IdSocio AS INT=0
		DECLARE @IdListaDnivelRiesgoSocio AS INT=0
		DECLARE @Calificacion AS NUMERIC(13,2)=0
		DECLARE @IdListaDnivelRiesgoSocioActual AS INT=0
		
		SELECT @IdSesion=IdSesion
		FROM dbo.vSISsesion

		SELECT TOP 1 @IdSocio=s.IdSocio,@IdListaDnivelRiesgoSocioActual=ISNULL(s.IdListaDnivelRiesgo,0)
		FROM dbo.tSCSsocios s WITH (NOLOCK) 
		WHERE s.IdPersona=@IdPersona

		IF (@IdSocio!=0)
		BEGIN

		EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = @IdSocio,                 
                                @pNoSocio = '',                
                                @pEvaluacionMasiva = 0,     
                                @pFechaTrabajo = @fecha, 
                                @pDEBUG = 0                 

		DECLARE @IdNivelRiesgoSocio AS INT=0
		DECLARE @NivelRiesgoSocio AS VARCHAR(32)

		SELECT TOP 1
		@IdNivelRiesgoSocio = fin.NivelDeRiesgo,
		@NivelRiesgoSocio = fin.NivelDeRiesgoDescripcion,
		@Calificacion=fin.Calificacion
		FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales fin  WITH(NOLOCK) 
		WHERE fin.IdEstatus=1
			AND fin.IdSocio=@IdSocio
		ORDER BY fin.IdEvaluacionRiesgo DESC

		SELECT @IdListaDnivelRiesgoSocio = CASE @IdNivelRiesgoSocio
											WHEN 1 THEN -46
											WHEN 2 THEN -45
											WHEN 3 THEN -44
											ELSE 0 END

		UPDATE s SET s.IdListaDnivelRiesgo=@IdListaDnivelRiesgoSocio,
					 s.DescripcionNivelRiesgo=@NivelRiesgoSocio,
					 s.CalificacionNivelRiesgo=TRY_CAST(@Calificacion AS INT)
		FROM dbo.tSCSsocios s  WITH (NOLOCK)
		WHERE s.IdSocio=@IdSocio	
		
		IF (@IdListaDnivelRiesgoSocio =-44)	
		BEGIN
			SET @Bloqueado=1
			
			INSERT INTO dbo.tPLDoperaciones(IdPersona, IdTipoDoperacionPLD, IdEstatusAtencion, Monto, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDDominio, Texto,  TipoIndicador, IdSocio, GeneradaDesdeSistema, IdInusualidad,IdSesion,IdCuenta)
			SELECT @IdPersona,1593,46,0,1,-1,@fecha,-1,GETDATE(),1598,'NIVEL DE RIESGO DEL SOCIO: ALTO','NIVEL DE RIESGO DEL SOCIO: ALTO',@IdSocio,1,21,@IdSesion,0
		
			IF @IdListaDnivelRiesgoSocioActual <>-44
			BEGIN
				INSERT INTO dbo.tGRLpersonasBloqueadas (IdSocio,IdPersona,Motivo,IdTipoDbloqueo,IdEstatus,IdSesion,IdSesionCambio,Alta,Cambio)
				VALUES(@IdSocio,@IdPersona,'Socio Bloqueado ALTO RIESGO',2877,1,@IdSesion,@IdSesion,GETDATE(),GETDATE())
			END
        END

	 END
			
	 END;
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pPLDevaluacionDeRiesgoDesdeErprise')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pPLDevaluacionDeRiesgoDesdeErprise')
END
GO

