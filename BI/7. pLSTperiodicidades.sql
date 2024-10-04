

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pLSTperiodicidades')
BEGIN
	DROP PROC pLSTperiodicidades
END
GO

CREATE PROC pLSTperiodicidades
@TipoOperacion VARCHAR(25)=''
AS
BEGIN
	
	IF @TipoOperacion='ACTIVAS'
	BEGIN
		SELECT pe.IdPeriodicidad,pe.Codigo,pe.Descripcion 
		FROM dbo.tCTLperiodidadesEjecucion pe  WITH(nolock)     
		WHERE pe.IdEstatus=1
	END
	
END
