

USE iERP_CAZ
go


		SELECT	suc.Codigo AS SucursalCodigo, suc.Descripcion AS Sucursal
				, IIF(pf.IdPersonaFisica IS NULL,'Persona Moral','Persona Física')
				, s.Codigo as [Número de Socio]
				,s.FechaAlta, [FechaBaja]=CASE WHEN cast(s.FechaBaja as date)='19000101 00:00:00.000' THEN NULL ELSE s.FechaBaja END
				,p.Nombre AS NombreCompleto, pf.Nombre, pf.ApellidoPaterno, pf.ApellidoMaterno
				, Género = pf.sexo
				,pf.FechaNacimiento
				,pm.FechaConstitucion
				,pf.CURP, p.RFC
				, edonac.Descripcion AS EntidadNacimiento
				, paisnac.Descripcion AS PaisNacimiento
				, nacg.Nacionalidad
				, ldocupacion.Descripcion AS [Ocupación]
				, ldprofesion.Descripcion AS [Profesión]
				, ldactividadEmp.Descripcion AS [GiroActividad]
				, d.calle, d.NumeroExterior, d.NumeroInterior, d.Asentamiento, d.Ciudad, d.Municipio, d.Estado, d.CodigoPostal,d.Pais 
				,[Teléfonos] = Telefono.Telefonos
				, email.Emails
				, pf.CURP
				, p.RFC
				, p.NumeroSerieFEA
				, ldNivelRiesgo.Descripcion AS NivelRiesgo
				, ingresoegreso.IngresoOrdinario
				, tedocivil.Descripcion AS EstadoCivil
				, tipoVivienda.Descripcion AS TipoVivienda
				, tipoDomicilio.Descripcion AS TipoDomicilio
				, analcred.TiempoResidenciaActual
				, pf.EsPersonaPoliticamenteEspuesta
				, IIF(terceros.IdPersonaSocio IS null,'NO','SI') AS RepresentaTercero
				, alertaspld.NoAlertas
				, IIF(ldactividadEmp.Valor=1,'SI','NO') AS ActividadVulnerable
				, IIF(empleado.IdEmpleado IS null,'NO','SI') AS EsEmpleado
				,s.EsSocioValido AS SocioConParteSocial
				, 1 AS Conteo
		FROM tSCSsocios s											WITH(NOLOCK)
			INNER JOIN tGRLpersonas							p			WITH(NOLOCK) on p.IdPersona=s.IdPersona
			LEFT JOIN tGRLpersonasFisicas					pf			WITH(NOLOCK) on pf.IdPersonaFisica=s.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales				pm			 WITH(NOLOCK)ON pm.IdPersona = p.IdPersona
			LEFT JOIN tCTLsucursales						suc				WITH(NOLOCK) on suc.IdSucursal=s.IdSucursal
			LEFT JOIN dbo.tCTLestados edonac  WITH(nolock) ON edonac.IdEstado = pf.IdEstadoNacimiento
			LEFT JOIN dbo.tCTLpaises paisnac  WITH(nolock) ON paisnac.IdPais = pf.IdPaisNacimiento
			LEFT JOIN dbo.vCATnacionalidadesAgrupadas nacg  WITH(nolock) ON nacg.IdPersonaFisica = pf.IdPersonaFisica
			LEFT JOIN dbo.tCTLlaborales laborales  WITH(nolock) ON laborales.IdPersona = p.IdPersona
			LEFT JOIN dbo.tCATlistasD ldactividadEmp  WITH(nolock) ON ldactividadEmp.IdListaD = laborales.IdListaDactividadEmpresa 
			LEFT JOIN tCATdomicilios						d		WITH(NOLOCK) ON d.IdRel=p.IdRelDomicilios AND d.IdTipoD=11
			LEFT JOIN dbo.tCTLestatusActual ead						WITH(NOLOCK) ON ead.IdEstatusActual = d.IdEstatusActual AND ead.IdEstatus = 1
			LEFT JOIN tCATlistasD						ldocupacion		WITH(NOLOCK) ON ldocupacion.IdListaD=pf.IdListaDOcupacion
			LEFT JOIN tCATlistasD						ldprofesion		WITH(NOLOCK) ON ldprofesion.IdListaD=pf.IdListaDProfesion
			LEFT JOIN dbo.vCATtelefonosAgrupados Telefono  WITH(nolock)  ON Telefono.IdRel = p.IdRelTelefonos
			LEFT JOIN dbo.vCATEmailsAgrupados email  WITH(nolock) ON email.IdRel = p.IdRelEmails
			LEFT JOIN dbo.tCATlistasD ldNivelRiesgo  WITH(nolock) ON ldNivelRiesgo.IdListaD = s.IdListaDnivelRiesgo
			LEFT JOIN tSCSanalisisCrediticio analcred  WITH(nolock) ON analcred.IdPersona = p.IdPersona
			LEFT JOIN tSCSanalisisIngresosEgresos ingresoegreso  WITH(nolock) ON ingresoegreso.IdAnalisisCrediticio = analcred.IdAnalisisCrediticio
			LEFT JOIN dbo.tCTLtiposD tedocivil  WITH(nolock) ON tedocivil.IdTipoD = pf.IdTipoDEstadoCivil
			LEFT JOIN dbo.tCTLtiposD tipoVivienda  WITH(nolock) ON tipoVivienda.IdTipoD = analcred.IdTipoDresidencia
			LEFT JOIN dbo.tCTLtiposD tipoDomicilio  WITH(nolock) ON tipoDomicilio.IdTipoD = d.IdTipoD
			LEFT JOIN (
						SELECT terceros.IdPersonaSocio
						FROM dbo.tPLDsocioTerceros terceros  WITH(nolock) 
						GROUP BY terceros.IdPersonaSocio
					) terceros ON terceros.IdPersonaSocio = p.IdPersona
			LEFT JOIN (
						SELECT sc.IdSocio, COUNT(sc.IdSocio) AS NoAlertas
						FROM dbo.tPLDoperaciones oppld  WITH(nolock)
						INNER JOIN dbo.tSCSsocios sc  WITH(nolock) ON sc.IdSocio = oppld.IdSocio
						WHERE oppld.IdTipoDoperacionPLD IN (1594,1592,1596)
						GROUP BY sc.IdSocio
					) alertaspld ON alertaspld.IdSocio = s.IdSocio
			LEFT JOIN dbo.tPERempleados empleado  WITH(nolock) ON empleado.IdPersonaFisica=pf.IdPersonaFisica
			LEFT JOIN dbo.tCTLestatusActual eaEmpleado  WITH(nolock) ON eaEmpleado.IdEstatusActual=empleado.IdEstatusActual 
																	AND eaEmpleado.IdEstatus = 1
		WHERE p.IdPersona <> 0 AND s.EsSocioValido=1
		

