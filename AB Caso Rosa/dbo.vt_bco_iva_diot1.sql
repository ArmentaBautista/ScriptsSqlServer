

create or alter function dbo.fnBCOivaDiot(
@pFechaInicio date,
@pFechaFin date)
RETURNS TABLE
AS
RETURN 
(  
	SELECT     
	dbo.bco_iva_aux.id_tip_doc AS id_tip_doc_apl,
	dbo.bco_iva_aux.id_doc AS id_doc_apl,
	dbo.sis_imptos.id_doc_part,
	dbo.bco_iva_aux.ptg_apl,
	dbo.bco_aux.id_tip_doc,
	dbo.bco_aux.id_doc,
	dbo.bco_aux.num_doc,
	dbo.sis_imptos.dcto_glb,
	dbo.bco_iva_aux.aplicado,
	dbo.bco_iva_aux.total_bse AS total_bse_doc_apl,
	dbo.bco_iva_aux.tc AS tc_doc_apl
	FROM dbo.bco_aux with (nolock) 
	INNER JOIN dbo.bco_rel_iva with (nolock) 
		ON dbo.bco_aux.id_rel_bco_iva = dbo.bco_rel_iva.id_rel_bco_iva 
	INNER JOIN dbo.bco_iva_aux with (nolock) 
		ON dbo.bco_rel_iva.id_rel_bco_iva = dbo.bco_iva_aux.id_rel_bco_iva 
	INNER JOIN dbo.sis_imptos with (nolock) 
		ON dbo.bco_iva_aux.id_rel_imp_doc = dbo.sis_imptos.id_rel_imp_doc 
	LEFT JOIN (
				SELECT		
				id_rcn_iva, id_sis_imp
				FROM        dbo.bco_iva_det with (nolock)  
				GROUP BY	
				id_rcn_iva, id_sis_imp
	) vt_bco_iva_det_distinct on vt_bco_iva_det_distinct.id_sis_imp = sis_imptos.id_sis_imp 
	left JOIN dbo.bco_iva AS bco_iva with (nolock) 
		on bco_iva.id_rcn_iva = vt_bco_iva_det_distinct.id_rcn_iva
	where --id_conc<>0
	--and 
	fec_apl between '20230701' and '20230731'	 
	and
	(dbo.bco_aux.c_cnl = 0) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.mto_imp_bse <> 0) AND (dbo.bco_aux.c_conc = 1) OR  
                      (dbo.bco_aux.c_cnl = 1) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.mto_imp_bse <> 0) AND (dbo.bco_aux.c_conc = 1) AND (dbo.bco_aux.c_sal_ini = 1) OR  
                      (dbo.sis_imptos.c_exe = 1) AND (dbo.bco_iva_aux.c_cnl = 0)AND (ISNULL(bco_iva.id_rcn_iva, 1) = 1) OR  
                      (dbo.bco_aux.c_cnl = 0) AND (dbo.bco_aux.id_rel_bco_iva > 0) AND (dbo.bco_iva_aux.id_rel_imp_doc > 0) AND (dbo.sis_imptos.c_iva = 1) AND   
                      (dbo.bco_iva_aux.c_cnl = 0) AND (dbo.sis_imptos.id_cod_imp =3)  AND (dbo.bco_aux.c_conc = 1)
	
)  
GO

	