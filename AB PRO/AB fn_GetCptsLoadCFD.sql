



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fn_GetCptsLoadCFD')
BEGIN
	DROP FUNCTION dbo.fn_GetCptsLoadCFD
	SELECT 'fn_GetCptsLoadCFD BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fn_GetCptsLoadCFD
(
@strCFDs AS NVARCHAR(MAX)
)
RETURNS @tConceptosAgrp TABLE(    
 id INT PRIMARY KEY,    
 IdComprobante INT,    
 IdConcepto INT,    
 ids_impto VARCHAR(100),    
 c_apl_impto_local INT,    
 Importe NUMERIC(27, 6),    
 mtpImptos NUMERIC(27, 6),    
 Descuento NUMERIC(27, 6),    
 Cantidad NUMERIC(27, 6),    
 id_pro INT,    
 id_udm INT,    
 id_ent INT,    
 id_cen_cto INT,    
 id_cod_srv INT,    
 id_ref INT,    
 des_pro_ext VARCHAR(150),    
 c_can_xml INT,    
 c_map_aut INT,    
 c_agrp_cpts_cfd INT,    
 statusAgrp INT,    
 cmtAgrp VARCHAR(300),    
 cve_pro VARCHAR(25),    
 cod_udm VARCHAR(25),    
 cve_ent VARCHAR(25),    
 cod_cc VARCHAR(25),    
 cod_svr VARCHAR(25),    
 ref VARCHAR(70),    
 id_pln INT,    
 statusGen INT,    
 cmtGen VARCHAR(255),    
 total NUMERIC(27, 6),
 id_impto_det INT
)    
AS  
BEGIN    
--SET NOCOUNT ON  
--DECLARE @strCFDs AS VARCHAR(MAX) = '1,80|2,80|29,80|32,80'  
DECLARE @strParCFDs AS VARCHAR(25)  
DECLARE @cveSat AS VARCHAR(25)  
DECLARE @idCFD AS INT= 0    
DECLARE @idPln AS INT= 0    
DECLARE @idCpt AS INT = 0    
DECLARE @c1 AS INT= 0    
DECLARE @iComa AS INT= 0    
DECLARE @c_apl_impto_local AS INT = 0    
DECLARE @ids_impto AS VARCHAR(100)    
DECLARE @cadImptos AS VARCHAR(500)    
DECLARE @mtoImptos NUMERIC(27, 6)    
DECLARE @idTipRet AS INT= 0    
DECLARE @c_map_aut AS INT    
DECLARE @c_agrp_cpts AS INT    
DECLARE @can_cpts AS INT    
DECLARE @idReg AS INT = 0    
DECLARE @cmtCE AS VARCHAR(MAX)    
    
DECLARE @tParesCFD AS TABLE(    
 id INT PRIMARY KEY,    
 dat NVARCHAR(MAX)    
)    
    
DECLARE @tInfoPlnCfd AS TABLE(    
 id INT PRIMARY KEY,    
 id_cfd INT,    
 id_pln INT,    
 c_map_aut INT,    
 c_agrp_cpts_cfd INT,    
 c_encontro INT,    
 can_part INT    
)    
    
DECLARE @tInfoPlnDetCfd AS TABLE(    
 id INT,    
 id_pln_cfd_det INT  PRIMARY KEY,    
 id_pln_cfd INT,    
 id_pro INT,    
 id_udm INT,    
 id_ent INT,    
 id_cen_cto INT,    
 id_cod_srv INT,    
 id_ref INT,    
 id_impto INT,    
 des_pro_ext VARCHAR(1000),    
 cod_pro_ext VARCHAR(60),    
 c_cant_xml TINYINT,    
 c_impto_aut_xml TINYINT,  
 id_cod_sat_pro_ser VARCHAR(100),  
 des_cod_sat_pro_ser VARCHAR(100),  
 c_oper_bool VARCHAR(10)    
     
)    
    
DECLARE @tConceptosExten AS TABLE(    
 id INT PRIMARY KEY,    
 IdConcepto INT,    
 IdComprobante INT,    
 ClaveProdServ VARCHAR(8000),    
 NoIdentificacion VARCHAR(100),    
 Cantidad NUMERIC(27, 6),    
 ClaveUnidad VARCHAR(8000),    
 Unidad VARCHAR(20),    
 Descripcion VARCHAR(1000),    
 ValorUnitario NUMERIC(27, 6),    
 Importe NUMERIC(27, 6),    
 Descuento NUMERIC(27, 6),    
 NoDespacho VARCHAR(100),    
 xmlConcepto XML,      
 ids_impto VARCHAR(100),    
 c_apl_impto_local INT,    
 mtoImptos NUMERIC(27, 6),    
 id_pln INT,    
 c_map_aut INT,    
 can_cpts INT,    
 cmt VARCHAR(MAX)    
)    
    

