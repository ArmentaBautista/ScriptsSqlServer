

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDinusualidadMontoEfectivoMayorMontoConfigurado')
BEGIN
	DROP PROC pPLDinusualidadMontoEfectivoMayorMontoConfigurado
	SELECT 'pPLDinusualidadMontoEfectivoMayorMontoConfigurado BORRADO' AS info
END
GO

CREATE PROC pPLDinusualidadMontoEfectivoMayorMontoConfigurado
@pIdOperacion		AS INT,
@pIdSocio			AS INT,
@pMontoSubOperacion	AS INT,
@pIdMetodoPago		AS INT,
@pIdUsuarioAlta		AS INT,
@pIdSesion			AS INT,
@pIdTransaccionD	AS INT
AS
BEGIN
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- JCA 230620
-- Depósitos en efectivo en una sola exhibición con un monto mayor o igual a $100,000.00 ** Monto configurable
-- TODO 1. Crear parámetro de configuracion PLD para el monto
--		2. Integrarse al generar una operación

-- Variables Locales
DECLARE @Idoperacion		AS INT=0
DECLARE @IdSocio			AS INT= 0
DECLARE @MontoSubOperacion	AS INT=0
DECLARE @IdMetodoPago		AS INT=0
DECLARE @IdPersona			AS INT=0
DECLARE @IdUsuarioAlta		AS INT=0
DECLARE @IdSesion			AS INT=0
DECLARE @IdTransaccionD		AS INT=0
DECLARE @MontoReferencia	AS MONEY=100000

-- Asignacion de variables locales
SET @IdOperacion		= @pIdOperacion		
SET @IdSocio			= @pIdSocio			
SET @MontoSubOperacion	= @pMontoSubOperacion	
SET @IdMetodoPago		= @pIdMetodoPago				
SET @IdUsuarioAlta		= @pIdUsuarioAlta		
SET @IdSesion			= @pIdSesion			
SET @IdTransaccionD		= @pIdTransaccionD	

	IF (@IdMetodoPago IN (-2,-10) AND @MontoSubOperacion>=@MontoReferencia)
	BEGIN

		SET @IdPersona = (SELECT idpersona FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.IdSocio=@IdSocio)

		/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
		-- Insert Operación PLD 
		-- IdTipoDoperacion 1593 -- IdEstatusAtencion 46 -- IdtipoDdominio 1598
		 
		INSERT INTO dbo.tPLDoperaciones
		(
			IdPersona,
			IdTipoDoperacionPLD,
			IdEstatusAtencion,
			Monto,
			IdEstatus,
			IdUsuarioAlta,
			IdTipoDDominio,
			IdSesion,
			Texto,
			IdOperacionOrigen,
			IdTransaccionD,
			TipoIndicador,
			MontoReferencia,
			IdSocio,
			IdCuenta,
			Descripcion,
			GeneradaDesdeSistema,
			IdInusualidad,
			IdMetodoPago
		)
		SELECT @IdPersona,1593,46,@MontoSubOperacion,1,@IdUsuarioAlta,1598,@IdSesion,CONCAT('Depósito en efectivo por: ', FORMAT(@MontoSubOperacion,'C','es-MX'))
		,@IdOperacion,@IdTransaccionD,CONCAT('Depósito en efectivo mayor o igual a ', FORMAT(@MontoReferencia,'C','es-MX'))
		,@MontoReferencia,@IdSocio,0,CONCAT('Depósito en efectivo por: ', FORMAT(@MontoSubOperacion,'C','es-MX'))
		,1,100,@IdMetodoPago

	END -- IF

END -- sp