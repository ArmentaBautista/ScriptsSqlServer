
SELECT 
u.nom_larg_usr,
v.prim_ver, v.sec_ver, v.rev_ver
,o.* 
FROM co.tbl_scpt_obj o  WITH(NOLOCK) 
INNER JOIN co.tbl_usr_ctrl_obj u  WITH(NOLOCK) 
	ON u.id_usr = o.id_usr
INNER JOIN co.tbl_ver_bd v  WITH(NOLOCK) 
	ON v.id_ver=o.id_ver_fk
WHERE o.nom_obj='vFMTticketTransaccionFinanciera'
ORDER BY o.fec_reg

