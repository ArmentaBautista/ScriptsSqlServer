
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE OR ALTER FUNCTION [dbo].ft_fis_ded1(
@cod_tip_impto AS VARCHAR(25)='IVA'
)
RETURNS @tablaGp TABLE(
 [id_tip_doc] INT,
    [id_doc] INT,
    [id_doc_det] INT,
    [num_doc] INT,
    [fec_doc] DATETIME,
    [serie] VARCHAR(1),
    [no_fact] VARCHAR(40),
    [id_cli_fa_da] INT,
    [clave] VARCHAR(12),
    [nom1] VARCHAR(128),
    [nom2] VARCHAR(128),
    [rfc] VARCHAR(40),
    [cod_pro] NVARCHAR(30),
    [des_pro] NVARCHAR(250),
    [mto_bse_doc] FLOAT(8),
    [imptos_bse_doc] FLOAT(8),
    [total_bse_doc] FLOAT(8),
    [mto_bse] FLOAT(8),
    [imptos_bse] FLOAT(8),
    [total_bse] FLOAT(8),
    [id_impto] INT,
    [ptg_acu_com] FLOAT(8)
)
AS
BEGIN

	DECLARE @tabla TABLE(
    [id_tip_doc] INT,
    [id_doc] INT,
    [id_doc_det] INT,
    [num_doc] INT,
    [fec_doc] DATETIME,
    [serie] VARCHAR(1),
    [no_fact] VARCHAR(40),
    [id_cli_fa_da] INT,
    [clave] VARCHAR(12),
    [nom1] VARCHAR(128),
    [nom2] VARCHAR(128),
    [rfc] VARCHAR(40),
    [id_cpt] INT,
    [cpt] VARCHAR(500),
    [id_pro] INT,
    [cod_pro] NVARCHAR(30),
    [des_pro] NVARCHAR(250),
    [id_ent] INT,
    [cod_ent] VARCHAR(12),
    [des_ent] VARCHAR(50),
    [mto_bse_doc] FLOAT(8),
    [imptos_bse_doc] FLOAT(8),
    [total_bse_doc] FLOAT(8),
    [mto_bse] FLOAT(8),
    [imptos_bse] FLOAT(8),
    [total_bse] FLOAT(8),
    [id_impto] INT,
    [ptg_acu_vta] FLOAT(8),
    [ptg_acu_com] FLOAT(8),
    [id_tip_impto] INT,
    [cod_tip_impto] VARCHAR(50),
    [des_tip_impto] VARCHAR(160),
    [tip_cli_prov] INT,
    [id_cta] INT,
    [num_cta] VARCHAR(25),
    [nom] VARCHAR(80),
    [id_tbl] INT,
    [id_mda] INT,
    [id_cen_cto] INT
)

	INSERT INTO @tabla
	SELECT     e.id_tip_doc, e.id_cxp_doc AS id_doc, dd.id_cxp_doc_det AS id_doc_det, e.num_doc, e.fec_doc, '' AS serie, e.no_fact, pf.id_cli_fa_da, pf.clave, pf.nom1, pf.nom2, 
						  pf.rfc, e.id_cpt, CASE WHEN e.id_cpt > 0 THEN cp.des ELSE '' END AS cpt, dd.id_pro, CASE WHEN dd.id_pro > 0 THEN p.codigo ELSE '' END AS cod_pro, 
						  CASE WHEN dd.id_pro > 0 THEN p.des ELSE '' END AS des_pro, dd.id_ent, CASE WHEN dd.id_ent > 0 THEN g.clave ELSE '' END AS cod_ent, 
						  CASE WHEN dd.id_ent > 0 THEN g.des ELSE '' END AS des_ent, e.imp_doc_bse AS mto_bse_doc, e.imptos_bse AS imptos_bse_doc, e.total_bse AS total_bse_doc, 
						  dd.importe_bse AS mto_bse, dd.imptos_bse, dd.total_bse, dd.id_impto, fd.ptg_acu_vta, fd.ptg_acu_com, s.id_tip AS id_tip_impto, s.codigo AS cod_tip_impto, 
						  s.des AS des_tip_impto, 2 AS tip_cli_prov, c.id_cta, c.num_cta, c.nom, 125 AS id_tbl, e.id_mda, pd.id_cen_cto
	FROM         dbo.cxp_doc_det AS dd with (nolock) INNER JOIN
						  dbo.cxp_doc AS e with (nolock) ON e.id_cxp_doc = dd.id_cxp_doc INNER JOIN
						  dbo.cat_doctos AS d with (nolock) ON e.id_tip_doc = d.id_doc INNER JOIN
						  dbo.sis_conceptos AS cp with (nolock) ON e.id_cpt = cp.id_cpt INNER JOIN
						  dbo.cat_cli_fa_da AS pf with (nolock) ON e.id_prov_fis = pf.id_cli_fa_da INNER JOIN
						  dbo.cat_pro AS p with (nolock) ON dd.id_pro = p.id_pro INNER JOIN
						  dbo.cat_gastos AS g with (nolock) ON dd.id_ent = g.id_gto INNER JOIN
						  dbo.fis_cfg_rel AS r with (nolock) ON dd.id_fis_rel = r.id_fis_rel INNER JOIN
						  dbo.fis_cfg AS f with (nolock) ON r.id_fis_cfg = f.id_fis_cfg INNER JOIN
						  dbo.fis_cfg_det AS fd with (nolock) ON f.id_fis_cfg = fd.id_fis_cfg INNER JOIN
						  dbo.sis_tip AS s with (nolock) ON fd.id_tip_impto = s.id_tip LEFT OUTER JOIN
						  dbo.ctb_pol_det AS pd with (nolock) ON dd.id_cxp_doc_det = pd.id_part AND e.id_tip_doc = pd.id_tip_doc AND e.id_cxp_doc = pd.id_doc AND pd.id_tip_rub <> 520 LEFT OUTER JOIN
						  dbo.ctb_cta AS c with (nolock) ON pd.id_cta = c.id_cta
	WHERE     (d.id_doc_pad IN (92,94,95,96)) AND (s.tipo = 25) AND (dd.id_cli_a_cta_de = 0) AND e.status in (1,2) AND isnull(c.c_no_ded,0)=0 and e.id_tip_doc <> 150--AND c.c_no_ded=0  
	AND s.codigo=@cod_tip_impto
   
