USE [iERP_FNG]
GO
/****** Object:  Trigger [dbo].[trValidarRazonSocialLetrasModificacion]    Script Date: 11/01/2024 11:08:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[trValidarRazonSocialLetrasModificacion] ON [dbo].[tGRLpersonas]
 AFTER UPDATE
AS 
BEGIN
	IF UPDATE(Nombre) OR UPDATE(RazonSocial)
	BEGIN	

		IF EXISTS(SELECT 1 FROM Deleted WHERE Deleted.IdPersonaFisica<>0)
		BEGIN	
			RETURN 
		END
		
		IF EXISTS(SELECT per.numero
				  FROM (SELECT numero= COUNT(IdPersonaMoral)
						FROM Deleted
					   )per 
				  WHERE per.numero>1)
		BEGIN	
			RETURN 
		END 

		DECLARE @MensajeCambios VARCHAR(max)

		IF EXISTS(SELECT 1 
					FROM Deleted d 
					INNER JOIN Inserted i ON i.IdPersona = d.IdPersona
					WHERE d.RazonSocial<>i.RazonSocial OR d.Nombre<>i.Nombre)
		BEGIN	
			SET @MensajeCambios =CONCAT('CodEx|02787|trValidarRazonSocialLetrasModificacion| :',@MensajeCambios)
				RAISERROR('El nombre ha cambiado, acción no permitida.', 16, 8) ;
                RETURN ;
		END
		


		DECLARE @NumeroMaximoCambioLetras INT;
		SELECT @NumeroMaximoCambioLetras= TRY_PARSE(Valor AS INT)
		FROM dbo.tCTLconfiguracion WITH(NOLOCK)
		WHERE IdConfiguracion=331

		IF ISNULL(@NumeroMaximoCambioLetras,0) > 0
		BEGIN 
			DECLARE @Nombre VARCHAR(80),
					@IdPersona int,
					
					@NumeroCambiosLetras INT;
			DECLARE @ValoresOriginales TABLE(Letra VARCHAR(8),IdPersona INT,Campo VARCHAR(20))
			
			DECLARE @NombreActual VARCHAR(80)
			DECLARE @ValoresNuevos TABLE(Letra VARCHAR(8),IdPersona INT,Campo VARCHAR(20))

			SELECT TOP 1 @Nombre=del.Nombre,@IdPersona=del.IdPersonaFisica
			FROM Deleted del WITH(NOLOCK)

			SELECT TOP 1 @NombreActual=ins.Nombre
			FROM Inserted ins WITH(NOLOCK)

			------------------***************************-------------------
			INSERT INTO @ValoresOriginales(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'Nombre'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@Nombre)
			----------------------------------------------------------------			
			------------------***************************-------------------
			INSERT INTO @ValoresNuevos(Letra,IdPersona,Campo)			
			SELECT oneChar,@IdPersona,'Nombre'
			FROM dbo.ufn_TiL_SeparaEnCaracteres(@NombreActual)
			----------------------------------------------------------------
			SELECT @MensajeCambios = CASE WHEN (LEN(@Nombre)<LEN(@NombreActual)) THEN
										CONCAT('Num de letras que se agregaron al nombre ',LEN(@NombreActual)-LEN(@Nombre),CHAR(13))
									  WHEN (LEN(@Nombre)>LEN(@NombreActual)) then
										CONCAT('Num de letras que se borraron al nombre ',LEN(@Nombre)-LEN(@NombreActual),CHAR(13))
									  WHEN(@Nombre != @NombreActual) THEN
										CONCAT('El nombre no son iguales valor original: ',@Nombre,' valor modificado: ',@NombreActual,CHAR(13))
									END


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
				SET @MensajeCambios =CONCAT('CodEx|02787|trValidarRazonSocialLetrasModificacion| :',@MensajeCambios)
				RAISERROR(@MensajeCambios, 16, 8) ;
                RETURN ;
			END 

		END 
	END 
END 


 
