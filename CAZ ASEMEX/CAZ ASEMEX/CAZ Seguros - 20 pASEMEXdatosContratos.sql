
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pASEMEXdatosContratos')
BEGIN
	DROP PROC pASEMEXdatosContratos
	SELECT 'pASEMEXdatosContratos BORRADO' AS info
END
GO

CREATE PROC pASEMEXdatosContratos
	@Periodo as varchar(50)='',
	@pTipo as tinyint = 0	
as
begin
/* INFO (⊙_☉) JCA.21/02/2024.09:24 a. m. 
Nota: JCA 240221 Se agrega el uso de la función fnASEMEXsucursales para obtener la clave asignada por la aseguradora
*/

declare @IdPeriodo as int
declare @FechaInicioPeriodo as date
declare @FechaFinPeriodo as date
declare @Tipo as tinyint = @pTipo

select @IdPeriodo=p.IdPeriodo, @FechaInicioPeriodo=p.Inicio ,@FechaFinPeriodo=p.Fin from dbo.tCTLperiodos p  with(nolock) where p.EsAjuste=0 and p.Codigo=@Periodo

select
  cs.Folio
, [CodigoServicio]				= s.Codigo
, [Servicio]						= s.Descripcion
, cs.InicioVigencia
, cs.FinVigencia
, [Paterno]						= pf.ApellidoPaterno
, [Materno]						= pf.ApellidoMaterno
, [Nombre]						= pf.Nombre
, pf.FechaNacimiento
, n.Nacionalidad
, pf.Sexo
, [Ocupacion]					= locupacion.Descripcion
, p.RFC
, pf.CURP
, [Sucursal]					= suc.CodigoAsemex
, [NoSocio]						= sc.Codigo
, [Edad]						= DATEDIFF(YEAR,pf.FechaNacimiento,@FechaFinPeriodo)
, p.IdRelDomicilios
, pf.RelReferenciasPersonales
, p.IdRelTelefonos
, cs.IdSocio
, p.IdPersona
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
LEFT JOIN dbo.fnASEMEXsucursales() suc 
	ON suc.IdSucursal = sc.IdSucursal
WHERE 
(@Tipo=1 AND cs.IdEstatus=1 AND cs.InicioVigencia BETWEEN @FechaInicioPeriodo AND @FechaFinPeriodo)
	OR (@Tipo=2 AND cs.FinVigencia BETWEEN @FechaInicioPeriodo AND @FechaFinPeriodo)
		OR (@Tipo=3 AND cs.IdEstatus=1 AND cs.InicioVigencia <= @FechaFinPeriodo and cs.FinVigencia>@FechaFinPeriodo )
		

END
GO

