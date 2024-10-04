

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDobservacionesAlertas')
BEGIN
	DROP PROC pCnPLDobservacionesAlertas
	SELECT 'pCnPLDobservacionesAlertas BORRADO' AS info
END
GO

CREATE PROC pCnPLDobservacionesAlertas
@pFechaInicial date='19000101',
@pFechaFinal	date='19000101'
AS
begin
	
		select  
		socio.Codigo as SocioCodigo
		,estatus.IdEstatus
		,estatus.Descripcion as EstatusAtencion
		,tipooperacion.Descripcion as TipoOperacionPLD
		,operacion.Folio AS OperacionFolio
		,o.Monto
		,tipo.Descripcion AS TipoSubOperacion
		,tope.Descripcion AS TipoOperacion
		,CASE operacion.IdOperacion    WHEN 0 THEN CAST(o.Alta AS DATE)   ELSE operacion.Fecha END AS FechaOperacion
		,sucursal.Descripcion AS Sucursal
		,perAlta.nombre AS UsuarioOperacion
		,iif(o.texto='',o.TipoIndicador,o.Texto) AS Nota
		,lor.Descripcion AS OrigenRecursos
		,sesion.Folio AS SesionCCCfolio
		,o.GeneradaDesdeSistema
		,o.TipoIndicador
		,per.Nombre AS PersonaNombre
		,per.RFC AS PersonaRFC
		,per.Domicilio AS PersonaDomicilio
		,per.EsExtranjero
		,per.EsSocio AS PersonaEsSocio
		,pf.FechaNacimiento
		,pf.Sexo
		,pf.CURP
		,pf.IFE AS NumeroIdentificacion
		,inu.Descripcion AS Inusualidad
		,mp.Descripcion AS MetodoPago
		,observacion.Observaciones
		,estatus.Codigo AS CodigoEstatusAtencion
		,pf.EsPersonaPoliticamenteEspuesta AS EsPEP
		FROM dbo.tPLDoperaciones o (NOLOCK)
		JOIN dbo.tCATmetodosPago mp With (nolock) ON mp.IdMetodoPago = o.IdMetodoPago
		JOIN dbo.tPLDinusualidades inu With (nolock) ON inu.IdInusualidad = o.IdInusualidad
		JOIN dbo.tCTLestatus estatus       WITH (NOLOCK)ON estatus.IdEstatus = o.IdEstatusAtencion 
			and estatus.IdEstatus = 68
		JOIN dbo.tSCSsocios socio		   WITH(NOLOCK)ON socio.IdSocio = o.IdSocio
		INNER JOIN tGRLpersonas per	       WITH (NOLOCK) ON per.IdPersona=IIF(o.IdPersona=0,socio.IdPersona,o.IdPersona)
		LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON pf.IdPersonaFisica=per.IdPersonaFisica
		JOIN dbo.tCTLtiposD tipooperacion  WITH(NOLOCK)ON tipooperacion.IdTipoD=o.IdTipoDoperacionPLD
		JOIN dbo.tGRLoperaciones operacion WITH(NOLOCK)ON operacion.IdOperacion=o.IdOperacionOrigen 
		JOIN dbo.tSDOtransaccionesD tranD  WITH(NOLOCK)ON trand.IdTransaccionD=o.IdTransaccionD
		JOIN dbo.tCTLtiposOperacion tipoOp WITH(NOLOCK)ON tipoop.IdTipoOperacion=trand.IdTipoSubOperacion
		JOIN dbo.tCTLtiposD tipo		   WITH (NOLOCK)ON tipo.IdTipoD=tipoop.IdTipoDdominio
		JOIN dbo.tCTLtiposOperacion tope   WITH(NOLOCK)ON tope.IdTipoOperacion=operacion.IdTipoOperacion
		JOIN dbo.tCTLsucursales sucursal   WITH(NOLOCK)ON sucursal.IdSucursal = IIF(operacion.IdSucursal=0,socio.IdSucursal, operacion.IdSucursal)
		JOIN dbo.tCTLusuarios usuAlta	   WITH(NOLOCK)ON usualta.IdUsuario=operacion.IdUsuarioAlta
		JOIN dbo.tGRLpersonas perAlta	   WITH(NOLOCK)ON perAlta.IdPersona=usuAlta.IdPersonaFisica 
		JOIN dbo.tCATlistasD lor		   WITH(NOLOCK)ON lor.IdListaD=o.IdListaDorigenRecursos
		JOIN dbo.tPLDsesionesCCC sesion    WITH(NOLOCK)ON sesion.IdSesionCCC=o.IdSesionCCC
		JOIN dbo.tCTLobservacionesE   obs WITH(NOLOCK)ON obs.IdObservacionE = o.IdObservacionEDominio
		LEFT JOIN dbo.vCTLobservacionesConcatenadas observacion With (nolock) ON observacion.IdObservacionE=o.IdObservacionEDominio
		WHERE CAST(o.Alta AS DATE) BETWEEN @pFechaInicial AND @pFechaFinal;

END
GO