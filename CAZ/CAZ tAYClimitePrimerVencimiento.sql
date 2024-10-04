

IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYClimitePrimerVencimiento')
BEGIN
	-- DROP TABLE tAYClimitePrimerVencimiento
	SELECT 'Tabla existente tAYClimitePrimerVencimiento' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYClimitePrimerVencimiento]
(
	IdTipoDPlazo 	int NOT NULL,
	DiasMaximoPrimerVencimiento SMALLINT NOT NULL,
	Alta			DateTime NOT NULL DEFAULT GetDate(),
	IdEstatus 		int NOT NULL DEFAULT 1,
	IdUsuarioAlta 	int NOT NULL,
	IdSesion 		int NOT NULL
) ON [PRIMARY]

CREATE UNIQUE INDEX UQ_tAYClimitePrimerVencimiento
ON dbo.tAYClimitePrimerVencimiento (IdTipoDPlazo,IdEstatus)

SELECT 'Tabla Creada tAYClimitePrimerVencimiento' AS info

-- Goto tag
Fin: