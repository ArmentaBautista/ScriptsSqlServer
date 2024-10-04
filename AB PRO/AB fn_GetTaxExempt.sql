
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fn_GetTaxExempt')
BEGIN
	DROP FUNCTION dbo.fn_GetTaxExempt
	SELECT 'fn_GetTaxExempt BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fn_GetTaxExempt
(
 @ids_impto AS VARCHAR(100)  
)
RETURNS VARCHAR(100)
AS  
BEGIN  
  
DECLARE @c1 AS INT = 1  
DECLARE @id_impto_tmp AS INT  
  
DECLARE @tImptosDet As TABLE(  
 id int PRIMARY KEY,  
 id_impto INT,  
 id_cod_imp INT,  
 id_cta INT,  
 tasa FLOAT,  
 c_iva INT,  
 c_ret INT,  
 c_exe INT,  
 tipo INT,  
 tip_impto INT,  
 c_pag_imp INT,  
 c_zon_frn INT,  
 c_iva_imp INT,  
 id_tip_impto INT,  
 id_tip_ret INT  
)  
  
INSERT INTO @tImptosDet  
SELECT   
 ROW_NUMBER() OVER(ORDER BY id_impto ASC) AS Row, id_impto, id_cod_imp, id_cta, tasa, c_iva, c_ret, c_exe, tipo, tip_impto, c_pag_imp, c_zon_frn,c_iva_imp, id_tip_impto, id_tip_ret   
FROM   
 vt_cat_imp_frm   
WHERE  
 c_exe = 1 AND id_impto in (SELECT id_impto FROM dbo.vtImptosCanPart WHERE canDet = 1)   
  
  
  
WHILE EXISTS(SELECT * FROM @tImptosDet WHERE id = @c1)  
BEGIN  
 SELECT @id_impto_tmp = id_impto FROM @tImptosDet WHERE id = @c1  
 SET @ids_impto =   @ids_impto + ',' + CONVERT(VARCHAR(5), @id_impto_tmp)  
  
 SET @c1 = @c1 + 1  
END  
  
  
SET @ids_impto = ISNULL( SUBSTRING(@ids_impto,2, LEN(@ids_impto)), '0')  
  
SET @ids_impto = CASE WHEN LEN(@ids_impto) = 0 THEN '-1' ELSE @ids_impto END  
 
RETURN @ids_impto 
END
GO

