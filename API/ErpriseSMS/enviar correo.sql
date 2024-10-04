
DECLARE @msg AS VARCHAR(max);

SET @msg= CONCAT('CPD',CHAR(13),'Prueba de correo');

EXEC dbo.pCTLenviarMail @destinatario = 'carlos.armenta@intelix.mx',@asunto = 'ERPRISE ADMIN',@cuerpo = @msg  


SELECT * FROM dbo.tCTLtiposE e  WITH(NOLOCK) WHERE e.Descripcion LIKE '%etapa%'

SELECT d.IdTipoD,d.Codigo,d.Descripcion,d.Orden FROM dbo.tCTLtiposD d  WITH(NOLOCK) WHERE d.IdTipoE = 172


