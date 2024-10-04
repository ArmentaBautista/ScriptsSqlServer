
IF EXISTS(SELECT name FROM sys.tables WHERE name='tGRLoperacionesPadreHijas')
BEGIN
	-- DROP TABLE [dbo].[tGRLoperacionesPadreHijas]
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tGRLoperacionesPadreHijas]
(
	IdOperacion int NOT NULL,
	IdOperacionPadre int NOT NULL,
	[RelOperaciones] [int] NOT NULL, 
	[RelOperacionesD] [int] NOT NULL, 
	[RelTransacciones] [int] NOT NULL, 
	[RelTransaccionesFinancieras] [int] NOT NULL 
) ON [PRIMARY]


ALTER TABLE dbo.[tGRLoperacionesPadreHijas] 
ADD CONSTRAINT FK_tGRLoperacionesPadreHijas_IdOperacion 
FOREIGN KEY (IdOperacion) REFERENCES dbo.tGRLoperaciones (IdOperacion)

ALTER TABLE dbo.[tGRLoperacionesPadreHijas] 
ADD CONSTRAINT FK_tGRLoperacionesPadreHijas_IdOperacionPadre 
FOREIGN KEY (IdOperacionPadre) REFERENCES dbo.tGRLoperaciones (IdOperacion)


SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: