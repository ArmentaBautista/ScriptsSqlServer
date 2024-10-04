
-- 35



UPDATE c SET c.SQL='
SELECT 
IdSocio,
SocioCodigo,
Codigo,
Descripcion,
PersonaNombre,
PersonaDomicilio,
CodigoInterfaz,
IdEstatus,
EstatusCodigo,
EstatusDescripcion,
EsSocioValido,
PersonaIdPersona
FROM (
		select
			IdSocio,
			SocioCodigo			= tSCSsocios.Codigo,
			Codigo = tSCSsocios.Codigo,
			Descripcion = Nombre,
			PersonaNombre		= Nombre,
			PersonaDomicilio	= Domicilio,
			CodigoInterfaz		= tSCSsocios.CodigoInterfaz,
			IdEstatus			= tCTLestatus.IdEstatus,
			EstatusCodigo		= tCTLestatus.Codigo,
			EstatusDescripcion	= tCTLestatus.Descripcion,
			EsSocioValido		= tSCSsocios.EsSocioValido,
			PersonaIdPersona    = tGRLpersonas.IdPersona
		FROM		tSCSsocios			WITH(NOLOCK)
		INNER JOIN	tGRLpersonas		WITH(NOLOCK) ON tGRLpersonas.IdPersona		= tSCSsocios.IdPersona
		INNER JOIN	tCTLestatus			WITH(NOLOCK) ON tSCSsocios.IdEstatus = tCTLestatus.IdEstatus
		WHERE IdSocio != 0 and tCTLestatus.idestatus=1
) t where 1=1 '
,tituloventana='Socios F3'
--, CampoEstatusFiltro='tCTLestatus.IdEstatus'
--,CampoCodigo='tSCSsocios.Codigo',CampoDescripcion='PersonaNombre', orden='PersonaNombre'
FROM dbo.tCTLconsultas c  WITH(NOLOCK) 
WHERE c.IdConsulta in (35,123,423,777)

GO




