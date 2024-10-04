

SELECT    dbo.sis_tip.codigo AS cod_tip_doc, dbo.sis_int.num_sol AS Numero, dbo.sis_int.adu, dbo.sis_int.pat, dbo.sis_cod_svr.codigo AS cod_srv_codigo, 
                      dbo.sis_int.fec_ope AS Fecha, dbo.cat_clientes.clave AS Cliente_Clave, dbo.cat_pro.codigo AS Pro_codigo, dbo.cat_almac.descripcion AS alm_desc, 
                      dbo.vt_sis_ref.ref AS sis_ref_ref, dbo.sis_int.cant, dbo.sis_int.cant AS Pendiente, dbo.sis_int.cant AS Por_Facturar, dbo.sis_int.precio AS precio_simptos, 
                      dbo.sis_int.importe AS importe_simptos, '' AS fecha_venc, CASE WHEN dbo.sis_int.id_cpt = 0 THEN '' ELSE dbo.sis_conceptos.des END AS des_concepto, '' AS Vendedor,dbo.cat_cnd.des AS des_cnd, dbo.cat_pro.des AS pro_des, 
                      dbo.sis_cod_svr.des AS cod_srv_desc, dbo.ctb_cen_cto.des AS cen_cto_des, '' AS fec_prom, dbo.sis_int.fec_req, dbo.sis_int.id_ope AS id_fac_det, 
                      dbo.sis_int.id_doc_apl AS id_fac, 0 AS tipo, CASE tipcliprov WHEN 1 THEN cat_cli_fa_da.nom1 ELSE ' ' END AS Facturar_A, 
                      CASE tipcliprov WHEN 1 THEN id_cli_fa ELSE 0 END AS id_cli_fa, CASE tipcliprov WHEN 1 THEN dbo.cat_cli_fa_da.clave ELSE ' ' END AS FA_Clave, 
                      dbo.cat_clientes.nom1 AS cliente_nombre, dbo.sis_int.id_cli, dbo.sis_int.id_tip AS id_tipo_doc, dbo.sis_int.status, dbo.ctb_cen_cto.codigo AS cod_cen_cto, 
                      dbo.sis_int.id_cli_cta_de, '0' AS idFactPed, dbo.sis_int.id_int, sis_int.id_cpt, 0 AS id_vend,sis_int.id_cnd, dbo.cat_almac.codigo AS id_almac, dbo.sis_int.id_cod_srv, 
                      dbo.ctb_cen_cto.id_cen_cto, dbo.sis_int.id_ref, dbo.cat_pro.id_clas1, dbo.sis_int.campo1, dbo.sis_int.campo2, dbo.sis_int.campo3, dbo.sis_int.campo4, 
                      dbo.sis_int.campo5, dbo.sis_int.campo6, dbo.sis_int.campo7, dbo.sis_int.campo8, dbo.sis_int.campo9, dbo.sis_int.campo10, dbo.mon_monedas.codigo AS mda_cod, 
                      CASE tipcliprov WHEN 1 THEN dbo.cat_cli_fa_da.dir1 + + dbo.cat_cli_fa_da.ciu ELSE ' ' END AS DirCiu_FA, dbo.cat_clientes.id_rel_fa_da, 
                      dbo.sis_int.id_cen_cto AS int_id_cen_cto, ctb_cen_cto_1.codigo AS int_cod_cen_cto, ctb_cen_cto_1.des AS int_des_cen_cto, dbo.sis_int.ref_ext, dbo.sis_int.id_impto, 
                      dbo.cat_impto.des AS des_impto, dbo.sis_notas.id_nota, dbo.sis_int.precio_ext, 0 AS Facturado, dbo.sis_int.Campo11, dbo.sis_int.Campo12, dbo.sis_int.Campo13, 
                      dbo.sis_int.Campo14, dbo.sis_int.Campo15, dbo.sis_int.Campo16, dbo.sis_int.Campo17, dbo.sis_int.Campo18, dbo.sis_int.Campo19, dbo.sis_int.Campo20, 
                      dbo.sis_int.Campo21, dbo.sis_int.Campo22, dbo.sis_int.Campo23, dbo.sis_int.Campo24, dbo.sis_int.Campo25, dbo.sis_int.Campo26, dbo.sis_int.Campo27, 
                      dbo.sis_int.Campo28, dbo.sis_int.Campo29, dbo.sis_int.Campo30, dbo.sis_int.Campo31, dbo.sis_int.Campo32, dbo.sis_int.Campo33, dbo.sis_int.Campo34, 
                      dbo.sis_int.Campo35, dbo.sis_int.Campo36, dbo.sis_int.Campo37, dbo.sis_int.Campo38, dbo.sis_int.Campo39, dbo.sis_int.Campo40, dbo.sis_int.Id_Nota2, 
                      dbo.sis_int.Id_Nota3, dbo.sis_int.id_sis, dbo.sis_int.id_ope, dbo.cat_pro.id_pro, dbo.vt_sis_ref.id_rel_ref_det, dbo.sis_cod_svr.id_prov, dbo.sis_int.id_ref_det, 
                      dbo.sis_int.suc, dbo.sis_tip.codigo AS codigo_tip_doc, dbo.sis_int.id_ope_ext, dbo.sis_int.serie, dbo.sis_int.id_part_alm_sir, dbo.sis_int.dias_alm_sir, 
                      dbo.sis_int.dias_lib_alm_sir, dbo.sis_int.dias_dcto_alm_sir, dbo.sis_int.fec_corte_alm_sir, dbo.sis_int.id_almje_gral, dbo.sis_int.id_almje_esp, '' AS des_hon, 
                      dbo.sis_int.num_doc_apl, mon_monedas.oper, dbo.sis_int.tc, dbo.sis_int.id_com, isnull(vt_cat_cli_fa_cta.codigo,'') as codigo, isnull(vt_cat_cli_fa_cta.des,'') as des_met, isnull(vt_cat_cli_fa_cta.id_cli_fa_cta,0) as idiscta,
					  dbo.cat_cli_fa_da.id_tip_uso, st.codigo AS uso_cod, st.des AS uso_des, cat_cli_fa_da.tip_cli
