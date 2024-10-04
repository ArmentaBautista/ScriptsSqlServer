

CREATE FUNCTION [dbo].[fn_convert_numbers](@number BIGINT)      
RETURNS VARCHAR(MAX)      
AS        
BEGIN       
DECLARE @numberToText AS VARCHAR(MAX)      
DECLARE @UDC_Millon AS BIGINT      
DECLARE @UDC_Millar AS BIGINT      
DECLARE @C AS BIGINT      
DECLARE @D AS BIGINT      
DECLARE @U AS BIGINT      
DECLARE @Bandera AS INT      
DECLARE @final AS VARCHAR(MAX)      
SET @numberToText = ''      
SET @Bandera = 1      
       
SET @UDC_Millon = FLOOR(@number/1000000)    --Para obtener los millones en 3 cifras = MMM---... -> MMM      
SET @UDC_Millar = FLOOR((@number%1000000)/1000)   --Para obtener los millares en 3 cifras = ---MMM... -> MMM      
SET @C  = FLOOR(@number/100)-(FLOOR(@number/1000)*10) --Para obtener, desde un grupo de 3 cifras, la centena = C-- -> C      
SET @D  = FLOOR(@number/10)-(FLOOR(@number/100)*10)  --Para obtener, desde un grupo de 3 cifras, la decena = -D-  -> D      
SET @U  = @number - (FLOOR(@number/10)*10)    --Para obtener, desde un grupo de 3 cifras, la unidad = --U  -> U      
/*      
  DEBIDO A QUE ES ESPAGUETHIFICADO, SE RECORRE CADA PARTE UNA VEZ,      
   A EXCEPCION DONDE SE HACE LA LLAMADA A SÍ MISMA PARA CONTAR GRUPOS DE 3 CIFRAS. Debido a que van en la estructura UDC, pasarán directamente a los pasos 3,4 y 5      
  PASOS      
   1) OBTENEMOS UDC_Millon.      
    SI ES =1; NUMBERTOTEXT -> 'UN MILLON' + @NUMBERTOTEXT      
    SI ES >1; NUMBERTOTEXT -> numberToWords(UDC_Millon) + ' MILLONES '      
   2) OBTENEMOS UDC_Millar      
    SI ES =1; NUMBERTOTEXT -> @NUMBERTOTEXT + 'UN MIL'      
    SI ES >1; NUMBERTOTEXT -> @NUMBERTOTEXT + numberToWords(UDC_Millar) + ' MIL '      
   3) OBTENEMOS LAS CENTENAS -> @NUMBERTOTEXT + TEXTO      
   4) OBTENEMOS LAS DECENAS -> @NUMBERTOTEXT + TEXTO      
   5) OBTENEMOS LAS UNIDADES -> @NUMBERTOTEXT + TEXTO      
   FIN) RETORNAR TEXTO      
*/      
IF(@UDC_Millon > 0)      
  BEGIN      
   SELECT @numberToText = CASE      
    WHEN @UDC_Millon=1 THEN 'UN MILLON ' + @numberToText      
    WHEN @UDC_Millon>1 THEN dbo.fn_convert_numbers(@UDC_Millon) + 'MILLONES '      
   END      
  END      
       
IF(@UDC_Millar > 0)      
  BEGIN      
   SELECT @numberToText = CASE      
    WHEN @UDC_Millar=1 THEN @numberToText + 'UN MIL '      
    WHEN @UDC_Millar>1 THEN @numberToText + dbo.fn_convert_numbers(@UDC_Millar) + 'MIL '      
   END      
  END      
      
/* - - - - - - - - - - - - - - - - */      
/* * * * * * * PARTE RECURSIVA * * * * * * */      
/* - - - - - - - - - - - - - - - - */      
       
