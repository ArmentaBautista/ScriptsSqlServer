

/* JCA.19/4/2024.01:49 
Nota: Riesgo Operativo. Devuelve los datos del usuario de la sesion, se usa para llenar los datos de quien captura el reporte
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRriesgoOperativo')
BEGIN
	DROP PROC pAIRriesgoOperativo
	SELECT 'pAIRriesgoOperativo BORRADO' AS info
END
GO

CREATE PROC pAIRriesgoOperativo
@pTipoOperacion VARCHAR(16),
@pIdSesion	INT
AS
BEGIN
	
	IF @pTipoOperacion='USER'
	BEGIN
		
		SELECT
		TOP 1
		[IdUsuario]		= ISNULL(u.IdUsuario,-1), 
		[Usuario]		= ISNULL(u.Usuario,'SYSTEM'),
		[Nombre]		= ISNULL(p.Nombre,''),
		[IdEmpleado]	= ISNULL(emp.IdEmpleado,0),
		[IdPuesto]		= ISNULL(puesto.IdPuesto,0),
		[Puesto]		= ISNULL(puesto.Descripcion,''),
		[IdDepartamento]= ISNULL(depto.IdDepartamento,0),
		[Departamento]	= ISNULL(depto.Descripcion,'')
		FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK) 
			ON s.IdUsuario = u.IdUsuario
				AND s.IdSesion=@pIdSesion
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersonaFisica = u.IdPersonaFisica
		LEFT JOIN dbo.tPERempleados emp  WITH(NOLOCK) 
			ON emp.IdPersonaFisica = p.IdPersonaFisica
		LEFT JOIN dbo.tPERpuestos puesto  WITH(NOLOCK) 
			ON puesto.IdPuesto = emp.IdPuesto
		LEFT JOIN dbo.tPERdepartamentos depto  WITH(NOLOCK) 
			ON depto.IdDepartamento = puesto.IdDepartamento
		WHERE u.IdUsuario<>0
		RETURN 1
	END

END
GO






