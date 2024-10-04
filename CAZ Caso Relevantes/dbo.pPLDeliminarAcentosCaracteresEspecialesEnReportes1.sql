SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROC pPLDeliminarAcentosCaracteresEspecialesEnReportes
@TipoOperacion VARCHAR(20),
@IdPeriodo INT = 0
AS
BEGIN
	/*
	Degug
	SELECT @TipoOperacion, @IdPeriodo
	RETURN
	*/
	
	IF (@TipoOperacion = 'REL-XLS')
	BEGIN
		UPDATE dbo.tPLDoperacionesRelavantes
		SET Domicilio = UPPER(Domicilio),
			Colonia = UPPER(Colonia)
		WHERE IdPeriodo = @IdPeriodo

		--SELECT rfc, Domicilio FROM dbo.tPLDoperacionesRelavantes  WITH(NOLOCK) WHERE RFC='CTE160926MF6'

		UPDATE dbo.tPLDoperacionesRelavantes
		SET RazonSocial = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(RazonSocial),
			Nombre = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(Nombre),
			Paterno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(Paterno),
			Materno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(Materno),
			Domicilio = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(Domicilio),
			Colonia = dbo.fnPLDreemplazarAcentosCaracteresEspeciales(Colonia)
		WHERE IdPeriodo = @IdPeriodo
	
	--SELECT rfc, Domicilio FROM dbo.tPLDoperacionesRelavantes  WITH(NOLOCK) WHERE RFC='CTE160926MF6'

		UPDATE dbo.tPLDoperacionesRelavantes
		SET Domicilio =  SUBSTRING(Domicilio, 1, 55)
		WHERE IdPeriodo = @IdPeriodo

		RETURN
    END

	IF (@TipoOperacion = 'INU-XLS')
	BEGIN
		UPDATE dbo.tPLDoperacionesInusuales
		SET RazonSocial = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (RazonSocial),
        Nombre = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Nombre),
        Paterno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Paterno),
        Materno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Materno),
        Domicilio = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Domicilio),
        Colonia = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Colonia),
        NombreAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (NombreAgente),
        PaternoAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (PaternoAgente),
        MaternoAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (MaternoAgente),
        SujetoObligadoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (SujetoObligadoPersonaRelacionada),
        NombrePersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (NombrePersonaRelacionada),
        PaternoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (PaternoPersonaRelacionada),
        MaternoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (MaternoPersonaRelacionada)
    WHERE IdPeriodo = @IdPeriodo;

		RETURN
    END

	IF (@TipoOperacion = 'PRE-XLS')
	BEGIN
		UPDATE dbo.tPLDoperacionesPreocupantes
		SET RazonSocial = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (RazonSocial),
        Nombre = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Nombre),
        Paterno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Paterno),
        Materno = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Materno),
        Domicilio = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Domicilio),
        Colonia = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (Colonia),
        NombreAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (NombreAgente),
        PaternoAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (PaternoAgente),
        MaternoAgente = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (MaternoAgente),
        SujetoObligadoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (SujetoObligadoPersonaRelacionada),
        NombrePersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (NombrePersonaRelacionada),
        PaternoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (PaternoPersonaRelacionada),
        MaternoPersonaRelacionada = dbo.fnPLDreemplazarAcentosCaracteresEspeciales (MaternoPersonaRelacionada)
    WHERE IdPeriodo = @IdPeriodo;


		RETURN
    END

END
GO

