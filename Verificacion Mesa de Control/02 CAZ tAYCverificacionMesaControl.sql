
IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCverificacionMesaControl')
BEGIN
	-- DROP TABLE tAYCverificacionMesaControl
	SELECT 'Tabla existente tAYCverificacionMesaControl' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCverificacionMesaControl]
(
	IdVerificacionMesaControl	INT NOT NULL PRIMARY KEY IDENTITY,
	IdCuenta					INT NOT NULL,
	IdElemento					INT NOT NULL,
	Cubierto					BIT	NOT NULL,
	NoCubierto					BIT NOT NULL,
	Alta						DATETIME NOT NULL DEFAULT GETDATE(),
	IdEstatus 					INT NOT NULL,
	IdUsuarioAlta 				INT NOT NULL,
	IdSesion 					INT NOT NULL
) ON [PRIMARY]


ALTER TABLE dbo.tAYCverificacionMesaControl 
ADD CONSTRAINT FK_tAYCverificacionMesaControl_IdCuenta 
FOREIGN KEY (IdCuenta) REFERENCES dbo.tAYCcuentas (IdCuenta)

ALTER TABLE dbo.tAYCverificacionMesaControl 
ADD CONSTRAINT FK_tAYCverificacionMesaControl_IdElemento 
FOREIGN KEY (IdElemento) REFERENCES dbo.tAYCelementosVerificacionMesaControl (IdElemento)

ALTER TABLE dbo.tAYCverificacionMesaControl 
ADD CONSTRAINT FK_tAYCverificacionMesaControl_IdEstatus 
FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)

ALTER TABLE dbo.tAYCverificacionMesaControl 
ADD CONSTRAINT FK_tAYCverificacionMesaControl_IdUsuarioAlta 
FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios (IdUsuario)

ALTER TABLE dbo.tAYCverificacionMesaControl 
ADD CONSTRAINT FK_tAYCverificacionMesaControl_IdSesion 
FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)


SELECT 'Tabla Creada tAYCverificacionMesaControl' AS info

-- Goto tag
Fin: