
/* JCA.23/4/2024.02:36 
Nota: Modulo Auditoria. Registra la actividad del usuario en registros del sistema
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAUDregistrarActividadRecurso')
BEGIN
	DROP PROC pAUDregistrarActividadRecurso
	SELECT 'pAUDregistrarActividadRecurso BORRADO' AS info
END
GO

CREATE PROC dbo.pAUDregistrarActividadRecurso
@pIdRecurso AS INT,
@pIdUsuario AS INT,
@pIdSesion AS INT
AS
BEGIN
	INSERT INTO dbo.tAUDactividadUsuariosRecursos
	(
	    IdRecurso,
	    IdUsuario,
	    IdSesion
	)
	VALUES
	(   @pIdRecurso,
	    @pIdUsuario,
	    @pIdSesion
	    )
END
GO



