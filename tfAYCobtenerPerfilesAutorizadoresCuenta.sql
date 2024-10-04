

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tfAYCobtenerPerfilesAutorizadoresCuenta')
BEGIN
	DROP FUNCTION dbo.tfAYCobtenerPerfilesAutorizadoresCuenta
	SELECT 'tfAYCobtenerPerfilesAutorizadoresCuenta BORRADO' AS info
END
GO

CREATE FUNCTION dbo.tfAYCobtenerPerfilesAutorizadoresCuenta(
@IdCuenta INT
)
RETURNS @tAutorizadores TABLE (
    IdCuenta INT,
	IdSolicitud	INT, 
	IdSolicitudD	INT,
	Etapa	INT, 
	Usuario	VARCHAR(40),
	Perfil  VARCHAR(80)
)
AS
BEGIN
    DECLARE @IdSolicitud AS INT

	SELECT @IdSolicitud=c.IdSolicitud
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	WHERE c.IdCuenta=@IdCuenta 

	DECLARE @SolicitudesD AS TABLE
	(
		[IdSolicitudD] INT,
		[IdSolicitud] INT,
		[Fecha] DATE,
		[Etapa] INT,
		[IdUsuario] INT,
		IdEstatusSolicitud	INT,
		Alta DATE
	)

	DECLARE @SolicitudesDAutorizacion AS TABLE(
		IdSolicitudD INT,
		Etapa	int	
	)

	INSERT INTO @SolicitudesD
	SELECT 
	sd.IdSolicitudD, sd.IdSolicitud,sd.Fecha, sd.Etapa, sd.IdUsuario, sd.IdEstatusSolicitud, sd.Alta
	FROM dbo.tAUTsolicitudesD sd  WITH(NOLOCK) 
	WHERE sd.IdEstatus=1
		AND sd.IdSolicitudD<>0
			AND sd.IdSolicitud=@IdSolicitud

	INSERT INTO @SolicitudesDAutorizacion
	SELECT 
	MAX(sd.IdSolicitudD) AS IdSolicitudD, sd.Etapa
	FROM @SolicitudesD sd 
	GROUP BY sd.Etapa

	INSERT @tAutorizadores
	SELECT 
	@IdCuenta, sd.IdSolicitud, sd.IdSolicitudD,sd.Etapa, u.Usuario,perfil.Descripcion 
	FROM @SolicitudesDAutorizacion sda
	INNER JOIN @SolicitudesD sd
		ON sd.IdSolicitudD = sda.IdSolicitudD
	INNER JOIN (
		SELECT ss.IdUsuario, ss.FechaTrabajo, MAX(ss.IdPerfil) AS IdPerfil
		FROM dbo.tCTLsesiones ss  WITH(NOLOCK) 		
		GROUP BY ss.IdUsuario, ss.FechaTrabajo
	) sesion
		ON sesion.IdUsuario = sd.IdUsuario
			AND sesion.FechaTrabajo=sd.Alta
	INNER JOIN dbo.tCATperfiles perfil  WITH(NOLOCK) 
			ON perfil.IdPerfil = sesion.IdPerfil
	INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
		ON u.IdUsuario = sd.IdUsuario


    RETURN;
END;
GO



