

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pObtACTDATtercerosRepresentados')
BEGIN
	DROP PROC pObtACTDATtercerosRepresentados
	SELECT 'pObtACTDATtercerosRepresentados BORRADO' AS info
END
GO

CREATE PROC pObtACTDATtercerosRepresentados
@RETURN_MESSAGE VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion VARCHAR(16)='',
@pCadenaBusqueda VARCHAR(16)='',
@pIdPersona INT=0,
@pFolio INT=0
AS
BEGIN
	IF @pTipoOperacion=''
		RETURN -1;

	IF @pTipoOperacion='Persona'
	BEGIN
		SELECT 
		p.IdPersona,
		p.Nombre,
		p.RFC,
		sc.Codigo AS NoSocio,
		p.Domicilio,
		IIF(pb.IdPersonasBloqueadas IS NULL,0,1) AS Bloqueado	
		FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
		LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		LEFT JOIN dbo.tGRLpersonasBloqueadas pb  WITH(NOLOCK) 
			ON pb.IdPersona = p.IdPersona
		WHERE p.Nombre LIKE '%' + @pCadenaBusqueda + '%'
			OR sc.Codigo LIKE '%' + @pCadenaBusqueda + '%'

		RETURN 1
    END

	IF @pTipoOperacion='RelPer'
	BEGIN		
		SELECT
		 ref.IdReferenciaPersonal
		,ref.RelReferenciasPersonales
		,perref.IdPersona as IdPersonaReferencia
		,perref.Nombre
		,perref.RFC
		,perref.Domicilio
		,tipref.Descripcion AS TipoRelacion
		,ref.EsTutorPrincipal AS Tutor
		,ref.EsBeneficiario
		,ref.PorcentajeBeneficiario * 100 AS Porcentaje
		,ref.EsProveedorRecursos
		,ref.EsPropietarioReal
		FROM dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK)
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = ref.IdEstatusActual
				AND ea.IdEstatus=1
		INNER JOIN dbo.tGRLpersonas perref  WITH(NOLOCK) 
			ON perref.IdPersona = ref.IdPersona
		INNER JOIN dbo.tCTLtiposD tipref  WITH(NOLOCK) 
			ON tipref.IdTipoD = ref.IdTipoD
		WHERE ref.RelReferenciasPersonales=@pIdPersona

		RETURN 1
    END
	
	IF @pTipoOperacion='OperacionE'
	BEGIN
		SELECT 
		e.IdTercerosRepresentadosE,
		e.FechaTrabajo,
		p.IdPersona,
		p.Nombre
		FROM dbo.tACTDATtercerosRepresentadosE e  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = e.IdPersona
		WHERE p.Nombre LIKE '%' + @pCadenaBusqueda +'%'
			--OR e.IdTercerosRepresentadosE=@pFolio
			
		RETURN 1
    END

	IF @pTipoOperacion='OperacionD'
	BEGIN
		SELECT 
		d.IdReferenciaPersonal
		,d.RelReferenciasPersonales
		,perref.IdPersona as IdPersonaReferencia
		,perref.Nombre
		,perref.RFC
		,perref.Domicilio
		,tipref.Descripcion AS TipoRelacion
		,ref.EsTutorPrincipal AS Tutor
		,ref.EsBeneficiario
		,ref.PorcentajeBeneficiario * 100 AS Porcentaje
		,d.EsProveedorRecursos
		,d.EsPropietarioReal
		FROM dbo.tACTDATtercerosRepresentadosD d  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas perref  WITH(NOLOCK) 
			ON perref.IdPersona = d.IdPersonaReferencia
		INNER JOIN dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK) 
			ON ref.IdReferenciaPersonal = d.IdReferenciaPersonal
		INNER JOIN dbo.tCTLtiposD tipref  WITH(NOLOCK) 
			ON tipref.IdTipoD = ref.IdTipoD
		WHERE d.EsRegistroActual=1
			AND d.IdTercerosRepresentadosE=@pFolio

		RETURN 1
	END

END
GO
