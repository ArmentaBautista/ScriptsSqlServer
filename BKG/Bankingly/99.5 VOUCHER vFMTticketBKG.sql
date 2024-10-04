

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketBKG')
BEGIN
	DROP VIEW vFMTticketBKG
	SELECT 'vFMTticketBKG BORRADO' AS info
END
GO

CREATE VIEW dbo.vFMTticketBKG
	as
SELECT	

		IdOperacion			= Operacion.IdOperacion, 
		IdSucursal			= Operacion.IdSucursal, 
		[Razon Social]		= PersonaEmpresa.Nombre,
		[Nombre Comercial]	= Empresa.NombreComercial , 
		[Codigo Sucursal]	= Sucursal.codigo,
		Sucursal			= sucursal.Descripcion , 
		Caja				= Ventanilla.Descripcion, 
		Codigo              = Ventanilla.Codigo,
		Operacion.Serie, 
		Operacion.Folio, 
        SerieFolio			= Operacion.Serie + CAST(Operacion.Folio AS VARCHAR) , 
		Operacion.Fecha,		
		Operacion.Concepto, 
		Operacion.Referencia,
		Operacion			= CASE WHEN Total < 0 THEN 
										'Retiro' 
										WHEN total = 0 THEN 
										'----' 
										ELSE 
										'Depósito' 
								END , 
		Total = ABS(Operacion.Total) , 
		Usuario = PersonaFisica.Nombre + ' ' + PersonaFisica.ApellidoPaterno + ' ' + PersonaFisica.ApellidoMaterno,
		Operacion.IdEstatus, 
		Operacion.IdUsuarioAlta,
		Operacion.IdCuentaABCD, 
		Operacion.IdTipoOperacion, 
		(sucursal.DomicilioCalle + ', No. ' +sucursal.DomicilioNumeroExterior + iif(sucursal.DomicilioNumeroInterior<>'', 'Int. ' + sucursal.DomicilioNumeroInterior, '') + 
		' C.P. ' + sucursal.DomicilioCodigoPostal + iif(sucursal.DomicilioCiudad<>'', ', ' + sucursal.DomicilioCiudad, '') + ', ' + sucursal.DomicilioEstado) AS SucursalDireccion,
		Operacion.Alta,
		Usuario.Usuario AS CodigoUsuario,
		Operacion.IdSocio AS OperacionIdSocio
FROM            dbo.tGRLoperaciones AS Operacion WITH (NOLOCK)  INNER JOIN
                dbo.tCTLtiposOperacion AS tco WITH (NOLOCK)  ON tco.IdTipoOperacion = Operacion.IdTipoOperacion LEFT JOIN
		        dbo.vCTLsucursalesGUI AS sucursal WITH (NOLOCK) ON sucursal.IdSucursal = Operacion.IdSucursal INNER JOIN
                dbo.tCTLempresas AS empresa WITH (NOLOCK) ON empresa.IdEmpresa = sucursal.IdEmpresa INNER JOIN
				tGRLpersonas as PersonaEmpresa WITH (NOLOCK) ON Empresa.IdPersona = PersonaEmpresa.IdPersona INNER JOIN
                dbo.tGRLcuentasABCD AS Ventanilla WITH (NOLOCK)  ON Ventanilla.IdCuentaABCD = Operacion.IdCuentaABCD INNER JOIN
				tCTLusuarios as Usuario WITH (NOLOCK)  ON Operacion.IdUsuarioAlta = Usuario.IdUsuario INNER JOIN
				tGRLpersonasFisicas as PersonaFisica WITH (NOLOCK)  ON Usuario.IdPersonaFisica = PersonaFisica.IdPersonaFisica

WHERE        --(Operacion.IdTipoOperacion IN(1,71)) AND 
(Operacion.IdOperacion <> 0)



GO


