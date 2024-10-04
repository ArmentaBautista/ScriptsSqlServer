-- 04.02 tfAUDsociosConsultadosPorFecha.sql

IF (OBJECT_ID('tfAUDsociosConsultadosPorFecha') IS NOT NULL)
        BEGIN
            DROP FUNCTION dbo.tfAUDsociosConsultadosPorFecha
            SELECT 'tfAUDsociosConsultadosPorFecha BORRADO' AS info
        END
GO

CREATE FUNCTION dbo.tfAUDsociosConsultadosPorFecha(
    @pFechaInicio AS DATE='19000101',
    @pFechaFin AS DATE='19000101'
)
    RETURNS @tResultado TABLE
                        (
                            NoSocio VARCHAR(20),
                            NombreSocio VARCHAR(80),
                            FechaConsulta DATE,
                            HoraConsulta TIME,
                            Host VARCHAR(32),
                            Usuario VARCHAR(32),
                            NombnreUsuario VARCHAR(80),
                            FechaTrabajo DATE
                        )
AS
BEGIN

DECLARE @bitacora as TABLE(
    IdSocioConsultado INT PRIMARY KEY ,
    IdSocio INT
                          )

INSERT INTO @bitacora
SELECT
    IdSocioConsultado,
    IdSocio
FROM tAUDsociosConsultados sc WITH (NOLOCK)
WHERE Fecha BETWEEN @pFechaInicio AND @pFechaFin
    AND sc.IdSocio<>0

INSERT INTO @bitacora
SELECT
    sc.IdSocioConsultado,
    s.IdSocio
FROM tAUDsociosConsultados sc WITH (NOLOCK)
INNER JOIN tSCSsocios s WITH (NOLOCK)
    ON sc.NoSocio = s.Codigo
        AND sc.IdSocio=0
WHERE Fecha BETWEEN @pFechaInicio AND @pFechaFin

INSERT INTO @tResultado
SELECT
sc.Codigo AS NoSocio,
p.Nombre AS NombreSocio,
consultados.Fecha AS FechaConsulta,
consultados.Hora AS HoraConsulta,
ss.Host,
u.Usuario,
p.Nombre AS NombnreUsuario,
ss.FechaTrabajo
FROM @bitacora b
INNER JOIN tAUDsociosConsultados consultados WITH (NOLOCK)
    ON consultados.IdSocioConsultado=b.IdSocioConsultado
INNER JOIN tCTLsesiones ss  WITH(NOLOCK)
  ON ss.IdSesion = consultados.IdSesion
INNER JOIN tSCSsocios sc  WITH(NOLOCK)
  ON sc.IdSocio = b.IdSocio
INNER JOIN tGRLpersonas persoc WITH (NOLOCK)
    ON sc.IdPersona = persoc.IdPersona
INNER JOIN tCTLusuarios u  WITH(NOLOCK)
  ON ss.IdUsuario = u.IdUsuario
INNER JOIN tGRLpersonas p WITH (NOLOCK)
    ON p.IdPersona=u.IdPersonaFisica

    RETURN;
END;
GO


