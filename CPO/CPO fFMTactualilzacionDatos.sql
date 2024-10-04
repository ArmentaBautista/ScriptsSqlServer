SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


create FUNCTION fFMTactualilzacionDatos
(
@Codigo AS varchar(30) = ''
)
RETURNS TABLE
AS
RETURN	
(
	SELECT 
			personafisica.RelReferenciasPersonales, 
	        persona.IdRelTelefonos, socio.Codigo, persona.Nombre,
	        CONCAT(domicilio.Calle,' N° ',domicilio.NumeroExterior,' INT ',
	        domicilio.NumeroInterior) AS domicilio,
	        domicilio.Calles, 
	        domicilio.Asentamiento AS colonia, 
	        domicilio.CodigoPostal, 
	        domicilio.Ciudad AS Localidad,	
	        domicilio.Municipio, 
	        domicilio.Estado, 
	        telefonos.TelefonoCasa,
	        telefonos.TelefonoCelular,
	        correo.Emails,  
	        personafisica.Sexo, 
	        personafisica.FechaNacimiento, 
	        InicioResidencia = CONCAT(analisis.TiempoResidenciaActual, ' Meses'),
	        pfrconyuge.NombreReferencia AS Conyuge,
	        tdestcivil.Descripcion AS EstadoCivil,
	        listaocupacion.Descripcion AS Ocupacion, 
	        tipovivienda.Descripcion AS EstatusVivienda, 
	        socio.UltimoCambio,
	        IIF(@Codigo='00079831','MARICELA LOPEZ MARTINEZ'
			,CONCAT(personausuario.Nombre,' ', personausuario.ApellidoPaterno,' ', personausuario.ApellidoMaterno)) AS Usuario, 
	        sucursalsesion.Descripcion AS Sucursal,
	        referenciatutor.Nombre AS Tutor, 
	        CONCAT(domtutor.Calle,' ', domtutor.NumeroExterior,' ',domtutor.NumeroInterior) AS DomicilioTutor

FROM dbo.tSCSsocios                                 socio
	INNER JOIN dbo.tGRLpersonas                     persona			WITH(NOLOCK) ON persona.IdPersona					= socio.IdPersona
	INNER JOIN dbo.tGRLpersonasFisicas              personafisica	WITH(NOLOCK) ON personafisica.IdPersona				= socio.IdPersona
	INNER JOIN dbo.vCTLDomiciliosPrincipales        domicilio		WITH(NOLOCK) ON domicilio.IdRel						= persona.IdRelDomicilios
	INNER JOIN dbo.tSCSpersonasSocioeconomicos      socioeconomico	WITH(NOLOCK) ON socioeconomico.IdSocioeconomico		= persona.IdSocioeconomico
	INNER JOIN dbo.tCTLusuarios                     usuario			WITH(NOLOCK) ON usuario.IdUsuario					= socio.IdUsuarioCambio
	INNER JOIN dbo.tGRLpersonasFisicas              personausuario	WITH(NOLOCK) ON personausuario.IdPersonaFisica		= usuario.IdPersonaFisica
	INNER JOIN dbo.tCTLsesiones                     sesion			WITH(NOLOCK) ON sesion.IdSesion						= socio.IdSesion
	INNER JOIN dbo.tCTLsucursales                   sucursalsesion	WITH(NOLOCK) ON sucursalsesion.IdSucursal			= sesion.IdSucursal
	INNER JOIN dbo.tCTLtiposD                       tdestcivil		WITH(NOLOCK) ON tdestcivil.IdTipoD					= personafisica.IdTipoDEstadoCivil
	LEFT  JOIN dbo.vSCSpersonasFisicasReferencias   pfrconyuge	    WITH(NOLOCK) ON pfrconyuge.IdPersona				= personafisica.IdPersona 
																														  AND pfrconyuge.IdTipoD = 290
	LEFT  JOIN dbo.vCATtelefonosyCelularesAgrupados telefonos	    WITH(NOLOCK) ON telefonos.IdRel						= persona.IdRelTelefonos
	LEFT  JOIN dbo.vCATEmailsAgrupados              correo			WITH(NOLOCK) ON correo.IdRel						= persona.IdRelEmails
	LEFT  JOIN dbo.tGRLpersonasFisicas              pftutor			WITH(NOLOCK) ON pftutor.IdPersona					= persona.IdPersona
	LEFT  JOIN dbo.vFMTpersonasFisicasReferencias   referencia      WITH(NOLOCK) ON referencia.RelReferenciasPersonales = pftutor.IdPersonaFisica 
	                                                                                                                      AND referencia.EsTutorPrincipal = 1
	LEFT  JOIN dbo.tGRLpersonas                     referenciatutor WITH(NOLOCK) ON referenciatutor.IdPersona			= referencia.IdPersona  
	LEFT  JOIN dbo.vCTLDomiciliosPrincipales        domtutor	    WITH(NOLOCK) ON domtutor.IdRel						= referenciatutor.IdRelDomicilios
	LEFT  JOIN dbo.tCATlistasD                      listaocupacion	WITH(NOLOCK) ON listaocupacion.IdListaD				= personafisica.IdListaDOcupacion
	LEFT  JOIN dbo.tSCSanalisisCrediticio           analisis        WITH(NOLOCK) ON analisis.IdPersona                  = persona.IdPersona
	LEFT  JOIN dbo.tSCSanalisisIngresosEgresos      egreso          WITH(NOLOCK) ON egreso.IdAnalisisCrediticio         = analisis.IdAnalisisCrediticio 
	LEFT  JOIN dbo.tCTLtiposD                       tipovivienda	WITH(NOLOCK) ON tipovivienda.IdTipoD				= analisis.IdTipoDresidencia
WHERE socio.Codigo = @Codigo
)





GO

