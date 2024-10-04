
CREATE NONCLUSTERED INDEX [IX_tAUTsolicitudesD_IdSolicitud_IdEstatus]
ON [dbo].[tAUTsolicitudesD] ([IdSolicitud],[IdEstatus])
INCLUDE ([Etapa],[MontoAutorizado],[IdUsuario],[IdTipoDestadoSolicitud],[Alta])
GO

