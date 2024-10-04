SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER procedure dbo.sp_ObtenerDatosPresupuesto
@consulta int,
@id_eje 	AS VARCHAR(MAX),
@rev 	AS VARCHAR(MAX),
@id_cc 	AS VARCHAR(MAX),
@id_cta	AS VARCHAR(MAX)
as 
begin
	if @consulta=0 --Periodos Reales En el Sistema
		begin
			Select rev ,c_act,status FROM vt_pre_rev WHERE id_eje=@id_eje And Rev=@rev
		end
	if @consulta=1 --Periodos Reales En el Sistema
		begin
			Select distinct año as Año, fec_ini_eje as [Fecha inicial], fec_fin_eje as [Fecha final], id_eje from vt_ctb_per_eje where id_eje > 0
		end
	if @consulta=2 --Revisiones relacionadas al periodo 
		begin
			Select rev as Revisión, fec_alta as [Fecha de Alta], fec_reg as [Ult. modific.], CASE c_act WHEN 0 THEN 'CERRADA' WHEN 1 THEN 'ABIERTA' WHEN 3 THEN 'ELIMINADA' END as [Estado] FROM vt_pre_rev where id_eje= @id_eje
		end
	if @consulta=3 --Devuelve detalles de la revision
	begin
		Select c_act, fec_alta, usr_alta, fec_reg, Usr_ult_modif, id_nota,nota,id_rev from vt_pre_rev Where id_eje =@id_eje And Rev = @rev
	end	
	if @consulta=4 --Cuentas relacionadas al Periodo 
		begin
			Select id_cta, (num_cta + ' ' + nom ) as Cuenta from vt_ctb_pre Where id_pre > 0 And id_cta>0 And rev=@rev AND id_Eje=@id_eje and status=1 Group by id_cta,num_cta,nom order by num_cta
		end
	if @consulta=5 --presupuesto en tablas normal
		begin
			Select * from vt_ctb_pre where id_eje =@id_eje and rev=@rev and id_tip_obj>0 and status=1 order by id_per, num_per
		End
	if @consulta=6 --presupuesto en tablas pivoteadas
		begin
			select isnull(enero,0) as enero,isnull(febrero,0) as febrero,isnull(marzo,0) as marzo,isnull(abril,0) as abril,isnull(mayo,0) as mayo,isnull(junio,0) as junio, isnull(julio,0) as julio,
			isnull(agosto,0) as agosto,isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre,isnull(noviembre,0) as noviembre,isnull(diciembre,0) as diciembre,*			
			from (Select CAST('False' as bit) as valor,tipo,pad,mon,udm,rev,num_cta,nom,mto,per,mto_eje,id_cta,id_tip,id_obj 
							from vt_ctb_pre1 
							where id_eje =@id_eje and rev=@rev and id_tip_obj=0 and status=1) as t 
					pivot (sum(mto) for per in ([enero],[febrero],[marzo],[abril],[mayo],[junio],[julio],[agosto],[septiembre],[octubre],[noviembre],[diciembre])) as pt order by id_tip
		End
	if @consulta=7 --Detalle de Centro de Costo
		begin
			select isnull(enero,0) as enero,isnull(febrero,0) as febrero,isnull(marzo,0) as marzo,isnull(abril,0) as abril,isnull(mayo,0) as mayo,isnull(junio,0) as junio, isnull(julio,0) as julio,
			isnull(agosto,0) as agosto,isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre,isnull(noviembre,0) as noviembre,isnull(diciembre,0) as diciembre,*
			,enero+febrero+marzo+abril+mayo+junio+julio+agosto+septiembre+Octubre+noviembre+diciembre as monto from (SELECT id_cta, id_cen_cto,per,cod_cc,des_cc, Round(mto,0,1) as mto, num_cta,id_obj 
							From vt_ctb_pre WITH (NOLOCK) 
							Where id_eje =@id_eje And rev =@rev And id_tip_obj = 207 And id_cen_cto>0 And status>0 /*And num_cta like '403000101%'*/) as t
					pivot (sum(mto) for per in ([enero],[febrero],[marzo],[abril],[mayo],[junio],[julio],[agosto],[septiembre],[octubre],[noviembre],[diciembre])) as pt
			--				ORDER BY num_cta, cod_cc, id_per 
		End
	if @consulta=8 --Detalle por tipo de objeto
		begin
			 SELECT (Case id_tip_obj when 209 then Codigo_Cod_Svr when 211 then ref_ref when 212 then str(id_obj) when 202 then codigo_pro when 203 then codigo_pro END) as ColCod,id_obj,
			(Case id_tip_obj when 209 then des_Cod_Svr when 211 then des_ref when 212 then nom_emp when 202 then des_pro when 203 then des_pro END) as ColDes,id_cta , id_cen_cto, id_tip_obj 
			From vt_ctb_pre Where id_eje =@id_eje And rev=@rev AND id_cen_cto=@id_CC AND id_cta= @id_cta /*AND id_tip_obj not in(0,207)*/ AND status>0 
			group by id_tip_obj,Codigo_Cod_Svr, ref_ref,id_emp,codigo_pro,des_cod_svr,des_ref,nom_emp, des_pro,id_obj, id_cta, id_cen_cto,id_tip_obj Order by id_tip_obj, id_obj
		End
	if @consulta=9 --Detalle por tipo de objeto
		BEGIN
        -- 1. Meter todo esto (9) en un sp pPREobtenerDetalleTipoObjeto
		-- 2. Dentro del sp crear variable de tabla @t_ctb_pre2
		-- 3. El select de esta seccion (9) hacerlo función recibiendo el ejericio (año)
		-- 4. Invocar la función y el resultado meterlo en la variable de tabla
		-- 5. el pivot hacrelo con la variable de tabla


			SELECT *,
       enero + febrero + marzo + abril + mayo + junio + julio + agosto + septiembre + octubre + noviembre + diciembre AS monto,
       ColCod
