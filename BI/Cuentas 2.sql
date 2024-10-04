-- ===================================
-- Agregar las cuentas de AYC as BSI
-- ===================================

declare @idEmpresa as INT = 7   -- Dr Arroyo

-- Primero se borran las cuentas en BSI
--delete from tBSIcuentas where IdEmpresa = @IdEempresa

-- Se leen las cuentas de la base de producción

SELECT @Idempresa as IdEmpresa, idcuenta,cuenta.Codigo,Producto = Cuenta.Descripcion,TipoDAIC.Descripcion AS [Tipo Producto],Plazo.Descripcion AS [Plazo],Amort.Descripcion AS [Amortización],
		NivelRiesgo.Descripcion [Nivel de riesgo],Socio.Codigo as [Número Socio], Persona.Nombre as Socio,Sucursal.Codigo as [Código Sucursal],Sucursal.Descripcion as Sucursal,
		EstatusCartera.Descripcion as [Estatus Cartera],Estatus.Descripcion as Estatus, TipoCartera as [Tipo Cartera], Fondeo.Descripcion as Fondeo, Finalidad.Descripcion as Finalidad,
		Clasificacion.Descripcion as Clasificación, Division.Descripcion AS Division
FROM 
			dbo.tAYCcuentas						Cuenta			WITH (NOLOCK) 
	JOIN	dbo.tCTLtiposD						TipoDAIC		WITH (NOLOCK) ON TipoDAIC.IdTipoD = Cuenta.IdTipoDAIC 
	JOIN	dbo.tCTLtiposD						Plazo			WITH (NOLOCK) ON Plazo.IdTipoD = Cuenta.IdTipoDplazo
	JOIN	dbo.tCTLtiposD						Amort			WITH (NOLOCK) ON Amort.IdTipoD = Cuenta.IdTipoDParcialidad
	JOIN	dbo.tCTLtiposD						NivelRiesgo		WITH (NOLOCK) ON NivelRiesgo.IdTipoD = Cuenta.IdTipoDnivelRiesgo
	JOIN	tSCSsocios							Socio			WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
	JOIN	tGRLpersonas						Persona			WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
	JOIN	tCTLsucursales						Sucursal		WITH (NOLOCK) ON Sucursal.IdSucursal = Cuenta.IdSucursal
	JOIN	tCTLestatus							EstatusCartera	WITH (NOLOCK) ON EstatusCartera.IdEstatus = Cuenta.IdEstatusCartera
	JOIN	tCTLestatus							Estatus			WITH (NOLOCK) ON Estatus.IdEstatus = Cuenta.IdEstatus
	JOIN	tAYCprogramasFondeoFinanciamiento	Fondeo			WITH (NOLOCK) ON Fondeo.IdProgramaFondeo = Cuenta.IdProgramaFondeo
	JOIN	tAYCfinalidades						Finalidad		WITH (NOLOCK) ON Finalidad.IdFinalidad = Cuenta.IdFinalidad
	JOIN	tCTLtiposD							Clasificacion	WITH (NOLOCK) ON Clasificacion.IdTipoD = Cuenta.IdTipoDAICclasificacion
	JOIN	tCNTdivisiones						Division		WITH (NOLOCK) ON Division.IdDivision = Cuenta.IdDivision
where idtipoDproducto = 143

UNION ALL

SELECT  @Idempresa as IdEmpresa, idcuenta,cuenta.Codigo,Producto = Cuenta.Descripcion,TipoDAIC.Descripcion AS [Tipo Producto],Plazo.Descripcion AS [Plazo],NULL AS [Amortización],
		NULL [Nivel de riesgo],Socio.Codigo as [Número Socio], Persona.Nombre as Socio,Sucursal.Codigo as [Código Sucursal],Sucursal.Descripcion as Sucursal,
		NULL as [Estatus Cartera],Estatus.Descripcion as Estatus, NULL as [Tipo Cartera], NULL as Fondeo, NULL as Finalidad,
		Clasificacion.Descripcion as Clasificación, Division.Descripcion AS Division
FROM 
			dbo.tAYCcuentas						Cuenta			WITH (NOLOCK) 
	JOIN	dbo.tCTLtiposD						TipoDAIC		WITH (NOLOCK) ON TipoDAIC.IdTipoD = Cuenta.IdTipoDAIC 
	JOIN	dbo.tCTLtiposD						Plazo			WITH (NOLOCK) ON Plazo.IdTipoD = Cuenta.IdTipoDplazo
	JOIN	dbo.tCTLtiposD						Amort			WITH (NOLOCK) ON Amort.IdTipoD = Cuenta.IdTipoDParcialidad
	JOIN	dbo.tCTLtiposD						NivelRiesgo		WITH (NOLOCK) ON NivelRiesgo.IdTipoD = Cuenta.IdTipoDnivelRiesgo
	JOIN	tSCSsocios							Socio			WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
	JOIN	tGRLpersonas						Persona			WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
	JOIN	tCTLsucursales						Sucursal		WITH (NOLOCK) ON Sucursal.IdSucursal = Cuenta.IdSucursal
	JOIN	tCTLestatus							EstatusCartera	WITH (NOLOCK) ON EstatusCartera.IdEstatus = Cuenta.IdEstatusCartera
	JOIN	tCTLestatus							Estatus			WITH (NOLOCK) ON Estatus.IdEstatus = Cuenta.IdEstatus
	JOIN	tAYCprogramasFondeoFinanciamiento	Fondeo			WITH (NOLOCK) ON Fondeo.IdProgramaFondeo = Cuenta.IdProgramaFondeo
	JOIN	tAYCfinalidades						Finalidad		WITH (NOLOCK) ON Finalidad.IdFinalidad = Cuenta.IdFinalidad
	JOIN	tCTLtiposD							Clasificacion	WITH (NOLOCK) ON Clasificacion.IdTipoD = Cuenta.IdTipoDAICclasificacion
	JOIN	tCNTdivisiones						Division		WITH (NOLOCK) ON Division.IdDivision = Cuenta.IdDivision
where idtipoDproducto != 143


