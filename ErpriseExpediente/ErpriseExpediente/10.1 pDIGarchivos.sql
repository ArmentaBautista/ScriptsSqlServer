USE ErpriseExpediente
GO

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pDIGarchivos')
BEGIN
	DROP PROC pDIGarchivos
	SELECT 'pDIGarchivos BORRADO' AS info
END
GO


CREATE PROC dbo.pDIGarchivos
@tipoOperacion AS VARCHAR(32)='',
@IdArchivo AS INT OUTPUT,
@idExpediente AS INT=0,
@IdRequisito AS INT=0,
@Nombre AS VARCHAR(256)='',
@Referencia AS VARCHAR(256)='',
@Descripcion AS VARCHAR(256)='',
@EsAutogenerado AS BIT=0,
@EstaSincronizado AS BIT=0,
@Fecha AS DATE='19000101',
@IdSesion AS INT=0,
@Resultado INT OUTPUT,
@UpdateCampo AS VARCHAR(18)=NULL,
@UpdateValor AS VARCHAR(2)=null
AS
BEGIN

SET NOCOUNT ON;

--#region Documentación
/*	Sp para gestión de archivos vinculados a un Registro de Expediente (Requisito)
	Recibe un tipo de operación:
		OBT_ARCH_REQ. Obtiene la lista de archivos correspondientes a un requisito del Expediente.
		INS_ARCH.	  Se usa para la operación de insertar un nuevo archivo

	NOTA: La tabla de Archivos tienen un trigger que al insertar cambia el estatus de todos los archivos del Expediente 
		  entrante
*/
--#endregion Documentación


	IF @tipoOperacion='' 
	BEGIN
		RAISERROR ( 'Oops (>_<) Tipo de Operación no provisto.',18,1)
		RETURN -1
	END


	IF @TipoOperacion='OBT_ARCH_REQ'
	BEGIN	
			IF @idExpediente=0 
			BEGIN 
				RAISERROR ( 'Oops (>_<) Número de Expediente no provisto.',18,1)
				RETURN -1
			END

			--Obtener los archivos del expediente
			SELECT
			a.IdArchivo,
            a.IdExpediente,
            a.IdRequisito,
            a.Nombre,
            a.Referencia,
			a.Descripcion,
            a.EsAutogenerado,
            a.EstaSincronizado,
            a.Fecha,
            a.IdEstatus
			FROM dbo.tDIGarchivos a  WITH(NOLOCK) 
			WHERE a.IdExpediente=@idExpediente --AND a.IdEstatus=1
			ORDER BY a.IdEstatus ASC, a.IdArchivo DESC

			RETURN 1
	END

	IF @TipoOperacion='INS_ARCH'
	BEGIN	
		INSERT INTO dbo.tDIGarchivos
		(
		    IdExpediente,
		    IdRequisito,
		    Nombre,
		    Referencia,
			Descripcion,
		    EsAutogenerado,
		    EstaSincronizado,
		    Fecha,
		    IdSesion
		)
		VALUES
		(   @idExpediente,       
		    @IdRequisito,       
		    @Nombre,      
		    @Referencia,
			@Descripcion,
		    @EsAutogenerado, 
		    @EstaSincronizado, 
		    @Fecha, 
		    @IdSesion
		)

		SET @IdArchivo=SCOPE_IDENTITY()
		SET @Resultado = @@ROWCOUNT

		RETURN 1
	END
	
	-- Operación para la actualización del estatus de sincronziación
	IF @tipoOperacion='UPD_SYNC'
	BEGIN
		
		IF @IdArchivo IS NULL OR @IdArchivo=0
		BEGIN
			RAISERROR ( 'Oops (>_<) Debe proporcionar el Identificador del Archivo.',18,1)
			RETURN -1
		END


		IF @UpdateCampo = 'EstaSincronizado'
		BEGIN 
			DECLARE @valor AS BIT=CAST(@UpdateValor AS BIT);
			UPDATE a SET a.EstaSincronizado=@valor FROM tDIGarchivos a WHERE a.IdArchivo=@IdArchivo	AND a.EstaSincronizado<>@valor	
			
			SET @Resultado=@@ROWCOUNT
			--SET @Resultado=100
			RETURN 1
		END
		
		IF @UpdateCampo = 'IdEstatus'
		BEGIN 
			DECLARE @valor2 AS INT=CAST(@UpdateValor AS INT);
			UPDATE a SET a.IdEstatus=@valor2 FROM tDIGarchivos a WHERE a.IdArchivo=@IdArchivo AND a.IdEstatus<>@valor2
			
			SET @Resultado=@@ROWCOUNT
			
			RETURN 1
		END
		
		IF @UpdateCampo NOT IN ('IdEstatus','EstaSincronizado')
		BEGIN
			RAISERROR ( 'Oops (>_<) El campo indicado no es válido.',18,1)
			RETURN -1
		END
	END

END
GO
