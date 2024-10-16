
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pLSTsocios')
BEGIN
	DROP PROC pLSTsocios
END
GO

CREATE PROC [dbo].[pLSTsocios]
@tipoOperacion AS VARCHAR(20)='',
@socio varchar(20)='',
@cadenaBusqueda AS VARCHAR(30)=''	
AS
BEGIN

	
    

	IF @tipoOperacion='IngresoF3'
	BEGIN
		SELECT sc.IdSocio,sc.NoSocio, p.NombreCompleto 
		FROM dbo.tECEsocios sc  WITH(nolock) 
		INNER JOIN dbo.tECEpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
		WHERE p.NombreCompleto LIKE '%' + @cadenaBusqueda + '%' OR sc.NoSocio LIKE '%' + @cadenaBusqueda + '%'
	END
	
	IF @tipoOperacion=''
	begin 
	 select IdSocio, NoSocio as Codigo,Nombre as Descripcion,Domicilio
	 from  tECEsocios  WITH(nolock) 
	 where NoSocio like '%' + @socio+ '%' or Nombre like '%' + @socio + '%'
	END

END







