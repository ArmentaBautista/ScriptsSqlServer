IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpPLDcuentas')
BEGIN
	DROP TYPE tpPLDcuentas
	SELECT 'tpPLDcuentas BORRADO' AS info
END
GO

CREATE TYPE [dbo].tpPLDcuentas AS TABLE(
	[IdCuenta] [INT] NOT NULL,
	[IdSocio] [INT] NOT NULL,
	[IdApertura] [INT] NULL,
	[IdProducto] [INT] NOT NULL,
	[IdTipoDproducto] [INT] NOT NULL,
	[Producto] [VARCHAR](128) NOT NULL,
	[NoCuenta] [VARCHAR](32) NOT NULL,
	[Monto] [NUMERIC](13, 2) NULL,
	[Vencimiento] [DATE] NULL,
	[FechaEntregada] [DATE] NULL,
	[FechaBaja] [DATE] NULL DEFAULT ('19000101'),
	[TienePagoAnticipados] [BIT] NULL DEFAULT ((0)),
	[IdEstatus] [INT] NULL,
	
	INDEX [IxIdSocio] NONCLUSTERED ([IdSocio] ASC),
	PRIMARY KEY CLUSTERED ([IdCuenta] ASC) WITH (IGNORE_DUP_KEY = OFF)
)
GO


