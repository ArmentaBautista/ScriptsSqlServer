
DECLARE @pPeriodoInicial INT='2022-01'
DECLARE @pPeriodoFinal INT='2022-12'

DECLARE @IdPeriodoInicial INT=(SELECT p.IdPeriodo FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Codigo=@pPeriodoInicial)
DECLARE @IdPeriodoFinal INT=(SELECT p.IdPeriodo FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.Codigo=@pPeriodoFinal)

/* ฅ^•ﻌ•^ฅ   JCA.12/09/2023.09:00 a. m. Nota: Vamos por las cuentas primero 144 y 398  */
DECLARE @ctas TABLE(
	IdCuenta	INT PRIMARY KEY,
	IdSocio		INT,
	IdTipoDproducto	INT
)

INSERT INTO @ctas (IdCuenta,IdSocio,IdTipoDproducto)
SELECT 
c.IdCuenta, 
c.IdSocio, 
c.IdTipoDProducto 
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSDOhistorialAcreedoras ha  WITH(NOLOCK)
	ON ha.IdPeriodo=@IdPeriodoInicial
WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (144,398)

