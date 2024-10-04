


CREATE NONCLUSTERED INDEX [IX_tGRLpersonas_EsPersonaMoral_IdEstatus_IdPersona]
ON [dbo].[tGRLpersonas] ([EsPersonaMoral],[IdEstatus],[IdPersona])
INCLUDE ([Nombre])
GO
