


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Actualización del valor de rangos de transaccionalidad

-- PASO 1. MONTOS DE DEPÓSITOS Y RETIROS
/*

UPDATE ld SET ld.Valor= CAST(REPLACE(SUBSTRING(Descripcion,CHARINDEX('-',Descripcion)+3,LEN(Descripcion)),',','') AS NUMERIC(18,2)) FROM dbo.tCATlistasD ld WHERE ld.IdTipoE IN (175,177) AND valor	=0

*/

SELECT IdTipoE,Descripcion, ld.Valor FROM dbo.tCATlistasD ld WHERE ld.IdTipoE IN (175,177)

-- PASO 2. NÚMERO DE DEPÓSITOS Y RETIROS
/*

UPDATE ld SET ld.Valor = CAST(SUBSTRING(Descripcion,CHARINDEX('-',Descripcion)+1,LEN(Descripcion)) AS NUMERIC(18,2)) FROM dbo.tCATlistasD ld WHERE ld.IdTipoE IN (176,178) AND ld.Valor=0

*/

SELECT IdTipoE,Descripcion, ld.Valor FROM dbo.tCATlistasD ld WHERE IdTipoE IN (176,178)

