

SELECT 
			 id_tip_doc, id_doc, id_doc_det, num_doc, fec_doc, serie, no_fact, id_cli_fa_da, clave, nom1, nom2, rfc, cod_pro, des_pro, mto_bse_doc,
			 imptos_bse_doc, total_bse_doc, mto_bse, imptos_bse, total_bse, id_impto, ptg_acu_com
		   FROM dbo.vt_fis_ded WITH(NOLOCK)
		   WHERE cod_tip_impto='IVA'
		   GROUP BY id_tip_doc, id_doc, id_doc_det, num_doc, fec_doc, serie, no_fact, id_cli_fa_da, clave, nom1, nom2, rfc, cod_pro, des_pro, mto_bse_doc,
			 imptos_bse_doc, total_bse_doc, mto_bse, imptos_bse, total_bse, id_impto, ptg_acu_com


SELECT
id_tip_doc, id_doc, id_doc_det, num_doc, fec_doc, serie, no_fact, id_cli_fa_da, clave, nom1, nom2, rfc, cod_pro, des_pro, mto_bse_doc,
			 imptos_bse_doc, total_bse_doc, mto_bse, imptos_bse, total_bse, id_impto, ptg_acu_com
FROM dbo.ft_fis_ded1('IVA') f


