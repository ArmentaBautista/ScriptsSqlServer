
USE iERP_DRA_REG
GO


DECLARE @mes AS INT=DATEPART(MM,GETDATE()-30)
DECLARE @a�o AS INT=0

IF @mes=12
BEGIN	
	SET @a�o=DATEPART(YYYY,GETDATE()-365)
END
ELSE
BEGIN
	SET @a�o=DATEPART(YYYY,GETDATE())
END

DECLARE @periodo AS VARCHAR(6)=CONCAT(@a�o,@mes)     

SELECT @periodo

SELECT IdPeriodo,         
IdCatalogoSITI,         
Periodo,            
2 AS IdEmpresa,         
Importe,         
Saldo,         
IdSucursal   
FROM dbo.tSITcatalogoMinimoSaldosFinancieros   
WHERE Periodo = @periodo