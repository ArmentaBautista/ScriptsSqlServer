
use [1G_KANZ]
go

declare @FechaIncio as date='20230701'
declare @FechaFin as date='20230731'

--select * from fcn_erv_diot(@FechaIncio,@FechaFin)


--select * from dbo.fcn_bco_doc_apl_tmp(@FechaIncio,@FechaFin)

select * from dbo.fnBCOivaDiot(@FechaIncio,@FechaFin)

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
				from dbo.fnBCOivaDiot(@FechaIncio,@FechaFin)
				group by id_tip_doc_apl
					   , id_doc_apl
					   , id_doc_part
					   , ptg_apl
					   , id_tip_doc
					   , id_doc
					   , num_doc
					   , dcto_glb



