

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
begin

/* INFO (?_?) JCA.21/02/2024.09:39 a. m. 
Nota: Se agrega columnas saldo deudor vacia, se cambia la tabla de sucursales por la función con los códigos de asemex y se comentan los beneficiarios 5 y 6, y se modifico la vista de domicilios para poner NA donde encuentre CERO
*/



DECLARE @IdPeriodo AS INT
DECLARE @NumPeriodo AS INT
DECLARE @FechaInicioPeriodo AS DATE
DECLARE @FechaFinPeriodo AS DATE
DECLARE @Tipo AS TINYINT = @pTipo

SELECT @IdPeriodo=p.IdPeriodo, @FechaInicioPeriodo=p.Inicio ,@FechaFinPeriodo=p.Fin, @NumPeriodo=p.Numero 
FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND p.Codigo=@Periodo

DECLARE @contratos TABLE(
		Folio						INT,
		CodigoServicio				VARCHAR(30),
		Servicio					VARCHAR(80),
		InicioVigencia				DATE,
		FinVigencia					DATE,
		Paterno						VARCHAR(30),
		Materno						VARCHAR(30),
		Nombre						VARCHAR(80),
		FechaNacimiento				DATE,
		Nacionalidad				VARCHAR(80),
		Sexo						CHAR(1),
		Ocupacion					VARCHAR(80),
		RFC							VARCHAR(30),
		CURP						VARCHAR(80),
		Sucursal					VARCHAR(80),
		NoSocio						VARCHAR(20),
		Edad						INT,
		IdRelDomicilios				INT,
		RelReferenciasPersonales	INT,
		IdRelTelefonos				INT,
		IdSocio						INT,
		IdPersona					INT
)

IF @Tipo=1
BEGIN
	INSERT @contratos
	EXEC dbo.pASEMEXdatosContratos @Periodo = @Periodo, 
	                               @pTipo = 1     
END	

IF @Tipo=2
BEGIN
	DECLARE @periodoAnterior VARCHAR(8)=(SELECT p.Codigo FROM dbo.tCTLperiodos p WHERE p.IdPeriodo=(@IdPeriodo-IIF(@NumPeriodo=1,2,1)))
	
	DECLARE @bajasAnterior TABLE(
		Folio						INT,
		CodigoServicio				VARCHAR(30),
		Servicio					VARCHAR(80),
		InicioVigencia				DATE,
		FinVigencia					DATE,
		Paterno						VARCHAR(30),
		Materno						VARCHAR(30),
		Nombre						VARCHAR(80),
		FechaNacimiento				DATE,
		Nacionalidad				VARCHAR(80),
		Sexo						CHAR(1),
		Ocupacion					VARCHAR(80),
		RFC							VARCHAR(30),
		CURP						VARCHAR(80),
		Sucursal					VARCHAR(80),
		NoSocio						VARCHAR(20),
		Edad						INT,
		IdRelDomicilios				INT,
		RelReferenciasPersonales	INT,
		IdRelTelefonos				INT,
		IdSocio						INT,
		IdPersona					INT
)

	DECLARE @vigentes TABLE(
		Folio						INT,
		CodigoServicio				VARCHAR(30),
		Servicio					VARCHAR(80),
		InicioVigencia				DATE,
		FinVigencia					DATE,
		Paterno						VARCHAR(30),
		Materno						VARCHAR(30),
		Nombre						VARCHAR(80),
		FechaNacimiento				DATE,
		Nacionalidad				VARCHAR(80),
		Sexo						CHAR(1),
		Ocupacion					VARCHAR(80),
		RFC							VARCHAR(30),
		CURP						VARCHAR(80),
		Sucursal					VARCHAR(80),
		NoSocio						VARCHAR(20),
		Edad						INT,
		IdRelDomicilios				INT,
		RelReferenciasPersonales	INT,
		IdRelTelefonos				INT,
		IdSocio						INT,
		IdPersona					INT
)

	INSERT @bajasAnterior
	EXEC dbo.pASEMEXdatosContratos @Periodo = @periodoAnterior, 
	                               @pTipo = 2     

	INSERT @vigentes
	EXEC dbo.pASEMEXdatosContratos @Periodo = @Periodo, 
	                               @pTipo = 3

	INSERT @contratos
	SELECT b.*
	FROM @bajasAnterior b
	WHERE NOT EXISTS (SELECT c.NoSocio FROM @vigentes c WHERE c.NoSocio = b.NoSocio)							  

END	

IF @Tipo=3
BEGIN
	INSERT @contratos
	EXEC dbo.pASEMEXdatosContratos @Periodo = @Periodo, 
	                               @pTipo = 3     

	INSERT @contratos
	EXEC dbo.pASEMEXdatosContratos @Periodo = @Periodo, 
	                               @pTipo = 2     
END


--SELECT COUNT(1) FROM @contratos

SELECT 
  cs.Folio
, [CodigoServicio]				= cs.CodigoServicio
, [Servicio]					= cs.Servicio
, cs.InicioVigencia
, cs.FinVigencia
-- Campos ASEMEX
, [Paterno]						= cs.Paterno
, [Materno]						= cs.Materno
, [Nombre]						= cs.Nombre
, cs.FechaNacimiento
, dom.Calle
, dom.NumeroExterior
, dom.NumeroInterior
, dom.Asentamiento
, [Ciudad]						= IIF(dom.Ciudad IS NULL OR dom.Ciudad='',dom.Municipio,dom.Ciudad)
, [CveEstado]					= edos.PKEstado
, dom.CodigoPostal
, [NumeroTelefono]				= tel.Telefono
, cs.Nacionalidad
, cs.Sexo
, [Ocupacion]					= cs.Ocupacion
, cs.RFC
, cs.CURP
, [Sucursal]					= cs.Sucursal
, [sumaUltimosGastos]			= 60000,
  [Saldo-Deudor]				='',
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
  ben.B4porcentaje
  
  --ben.B5AP,
  --ben.B5AM,
  --ben.B5Nombre,
  --ben.B5Parentesco,
  --ben.B5porcentaje,

  --ben.B6AP,
  --ben.B6AM,
  --ben.B6Nombre,
  --ben.B6Parentesco,
  --ben.B6porcentaje
, [PorcentajeTotal]				= (ISNULL(ben.B1porcentaje,0) + 
								   ISNULL(ben.B2porcentaje,0) +  
								   ISNULL(ben.B3porcentaje,0) + 
								   ISNULL(ben.B4porcentaje,0)) 
, [NoSocio]						= cs.NoSocio
, [Edad]						= cs.Edad -- DATEDIFF(YEAR,pf.FechaNacimiento,@FechaFinPeriodo)
, [Estatus]						= CASE 
									WHEN @Tipo=1 THEN 'ALTAS'
									WHEN @Tipo=2 THEN 'BAJAS'
									WHEN @Tipo=3 THEN 'CON SEGURO'
								END
FROM @contratos cs
LEFT JOIN dbo.vASEMEXdomiciliosPrincipales dom  WITH(NOLOCK) 
	ON dom.IdRel=cs.IdRelDomicilios
LEFT JOIN tASEMEXestados edos
	ON edos.IdEstado=dom.IdEstado
LEFT JOIN dbo.fnAYCpivotDatosBeneficiarios() ben  
	ON ben.RelReferenciasPersonales = cs.RelReferenciasPersonales
LEFT JOIN dbo.fnLSTprimerTelefonoCelular() tel
	ON tel.IdRel=cs.IdRelTelefonos



END
GO

