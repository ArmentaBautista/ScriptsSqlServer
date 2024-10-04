

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vPLDusuariosLogin')
BEGIN
	DROP VIEW vPLDusuariosLogin
	DELETE FROM dbo.tPLDobjetosModulo WHERE Nombre='vPLDusuariosLogin'
	SELECT 'vPLDusuariosLogin BORRADO' AS info
END
GO

CREATE VIEW vPLDusuariosLogin
AS

	SELECT u.IdUsuario,u.Usuario,u.Llave,u.LlaveAutorizacion,u.IdRelPerfiles 
	FROM dbo.tCTLusuarios u  WITH(NOLOCK)
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = u.IdEstatusActual
			AND ea.IdEstatus=1

GO


INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('vPLDusuariosLogin')
