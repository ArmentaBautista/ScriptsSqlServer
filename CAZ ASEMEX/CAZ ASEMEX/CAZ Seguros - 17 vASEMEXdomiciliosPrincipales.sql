
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vASEMEXdomiciliosPrincipales')
BEGIN
	DROP VIEW vASEMEXdomiciliosPrincipales
	SELECT 'vASEMEXdomiciliosPrincipales BORRADO' AS info
END
GO

CREATE VIEW dbo.vASEMEXdomiciliosPrincipales
AS
SELECT TMP.IdRel
     , TMP.NumeroExterior
     , TMP.NumeroInterior
     , TMP.CodigoPostal
     , TMP.Referencia
     , TMP.Calle
     , TMP.Calles
     , TMP.Asentamiento
     , TMP.Ciudad
     , TMP.Municipio
     , TMP.Estado
     , TMP.IdEstado
     , TMP.IdDomicilio
     , TMP.Pais
FROM ( 
		select rel.IdRel
		, iif(dom.NumeroExterior in ('0','',null),'SN',dom.NumeroExterior) as NumeroExterior
		,dom.NumeroInterior
		,dom.CodigoPostal,dom.Referencia,dom.Calle,
		dom.Calles, dom.Asentamiento AS Asentamiento, cd.Descripcion AS Ciudad, mun.Descripcion AS Municipio, edo.Descripcion AS Estado,
		dom.IdAsentamiento, dom.IdCiudad, dom.IdMunicipio, dom.IdEstado, dom.IdEstatusActual, ea.IdEstatus,
		dom.HoraLocalizacionInicial, dom.HoraLocalizacionFinal, dom.IdDomicilio,
		NumeroRegistro = ROW_NUMBER() OVER ( PARTITION BY dom.IdRel ORDER BY dom.IdDomicilio DESC ), dom.Pais
		FROM dbo.tCATdomicilios dom WITH(NOLOCK) 
		JOIN dbo.tCTLrelaciones rel ON rel.IdRel = dom.IdRel
		JOIN dbo.tCTLtiposD tdom WITH(NOLOCK) ON tdom.IdTipoD = dom.IdTipoD
		JOIN dbo.tCTLasentamientos a WITH(NOLOCK) ON a.IdAsentamiento=dom.IdAsentamiento
		JOIN dbo.tCTLciudades cd WITH(NOLOCK) ON cd.IdCiudad = dom.IdCiudad
		JOIN dbo.tCTLmunicipios mun WITH(NOLOCK) ON mun.IdMunicipio = dom.IdMunicipio
		JOIN dbo.tCTLestados edo WITH(NOLOCK) ON edo.IdEstado = dom.IdEstado
		JOIN dbo.tCTLestatusActual ea WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual 
		JOIN dbo.tCTLestatus e WITH(NOLOCK) ON e.IdEstatus = ea.IdEstatus AND e.IdEstatus = 1
		WHERE tdom.IdTipoD=11 
		) AS TMP
WHERE NumeroRegistro = 1


GO

