
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDpersonasActualizadasRangoFechas')
BEGIN
	DROP FUNCTION fnPLDpersonasActualizadasRangoFechas
	SELECT 'fnPLDpersonasActualizadasRangoFechas BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDpersonasActualizadasRangoFechas(
@pFechaInicial AS DATE,
@pFechaFinal	AS DATE
)
RETURNS @PersonasActualizadas TABLE(
	Folio						INT,
	Nombre						VARCHAR(250),
	TipoOperacion				VARCHAR(30),
	Actualizacion				DATE,
	Alta						DATETIME,
	Usuario						VARCHAR(40),
	IdActualizacionPersonaE		INT,
	IdOperacion					INT
)
AS
BEGIN

	INSERT INTO @PersonasActualizadas
    SELECT Actualizacion.Folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           Actualizacion.Fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		   [IdActualizacionPersonaE] =  Actualizacion.IdActualizacionPersonaE,Actualizacion.IdTipoOperacion
    FROM dbo.tGRLactualizacionPersonasE Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuario
    WHERE Actualizacion.Fecha BETWEEN @pFechaInicial AND @pFechaFinal


    INSERT INTO @PersonasActualizadas
    SELECT Actualizacion.Folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           Actualizacion.Fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		   [IdActualizacionPersonaE] = Actualizacion.IdActualizacionDomicilioE,Actualizacion.IdTipoOperacion
    FROM dbo.tGRLactualizacionDomiciliosE Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuario
    WHERE Actualizacion.Fecha BETWEEN @pFechaInicial AND @pFechaFinal

    INSERT INTO @PersonasActualizadas
    SELECT Actualizacion.Folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           Actualizacion.Fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		    [IdActualizacionPersonaE] = Actualizacion.IdActualizacionReferenciasPersonalesE,Actualizacion.IdTipoOperacion
    FROM dbo.tGRLactualizacionReferenciasPersonalesE Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuario
    WHERE Actualizacion.Fecha BETWEEN @pFechaInicial AND @pFechaFinal

	INSERT INTO @PersonasActualizadas
    SELECT Actualizacion.Folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           Actualizacion.Fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		    [IdActualizacionPersonaE] = Actualizacion.IdActualizacionPersonaMoralE,Actualizacion.IdTipoOperacion
    FROM dbo.tGRLactualizacionPersonasMoralesE Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuario
    WHERE Actualizacion.Fecha BETWEEN @pFechaInicial AND @pFechaFinal

	INSERT INTO @PersonasActualizadas
    SELECT Actualizacion.Folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           Actualizacion.Fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		    [IdActualizacionPersonaE] = Actualizacion.IdActualizacionContactoPersonaMoralE,Actualizacion.IdTipoOperacion
    FROM dbo.tGRLactualizacionContactosPersonasMoralesE Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuario
    WHERE Actualizacion.Fecha BETWEEN @pFechaInicial AND @pFechaFinal
	
	INSERT INTO @PersonasActualizadas
    SELECT DISTINCT Actualizacion.FolioActualizacion AS folio,
           Personas.Nombre,
           [TipoOperacion] = TipoOperacion.Descripcion,
           CAST(Actualizacion.Alta AS DATE) AS fecha,
           Actualizacion.Alta,
           Usuario.Usuario,
		    [IdActualizacionPersonaE] = 0,Actualizacion.IdTipoOperacion
    FROM dbo.tPERhuellasDigitalesPersonaActualizaciones Actualizacion WITH (NOLOCK)
        JOIN dbo.tGRLpersonas Personas WITH (NOLOCK)
            ON Personas.IdPersona = Actualizacion.IdPersona
        JOIN dbo.tCTLtiposOperacion TipoOperacion WITH (NOLOCK)
            ON TipoOperacion.IdTipoOperacion = Actualizacion.IdTipoOperacion
        JOIN dbo.tCTLusuarios Usuario WITH (NOLOCK)
            ON Usuario.IdUsuario = Actualizacion.IdUsuarioAlta
    WHERE CAST(Actualizacion.Alta AS DATE) BETWEEN @pFechaInicial AND @pFechaFinal
	
	RETURN; 
END;

GO