--PRINT 'SPLIT BEGIN'    
--PRINT CURRENT_TIMESTAMP    
--Desgloce de pares CFD    
INSERT INTO @tParesCFD    
SELECT * FROM [dbo].SplitString (@strCFDs, '|')    

--PRINT CURRENT_TIMESTAMP    
--PRINT 'SPLIT END'

--select * from @tParesCFD    
    
----Obtención de información de plantillas    
    
WHILE EXISTS(SELECT * FROM @tParesCFD WHERE id = @c1)    
BEGIN    
 --Se desglozan datos    
 SELECT @strParCFDs = dat FROM @tParesCFD WHERE id = @c1    
 SET @iComa = CHARINDEX(',', @strParCFDs)    
 SET @idCFD = CONVERT(INT, SUBSTRING(@strParCFDs, 0, @iComa) )    
 SET @idPln = CONVERT(INT, SUBSTRING(@strParCFDs, @iComa + 1, LEN(@strParCFDs) - @iComa) )    
    
 INSERT INTO @tInfoPlnCfd VALUES(@c1, @idCFD, @idPln, 0, 0, 0, 0)    
    
 --Se obtiene información de plantillas(encabezado)    
 UPDATE t SET t.c_map_aut = pln.c_map_aut, t.c_agrp_cpts_cfd = pln.c_agrp_cpts_cfd, t.c_encontro = 1     
 FROM @tInfoPlnCfd t 
 INNER JOIN sis_pln_cfd pln WITH(NOLOCK) 
	ON t.id_pln = pln.id_pln_cfd    
 WHERE t.id_cfd = @idCFD    
    
 IF NOT EXISTS(SELECT * FROM @tInfoPlnDetCfd WHERE id_pln_cfd = @idPln)    
 BEGIN    
  INSERT INTO @tInfoPlnDetCfd    
  --SELECT ROW_NUMBER() OVER(ORDER BY id_pln_cfd_det ASC) AS Row, * FROM dbo.sis_pln_cfd_det WITH(NOLOCK) WHERE id_pln_cfd = @idPln  --- asi se encontraba mal hecho  
    SELECT ROW_NUMBER() OVER(ORDER BY id_pln_cfd_det ASC) AS Row,id_pln_cfd_det,id_pln_cfd,id_pro,id_udm,id_ent,id_cen_cto,id_cod_srv  
  ,id_ref,id_impto,des_pro_ext,cod_pro_ext,c_cant_xml,c_impto_aut_xml,id_cod_sat_pro_ser,des_cod_sat_pro_ser,c_oper_bool  
  FROM dbo.sis_pln_cfd_det WITH(NOLOCK) 
  WHERE id_pln_cfd = @idPln     
    
  UPDATE @tInfoPlnCfd SET can_part = (SELECT COUNT (id_pln_cfd_det) FROM @tInfoPlnDetCfd WHERE id_pln_cfd = @idPln ) WHERE id_pln = @idPln    
 END    
    
    
 --IF EXISTS(SELECT * FROM @tInfoPlnCfd WHERE id_pln = @idPln)    
 --select @idCFD, @idPln    
 SET @c1 = @c1 + 1    
END    
    
--*************************************************    
--Validar como se procede con plantillas mapeadas    
--*************************************************    
    
    
--Se Obtienen conceptos    
INSERT INTO @tConceptosExten    
SELECT     
 ROW_NUMBER() OVER(ORDER BY t.id ASC) AS Row,    
 cpt.IdConcepto,    
 cpt.IdComprobante,    
 cpt.ClaveProdServ,    
 cpt.NoIdentificacion,    
 cpt.Cantidad,    
 cpt.ClaveUnidad,    
 cpt.Unidad,    
 cpt.Descripcion,    
 cpt.ValorUnitario,    
 cpt.Importe,    
 cpt.Descuento,    
 cpt.NoDespacho,    
 cpt.xmlConcepto,     
 '0' AS id_impto,    
 0 AS c_apl_impto_local,    
 0.0 AS mtoImptos,    
 t.id_pln,    
 t.c_map_aut,    
 0,    
 '' cmt
FROM     
 @tInfoPlnCfd t INNER JOIN dbo.CFDIdataConcepto cpt WITH(NOLOCK) ON t.id_cfd = cpt.IdComprobante    
WHERE     
 t.c_map_aut IN (0,1)    
    
--SELECT * FROM @tConceptosExten    
    
