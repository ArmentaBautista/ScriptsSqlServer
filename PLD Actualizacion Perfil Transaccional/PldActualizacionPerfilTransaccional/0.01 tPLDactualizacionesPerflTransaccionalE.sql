

-- 0.01 tPLDactualizacionesPerfilTransaccionalE

/* @^..^@   JCA.05/02/2024.09:50 p. m. Nota: Tabla para guardar todas las actualizaciones del perfil transaccional que se van haciendo sobre el socio   */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDactualizacionesPerfilTransaccionalE')
BEGIN
	DROP TABLE tPLDactualizacionesPerfilTransaccionalE
	SELECT 'tPLDactualizacionesPerfilTransaccionalE BORRADO' AS info
END
GO

CREATE TABLE tPLDactualizacionesPerfilTransaccionalE
(
	IdActualizacionPerfilTransaccional	INT PRIMARY KEY IDENTITY,
	Fecha								DATE DEFAULT GETDATE(),
	PorcentajeVariacion					NUMERIC(3,2),
	MesesEvaluados						INT,
	Inicio								DATE,
	Fin									DATE
)
GO



