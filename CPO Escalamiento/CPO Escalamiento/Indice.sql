

USE [CLON_OBL_DB]
GO
CREATE NONCLUSTERED INDEX [IX_tGRLoperaciones_SocioOperacionFechaEstatus]
ON [dbo].[tGRLoperaciones] ([IdSocio],[IdTipoOperacion],[Fecha],[IdEstatus])
INCLUDE ([IdOperacion])
GO

