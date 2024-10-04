
CREATE NONCLUSTERED INDEX [IxtSCSsocios_IdEstatus_Codigo]
ON [dbo].[tSCSsocios] ([IdEstatus],[IdSocio])
INCLUDE ([IdPersona],[CodigoInterfaz],[EsSocioValido],[Codigo])
GO

