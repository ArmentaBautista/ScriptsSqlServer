

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='vCnDatosIngresoSocios')
BEGIN
	DROP VIEW vCnDatosIngresoSocios
END
GO

CREATE VIEW vCnDatosIngresoSocios
AS

SELECT
				soc.IdSocio,																
				sucu.IdSucursal,
				sucu.Codigo															   AS CodigoSucursal,
				sucu.Descripcion													   AS Sucursal,
                soc.Codigo                                                             AS NumeroSocio,
                soc.FechaAlta                                                          AS FechaIngreso,
                soc.FechaBaja,
                per.ActividadEmpresarial                                               AS TipoFisicaActEmpresarial,
                per.Nombre															   AS NombreCompleto,
				per.Nombre															   AS Nombre,
				per.ApellidoPaterno 												   AS ApellidoPaterno,
				per.ApellidoMaterno													   AS ApellidoMaterno,
				per.Sexo                                                               AS Genero,
                per.FechaNacimiento,
                morales.FechaConstitucion,
				mun.Descripcion                                                        AS EntidadFederativaNacimiento,
                pa.Descripcion                                                         AS PaisNacimiento,
                ocupacion.Descripcion                                                  AS Ocupacion,
                profesion.Descripcion                                                  AS Profesion,
                act.Descripcion                                                        AS ActividadGiroNegocio,
                dom.Calle,
                dom.NumeroExterior,
                dom.NumeroInterior,
                dom.Asentamiento,
                dom.Municipio,
                dom.Ciudad,
                dom.Estado,
                dom.CodigoPostal,
                dom.Pais                                                               AS Pais,
                naci.Descripcion                                                       AS Nacionalidad,
                tipos.Descripcion                                                      AS EstadoCivil,
                esc.Descripcion                                                        AS Escolaridad,
                per.CURP,
                pers.RFC,
                Em.Emails,
                tel.Telefonos,
                per.IFE,
                pers.EsRepresentanteTercero,
                per.EsPersonaPoliticamenteEspuesta,
                soc.DescripcionNivelRiesgo                                             AS NievelRiesgo,
                lis.Descripcion                                                        AS TipoEmpleo,
                tipo.Descripcion                                                       AS SectorEconomico,
                ambito.Descripcion                                                     AS Ambito,
                giro.Descripcion                                                       AS TiempoActividad,
                labo.TiempoActividad                                                   AS GiroMercantil,
                labo.ActividadVulnerable                                               AS ActividadVulnerable
        FROM
                dbo.tSCSsocios          soc
            INNER JOIN
                dbo.tGRLpersonas        pers WITH (NOLOCK)
                    ON pers.IdPersona = soc.IdPersona
            LEFT JOIN
                dbo.tGRLpersonasFisicas per WITH (NOLOCK)
                    ON per.IdPersonaFisica = pers.IdPersonaFisica
            LEFT JOIN
                dbo.tGRLpersonasMorales morales WITH (NOLOCK)
                    ON morales.IdPersonaMoral = pers.IdPersonaMoral
            LEFT JOIN
                dbo.tCTLestados      mun WITH (NOLOCK)
                    ON mun.IdEstado = per.IdEstadoNacimiento
            LEFT JOIN
                dbo.tCATdomicilios      dom WITH (NOLOCK)
                    ON dom.IdDomicilio = pers.IdRelDomicilios
            LEFT JOIN
                dbo.tCATlistasD         profesion WITH (NOLOCK)
                    ON profesion.IdListaD = per.IdListaDProfesion
            LEFT JOIN
                dbo.tCATlistasD         ocupacion WITH (NOLOCK)
                    ON ocupacion.IdListaD = per.IdListaDOcupacion
            LEFT JOIN
                dbo.tCTLlaborales       labo WITH (NOLOCK)
                    ON labo.IdPersona = per.IdPersona
            LEFT JOIN
                dbo.tCATlistasD         act WITH (NOLOCK)
                    ON act.IdListaD = labo.IdListaDactividadEmpresa
            LEFT JOIN
                dbo.tCTLpaises          pa WITH (NOLOCK)
                    ON pa.IdPais = per.IdPaisNacimiento
            LEFT JOIN
                dbo.tCTLnacionalidades  naci WITH (NOLOCK)
                    ON naci.IdNacionalidad = per.IdNacionalidad
            LEFT JOIN
                dbo.tCTLtiposD          tipos WITH (NOLOCK)
                    ON tipos.IdTipoD = per.IdTipoDEstadoCivil
            LEFT JOIN
                dbo.tCATlistasD         esc WITH (NOLOCK)
                    ON esc.IdListaD = per.IdListaDEscolaridad
            LEFT JOIN
                vCATEmailsAgrupados     Em WITH (NOLOCK)
                    ON Em.IdRel = pers.IdRelEmails
            LEFT JOIN
                vCATtelefonosAgrupados  tel WITH (NOLOCK)
                    ON tel.IdRel = pers.IdRelTelefonos
            LEFT JOIN
                dbo.tCATlistasD         lis WITH (NOLOCK)
                    ON lis.IdListaD = labo.IdListaDempleo
            LEFT JOIN
                dbo.tCTLtiposD          tipo WITH (NOLOCK)
                    ON tipo.IdTipoD = labo.IdTipoDactividadEconomica
            LEFT JOIN
                dbo.tCATlistasD         ambito WITH (NOLOCK)
                    ON ambito.IdListaD = labo.IdListaDambito
            LEFT JOIN
                dbo.tCATlistasD         giro WITH (NOLOCK)
                    ON giro.IdListaD = labo.IdListaDgiro
            LEFT JOIN
                dbo.tCTLsucursales      sucu WITH (NOLOCK)
                    ON sucu.IdSucursal = soc.IdSucursal
        WHERE
                soc.EsSocioValido = 1;