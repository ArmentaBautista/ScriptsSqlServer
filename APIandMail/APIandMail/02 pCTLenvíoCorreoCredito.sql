

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLenvíoCorreoCredito')
BEGIN
	DROP PROC pCTLenvíoCorreoCredito
	SELECT 'pCTLenvíoCorreoCredito BORRADO' AS info
END
GO

CREATE PROC pCTLenvíoCorreoCredito
@pIdEtapaCredito AS INT,
@pIdCuenta AS INT
AS
BEGIN
	DECLARE @IdEtapaCredito AS INT=@pIdEtapaCredito
	DECLARE @IdCuenta AS INT=@pIdCuenta
	DECLARE @Etapa AS VARCHAR(250) 

	SELECT @Etapa=d.Descripcion FROM dbo.tCTLtiposD d  WITH(NOLOCK) WHERE d.IdTipoD=@IdEtapaCredito

	DECLARE @msg AS VARCHAR(max);
	SELECT  
	@msg=CONCAT('<h3>Cuenta:',c.Codigo,' ',c.Descripcion, '</h3>',CHAR(13),CHAR(13),'<h3> Socio ',sc.Codigo,' ',p.Nombre,' </h3>',CHAR(13),CHAR(13),'<h3> Situación: ',@Etapa,' </h3>')
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		ON c.IdSocio = sc.IdSocio
			AND c.IdCuenta=@IdCuenta

	DECLARE @Head AS VARCHAR(32)='<html><body>'
	DECLARE @Foot AS VARCHAR(32)='</body></html>'

	SET @msg= CONCAT('<h5>Notificación Automática. (NO responda este correo)</h5>',CHAR(13),CHAR(13),@msg);

	--5PRINT @msg
	EXEC dbo.pCTLenviarMail @destinatario = 'carlos.armenta@intelix.mx',@asunto = 'ERPRISE ADMIN',@cuerpo = @msg  

END
GO
