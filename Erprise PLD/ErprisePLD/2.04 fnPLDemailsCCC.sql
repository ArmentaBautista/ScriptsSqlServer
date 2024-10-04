
-- 2.04 fnPLDemailsCCC


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDemailsCCC')
BEGIN
	DROP FUNCTION fnPLDemailsCCC
	SELECT 'fnPLDemailsCCC BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDemailsCCC()
RETURNS @correos TABLE (
	IdPersona		INT,
	Nombre			VARCHAR(250),
	Puesto			VARCHAR(250),
	Email			VARCHAR(80)
)
BEGIN

		INSERT INTO @correos
		SELECT 
		p.IdPersona, p.Nombre, ld.Descripcion AS Puesto, mail.Email
		FROM dbo.tPLDccc ccc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = ccc.IdPersona
		INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) 
			ON ld.IdListaD = ccc.IdListaDpuesto
				AND ld.IdListaD <> -49 -- Todos menos el Oficial de Cumplimiento
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = ccc.IdEstatusActual
				AND ea.IdEstatus=1
		INNER JOIN (
						SELECT tabla.IdRel,MAX(tabla.email) AS Email 
						FROM (
							  SELECT email.IdRel,email FROM dbo.tCATemails email With (nolock) 
							  JOIN dbo.tCTLestatusActual ea With (nolock)  ON ea.IdEstatusActual = email.IdEstatusActual
							  JOIN dbo.tCATlistasD l With (nolock) 
								ON l.IdListaD = email.IdListaD
									AND l.IdListaD IN (-22,-21) -- Correos corporativo y de trabajo
							  WHERE ea.IdEstatus=1
						)
						AS tabla
						GROUP BY tabla.IdRel) mail
	ON mail.IdRel = p.IdRelEmails

	RETURN
END
GO

IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='fnPLDemailsCCC')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('fnPLDemailsCCC')
END
GO
