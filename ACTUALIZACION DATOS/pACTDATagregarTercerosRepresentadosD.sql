
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pACTDATagregarTercerosRepresentadosD')
BEGIN
	DROP PROC pACTDATagregarTercerosRepresentadosD
	SELECT 'pACTDATagregarTercerosRepresentadosD BORRADO' AS info
END
GO

CREATE PROC pACTDATagregarTercerosRepresentadosD
@pIdTercerosRepresentadosE INT,
@pIdReferenciaPersonal INT,
@pIdPersonaReferencia INT,
@pRelReferenciasPersonales INT,
@pEsProveedorRecursos BIT,
@pEsPropietarioReal BIT
AS
BEGIN
	DECLARE @EsProveedorRecursosValorAnterior BIT=0
	DECLARE @EsPropietarioRealValorAnterior BIT=0
	
	SELECT 
	@EsPropietarioRealValorAnterior= ref.EsPropietarioReal,
	@EsProveedorRecursosValorAnterior= ref.EsProveedorRecursos
	FROM dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK) 
	WHERE ref.IdReferenciaPersonal=@pIdReferenciaPersonal

	BEGIN TRY
		BEGIN TRANSACTION;
		
			INSERT INTO dbo.tACTDATtercerosRepresentadosD
			(IdTercerosRepresentadosE,IdReferenciaPersonal,IdPersonaReferencia,RelReferenciasPersonales,EsProveedorRecursos,EsPropietarioReal,EsRegistroAnterior,EsRegistroActual)
			VALUES
			(@pIdTercerosRepresentadosE,@pIdReferenciaPersonal,@pIdPersonaReferencia,@pRelReferenciasPersonales,@EsProveedorRecursosValorAnterior,@EsPropietarioRealValorAnterior,1,0),
			(@pIdTercerosRepresentadosE,@pIdReferenciaPersonal,@pIdPersonaReferencia,@pRelReferenciasPersonales,@pEsProveedorRecursos,@pEsPropietarioReal,0,1) 
		
			UPDATE ref SET ref.EsProveedorRecursos=@pEsProveedorRecursos, ref.EsPropietarioReal=@pEsPropietarioReal 
			FROM dbo.tSCSpersonasFisicasReferencias ref WHERE ref.IdReferenciaPersonal=@pIdReferenciaPersonal

		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;	
		DECLARE @err AS NVARCHAR(max)
		SELECT @err = CONCAT(ERROR_NUMBER(),'\r\n',ERROR_STATE(),'\r\n',ERROR_SEVERITY(),'\r\n',ERROR_PROCEDURE(),'\r\n',ERROR_LINE(),'\r\n',ERROR_MESSAGE())
	
		RAISERROR (@err, 1, 1, 50001);
	END CATCH;	
END
GO