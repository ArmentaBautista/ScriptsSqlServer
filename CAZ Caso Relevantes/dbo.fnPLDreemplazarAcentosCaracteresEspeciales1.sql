SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER FUNCTION dbo.fnPLDreemplazarAcentosCaracteresEspeciales
(
    @Cadena NVARCHAR(4000)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
    DECLARE @CadenaSinAcentos NVARCHAR(4000);

    -- Inicializar @CadenaSinAcentos con el valor de @Cadena
    SET @CadenaSinAcentos = @Cadena;

    -- Reemplazar vocales acentuadas minúsculas y mayúsculas
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'á', N'A');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'é', N'E');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'í', N'I');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'ó', N'O');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'ú', N'U');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'Á', N'A');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'É', N'E');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'Í', N'I');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'Ó', N'O');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'Ú', N'U');

    -- Reemplazar "ñ" por "n"
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'ñ', N'N');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'Ñ', N'N');

    -- Reemplazar caracteres especiales por un espacio
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'!', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'#', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'%', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'&', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'/', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'(', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N')', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'=', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'?', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'¡', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'¿', N' ');

    -- Devolver la cadena sin acentos ni caracteres especiales
    RETURN @CadenaSinAcentos;
END;
GO

