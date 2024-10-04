
USE ErpriseExpediente
go

SELECT * FROM dbo.tDIGagrupadores
SELECT * FROM dbo.tDIGrequisitos

/************************************     3     ****************************************/
/************************************     Personales     ****************************************/
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(1,1)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(1,2)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(1,3)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(1,4)
GO
/************************************     Captacion     ****************************************/
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,5)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,6)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,7)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,8)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,9)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,10)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,11)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,12)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(4,13)
GO
/************************************     PLD     ****************************************/
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,14)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,15)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,16)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,17)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,18)
GO
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(5,19)
GO
/************************************     Crédito     ****************************************/
INSERT INTO dbo.tDIGagrupadoresRequisitos (IdAgrupador,IdRequisito) VALUES(6,20)
GO


/************************************             ****************************************/
/************************************     Fin     ****************************************/
/************************************             ****************************************/


SELECT a.Codigo,a.Descripcion, r.Codigo, r.Descripcion 
FROM dbo.tDIGagrupadoresRequisitos ar  WITH(NOLOCK) 
INNER JOIN dbo.tDIGagrupadores a  WITH(NOLOCK) ON a.IdAgrupador = ar.IdAgrupador
INNER JOIN dbo.tDIGrequisitos r  WITH(NOLOCK) ON r.IdRequisito = ar.IdRequisito


