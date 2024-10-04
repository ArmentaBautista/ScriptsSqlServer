

/* JCA.22/4/2024.21:39 
Nota: Módulo: Auditoria. Tabla para registrar los recursos que se lanzan desde erpise
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAUDactividadUsuariosRecursos')
BEGIN
	CREATE TABLE [dbo].[tAUDactividadUsuariosRecursos]
	(
		Id 						INT NOT NULL IDENTITY,
		IdRecurso				INT NOT NULL,
		IdUsuario				INT NOT NULL,
		IdSesion 				INT NOT NULL,
		Fecha					DATE NOT NULL DEFAULT GETDATE(),
		Hora					TIME NOT NULL DEFAULT GETDATE(),
		
		CONSTRAINT PK_tAUDactividadUsuariosRecursos_Id PRIMARY KEY(Id),
		CONSTRAINT FK_tAUDactividadUsuariosRecursos_IdRecurso FOREIGN KEY (IdRecurso) REFERENCES dbo.tCTLrecursos (IdRecurso),
		CONSTRAINT FK_tAUDactividadUsuariosRecursos_IdUsuario FOREIGN KEY (IdUsuario) REFERENCES dbo.tCTLusuarios (IdUsuario),
		CONSTRAINT FK_tAUDactividadUsuariosRecursos_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tAUDactividadUsuariosRecursos' AS info
END
ELSE 
	-- DROP TABLE tAUDactividadUsuariosRecursos
	SELECT 'tAUDactividadUsuariosRecursos Existe'
GO

