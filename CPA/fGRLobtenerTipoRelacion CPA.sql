SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO





 ALTER FUNCTION [dbo].[fGRLobtenerTipoRelacion] 
(
	-- Add the parameters for the function here
	@IdPersona1 as int = 0,
	@IdPersona2	as int = 0,
	@IdRegla	as int = 0
)
RETURNS INT
	AS
BEGIN
	
	RETURN 0;

	IF dbo.fGRLtienePermiso(@IdPersona1)=0
		RETURN 0;

	-- Es la misma persona
	IF @IdPersona1=@IdPersona2 RETURN 3

	-- Relaciones personales en el Socio
	IF Exists(	SELECT r.IdReferenciaPersonal 
				FROM tSCSpersonasFisicasReferencias r WITH (NOLOCK)
				INNER JOIN dbo.tCTLestatusActual	e WITH (NOLOCK) ON e.IdEstatusActual = r.IdEstatusActual
				WHERE e.IdEstatus=1 AND
						((r.RelReferenciasPersonales=@IdPersona1 AND r.IdPersona=@IdPersona2) OR (r.RelReferenciasPersonales=@IdPersona2 AND r.IdPersona=@IdPersona1)) AND
						r.IdTipoD in (289, 290, 291, 292)
			)
		RETURN 1

	-- Relaciones personales en las Cuentas (Beneficiarios y Cotitulares)
	IF EXISTS(SELECT r.IdReferenciaPersonal
			  FROM tSCSpersonasFisicasReferencias r WITH (NOLOCK)
			  JOIN  tAYCreferenciasAsignadas	  a WITH (NOLOCK) ON r.IdReferenciaPersonal=a.IdReferenciaPersonal
			  WHERE a.IdEstatus = 1 AND
						((r.RelReferenciasPersonales=@IdPersona1 AND r.IdPersona=@IdPersona2) OR(r.RelReferenciasPersonales=@IdPersona2 AND r.IdPersona=@IdPersona1)) AND
						(a.EsCotitular=1 or a.EsBeneficiario=1)
			)
		RETURN 2

		IF NOT @IdRegla = 0 
		BEGIN			-- Relacion entre la persona del crédito y las reglas
			IF EXISTS(SELECT PersonaIdPersona FROM vAUTreglasPersonaAutorizadora WITH (NOLOCK) WHERE PersonaIdPersona = @IdPersona2)
			RETURN 4
		END

	RETURN 0
END






GO

