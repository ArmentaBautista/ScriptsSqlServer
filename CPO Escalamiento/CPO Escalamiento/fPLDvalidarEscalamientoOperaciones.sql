SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO




ALTER FUNCTION [dbo].[fPLDvalidarEscalamientoOperaciones] 
	(
		@IdSocio AS INTEGER,
		@fecha AS DATE ,
		@Monto AS numeric(18,2)
	)
	RETURNS bit
	AS
	BEGIN
		
		return 0 
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

		SELECT @MontoSuma=SUM(t.Monto) FROM dbo.tSDOtransaccionesD t With (nolock) 
		JOIN dbo.tGRLoperaciones o With (nolock) ON o.IdOperacion = t.IdOperacion
		WHERE o.IdSocio=@idsocio AND t.EsCambio=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND o.IdEstatus!=18 AND t.IdMetodoPago IN (-2) AND t.IdTipoSubOperacion=500
		AND o.Fecha>=DATEADD(MM, DATEDIFF(MM,0,@fecha), 0) 

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

