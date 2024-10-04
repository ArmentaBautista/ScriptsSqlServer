
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
                Activaci�n ,
                [Monto Otorgado] ,
                Vencimiento ,
                [Mora M�xima] ,
                [Capital Insoluto] ,
                [Capital Atrasado] ,
                [Inter�s Ordinario] ,
                [IVA Inter�s Ordinario] ,
                [Inter�s Moratorio] ,
                [IVA Inter�s Moratorio] ,
                [Gastos Cobranza Estimados] ,
                [IVA Gastos Cobranza Estimados] ,
                [Para regularizarse] ,
                [Para liquidar] ,
                [D�as Objetivo] ,
                [Abono Requerido] ,
                [Abono Exigible] ,
                [Rango Morosidad] ,
                [En Cartera Vencida] ,
                [Pr�ximo Abono] ,
                Asentamiento ,
                Municipio ,
                Domicilio ,
                [Tel�fono] ,
                Aval1 ,
                Aval2 ,
                Aval3 ,
                Ejecutivo ,
                Promotor,
				[C�digo del Gestor],
				[Gestor],
				[Fecha de Asignaci�n],
				[�ltima Gesti�n],
				[Gestiones Realizadas]= [Numero Gestiones],
				Actividad,
				Resultado,
				Nota,
				[Saldo al D�a],
				[Saldo Exigible],
				[Total a Liquidar],
				[Saldo al D�a Sin Cargos],
				[Saldo Exigible Sin Cargos],
				[Total a Liquidar Sin Cargos],
				EstatusCartera
				,[En Departamento Juridico]
				,[En Proceso Judicial]
				,[Giro Socio]
				,[Ingresos Declarados]
				,[Score Circulo de Credito]
				,[Empresa Convenio]
				,[Correo Electr�nico]
				,[Fecha �ltimo pago de capital]
				,[Monto �ltimo pago de capital]
				,[Fecha �ltimo pago de Inter�s]
				,[Monto �ltimo pago de inter�s]
				,[DiasMora]
        FROM    fAYCconsultarCarteraCobranza(''',CONVERT(VARCHAR,@Fecha,112),''', ''',@Sucursal,''', ''',@Cuenta,''');');
		PRINT	@comando
		EXEC(@comando)
		
    END; 








GO

