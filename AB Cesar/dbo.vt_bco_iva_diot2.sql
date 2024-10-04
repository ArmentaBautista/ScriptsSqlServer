
--ALTER VIEW [dbo].[vt_bco_iva_diot]  
--AS  
SELECT     TOP (100) PERCENT dbo.bco_aux.id_usr, dbo.bco_aux.id_cta, dbo.bco_aux.id_cpt, dbo.bco_aux.id_tip_doc, dbo.bco_aux.id_doc, dbo.bco_aux.num_doc,   
                      dbo.bco_aux.num_chq, dbo.bco_aux.num_doc_cli, dbo.bco_aux.fec_doc, dbo.bco_aux.tipo, dbo.bco_aux.ref, dbo.bco_aux.cargo, dbo.bco_aux.abono,   
                      dbo.bco_aux.id_mda, dbo.bco_aux.tc, dbo.bco_aux.oper, dbo.bco_aux.cargo_bse, dbo.bco_aux.abono_bse, dbo.bco_aux.id_conc, dbo.bco_aux.c_chq,   
                      dbo.bco_aux.id_cli, dbo.bco_aux.id_prov, dbo.bco_iva_aux.id_ctl_iva, dbo.bco_iva_aux.id_tip_doc AS id_tip_doc_apl, dbo.bco_iva_aux.id_doc AS id_doc_apl,   
                      dbo.bco_iva_aux.num_doc AS num_doc_apl, dbo.bco_iva_aux.fec_doc AS fec_doc_apl, dbo.bco_iva_aux.importe AS importe_doc_apl,   
                      dbo.bco_iva_aux.imptos AS imptos_doc_apl, dbo.bco_iva_aux.iva AS ivas_doc_apl, dbo.bco_iva_aux.total AS totals_doc_apl,   
                      dbo.bco_iva_aux.id_mda AS id_mda_doc_apl, dbo.bco_iva_aux.oper AS oper_doc_apl, dbo.bco_iva_aux.tc AS tc_doc_apl,   
                      dbo.bco_iva_aux.importe_bse AS importe_bse_doc_apl, dbo.bco_iva_aux.imptos_bse AS imptos_bse_doc_apl, dbo.bco_iva_aux.iva_bse AS iva_bse_doc_apl,   
                      dbo.bco_iva_aux.total_bse AS total_bse_doc_apl, dbo.bco_iva_aux.id_pag, dbo.bco_iva_aux.id_pag_det, dbo.bco_iva_aux.id_cobro, dbo.bco_iva_aux.id_cobro_det,   
                      dbo.bco_iva_aux.fec_apl, dbo.bco_iva_aux.aplicado, dbo.bco_iva_aux.tc_pag, dbo.bco_iva_aux.oper_pag, dbo.bco_iva_aux.aplicado_bse, dbo.bco_iva_aux.iva_apl,   
                      dbo.bco_iva_aux.iva_apl_bse, dbo.bco_iva_aux.ptg_apl, dbo.bco_iva_aux.tip_iva, dbo.sis_imptos.id_doc_part, dbo.sis_imptos.id_impto, dbo.sis_imptos.id_cod_imp,   
                      dbo.sis_imptos.des, dbo.sis_imptos.tasa, dbo.sis_imptos.mto_base, dbo.sis_imptos.mto_imp, dbo.sis_imptos.mto_base_bse, dbo.sis_imptos.mto_imp_bse,   
                      dbo.sis_imptos.id_cta AS id_ctb_cta, dbo.sis_imptos.dcto_glb, dbo.sis_imptos.mto_imp_s_dcto, dbo.sis_imptos.mto_base_s_dcto, dbo.sis_imptos.c_mod_imptos,   
                      ISNULL(dbo.vt_bco_iva_det_distinct.iva_apl_rcn, 0) AS iva_apl_part, dbo.sis_imptos.iva_sdo, dbo.bco_aux.id_rel_bco_iva, dbo.bco_iva_aux.id_rel_imp_doc,   
                      dbo.bco_aux.fec_conc, CASE WHEN cat_cli_fa_da.tipcliprov = 1 THEN cat_cli_fa_da.clave ELSE '' END AS clave_cli,   
                      CASE WHEN cat_cli_fa_da.tipcliprov = 1 THEN cat_cli_fa_da.nom1 ELSE '' END AS nom1_cli,   
                      CASE WHEN cat_cli_fa_da.tipcliprov = 2 THEN cat_cli_fa_da.clave ELSE '' END AS clave_prv,   
                      CASE WHEN cat_cli_fa_da.tipcliprov = 2 THEN cat_cli_fa_da.nom1 ELSE '' END AS nom1_prv, dbo.cfg_modulos.des AS des_mod,   
                      dbo.cat_doctos.descripcion AS tipo_documento, dbo.bco_tip_trn.des AS tipo_transaccion, dbo.sis_conceptos.des AS Concepto, dbo.bco_aux.id_bco_aux,   
                      dbo.bco_aux.fec_reg, cat_doctos_1.descripcion AS tip_doc_apl, dbo.sis_imptos.c_afe_ctb, dbo.ctb_cta.num_cta, dbo.ctb_cta.nom, dbo.sis_imptos.id_sis_imp,   
                      cat_doctos_2.c_uso_cli, cat_doctos_2.c_uso_prov, ISNULL(dbo.vt_bco_iva_det_distinct.id_rcn_iva, 0) AS id_rcn_iva, dbo.bco_iva_aux.id_bco_iva_aux,   
                      dbo.bco_aux.id_suc, dbo.sis_imptos.c_iva, dbo.sis_imptos.c_ret, dbo.sis_imptos.c_exe, dbo.sis_imptos.mto_pag_ret, dbo.sis_imptos.mto_acr_ret,   
                      dbo.sis_imptos.fec_pgo, dbo.sis_imptos.id_cli_fa, dbo.sis_imptos.no_fact  
