
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fn_SearchStrTax')
BEGIN
	DROP FUNCTION dbo.fn_SearchStrTax
	SELECT 'fn_SearchStrTax BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fn_SearchStrTax
(
 @cad_imptos AS NVARCHAR(MAX)
 ,@ids_impto AS VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN

DECLARE @id_impto_tmp AS INT
DECLARE @strCveImptos As NVARCHAR(MAX)
DECLARE @strTipoFactor As NVARCHAR(MAX)
DECLARE @strTasas As NVARCHAR(MAX)
DECLARE @strTipos As NVARCHAR(MAX)
DECLARE @tipo AS INT
DECLARE @nPartidas AS INT
DECLARE @id_tip_ret AS INT
DECLARE @id_tip_apl_impto_local AS INT
DECLARE @cveSat AS INT
DECLARE @c1 AS INT = 1
DECLARE @c2 AS INT = 1
DECLARE @c3 AS INT = 1

DECLARE @tDatos As TABLE(
 id int PRIMARY KEY,
 dat NVARCHAR(MAX)
)

DECLARE @tCveImptos As TABLE(
 id int PRIMARY KEY,
 dat NVARCHAR(MAX)
)

DECLARE @tTipoFactor As TABLE(
 id int PRIMARY KEY,
 dat NVARCHAR(MAX)
)

DECLARE @tTasas As TABLE(
 id int PRIMARY KEY,
 dat NVARCHAR(MAX)
)

DECLARE @tTipos As TABLE(
 id int PRIMARY KEY,
 dat NVARCHAR(MAX)
)

DECLARE @tImptos As TABLE(
 id int IDENTITY(1,1) PRIMARY KEY,
 id_impto int
)

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

SET @ids_impto = ISNULL(@ids_impto, '')

--=============================================================================
--====Proceso para ubicar impuesto exento (cad_imptos debe venir vacio '' )
--=============================================================================
IF len(ltrim(rTRIM(@cad_imptos))) = 0  GOTO UBICADO



INSERT INTO @tDatos
SELECT * FROM [dbo].SplitString (@cad_imptos, '|')

SELECT @strCveImptos = dat FROM @tDatos WHERE id = 0
SELECT @strTipoFactor = dat FROM @tDatos WHERE id = 1
SELECT @strTasas = dat FROM @tDatos WHERE id = 2
SELECT @strTipos = dat FROM @tDatos WHERE id = 3
SELECT @cveSat = dat FROM @tDatos WHERE id = 4
SELECT @id_tip_ret = CONVERT(INT,dat) FROM @tDatos WHERE id = 5

INSERT INTO @tCveImptos
SELECT * FROM [dbo].SplitString (@strCveImptos, ',')

INSERT INTO @tTipoFactor
SELECT * FROM [dbo].SplitString (@strTipoFactor, ',')

INSERT INTO @tTasas
SELECT * FROM [dbo].SplitString (@strTasas, ',')

INSERT INTO @tTipos
SELECT * FROM [dbo].SplitString (@strTipos, ',')

--select * from @tCveImptos
--select * from @tTipoFactor
--select * from @tTasas
--select * from @tTipos

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--CONSIDERAR LOS IMPUESTOS PARA PODER INSERTAR LOS QUE CORRESPONDE UNICAMENTE A PROVEEDOR O A AMBOS.
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Tipo 0 = Aplica a todos
--Tipo 1 = Aplica a Clientes [TODOS LOS IMPUESTOS CON ESTE TIPO DEBEN DE DESCARTARSE YA QUE NO APLICARIAN]
--Tipo 2 = Aplica a proveedores.
  SET @tipo = 2
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--SE COMENTA ESTA LINEA PARA FORZAR A QUE UNICAMENTE SEAN IMPUESTOS DE TIPO PROVEEDOR O TODOS.
--IF EXISTS(SELECT * FROM @tTipos WHERE dat ='2') SET @tipo = 2 ELSE SET @tipo = 1
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SELECT @nPartidas = COUNT(*) FROM @tTasas

--SELECT @id_tip_apl_impto_local = id_tip_apl_impto_local, @id_tip_ret = id_tip_ret FROM cat_sat_pro_ser WITH(NOLOCK) WHERE ClaveProdServ = @cveSat

--SELECT @tipo tipo, @nPartidas nPartidas

INSERt INTO @tImptos
SELECT id_impto FROM vtImptosCanPart WHERE (tipo = @tipo OR tipo = 0) AND canDet = @nPartidas

--SELECT * FROM @tImptos

WHILE EXISTS(SELECT * FROM @tImptos WHERE id = @c1)
BEGIN

 DELETE @tImptosDet
 SET @c2 = 1

 SELECT @id_impto_tmp = id_impto FROM @tImptos WHERE id = @c1
 --SELECT @id_impto_tmp id_impto_tmp
 --select * from vt_cat_imp_frm WHERE id_impto = @id_impto_tmp order by id_cod_imp
 INSERT INTO @tImptosDet
 SELECT
  ROW_NUMBER() OVER(ORDER BY id_impto ASC) AS Row, id_impto, id_cod_imp, id_cta, tasa, c_iva, c_ret, c_exe, tipo, tip_impto, c_pag_imp, c_zon_frn,c_iva_imp, id_tip_impto, id_tip_ret
 FROM
  dbo.vt_cat_imp_frm
 WHERE
  id_impto = @id_impto_tmp
 ORDER BY
  id_cod_imp

 --'002,001,002|Tasa,Tasa,Tasa|0.160000,0.100000,0.106667|1,2,2'
 DECLARE @nCoincidencias AS INT
 DECLARE @tip_impto AS INT
 DECLARE @id_tip_impto AS INT
 DECLARE @c_ret AS INT
 DECLARE @c_iva AS INT
 DECLARE @c_exe AS INT
 DECLARE @tasa AS FLOAT

 WHILE EXISTS(SELECT * FROM @tImptosDet WHERE id = @c2)
 BEGIN
  SET @c3 = 0

  WHILE @c3 <  @nPartidas
  BEGIN

   SET @tip_impto = 0
   SET @id_tip_impto = 0
   SET @c_ret = 0
   SET @c_iva = 0
   SET @c_exe = 0
   SET @tasa = 0
   --SELECT * FROM @tTasas --WHERE id = @c3
   IF EXISTS (SELECT * FROM @tTasas WHERE id = @c3)
   BEGIN

  SELECT
   @c_iva = CASE WHEN dat ='002' THEN 1 ELSE 0 END,
   @id_tip_impto = CASE WHEN dat ='002' THEN 15000 WHEN dat ='001' THEN 15001 WHEN dat ='003' THEN 15004 WHEN dat ='NA' THEN 15000 ELSE 0 END --Para NA se vendría IVA(002) o IEPS(003), por default se deja como si fuera IVA
  FROM @tCveImptos WHERE id = @c3

  SELECT
   @tip_impto = CASE WHEN dat ='Tasa' THEN 1 WHEN dat ='Exento' THEN 1 ELSE 2 END,
   @c_exe = CASE WHEN dat = 'Exento' THEN 1 ELSE 0 END
  FROM @tTipoFactor WHERE id = @c3

   IF EXISTS(SELECT * FROM @tTasas WHERE id = @c3 AND (CONVERT(FLOAT, dat)) = 0)
   BEGIN
    SELECT
   @c_iva = CASE WHEN CONVERT(FLOAT,dat) = 0 THEN 0 END
  FROM @tTasas WHERE id = @c3

    SELECT
    @c_exe = CASE WHEN CONVERT(FLOAT,dat) = 0 THEN 1 END
   FROM @tTasas WHERE id = @c3
   END
    SELECT @c_ret = CASE WHEN dat ='1' THEN 0 WHEN dat ='0' THEN 0 WHEN dat IS NULL THEN 0 ELSE 1  END FROM @tTipos WHERE id = @c3
    SELECT @tasa = (CONVERT(FLOAT, dat)) * (CASE WHEN @c_ret = 1 THEN -1 ELSE 1 END )FROM @tTasas WHERE id = @c3

    IF EXISTS (SELECT * FROM @tImptosDet WHERE id = @c2 AND c_iva = @c_iva AND c_ret = @c_ret AND c_exe = @c_exe AND tip_impto = @tip_impto AND id_tip_impto = @id_tip_impto AND ROUND(tasa, 2) = ROUND(@tasa, 2) )
    BEGIN
     DELETE @tImptosDet WHERE id = @c2  GOTO SIGUIENTE
    END
   END

   SET @c3 = @c3 + 1
  END

  SIGUIENTE:
  SET @c2 = @c2 + 1
 END

--SELECT * FROM @tImptosDet
 IF NOT EXISTS(SELECT * FROM @tImptosDet)
 BEGIN
  --select @id_impto_tmp id_impto_tmp, @ids_impto ids_impto
  SET @ids_impto =   @ids_impto + ',' + CONVERT(VARCHAR(5), @id_impto_tmp)
  --SELECT 'PRIMERA BUSQUEDA : ' + @ids_impto
  --GOTO UBICADO
 END


 SET @c1 = @c1 + 1
END

UBICADO:

SET @ids_impto = ISNULL( SUBSTRING(@ids_impto,2, LEN(@ids_impto)), '0')
SET @ids_impto = CASE WHEN LEN(@ids_impto) = 0 THEN '-1' ELSE @ids_impto END

--Select 'Encontro' + @ids_impto

RETURN @ids_impto;
END
--END JPMA
GO