INSERT INTO @tabla
 SELECT     e.id_tip_doc, e.id_cxp_doc AS id_doc, dd.id_cxp_doc_det AS id_doc_det, e.num_doc, e.fec_doc, '' AS serie, e.no_fact, pf.id_cli_fa_da, pf.clave, pf.nom1, pf.nom2,   
        pf.rfc, e.id_cpt, CASE WHEN e.id_cpt > 0 THEN cp.des ELSE '' END AS cpt, dd.id_pro, CASE WHEN dd.id_pro > 0 THEN p.codigo ELSE '' END AS cod_pro,   
        CASE WHEN dd.id_pro > 0 THEN p.des ELSE '' END AS des_pro, dd.id_ent, CASE WHEN dd.id_ent > 0 THEN g.clave ELSE '' END AS cod_ent,   
        CASE WHEN dd.id_ent > 0 THEN g.des ELSE '' END AS des_ent, e.imp_doc_bse AS mto_bse_doc, e.imptos_bse AS imptos_bse_doc, e.total_bse AS total_bse_doc,   
        dd.importe_bse AS mto_bse, dd.imptos_bse, dd.total_bse, dd.id_impto, fd.ptg_acu_vta, fd.ptg_acu_com, s.id_tip AS id_tip_impto, s.codigo AS cod_tip_impto,   
        s.des AS des_tip_impto, 2 AS tip_cli_prov, c.id_cta, c.num_cta, c.nom, 125 AS id_tbl, e.id_mda, pd.id_cen_cto  
 FROM         dbo.cxp_doc_det AS dd with (nolock) INNER JOIN  
        dbo.cxp_doc AS e with (nolock) ON e.id_cxp_doc = dd.id_cxp_doc INNER JOIN  
        dbo.cat_doctos AS d with (nolock) ON e.id_tip_doc = d.id_doc INNER JOIN  
        dbo.sis_conceptos AS cp with (nolock) ON e.id_cpt = cp.id_cpt INNER JOIN  
        dbo.cat_cli_fa_da AS pf with (nolock) ON dd.id_prov_fis = pf.id_cli_fa_da INNER JOIN  
        dbo.cat_pro AS p with (nolock) ON dd.id_pro = p.id_pro INNER JOIN  
        dbo.cat_gastos AS g with (nolock) ON dd.id_ent = g.id_gto INNER JOIN  
        dbo.fis_cfg_rel AS r with (nolock) ON dd.id_fis_rel = r.id_fis_rel INNER JOIN  
        dbo.fis_cfg AS f with (nolock) ON r.id_fis_cfg = f.id_fis_cfg INNER JOIN  
        dbo.fis_cfg_det AS fd with (nolock) ON f.id_fis_cfg = fd.id_fis_cfg INNER JOIN  
        dbo.sis_tip AS s with (nolock) ON fd.id_tip_impto = s.id_tip LEFT OUTER JOIN  
        dbo.ctb_pol_det AS pd with (nolock) ON dd.id_cxp_doc_det = pd.id_part AND e.id_tip_doc = pd.id_tip_doc AND e.id_cxp_doc = pd.id_doc AND pd.id_tip_rub <> 520 LEFT OUTER JOIN  
        dbo.ctb_cta AS c with (nolock) ON pd.id_cta = c.id_cta  
 WHERE     (e.id_tip_doc IN (150)) AND (s.tipo = 25) AND (dd.id_cli_a_cta_de = 0) AND e.status in (1,2) AND isnull(c.c_no_ded,0)=0--AND c.c_no_ded=0  
 AND s.codigo=@cod_tip_impto
 
	INSERT INTO @tabla
	SELECT     e.id_tip_doc, e.id_bco_doc AS id_doc, dd.id_bco_doc_det AS id_doc_det, e.num_doc, dd.fecha, '' AS serie, dd.num_doc_ref AS no_fact, pf.id_cli_fa_da, pf.clave, 
						  pf.nom1, pf.nom2, pf.rfc, e.id_cpt, CASE WHEN e.id_cpt > 0 THEN cp.des ELSE '' END AS cpt, dd.id_pro, 
						  CASE WHEN dd.id_pro > 0 THEN p.codigo ELSE '' END AS cod_pro, CASE WHEN dd.id_pro > 0 THEN p.des ELSE '' END AS des_pro, dd.id_ent, 
						  CASE WHEN dd.id_ent > 0 THEN g.clave ELSE '' END AS cod_ent, CASE WHEN dd.id_ent > 0 THEN g.des ELSE '' END AS des_ent, e.monto_bse AS mto_bse_doc, 
						  0 AS imptos_bse_doc, e.monto_bse AS total_bse_doc, dd.importe_bse AS mto_bse, dd.imptos_bse, dd.total_bse, dd.id_impto, ptg_acu_vta, 
						  ptg_acu_com, s.id_tip AS id_tip_impto, s.codigo AS cod_tip_impto, s.des AS des_tip_impto, 2 AS tip_cli_prov, c.id_cta, c.num_cta, c.nom, 49 AS id_tbl, 
						  e.id_mda, pd.id_cen_cto
	FROM         dbo.bco_doc_det AS dd with (nolock) INNER JOIN
						  dbo.bco_doc AS e with (nolock) ON e.id_bco_doc = dd.id_bco_doc INNER JOIN
						  dbo.cat_doctos AS d with (nolock) ON e.id_tip_doc = d.id_doc INNER JOIN
						  dbo.sis_conceptos AS cp with (nolock) ON e.id_cpt = cp.id_cpt INNER JOIN
						  dbo.cat_cli_fa_da AS pf with (nolock) ON dd.id_cli_prov = pf.id_cli_fa_da INNER JOIN
						  dbo.cat_pro AS p with (nolock) ON dd.id_pro = p.id_pro INNER JOIN
						  dbo.cat_gastos AS g with (nolock) ON dd.id_ent = g.id_gto INNER JOIN
						  dbo.fis_cfg_rel AS r with (nolock) ON dd.id_fis_rel = r.id_fis_rel INNER JOIN
						  dbo.fis_cfg AS f with (nolock) ON r.id_fis_cfg = f.id_fis_cfg INNER JOIN
						  dbo.fis_cfg_det AS fd with (nolock) ON f.id_fis_cfg = fd.id_fis_cfg INNER JOIN
						  dbo.sis_tip AS s with (nolock) ON fd.id_tip_impto = s.id_tip LEFT OUTER JOIN
						  dbo.ctb_pol_det AS pd with (nolock) ON dd.id_bco_doc_det = pd.id_part AND e.id_tip_doc = pd.id_tip_doc AND e.id_bco_doc = pd.id_doc AND pd.id_tip_rub <> 520 LEFT OUTER JOIN
						  dbo.ctb_cta AS c with (nolock) ON pd.id_cta = c.id_cta
	WHERE     (d.id_doc_pad IN (100)) AND (s.tipo = 25) AND (dd.id_cli_a_cta_de = 0) AND e.status in (1,2) AND c.c_no_ded=0
	 AND s.codigo=@cod_tip_impto
 
	INSERT INTO @tabla 
	-- Se agrega las Compras Directas AGT 23-01-2009
	SELECT     e.id_tip_doc, e.id_compra AS id_doc, dd.id_part AS id_doc_det, e.num_doc, e.fec_doc, '' AS serie, 
			   e.num_doc_rec AS no_fact, pf.id_cli_fa_da, pf.clave, pf.nom1, pf.nom2, 
			  pf.rfc, e.id_cpt, 
			  CASE WHEN e.id_cpt > 0 THEN cp.des ELSE '' END AS cpt, dd.id_pro, 
			  CASE WHEN dd.id_pro > 0 THEN p.codigo ELSE '' END AS cod_pro, 
			  CASE WHEN dd.id_pro > 0 THEN p.des ELSE '' END AS des_pro,
			  0 AS id_ent,'' AS cod_ent, '' AS des_ent,
						  e.imp_s_dcto_bse AS mto_bse_doc, 
						  e.impto_bse AS imptos_bse_doc,
						  e.total_bse AS total_bse_doc, 
						  dd.importe_bse AS mto_bse, 
						  dd.imptos_bse, 
						  dd.total_bse, dd.id_impto, fd.ptg_acu_vta, fd.ptg_acu_com, s.id_tip AS id_tip_impto, s.codigo AS cod_tip_impto, 
						  s.des AS des_tip_impto, 
						  2 AS tip_cli_prov, 
						  c.id_cta, c.num_cta,c.nom,
						  102 AS id_tbl, 
						  e.id_mda, pd.id_cen_cto
	FROM         dbo.com_mov_part AS dd with (nolock) INNER JOIN
						  dbo.com_mov_doc AS e with (nolock) ON e.id_compra  = dd.id_compra  INNER JOIN
						  dbo.cat_doctos AS d with (nolock) ON e.id_tip_doc = d.id_doc INNER JOIN
						  dbo.sis_conceptos AS cp with (nolock) ON e.id_cpt = cp.id_cpt INNER JOIN
						  dbo.cat_cli_fa_da AS pf with (nolock) ON e.id_prov_fis = pf.id_cli_fa_da INNER JOIN
						  dbo.cat_pro AS p with (nolock) ON dd.id_pro = p.id_pro INNER JOIN
						  dbo.fis_cfg_rel AS r with (nolock) ON dd.id_fis_rel = r.id_fis_rel INNER JOIN
						  dbo.fis_cfg AS f with (nolock) ON r.id_fis_cfg = f.id_fis_cfg INNER JOIN
						  dbo.fis_cfg_det AS fd with (nolock) ON f.id_fis_cfg = fd.id_fis_cfg INNER JOIN
						  dbo.sis_tip AS s with (nolock) ON fd.id_tip_impto = s.id_tip LEFT OUTER JOIN
						  dbo.ctb_pol_det AS pd with (nolock) ON dd.id_part = pd.id_part AND e.id_tip_doc = pd.id_tip_doc AND e.id_compra= pd.id_doc AND pd.id_tip_rub <> 520 LEFT OUTER JOIN
						  dbo.ctb_cta AS c with (nolock) ON pd.id_cta = c.id_cta
	WHERE     (d.id_doc_pad IN (84)) AND (s.tipo = 25) --AND (dd.id_cli_a_cta_de = 0) 
	AND e.status in (1,2) AND c.c_no_ded=0
	 AND s.codigo=@cod_tip_impto
 
	INSERT INTO @tablaGp
	SELECT
	id_tip_doc, id_doc, id_doc_det, num_doc, fec_doc, serie, no_fact, id_cli_fa_da, clave, nom1, nom2, rfc, cod_pro, des_pro, mto_bse_doc,
			 imptos_bse_doc, total_bse_doc, mto_bse, imptos_bse, total_bse, id_impto, ptg_acu_com
	FROM @tabla t 
	GROUP BY id_tip_doc, id_doc, id_doc_det, num_doc, fec_doc, serie, no_fact, id_cli_fa_da, clave, nom1, nom2, rfc, cod_pro, des_pro, mto_bse_doc,
			 imptos_bse_doc, total_bse_doc, mto_bse, imptos_bse, total_bse, id_impto, ptg_acu_com
 
 RETURN
END
GO

