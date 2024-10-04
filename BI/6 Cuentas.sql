

DECLARE @idEmpresa as INT = 2   -- FNG
DECLARE @fechaBI AS DATE=GETDATE()
DECLARE @alta AS DATETIME=GETDATE()

SELECT  @Idempresa as IdEmpresa, cuenta.idcuenta,cuenta.Codigo,Producto = Cuenta.Descripcion,TipoDAIC.Descripcion AS [Tipo Producto],Plazo.Descripcion AS [Plazo],Amort.Descripcion AS [Amortización],
		NivelRiesgo.Descripcion [Nivel de riesgo],Socio.Codigo as [Número Socio], Persona.Nombre as Socio,Sucursal.Codigo as [Código Sucursal],Sucursal.Descripcion as Sucursal,
		EstatusCartera.Descripcion as [Estatus Cartera],Estatus.Descripcion as Estatus, TipoCartera as [Tipo Cartera], Fondeo.Descripcion as Fondeo, Finalidad.Descripcion as Finalidad,
		Clasificacion.Descripcion as Clasificación
		,@fechaBI AS FechaBI, @alta AS Alta
FROM 
			dbo.tAYCcuentas						Cuenta			WITH (NOLOCK) 
	JOIN	dbo.tCTLtiposD						TipoDAIC		WITH (NOLOCK) ON TipoDAIC.IdTipoD = Cuenta.IdTipoDAIC 
	JOIN	dbo.tCTLtiposD						Plazo			WITH (NOLOCK) ON Plazo.IdTipoD = Cuenta.IdTipoDplazo
	JOIN	dbo.tCTLtiposD						Amort			WITH (NOLOCK) ON Amort.IdTipoD = Cuenta.IdTipoDParcialidad
	JOIN	dbo.tCTLtiposD						NivelRiesgo		WITH (NOLOCK) ON NivelRiesgo.IdTipoD = Cuenta.IdTipoDnivelRiesgo
	JOIN	dbo.tSCSsocios							Socio			WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
	JOIN	dbo.tGRLpersonas						Persona			WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
	JOIN	dbo.tCTLsucursales						Sucursal		WITH (NOLOCK) ON Sucursal.IdSucursal = Cuenta.IdSucursal
	JOIN	dbo.tCTLestatus							EstatusCartera	WITH (NOLOCK) ON EstatusCartera.IdEstatus = Cuenta.IdEstatusCartera
	JOIN	dbo.tCTLestatus							Estatus			WITH (NOLOCK) ON Estatus.IdEstatus = Cuenta.IdEstatus
	JOIN	dbo.tAYCprogramasFondeoFinanciamiento	Fondeo			WITH (NOLOCK) ON Fondeo.IdProgramaFondeo = Cuenta.IdProgramaFondeo
	JOIN	dbo.tAYCfinalidades						Finalidad		WITH (NOLOCK) ON Finalidad.IdFinalidad = Cuenta.IdFinalidad
	JOIN	dbo.tCTLtiposD							Clasificacion	WITH (NOLOCK) ON Clasificacion.IdTipoD = Cuenta.IdTipoDAICclasificacion
	JOIN	tCNTdivisiones						Division		WITH (NOLOCK) ON Division.IdDivision = Cuenta.IdDivision
WHERE Cuenta.idtipoDproducto = 143 AND Cuenta.IdEstatus=1

UNION ALL

SELECT  @Idempresa as IdEmpresa, Cuenta.idcuenta,cuenta.Codigo,Producto = Cuenta.Descripcion,TipoDAIC.Descripcion AS [Tipo Producto],Plazo.Descripcion AS [Plazo],NULL AS [Amortización],
		NULL [Nivel de riesgo],Socio.Codigo as [Número Socio], Persona.Nombre as Socio,Sucursal.Codigo as [Código Sucursal],Sucursal.Descripcion as Sucursal,
		NULL as [Estatus Cartera],Estatus.Descripcion as Estatus, NULL as [Tipo Cartera], NULL as Fondeo, NULL as Finalidad,
		Clasificacion.Descripcion as Clasificación
		,@fechaBI AS FechaBI, @alta AS Alta
FROM 
			dbo.tAYCcuentas						Cuenta			WITH (NOLOCK) 
	JOIN	dbo.tCTLtiposD						TipoDAIC		WITH (NOLOCK) ON TipoDAIC.IdTipoD = Cuenta.IdTipoDAIC 
	JOIN	dbo.tCTLtiposD						Plazo			WITH (NOLOCK) ON Plazo.IdTipoD = Cuenta.IdTipoDplazo
	JOIN	dbo.tCTLtiposD						Amort			WITH (NOLOCK) ON Amort.IdTipoD = Cuenta.IdTipoDParcialidad
	JOIN	dbo.tCTLtiposD						NivelRiesgo		WITH (NOLOCK) ON NivelRiesgo.IdTipoD = Cuenta.IdTipoDnivelRiesgo
	JOIN	dbo.tSCSsocios							Socio			WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
	JOIN	dbo.tGRLpersonas						Persona			WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
	JOIN	dbo.tCTLsucursales						Sucursal		WITH (NOLOCK) ON Sucursal.IdSucursal = Cuenta.IdSucursal
	JOIN	dbo.tCTLestatus							EstatusCartera	WITH (NOLOCK) ON EstatusCartera.IdEstatus = Cuenta.IdEstatusCartera
	JOIN	dbo.tCTLestatus							Estatus			WITH (NOLOCK) ON Estatus.IdEstatus = Cuenta.IdEstatus
	JOIN	dbo.tAYCprogramasFondeoFinanciamiento	Fondeo			WITH (NOLOCK) ON Fondeo.IdProgramaFondeo = Cuenta.IdProgramaFondeo
	JOIN	dbo.tAYCfinalidades						Finalidad		WITH (NOLOCK) ON Finalidad.IdFinalidad = Cuenta.IdFinalidad
	JOIN	dbo.tCTLtiposD							Clasificacion	WITH (NOLOCK) ON Clasificacion.IdTipoD = Cuenta.IdTipoDAICclasificacion
	JOIN	tCNTdivisiones						Division		WITH (NOLOCK) ON Division.IdDivision = Cuenta.IdDivision
WHERE cuenta.idtipoDproducto <> 143 AND Cuenta.IdEstatus=1


