
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCconsultarCarteraCobranza')
BEGIN
	DROP PROC pCnAYCconsultarCarteraCobranza
	SELECT 'pCnAYCconsultarCarteraCobranza BORRADO' AS info
END
GO

CREATE PROC dbo.pCnAYCconsultarCarteraCobranza
    @Fecha DATE ,
    @Sucursal VARCHAR(12) ,
    @Cuenta VARCHAR(12)
AS
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    begin
        DECLARE @comando VARCHAR(MAX)=''
		set @comando =concat('SELECT  IdCuenta ,
                Socio ,
                [Nombre Socio] ,
                Producto ,
                Cuenta ,
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
				,[En Departamento Juridico]
				,[En Proceso Judicial]
				,[Giro Socio]
				,[Ingresos Declarados]
				,[Score Circulo de Credito]
				,[Empresa Convenio]
				,[Correo Electrónico]
				,[Fecha último pago de capital]
				,[Monto último pago de capital]
				,[Fecha último pago de Interés]
				,[Monto último pago de interés]
				,[DiasMora]
        FROM    fAYCconsultarCarteraCobranza(''',CONVERT(VARCHAR,@Fecha,112),''', ''',@Sucursal,''', ''',@Cuenta,''');');
		PRINT	@comando
		EXEC(@comando)
		
    END; 








GO

