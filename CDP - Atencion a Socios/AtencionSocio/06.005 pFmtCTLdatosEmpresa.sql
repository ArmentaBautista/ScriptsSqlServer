IF (OBJECT_ID('pFmtCTLdatosEmpresa') IS NOT NULL)
        BEGIN
            DROP PROC pFmtCTLdatosEmpresa
            SELECT 'pFmtCTLdatosEmpresa BORRADO' AS info
        END
GO

CREATE PROC pFmtCTLdatosEmpresa
AS
BEGIN
    /********  JCA.2/10/2024.13:18 Info: string_agg No funciona en SQL 2014 o menor  ********/

	SELECT
        TOP 1
	    p. Nombre,
	    p. RFC,
	    p. Domicilio,
	    tel. Telefonos
	FROM dbo. tCTLempresas emp  WITH(NOLOCK)
	INNER JOIN dbo. tGRLpersonas p  WITH(NOLOCK)
		ON p. IdEmpresa = emp. IdEmpresa
	CROSS APPLY (
					SELECT
					STRING_AGG(telefono. Telefono,', ') AS Telefonos
					FROM tCATtelefonos telefono WITH(NOLOCK)
					INNER JOIN tCTLestatusActual ea     WITH(NOLOCK)
						ON ea. IdEstatusActual = telefono. IdEstatusActual
							AND ea. IdEstatus = 1
					INNER JOIN tCATlistasD lstipo WITH(NOLOCK)
						ON lstipo. IdListaD    = telefono. IdListaD
					WHERE telefono. IdRel = p. IdRelTelefonos
					) tel
	WHERE emp. IdEmpresa<>0


END
GO
SELECT 'pFmtCTLdatosEmpresa CREADO' AS info
GO
