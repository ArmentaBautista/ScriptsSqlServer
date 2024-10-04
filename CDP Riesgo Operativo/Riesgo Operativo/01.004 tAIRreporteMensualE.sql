
/* JCA.19/4/2024.01:27 
Nota: Riesgo Operativo. Tabla de encabezado del reporte que se emite mensualmente
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAIRreporteMensualE')
BEGIN
	CREATE TABLE [dbo].[tAIRreporteMensualE]
	(
		IdReporteMensualE 		INT NOT NULL IDENTITY,
		IdPeriodo				INT NOT NULL,
		IdUsuario				INT NOT NULL,
		IdEmpleado				int NOT NULL,
		IdDepartamento			INT NOT NULL,
		IdPuesto				INT NOT NULL,
		Fecha					DATE NOT NULL DEFAULT GETDATE(),
		Alta					DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL
		
		CONSTRAINT PK_tAIRreporteMensual_IdReporteMensualE PRIMARY KEY(IdReporteMensualE) ,
		CONSTRAINT FK_tAIRreporteMensual_IdPeriodo FOREIGN KEY (IdPeriodo) REFERENCES dbo.tCTLperiodos (IdPeriodo),
		CONSTRAINT FK_tAIRreporteMensual_IdUsuario FOREIGN KEY (IdUsuario) REFERENCES dbo.tCTLusuarios (IdUsuario),
		CONSTRAINT FK_tAIRreporteMensual_IdDepartamento FOREIGN KEY (IdDepartamento) REFERENCES dbo.tPERdepartamentos (IdDepartamento),
		CONSTRAINT FK_tAIRreporteMensual_IdPuesto FOREIGN KEY (IdPuesto) REFERENCES dbo.tPERpuestos (IdPuesto),
		CONSTRAINT FK_tAIRreporteMensual_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tAIRreporteMensual_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tAIRreporteMensualE' AS info
END
ELSE 
	-- DROP TABLE tAIRreporteMensualE
	SELECT 'tAIRreporteMensualE Existe'
GO


