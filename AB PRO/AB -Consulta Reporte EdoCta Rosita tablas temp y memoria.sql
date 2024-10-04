


--IF EXISTS(SELECT OBJECT_ID('tempdb..#sis_ref_aux', 'U'))
--BEGIN
--	DROP TABLE #sis_ref_aux
--	PRINT 'tabla borrada'
--END



CREATE TABLE #sis_ref_aux
(
    [id_ref_aux] [INT] NOT NULL PRIMARY KEY,
    [fecha] [DATETIME] NOT NULL,
    [id_tip_doc] [INT] NOT NULL,
    [id_doc] [INT] NOT NULL,
    [num_doc] [INT] NOT NULL,
    [serie] [VARCHAR](10) NOT NULL,
    [id_ref] [INT] NOT NULL,
    [id_tip_doc_apl] [INT] NOT NULL,
    [id_doc_apl] [INT] NOT NULL,
    [num_doc_apl] [INT] NOT NULL,
    [id_ref_apl] [INT] NOT NULL,
    [importe] [FLOAT] NOT NULL,
    [imptos] [FLOAT] NOT NULL,
    [total] [FLOAT] NOT NULL,
    [id_mda] [INT] NOT NULL,
    [tc] [FLOAT] NOT NULL,
    [importe_bse] [FLOAT] NOT NULL,
    [imptos_bse] [FLOAT] NOT NULL,
    [total_bse] [FLOAT] NOT NULL,
    [status] [TINYINT] NOT NULL,
    [fec_reg] [DATETIME] NOT NULL,
    [id_int] [INT] NOT NULL,
    [mto_utiper] [FLOAT] NOT NULL,
    [id_cga_apl] [INT] NOT NULL,
    [io] [TINYINT] NOT NULL,
    [id_cli] [INT] NOT NULL,
    [id_cli_fa] [INT] NOT NULL,
    [id_suc] [INT] NOT NULL
       
) 

INSERT INTO #sis_ref_aux
SELECT id_ref_aux,
       fecha,
       id_tip_doc,
       id_doc,
       num_doc,
       serie,
       id_ref,
       id_tip_doc_apl,
       id_doc_apl,
       num_doc_apl,
       id_ref_apl,
       importe,
       imptos,
       total,
       id_mda,
       tc,
       importe_bse,
       imptos_bse,
       total_bse,
       status,
       fec_reg,
       id_int,
       mto_utiper,
       id_cga_apl,
       io,
       id_cli,
       id_cli_fa,
       id_suc
FROM dbo.sis_ref_aux WITH (NOLOCK)
WHERE id_tip_doc_apl NOT IN ( 89, 91, 92, 93, 150, 351, 106 )
      AND status <> 3;

DECLARE @vt_suc_pat_adu TABLE(
    [nIdSucPatAdu71] INT PRIMARY KEY,
    [CveSucPatAdu] VARCHAR(10),
    [Sucursal] VARCHAR(15),
    [Nombre Sucursal] VARCHAR(50)	
)

INSERT @vt_suc_pat_adu
SELECT 
	  0 AS nIdSucPatAdu71 ,
	  '0' as CveSucPatAdu,
	  '' AS Sucursal, 
	  '' AS [Nombre Sucursal]

INSERT @vt_suc_pat_adu
SELECT DISTINCT 
	  nIdSucPatAdu71,
      CONVERT(CHAR(10),nIdSucPatAdu71) as CveSucPatAdu,
	  Siglas AS Sucursal, 
	  Sucursal AS [Nombre Sucursal]
FROM SIR.SIR_VT_SucursalPatenteAduana WITH(NOLOCK)

