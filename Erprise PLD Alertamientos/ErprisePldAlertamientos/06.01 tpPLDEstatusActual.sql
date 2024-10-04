
IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpPLDestatusActual')
BEGIN
	DROP TYPE tpPLDEstatusActual
	SELECT 'tpPLDestatusActual BORRADO' AS info
END
GO

CREATE TYPE dbo.tpPLDEstatusActual AS TABLE(
	[IdEstatusActual] [INT] PRIMARY KEY,
	[IdEstatus] [INT] NOT NULL DEFAULT 1,
	[IdTipoDDominio] [INT] NOT NULL
)
GO


