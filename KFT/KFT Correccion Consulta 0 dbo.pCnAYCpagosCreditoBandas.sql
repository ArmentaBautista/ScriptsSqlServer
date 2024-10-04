
USE iERP_KFT 
GO

SELECT * FROM dbo.tCTLrecursos rr  WITH(nolock) 
WHERE rr.Descripcion LIKE '%Pagos de Crédito por Bandas%'


SELECT *
-- UPDATE c SET c.TituloVentana='Pagos de Crédito por Bandas', c.Descripcion='Pagos de Crédito por Bandas', SQL='EXEC pCnAYCpagosCreditoBandas @Usuario, @fechaInicio, @fechaFinal'
FROM dbo.tCTLconsultas c  WITH(nolock) WHERE c.IdConsulta=301


EXEC pCnAYCpagosCreditoBandas @fechaInicio='20200801', @fechaFinal='20200830',@Usuario='KHERNANDEZ'


SELECT * FROM dbo.tCTLparametroIC p WHERE p.IdParametroIC IN (3,4,23)

SELECT * FROM tCTLinformeConsulta WHERE IdRecurso=730

IF NOT EXISTS(SELECT IdInformeConsulta FROM tCTLinformeConsulta WHERE IdRecurso =  730 AND  IdParametroIC = 4)   BEGIN   
INSERT INTO tCTLinformeConsulta(IdRecurso, IdParametroIC, Orden)    
VALUES (  2546, 4, 2 )   END