FROM         dbo.bco_aux with (nolock) INNER JOIN  
                      dbo.bco_rel_iva with (nolock) ON dbo.bco_aux.id_rel_bco_iva = dbo.bco_rel_iva.id_rel_bco_iva INNER JOIN  
                      dbo.bco_iva_aux with (nolock) ON dbo.bco_rel_iva.id_rel_bco_iva = dbo.bco_iva_aux.id_rel_bco_iva INNER JOIN  
                      dbo.sis_imptos with (nolock) ON dbo.bco_iva_aux.id_rel_imp_doc = dbo.sis_imptos.id_rel_imp_doc INNER JOIN  
                      dbo.cfg_modulos with (nolock) ON dbo.bco_aux.id_mod = dbo.cfg_modulos.id_mod INNER JOIN  
                      dbo.bco_tip_trn with (nolock) ON dbo.bco_aux.id_tip_trn = dbo.bco_tip_trn.id_tip_trn INNER JOIN  
                      dbo.sis_conceptos with (nolock) ON dbo.bco_aux.id_cpt = dbo.sis_conceptos.id_cpt INNER JOIN  
                      dbo.cat_doctos with (nolock) ON dbo.bco_aux.id_tip_doc = dbo.cat_doctos.id_doc INNER JOIN  
                      dbo.cat_doctos AS cat_doctos_1 with (nolock) ON dbo.bco_iva_aux.id_tip_doc = cat_doctos_1.id_doc INNER JOIN  
                      dbo.ctb_cta with (nolock) ON dbo.sis_imptos.id_cta = dbo.ctb_cta.id_cta INNER JOIN  
                      dbo.cat_doctos AS cat_doctos_2 with (nolock) ON dbo.sis_imptos.id_tip_doc = cat_doctos_2.id_doc INNER JOIN  
                      dbo.cat_cli_fa_da with (nolock) ON dbo.sis_imptos.id_cli_fa = dbo.cat_cli_fa_da.id_cli_fa_da LEFT OUTER JOIN  
                      dbo.vt_bco_iva_det_distinct with (nolock) ON dbo.sis_imptos.id_sis_imp = dbo.vt_bco_iva_det_distinct.id_sis_imp AND   
                      dbo.bco_iva_aux.id_bco_iva_aux = dbo.vt_bco_iva_det_distinct.id_bco_iva_aux LEFT OUTER JOIN  
                      dbo.bco_iva AS bco_iva with (nolock) ON bco_iva.id_rcn_iva = dbo.vt_bco_iva_det_distinct.id_rcn_iva  
WHERE    (dbo.bco_aux.c_cnl = 0) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.mto_imp_bse <> 0) AND (dbo.bco_aux.c_conc = 1) OR  
                      (dbo.bco_aux.c_cnl = 1) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.mto_imp_bse <> 0) AND (dbo.bco_aux.c_conc = 1) AND (dbo.bco_aux.c_sal_ini = 1) OR  
                      (dbo.sis_imptos.c_exe = 1) AND (dbo.bco_iva_aux.c_cnl = 0)AND (ISNULL(bco_iva.id_rcn_iva, 1) = 1) OR  
                      (dbo.bco_aux.c_cnl = 0) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.id_cod_imp =3)  AND (dbo.bco_aux.c_conc = 1)
ORDER BY dbo.bco_aux.id_tip_doc, dbo.bco_aux.id_doc, dbo.bco_aux.num_doc  
  
GO

