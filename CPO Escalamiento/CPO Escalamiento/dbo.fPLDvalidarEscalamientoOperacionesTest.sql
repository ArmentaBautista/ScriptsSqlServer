
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fPLDvalidarEscalamientoOperacionesTEST')
BEGIN
	DROP FUNCTION fPLDvalidarEscalamientoOperacionesTEST
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fPLDvalidarEscalamientoOperacionesTEST] 
	(
		@IdSocio AS INTEGER,
		@fecha AS DATE ,
		@Monto AS numeric(18,2)
	)
	RETURNS bit
	AS
	BEGIN
		
		--return 0 
		IF @IdSocio!=0
		BEGIN
        
			DECLARE @EsPersonaMoral AS BIT=0
			DECLARE @ConActividadEmpresarial AS BIT=0
			DECLARE @MontoSuma AS NUMERIC(18,2)=0

			DECLARE @MontoPersonasFisicas AS NUMERIC(18,2)=ISNULL((SELECT valor FROM dbo.tPLDconfiguracion c With (nolock) WHERE c.IdParametro=-29),0)
			DECLARE @MontoPersonasMorales AS NUMERIC(18,2)=ISNULL((SELECT valor FROM dbo.tPLDconfiguracion c With (nolock) WHERE c.IdParametro=-30),0)

			---Ver si es persona moral o fisica
			SELECT @EsPersonaMoral=p.EsPersonaMoral,@ConActividadEmpresarial=c.ExentaIVA
			FROM dbo.tSCSsocios c With (nolock) 
			JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona = c.IdPersona
			WHERE c.IdSocio=@IdSocio

			-- CONSULTA DEL MONTO ACUMULADO DEL SOCIO Y PERIODO
			DECLARE @idPeriodo AS INT=0
			SELECT @idPeriodo= p.idperiodo FROM IERP_OBL.dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Numero<>13 and @fecha >= p.Inicio AND @fecha<=p.Fin
		
			SELECT @MontoSuma=acu.AcumuladoMesCalendario
			FROM iERP_OBL_HST.dbo.tPLDDacumuladoDepositosEfectivoMesCalendario acu
			WHERE acu.IdSocio=@IdSocio AND IdPeriodo=@idPeriodo
		 

			-- Validación
			IF (@EsPersonaMoral=0 AND @ConActividadEmpresarial=0)
			BEGIN
			
				IF ( ISNULL(@MontoSuma,0)+@Monto >@MontoPersonasFisicas)
				RETURN 1
			END

			IF ( (@EsPersonaMoral=0 AND @ConActividadEmpresarial=1) OR @EsPersonaMoral=1)
			BEGIN
			
				IF (ISNULL(@MontoSuma,0)+@Monto>@MontoPersonasMorales)
				RETURN 1
			END
		
			RETURN 0 	
		END

        RETURN 0
		
	END

 



GO

