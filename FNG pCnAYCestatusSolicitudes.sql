

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCestatusSolicitudes')
BEGIN
	DROP PROC pCnAYCestatusSolicitudes
	SELECT 'pCnAYCestatusSolicitudes BORRADO' AS info
END
GO

CREATE PROC pCnAYCestatusSolicitudes
@pFechaInicial AS DATE='19000101',
@pFechaFinal AS DATE='19000101',
@pEstatus AS VARCHAR(24)='*'
AS
BEGIN

	IF @pFechaInicial='19000101' OR @pFechaFinal='19000101'
		BEGIN
			SELECT 'El valor de las fechas no puede ser 19000101' AS INFO
			RETURN -1
		END

		IF @pFechaInicial > @pFechaFinal
		BEGIN
			SELECT 'La fecha inicial no puede ser mayor a la fecha final' AS INFO
			RETURN -1
		END

		IF @pEstatus IS null OR @pEstatus=''
		BEGIN
			SELECT 'Debe especificar un estatus o * para TODOS' AS INFO
			RETURN -1
		END

	DECLARE @fechaInicial AS DATE=@pFechaInicial
	DECLARE @fechaFinal AS DATE=@pFechaFinal
	DECLARE @Estatus AS VARCHAR(24)=@pEstatus

	SELECT 
	  a.Fecha
	, Sucursal			= suc.Descripcion
	, a.Folio
	, NoCuenta			= c.Codigo
	, Producto			= pf.Descripcion
	, NoSocio			= sc.Codigo
	, p.Nombre
	, EstatusApertura	= eapertura.Descripcion
	, EstatusSolcitud	= eSolicitud.Descripcion
	, c.FechaAutorizacion
	, EstatusCuenta		= ecuenta.Descripcion
	, c.FechaInstrumentacion
	, EstatusEntrega	= eEntrega.Descripcion
	, ce.FechaEntregada
	FROM dbo.tAYCaperturas a  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = a.IdSucursal
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdApertura = a.IdApertura
	AND c.IdApertura<>0
	AND C.IdTipoDProducto=143 
	INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tAUTsolicitudes s  WITH(NOLOCK) ON s.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tCTLestatus eapertura  WITH(NOLOCK) ON eapertura.IdEstatus = a.IdEstatus
	INNER JOIN dbo.tCTLestatus ecuenta	 WITH(NOLOCK) ON ecuenta.IdEstatus = c.IdEstatus
	AND (@Estatus='*' OR ecuenta.Codigo=@Estatus)
	INNER JOIN dbo.tCTLestatus eEntrega  WITH(NOLOCK) ON eEntrega.IdEstatus = c.IdEstatusEntrega
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = s.IdEstatusActual
	INNER JOIN dbo.tCTLestatus eSolicitud  WITH(NOLOCK) ON eSolicitud.IdEstatus = ea.IdEstatus 
	AND esolicitud.IdEstatus<>2
	WHERE a.Fecha BETWEEN @fechaInicial AND @fechaFinal
	ORDER BY a.Fecha, suc.Descripcion

END