

	DECLARE @tCATdomicilios AS TABLE
	(
	IdSucursal		INT,
	Sucursal		VARCHAR(80),
	IdSocio			INT,
	NoSocio			VARCHAR(20),
	Nombre			VARCHAR(250),
	IdCuenta		INT,
	NoCuenta		VARCHAR(30),
	Producto		VARCHAR(80),
	TipoDomicilio	VARCHAR(250),
	IdDomicilio		INT,
	IdRel			INT,
	IdTipoD			INT ,
	Descripcion		VARCHAR (512) ,
	Calle			VARCHAR (80) ,
	NumeroExterior	VARCHAR (24),
	NumeroInterior	VARCHAR (24),
	Calles			VARCHAR (80) ,
	CodigoPostal	VARCHAR (10),
	Asentamiento	VARCHAR (80),
	Ciudad			VARCHAR (80) ,
	Municipio		VARCHAR (80) ,
	Estado			VARCHAR (80) ,
	Pais			VARCHAR (80) ,
	IdAsentamiento	INT ,
	IdCiudad		INT ,
	IdMunicipio		INT,
	IdEstado		INT,
	IdPais			INT,
	IdEstatusActual INT,
	Referencia		VARCHAR (250)
	) 

INSERT INTO @tCATdomicilios
SELECT 
  suc.IdSucursal,
  suc.Descripcion,
  sc.IdSocio
, sc.Codigo AS NoSocio
, p.Nombre
, c.IdCuenta
, c.Codigo AS Nocuenta
, c.Descripcion AS Producto
, td.Descripcion as TipoDomicilio
, dom.IdDomicilio		
, dom.IdRel			
, dom.IdTipoD			
, dom.Descripcion		
, dom.Calle			
, dom.NumeroExterior	
, dom.NumeroInterior	
, dom.Calles			
, dom.CodigoPostal	
, dom.Asentamiento	
, dom.Ciudad			
, dom.Municipio		
, dom.Estado			
, dom.Pais			
, dom.IdAsentamiento	
, dom.IdCiudad		
, dom.IdMunicipio		
, dom.IdEstado		
, dom.IdPais			
, dom.IdEstatusActual 
, dom.Referencia	
FROM tayccuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
	ON suc.IdSucursal = sc.IdSucursal
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) 
	ON dom.IdRel=p.IdRelDomicilios
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = dom.IdEstatusActual
		AND ea.IdEstatus=1
INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) 
	ON td.IdTipoD = dom.IdTipoD
WHERE c.IdTipoDProducto=143
	AND c.IdEstatus=1

SELECT
d.IdSucursal,
d.Sucursal,
d.NoSocio,
d.Nombre,
d.IdCuenta,
d.NoCuenta,
d.Producto,
d.TipoDomicilio,
IIF(d.IdAsentamiento>0,'FNG','SEPOMEX') AS TipoRegistroAsentamiento,
d.IdDomicilio,
d.IdRel,
d.IdTipoD,
d.Descripcion,
d.Calle,
d.NumeroExterior,
d.NumeroInterior,
d.Calles,
d.CodigoPostal,
d.Asentamiento,
d.Ciudad,
d.Municipio,
d.Estado,
d.Pais,
d.IdAsentamiento,
d.IdCiudad,
d.IdMunicipio,
d.IdEstado,
d.IdPais,
d.IdEstatusActual,
d.Referencia
FROM @tCATdomicilios d 
ORDER BY d.Sucursal, d.Nombre


