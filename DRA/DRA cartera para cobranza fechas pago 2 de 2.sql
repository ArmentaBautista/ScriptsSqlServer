SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



ALTER PROCEDURE dbo.pCnAYCconsultarCarteraCobranza
    @Fecha DATE ,
    @Sucursal VARCHAR(12) ,
    @Cuenta VARCHAR(12)
AS
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN
        DECLARE @comando VARCHAR(MAX)=''
		SET @comando =CONCAT('SELECT  IdCuenta ,
                Socio ,
                [Nombre Socio] ,
                Producto ,
                Cuenta ,
				TipoCartera,
				Emproblemado,
                Sucursal ,
                Activación ,
                [Monto Otorgado] ,
                Vencimiento ,
                [Mora Máxima] ,
                [Capital Insoluto] ,
                [Capital Atrasado] ,
                [Interés Ordinario] ,
                [IVA Interés Ordinario] ,
                [Interés Moratorio] ,
                [IVA Interés Moratorio] ,
                [Gastos Cobranza Estimados] ,
                [IVA Gastos Cobranza Estimados] ,
                [Para regularizarse] ,
                [Para liquidar] ,
                [Días Objetivo] ,
                [Abono Requerido] ,
                [Abono Exigible] ,
                [Rango Morosidad] ,
                [En Cartera Vencida] ,
                [Próximo Abono] ,
				PrimerVencimientoPendienteInteres,
				PrimerVencimientoPendienteCapital,
                Asentamiento ,
                Municipio ,
                Domicilio ,
                [Teléfono] ,
                Aval1 ,
                Aval2 ,
                Aval3 ,
                Ejecutivo ,
                Promotor,
				[Código del Gestor],
				[Gestor],
				[Fecha de Asignación],
				[Última Gestión],
				[Gestiones Realizadas]= [Numero Gestiones],
				Actividad,
				Resultado,
				Nota,
				[Saldo al Día],
				[Saldo Exigible],
				[Total a Liquidar],
				[Saldo al Día Sin Cargos],
				[Saldo Exigible Sin Cargos],
				[Total a Liquidar Sin Cargos],
				EstatusCartera
        FROM    fAYCconsultarCarteraCobranza(''',CONVERT(VARCHAR,@Fecha,112),''', ''',@Sucursal,''', ''',@Cuenta,''');');
		PRINT	@comando
		EXEC(@comando)
		
    END; 



GO

