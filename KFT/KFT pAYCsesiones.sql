

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCsesiones')
BEGIN
	DROP PROC pAYCsesiones
	SELECT 'pAYCsesiones BORRADO' AS info
END
GO

CREATE PROC pAYCsesiones
	@FechaInicial AS DATE = '19000101',
	@FechaFinal AS DATE = '19000101',
	@Usuario AS VARCHAR(30)='*'
AS 
BEGIN
		
		SELECT usuario.Usuario, persona.Nombre, sesion.FechaTrabajo,sesion.IP,sesion.Host,sesion.Inicio,sesion.Fin,sesion.Version
		FROM dbo.tCTLsesiones sesion With(Nolock)
		INNER JOIN dbo.tCTLusuarios usuario With(Nolock) ON usuario.IdUsuario = sesion.IdUsuario
		INNER JOIN dbo.tGRLpersonasFisicas perfisica With(Nolock) ON perfisica.IdPersonaFisica = usuario.IdPersonaFisica
		INNER JOIN dbo.tGRLpersonas persona With(Nolock) ON persona.IdPersona = perfisica.IdPersona
		WHERE sesion.FechaTrabajo BETWEEN @FechaInicial AND @FechaFinal
			  AND (usuario.Usuario = @Usuario OR @Usuario = '*')
		ORDER BY sesion.FechaTrabajo DESC
END 

GO

