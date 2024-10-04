
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fFMTconsultaBuroCYLpostConsulta')
BEGIN
	DROP FUNCTION fFMTconsultaBuroCYLpostConsulta
	SELECT 'fFMTconsultaBuroCYLpostConsulta BORRADO' AS info
END
GO

CREATE FUNCTION fFMTconsultaBuroCYLpostConsulta
(
	@FolioConsultaBuro AS VARCHAR(100)
)
RETURNS TABLE
AS
RETURN

(

SELECT 
	  Nombre = persona.Nombre,
	  persona.EsPersonaMoral,
	  personafisica.ActividadEmpresarial,
	  persona.RFC,
	  domicilio = CONCAT(domicilio.Calle, ' ', domicilio.NumeroExterior, ' ', domicilio.NumeroInterior),
	  Colonia = domicilio.Asentamiento,
	  Estado  = CONCAT(domicilio.Municipio,', ',domicilio.Estado),
	  domicilio.CodigoPostal,
	  telefono.Telefonos,
	  FechaAlta = '',
	  MunicipioDomiciilio  = domicilio.Municipio,
	  EstadoDomicilio = domicilio.Estado
	  --representante.Nombre
, eb.NumeroControlConsulta
, dbo.fCTLstrToDate(resp.FechaSolicitudReporteMasReciente) AS FechaBuro
FROM dbo.tGRLpersonas persona  WITH(NOLOCK)
INNER JOIN  dbo.tBURpeticionConsultaPersonaBuro p  WITH(NOLOCK) 
	ON p.IdPersona = persona.IdPersona
INNER JOIN dbo.tBURConsultaBuroCreditoE cb  WITH(NOLOCK)
	ON cb.IdConsultaBuroCredito = p.IdConsultaBuroCredito
INNER JOIN dbo.tBURrespuestaConsultaEncabezado eb
	ON eb.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
		AND eb.NumeroControlConsulta= @FolioConsultaBuro
INNER JOIN dbo.tBURrespuestaConsultaResumenReporte resp  WITH(NOLOCK) 
	ON resp.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
INNER JOIN dbo.tGRLpersonasFisicas personafisica  WITH(NOLOCK) ON personafisica.IdPersona = persona.IdPersona
LEFT JOIN dbo.vCTLDomiciliosPrincipales domicilio  WITH(NOLOCK) ON domicilio.IdRel = persona.IdRelDomicilios
LEFT JOIN dbo.vCATtelefonosAgrupados telefono WITH(NOLOCK) ON telefono.IdRel = persona.IdRelDomicilios
)
GO

