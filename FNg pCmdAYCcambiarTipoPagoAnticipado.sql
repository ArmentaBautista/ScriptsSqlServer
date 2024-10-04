
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCmdAYCcambiarTipoPagoAnticipado')
BEGIN
	DROP PROC pCmdAYCcambiarTipoPagoAnticipado
	SELECT 'pCmdAYCcambiarTipoPagoAnticipado BORRADO' AS info
END
GO

CREATE PROC pCmdAYCcambiarTipoPagoAnticipado
@pNoSocio AS VARCHAR(30)='',
@pNoCuenta AS VARCHAR(30)='',
@pUsarReduccionCuota AS BIT=0,
@pUsarReduccionPlazo AS BIT=0
AS
BEGIN
	IF @pNoSocio IN ('','*') OR @pNoCuenta IN ('','*')
	BEGIN
		SELECT 'Debe proporcionar No de Socio y Cuenta, válidos.' AS Info
		RETURN 0
	END

	IF @pUsarReduccionCuota=@pUsarReduccionPlazo
	BEGIN
		SELECT 'Debe elegir solo una modalidad de anticipo.' AS Info
		RETURN 0
	END

	DECLARE @IdSocio AS INT
	DECLARE @IdCuenta AS INT
	DECLARE @IdTipoDpagoAnticipado AS INT=0

	IF @pUsarReduccionPlazo=1
		SET @IdTipoDpagoAnticipado=417
	ELSE 
		SET @IdTipoDpagoAnticipado=416

	SELECT @IdSocio=c.IdSocio, @IdCuenta=c.IdCuenta
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		ON sc.IdSocio = c.IdSocio
			AND sc.Codigo=@pNoSocio
	WHERE c.IdEstatus=1
		AND c.IdTipoDProducto=143
			AND c.Codigo=@pNoCuenta

	IF @IdSocio=0 OR @IdCuenta=0
	BEGIN
		SELECT 'La combinación Socio y Cuenta no ha devuelto resultados.' AS Info
		RETURN 0
	END

	UPDATE c
	SET c.IdTipoDPagoAnticipado=@IdTipoDpagoAnticipado
	FROM dbo.tAYCcuentas c WHERE c.IdCuenta=@IdCuenta AND c.IdSocio=@IdSocio

	SELECT CAST(@@ROWCOUNT AS VARCHAR(4)) + ' registros Actualziados.'

END
GO

