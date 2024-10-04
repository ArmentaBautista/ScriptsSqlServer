
declare @FINI as date='20230701'
declare @FFIN as date='20230731'

select id_tip_doc_apl
			 , id_doc_apl
			 , id_doc_part
			 , ptg_apl
			 , id_tip_doc
			 , id_doc
			 , num_doc
			 , dcto_glb
			 , "aplicado"       = sum(aplicado)
			 , "totals_doc_apl" = sum(   total_bse_doc_apl / case
																 when tc_doc_apl = 0 then
																	 1
																 else
																	 tc_doc_apl
															 end
									 )
				from dbo.vt_bco_iva_diot with (nolock)
				where fec_apl
					  between @FINI and @FFIN
					  and id_conc <> 0
				group by id_tip_doc_apl
					   , id_doc_apl
					   , id_doc_part
					   , ptg_apl
					   , id_tip_doc
					   , id_doc
					   , num_doc
					   , dcto_glb