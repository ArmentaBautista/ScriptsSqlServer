
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCcolocacionCPO')
BEGIN
	DROP PROC pCnAYCcolocacionCPO
	SELECT 'pCnAYCcolocacionCPO BORRADO' AS info
END
GO

CREATE PROC pCnAYCcolocacionCPO
@Sucursal VARCHAR(100),
@Estatus VARCHAR(100) ,
@FechaInicial DATE,
@FechaFinal DATE
AS	
SELECT	[Código Sucursal]=suc.Codigo,
			Sucursal=suc.Descripcion,
			Cuenta=c.Codigo,
			Producto=pr.Descripcion,
			[Código Sucursal Socio]=sucsocio.Codigo,
			sucsocio.Descripcion AS [Sucursal Socio],
			Socio=soc.Codigo,
			Nombre=psn.Nombre,
			SubTipo=td.Descripcion,
			[Fecha Otorgamiento]=c.FechaEntrega,
			[Monto Otorgado]=c.MontoEntregado,
			[Plazo]=c.NumeroParcialidades,
			[Días por Plazo]=IIF(NumeroParcialidades=1, DATEDIFF(d,c.FechaEntrega, c.Vencimiento), c.Dias),
			Vencimiento=c.Vencimiento,
			[Tasa Anual]=c.InteresOrdinarioAnual*100,
			Finalidad=IIF(c.IdFinalidad!=0, fn.Descripcion, c.DescripcionLarga),
			[Finalidad Descripción] = c.DescripcionLarga,
			Ejecutivo=ejp.Nombre,
			Promotor=prop.Nombre,
			Autorizador=up.Nombre,
			[Usuario Activó]=uap.Nombre,
			[Estatus Actual]=st.Descripcion,
			[Estatus Período]=esthis.Descripcion,
			Conteo=1,
			h.IdPeriodo,
			perins.Nombre AS [Usuario Instrumentó],
			sucop.Descripcion AS [Sucursal Desembolso]
	FROM tAYCcuentas c With (nolock) 
	JOIN tCTLtiposD td With (nolock)on c.IdTipoDAIC=td.IdTipoD
	JOIN tCTLestatus st With (nolock)on c.IdEstatus=st.IdEstatus
	JOIN tAYCfinalidades fn With (nolock)on c.IdFinalidad=fn.IdFinalidad
	JOIN tSCSsocios soc With (nolock)on c.IdSocio=soc.IdSocio
	JOIN dbo.tCTLsucursales sucsocio With (nolock)ON  sucsocio.IdSucursal = soc.IdSucursal
	JOIN tAYCcuentasEstadisticas ce With (nolock)on c.IdCuenta=ce.IdCuenta
	JOIN tGRLpersonas psn With (nolock)on soc.IdPersona=psn.IdPersona
	JOIN tCTLusuarios ej With (nolock)on c.IdUsuarioAlta=ej.IdUsuario
	JOIN tGRLpersonas ejp With (nolock)on ej.IdPersonaFisica=ejp.IdPersona
	JOIN tCOMvendedores pro With (nolock)on c.IdVendedor=pro.IdVendedor
	JOIN tGRLpersonas prop With (nolock)on pro.IdPersona=prop.IdPersona
	JOIN tCTLusuarios u With (nolock)on c.IdUsuarioAutorizo=u.IdUsuario
	JOIN tGRLpersonas up With (nolock)on u.IdPersonaFisica=up.IdPersona
	JOIN tCTLusuarios ua With (nolock)on ce.IdUsuarioActivo=ua.IdUsuario
	JOIN tGRLpersonas uap With (nolock)on ua.IdPersonaFisica=uap.IdPersona
	JOIN tCTLsucursales suc With (nolock)on c.IdSucursal=suc.IdSucursal
	JOIN tAYCproductosFinancieros pr With (nolock)ON c.IdProductoFinanciero=pr.IdProductoFinanciero
	JOIN dbo.tCTLperiodos per With (nolock)on c.FechaActivacion BETWEEN per.Inicio AND per.Fin and per.EsAjuste = 0 
	JOIN dbo.tCTLusuarios usuinstrumento With (nolock) ON usuinstrumento.IdUsuario=c.IdUsuarioInstrumento
	JOIN dbo.tGRLpersonas perins With (nolock) ON perins.IdPersona=usuinstrumento.IdPersonaFisica
	LEFT JOIN dbo.tSDOhistorialDeudoras h With (nolock)ON h.IdCuenta = c.IdCuenta AND per.IdPeriodo = h.IdPeriodo 
	LEFT JOIN dbo.tCTLestatus esthis With (nolock)ON esthis.IdEstatus = h.IdEstatus
	LEFT JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta=c.IdCuenta
																AND tf.IdTipoSubOperacion=501
	LEFT JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion=tf.IdOperacion
	LEFT JOIN dbo.tCTLsucursales sucop  WITH(NOLOCK) ON sucop.IdSucursal=op.IdSucursal
	WHERE c.IdEstatus IN (1,7,53,26) AND c.IdEstatusEntrega != 26 AND IdTipoDproducto =143
	and  (@Sucursal='*'OR suc.Codigo = @Sucursal)
	AND (c.FechaEntrega BETWEEN @FechaInicial AND @FechaFinal)
	AND (@Estatus = '*'OR @Estatus = st.Descripcion)


GO

