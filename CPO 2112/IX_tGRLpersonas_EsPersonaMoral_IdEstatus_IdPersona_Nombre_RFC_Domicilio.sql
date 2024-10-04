

CREATE NONCLUSTERED INDEX [IX_tGRLpersonas_EsPersonaMoral_IdEstatus_IdPersona_Nombre_RFC_Domicilio]
ON [dbo].[tGRLpersonas] ([EsPersonaMoral],[IdEstatus],[IdPersona])
INCLUDE ([Nombre],[RFC],[Domicilio])
GO

