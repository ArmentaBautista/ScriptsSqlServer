IF (OBJECT_ID('pGYCobtenerRutaPorAsentamiento') IS NOT NULL)
        BEGIN
            DROP PROC pGYCobtenerRutaPorAsentamiento
            SELECT 'pGYCobtenerRutaPorAsentamiento BORRADO' AS info
        END
GO

CREATE PROC pGYCobtenerRutaPorAsentamiento
@RETURN_MESSAGE AS VARCHAR(MAX)='' OUTPUT,
@pIdAsentamiento as INT=0,
@pIdRuta AS INT=0 OUTPUT ,
@pRuta AS VARCHAR(12)='' OUTPUT
AS
BEGIN
    DECLARE @rutas AS TABLE (
        IdRuta INT,
        Ruta VARCHAR(12)
                            )

    INSERT INTO @rutas
    SELECT
        re.IdRuta,
        re.Codigo
    FROM tGYCrutasD rd WITH (NOLOCK)
    INNER JOIN tGYCRutas re WITH (NOLOCK)
        ON rd.IdRuta = re.IdRuta
    INNER JOIN tCTLestatusActual ea WITH (NOLOCK)
        ON re.IdEstatusActual = ea.IdEstatusActual
            AND ea.IdEstatus=1
    WHERE rd.IdEstatus=1
        AND rd.IdAsentamiento=@pIdAsentamiento

    DECLARE @NumeroFilas AS INT=(SELECT count(1) FROM @rutas)
    IF (@NumeroFilas>1)
    BEGIN
        SET @RETURN_MESSAGE='El asentamiento del domicilio está en más de una ruta, por favor comuniquelo al depto de Sistemas.'
        RETURN -1
    END

    SELECT
        @pIdAsentamiento=r.IdRuta,
        @pRuta=Ruta
    FROM @rutas r;

    RETURN 0;
END
GO
SELECT 'pGYCobtenerRutaPorAsentamiento creado'
GO

















