

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCcolocacionExtendida')
BEGIN
	DROP PROC pCnAYCcolocacionExtendida
END
GO

CREATE PROC pCnAYCcolocacionExtendida
@FechaInicial DATE='',
@FechaFinal DATE=''
AS	
	SELECT	c.IdCuenta,
			Cuenta=c.Codigo,
			[ProductoCodigo] = pr.Codigo,
			Producto=pr.Descripcion,
			Socio=soc.Codigo,
			Nombre=psn.Nombre,
			[Código Sucursal]=suc.Codigo,
			Sucursal=suc.Descripcion,
			SubTipo=td.Descripcion,
			[Fecha Otorgamiento]=c.FechaEntrega,
			[Monto Otorgado]=c.MontoEntregado,
			[Plazo]=c.NumeroParcialidades,
			[Días por Plazo]=IIF(c.NumeroParcialidades=1, DATEDIFF(d,c.FechaEntrega, c.Vencimiento), c.Dias),
			Vencimiento=c.Vencimiento,
			[Tasa Anual]=c.InteresOrdinarioAnual*100,
			Finalidad=IIF(c.IdFinalidad!=0, fn.Descripcion, c.DescripcionLarga),
			[Finalidad Descripción] = c.DescripcionLarga,
			Ejecutivo=ejp.Nombre,
			Promotor=prop.Nombre,
			Autorizador=up.Nombre,
			[Usuario Activó]=uap.Nombre,
			[Estatus Actual]=st.Descripcion,
			-- Renovaciones Reestructuras
			Conteo=1,
			rr.IdCuentaOrigen,
			[CodigoProductoRR]			= pfrr.Codigo,
			[ProductoRR]				= pfrr.Descripcion,
			[NoCuentaRR]					= crr.Codigo

	-- INTO tTMPoportunos
	FROM tAYCcuentas c  WITH(NOLOCK)
	JOIN tCTLtiposD td   WITH(NOLOCK) ON c.IdTipoDAIC=td.IdTipoD
	JOIN tCTLestatus st   WITH(NOLOCK)on c.IdEstatus=st.IdEstatus
	JOIN tAYCfinalidades fn   WITH(NOLOCK) ON c.IdFinalidad=fn.IdFinalidad
	JOIN tSCSsocios soc   WITH(NOLOCK) ON c.IdSocio=soc.IdSocio
	JOIN tAYCcuentasEstadisticas ce   WITH(NOLOCK) ON c.IdCuenta=ce.IdCuenta
	JOIN tGRLpersonas psn   WITH(NOLOCK) ON soc.IdPersona=psn.IdPersona
	JOIN tCTLusuarios ej   WITH(NOLOCK) ON c.IdUsuarioAlta=ej.IdUsuario
	JOIN tGRLpersonas ejp   WITH(NOLOCK) ON ej.IdPersonaFisica=ejp.IdPersona
	JOIN tCOMvendedores pro   WITH(NOLOCK) ON c.IdVendedor=pro.IdVendedor
	JOIN tGRLpersonas prop   WITH(NOLOCK) ON pro.IdPersona=prop.IdPersona
	JOIN tCTLusuarios u   WITH(NOLOCK) ON c.IdUsuarioAutorizo=u.IdUsuario
	JOIN tGRLpersonas up   WITH(NOLOCK) ON u.IdPersonaFisica=up.IdPersona
	JOIN tCTLusuarios ua   WITH(NOLOCK) ON ce.IdUsuarioActivo=ua.IdUsuario
	JOIN tGRLpersonas uap   WITH(NOLOCK) ON ua.IdPersonaFisica=uap.IdPersona
	JOIN tCTLsucursales suc   WITH(NOLOCK) ON c.IdSucursal=suc.IdSucursal
	JOIN tAYCproductosFinancieros pr   WITH(NOLOCK) ON c.IdProductoFinanciero=pr.IdProductoFinanciero
	-- renovaciones
	LEFT JOIN dbo.tAYCrestructurasRenovaciones rr  WITH(NOLOCK) ON rr.IdCuentaDestino = c.IdCuenta
	LEFT JOIN dbo.tAYCcuentas crr  WITH(NOLOCK) ON crr.IdCuenta = rr.IdCuentaOrigen
	LEFT JOIN dbo.tAYCproductosFinancieros pfrr  WITH(NOLOCK) ON pfrr.IdProductoFinanciero = crr.IdProductoFinanciero
	-- filtros
	WHERE c.IdEstatus IN (1,7,53,26) AND c.IdEstatusEntrega != 26 AND c.IdTipoDproducto =143 
	AND c.FechaAlta BETWEEN @FechaInicial AND @FechaFinal
	--AND pr.Codigo='017'







GO

