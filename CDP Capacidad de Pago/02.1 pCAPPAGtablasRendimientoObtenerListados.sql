
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAGtablasRendimientoObtenerListados')
BEGIN
	DROP PROC pCAPPAGtablasRendimientoObtenerListados
	SELECT 'pCAPPAGtablasRendimientoObtenerListados BORRADO' AS info
END
GO

CREATE PROCEDURE pCAPPAGtablasRendimientoObtenerListados
	@TipoOperacion	VARCHAR(11)='',
    @Clase VARCHAR(32) ='',
    @Cultivo VARCHAR(32) ='',
    @Modalidad VARCHAR(32) ='',
    @Region VARCHAR(56) =''
AS
BEGIN
	IF @TipoOperacion=''
		RETURN 0

    -- 1. Devuelve una lista del campo Clase
    IF @TipoOperacion='CLASE'
    BEGIN
        SELECT Clase
        FROM dbo.tCAPPAGtablasRendimiento  WITH(NOLOCK)
		WHERE IdEstatus=1 
		GROUP BY Clase
        RETURN 1;
    END

    -- 2. Devuelve una lista del campo Cultivo filtrado por la Clase
    IF @TipoOperacion='CULTIVO'
    BEGIN
        SELECT Cultivo
        FROM dbo.tCAPPAGtablasRendimiento  WITH(NOLOCK)
		WHERE IdEstatus=1 
			AND Clase=@Clase
		GROUP BY Cultivo
        RETURN 1;
    END

    -- 3. Devuelve una lista del campo Modalidad filtrado por el Cultivo
    IF @TipoOperacion='MODALIDAD'
    BEGIN
        SELECT Modalidad
        FROM dbo.tCAPPAGtablasRendimiento  WITH(NOLOCK)
		WHERE IdEstatus=1 
			AND Clase=@Clase
				AND Cultivo=@Cultivo
		GROUP BY Modalidad
        RETURN 1;
    END

    -- 4. Devuelve una lista del campo Region filtrado por la Modalidad
    IF @TipoOperacion='REGION'
    BEGIN
        SELECT Region
        FROM dbo.tCAPPAGtablasRendimiento  WITH(NOLOCK) 
        WHERE IdEstatus=1 
			AND Clase=@Clase
				AND Cultivo=@Cultivo
					AND Modalidad=@Modalidad
		GROUP BY Region
        RETURN 1;
    END

    -- 5. Devuelve resultados filtrando por Clase, Cultivo, Modalidad y Region
    IF @TipoOperacion='RENDIMIENTO'
    BEGIN
        SELECT t.IdRendimiento,
               t.Clase,
               t.Cultivo,
               t.Modalidad,
               t.Region,
               t.Ciclo,
               t.CicloVegetativoMeses,
               t.CiclosPorAño,
               t.RendimientoTonelada,
               t.PrecioVentaInpc,
               t.CostosProduccionInpp,
               t.IngresoHa,
               t.Utilidad,
               t.Factor,
               t.Vigencia,
               t.Fecha,
               t.Alta,
               t.IdEstatus
        FROM dbo.tCAPPAGtablasRendimiento t  WITH(NOLOCK) 
        WHERE Clase = @Clase 
			AND Cultivo = @Cultivo 
				AND Modalidad = @Modalidad 
					AND Region = @Region;
        RETURN 1;
    END

END;

