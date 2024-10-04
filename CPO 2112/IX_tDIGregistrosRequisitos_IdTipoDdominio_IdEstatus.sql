

CREATE NONCLUSTERED INDEX [IX_tDIGregistrosRequisitos_IdTipoDdominio_IdEstatus]
ON [dbo].[tDIGregistrosRequisitos] ([IdTipoDdominio],[IdEstatus])
INCLUDE ([IdRegistroRequisitoPadre],[IdRegistroDocumento])
GO