SELECT "id_fac" = 0,
       "id_tipo_doc" = sa.id_tip_doc,
       sa.id_cli,
       "numero" = sa.num_doc,
       "fecha" = (CASE
                      WHEN sa.id_tip_doc = 125 THEN
                          reasig.fecha
                      ELSE
                          sa.fecha
                  END
                 ),
       ve.fecha_venc,
       "clave" = CASE
                     WHEN sa.id_cga_apl = 0 THEN
                         cc.clave
                     ELSE
                         ccga.clave
                 END,
       "nom1" = CASE
                    WHEN sa.id_cga_apl = 0 THEN
                        cc.nom1
                    ELSE
                        ccga.nom1
                END,
       sa.tc,
       "importe_simptos" = (CASE
                                WHEN sa.id_tip_doc IN ( 8, 12 ) THEN
                                    sa.importe
                                ELSE
                                    0
                            END
                           ),
       "importe_simptos_bse" = (CASE
                                    WHEN sa.id_tip_doc IN ( 8, 12 ) THEN
                                        sa.importe_bse
                                    ELSE
                                        0
                                END
                               ),
       "montos_imptos" = (CASE
                              WHEN sa.id_tip_doc IN ( 8, 12 ) THEN
                                  sa.imptos
                              ELSE
                                  0
                          END
                         ),
       "monto_imptos_bse" = (CASE
                                 WHEN sa.id_tip_doc IN ( 8, 12 ) THEN
                                     sa.imptos_bse
                                 ELSE
                                     0
                             END
                            ),
       "id_rem" = sa.id_cga_apl,
       "num_cga" = ve.numero,
       "fecha_cga" = ve.fecha,
       "sub_cga" = ve.sub,
       "sub_cga_bse" = ve.sub_bse,
       "imptos_cga" = ve.imptos,
       "imptos_cga_bse" = ve.imptos_bse,
       "total_cga" = ve.total,
       "total_cga_bse" = ve.total_bse,
       "saldo_cga_his" = 0,
       "saldo_cga_bse_his" = 0,
       "tot_cob" = (CASE
                        WHEN sa.id_tip_doc IN ( 110, 111, 997 ) THEN
                            sa.total * (-1)
                        WHEN sa.id_tip_doc = 121
                             AND sa.id_tip_doc_apl <> 120 THEN
                            sa.total * (-1)
                        ELSE
                            0
                    END
                   ),
       "tot_cob_bse" = (CASE
                            WHEN sa.id_tip_doc IN ( 110, 111, 997 ) THEN
                                sa.total_bse * (-1)
                            WHEN sa.id_tip_doc = 121
                                 AND sa.id_tip_doc_apl <> 120 THEN
                                sa.total_bse * (-1)
                            ELSE
                                0
                        END
                       ),
       "importe_ant" = (CASE
                            WHEN sa.id_tip_doc = 120 THEN
                                sa.total
                            WHEN sa.id_tip_doc IN ( 125, 136 )
                                 AND sa.io = 1 THEN
                                sa.total
                            ELSE
                                0
                        END
                       ),
       "importe_ant_bse" = (CASE
                                WHEN sa.id_tip_doc = 120 THEN
                                    sa.total_bse
                                WHEN sa.id_tip_doc IN ( 125, 136 )
                                     AND sa.io = 1 THEN
                                    sa.total_bse
                                ELSE
                                    0
                            END
                           ),
       "saldo_ant" = NULL,
       "saldo_ant_bse" = NULL,
       sa.status,
       "id_fac_det" = 0,
       "ref" = sri.sReferencia,
       "tip_ope" = sri.nTipoOperacion,
       "Pedimento" = sri.sNumPedimento,
       ve.saldo,
       ve.saldo_bse,
       ve.serie,
       "id_mda" = mm.id_moneda,
       mm.codigo,
       "Saldo_ant_cga" = (CASE
                              WHEN sa.id_tip_doc IN ( 120, 16, 17 )
                                   OR
                                   (
                                       sa.id_tip_doc IN ( 125, 136 )
                                       AND sa.io = 1
                                   ) THEN
                                  sa.total
                              ELSE
                                  0
                          END
                         ),
       "Mto_ant_cga" = NULL,
       "Mto_apl_ant_cga" = NULL,
       "nom1_fa_da" = cfd.nom1,
       "clave_fa_da" = cfd.clave,
       sa.id_ref,
       "mto_nc" = (CASE
                       WHEN sa.id_tip_doc IN ( 16, 17 ) THEN
                           sa.total
                       ELSE
                           0
                   END
                  ),
       "mto_nc_bse" = (CASE
                           WHEN sa.id_tip_doc IN ( 16, 17 ) THEN
                               sa.total_bse
                           ELSE
                               0
                       END
                      ),
       "id_suc" = (CASE
                       WHEN sa.id_cga_apl = 0 THEN
                           sa.id_suc
                       ELSE
                           ve.id_suc
                   END
                  ),
       "mto_apl_dev_sdo" = (CASE
                                WHEN sa.id_tip_doc = 124 THEN
                                    sa.total
                                ELSE
                                    0
                            END
                           ),
       "mto_apl_dev_sdo_bse" = (CASE
                                    WHEN sa.id_tip_doc = 124 THEN
                                        sa.total_bse
                                    ELSE
                                        0
                                END
                               ),
       "Import_Razon_Social" = svr.nom1,
       "Reasignado_real" = NULL,
       "Saldo_cte" = NULL,
       "Saldo_cte_bse" = NULL,
       "Saldo_cga" = sa.total,
       "saldo_cga_bse" = sa.total_bse,
       "apl_aut" = (CASE
                        WHEN sa.id_tip_doc IN ( 121, 122 )
                             AND sa.id_int != 666 THEN
                            cxc.c_apl_cga
                        WHEN sa.id_tip_doc IN ( 121, 122 )
                             AND sa.id_int = 666 THEN
                            1
                        ELSE
                            0
                    END
                   ),
       "Aplicado" = 0,
       "Aplicado_bse" = 0,
       sa.id_cga_apl,
       "Sal_fav" = (CASE
                        WHEN sa.id_tip_doc = 120 THEN
                            cxc.c_sal_fav
                        WHEN (
                                 sa.id_tip_doc = 125
                                 AND sa.id_tip_doc_apl = 120
                             )
                             OR
                             (
                                 sa.id_tip_doc IN ( 121, 124, 129 )
                                 AND sa.id_tip_doc_apl = 120
                                 AND sa.id_cga_apl = 0
                             ) THEN
                            sf.c_sal_fav
                        ELSE
                            0
                    END
                   ),
       sa.id_tip_doc_apl,
       sa.id_doc_apl,
       sa.num_doc_apl,
       sa.id_ref_apl,
       sa.total,
       sa.total_bse,
       "CveSucPatAdu" = (CASE
                             WHEN sa.id_cga_apl = 0 THEN
                                 vs.CveSucPatAdu
                             ELSE
                                 vs_ve.CveSucPatAdu
                         END
                        ),
       "Sucursal" = (CASE
                         WHEN sa.id_cga_apl = 0 THEN
                             vs.Sucursal
                         ELSE
                             vs_ve.Sucursal
                     END
                    ),
       "Nombre Sucursal" = (CASE
                                WHEN sa.id_cga_apl = 0 THEN
                                    vs.[Nombre Sucursal]
                                ELSE
                                    vs_ve.[Nombre Sucursal]
                            END
                           ),
       sa.fec_reg,
       sa.id_ref_aux,
       "serie_doc" = sa.serie,
       "cmt" = cxc.ref,
       "sdo_ant_cga" = ve.sdo_ant,
       "id_mda_cga" = CASE
                          WHEN sa.id_cga_apl = 0 THEN
                              sa.id_mda
                          ELSE
                              ve.id_mda
                      END,
       "id_cli_sra" = sa.id_cli,
       "status_cga" = ve.status,
       sa.id_cli_fa,
       cxc.id_cta,
       -- --Se agregó el campo Pedido
       "Pedido" = ISNULL(si.pedido, ''),
       sa.id_doc,
       mmc.codigo
