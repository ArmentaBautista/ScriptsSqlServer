SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



CREATE OR ALTER   FUNCTION dbo.ValidarRFC (@EsPersonaMoral BIT, @RFC VARCHAR(13))
RETURNS BIT
AS
BEGIN
	DECLARE @Valido AS BIGINT=0
    --RETURN CASE WHEN @RFC LIKE '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]%' THEN 1 ELSE 0 END
	IF @EsPersonaMoral=1
		SET @Valido = CASE WHEN  (LEN(@RFC)=12 AND  
									@RFC LIKE '[A-Z][A-Z][A-Z][1-9][0-9][0-1][0-9][0-3][0-9][A-Z0-9][A-Z0-9][A-Z0-9]') 
									THEN 1 
									ELSE 0 
									END
	else
		SET @Valido = CASE WHEN  (LEN(@RFC)=13 AND  
									@RFC LIKE '[A-Z][A-Z][A-Z][A-Z][1-9][0-9][0-1][0-9][0-3][0-9][A-Z0-9][A-Z0-9][A-Z0-9]') 
									THEN 1 
									ELSE 0 
									END

	RETURN @Valido
END;
GO

