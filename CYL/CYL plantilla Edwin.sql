


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCYL_MODnombreProcedimiento')
BEGIN
	DROP PROC pCYL_MODnombreProcedimiento
	SELECT 'pCYL_MODnombreProcedimiento BORRADO' AS info
END
GO

CREATE PROC pCYL_MODnombreProcedimiento
@pArgumento1 AS DATE,
@pArgumento2 AS DATE
AS
BEGIN
	/* @^..^@   JCA.02/02/2024.12:48 p. m. Nota: Aquí ingresa tu código   */
	SELECT CAST(@pArgumento1 AS VARCHAR(10))

	/*  (◕ᴥ◕)    JCA.02/02/2024.12:50 p. m. Nota: Si tu procedimiento no requiere parámetros, simplemente quitalos de la firma del SP  */


END
GO