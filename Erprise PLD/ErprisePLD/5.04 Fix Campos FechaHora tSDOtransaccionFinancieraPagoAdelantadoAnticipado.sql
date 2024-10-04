
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tSDOtransaccionFinancieraPagoAdelantadoAnticipado')
BEGIN	
		CREATE TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado]
		(
		[id] [int] NOT NULL IDENTITY(1, 1),
		[IdOperacion] [int] NULL,
		[EsPagoAdelantado] [bit] NULL,
		[EsPagoAnticipado] [bit] NULL,
		[IdTipoDpagoAnticipado] [int] NULL,
		[IdTransacccionFinanciera] [int] NULL,
		[IdCuenta] [int] NULL,
		[Fecha] [date] NULL CONSTRAINT [DF__tSDOtrans__Fecha__3695512F] DEFAULT (getdate()),
		[Hora] [time] NULL CONSTRAINT [DF__tSDOtransa__Hora__37897568] DEFAULT (getdate())
		) ON [PRIMARY]

		ALTER TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado] ADD CONSTRAINT [PK__tSDOtran__3213E83FB98D4D00] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]

		ALTER TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado] ADD CONSTRAINT [FK_tSDOtransaccionFinancieraPagoAdelantadoAnticipado_IdCuenta] FOREIGN KEY ([IdCuenta]) REFERENCES [dbo].[tAYCcuentas] ([IdCuenta])

		ALTER TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado] ADD CONSTRAINT [FK_tSDOtransaccionFinancieraPagoAdelantadoAnticipado_IdOperacion] FOREIGN KEY ([IdOperacion]) REFERENCES [dbo].[tGRLoperaciones] ([IdOperacion])

		ALTER TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado] ADD CONSTRAINT [FK_tSDOtransaccionFinancieraPagoAdelantadoAnticipado_IdTipoDpagoAnticipado] FOREIGN KEY ([IdTipoDpagoAnticipado]) REFERENCES [dbo].[tCTLtiposD] ([IdTipoD])

		ALTER TABLE [dbo].[tSDOtransaccionFinancieraPagoAdelantadoAnticipado] ADD CONSTRAINT [FK_tSDOtransaccionFinancieraPagoAdelantadoAnticipado_IdTransacccionFinanciera] FOREIGN KEY ([IdTransacccionFinanciera]) REFERENCES [dbo].[tSDOtransaccionesFinancieras] ([IdTransaccion])
		
		SELECT 'Tabla Creada tSDOtransaccionFinancieraPagoAdelantadoAnticipado' AS info
END
ELSE 
	-- DROP TABLE tSDOtransaccionFinancieraPagoAdelantadoAnticipado
	SELECT 'tSDOtransaccionFinancieraPagoAdelantadoAnticipado Existe'
GO

IF NOT EXISTS(SELECT 1
				FROM sys.tables t 
				INNER JOIN sys.columns c ON c.object_id = t.object_id
				WHERE t.name='tSDOtransaccionFinancieraPagoAdelantadoAnticipado'
					AND c.name = 'Fecha')
BEGIN
	ALTER TABLE dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado
		ADD Fecha DATE DEFAULT GETDATE()

	SELECT 'Columna Fecha agregada'
END
GO

IF NOT EXISTS(SELECT 1
				FROM sys.tables t 
				INNER JOIN sys.columns c ON c.object_id = t.object_id
				WHERE t.name='tSDOtransaccionFinancieraPagoAdelantadoAnticipado'
					AND c.name = 'Hora')
BEGIN
	ALTER TABLE dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado
		ADD Hora TIME DEFAULT GETDATE()

	SELECT 'Columna Hora agregada'
END
GO

