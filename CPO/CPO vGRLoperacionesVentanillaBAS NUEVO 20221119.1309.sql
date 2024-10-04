
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vGRLoperacionesVentanillaBAS')
BEGIN
	DROP VIEW vGRLoperacionesVentanillaBAS
	SELECT 'vGRLoperacionesVentanillaBAS BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE VIEW dbo.vGRLoperacionesVentanillaBAS
AS 
--consulta para Ventanilla
SELECT DISTINCT tg.IdOperacion,tg.IdSucursal,sucursal.Descripcion AS SucursalDescripcion,empresa.NombreComercial AS EmpresaNombreComercial 
,tg.IdCuentaABCD, tg.IdTipoOperacion,tg.Serie , tg.Folio ,
(tg.Serie + CAST(tg.Folio AS VARCHAR) ) AS [SerieFolio],tg.Fecha,tga.Descripcion AS Caja,
ts2.Codigo AS SocioCodigo,tg2.Nombre AS Socio
,tg2.Nombre AS Concepto,'' AS Referencia
,CASE WHEN Total<0 THEN 'Retiro' WHEN total=0 THEN '----' ELSE 'Depósito' END AS [Operacion] ,ABS(tg.Total) AS Total,tg.IdEstatus,tg.IdUsuarioAlta,
DescripcionLarga=ban.NombreComercial+' - '+tga.NumeroCuenta+' - '+td.Descripcion
,FolioIdSesion=tg.Folio
FROM tGRLoperaciones tg				WITH (NOLOCK)
INNER JOIN tCTLtiposOperacion tco	WITH (NOLOCK) ON tco.IdTipoOperacion = tg.IdTipoOperacion
INNER JOIN tCTLsucursales sucursal	WITH (NOLOCK) ON sucursal.IdSucursal = tg.IdSucursal
INNER JOIN tCTLempresas empresa		WITH (NOLOCK) ON empresa.IdEmpresa = sucursal.IdEmpresa
INNER JOIN tGRLcuentasABCD tga	WITH(NOLOCK) ON tga.IdCuentaABCD = tg.IdCuentaABCD
INNER JOIN tSCSsocios ts2		WITH(NOLOCK) ON ts2.IdSocio = tg.IdSocio
INNER JOIN tGRLpersonas tg2		WITH(NOLOCK) ON tg2.IdPersona = ts2.IdPersona
INNER JOIN dbo.tFNZbancos ban WITH(NOLOCK)ON ban.IdBanco = tga.IdBanco
INNER JOIN dbo.tCTLtiposD td WITH (NOLOCK) ON td.IdTipoD = tga.IdTipoD
WHERE tg.IdTipoOperacion = 1 AND tg.IdOperacion!=0
AND tg.fecha=CAST(GETDATE() AS DATE)

GO


