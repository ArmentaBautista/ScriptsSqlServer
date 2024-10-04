
-- Asentamientos
SELECT a.IdAsentamiento, a.ClaveSEPOMEX, a.Descripcion, a.CodigoPostal
FROM dbo.tCTLasentamientos a  WITH(nolock) WHERE a.IdEstatus=1

-- Municipios
SELECT m.IdMunicipio, m.Codigo, m.Descripcion, m.IdEstado
FROM dbo.tCTLmunicipios m  WITH(nolock) WHERE m.IdMunicipio!=0 AND m.IdEstatus=1

-- Estados
SELECT e.IdEstado, e.Codigo, e.Descripcion
FROM dbo.tCTLestados e  WITH(nolock) WHERE e.IdEstatus=1

-- Nivel de Riesgo
SELECT e.IdTipoE, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual 
WHERE e.IdTipoE=225

-- Orígenes de Recursos
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual 
WHERE e.IdTipoE=273

-- Tipos de Montos de Depósitos al Mes
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE=175

-- Monto de Retiro / Pagos Mes
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE=177

-- Número de Depósitos / Pagos Mes
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE=176

-- Número de Retiro / Pagos Mes
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE= 178

-- Medios de difusión de la Entidad
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE= 179

-- Tipos de Servicios Financieros de la Entidad
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE= 180

-- Medios de Disposición de la Entidad
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE= 181

-- Tipo de Actividad (giro)
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE e.IdTipoE= 185

-- Tipo de Empleo
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual 
WHERE e.IdTipoE= 182

-- Ambito de Actividades de Negocio
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE e.IdTipoE= 184

-- Tipo de Actividad Económica
SELECT e.IdTipoE, e.Descripcion, ld.IdTipoD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ld.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCTLtiposD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE --AND ld.IdEstatus=1
WHERE e.IdTipoE= 183

-- Productos
SELECT pf.IdProductoFinanciero, pf.Codigo, pf.Descripcion, pf.DescripcionLarga, td.Descripcion AS Tipo, ea.IdEstatus
FROM dbo.tAYCproductosFinancieros pf  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = pf.IdEstatusActual
INNER JOIN dbo.tCTLtiposD td  WITH(nolock) ON td.IdTipoD = pf.IdTipoDDominioCatalogo
ORDER BY Tipo

-- Impuestos
SELECT imp.IdImpuesto, imp.Codigo, imp.Descripcion, ea.IdEstatus
FROM dbo.tIMPimpuestos imp  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = imp.IdEstatusActual
WHERE imp.IdImpuesto!=0


-- Motivo de Castigo | Condonación
SELECT e.IdTipoE, e.Descripcion, ld.IdListaD, ld.Codigo, ld.Descripcion, ld.DescripcionLarga, ea.IdEstatus
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock)  ON ld.IdTipoE = e.IdTipoE
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual  AND ea.IdEstatus=1
WHERE e.IdTipoE= 148

-- Usuarios (Ejecutivos, Asesores)
SELECT u.IdUsuario, u.Usuario
FROM dbo.tCTLusuarios u  WITH(nolock) 



