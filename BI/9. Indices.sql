

USE [iERP_BI]

GO

-- UK CUENTAS
IF EXISTS(SELECT name FROM sys.indexes o  WITH(nolock) WHERE name ='nci_tBSIcuentas_UK')
BEGIN
	DROP INDEX nci_tBSIcuentas_UK ON dbo.tBSIcuentas
	SELECT 'nci_tBSIcuentas_UK ON dbo.tBSIcuentas BORRADO'
END
GO

CREATE UNIQUE NONCLUSTERED INDEX [nci_tBSIcuentas_UK] ON [dbo].[tBSIcuentas]
(
	[IdEmpresa] ASC,
	[idcuenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

GO

SELECT 'nci_tBSIcuentas_UK ON dbo.tBSIcuentas CREADO'

-- UK CARTERA
IF EXISTS(SELECT name FROM sys.indexes o  WITH(nolock) WHERE name ='nci_tBSIcarteraDiaria_UK')
BEGIN
	DROP INDEX nci_tBSIcarteraDiaria_UK ON dbo.tBSIcarteraDiaria
	SELECT 'nci_tBSIcarteraDiaria_UK ON dbo.tBSIcarteraDiaria BORRADO'
END
GO

CREATE UNIQUE NONCLUSTERED INDEX [nci_tBSIcarteraDiaria_UK] ON [dbo].[tBSIcarteraDiaria]
(
	[IdEmpresa] ASC,
	[idcuenta] ASC,
	[FechaCartera]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

GO

SELECT 'nci_tBSIcarteraDiaria_UK ON dbo.tBSIcarteraDiaria CREADO'

