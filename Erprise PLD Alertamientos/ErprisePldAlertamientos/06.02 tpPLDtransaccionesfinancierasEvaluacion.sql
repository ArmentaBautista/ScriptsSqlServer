
IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpPLDtransaccionesfinancierasEvaluacion')
BEGIN
	DROP TYPE tpPLDtransaccionesfinancierasEvaluacion
	SELECT 'tpPLDtransaccionesfinancierasEvaluacion BORRADO' AS info
END
GO

CREATE TYPE dbo.tpPLDtransaccionesfinancierasEvaluacion AS TABLE(
	[IdTransaccion] [INT] PRIMARY KEY,
	[IdOperacion] [INT] NOT NULL,
	[IdTipoSubOperacion] [INT] NOT NULL,
	[Fecha] [DATE] NOT NULL,
	[MontoSubOperacion] [NUMERIC](11, 2) NOT NULL,
	[IdCuenta] [INT] NOT NULL,
	[Naturaleza] [SMALLINT] NULL,
	[TotalCargos] [NUMERIC](11, 2) NULL,
	[TotalAbonos] [NUMERIC](11, 2) NULL,
	[SaldoCapital] [NUMERIC](11, 2) NULL,
	[SaldoCapitalAnterior] [NUMERIC](11, 2) NULL
)
GO