--Asignación de impuestos y de bandera si aplica impto local y el tipo de retención    
SET @c1 = 1    
WHILE EXISTS(SELECT * FROM @tConceptosExten WHERE id = @c1)    
BEGIN    
 --@cveSat    
 SELECT  @cveSat = ClaveProdServ, @idCfd = IdComprobante, @idCpt = IdConcepto, @idPln = id_pln  FROM @tConceptosExten WHERE id = @c1    
 SELECT  @can_cpts = COUNT(IdConcepto)  FROM @tConceptosExten WHERE IdComprobante = @idCfd    
 --Si es mapeado o no    
 SELECT @c_map_aut = c_map_aut FROM @tInfoPlnCfd WHERE id_cfd = @idCfd AND id_pln = @idPln    
    
 SELECT @c_apl_impto_local = id_tip_apl_impto_local, @idTipRet = id_tip_ret FROM dbo.cat_sat_pro_ser WITH(NOLOCK) WHERE ClaveProdServ = @cveSat    
 SET @cmtCE = ''    
 --Se obtiene información de impuestos    
 SET @ids_impto = ''    
    
 IF @c_map_aut = 0    
 BEGIN    
  SELECT     
   @cadImptos = cveImptos + '|' + tiposFactor + '|' + tasas + '|' + tipos + '|' + ClaveProdServ + '|' + CONVERT(VARCHAR(10),@idTipRet) + '|2', @mtoImptos = CASE WHEN LEN(importeImptos) = 0  THEN 0.0 ELSE CONVERT(NUMERIC(27, 6), importeImptos) END    
  FROM     
   dbo.vtDetImptosCFDL     
  WHERE     
   IdComprobante = @idCfd AND idConcepto = @idCpt     
    
  --SELECT @cadImptos, @idCfd, @idCpt    
    
  IF @cadImptos IS NOT NULL    
  BEGIN    
   SELECT @ids_impto = dbo.fn_SearchStrTax(@cadImptos, @ids_impto)
   --EXEC dbo.sp_SearchStrTax @cadImptos, @ids_impto OUTPUT    
  END    
  ELSE    
  BEGIN    
   --Si no existe registro se busca exento    
   SET @ids_impto = ''    
   SELECT @ids_impto = dbo.fn_GetTaxExempt(@ids_impto)
   --EXEC dbo.sp_GetTaxExempt @ids_impto OUTPUT    
  END    
 END    
 ELSE    
 BEGIN    
      
  --SET @ids_impto = '0' -- Se toma de la plantilla(se espera respuesta)     
    
  --SELECT     
  -- @mtoImptos = CASE WHEN LEN(importeImptos) = 0  THEN 0.0 ELSE CONVERT(NUMERIC(27, 6), importeImptos) END    
  --FROM     
  -- dbo.vtDetImptosCFDL     
  --WHERE     
  -- IdComprobante = @idCfd AND idConcepto = @idCpt    
    
    
  SELECT     
   @cadImptos = cveImptos + '|' + tiposFactor + '|' + tasas + '|' + tipos + '|' + ClaveProdServ + '|' + CONVERT(VARCHAR(10),@idTipRet) + '|2', @mtoImptos = CASE WHEN LEN(importeImptos) = 0  THEN 0.0 ELSE CONVERT(NUMERIC(27, 6), importeImptos) END    
  FROM     
   dbo.vtDetImptosCFDL     
  WHERE     
   IdComprobante = @idCfd AND idConcepto = @idCpt     
    
  --SELECT @cadImptos, @idCfd, @idCpt    
    
  IF @cadImptos IS NOT NULL    
  BEGIN    
	SELECT @ids_impto= dbo.fn_SearchStrTax(@cadImptos, @ids_impto)
   --EXEC dbo.sp_SearchStrTax @cadImptos, @ids_impto OUTPUT    
  END    
  ELSE    
  BEGIN    
   --Si no existe registro se busca exento    
   SET @ids_impto = ''    
   SELECT @ids_impto = dbo.fn_GetTaxExempt(@ids_impto)
   --EXEC dbo.sp_GetTaxExempt @ids_impto OUTPUT    
  END    
    
 END    
   
 SET @cmtCE = CONVERT(VARCHAR(10), @idCpt )    
 --Se actualiza el registro    
 UPDATE @tConceptosExten SET c_apl_impto_local = @c_apl_impto_local, ids_impto = @ids_impto, mtoImptos = @mtoImptos, can_cpts = @can_cpts, cmt = @cmtCE WHERE id = @c1    
    
 SET @c1 = @c1 + 1    
END    
    
--select * from @tConceptosExten    
--select * from @tInfoPlnCfd    
--select * from @tInfoPlnDetCfd    
    
INSERT INTO @tConceptosAgrp    
    
--=====================================================================================================================    
--          Obtención de resultados    
--=====================================================================================================================    
    
