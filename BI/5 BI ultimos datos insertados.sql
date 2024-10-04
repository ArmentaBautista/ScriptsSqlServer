
use ierp_bi
go

DECLARE @fechaActual AS DATETIME =GETDATE()

DECLARE @mes AS INT=DATEPART(MM,@fechaActual - 30)
DECLARE @año AS INT=0

		IF @mes=12
		BEGIN	
			SET @año=DATEPART(YYYY,@fechaActual -365)
		END
		ELSE
		BEGIN
			SET @año=DATEPART(YYYY,@fechaActual)
		END

		--DECLARE @periodo AS VARCHAR(6)=CONCAT(@año,@mes)     
		DECLARE @periodo AS VARCHAR(6)=CONCAT(@año,FORMAT(@mes,'00'))     

		SELECT @periodo AS PeriodoAconsultar

		SELECT * FROM iERP_KFT.dbo.tCTLperiodos per  WITH(nolock) WHERE REPLACE(per.Codigo,'-','') =@periodo

		DECLARE @ultimoPeriodo AS INT
		SELECT @ultimoPeriodo= MAX(IdPeriodo) FROM dbo.tSITcatalogoMinimo 
		
		SELECT *FROM dbo.tSITcatalogoMinimo t  WITH(nolock) WHERE t.IdPeriodo=@ultimoPeriodo

		SELECT * FROM dbo.tSITcatalogoMinimoSaldos WHERE IdPeriodo=@ultimoPeriodo

		SELECT * FROM dbo.tBSIsucursales WHERE Periodo=@periodo




