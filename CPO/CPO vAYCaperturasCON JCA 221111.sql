SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


ALTER VIEW [dbo].[vAYCaperturasCON]
	AS

SELECT      ta.IdApertura,
            Folio,
            Fecha,
            ta.IdTipoDProducto,
			CASE c.IdTipoDProducto 
				WHEN 144 THEN 'DISPONIBILIDAD INMEDIATA'
				WHEN 143 THEN 'CRÉDITO'
				WHEN 398 THEN 'INVERSIÓN'
				WHEN 716 THEN 'CERTIFICADO APORTACIÓN'
				WHEN 2196 THEN 'PRODUCTO ACREEDOR'
				WHEN 2197 THEN 'PRODUCTO DEUDOR'
				ELSE 'OTRO'
			END AS TipoDproductoDescripcion,
            ta.IdProductoFinanciero,
			c.Descripcion AS ProductoDescripcion,
            ta.IdTipoDAIC,
			CASE ta.IdTipoDAIC 
				WHEN 400 THEN 'A LA VISTA'
				WHEN 401 THEN 'CONSUMO'
				WHEN 402 THEN 'COMERCIO'
				WHEN 403 THEN 'VIVIENDA'
				WHEN 489 THEN 'AHORRO'
				WHEN 490 THEN 'A PLAZO'
				WHEN 762 THEN 'APORTACIÓN'
				WHEN 2198 THEN 'PROD ACREEDOR'
				WHEN 2199 THEN 'PROD DEUDOR'
			END AS TipoDAICdescripcion,
			Persona.Nombre AS [GrupoSocio],
            Socio.Codigo AS SocioCodigo,
            IIF(ta.EsCreditoGrupal = 1, 'Sí', 'No') AS EsCreditoGrupal,
            ta.MontoSolicitado,
            ta.IdSucursal,
            tc2.Descripcion AS SucursalDescripcion,
            c.IdEstatus,
            '' AS EstatusCodigo,
			CASE c.IdEstatus 
				WHEN 7 THEN 'CERRADO'
				WHEN 56 THEN 'CERRANDO CUENTA'
				WHEN 73 THEN 'CONDONADO'
				WHEN 89 THEN 'VERIFICACION APROBADA'
				WHEN 30 THEN 'PENDIENTE AUTORIZAR'
				WHEN 80 THEN 'TEMPORAL RESTRUCTURA'
				WHEN 9 THEN 'AUTORIZADO'
				WHEN 18 THEN 'CANCELADO'
				WHEN 86 THEN 'EN VERIFICACION'
				WHEN 1 THEN 'ACTIVO'
				WHEN 3 THEN 'INACTIVO'
				WHEN 10 THEN 'RECHAZADO'
				WHEN 53 THEN 'CASTIGADA'
				WHEN 85 THEN 'PENDIENTE DE VERIFICACION'
			END AS EstatusDescripcion,
            [CuentaIdCuenta] = c.IdCuenta,
            [CuentaCodigo] = c.Codigo,
            [CuentaDescripcion] = c.Descripcion,
            [CuentaIdEstatusEntrega] = c.IdEstatusEntrega,
			CASE c.IdEstatusEntrega
				WHEN 20 THEN 'Entregado'
				WHEN 26 THEN 'No Entregado'
			END AS CuentaEstatusEntrega,
            [CuentaEsPrecalificado] = ISNULL(c.EsPrecalificado, 0)
 FROM tAYCaperturas ta WITH(NOLOCK)
     INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK)ON c.IdApertura=ta.IdApertura
     INNER JOIN tCTLsucursales tc2 WITH(NOLOCK)ON tc2.IdSucursal=ta.IdSucursal
     INNER JOIN tSCSsocios Socio WITH(NOLOCK)ON Socio.IdSocio=c.IdSocio
     INNER JOIN tGRLpersonas Persona WITH(NOLOCK)ON Persona.IdPersona=Socio.IdPersona
 WHERE      ta.IdApertura <> 0;
 
GO