SELECT ROW_NUMBER() OVER(ORDER BY IdComprobante ASC) AS Row, * FROM (    
    
 --=====================================================================================================================    
 --                              Proceso para plantillas no mapeadas agrupadas    
 --=====================================================================================================================    
    
 SELECT     
  cpts.IdComprobante, 0 IdConcepto, cpts.ids_impto, cpts.c_apl_impto_local, SUM(cpts.Importe) AS Importe, SUM(cpts.mtoImptos) AS mtoImptos, SUM(cpts.Descuento) AS Descuento,  SUM(cpts.Cantidad) AS Cantidad    
  , MAX(pdcfd.id_pro) AS id_pro, MAX(pdcfd.id_udm) AS id_udm, MAX(pdcfd.id_ent) AS id_ent, MAX(pdcfd.id_cen_cto) AS id_cen_cto     
  , MAX(pdcfd.id_cod_srv) AS id_cod_srv, MAX(pdcfd.id_ref) AS id_ref, MAX(pdcfd.des_pro_ext) AS des_pro_ext, MAX(pdcfd.c_cant_xml) AS c_cant_xml,    
  MAX(pcfd.c_map_aut) AS c_map_aut, MAX(pcfd.c_agrp_cpts_cfd) AS c_agrp_cpts_cfd, 1 AS statusAgrp,     
  --'Ok' cmtAgrp,     
  MAX(cpts.cmt) cmtAgrp,    
  '' cve_pro,    
  '' cod_udm,    
  '' cve_ent,    
  '' cod_cc,    
  '' cod_svr,    
  '' ref,    
  MAX(pcfd.id_pln) id_pln,    
  1 statusGen,    
  'Ok' cmtGen,    
  (SUM(cpts.Importe) + SUM(cpts.mtoImptos)) - SUM(cpts.Descuento) total,
  MAX(pdcfd.id_impto) as id_impto
 FROM     
  @tInfoPlnCfd pcfd     
  INNER JOIN @tInfoPlnDetCfd pdcfd ON pcfd.id_pln =  pdcfd.id_pln_cfd     
  INNER JOIN @tConceptosExten cpts ON pcfd.id_cfd = cpts.IdComprobante AND pcfd.id_pln = cpts.id_pln    
 WHERE     
  pcfd.c_map_aut = 0 AND pcfd.c_agrp_cpts_cfd = 1 AND pcfd.c_encontro = 1 AND cpts.c_map_aut = 0    
 GROUP BY     
  cpts.IdComprobante, cpts.ids_impto, cpts.c_apl_impto_local    
    
 UNION ALL    
    
 --=====================================================================================================================    
 --                           Proceso para plantillas no mapeadas no agrupadas    
 --=====================================================================================================================    
    
 SELECT     
  cpts.IdComprobante, cpts.IdConcepto, cpts.ids_impto, cpts.c_apl_impto_local, SUM(cpts.Importe) AS Importe, SUM(cpts.mtoImptos) AS mtoImptos, SUM(cpts.Descuento) AS Descuento, SUM(cpts.Cantidad) AS Cantidad    
  , MAX(pdcfd.id_pro) AS id_pro, MAX(pdcfd.id_udm) AS id_udm, MAX(pdcfd.id_ent) AS id_ent, MAX(pdcfd.id_cen_cto) AS id_cen_cto     
  , MAX(pdcfd.id_cod_srv) AS id_cod_srv, MAX(pdcfd.id_ref) AS id_ref, MAX(pdcfd.des_pro_ext) AS des_pro_ext, MAX(pdcfd.c_cant_xml) AS c_cant_xml,    
  MAX(pcfd.c_map_aut) AS c_map_aut, MAX(pcfd.c_agrp_cpts_cfd) AS c_agrp_cpts_cfd, 1 AS statusAgrp,     
  --'Ok' cmtAgrp,     
  MAX(cpts.cmt),    
  '' cve_pro,    
  '' cod_udm,    
  '' cve_ent,    
  '' cod_cc,    
  '' cod_svr,    
  '' ref,    
  MAX(pcfd.id_pln) id_pln,    
  1 statusGen,    
  'Ok' cmtGen,    
  (SUM(cpts.Importe) + SUM(cpts.mtoImptos)) - SUM(cpts.Descuento) total,
  MAX(pdcfd.id_impto) as id_impto
 FROM     
  @tInfoPlnCfd pcfd     
  INNER JOIN @tInfoPlnDetCfd pdcfd ON pcfd.id_pln =  pdcfd.id_pln_cfd     
  INNER JOIN @tConceptosExten cpts ON pcfd.id_cfd = cpts.IdComprobante AND pcfd.id_pln = cpts.id_pln    
 WHERE     
  pcfd.c_map_aut = 0 AND pcfd.c_agrp_cpts_cfd = 0 AND pcfd.c_encontro = 1 AND cpts.c_map_aut = 0    
 GROUP BY   
  cpts.IdComprobante, cpts.idConcepto , cpts.ids_impto, cpts.c_apl_impto_local    
    
 UNION ALL    
    
 --=====================================================================================================================    
 --         Proceso para plantillas mapeadas no agrupadas     
 --=====================================================================================================================    
    
 SELECT DISTINCT    
  cpts.IdComprobante, cpts.IdConcepto, cpts.ids_impto, cpts.c_apl_impto_local, cpts.Importe, cpts.mtoImptos, cpts.Descuento, cpts.Cantidad    
  , pln.id_pro, pln.id_udm, pln.id_ent, pln.id_cen_cto    
  , pln.id_cod_srv, pln.id_ref,     
  pln.des_pro_ext,     
  pln.c_cant_xml,    
  pln.c_map_aut, pln.c_agrp_cpts_cfd,     
  CASE     
   WHEN pln.id_pln_cfd_det IS NULL THEN 4     
   WHEN cpts.can_cpts <> pln.can_part THEN 5    
   ELSE 1     
  END AS statusAgrp,     
  CASE     
   WHEN pln.id_pln_cfd_det IS NULL THEN 'Concepto no mapeado, Descripción: ' + cpts.descripcion + ' NoIdentificación:' + cpts.NoIdentificacion + ' ClaveSAT: ' + cpts.ClaveProdServ      
   WHEN cpts.can_cpts <> pln.can_part THEN 'Cuando la plantilla es mapeada y no agrupada la cantiad de conceptos debe ser la misma que la cantidad de partidas configuradas en la plantilla'    
   WHEN cpts.ids_impto = '-1' THEN cpts.cmt    
   ELSE 'Ok'     
  END cmtAgrp,     
  '' cve_pro,    
  '' cod_udm,    
  '' cve_ent,    
  '' cod_cc,    
  '' cod_svr,    
  '' ref,    
  pln.id_pln,    
  1 statusGen,    
  'Ok' cmtGen,    
  (cpts.Importe + cpts.mtoImptos) - cpts.Descuento total,
  pln.id_impto
 FROM     
  @tConceptosExten cpts    
  LEFT JOIN    
  (SELECT     
   pdcfd.id_pln_cfd_det, pcfd.id_cfd, pcfd.id_pln, pcfd.c_map_aut, pcfd.c_encontro, pdcfd.id_impto, pdcfd.id_pro, pdcfd.id_udm, pdcfd.id_ent, pdcfd.id_cen_cto    
   ,pdcfd.id_cod_srv, pdcfd.id_ref, pdcfd.des_pro_ext, pdcfd.c_cant_xml,    
   pcfd.c_agrp_cpts_cfd, pdcfd.cod_pro_ext, pcfd.can_part, pdcfd.c_oper_bool    
  FROM     
   @tInfoPlnCfd pcfd     
   INNER JOIN @tInfoPlnDetCfd pdcfd ON  pcfd.id_pln =  pdcfd.id_pln_cfd    
  WHERE     
   pcfd.c_map_aut = 1 AND pcfd.c_encontro = 1 AND pcfd.c_agrp_cpts_cfd = 0    
  ) AS pln    
   ON cpts.IdComprobante = pln.id_cfd AND cpts.id_pln = pln.id_pln AND     
   --cpts.descripcion = pln.des_pro_ext and cpts.NoIdentificacion = pln.cod_pro_ext    
  CASE     
   WHEN pln.c_oper_bool <> '' THEN --Con operador booleano    
    CASE    
     WHEN pln.c_oper_bool = 'AND' THEN    
      CASE  WHEN cpts.Descripcion = pln.des_pro_ext AND cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
     WHEN pln.c_oper_bool = 'OR' THEN    
      CASE  WHEN cpts.Descripcion = pln.des_pro_ext OR cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
     ELSE    
      0    
    END    
   ELSE --Sin operador booleano    
    CASE     
     WHEN cpts.Descripcion <> '' THEN --Si el campo Descripcion es diferente de vacio se compara    
      CASE WHEN cpts.Descripcion = pln.des_pro_ext THEN 1 ELSE 0 END    
     ELSE --De lo contrario se usa el NoIdentificación para comparar    
      CASE WHEN cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END    
    END     
    
  END  = 1     
 WHERE    
  cpts.c_map_aut = 1 AND pln.c_agrp_cpts_cfd = 0    
     
 UNION ALL    
    
 --=====================================================================================================================    
 --         Proceso para plantillas mapeadas agrupadas     
 --=====================================================================================================================    
    
 SELECT     
  cpts.IdComprobante, 0 IdConcepto, cpts.ids_impto, cpts.c_apl_impto_local, SUM(cpts.Importe) AS Importe, SUM(cpts.mtoImptos) AS mtoImptos, SUM(cpts.Descuento) AS Descuento, SUM(cpts.Cantidad) AS Cantidad    
  , MAX(pln.id_pro) AS id_pro, MAX(pln.id_udm) AS id_udm, MAX(pln.id_ent) AS id_ent, MAX(pln.id_cen_cto) AS id_cen_cto     
  , MAX(pln.id_cod_srv) AS id_cod_srv, MAX(pln.id_ref) AS id_ref, pln.des_pro_ext AS des_pro_ext, MAX(pln.c_cant_xml) AS c_cant_xml,    
  MAX(pln.c_map_aut) AS c_map_aut, MAX(pln.c_agrp_cpts_cfd) AS c_agrp_cpts_cfd,    
  CASE     
   WHEN MAX(pln.id_pln_cfd_det) IS NULL THEN 4     
   ELSE 1     
  END AS statusAgrp,     
  CASE     
   WHEN MAX(pln.id_pln_cfd_det) IS NULL THEN 'Concepto no mapeado, Descripción: ' + MAX(cpts.descripcion) + ' NoIdentificación:' + MAX(cpts.NoIdentificacion) + ' ClaveSAT: ' + MAX(cpts.ClaveProdServ)      
   WHEN cpts.ids_impto = '-1' THEN MAX(cpts.cmt)    
   ELSE 'Ok'     
  END cmtAgrp,     
  '' cve_pro,    
  '' cod_udm,    
  '' cve_ent,    
  '' cod_cc,    
  '' cod_svr,    
  '' ref,    
  MAX(pln.id_pln) id_pln,    
  1 statusGen,    
  'Ok' cmtGen,    
  (SUM(cpts.Importe) + SUM(cpts.mtoImptos)) - SUM(cpts.Descuento) total,
  MAX(pln.id_impto) as id_impto
 FROM     
  @tConceptosExten cpts    
  LEFT JOIN    
  (SELECT     
   pdcfd.id_pln_cfd_det, pcfd.id_cfd, pcfd.id_pln, pcfd.c_map_aut, pcfd.c_encontro, pdcfd.id_impto, pdcfd.id_pro, pdcfd.id_udm, pdcfd.id_ent, pdcfd.id_cen_cto    
   ,pdcfd.id_cod_srv, pdcfd.id_ref, pdcfd.des_pro_ext, pdcfd.c_cant_xml,    
   pcfd.c_agrp_cpts_cfd, pdcfd.cod_pro_ext, pcfd.can_part, pdcfd.c_oper_bool    
  FROM     
   @tInfoPlnCfd pcfd     
   INNER JOIN @tInfoPlnDetCfd pdcfd ON  pcfd.id_pln =  pdcfd.id_pln_cfd    
  WHERE     
   pcfd.c_map_aut = 1 AND pcfd.c_encontro = 1 AND pcfd.c_agrp_cpts_cfd = 1    
  ) AS pln    
   ON cpts.IdComprobante = pln.id_cfd AND cpts.id_pln = pln.id_pln AND     
   --cpts.descripcion = pln.des_pro_ext and cpts.NoIdentificacion = pln.cod_pro_ext    
  CASE     
   WHEN pln.c_oper_bool <> '' THEN --Con operador booleano    
    CASE    
     WHEN pln.c_oper_bool = 'AND' THEN    
      CASE  WHEN cpts.Descripcion = pln.des_pro_ext AND cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
     WHEN pln.c_oper_bool = 'OR' THEN    
      CASE  WHEN cpts.Descripcion = pln.des_pro_ext OR cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
     ELSE    
      0    
    END    
   ELSE --Sin operador booleano    
    CASE     
     WHEN cpts.Descripcion <> '' THEN --Si el campo Descripcion es diferente de vacio se compara    
      CASE WHEN cpts.Descripcion = pln.des_pro_ext THEN 1 ELSE 0 END    
     ELSE --De lo contrario se usa el NoIdentificación para comparar    
      CASE WHEN cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END    
    END     
    
  END  = 1     
 WHERE    
  cpts.c_map_aut = 1 AND pln.c_agrp_cpts_cfd = 1    
 GROUP BY     
  cpts.IdComprobante, pln.des_pro_ext, pln.cod_pro_ext, cpts.ids_impto, cpts.c_apl_impto_local    
     
    
    
    
) AS t    
    
