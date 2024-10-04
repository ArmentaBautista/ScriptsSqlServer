

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tGRLpersonas_IdPersona_Nombre] ON [dbo].[tGRLpersonas]
(
	[IdPersona] ASC,
	[Nombre] ASC
)
INCLUDE([Domicilio]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
