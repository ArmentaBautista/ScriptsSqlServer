SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


ALTER VIEW [dbo].[vAYCaperturasCON]
	AS
SELECT      ta.IdApertura,
            Folio,
            Fecha,
            ta.IdTipoDProducto,
            d.Descripcion AS TipoDproductoDescripcion,
            ta.IdProductoFinanciero,
            taf.Descripcion AS ProductoDescripcion,
            ta.IdTipoDAIC,
            dp.Descripcion AS TipoDAICdescripcion,
            IIF(ta.EsCreditoGrupal = 1, gr.Descripcion, Persona.Nombre) AS [GrupoSocio],
            Socio.Codigo AS SocioCodigo,
            IIF(ta.EsCreditoGrupal = 1, 'Sí', 'No') AS EsCreditoGrupal,
            ta.MontoSolicitado,
            ta.IdSucursal,
            tc2.Descripcion AS SucursalDescripcion,
            ta.IdEstatus,
            tc.Codigo AS EstatusCodigo,
            tc.Descripcion AS EstatusDescripcion,
            [CuentaIdCuenta] = c.IdCuenta,
            [CuentaCodigo] = c.Codigo,
            [CuentaDescripcion] = c.Descripcion,
            [CuentaIdEstatusEntrega] = c.IdEstatusEntrega,
            [CuentaEstatusEntrega] = ece.Descripcion,
            [CuentaEsPrecalificado] = ISNULL(c.EsPrecalificado, 0)
 FROM tAYCaperturas ta WITH(NOLOCK)
     INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK)ON c.IdApertura=ta.IdApertura
     INNER JOIN dbo.tCTLestatus ece WITH(NOLOCK)ON ece.IdEstatus=c.IdEstatusEntrega
     INNER JOIN tAYCproductosFinancieros taf WITH(NOLOCK)ON taf.IdProductoFinanciero=ta.IdProductoFinanciero
     INNER JOIN tCTLtiposD d WITH(NOLOCK)ON d.IdTipoD=ta.IdTipoDProducto
     INNER JOIN tCTLtiposD dp WITH(NOLOCK)ON dp.IdTipoD=ta.IdTipoDAIC
     INNER JOIN tCTLestatus tc WITH(NOLOCK)ON tc.IdEstatus=ta.IdEstatus
     INNER JOIN tCTLsucursales tc2 WITH(NOLOCK)ON tc2.IdSucursal=ta.IdSucursal
     INNER JOIN tSCSsocios Socio WITH(NOLOCK)ON Socio.IdSocio=c.IdSocio
     INNER JOIN tGRLpersonas Persona WITH(NOLOCK)ON Persona.IdPersona=Socio.IdPersona
     INNER JOIN tAYCgrupos gr WITH(NOLOCK)ON gr.IdGrupo=ta.IdGrupo

 WHERE      ta.IdApertura <> 0;
 
GO