--Determinación de conceptos no mapeados plantillas mapeadas agrupadas    
DECLARE @cptNoMap TABLE(    
 ID INT,    
 IdComprobante INT,    
 IdConcepto INT,    
 des_pro_ext VARCHAR(1000),    
 cod_pro_ext VARCHAR(60),    
 mach INT    
)    
    
INSERT INTO @cptNoMap    
SELECT     
 ROW_NUMBER() OVER(ORDER BY cpts.IdComprobante ASC) AS Row,    
 cpts.IdComprobante, MAX(cpts.IdConcepto), cpts.Descripcion, cpts.NoIdentificacion,    
 SUM(CASE     
  WHEN pln.c_oper_bool <> '' THEN --Con operador booleano    
   CASE    
    WHEN pln.c_oper_bool = 'AND' THEN    
     CASE  WHEN cpts.Descripcion = pln.des_pro_ext AND cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
    WHEN pln.c_oper_bool = 'OR' THEN    
     CASE  WHEN cpts.Descripcion = pln.des_pro_ext OR cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
    ELSE    
     0    
   END    
  ELSE --Sin operador booleano    
   CASE     
    WHEN cpts.Descripcion <> '' THEN --Si el campo Descripcion es diferente de vacio se compara    
     CASE WHEN cpts.Descripcion = pln.des_pro_ext THEN 1 ELSE 0 END    
    ELSE --De lo contrario se usa el NoIdentificación para comparar    
     CASE WHEN cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END    
   END     
    
 END) AS MACH    
