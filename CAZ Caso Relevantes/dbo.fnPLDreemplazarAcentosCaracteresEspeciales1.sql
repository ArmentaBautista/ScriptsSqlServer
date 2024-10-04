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

    -- Reemplazar vocales acentuadas min�sculas y may�sculas
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'A');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'E');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'I');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'O');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'U');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'A');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'E');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'I');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'O');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'U');

    -- Reemplazar "�" por "n"
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'N');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N'N');

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
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N' ');
    SET @CadenaSinAcentos = REPLACE (@CadenaSinAcentos, N'�', N' ');

    -- Devolver la cadena sin acentos ni caracteres especiales
    RETURN @CadenaSinAcentos;
END;
GO

