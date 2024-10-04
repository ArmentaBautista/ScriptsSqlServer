
/********  JCA.7/5/2024.23:32 Info: Comando para la baja de PPE, opcionalmente considera sus Asimilados  ********/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCmdPLDdesmarcarPPE')
BEGIN
	DROP PROC pCmdPLDdesmarcarPPE
	SELECT 'pCmdPLDdesmarcarPPE BORRADO' AS info
END
GO

CREATE PROC pCmdPLDdesmarcarPPE
@pNombre AS VARCHAR(50),
@pApellidoPaterno AS VARCHAR(50),
@pApellidoMaterno AS VARCHAR(50),
@pRFC AS VARCHAR(15),
@pDesmarcarAsimilados AS BIT=0
AS
BEGIN
	DECLARE @IdPersona AS INT=0;
	DECLARE @RelSocio AS INT=0;
	DECLARE @IdSesion INT = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 
	DECLARE @Ppes AS TABLE ( IdPersona INT)
	
	/********  JCA.7/5/2024.17:25 Info: Obtenemos el IdPersona  ********/
	SELECT @IdPersona=p.IdPersona
	FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
		ON pf.IdPersona = p.IdPersona
			AND pf.Nombre=@pNombre
				AND pf.ApellidoPaterno=@pApellidoPaterno
					and pf.ApellidoMaterno=@pApellidoMaterno
	WHERE p.RFC=@pRFC

	IF @IdPersona=0
	BEGIN
		SELECT 'Persona no encontrada' AS Info
		RETURN 0
	END

	/********  JCA.7/5/2024.23:01 Info: Obtenemos el RelSocio de la Persona, esto para obtener a sus asimilados posteriormente  ********/
	SELECT TOP 1 @RelSocio=p.RelSocio 
	FROM dbo.tPLDppe p  WITH(NOLOCK) 
	WHERE p.IdPersona=@IdPersona 
		AND p.IdSocio<>0

	/********  JCA.7/5/2024.17:46 Info: Buscamos a la persona principal  ********/
	INSERT INTO @Ppes
	SELECT idpersona FROM dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) WHERE pf.IdPersona=@IdPersona AND pf.EsPersonaPoliticamenteEspuesta=1
	/********  JCA.7/5/2024.17:47 Info: Buscamos a la persona en la tabla de pps  ********/
	INSERT INTO @Ppes
	SELECT ppe.IdPersona FROM dbo.tPLDppe ppe  WITH(NOLOCK) WHERE ppe.IdEstatus=1 AND ppe.IdPersona=@IdPersona 
	/********  JCA.7/5/2024.23:05 Info: Buscamos a los Asimilados  ********/
	INSERT INTO @Ppes
	SELECT ppe.IdPersona FROM dbo.tPLDppe ppe  WITH(NOLOCK) WHERE ppe.IdEstatus=1 AND ppe.IdSocio=0 AND ppe.RelSocio=@RelSocio
	
	BEGIN TRY
		BEGIN TRANSACTION;
			/********  JCA.7/5/2024.23:31 Info: Desmarcamos las personas  ********/
			UPDATE pf 
			SET pf.EsPersonaPoliticamenteEspuesta=0, pf.IdTipoDPPE=0 
			FROM dbo.tGRLpersonasFisicas pf  
			INNER JOIN @Ppes p
				ON p.IdPersona = pf.IdPersona
			
			/********  JCA.7/5/2024.23:31 Info: Se mandan a baja en la tabla de ppes  ********/
			UPDATE p
			SET p.idestatus=2
			FROM dbo.tPLDppe p
			INNER JOIN @Ppes ppe
				ON ppe.IdPersona = p.IdPersona
			WHERE p.IdEstatus=1

			/********  JCA.7/5/2024.23:21 Info: Insertar en la bitácora  ********/
			INSERT INTO dbo.tPLDbitacoraComandoBajaPpe (IdPersona)
			SELECT p.idpersona FROM @Ppes p			
		COMMIT TRANSACTION;		
		
		SELECT p.Nombre, p.RFC, pf.CURP, p.Domicilio
		from @Ppes ppe
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = ppe.IdPersona
		INNER JOIN dbo.tGRLpersonasFisicas pf WITH(NOLOCK) 
			ON pf.IdPersona = p.IdPersona

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


