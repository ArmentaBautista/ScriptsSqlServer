
-- 0.02 tPLDactualizacionesPerfilTransaccionalD

/* @^..^@   JCA.05/02/2024.09:50 p. m. Nota: Tabla para guardar todas las actualizaciones del perfil transaccional que se van haciendo sobre el socio   */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDactualizacionesPerfilTransaccionalD')
BEGIN
	DROP TABLE tPLDactualizacionesPerfilTransaccionalD
	SELECT 'tPLDactualizacionesPerfilTransaccionalD BORRADO' AS info
END
GO

CREATE TABLE tPLDactualizacionesPerfilTransaccionalD
(
	IdActualizacionesPerfilTransaccionalD INT PRIMARY KEY IDENTITY,
	IdActualizacionPerfilTransaccional	INT FOREIGN KEY REFERENCES dbo.tPLDactualizacionesPerfilTransaccionalE(IdActualizacionPerfilTransaccional),
	IdPersona							INT FOREIGN KEY REFERENCES dbo.tGRLpersonas(IdPersona),
	IdSocio								INT FOREIGN KEY REFERENCES dbo.tSCSsocios(IdSocio),
	IdSocioeconomico					INT FOREIGN KEY REFERENCES dbo.tSCSpersonasSocioeconomicos(IdSocioeconomico),
	DatoTransaccional					INT, -- 1. N�mero dep�sitos, 2. N�mero Retiros, 3. Monto Dep�sitos, 4. Monto Retiros
	ValorDeclaracion					NUMERIC(13,2),
	ValorOperaciones					NUMERIC(13,2),
	Fecha								DATE DEFAULT GETDATE()
)
GO



