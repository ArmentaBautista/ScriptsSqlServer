CREATE or alter FUNCTION [dbo].[Funcion_JC_ValidaRFC2] 
(
    @RFC as VARCHAR(15) --No necesitas que sea tan largo
)
RETURNS BIT
AS
BEGIN
   declare @validacion bit 

    IF EXISTS(  SELECT *
                FROM(VALUES(10, '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]', 5), --PF sin homoclave
                           (13, '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z0-9][A-Z0-9][A-Z0-9]', 5), --PF con homoclave
                           (12, '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z0-9][A-Z0-9][A-Z0-9]', 4) --PM (siempre lleva homoclave)
                           )x(longitud, patron, iniciofecha)
                WHERE longitud = LEN( @RFC) -- Selecciona cual patrón usar (PF o PM)
                AND   @RFC LIKE patron -- Valida que el RFC cumpla con el patrón de letras y números
                AND   TRY_CONVERT( date, SUBSTRING( @RFC, iniciofecha, 6), 12) IS NOT NULL -- Valida que la fecha sea real
               )
        set @validacion = 1
    ELSE 
        set @validacion =0
	
	RETURN @validacion 
END

select dbo.Funcion_JC_ValidaRFC2('AEBJ820322TE7')



