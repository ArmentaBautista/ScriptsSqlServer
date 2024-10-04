IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_dveVt_ctb_pre2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_dveVt_ctb_pre2]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION fn_dveVt_ctb_pre2
(
    @id_eje AS VARCHAR(MAX),
	@id_rev as VARCHAR(MAX)
)
RETURNS table 
AS
return(
		SELECT  p.num_cta +' - ' + p.nom as pad,m.codigo as mon,u.codigo as udm,case st.des when 'VENTAS' then '0' when 'COSTO DE LO VENDIDO' then '1'  when 'GASTOS' then '2' when 'GASTOS FINANCIEROS' then '3' 
				when 'IMPUESTOS' then '4' else '9' end +' '+ st.des as tipo,st.des as tipo1,
				pre.id_pre, pre.rev, pre.id_per, pre.id_cta, pre.id_emp, pre.id_cen_cto, pre.mto,   
                pre.c_act, pre.id_usr, pre.fec_reg, pre.status, cpe.id_eje, cpe.año, cpe.num_per,   
                cpe.per, cpe.status AS status_per, cta.num_cta, cta.nom, cta.status AS status_cc,   
                cc.codigo AS cod_cc, cc.des AS des_cc, cc.status AS status_cta, pre.mto_eje, pre.cmt,   
                pre.id_tip_obj, pre.id_obj, s.des AS des_tip_obj, ISNULL(dbo.sis_cod_svr.codigo, ' ') AS Codigo_Cod_Svr,   
                ISNULL(dbo.sis_cod_svr.des, ' ') AS des_Cod_Svr, ISNULL(r.ref, ' ') AS ref_ref, ISNULL(r.ref, ' ') AS des_ref,   
                ISNULL(pro.codigo, N' ') AS codigo_pro, ISNULL(pro.des, N' ') AS des_pro,   
				ISNULL(cli.clave, N' ') AS codigo_cli, ISNULL(cli.nom2, N' ') AS des_cli,   
				ISNULL(prov.clave, N' ') AS codigo_prov, ISNULL(prov.nom2, N' ') AS des_prov,   
                ISNULL(e.nom + ' ' + e.ap_pat + ' ' + e.ap_mat, ' ') AS nom_emp,
				ISNULL(depto.des,'') AS des_depto,
				ISNULL(clas.des,'') AS des_clas,
				us.usr,cta.id_tip,
				ISNULL(corp.clave,'') AS codigo_corp,ISNULL(corp.nom1, N' ') AS des_corp,   
				ISNULL(suc.suc,'') AS codigo_suc,ISNULL(suc.nom, N' ') AS des_suc,
				ISNULL(clas1.Clave,'') AS codigo_clas1,ISNULL(clas1.des, N' ') AS des_clas1,
				ISNULL(clas2.Clave,'') AS codigo_clas2,ISNULL(clas2.des, N' ') AS des_clas2,
				ISNULL(clas3.Clave,'') AS codigo_clas3,ISNULL(clas3.des, N' ') AS des_clas3
FROM         dbo.ctb_pre pre with (nolock) INNER JOIN  		
                dbo.ctb_cta cta with (nolock) ON pre.id_cta = cta.id_cta  and pre.rev=@id_rev INNER JOIN 
				dbo.sis_tip st with (nolock) ON st.id_tip = cta.id_tip LEFT OUTER JOIN  
				dbo.ctb_cta p with (nolock) ON cta.id_cta_pad = p.id_cta INNER JOIN 
				dbo.mon_monedas m with (nolock) ON cta.id_mda = m.id_moneda INNER JOIN 
				dbo.cat_udm u with (nolock) ON cta.id_udm = u.id_udm INNER JOIN 
                dbo.ctb_cen_cto cc with (nolock) ON pre.id_cen_cto = cc.id_cen_cto INNER JOIN  
                dbo.ctb_per_eje cpe with (nolock) ON pre.id_per = cpe.id_per and cpe.id_eje=@id_eje INNER JOIN  
                dbo.cat_usr us with (nolock) ON pre.id_usr = us.id_usr LEFT OUTER JOIN  
                dbo.sis_tip s with (nolock) ON pre.id_tip_obj = s.id_tip LEFT OUTER JOIN  
                dbo.sis_ref r with (nolock) ON pre.id_obj = r.id_ref LEFT OUTER JOIN  
                dbo.cat_emp e with (nolock) ON pre.id_obj = e.id_emp LEFT OUTER JOIN  
                dbo.cat_pro pro with (nolock) ON pre.id_obj = pro.id_pro LEFT OUTER JOIN  
				dbo.cat_clientes cli with (nolock) ON pre.id_obj = cli.id_cli LEFT OUTER JOIN  
				dbo.cat_prov prov with (nolock) ON pre.id_obj = prov.id_cli LEFT OUTER JOIN  					  
				dbo.cat_depto depto with (nolock) ON pre.id_obj = depto.id_depto LEFT OUTER JOIN 
				dbo.cat_clas clas with (nolock) ON pre.id_obj = clas.id_clas and id_clas_gral in (2) LEFT OUTER JOIN 
				dbo.sis_corp corp with (nolock) ON pre.id_obj = corp.id_crp  LEFT OUTER JOIN 
				dbo.mcp_suc suc with (nolock) ON pre.id_obj = suc.id_suc  LEFT OUTER JOIN 
				dbo.vt_clas clas1 with (nolock) ON pre.id_obj = clas1.id_clas and clas1.id_clas>0 AND clas1.status=1 AND clas1.tipoobj IN (1,3) AND clas1.id_clas_gral=2   LEFT OUTER JOIN 
				dbo.vt_clas clas2 with (nolock) ON pre.id_obj = clas2.id_clas and clas2.id_clas>0 AND clas2.status=1 AND clas2.tipoobj IN (2,3) AND clas2.id_clas_gral=4   LEFT OUTER JOIN 
				dbo.vt_clas clas3 with (nolock) ON pre.id_obj = clas3.id_clas and clas3.id_clas>0 AND clas3.status=1 AND clas3.id_clas_gral=6 LEFT OUTER JOIN 
                dbo.sis_cod_svr ON pre.id_obj = dbo.sis_cod_svr.id_cod_svr  
WHERE     (pre.id_pre > 0) 
)
GO
