

USE ErpriseExpediente
GO

/*
Tipo: Procedimiento
Objeto: pGRLpersonas
Resumen: Concentra las operaciones sobre personas.
*/


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLpersonas')
BEGIN
	DROP PROC pGRLpersonas
	SELECT 'pGRLpersonas BORRADO' AS info
END
GO

CREATE PROC pGRLpersonas
@TipoOperacion AS VARCHAR(20)='',
@Socio AS VARCHAR(30)=''
AS
BEGIN
	IF @TipoOperacion=''
		RETURN -1

	IF @TipoOperacion='GET'
	BEGIN	
			SELECT 
			Identificador =	p.NumeroSocio
			,Nombre		  = CONCAT(p.NombreRazonSocial,' '
								, IIF(p.Nombre2<>'',p.Nombre2 + ' ','')
								, p.ApellidoPaterno,' '
								, p.ApellidoMaterno)
			,p.FechaNacimiento,p.RFC,p.CURP
			, p.IdSocio
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			WHERE p.ClavePersona LIKE '%' + @Socio + '%' 
			OR CONCAT(p.NombreRazonSocial,' '
								, IIF(p.Nombre2<>'',p.Nombre2 + ' ','')
								, p.ApellidoPaterno,' '
								, p.ApellidoMaterno) LIKE '%' + @Socio + '%'
			ORDER BY p.NombreRazonSocial,p.Nombre2,p.ApellidoPaterno,p.ApellidoMaterno
	
			RETURN 0
	END

END