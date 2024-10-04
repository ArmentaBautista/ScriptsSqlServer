

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAUDactividadRecursosUsuario')
BEGIN
	DROP PROC pCnAUDactividadRecursosUsuario
	SELECT 'pCnAUDactividadRecursosUsuario BORRADO' AS info
END
GO

CREATE PROC pCnAUDactividadRecursosUsuario
@pUsuario AS VARCHAR(30)='*',
@pRecurso AS VARCHAR(30)='*',
@pFechaInicial AS DATE='19000101',
@pFechaFinal AS DATE='19000101'
AS
BEGIN
	
	IF (@pFechaInicial='19000101' OR @pFechaFinal='19000101') 
	BEGIN
		SET @pFechaInicial=GETDATE()
		SET @pFechaFinal=GETDATE()
	END
	
	DECLARE @FiltroUsuario AS NVARCHAR(max)=''
	DECLARE @FiltroRecurso AS NVARCHAR(max)=''

	DECLARE @sql AS NVARCHAR(max)='
	SELECT 
	u.Usuario,
	[Perfil]	= p.Descripcion,
	[Recurso]	= r.Descripcion,
	s.IP,
	s.Host,
	s.FechaTrabajo,
	[FechaUso]	= aur.Fecha,
	[HoraUso]	= aur.Hora
	FROM dbo.tAUDactividadUsuariosRecursos aur  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLrecursos r  WITH(NOLOCK) 
		ON r.IdRecurso = aur.IdRecurso
	INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
		ON u.IdUsuario = aur.IdUsuario
	INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK) 
		ON s.IdSesion = aur.IdSesion
	INNER JOIN dbo.tCATperfiles p  WITH(NOLOCK) 
		ON p.IdPerfil = s.IdPerfil
	WHERE aur.Fecha BETWEEN ''' + CAST(@pFechaInicial AS NVARCHAR) + ''' AND ''' + CAST(@pFechaFinal AS NVARCHAR) + ''''

	IF @pUsuario<>'*'
		SET @FiltroUsuario=' AND u.usuario=''' + @pUsuario + ''''

	IF @pRecurso<>'*'
		SET @FiltroRecurso=' AND r.Descripcion like ''%' + @pRecurso + '%'''

	SET @sql = @sql + @FiltroUsuario + @FiltroRecurso

	--PRINT @sql
	EXEC sp_executesql @sql

END
GO