FROM     
 @tConceptosExten cpts    
 LEFT JOIN    
 (SELECT     
  pdcfd.id_pln_cfd_det, pcfd.id_cfd, pcfd.id_pln, pcfd.c_map_aut, pcfd.c_encontro, pdcfd.id_impto, pdcfd.id_pro, pdcfd.id_udm, pdcfd.id_ent, pdcfd.id_cen_cto    
  ,pdcfd.id_cod_srv, pdcfd.id_ref, pdcfd.des_pro_ext, pdcfd.c_cant_xml,    
  pcfd.c_agrp_cpts_cfd, pdcfd.cod_pro_ext, pcfd.can_part, pdcfd.c_oper_bool    
 FROM     
  @tInfoPlnCfd pcfd     
  INNER JOIN @tInfoPlnDetCfd pdcfd ON  pcfd.id_pln =  pdcfd.id_pln_cfd    
 WHERE     
  pcfd.c_map_aut = 1 AND pcfd.c_encontro = 1 AND pcfd.c_agrp_cpts_cfd = 1    
 ) AS pln    
  ON cpts.IdComprobante = pln.id_cfd AND cpts.id_pln = pln.id_pln AND     
  --cpts.descripcion = pln.des_pro_ext and cpts.NoIdentificacion = pln.cod_pro_ext    
 CASE     
  WHEN pln.c_oper_bool <> '' THEN --Con operador booleano    
   CASE    
    WHEN pln.c_oper_bool = 'AND' THEN    
     CASE  WHEN cpts.Descripcion = pln.des_pro_ext AND cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
    WHEN pln.c_oper_bool = 'OR' THEN    
     CASE  WHEN cpts.Descripcion = pln.des_pro_ext OR cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END     
    ELSE    
     0    
   END    
  ELSE --Sin operador booleano    
   CASE     
    WHEN cpts.Descripcion <> '' THEN --Si el campo Descripcion es diferente de vacio se compara    
     CASE WHEN cpts.Descripcion = pln.des_pro_ext THEN 1 ELSE 0 END    
    ELSE --De lo contrario se usa el NoIdentificación para comparar    
     CASE WHEN cpts.NoIdentificacion = pln.cod_pro_ext THEN 1 ELSE 0 END    
   END     
    
 END IN ( 1 ,0 )    
