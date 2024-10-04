
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnGRLpersonas')
BEGIN
	DROP PROC pCnGRLpersonas
END
GO

CREATE PROC pCnGRLpersonas
@nombre AS VARCHAR(128)='',
@curp AS VARCHAR(30)='',
@rfc AS VARCHAR(12)=''
AS
	
	IF @nombre IS NOT NULL AND  LEN(@nombre)>4 AND @nombre !='*'
	BEGIN
	PRINT @nombre;
			SELECT p.IdPersona, p.Nombre, pm.FechaConstitucion, pf.FechaNacimiento, p.RFC, pf.CURP, p.Domicilio, soc.Codigo AS NoSocio, soc.EsSocioValido AS TieneAportacion
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
			LEFT JOIN dbo.tSCSsocios soc  WITH(NOLOCK) ON soc.IdPersona = p.IdPersona
			WHERE p.Nombre LIKE '%' + @nombre + '%'

			
	end
	
	IF @rfc IS NOT NULL AND LEN(@rfc)>4 AND @rfc !='*'
	BEGIN
	PRINT @rfc;
			SELECT p.IdPersona, p.Nombre, pm.FechaConstitucion, pf.FechaNacimiento, p.RFC, pf.CURP, p.Domicilio, soc.Codigo AS NoSocio, soc.EsSocioValido AS TieneAportacion
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
			LEFT JOIN dbo.tSCSsocios soc  WITH(NOLOCK) ON soc.IdPersona = p.IdPersona
			WHERE p.RFC LIKE '%' + @rfc + '%'

			RETURN
	END
    	
	IF @curp IS NOT NULL AND LEN(@curp)>4 AND @curp !='*'
	BEGIN
	PRINT @curp;
			SELECT p.IdPersona, p.Nombre, pm.FechaConstitucion, pf.FechaNacimiento, p.RFC, pf.CURP, p.Domicilio, soc.Codigo AS NoSocio, soc.EsSocioValido AS TieneAportacion
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
			LEFT JOIN dbo.tSCSsocios soc  WITH(NOLOCK) ON soc.IdPersona = p.IdPersona
			WHERE pf.CURP LIKE '%' + @curp + '%'

			RETURN
	END
GO

