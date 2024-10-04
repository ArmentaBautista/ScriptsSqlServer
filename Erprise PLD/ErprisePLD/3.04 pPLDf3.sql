

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDf3')
BEGIN
	DROP PROC pPLDf3
	SELECT 'pPLDf3 BORRADO' AS info
END
GO

CREATE PROC pPLDf3
@TipoOperacion AS VARCHAR(20)='',
@Socio AS VARCHAR(30)=''
AS
BEGIN
	IF @TipoOperacion=''
		RETURN 0

	IF @TipoOperacion='F3Socio'
	BEGIN	
			DECLARE @fechaTrabajo AS DATE=GETDATE();

			SELECT 
			NoSocio =	sc.codigo
			,Nombre		  = p.nombre
			,pf.FechaNacimiento
			,p.RFC
			,pf.CURP
			,p.domicilio
			,p.EsPersonaMoral
			,sc.EsSocioValido
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			INNER JOIN tscssocios sc WITH(NOLOCK) 
				ON sc.idpersona = p.idpersona
			LEFT JOIN tgrlpersonasfisicas pf WITH(NOLOCK) 
				ON pf.idpersona = p.idpersona
			LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) 
				ON pm.IdPersona = p.IdPersona
			WHERE 
			(
					CASE
						WHEN sc.EsSocioValido=0 AND p.EsPersonaMoral=0 AND DATEDIFF(YEAR,ISNULL(pf.FechaNacimiento,@fechaTrabajo),@fechaTrabajo)<18
							THEN 1
						WHEN sc.EsSocioValido=1 AND p.EsPersonaMoral=1
							THEN 1
						WHEN sc.EsSocioValido=1 AND p.EsPersonaMoral=0
							THEN 1
						ELSE
							0
					END = 1
			)
			AND (sc.codigo LIKE '%' + @Socio + '%' OR p.nombre LIKE '%' + @Socio + '%')
			ORDER BY p.Nombre
	
			RETURN 0
	END

END
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pPLDf3')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pPLDf3')
END
GO
