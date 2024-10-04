
USE iERP_DRA
GO

DECLARE @tFinancierasD AS TABLE(
    [IdTransaccionFinancieraD] INT,
    [IdTransaccionFinanciera] INT,
    [IdParcialidad] INT,
    [IdCargoDescuento] INT,
    [IdSaldo] INT,
    [IdBienServicio] INT,
    [IdTipoDconcepto] INT,
    [IdPeriodo] INT,
    [Fecha] DATE,
    [Dias] INT,
    [InteresDiario] DECIMAL(23, 8),
    [Estimado] DECIMAL(23, 8),
    [Devengado] DECIMAL(23, 8),
    [Pagado] DECIMAL(23, 8),
    [Condonado] DECIMAL(23, 8),
    [IVAestimado] DECIMAL(23, 8),
    [IVAdevengado] DECIMAL(23, 8),
    [IVApagado] DECIMAL(23, 8),
    [IVAcondonado] DECIMAL(23, 8),
    [TotalEstimado] DECIMAL(24, 8),
    [TotalDevengado] DECIMAL(24, 8),
    [TotalPagado] DECIMAL(24, 8),
    [TotalCondonado] DECIMAL(24, 8),
    [Ahorrado] DECIMAL(23, 8),
    [IdMovimiento] INT,
    [IdEstatus] INT,
    [SaldoEstimado] DECIMAL(23, 8),
    [SaldoCuentasOrden] DECIMAL(23, 8),
    [CuentasOrden] DECIMAL(23, 8),
    [IdEstatusCartera] INT,
    [DeCuentasOrden] DECIMAL(23, 8),
    [Saldo] DECIMAL(18, 2),
    [Castigado] DECIMAL(18, 2),
    [IVAcastigado] DECIMAL(18, 2),
    [IdTipoSubOperacion] INT,
    [NumeroCargo] INT,
    [FechaUltimoCalculoInteresMoratorio] DATE,
    [PagadoCapital] DATE,
    [PagadoInteresOrdinario] DATE,
    [PagadoInteresMoratorio] DATE,

	INDEX IX1(Fecha)
);


INSERT INTO @tFinancierasD
SELECT * FROM dbo.tSDOtransaccionesFinancierasD  WITH(NOLOCK) 

SELECT * FROM @tFinancierasD t
WHERE t.Fecha BETWEEN '20210101' AND '20240101'



