


DECLARE @Periodo AS VARCHAR(7)='2023-07'
DECLARE @FechaFinPeriodo AS DATE=(SELECT p.Fin FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 and p.Codigo=@Periodo)

/*
DECLARE @Telefonos TABLE(
	Id				INT PRIMARY KEY IDENTITY,
	IdRel			INT,
	Telefono		VARCHAR(30),
	INDEX IX
)



SELECT 
cel.IdRel
,cel.Telefono
FROM dbo.tCATtelefonos cel  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) 
	ON ea.IdEstatusActual = cel.IdEstatusActual 
		AND ea.IdEstatus=1
WHERE cel.IdListaD=-1339
GROUP BY cel.IdRel, cel.Telefono

*/


SELECT 
  [FechaReferencia]				= @FechaFinPeriodo
, cs.Folio
, [CodigoServicio]				= s.Codigo
, [Servicio]						= s.Descripcion
, cs.InicioVigencia
, cs.FinVigencia
, [Paterno]						= pf.ApellidoPaterno
, [Materno]						= pf.ApellidoMaterno
, [Nombre]						= pf.Nombre
, pf.FechaNacimiento
, dom.Calle
, dom.NumeroExterior
, dom.Asentamiento
, dom.Ciudad
, dom.Estado
, dom.CodigoPostal
, [NoSocio]						= sc.Codigo
, [Edad]						= DATEDIFF(YEAR,pf.FechaNacimiento,@FechaFinPeriodo)
, [Estatus]						= 'CON SEGURO'
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
INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) 
	ON dom.IdRel=p.IdRelDomicilios
		AND dom.IdTipoD=11
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = dom.IdEstatusActual
		AND ea.IdEstatus=1
WHERE cs.FinVigencia>@FechaFinPeriodo





-- SELECT * FROM dbo.fnAYCpivotDatosBeneficiarios()

