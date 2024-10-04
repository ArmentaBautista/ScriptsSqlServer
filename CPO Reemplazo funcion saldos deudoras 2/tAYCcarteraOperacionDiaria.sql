

IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCcarteraOperacionDiaria')
BEGIN
	-- DROP TABLE CREATE TABLE [dbo].[tAYCcarteraOperacionDiaria]
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCcarteraOperacionDiaria]
(
Fecha DATE NOT NULL,
Alta DATETIME NOT NULL,
[IdCuenta] [int] NOT NULL,
[Capital] [numeric] (14, 2) NULL,
[IdSocio] [int] NOT NULL,
[InteresOrdinario] [numeric] (14,2) NULL,
[InteresOrdinarioIVA] [numeric] (14,2) NULL,
[InteresOrdinarioTotal] [numeric] (14,2) NULL,
[InteresMoratorio] [numeric] (14,2) NULL,
[InteresMoratorioIVA] [numeric] (14,2) NULL,
[InteresMoratorioTotal] [numeric] (14,2) NULL,
[CapitalAtrasado] [numeric] (14,2) NULL,
[CapitalAlDia] [numeric] (14,2) NULL,
[CapitalExigible] [numeric] (14,2) NULL,
[InteresOrdinarioAtrasado] [numeric] (14,2) NULL,
[InteresOrdinarioIVAAtrasado] [numeric] (14,2) NULL,
[InteresOrdinarioTotalAtrasado] [numeric] (14,2) NULL,
[InteresMoratorioAtrasado] [numeric] (14,2) NULL,
[InteresMoratorioIVAAtrasado] [numeric] (14,2) NULL,
[InteresMoratorioTotalAtrasado] [numeric] (14,2) NULL,
[DiasTranscurridos] [int] NULL,
[DiasMora] [int] NULL,
[Cargos] [numeric] (14,2) NULL,
[CargosImpuestos] [numeric] (14,2) NULL,
[CargosTotal] [numeric] (14,2) NULL,
[Impuestos] [numeric] (14,2) NULL,
[Total] [numeric] (14,2) NULL,
[TotalAtrasado] [numeric] (14,2) NULL,
[TotalAlDia] [numeric] (14,2) NULL,
[MoraMaxima] [int] NULL,
[ParcialidadesVencidas] [int] NULL,
[SaldoTotal] [numeric] (14,2) NULL,
[ParcialidadesCapitalAtrasadas] [int] NULL,
[NumeroParcialidades] [int] NOT NULL,
[SaldoAlDía] [numeric] (14,2) NULL,
[SaldoExigible] [numeric] (14,2) NULL,
[TotalALiquidar] [numeric] (14,2) NULL,
[SaldoAlDíaSinCargos] [numeric] (14,2) NULL,
[SaldoExigibleSinCargos] [numeric] (14,2) NULL,
[TotalALiquidarSinCargos] [numeric] (14,2) NULL,
[CargosCobranza] [numeric] (14,2) NOT NULL,
[IvaCargosCobranza] [decimal] (14,2) NOT NULL,
[SegurosPlanPagos] [numeric] (14,2) NULL,
[IvaSegurosPlanPagos] [numeric] (14,2) NULL
) ON [PRIMARY]



SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:

