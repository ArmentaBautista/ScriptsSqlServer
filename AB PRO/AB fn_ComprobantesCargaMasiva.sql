

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fn_ComprobantesCargaMasiva')
BEGIN
	DROP FUNCTION dbo.fn_ComprobantesCargaMasiva
	SELECT 'fn_ComprobantesCargaMasiva BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fn_ComprobantesCargaMasiva()
RETURNS TABLE
AS RETURN(

SELECT 
DISTINCT
CONCAT(TRY_CAST(c.IdComprobante AS VARCHAR),',',TRY_CAST(ISNULL(plantilla.id_pln_cfd, 0) AS VARCHAR)) AS Cadena,
-1 as id_plant_impto,
doc.id_doc As id_tip_Doc, 
CONVERT( 
  varchar(2), 
  doc.id_doc 
) + ' - ' + doc.descripcion As des_tip_doc, 
c.IdComprobante,
c.RfcEmisor,
c.NombreEmisor,
c.RfcReceptor,
c.NombreReceptor,
c.Serie,
c.Folio,
c.Fecha,
c.FormaPago,
c.CondicionesDePago,
c.SubTotal,
c.Descuento,
c.Moneda,
CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),c.TipoCambio)) as TipoCambio,
c.Total,
c.TipoDeComprobante,
c.MetodoPago,
c.LugarExpedicion,
c.Confirmacion,
c.VersionTimbre,
c.UUIDTimbre,
c.FechaTimbrado,
c.RfcProvCertif,
c.EstatusSAT,
c.FechaCancelacion,
CONVERT(NVARCHAR(MAX),c.xmlCFDI) AS xmlCFDI,
c.Emitido,
c.FechaRegistro,
CASE WHEN c.cmt = '' THEN sis_conceptos.des ELSE c.cmt END as cmt,
c.IdPlantilla,
c.moneda As Codigo, 
ISNULL(prov.id_prov, 0) AS id_prov, 
ISNULL(prov.rfc, '') As rfc_prov, 
ISNULL(prov.clave, '') As clave, 
ISNULL(prov.nom2, '') As proveedor, 
cnd.id_cnd, 
cnd.des AS des_cnd, 
ISNULL(tem_id_prov.id_mda, 0) As id_mda, 
c.TipoCambio As[tc], 
ISNULL(plantilla.id_pln_cfd, 0) AS id_pln_cfd, 
ISNULL(plantilla.cod_pln, 0) AS cod_pln, 
ISNULL(plantilla.des_pln, 0) AS des_pln, 
'-' As pdf, 
ISNULL(tem_num_pln.Tot_Plantillas, 0) AS Tot_Plantillas, 
ISNULL(tem_num_prov.Tot_provs, 0) AS Tot_provs, 
'' As Observa, 
ISNULL(sis_conceptos.id_cpt, 0) AS id_cpt, 
ISNULL(sis_conceptos.des, '') AS des_cpt, 
ISNULL(arch.archivo, '') as archivo, 
ISNULL(arch.ruta, '') AS ruta, 
0 as status_observ, 
ISNULL(cxp_doc.id_tip_doc, 0) As cxp_doc_id_tip_doc, 
ISNULL(cxp_doc.num_doc, 0) AS cxp_doc_num_doc, 
ISNULL(Imptos_Local.ImptoLocal, 0) AS ImptoLocal, 
ISNULL(prov.id_prov_pad, 0) AS id_prov_pad, 
ISNULL(plantilla.id_pln_cpt, -1) as id_pln_cpt, 
CASE WHEN t.IdComprobante IS NULL THEN '0' ELSE '1' END as Addenda, 
'' as comentario,0 as fac_numero,'' as fac_origen,'' as fac_destino, 0 as fac_monto,0 as fac_cantidad, '' as fac_cliente,'' as fac_corporativo,'' as fac_matriz,0 as fac_nofactura,0 as fac_flete 
FROM CFDIdataComprobante c WITH(NOLOCK) 
LEFT OUTER JOIN xml_desde_cfd arch WITH(nolock) ON(c.UUIDTimbre = arch.uuid) 
LEFT OUTER JOIN( 
  select 
    v.rfc, 
    v.id_mda, 
    v.moneda, 
    v.id_prov 
  from 
    vt_cargamasiva_cfdi_cxp_grp_prov v 
  GROUP BY 
    v.rfc, 
    v.id_mda, 
    v.moneda, 
    v.id_prov 
) tem_id_prov ON c.RfcEmisor = tem_id_prov.rfc AND c.moneda = tem_id_prov.moneda AND tem_id_prov.id_prov <> 0 
LEFT OUTER JOIN( 
  SELECT 
    REPLACE( 
      REPLACE(cat_prov.rfc, '-', ''),       ' ', 
      '' 
    ) AS RFC, 
    id_mda, 
    COUNT(cat_prov.id_prov) As Tot_Provs 
  FROM 
    cat_prov WITH(nolock) 
  WHERE 
    cat_prov.status = 1 
  GROUP BY 
    REPLACE( 
      REPLACE(cat_prov.rfc, '-', ''), 
      ' ', 
      '' 
     ), 
     id_mda 
) tem_num_prov ON c.RfcEmisor = tem_num_prov.RFC AND tem_id_prov.id_mda = tem_num_prov.id_mda 
LEFT OUTER JOIN cat_prov prov WITH(nolock) ON prov.id_prov = tem_id_prov.id_prov 
LEFT OUTER JOIN( 
  SELECT 
    id_prov, 
    COUNT(id_pln_cfd) as Tot_Plantillas, 
    ( 
      SELECT 
        top 1 id_pln_cfd 
      from 
        sis_rel_pln_cfd rel_cfd WITH(nolock) 
      WHERE 
        rel_cfd.id_prov = sis_rel_pln_cfd.id_prov 
      ORDER by 
        rel_cfd.c_def DESC, 
        id_pln_cfd 
    ) As id_pln_cfd_def 
  FROM 
    sis_rel_pln_cfd WITH(nolock) 
  group by 
    id_prov 
) tem_num_pln ON tem_num_pln.id_prov = prov.id_prov_pad 
LEFT OUTER JOIN sis_pln_cfd plantilla WITH(nolock) ON plantilla.id_pln_cfd = tem_num_pln.id_pln_cfd_def 
LEFT OUTER JOIN cat_cnd cnd WITH(nolock) ON cnd.id_cnd = ( 
  CASE WHEN c.metodopago = 'PUE' THEN( 
    SELECT 
      TOP 1 id_cnd 
    FROM 
      cat_cnd WITH(NOLOCK) 
    WHERE 
      dias = 0 
      AND met_pag = 'PUE' 
      AND id_cnd > 0 
) ELSE ISNULL(prov.id_cnd_pag, 0) END 
)  
LEFT OUTER JOIN( 
  SELECT 
    IdComprobante, 
    SUM(ImporteTras) AS ImptoLocal 
  from 
    CFDIDataCompImptoLocal WITH (NOLOCK) 
  GROUP BY 
    IdComprobante 
) Imptos_Local ON Imptos_Local.IdComprobante = c.IdComprobante 
INNER JOIN cat_doctos doc WITH(nolock) ON doc.id_doc = 92 
LEFT OUTER JOIN sis_conceptos WITH(nolock) ON sis_conceptos.id_cpt = CONVERT( 
  tinyint, 
  ( 
    select 
      Valor 
    from 
      cfg_global with (nolock) 
    where 
      campo = 'id_cpt_def_cxp' 
  ) 
)  
LEFT OUTER JOIN cxp_doc WITH(nolock) ON cxp_doc.uuid = c.UUIDTimbre AND cxp_doc.status IN(1, 2)  
LEFT JOIN sis_aud_cfdi f WITH(NOLOCK) ON f.UUID = c.UUIDTimbre AND UPPER(f.ESTATUS_COMPROBANTE) = UPPER('VIGENTE') 
LEFT JOIN aux_carga_masiva b WITH(NOLOCK) ON b.IdComprobante = c.IdComprobante 
AND cxp_doc.status IN(1, 2)  
LEFT JOIN( 
  SELECT 
    IdComprobante 
  FROM 
    CFDIdataAddenda WITH(NOLOCK) 
  GROUP BY 
    IdComprobante 
) as t ON t.IdComprobante = c.IdComprobante 
Where b.IdComprobante IS NULL   /*id_cmp=2*/  
AND arch.TipoDeComprobante = 'I' 
AND cxp_doc.num_doc IS NULL 
AND prov.id_prov <> 0  AND (prov.id_prov <> 0 OR prov.id_prov IS NOT NULL)

)
GO

