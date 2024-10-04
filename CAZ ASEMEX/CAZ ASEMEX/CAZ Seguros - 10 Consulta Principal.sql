


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pASEMEXreporteSeguros')
BEGIN
	DROP PROC pASEMEXreporteSeguros
	SELECT 'pASEMEXreporteSeguros BORRADO' AS info
END
GO

CREATE PROC pASEMEXreporteSeguros
	@pPeriodo AS VARCHAR(50)='',
	@pTipo AS TINYINT = 0	
AS
BEGIN
	
DECLARE @Periodo AS VARCHAR(7)=@pPeriodo
DECLARE @IdPeriodo AS INT
DECLARE @FechaFinPeriodo AS DATE
DECLARE @Tipo AS TINYINT = @pTipo

SELECT @IdPeriodo=p.IdPeriodo, @FechaFinPeriodo=p.Fin FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND p.Codigo=@Periodo


SELECT 
  [Paterno]						= pf.ApellidoPaterno
, [Materno]						= pf.ApellidoMaterno
, [Nombre]						= pf.Nombre
, pf.FechaNacimiento
, dom.Calle
, dom.NumeroExterior
, dom.Asentamiento
, dom.Ciudad
, [CveEstado]					= edos.PKEstado
, dom.CodigoPostal
, [NumeroTelefono]				= tel.Telefono
, n.Nacionalidad
, [Ocupacion]					= locupacion.Descripcion
, p.RFC
, pf.CURP
, [Sucursal]					= suc.Codigo
, [sumaUltimosGastos]			= 60000
, ben.B1Parentesco,
  ben.B1AP,
  ben.B1AM,
  ben.B1Nombre,
  ben.B1porcentaje,
  ben.B2Parentesco,
  ben.B2AP,
  ben.B2AM,
  ben.B2Nombre,
  ben.B2porcentaje,
  ben.B3Parentesco,
  ben.B3AP,
  ben.B3AM,
  ben.B3Nombre,
  ben.B3porcentaje,
  ben.B4Parentesco,
  ben.B4AP,
  ben.B4AM,
  ben.B4Nombre,
  ben.B4porcentaje,
  ben.B5Parentesco,
  ben.B5AP,
  ben.B5AM,
  ben.B5Nombre,
  ben.B6Parentesco,
  ben.B6AP,
  ben.B6AM,
  ben.B6Nombre,
  ben.B6porcentaje
, [PorcentajeTotal]				= (ben.B1porcentaje + ben.B2porcentaje + ben.B3porcentaje + ben.B4porcentaje + ben.B5porcentaje + ben.B6porcentaje)
, [NoSocio]						= sc.Codigo
, [Edad]						= DATEDIFF(YEAR,pf.FechaNacimiento,@FechaFinPeriodo)
, [Estatus]						= tc.Descripcion
FROM tHSTsocios h WITH (nolock) 
INNER JOIN tCTLestatus tc WITH (nolock) 
	ON tc.IdEstatus = h.IdEstatusSeguro
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = h.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
	ON pf.IdPersonaFisica = p.IdPersonaFisica
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
WHERE h.IdPeriodo = @IdPeriodo 
AND (
(@Tipo = 1 AND h.TieneCertificadoAportacion=1) 
	OR (@Tipo=2 AND h.BajaSeguro=1) 
		OR (@Tipo=3 AND h.AltaSeguro=1 
			AND h.TieneCertificadoAportacion=1))
 
END
GO


