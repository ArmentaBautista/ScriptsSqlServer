IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpPLDtransaccionesDevaluacion')
BEGIN
	DROP TYPE tpPLDtransaccionesDevaluacion
	SELECT 'tpPLDtransaccionesDevaluacion BORRADO' AS info
END
GO

CREATE TYPE [dbo].tpPLDtransaccionesDevaluacion AS TABLE(
	[IdTransaccionD] [INT] PRIMARY KEY,
	[IdOperacion] [INT] NOT NULL,
	[IdMetodoPago] [INT] NOT NULL,
	[IdTipoSubOperacion] [INT] NOT NULL,
	[Monto] [NUMERIC](11, 2) NOT NULL DEFAULT ((0))
)
GO


