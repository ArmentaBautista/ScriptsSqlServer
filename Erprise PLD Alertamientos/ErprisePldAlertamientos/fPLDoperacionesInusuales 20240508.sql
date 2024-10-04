
USE iERP_CYL_REG
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER FUNCTION dbo.fPLDoperacionesInusuales(@IdPeriodo AS INT) RETURNS TABLE
AS
RETURN
(
	SELECT	 -- 01
			 TipoReporte = '2', 
			 Periodo =dbo.fSITformatoSinPuntoGuiones(CAST(CURRENT_TIMESTAMP AS DATE)),
			 a.Folio,
			 a.OrganoSuperior, 
			 SujetoObligado = emp.ClaveEntidad,
			 a.Localidad, 
			 a.Sucursal, 
			 a.TipoOperacion, 
			 a.InstrumentoMonetario, 
			 a.NumeroCuenta, 
			 a.Monto, 
			 a.Moneda, 
			 a.FechaOperacion,
			 
			 -- 14 Las columnas marcadas con asterisco (*) (14, 34 a la 41) no aplican para operaciones Relevantes.
			 FechaDeteccionOperacion= ISNULL(a.FechaDeteccionOperacion, ''),

			 a.Nacionalidad, 
			 a.TipoPersona, 
			 a.RazonSocial,
			 a.Nombre, 
			 a.Paterno, 
			 a.Materno, 
			 a.RFC, 
			 a.CURP, 
			 a.FechaNacimiento,
			 a.Domicilio, 
			 a.Colonia, 
			 a.Ciudad, 
			 a.Telefono, 
			 a.ActividadEconomica, 
			
			 -- 29 Las columnas marcadas con ** (29 a la 33) aplican únicamente para Instituciones y Sociedades Mutualistas de Seguros, y para Instituciones de Fianzas.
			 NombreAgente = ISNULL( a.NombreAgente, ''),
			 PaternoAgente = ISNULL( a.PaternoAgente, ''),
			 MaternoAgente = ISNULL( a.MaternoAgente, ''),
			 RFCAgente = ISNULL( a.RFCAgente, ''),
			 CURPAgente = ISNULL( a.CURPAgente, ''),
			 
			 -- 34 Las columnas marcadas con asterisco (*) (14, 34 a la 41) no aplican para operaciones Relevantes.
			 ConsecutivoCuentaPersonaRelacionada = ISNULL(a.ConsecutivoCuentaPersonaRelacionada, ''),
			 NumeroCuentaPersonaRelacionada = ISNULL(a.NumeroCuentaPersonaRelacionada, ''),
			 SujetoObligadoPersonaRelacionada = ISNULL(a.SujetoObligadoPersonaRelacionada, ''),
			 NombrePersonaRelacionada = ISNULL(a.NombrePersonaRelacionada, ''),
			 PaternoPersonaRelacionada = ISNULL(a.PaternoPersonaRelacionada, ''),
			 MaternoPersonaRelacionada = ISNULL(a.MaternoPersonaRelacionada, ''),
			 DescripcionOperacion = ISNULL(a.DescripcionOperacion, ''),
			 Razones = ISNULL(a.Razones, '')
	FROM dbo.tPLDoperacionesInusuales a WITH (NOLOCK)
	JOIN tSITempresas emp WITH (NOLOCK) ON emp.IdEmpresa=a.IdEmpresa
	JOIN dbo.tSITperiodos pe ON pe.IdPeriodo = a.IdPeriodo
	WHERE a.IdPeriodo=@IdPeriodo

)









GO