WHERE    
 cpts.c_map_aut = 1 AND pln.c_agrp_cpts_cfd = 1    
GROUP BY     
 cpts.IdComprobante, cpts.Descripcion, cpts.NoIdentificacion    
    
--select * from @cptNoMap    
    
SELECT @idReg = MAX(id) FROM @tConceptosAgrp    
    
INSERT INTO @tConceptosAgrp    
SELECT     
 a.ID + @idReg,     
 c.IdComprobante,    
 c.IdConcepto,    
 c.ids_impto,    
 c.c_apl_impto_local,    
 c.Importe,    
 c.mtoImptos,     
 c.Descuento,    
 c.Cantidad,    
 0 id_pro, 0 id_udm, 0 id_ent, 0 id_cen_cto, 0 id_cod_srv, 0 id_ref,    
 c.Descripcion des_pro_ext,    
 0 c_can_xml,    
 1 c_map_aut,    
 1 c_agrp_cpts_cfd,    
 4 statusAgrp, 'Concepto no mapeado' cmtAgrp,    
 '' cve_pro,    
 '' cod_udm,    
 '' cve_ent,    
 '' cod_cc,    
 '' cod_svr,    
 '' ref,    
 c.id_pln,    
 1 statusAgrp,    
 'Ok' cmtGen,    
 (c.Importe + c.mtoImptos) - c.Descuento total,
 -1 as id_impto_det
FROM     
 @tConceptosExten c INNER JOIN @cptNoMap a ON c.IdComprobante = a.IdComprobante AND c.IdConcepto = a.IdConcepto    
WHERE    
 a.mach = 0    
    
    
    
    
--Determinación de conceptos no mapeados plantillas mapeadas no agrupadas    
    
SELECT @idReg = ISNULL((MAX(id) + 1), 0) FROM @tConceptosAgrp    
    