FROM         dbo.sis_int WITH (NOLOCK) INNER JOIN
                      dbo.cat_clientes WITH (NOLOCK) ON dbo.sis_int.id_cli = dbo.cat_clientes.id_cli INNER JOIN
                      dbo.cat_pro WITH (NOLOCK) ON dbo.sis_int.id_pro = dbo.cat_pro.id_pro INNER JOIN
                      dbo.sis_cod_svr WITH (NOLOCK) ON dbo.sis_int.id_cod_srv = dbo.sis_cod_svr.id_cod_svr INNER JOIN
                      dbo.ctb_cen_cto WITH (NOLOCK) ON dbo.cat_pro.id_cen_cto = dbo.ctb_cen_cto.id_cen_cto INNER JOIN
                      dbo.cat_almac WITH (NOLOCK) ON dbo.sis_int.id_alm = dbo.cat_almac.id_almac INNER JOIN
                      dbo.vt_sis_ref WITH (NOLOCK) ON dbo.sis_int.id_ref = dbo.vt_sis_ref.id_ref INNER JOIN
                      dbo.mon_monedas WITH (NOLOCK) ON dbo.sis_int.id_mda_cli = dbo.mon_monedas.id_moneda INNER JOIN
                      dbo.ctb_cen_cto AS ctb_cen_cto_1 WITH (NOLOCK) ON dbo.sis_int.id_cen_cto = ctb_cen_cto_1.id_cen_cto INNER JOIN
                      dbo.cat_impto WITH (NOLOCK) ON dbo.sis_int.id_impto = dbo.cat_impto.id_impto INNER JOIN
                      dbo.sis_notas WITH (NOLOCK) ON dbo.sis_int.id_nota = dbo.sis_notas.id_nota INNER JOIN
                      dbo.sis_tip WITH (NOLOCK) ON dbo.sis_int.id_tip = dbo.sis_tip.id_tip LEFT OUTER JOIN
					  dbo.cat_cnd with (nolock) ON dbo.sis_int.id_cnd = dbo.cat_cnd.id_cnd INNER JOIN
                      dbo.cat_cli_fa_da WITH (NOLOCK) ON dbo.sis_int.id_cli_fa = dbo.cat_cli_fa_da.id_cli_fa_da
					  INNER JOIN dbo.sis_conceptos WITH (nolock) ON dbo.sis_conceptos.id_cpt = dbo.sis_int.id_cpt
					  left join vt_cat_cli_fa_cta with (nolock) on vt_cat_cli_fa_cta.status=1 AND vt_cat_cli_fa_cta.id_cli_fa_da=id_cli_fa And vt_cat_cli_fa_cta.status=1 And vt_cat_cli_fa_cta.c_def =1
					  INNER JOIN sis_tip st WITH (nolock) ON st.id_tip = dbo.cat_cli_fa_da.id_tip_uso
WHERE     (dbo.sis_int.id_tip IN (8202, 8215)) AND (dbo.sis_int.num_sol > 0) 




