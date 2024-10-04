

USE [iERP_CAZ]
GO

CREATE NONCLUSTERED INDEX IX_tSDOtransaccionesFinancieras_IdEstatus_IdOperacion
ON [dbo].[tSDOtransaccionesFinancieras] ([IdEstatus],[IdOperacion])
INCLUDE ([IdTipoSubOperacion],[IdCuenta],[MontoSubOperacion],[Concepto],[DiasMora],[CapitalPagado],[InteresOrdinarioPagado],[InteresMoratorioPagado],[CargosPagados],[IVAInteresOrdinarioPagado],[IVAInteresMoratorioPagado],[IVACargosPagado],[IVAPagado],[TotalPagado],[EsPrincipal],[SubTotalPagado],[InteresOrdinarioPagadoVencido],[InteresMoratorioPagadoVencido],[CapitalPagadoVencido],[IdEstatusDominio],[IdGestor])
GO

