

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pASEMEXreporteContratosSegurosVida')
BEGIN
	DROP PROC pASEMEXreporteContratosSegurosVida
	SELECT 'pASEMEXreporteContratosSegurosVida BORRADO' AS info
END
GO

CREATE PROC pASEMEXreporteContratosSegurosVida
	@Periodo AS VARCHAR(50)='',
	@pTipo AS TINYINT = 0	
AS
BEGIN

DECLARE @IdPeriodo AS INT
DECLARE @FechaInicioPeriodo AS DATE
DECLARE @FechaFinPeriodo AS DATE
DECLARE @Tipo AS TINYINT = @pTipo

SELECT @IdPeriodo=p.IdPeriodo, @FechaInicioPeriodo=p.Inicio ,@FechaFinPeriodo=p.Fin FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND p.Codigo=@Periodo

	
SELECT 
  cs.Folio
, [CodigoServicio]				= s.Codigo
, [Servicio]						= s.Descripcion
, cs.InicioVigencia
, cs.FinVigencia
-- Campos ASEMEX
, [Paterno]						= pf.ApellidoPaterno
, [Materno]						= pf.ApellidoMaterno
, [Nombre]						= pf.Nombre
, pf.FechaNacimiento
, dom.Calle
, dom.NumeroExterior
, dom.NumeroInterior
, dom.Asentamiento
, [Ciudad]						= IIF(dom.Ciudad IS NULL OR dom.Ciudad='',dom.Municipio,dom.Ciudad)
, [CveEstado]					= edos.PKEstado
, dom.CodigoPostal
, [NumeroTelefono]				= tel.Telefono
, n.Nacionalidad
, pf.Sexo
, [Ocupacion]					= locupacion.Descripcion
, p.RFC
, pf.CURP
, [Sucursal]					= suc.Descripcion
, [sumaUltimosGastos]			= 60000,
  ben.B1AP,
  ben.B1AM,
  ben.B1Nombre,
  ben.B1Parentesco,
  ben.B1porcentaje,
  
  ben.B2AP,
  ben.B2AM,
  ben.B2Nombre,
  ben.B2Parentesco,
  ben.B2porcentaje,
  
  ben.B3AP,
  ben.B3AM,
  ben.B3Nombre,
  ben.B3Parentesco,
  ben.B3porcentaje,

  ben.B4AP,
  ben.B4AM,
  ben.B4Nombre,
  ben.B4Parentesco,
  ben.B4porcentaje,
  
  ben.B5AP,
  ben.B5AM,
  ben.B5Nombre,
  ben.B5Parentesco,
  ben.B5porcentaje,

  ben.B6AP,
  ben.B6AM,
  ben.B6Nombre,
  ben.B6Parentesco,
  ben.B6porcentaje
, [PorcentajeTotal]				= (ISNULL(ben.B1porcentaje,0) + 
								   ISNULL(ben.B2porcentaje,0) +  
								   ISNULL(ben.B3porcentaje,0) + 
								   ISNULL(ben.B4porcentaje,0) + 
								   ISNULL(ben.B5porcentaje,0) + 
								   ISNULL(ben.B6porcentaje,0)) 
, [NoSocio]						= sc.Codigo
, [Edad]						= DATEDIFF(YEAR,pf.FechaNacimiento,@FechaFinPeriodo)
, [Estatus]						= CASE 
									WHEN @Tipo=1 THEN 'ALTAS'
									WHEN @Tipo=2 THEN 'BAJAS'
									WHEN @Tipo=3 THEN 'CON SEGURO'
								END
FROM dbo.tCOMcontratosServicios cs  WITH(NOLOCK) 
INNER JOIN dbo.tGRLbienesServicios s  WITH(NOLOCK) 
	ON s.IdServicio = cs.IdServicio
		AND cs.IdServicio=28
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = cs.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
	ON pf.IdPersona = p.IdPersona
INNER JOIN dbo.vCTLDomiciliosPrincipales dom  WITH(NOLOCK) 
	ON dom.IdRel=p.IdRelDomicilios
LEFT JOIN tASEMEXestados edos
	ON edos.IdEstado=dom.IdEstado
LEFT JOIN dbo.fnAYCpivotDatosBeneficiarios() ben  
	ON ben.RelReferenciasPersonales = pf.RelReferenciasPersonales
LEFT JOIN dbo.fnLSTprimerTelefonoCelular() tel
	ON tel.IdRel=p.IdRelTelefonos
LEFT JOIN (
		SELECT *
		 FROM (
				 SELECT 
				 Numero = ROW_NUMBER() OVER(PARTITION BY np.IdPersona ORDER BY np.IdNacionalidad DESC)
				 , np.IdPersona
				 ,[Nacionalidad]	= n.Descripcion
				 FROM dbo.tGRLnacionalidadesPersona np  WITH(NOLOCK) 
				 INNER JOIN dbo.tCTLnacionalidades n  WITH(NOLOCK) 
					ON n.IdNacionalidad = np.IdNacionalidad
				WHERE np.IdEstatus=1
		) AS nac 
		WHERE nac.Numero=1
) n ON n.IdPersona = p.IdPersona
LEFT JOIN dbo.tCATlistasD locupacion  WITH(NOLOCK) 
	ON locupacion.IdListaD = pf.IdListaDOcupacion
LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
	ON suc.IdSucursal = sc.IdSucursal
WHERE 
(@Tipo=1 AND cs.IdEstatus=1 AND cs.InicioVigencia BETWEEN @FechaInicioPeriodo AND @FechaFinPeriodo)
	OR (@Tipo=2 AND cs.IdEstatus=1 AND cs.FinVigencia BETWEEN @FechaInicioPeriodo AND @FechaFinPeriodo)
		OR (@Tipo=3 AND cs.IdEstatus=1 AND cs.FinVigencia > @FechaFinPeriodo )


END
GO