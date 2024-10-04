
USE iERP_FNG
go


DECLARE @SQL AS VARCHAR(MAX)

DECLARE @periodo AS VARCHAR(6)=CONCAT(DATEPART(YYYY,GETDATE()),DATEPART(MM,GETDATE()-30))

	SELECT catmin.id,
		   catmin.IdPeriodo,
		   catmin.IdCatalogoSITI,
		   2 AS IdEmpresa,
		   catmin.Concepto,
		   catmin.Descripcion,
		   catmin.Orden,
		   catmin.Nivel,
		   catmin.Fila,
		   catmin.OrdenR01
	FROM dbo.tSITcatalogoMinimo catmin 
	JOIN dbo.tSITperiodos per ON per.IdPeriodo = catmin.IdPeriodo
	WHERE per.Periodo = @periodo


DECLARE @rfc AS VARCHAR(20)

EXEC pbiobtrfcempresa @rfc OUTPUT

SELECT @rfc 



SELECT * FROM dbo.tCTLperiodos WHERE IdPeriodo=270