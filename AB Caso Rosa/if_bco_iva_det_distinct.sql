
/* JCA.15/4/2024.13:18 
Nota: Función de ejemplo para la sustitución de la vista vt_bco_iva_det_distinct,
Debe revisarse cuales serían los campos correctos para el filtrado
*/

CREATE OR ALTER FUNCTION dbo.if_bco_iva_det_distinct(
@Inicio AS DATE='20230101',
@Fin AS DATE='20231231'
)
RETURNS TABLE
AS
RETURN (
    SELECT		id_rcn_iva, ba.id_bco_aux, id_sis_imp, tip_iva, SUM(iva_apl) AS iva_apl_rcn, iva_apl, id_bco_iva_aux,c_acreditado, cfdi_i, cfdi_p, cfdi_e, c_acreditado_bit , met_pag,uuid_crp 
	FROM        dbo.bco_iva_det bid with (nolock)  
	INNER JOIN dbo.bco_aux ba  WITH(NOLOCK) 
		ON ba.id_bco_aux = bid.id_bco_aux
			AND ba.fec_doc BETWEEN @Inicio AND @Fin
	GROUP BY	id_rcn_iva, ba.id_bco_aux, id_sis_imp, tip_iva, iva_apl, id_bco_iva_aux, c_acreditado, cfdi_i, cfdi_p, cfdi_e, c_acreditado_bit , met_pag, uuid_crp  
);
GO

SELECT f.id_rcn_iva,f.id_bco_aux,f.id_sis_imp,f.tip_iva,f.iva_apl_rcn,f.iva_apl,
f.id_bco_iva_aux,f.c_acreditado,f.cfdi_i,f.cfdi_p,f.cfdi_e,f.c_acreditado_bit,f.met_pag,f.uuid_crp
FROM dbo.if_bco_iva_det_distinct('20230101','20231231') f

-- 00:00:02
-- 141,449 reg

