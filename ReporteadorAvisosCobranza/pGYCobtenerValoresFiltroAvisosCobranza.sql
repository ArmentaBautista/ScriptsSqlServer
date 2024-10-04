
USE iERP_FNG_CSM
go

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGYCobtenerValoresFiltroAvisosCobranza')
BEGIN
	DROP PROC pGYCobtenerValoresFiltroAvisosCobranza
	SELECT 'pGYCobtenerValoresFiltroAvisosCobranza BORRADO' AS info
END
GO

CREATE PROC pGYCobtenerValoresFiltroAvisosCobranza
@FechaCartera AS VARCHAR(8)='19000101',
@NombreFiltro AS VARCHAR(50)='',
@NombreFiltroPadre AS VARCHAR(50)='',
@ValorFiltroPadre AS NVARCHAR(max)=''
AS
BEGIN
	
	DECLARE @query AS NVARCHAR(max)='';

	IF(@NombreFiltroPadre='')
	BEGIN
		
		SET @query ='Select val.' + @NombreFiltro + ' FROM dbo.fGYCvaloresFiltrosAvisosCobranza(''' + @FechaCartera + ''') val 
					 GROUP BY val.' + @NombreFiltro + ' ORDER BY val.' + @NombreFiltro


    END
	ELSE
    BEGIN
	   
	   PRINT @ValorFiltroPadre
	   DECLARE @temp AS NVARCHAR(max);
	   SET @temp=REPLACE(@ValorFiltroPadre,',',''',''');
	   SET @ValorFiltroPadre=@temp
	   SET @ValorFiltroPadre= CONCAT(CHAR(39),@temp,CHAR(39));
	   PRINT @ValorFiltroPadre
	   

       SET @query ='Select val.' + @NombreFiltro + ' FROM dbo.fGYCvaloresFiltrosAvisosCobranza(''' + @FechaCartera + ''') val  
					 WHERE val.' + @NombreFiltroPadre + ' in (' + @ValorFiltroPadre + ')
					 GROUP BY val.' + @NombreFiltro + ' ORDER BY val.' + @NombreFiltro
	END

	PRINT @query;
	
	 
	EXECUTE sp_executesql @stmt=@query;

END