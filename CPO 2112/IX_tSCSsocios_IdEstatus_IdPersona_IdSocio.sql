

CREATE NONCLUSTERED INDEX [IX_tSCSsocios_IdEstatus_IdPersona_IdSocio] ON [dbo].[tSCSsocios]
(
	[IdEstatus] ASC,
	[IdPersona] ASC,
	[IdSocio] ASC
)
INCLUDE([CodigoInterfaz],[EsSocioValido],[Codigo]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
