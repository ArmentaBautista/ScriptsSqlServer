


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnADMbitacoraCambiosUsuario')
BEGIN
	DROP PROC pCnADMbitacoraCambiosUsuario
	SELECT 'pCnADMbitacoraCambiosUsuario BORRADO' AS info
END
GO

CREATE PROC pCnADMbitacoraCambiosUsuario
@usuario AS VARCHAR(50)='*',
@fechaInicio AS DATE='19000101',
@fechaFin AS DATE='19000101'
AS
BEGIN
			IF @usuario='' or @usuario='*' OR @usuario IS NULL
			BEGIN
				RAISERROR('Debe proporcionar el nombre de un usuario válido', 18, 1)
				RETURN -1
			END
			
			IF @fechaFin='19000101'
				SET @fechaFin=GETDATE();

			SELECT us.Usuario, b.Fecha, b.Hora, b.Tabla, b.PK,b.IdRegistro,b.Campo,b.ValorOriginal,
			b.ValorNuevo,b.Host,b.IP,b.ApplicationName
			FROM tadmbitacora b  WITH(NOLOCK)
			INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion = b.IdSesion
			INNER JOIN dbo.tCTLusuarios us  WITH(NOLOCK) ON us.IdUsuario = ss.IdUsuario
															AND us.Usuario=@usuario
			WHERE b.Fecha BETWEEN @fechaInicio AND @fechaFin
			ORDER BY b.Fecha ASC

END
