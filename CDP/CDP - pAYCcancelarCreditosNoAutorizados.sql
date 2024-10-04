
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcancelarCreditosNoAutorizados')
BEGIN
	DROP PROC pAYCcancelarCreditosNoAutorizados
	SELECT 'pAYCcancelarCreditosNoAutorizados BORRADO' AS info
END
GO

CREATE PROC pAYCcancelarCreditosNoAutorizados
@fecha AS DATE='19000101'
as
BEGIN
	IF @fecha='19000101'
		RETURN -1

	DECLARE @fechaComparacion AS DATE='19000101'
	SET @fechaComparacion=(SELECT DATEADD(DAY,-30,@fecha))

	BEGIN TRY
		BEGIN TRANSACTION;
	   
		IF (@fechaComparacion!='19000101')
		BEGIN
	
		---Cancelar la apertura 
			UPDATE a SET a.IdEstatus=18,a.UltimoCambio=GETDATE()
			FROM dbo.tAYCcuentas c With (nolock) 
			JOIN dbo.tAYCaperturas a With (nolock) ON a.IdApertura = c.IdApertura
			WHERE c.IdTipoDProducto=143 AND c.IdSaldo!=0
			and c.FechaAlta<@fechaComparacion 
			AND NOT c.IdEstatus IN (1,53,73,2,18,80,10,7)

	   ----Cancelacion de las solicitudes
			 UPDATE ea SET ea.IdEstatus=18,ea.UltimoCambio=GETDATE()
			FROM dbo.tAYCcuentas c With (nolock) 
			JOIN dbo.tAUTsolicitudes sol With (nolock) ON sol.IdCuenta = c.IdCuenta
			JOIN dbo.tCTLestatusActual ea With (nolock) ON sol.IdCuenta=c.IdCuenta
			WHERE c.IdTipoDProducto=143 AND c.IdSaldo!=0
			and c.FechaAlta<@fechaComparacion 
			AND NOT c.IdEstatus IN (1,53,73,2,18,80,10,7)

		------cancelacion del saldo 
			UPDATE s SET s.IdEstatus=18,s.UltimaModificacion=GETDATE()
			FROM dbo.tAYCcuentas c With (nolock) 
			JOIN dbo.tAYCaperturas a With (nolock) ON a.IdApertura = c.IdApertura
			JOIN dbo.tSDOsaldos s With (nolock) ON s.IdCuenta = c.IdCuenta
			WHERE c.IdTipoDProducto=143 AND c.IdSaldo!=0
			and c.FechaAlta<@fechaComparacion 
			AND NOT c.IdEstatus IN (1,53,73,2,18,80,10,7)


		----Cancelacion de la cuenta		
			UPDATE c SET c.IdEstatus=18,c.UltimoCambio=GETDATE(),c.DescripcionLarga='Cancelado por más de 30 días en trámite'
			FROM dbo.tAYCcuentas c With (nolock) 
			WHERE c.IdTipoDProducto=143
			and c.FechaAlta<@fechaComparacion 
			AND NOT c.IdEstatus IN (1,53,73,2,18,80,10,7)
		END		 
			
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;		
		 SELECT
	    ERROR_NUMBER() AS ErrorNumber,
	    ERROR_STATE() AS ErrorState,
	    ERROR_SEVERITY() AS ErrorSeverity,
	    ERROR_PROCEDURE() AS ErrorProcedure,
	    ERROR_LINE() AS ErrorLine,
	    ERROR_MESSAGE() AS ErrorMessage;		
	END CATCH;
END 

GO

