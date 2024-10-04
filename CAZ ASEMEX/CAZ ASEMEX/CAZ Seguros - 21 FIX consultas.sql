

BEGIN TRY
/* @^..^@   JCA.21/02/2024.01:50 p. m. Nota: Se reemplaza el sp utilizado, solo cambio el nombre   */
	
	update cn set cn.SQL='EXEC dbo.pASEMEXreporteContratosSegurosVida @Periodo, @pTipo = 3'
	from dbo.tCTLconsultas cn where cn.IdConsulta=7433

	update cn set cn.SQL='EXEC dbo.pASEMEXreporteContratosSegurosVida @Periodo, @pTipo = 2'
	from dbo.tCTLconsultas cn where cn.IdConsulta=7434

	update cn set cn.SQL='EXEC dbo.pASEMEXreporteContratosSegurosVida @Periodo, @pTipo = 1'
	from dbo.tCTLconsultas cn where cn.IdConsulta=7435
	
END TRY
BEGIN CATCH
	
	 SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
	
END CATCH;