DECLARE @aux INT     
    
SET @c1 = 0    
WHILE EXISTS(SELECT * FROM @tInfoPlnCfd WHERE id = @c1)    
BEGIN    
 SELECT     
  @c_map_aut = c_map_aut,    
  @c_agrp_cpts = c_agrp_cpts_cfd,    
  @idCFD = id_cfd,    
  @idPln = id_pln    
 FROM @tInfoPlnCfd WHERE id = @c1    
    
 IF (@c_map_aut = 1)    
 BEGIN    
  IF (@c_agrp_cpts = 1)     
  BEGIN    
   --print 'agrupadas'    
   SET @aux = 7    
  END    
  ELSE    
  BEGIN    
       
   INSERT INTO @tConceptosAgrp    
   SELECT     
    @idReg + c.id id,         
    @idCFD IdComprobante,    
    c.IdConcepto,    
    c.ids_impto,    
    c.c_apl_impto_local,    
    c.Importe,    
    c.mtoImptos,     
    c.Descuento,    
    c.Cantidad,    
    0 id_pro, 0 id_udm, 0 id_ent, 0 id_cen_cto, 0 id_cod_srv, 0 id_ref,    
    c.Descripcion des_pro_ext,    
    0 c_can_xml,    
    @c_map_aut c_map_aut,    
    @c_agrp_cpts c_agrp_cpts_cfd,    
    4 statusAgrp, 'Concepto no mapeado' cmtAgrp,    
    '' cve_pro,    
    '' cod_udm,    
    '' cve_ent,    
    '' cod_cc,    
    '' cod_svr,    
    '' ref,    
    c.id_pln,    
    1 statusAgrp,    
    'Ok' cmtGen,    
    (c.Importe + c.mtoImptos) - c.Descuento total,
  a.id_impto_det
   FROM     
    @tConceptosExten c LEFT JOIN @tConceptosAgrp a ON c.IdComprobante = a.IdComprobante AND c.IdConcepto = a.IdConcepto    
   WHERE    
    c.IdComprobante = @idCFD AND c.id_pln = @idPln AND a.IdComprobante IS NULL    
    
   SET @idReg = @idReg +1    
    
  END    
 END    
     
    
 SET @c1 = @c1 + 1     
END    
    
    
    
--Se asignan datos de catálogos    
UPDATE d    
SET d.cve_pro = p.clave,    
 d.cod_udm = u.codigo,    
 d.cve_ent = g.clave,    
 d.cod_cc = cc.codigo,    
 d.cod_svr = svr.codigo,    
 d.ref = ISNULL(ref.ref, '')    
FROM     
 @tConceptosAgrp d     
 INNER JOIN cat_pro p WITH(NOLOCK) ON d.id_pro = p.id_pro    
 INNER JOIN cat_udm u WITH(NOLOCK) ON d.id_udm = u.id_udm    
 INNER JOIN cat_gastos g WITH(NOLOCK) ON d.id_ent = g.id_gto    
 INNER JOIN ctb_cen_cto cc WITH(NOLOCK) ON d.id_cen_cto = cc.id_cen_cto    
 INNER JOIN sis_cod_svr svr WITH(NOLOCK) ON d.id_cod_srv = svr.id_cod_svr    
 LEFT JOIN vt_sis_ref ref WITH(NOLOCK) ON d.id_ref = ref.id_ref    
--Se asignan status de las partidas    
    
UPDATE @tConceptosAgrp SET statusAgrp = 2 WHERE  CHARINDEX(',', ids_impto) > 0    
UPDATE @tConceptosAgrp SET cmtAgrp = 'Se ubicó más de un impuesto para el concepto' WHERE  CHARINDEX(',', ids_impto) > 0    
    
UPDATE @tConceptosAgrp SET statusAgrp = 3 WHERE ids_impto = '-1'    
UPDATE @tConceptosAgrp SET cmtAgrp = 'Impuesto no encontrado Cpt.:' + cmtAgrp WHERE ids_impto = '-1'    
    
IF EXISTS(SELECT * FROM @tConceptosAgrp  WHERE statusAgrp = 4)    
BEGIN    
 UPDATE @tConceptosAgrp SET statusGen = 2     
 UPDATE @tConceptosAgrp SET cmtGen = 'Existen concentos no mapeados'    
END    
    
--SET NOCOUNT OFF    
    
--SELECT * FROM @tConceptosAgrp;     
RETURN


--select * from @tInfoPlnCfd    
--select * from @tInfoPlnDetCfd    
--select * from @tConceptosExten    
    
--select * from @tInfoPlnDetCfd dp    
--inner join  @tConceptosExten dd on dd.descripcion = dp.des_pro_ext and dd.NoIdentificacion = dp.cod_pro_ext    
    
    
END  


GO

