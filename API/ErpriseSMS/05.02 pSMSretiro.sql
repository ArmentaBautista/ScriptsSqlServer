


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSMSmovimientoCuenta')
BEGIN
	DROP PROC pSMSmovimientoCuenta
	SELECT 'pSMSmovimientoCuenta BORRADO' AS info
END
GO

CREATE PROC pSMSmovimientoCuenta
@pIdCuenta AS INT,
@pIdTipoSubOperacion AS INT,
@pConcepto AS VARCHAR(80),
@pMonto AS NUMERIC(12,2)
AS
BEGIN
	DECLARE @NoCuenta AS VARCHAR(50)
	DECLARE @IdSocio AS INT
	SELECT TOP 1 @NoCuenta=c.Codigo, @IdSocio=c.IdSocio FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdCuenta=@pIdCuenta
	DECLARE @Mensaje AS VARCHAR(250)=CONCAT(FORMAT(CURRENT_TIMESTAMP,'yyyy-MM-dd HH:mm'), ' COOP-IX '
	,IIF(@pIdTipoSubOperacion=500,'DEPOSITO','RETIRO'),' ', FORMAT(@pMonto,'C','es-MX'),' Cuenta:',@NoCuenta,' ',@pConcepto)
	SET @Mensaje=SUBSTRING(@Mensaje,0,160)
	
	DECLARE @Telefono AS VARCHAR(10)=(SELECT TOP 1 tel.Telefono 
										FROM dbo.tCATtelefonos tel  WITH(NOLOCK) 
										INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
											ON ea.IdEstatusActual = tel.IdEstatusActual
												and ea.IdEstatus=1
										INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
											ON p.IdRelTelefonos=tel.IdRel
										INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
											ON sc.IdPersona = p.IdPersona
												AND sc.IdSocio=@IdSocio
										WHERE tel.IdListaD=-1339 )
	IF (@Telefono IS NULL OR @Telefono='' OR LEN(@Telefono)<>10)
		RETURN -1

	EXEC dbo.pSMSenvio @pTelefono = @Telefono, @pMensaje = @Mensaje   
END
GO








