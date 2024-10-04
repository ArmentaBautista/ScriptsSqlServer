
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tATNSoperaciones')
BEGIN
	CREATE TABLE [dbo].[tATNSoperaciones]
	(
		IdOperacion 			INT				NOT NULL IDENTITY,
		Fecha					DATE			NOT NULL DEFAULT GETDATE(),
		IdEmpleadoResponsable	INT				NOT NULL,
		IdSucursal				INT				NOT	NULL,
		IdTipoAtencion			INT				NOT NULL,
		IdSocio					INT				NOT NULL,
		IdCuenta				INT				NULL,
		IdOperacionReportada	INT				NULL,
		MontoReclamado			NUMERIC(13,2)	NOT NULL DEFAULT 0,
		IdMedioNotificacion		INT				NOT NULL,
		OtroMedioNotificacion	VARCHAR(24)		NULL,
		IdTipoCausa				INT				NOT NULL,
		IdSubtipoCausa			INT				NULL,
		Declaracion				VARCHAR(512)	NULL,
		Captcha					VARCHAR(6)		NOT NULL,
		Alta					DATETIME		NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT				NOT NULL,
		IdSesion 				INT				NOT NULL
		
		CONSTRAINT PK_tATNSoperaciones_IdOperacion PRIMARY KEY(IdOperacion),
		CONSTRAINT FK_tATNSoperaciones_IdEmpleadoResponsable FOREIGN KEY(IdEmpleadoResponsable) REFERENCES dbo.tPERempleados(IdEmpleado),
		CONSTRAINT FK_tATNSoperaciones_IdSucursal FOREIGN KEY(IdSucursal) REFERENCES dbo.tCTLsucursales(IdSucursal),
		CONSTRAINT FK_tATNSoperaciones_IdTipoAtencion FOREIGN KEY(IdTipoAtencion) REFERENCES dbo.tATNStiposAtencion(IdTipoAtencion),
		CONSTRAINT FK_tANTSoperaciones_IdSocio FOREIGN KEY (IdSocio) REFERENCES dbo.tSCSsocios(IdSocio),
		CONSTRAINT FK_tANTSoperaciones_IdScuenta FOREIGN KEY(IdCuenta) REFERENCES dbo.tAYCcuentas(IdCuenta),
		CONSTRAINT FK_tANTSoperaciones_IdOperacionReportada FOREIGN KEY(IdOperacionReportada) REFERENCES dbo.tGRLoperaciones(IdOperacion),
		CONSTRAINT FK_tANTSoperaciones_IdMedioNotificacion FOREIGN KEY(IdMedioNotificacion) REFERENCES dbo.tATNSmediosNotificacion(IdMedioNotificacion),
		CONSTRAINT FK_tANTSoperaciones_IdTipoCausa FOREIGN KEY(IdTipoCausa) REFERENCES dbo.tATNStiposCausa(IdTipoCausa),
		CONSTRAINT FK_tANTSoperaciones_IdSubtipoCausa FOREIGN KEY(IdSubtipoCausa) REFERENCES dbo.tATNSsubtiposCausa(IdSubtipoCausa),
		CONSTRAINT FK_tATNSoperaciones_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tATNSoperaciones_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tATNSoperaciones' AS info
END
ELSE 
	-- DROP TABLE tATNSoperaciones
	SELECT 'tATNSoperaciones Existe'
GO