FROM
(
    SELECT (CASE id_tip_obj
                WHEN 209 THEN
                    Codigo_Cod_Svr
                WHEN 211 THEN
                    ref_ref
                WHEN 212 THEN
                    nom_emp
                WHEN 202 THEN
                    codigo_pro
                WHEN 220 THEN
                    des_depto
                WHEN 66752 THEN
                    des_clas
                WHEN 203 THEN
                    codigo_pro
                WHEN 200 THEN
                    des_cli
                WHEN 201 THEN
                    des_cli
                WHEN 71701 THEN
                    des_corp
                WHEN 71702 THEN
                    des_suc
                WHEN 71703 THEN
                    des_clas1
                WHEN 71704 THEN
                    des_clas2
                WHEN 71705 THEN
                    des_clas3
            END
           ) AS ColCod,
           v.num_cta,
           id_tip_obj,
           id_obj,
           mto,
           per,
           s.des AS tipo,
           id_cen_cto,
           id_cta,
           des_cc
    FROM vt_ctb_pre2 v WITH (NOLOCK) -- @t_ctb_pre2
        INNER JOIN sis_tip s WITH (NOLOCK)
            ON s.id_tip = v.id_tip_obj
    WHERE id_eje = @id_eje
          AND rev = @rev
          AND id_tip_obj NOT IN ( 0, 207 )
          AND v.status > 0
          AND v.id_cen_cto = @id_cc
          AND v.id_cta = @id_cta
) AS t
PIVOT
(
    SUM(mto)
    FOR per IN ([enero], [febrero], [marzo], [abril], [mayo], [junio], [julio], [agosto], [septiembre], [octubre],
                [noviembre], [diciembre]
               )
) AS pt
ORDER BY id_tip_obj,
         id_obj;
		END
        



	if @consulta=10 --Consulta de Resumen
		begin
				select isnull(enero,0) as enero,isnull(febrero,0) as febrero,isnull(marzo,0) as marzo,isnull(abril,0) as abril,isnull(mayo,0) as mayo,isnull(junio,0) as junio, isnull(julio,0) as julio,
				isnull(agosto,0) as agosto,isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre,isnull(noviembre,0) as noviembre,isnull(diciembre,0) as diciembre,enero+febrero+marzo+abril+mayo+junio+julio+agosto+septiembre+Octubre+noviembre+diciembre as monto,*
				 from (Select max(tipo1) as tipo /*pad,mon,udm*/,rev/*,num_cta,nom*/,case when id_tip=6 then sum(mto) else sum(mto)*-1 end as mto,per,case when id_tip=6 then sum(mto_eje) else sum(mto_eje)*-1 end as mto_eje,id_tip/*,id_cta*/,
				 'UTILIDAD NETA' as grupo1,case when id_tip in (6,8) then ' 0 UTILIDAD BRUTA' when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS'  ELSE '9 IMPUESTOS'  end as grupo2,case when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS' ELSE 'UTILIDAD BRUTA = VENTAS - COSTO '  end as grupo3, 
				case when id_tip in (6,8) then ' 0 UTILIDAD BRUTA' when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS' when id_tip in (13) then '2 UTILIDAD NETA' ELSE '' end as grupo  
					from vt_ctb_pre1 
					where id_eje =@id_eje and rev=@rev and id_tip_obj=0 and status=1 and id_tip in (6,8,9,10,13) group by tipo,rev,per,id_tip) as t 
			pivot (sum(mto) for per in ([enero],[febrero],[marzo],[abril],[mayo],[junio],[julio],[agosto],[septiembre],[octubre],[noviembre],[diciembre])) as pt order by  id_tip,grupo
		End
	if @consulta=11 --llena Cuentas desde Catalogo
		begin
				SELECT CAST('False' as bit) as valor,dbo.fn_OrdenArbolCuentas(num_cta) + 'Z' AS OrdenArbol, v.*, s.des AS des_tip, s.orden, s.status AS status_tip, s.tipo as tipo_tip 
				FROM vt_ctb_cta v WITH (NOLOCK) 
				INNER JOIN sis_tip s WITH (NOLOCK) ON v.id_tip=s.id_tip 
				WHERE v.status<>0 AND v.id_cta>0 and s.clase in (4,5,6,7) and c_acu=0  ORDER BY s.orden ASC, OrdenArbol DESC
		End
	if @consulta=12 --Obtiene el maximo para grabar el nuevo presupuesto.
		begin
			Select Max(id_pre)+1 As Id_Pre from ctb_pre
		end
	if @consulta=13 -- Devuelve ids y deatalles de los periodos que se estan utilizando en el ejercicio.
		begin
			select p.*,ISNULL(e.status_per,-1) as status_per,e.id_mod from ctb_per_eje p inner join ctb_per_ctl e on p.id_per=e.id_per and e.id_mod=32 Where id_eje =@id_eje and num_per<13
		End
	if @consulta=14 --Devuelve Categorias o Tipos de Objetos
		begin
			select * from sis_tip Where id_tip in (209,212,202,203,211,200,201,66752,220,71701,71702,71703,71704,71705)
		End
	if @consulta=15 --Devuelve Revisiones y Nueva
		begin
			--Select distinct año as Año, fec_ini_eje as [Fecha inicial], fec_fin_eje as [Fecha final], id_eje from vt_ctb_per_eje where id_eje > 0
			--Select * from vt_ctb_per_eje where id_eje > 0
			--Select rev as Revisión, fec_alta as [Fecha de Alta], fec_reg as [Ult. modific.], CASE c_act WHEN 0 THEN 'CERRADA' WHEN 1 THEN 'ABIERTA' WHEN 3 THEN 'ELIMINADA' END as [Estado] FROM vt_pre_rev where id_eje= @id_eje
			Select 0 as id_rev,0 as id_eje,0 as rev,getdate()  as fec_alta,getdate() as fec_reg,0 as c_act,'NUEVA REVISION' as nota,0 as id_usr_alta,0 as id_usr,0 as status,0 as id_nota,'' as usr_alta,
			''  as usr_ult_modif,year(getdate()) as Año,getdate()  as Fechai,getdate() as Fechaf,0 as id_eje,'NUEVA' as [Estado],'' as Estatus,0 as Ventas,0 as Costos,0 as Gastos,0 as GastosFinan, 0 as Impuestos
			UNION
			Select v.id_rev,v.id_eje,v.rev,v.fec_alta,v.fec_reg,v.c_act,case cast(v.nota as varchar(max)) when 'SIN NOTA' then '' else cast(v.nota as varchar(max)) END as nota,v.id_usr_alta,v.id_usr,v.status,v.id_nota,v.usr_alta,v.usr_ult_modif,e.Año,e.Fechai,e.Fechaf,e.id_eje,
			CASE c_act WHEN 0 THEN 'CERRADA' WHEN 1 THEN 'ABIERTA' WHEN 3 THEN 'ELIMINADA' END as [Estado],CASE status WHEN 0 THEN 'CANCELADA' else 'GRABADA' END as [Estatus]  
			,0 as Ventas,0 as Costos,0 as Gastos,0 as GastosFinan, 0 as Impuestos
			FROM vt_pre_rev v inner join ( Select distinct año as Año, fec_ini_eje as Fechai, fec_fin_eje as Fechaf, id_eje from vt_ctb_per_eje where id_eje > 0) e on v.id_eje=e.id_eje 
			order by Año desc
			--Select v.*,e.*,CASE c_act WHEN 0 THEN 'CERRADA' WHEN 1 THEN 'ABIERTA' WHEN 3 THEN 'ELIMINADA' END as [Estado] FROM vt_pre_rev v inner join ( Select distinct año as Año, fec_ini_eje as Fechai, fec_fin_eje as Fechaf, id_eje from vt_ctb_per_eje where id_eje > 0) e on v.id_eje=e.id_eje			
		End
		if @consulta=16 --Devuelve Centros de Costo
		begin
			select CAST('False' as bit) as valor,id_cen_cto as id,codigo,des from ctb_cen_cto where id_cen_cto>0
		End
		if @consulta=17 --Devuelve Revisiones Sin Nueva
		begin						
			Select v.id_rev,v.id_eje,v.rev,v.fec_alta,v.fec_reg,v.c_act,cast(v.nota as varchar(max)) as nota,v.id_usr_alta,v.id_usr,v.status,v.id_nota,v.usr_alta,v.usr_ult_modif,e.Año,e.Fechai,e.Fechaf,e.id_eje,
			CASE c_act WHEN 0 THEN 'CERRADA' WHEN 1 THEN 'ABIERTA' WHEN 3 THEN 'ELIMINADA' END as [Estado] 
			,0 as Ventas,0 as Costos,0 as Gastos,0 as GastosFinan, 0 as Impuestos
			FROM vt_pre_rev v inner join ( Select distinct año as Año, fec_ini_eje as Fechai, fec_fin_eje as Fechaf, id_eje from vt_ctb_per_eje where id_eje > 0) e on v.id_eje=e.id_eje
			where not(v.id_eje=@id_eje And rev=@rev)
			order by Año desc
		End
		if @consulta=18 --Devuelve real de cuentas
		begin						
			select CAST('False' as bit) as valor,* from (select cta.id_cta,cta.num_cta,año ,case st.clase when 4 then cam_net*-1 else cam_net end as mto,p.per,case st.des when 'VENTAS' then '0' when 'COSTO DE LO VENDIDO' then '1'  when 'GASTOS' then '2' when 'GASTOS FINANCIEROS' then '3' 
					  when 'IMPUESTOS' then '4' else '9' end +' '+st.des as tipo,pad.num_cta +' - ' + pad.nom as pad,cta.nom,m.codigo as mon,u.codigo as udm,0 as id_obj 
				from ctb_acu acu with (nolock)
				inner join ctb_cta cta with (nolock) on cta.id_cta=acu.id_cta
				inner join ctb_per_eje p with (nolock) on acu.id_per=p.id_per 
				inner join sis_tip st with (nolock) ON st.id_tip = cta.id_tip 
				inner join ctb_cta pad with (nolock) ON cta.id_cta_pad = pad.id_cta
				inner join mon_monedas m with (nolock) ON cta.id_mda = m.id_moneda
				inner join cat_udm u with (nolock) ON cta.id_udm = u.id_udm 
				where p.id_eje=@id_eje and st.clase in (4,5,6,7) and cta.c_acu=0 /* group by st.des,cta.id_cta,cta.num_cta,per*/) as t 
				pivot (sum(mto) for per in ([enero],[febrero],[marzo],[abril],[mayo],[junio],[julio],[agosto],[septiembre],[octubre],[noviembre],[diciembre]))as pt	 				
				order by pt.tipo,pt.num_cta
		end
		if @consulta=19 --Devuelve real de cuentas
		begin						
			select cta.*,m.codsat,u.codigo,pad.num_cta +' - ' + pad.nom as pad,
			case st.des when 'VENTAS' then '0' when 'COSTO DE LO VENDIDO' then '1'  when 'GASTOS' then '2' when 'GASTOS FINANCIEROS' then '3' when 'IMPUESTOS' then '4' else '9' end +' '+ st.des as tipo 
			from ctb_cta cta
			inner join ctb_cta pad with (nolock) ON cta.id_cta_pad = pad.id_cta
			inner join mon_monedas m with (nolock) ON cta.id_mda = m.id_moneda
			inner join cat_udm u with (nolock) ON cta.id_udm = u.id_udm 
			inner join sis_tip st with (nolock) ON st.id_tip = cta.id_tip
		end
		if @consulta=20 --Devuelve Detalle de Resumen por cuentas padre
		begin						
				--select isnull(enero,0) as enero,isnull(febrero,0) as febrero,isnull(marzo,0) as marzo,isnull(abril,0) as abril,isnull(mayo,0) as mayo,isnull(junio,0) as junio, isnull(julio,0) as julio,
				--isnull(agosto,0) as agosto,isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre,isnull(noviembre,0) as noviembre,isnull(diciembre,0) as diciembre,
				select enero+febrero+marzo+abril+mayo+junio+julio+agosto+septiembre+Octubre+noviembre+diciembre as monto,*
				 from (select pad,max(tipo1) as tipo /*pad,mon,udm*/,rev/*,num_cta,nom*/,case when id_tip=6 then sum(mto) else sum(mto)*-1 end as mto,per,case when id_tip=6 then sum(mto_eje) else sum(mto_eje)*-1 end as mto_eje,id_tip/*,id_cta*/,
				 'UTILIDAD NETA' as grupo1,case when id_tip in (6,8) then ' 0 UTILIDAD BRUTA' when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS'  ELSE '9 IMPUESTOS'  end as grupo2,case when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS' ELSE 'UTILIDAD BRUTA = VENTAS - COSTO '  end as grupo3, 
					case when id_tip in (6,8) then ' 0 UTILIDAD BRUTA' when id_tip in (9,10) then '1 UTILIDAD NETA ANTES DE IMPUESTOS' when id_tip in (13) then '2 UTILIDAD NETA' ELSE '' end as grupo  
					from vt_ctb_pre1  
					where id_eje =@id_eje and rev=@rev and id_tip_obj=0 and status=1 and id_tip in (6,8,9,10,13) group by pad,rev,per,id_tip) as t 
			pivot (sum(mto) for per in ([enero],[febrero],[marzo],[abril],[mayo],[junio],[julio],[agosto],[septiembre],[octubre],[noviembre],[diciembre])) as pt order by  id_tip,grupo
		end
end
GO

