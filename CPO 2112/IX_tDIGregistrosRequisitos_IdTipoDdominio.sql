


CREATE NONCLUSTERED INDEX [IX_tDIGregistrosRequisitos_IdTipoDdominio]
ON [dbo].[tDIGregistrosRequisitos] ([IdTipoDdominio])
INCLUDE ([IdRegistroRequisito],[IdRegistro])
GO