IF (@C > 0)      
--SEPARAR CENTENAS      
  BEGIN      
   SELECT @numberToText = CASE      
    WHEN (@C = 1 AND @D = 0 AND @U = 0) THEN @numberToText+'CIEN '      
    WHEN @C=1 THEN @numberToText+'CIENTO '      
    WHEN @C=2 THEN @numberToText+'DOSCIENTOS '      
    WHEN @C=3 THEN @numberToText+'TRESCIENTOS '      
    WHEN @C=4 THEN @numberToText+'CUATROCIENTOS '      
    WHEN @C=5 THEN @numberToText+'QUINIENTOS '      
    WHEN @C=6 THEN @numberToText+'SEISCIENTOS '      
    WHEN @C=7 THEN @numberToText+'SETECIENTOS '      
    WHEN @C=8 THEN @numberToText+'OCHOCIENTOS '      
    WHEN @C=9 THEN @numberToText+'NOVECIENTOS '      
   END      
  END      
IF (@D = 1)      
--SEPARAR ENTRE 10 y 19      
  BEGIN      
   SET @Bandera = 0 --Bandera -> No requerimos 'y' para la cifra      
   SELECT @numberToText = CASE      
    WHEN (@D*10 + @U)  = 10 THEN @numberToText+'DIEZ '      
    WHEN (@D*10 + @U) = 11 THEN @numberToText+'ONCE '      
    WHEN (@D*10 + @U) = 12 THEN @numberToText+'DOCE '      
    WHEN (@D*10 + @U) = 13 THEN @numberToText+'TRECE '      
    WHEN (@D*10 + @U) = 14 THEN @numberToText+'CATORCE '      
    WHEN (@D*10 + @U) = 15 THEN @numberToText+'QUINCE '      
    WHEN (@D*10 + @U) = 16 THEN @numberToText+'DIECISEIS '      
    WHEN (@D*10 + @U) = 17 THEN @numberToText+'DIECISIETE '      
    WHEN (@D*10 + @U) = 18 THEN @numberToText+'DIECIOCHO '      
    WHEN (@D*10 + @U) = 19 THEN @numberToText+'DIECINUEVE '      
   END      
  END      
ELSE      
  IF (@D > 0)      
  --SEPARAR DECENAS      
   BEGIN      
    SELECT @numberToText = CASE      
     WHEN (@D = 2 AND @U>0) THEN @numberToText+'VEINTI'      
     WHEN (@D = 2 AND @U=0) THEN @numberToText+'VEINTE '      
     WHEN @D = 3 THEN @numberToText+'TREINTA '      
     WHEN @D = 4 THEN @numberToText+'CUARENTA '      
     WHEN @D = 5 THEN @numberToText+'CINCUENTA '      
     WHEN @D = 6 THEN @numberToText+'SESENTA '      
     WHEN @D = 7 THEN @numberToText+'SETENTA '      
     WHEN @D = 8 THEN @numberToText+'OCHENTA '      
     WHEN @D = 9 THEN @numberToText+'NOVENTA '      
     ELSE @numberToText      
    END      
    IF (@D=2 AND @U>0) SET @Bandera=2 --Bandera -> equerimos 'y' para la cifra      
   END      
  IF (@U > 0 AND @D > 0 AND @Bandera = 1) BEGIN SET @numberToText += 'Y ' END --Bandera -> Asignamos 'y' a la cifra      
  IF (@U > 0 AND @Bandera > 0)      
  --SEPARAR UNIDADES      
   BEGIN      
    SELECT @numberToText = CASE      
     WHEN (@U = 1 AND @UDC_Millar >= 0) THEN @numberToText + 'UN '      
     WHEN (@U = 1 AND @UDC_Millar = 0) THEN @numberToText + 'UNO '      
     WHEN @U = 2 THEN @numberToText + 'DOS '      
     WHEN @U = 3 THEN @numberToText + 'TRES '      
     WHEN @U = 4 THEN @numberToText + 'CUATRO '      
     WHEN @U = 5 THEN @numberToText + 'CINCO '      
     WHEN @U = 6 THEN @numberToText + 'SEIS '      
     WHEN @U = 7 THEN @numberToText + 'SIETE '      
     WHEN @U = 8 THEN @numberToText + 'OCHO '      
     WHEN @U = 9 THEN @numberToText + 'NUEVE '      
    END      
   END      
RETURN @numberToText      
END