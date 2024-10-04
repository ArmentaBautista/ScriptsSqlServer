
USE [ErpriseExpediente]
GO

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLestatus')
BEGIN
	DROP PROC pCTLestatus
	SELECT 'pCTLestatus BORRADO' AS info
END
GO


CREATE PROC dbo.pCTLestatus
@tipoOperacion AS VARCHAR(24)=''
AS
BEGIN

--#region Documentaci�n
/*	Sp para gesti�n de Estatus
	Recibe un tipo de operaci�n:
		LIST. Obtiene la lista de Estatus disponibles
*/
--#endregion Documentaci�n


	IF @tipoOperacion='' 
	BEGIN
		RAISERROR ( 'Oops (>_<) Tipo de Operaci�n no provisto.',18,1)
		RETURN -1
	END
	
	IF @TipoOperacion='LIST'
	BEGIN	
			--Obtener los registros del expediente
			SELECT 
			e.IdEstatus,
			e.Codigo,
			e.Descripcion
			FROM dbo.tCTLestatus e  WITH(NOLOCK) 
			WHERE e.IdEstatus IN (1,7,53,73)

			RETURN 1
	END

	

END
GO


