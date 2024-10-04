

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pATNSoperaciones')
BEGIN
	DROP PROC pATNSoperaciones
	SELECT 'pATNSoperaciones BORRADO' AS info
END
GO

CREATE PROC pATNSoperaciones
@pTipoOperacion			VARCHAR(16)	 ,
@pIdOperacion 			INT			 OUTPUT,
@pFecha					DATE		 ='19000101',
@pIdEmpleadoResponsable	INT			 =0,
@pIdSucursal			INT			 =0,
@pIdTipoAtencion		INT			 =0,
@pIdSocio				INT			 =0,
@pIdCuenta				INT			 =0,
@pIdOperacionReportada	INT			 =0,
@pMontoReclamado		NUMERIC(13,2)=0,
@pIdMedioNotificacion	INT			 =0,
@pOtroMedioNotificacion	VARCHAR(24)	 ='',
@pIdTipoCausa			INT			 =0,
@pIdSubtipoCausa		INT			 =0,
@pDeclaracion			VARCHAR(512) =0,
@pCaptcha				VARCHAR(6)	 =''		 
AS
BEGIN
	/* ฅ^•ﻌ•^ฅ   JCA.27/08/2023.03:44 a. m. Nota: Variables locales   */
	DECLARE @TipoOperacion			VARCHAR(16)	  = @pTipoOperacion			
	DECLARE @IdOperacion 			INT			  = @pIdOperacion 			
	DECLARE @Fecha					DATE		  = @pFecha					
	DECLARE @IdEmpleadoResponsable	INT			  = @pIdEmpleadoResponsable	
	DECLARE @IdSucursal				INT			  = @pIdSucursal			
	DECLARE @IdTipoAtencion			INT			  = @pIdTipoAtencion		
	DECLARE @IdSocio				INT			  = @pIdSocio				
	DECLARE @IdCuenta				INT			  = @pIdCuenta				
	DECLARE @IdOperacionReportada	INT			  = @pIdOperacionReportada	
	DECLARE @MontoReclamado			NUMERIC(13,2) = @pMontoReclamado		
	DECLARE @IdMedioNotificacion	INT			  = @pIdMedioNotificacion	
	DECLARE @OtroMedioNotificacion	VARCHAR(24)	  = @pOtroMedioNotificacion	
	DECLARE @IdTipoCausa			INT			  = @pIdTipoCausa			
	DECLARE @IdSubtipoCausa			INT			  = @pIdSubtipoCausa		
	DECLARE @Declaracion			VARCHAR(512)  = @pDeclaracion			
	DECLARE @Captcha				VARCHAR(6)	  = @pCaptcha				
	DECLARE @IdSesion 				INT			  = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 

	IF @TipoOperacion='ADD'
	BEGIN	
			INSERT INTO tATNSoperaciones (Fecha,IdEmpleadoResponsable,IdSucursal,IdTipoAtencion,IdSocio,IdCuenta,IdOperacionReportada,MontoReclamado,
			IdMedioNotificacion,OtroMedioNotificacion,IdTipoCausa,IdSubtipoCausa,Declaracion,Captcha,IdSesion)
			SELECT @Fecha,@IdEmpleadoResponsable,@IdSucursal,@IdTipoAtencion,@IdSocio,@IdCuenta,@IdOperacionReportada,@MontoReclamado			
					,@IdMedioNotificacion,@OtroMedioNotificacion,@IdTipoCausa,@IdSubtipoCausa,@Declaracion,@Captcha,@IdSesion 	
					
			SET @IdOperacion=SCOPE_IDENTITY();
		RETURN 1
	END		

END												   
GO