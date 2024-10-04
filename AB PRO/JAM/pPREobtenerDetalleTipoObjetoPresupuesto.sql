IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pPREobtenerDetalleTipoObjetoPresupuesto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pPREobtenerDetalleTipoObjetoPresupuesto]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure dbo.pPREobtenerDetalleTipoObjetoPresupuesto
@id_eje 	AS VARCHAR(MAX),
@rev 	AS VARCHAR(MAX),
@id_cc 	AS VARCHAR(MAX),
@id_cta	AS VARCHAR(MAX)
as 
begin
declare @t_ctb_pre2 table(
		[pad]		[varchar](108),
		[mon]		[varchar](3) not null,
		[udm]		[varchar](5) not null,
		[tipo]		[varchar](162),
		[tipo1]		[varchar](160),
		[id_pre]	[int] not null,
		[rev]		[int] not null,
		[id_per]	[int] not null,
		[id_cta]	[int] not null,	
		[id_emp]	[int] not null,
		[id_cen_cto][int] not null,
		[mto]		[money],
		[c_act]		[tinyint] not null,
		[id_usr]	[int] not null,
		[fec_reg]	[datetime] not null,
		[status]	[tinyint] not null,
		[id_eje]	[int] not null,
		[año]		[int] not null,
		[num_per]	[tinyint] not null,
		[per]		[varchar](50) not null,
		[status_per][tinyint] not null,
		[num_cta]	[varchar](25) not null,
		[nom]		[varchar](80) not null,
		[status_cc]	[tinyint] not null,
		[cod_cc]	[varchar](10) not null,
		[des_cc]	[varchar](80) not null,
		[status_cta][tinyint] not null,
		[mto_eje]	[money] not null,
		[cmt]		[varchar](25) not null,
		[id_tip_obj][int] not null,
		[id_obj]	[int] not null,
		[des_tip_obj][varchar](160) not null,
		[Codigo_Cod_Svr][varchar](64) not null,
		[des_Cod_Svr][varchar](50) not null,
		[ref_ref]	[varchar](64) not null,
		[des_ref]	[varchar](64) not null,
		[codigo_pro][nvarchar](60)not null,
		[des_pro]	[nvarchar](500) not null,
		[codigo_cli][varchar](12)not null,
		[des_cli]	[varchar](128) not null,
		[codigo_prov][varchar](12)not null,
		[des_prov]	[varchar](128) not null,
		[nom_emp]	[varchar](102) not null,
		[des_depto]	[varchar](80) not null,
		[des_clas]	[varchar](40) not null,
		[usr]		[varchar](10) not null,
		[id_tip]	[int] not null,
		[codigo_corp][varchar](10) not null,
		[des_corp]	[varchar](128) not null,
		[codigo_suc][varchar](15) not null,
		[des_suc]	[varchar](80) not null,
		[codigo_clas1][varchar](10)	not null,
		[des_clas1]	[varchar](40) not null,
		[codigo_clas2][varchar](10) not null,
		[des_clas2]	[varchar](40) not null,
		[codigo_clas3][varchar](10)	not null,
		[des_clas3]	[varchar](40) not null
	)
	INSERT INTO @t_ctb_pre2 
	SELECT pad,mon,udm,tipo,tipo1,id_pre,rev,id_per,id_cta,id_emp,id_cen_cto,mto,c_act,id_usr,fec_reg,status,id_eje,año,num_per,per,status_per,num_cta,nom,status_cc,cod_cc,des_cc,status_cta,mto_eje,
		cmt,id_tip_obj,id_obj,des_tip_obj,Codigo_Cod_Svr,des_Cod_Svr,ref_ref,des_ref,codigo_pro,des_pro,codigo_cli,des_cli,codigo_prov,des_prov,nom_emp,des_depto,des_clas,usr,id_tip,codigo_corp,des_corp,
		codigo_suc,des_suc,codigo_clas1,des_clas1,codigo_clas2,des_clas2,codigo_clas3,des_clas3
		FROM fn_dveVt_ctb_pre2(@id_eje,@rev)

		SELECT id_tip_obj,id_obj,mto,per,s.des AS tipo,id_cen_cto,id_cta,des_cc,enero + febrero + marzo + abril + mayo + junio + julio + agosto + septiembre + octubre + noviembre + diciembre AS monto, ColCod
FROM(  SELECT (CASE id_tip_obj
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
           ) AS ColCod,v.num_cta,id_tip_obj,id_obj,mto,per,s.des AS tipo,id_cen_cto,id_cta,des_cc
    FROM @t_ctb_pre2 v -- @t_ctb_pre2
    INNER JOIN sis_tip s WITH (NOLOCK) ON s.id_tip = v.id_tip_obj
    WHERE id_eje = @id_eje AND rev = @rev AND id_tip_obj NOT IN ( 0, 207 ) AND v.status > 0 AND v.id_cen_cto = @id_cc
          AND v.id_cta = @id_cta) as t
		  PIVOT
( SUM(mto) FOR per IN ([enero], [febrero], [marzo], [abril], [mayo], [junio], [julio], [agosto], [septiembre], [octubre],[noviembre], [diciembre])) AS pt ORDER BY id_tip_obj,id_obj
		END
        