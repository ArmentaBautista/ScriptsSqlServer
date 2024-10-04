

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPERrelacionesPersonalesEmpleados')
BEGIN
	DROP PROC pCnPERrelacionesPersonalesEmpleados
	SELECT 'pCnPERrelacionesPersonalesEmpleados BORRADO' AS info
END
GO

CREATE PROC pCnPERrelacionesPersonalesEmpleados
@pNoEmpleado VARCHAR(20) = '*'
AS
BEGIN

		SELECT 
		[NoEmpleado]	= e.Codigo,
		[Nombre]	= CONCAT(pf.Nombre,' ',pf.ApellidoPaterno, ' ', pf.ApellidoMaterno),
		[NoSocio]	= sc.Codigo,
		[TipoRelacion]	= td.Descripcion,
		[NombreRelacion]	= prel.Nombre
		FROM dbo.tPERempleados e  WITH(NOLOCK)
		INNER JOIN dbo.tCTLestatusActual eae  WITH(NOLOCK) 
			ON eae.IdEstatusActual = e.IdEstatusActual
				AND eae.IdEstatus=1
		INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
			ON pf.IdPersonaFisica = e.IdPersonaFisica
		INNER JOIN dbo.tSCSsocios sc WITH (NOLOCK) 
			ON sc.IdPersona = pf.IdPersona
		INNER JOIN dbo.tSCSpersonasFisicasReferencias ref WITH (NOLOCK) 
			ON ref.RelReferenciasPersonales = pf.RelReferenciasPersonales
		INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) 
			ON td.IdTipoD = ref.IdTipoD
		INNER JOIN dbo.tGRLpersonas prel  WITH(NOLOCK) 
			ON prel.IdPersona = ref.IdPersona
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = ref.IdEstatusActual
				AND ea.IdEstatus=1
		WHERE (e.Codigo = '*' OR e.Codigo =@pNoEmpleado)

END
GO
