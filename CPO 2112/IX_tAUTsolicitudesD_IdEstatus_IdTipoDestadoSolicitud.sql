

CREATE NONCLUSTERED INDEX [IX_tAUTsolicitudesD_IdEstatus_IdTipoDestadoSolicitud]
ON [dbo].[tAUTsolicitudesD] ([IdEstatus],[IdTipoDestadoSolicitud])
INCLUDE ([IdSolicitud],[Etapa],[MontoAutorizado],[IdUsuario],[Alta])
GO

