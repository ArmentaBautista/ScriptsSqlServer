

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pValidarPersonaEsEmpleado')
BEGIN
	DROP PROC pValidarPersonaEsEmpleado
	SELECT 'pValidarPersonaEsEmpleado BORRADO' AS info
END
GO

CREATE PROC dbo.pValidarPersonaEsEmpleado 
@idPersona INT=0,
@esEmpleado BIT OUTPUT
AS
BEGIN
	
    IF EXISTS(SELECT 1 
				FROM dbo.tPERempleados emp  WITH(NOLOCK) 
				INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = emp.IdEstatusActual AND ea.IdEstatus=1
				WHERE emp.IdPersonaFisica=@idPersona)
		SET @esEmpleado= 1
	ELSE
		SET @esEmpleado= 0

	
END
GO







