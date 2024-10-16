USE [iERP_FNG]
GO
/****** Object:  Trigger [dbo].[trValidarNombreLetrasModificacion]    Script Date: 11/01/2024 09:33:32 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[trValidarNombreLetrasModificacion] ON [dbo].[tGRLpersonasFisicas] 
 AFTER UPDATE
AS 
BEGIN
	IF UPDATE(Nombre) OR UPDATE(ApellidoPaterno) OR UPDATE(ApellidoMaterno)
	BEGIN	
		IF EXISTS(SELECT per.numero
				  FROM (SELECT numero= COUNT(IdPersonaFisica)
						FROM Deleted WITH(NOLOCK)
					   )per 
				  WHERE per.numero>1)
		BEGIN	
			RETURN 
		END 

		DECLARE @NumeroMaximoCambioLetras INT;
		SELECT @NumeroMaximoCambioLetras= TRY_PARSE(Valor AS INT)
		FROM dbo.tCTLconfiguracion WITH(NOLOCK)
		WHERE IdConfiguracion=331


		IF ISNULL(@NumeroMaximoCambioLetras,0) > 0
		BEGIN 
			DECLARE @Nombre VARCHAR(80),
					@ApellidoPaterno VARCHAR(30),
					@ApellidoMaterno VARCHAR(30),
					@IdPersona int,
					@MensajeCambios VARCHAR(max),
					@NumeroCambiosLetras INT;
			DECLARE @ValoresOriginales TABLE(Letra VARCHAR(8),IdPersona INT,Campo VARCHAR(20))
			
			DECLARE @NombreActual VARCHAR(80),
					@ApellidoPaternoActual VARCHAR(30),
					@ApellidoMaternoActual VARCHAR(30);
			DECLARE @ValoresNuevos TABLE(Letra VARCHAR(8),IdPersona INT,Campo VARCHAR(20))

			SELECT TOP 1 @Nombre=del.Nombre,@ApellidoPaterno=del.ApellidoPaterno
					,@ApellidoMaterno=del.ApellidoMaterno,@IdPersona=del.IdPersonaFisica
			FROM Deleted del WITH(NOLOCK)

			SELECT TOP 1 @NombreActual=ins.Nombre,@ApellidoPaternoActual=ins.ApellidoPaterno
					,@ApellidoMaternoActual=ins.ApellidoMaterno
			FROM Inserted ins WITH(NOLOCK)

			------------------***************************-------------------
			INSERT INTO @ValoresOriginales(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'Nombre'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@Nombre)
			----------------------------------------------------------------
			INSERT INTO @ValoresOriginales(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'ApellidoPaterno'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@ApellidoPaterno)
			----------------------------------------------------------------
			INSERT INTO @ValoresOriginales(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'ApellidoMaterno'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@ApellidoMaterno)
			------------------***************************-------------------
			INSERT INTO @ValoresNuevos(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'Nombre'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@NombreActual)
			----------------------------------------------------------------
			INSERT INTO @ValoresNuevos(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'ApellidoPaterno'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@ApellidoPaternoActual)
			----------------------------------------------------------------
			INSERT INTO @ValoresNuevos(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'ApellidoMaterno'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@ApellidoMaternoActual)
			----------------------------------------------------------------
			SELECT @MensajeCambios = CASE WHEN (LEN(@Nombre)<LEN(@NombreActual)) THEN
										CONCAT(':Num de letras que se agregaron al nombre: ',LEN(@NombreActual)-LEN(@Nombre),' valor original: ',@Nombre,' valor modificado: ',@NombreActual,CHAR(13))
									  WHEN (LEN(@Nombre)>LEN(@NombreActual)) then
										CONCAT(':Num de letras que se borraron al Nombre: ',LEN(@Nombre)-LEN(@NombreActual),' valor original: ',@Nombre,' valor modificado: ',@NombreActual,CHAR(13))
									  WHEN(@Nombre != @NombreActual) THEN
										CONCAT(':El Nombre ha cambiado, valor original: ',@Nombre,' valor modificado: ',@NombreActual,CHAR(13))
									END

			SELECT 	   @MensajeCambios = CONCAT(@MensajeCambios,CHAR(13), CASE WHEN (LEN(@ApellidoPaterno)<LEN(@ApellidoPaternoActual)) THEN
										CONCAT(':Num de letras que se agregaron al apellido paterno: ',LEN(@ApellidoPaternoActual)-LEN(@ApellidoPaterno),' valor original: ',@ApellidoPaterno,' valor modificado: ',@ApellidoPaternoActual,CHAR(13))
									WHEN (LEN(@ApellidoPaterno)>LEN(@ApellidoPaternoActual)) then
										CONCAT(':Num de letras que se borraron al apellido paterno: ',LEN(@ApellidoPaterno)-LEN(@ApellidoPaternoActual),' valor original: ',@ApellidoPaterno,' valor modificado: ',@ApellidoPaternoActual,CHAR(13))
									WHEN(@ApellidoPaterno != @ApellidoPaternoActual) THEN
										CONCAT(':El apellido paterno no son iguales valor original: ',@ApellidoPaterno,' valor modificado: ',@ApellidoPaternoActual,CHAR(13))
										END)

			SELECT @MensajeCambios = CONCAT(@MensajeCambios,CHAR(13),CASE WHEN (LEN(@ApellidoMaterno)<LEN(@ApellidoMaternoActual)) THEN
													CONCAT(':Num de letras que se agregaron al apellido materno: ',LEN(@ApellidoMaternoActual)-LEN(@ApellidoMaterno),' valor original: ',@ApellidoMaterno,' valor modificado: ',@ApellidoMaternoActual,CHAR(13))
												  WHEN (LEN(@ApellidoMaterno)>LEN(@ApellidoMaternoActual)) then
													CONCAT(':Num de letras que se borraron al apellido materno: ',LEN(@ApellidoMaterno)-LEN(@ApellidoMaternoActual),' valor original: ',@ApellidoMaterno,' valor modificado: ',@ApellidoMaternoActual,CHAR(13))
												WHEN(@ApellidoMaterno != @ApellidoMaternoActual) THEN
														CONCAT(':El apellido materno no son iguales valor original: ',@ApellidoMaterno,' valor modificado: ',@ApellidoMaternoActual,CHAR(13))
											 END)

			
			SELECT @NumeroCambiosLetras=SUM(IIF(valOri.Letra=nuevo.Letra,0,1)) 
			FROM (SELECT *,numerador=ROW_NUMBER() OVER(PARTITION BY IdPersona ORDER BY IdPersona)
			FROM @ValoresOriginales)valOri
			INNER JOIN (SELECT Letra,numerador=ROW_NUMBER() OVER(PARTITION BY IdPersona ORDER BY IdPersona)
						FROM @ValoresNuevos) nuevo ON nuevo.numerador= valOri.numerador
			
			IF ISNULL(@NumeroCambiosLetras,0)>0
				SET @MensajeCambios =CONCAT(@MensajeCambios,CHAR(13),'Total de Cambios: ',@NumeroCambiosLetras)

			--SELECT @MensajeCambios
			PRINT(@MensajeCambios)
			--SELECT @NumeroCambiosLetras
			IF ISNULL(@NumeroCambiosLetras,0)>@NumeroMaximoCambioLetras
			BEGIN
				SET @MensajeCambios =CONCAT('CodEx|02787|trValidarNombreLetrasModificacion| ',@MensajeCambios)
				RAISERROR(@MensajeCambios, 16, 8) ;
                RETURN ;
			END 

		END 
	END 
END 


 