FROM #sis_ref_aux AS sa WITH (NOLOCK)
    INNER JOIN dbo.vta_fac_enc AS ve WITH (NOLOCK)
        ON ve.id_fac = sa.id_cga_apl
    INNER JOIN dbo.cat_clientes AS cc WITH (NOLOCK)
        ON cc.id_cli = sa.id_cli
    INNER JOIN dbo.cat_clientes AS ccga WITH (NOLOCK)
        ON ccga.id_cli = ve.id_cli
    INNER JOIN [SIR].[SIR_60_REFERENCIAS] AS sri WITH (NOLOCK)
        ON sa.id_ref = sri.nIdReferencia60
    INNER JOIN dbo.mon_monedas AS mm WITH (NOLOCK)
        ON sa.id_mda = mm.id_moneda
    INNER JOIN dbo.mon_monedas AS mmc WITH (NOLOCK)
        ON (CASE
                WHEN sa.id_cga_apl = 0 THEN
                    sa.id_mda
                ELSE
                    ve.id_mda
            END
           ) = mmc.id_moneda
    LEFT OUTER JOIN dbo.cat_clientes AS svr WITH (NOLOCK)
        ON sri.nIdImex = svr.id_cli
    LEFT OUTER JOIN dbo.cat_cli_fa_da AS cfd WITH (NOLOCK)
        ON cfd.id_cli_fa_da = sa.id_cli_fa
    LEFT OUTER JOIN dbo.cxc_cobros AS cxc WITH (NOLOCK)
        ON sa.id_tip_doc = cxc.id_tip_doc
           AND sa.id_doc = cxc.id_cobro
    LEFT OUTER JOIN dbo.cxc_cobros AS sf WITH (NOLOCK)
        ON sa.id_tip_doc_apl = sf.id_tip_doc
           AND sa.id_doc_apl = sf.id_cobro
    LEFT OUTER JOIN @vt_suc_pat_adu vs  
        ON sa.id_suc = vs.nIdSucPatAdu71
    INNER JOIN @vt_suc_pat_adu vs_ve 
        ON ve.id_suc = vs_ve.nIdSucPatAdu71
    LEFT OUTER JOIN
    (
        SELECT id_cobro,
               id_tip_doc,
               fecha
        FROM dbo.cxc_cobros WITH (NOLOCK)
        WHERE status <> 3
              AND id_tip_doc = 125
    ) AS reasig
        ON sa.id_tip_doc = reasig.id_tip_doc
           AND sa.id_doc = reasig.id_cobro
    LEFT JOIN dbo.sis_ref_info si WITH (NOLOCK)
        ON sa.id_cga_apl = si.id_fac
           AND sa.id_ref = si.id_ref;


final:






















