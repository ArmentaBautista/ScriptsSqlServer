
USE iERP_FNG_CSM
go

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGYCobtenerInfoAvisosCobranza')
BEGIN
	DROP PROC pGYCobtenerInfoAvisosCobranza
	SELECT 'pGYCobtenerInfoAvisosCobranza BORRADO' AS info
END
GO

CREATE PROC pGYCobtenerInfoAvisosCobranza
@FechaCartera AS VARCHAR(8)='19000101',
@Sucursal AS VARCHAR(1000)='*',
@Domicilio AS VARCHAR(max)='*',
@Producto AS VARCHAR(500)='*',
@MoraInicial AS VARCHAR(4)='0',
@MoraFinal AS VARCHAR(4)='9999',
@CodigoRuta AS VARCHAR(20)='*',
@Socio AS VARCHAR(50)='*',
@Empresa VARCHAR(150)='*',
@SqlStatement AS VARCHAR(max)='' OUTPUT,
@TipoOperacion AS VARCHAR(30)='GRID'
AS
BEGIN
		DECLARE @counterFiltros AS INT=0
		DECLARE @temp AS NVARCHAR(max)='';

		IF @Sucursal=''
			SET @Sucursal='*'

		IF @MoraInicial='' OR @MoraInicial='*'
			SET @MoraInicial='0'

		IF @MoraFinal='' OR @MoraFinal='*'
			SET @MoraFinal='9999'

		IF @Socio=''
			SET @Socio='*'

		IF @Domicilio=''
			SET @Domicilio='*'

		IF @Producto=''
			SET @Producto='*'

		IF @Empresa=''
			SET @Empresa='*'

		SET @SqlStatement = 'SELECT ';

		IF @TipoOperacion='ALL'
			SET @SqlStatement=@SqlStatement + ' * '

		IF @TipoOperacion='GRID'
			SET @SqlStatement=@SqlStatement + ' info.Sucursal,info.MoraMaxima,info.Producto,info.ProductoDescripcion,info.socio,info.Domicilio,info.DetalleDomicilioSocio,info.Cuenta,
info.ParcialidadesAtrasadas,info.NombreEmpresa,info.SaldoCapital,info.FechaUltimoPago,info.TotalALiquidar,
info.MontoEntregado,info.CapitalAtrasado,info.InteresOrdinario,info.InteresMoratorio,info.IVA,info.SaldoTotalSinCargos,
info.PlazoVencido,info.EstatusCartera,info.PorcentagePagado,info.Amortizacion,info.AportacionSocial,info.Ahorro,
info.Reciprocidad,info.ProcentajePagadoAmortzacion,info.FechaCartera,info.IdCuenta ' + CHAR(13)
	
	SET @SqlStatement=@SqlStatement + ' FROM dbo.fGYCAvisosCobranzaFNG(''*'',' + @MoraInicial + ',' + @MoraFinal + ',''' + @CodigoRuta + ''',''' + @Socio + ''',''' + @FechaCartera + ''',''*'',''*'',''' + @Empresa + ''') info' + CHAR(13)

		IF @Sucursal<>'*'
		BEGIN
		   SET @temp=REPLACE(@Sucursal,',',''',''');
		   SET @Sucursal= CONCAT(CHAR(39),@temp,CHAR(39));

			IF @counterFiltros=0
				SET @SqlStatement = @SqlStatement + ' WHERE '
			ELSE
				SET @SqlStatement = @SqlStatement + ' AND '
			
			SET @SqlStatement = @SqlStatement + ' info.Sucursal IN (' + @Sucursal + ')'
			SET @counterFiltros=@counterFiltros+1;
        END

		IF @Producto<>'*'
		BEGIN
		   SET @temp=REPLACE(@Producto,',',''',''');
		   SET @Producto= CONCAT(CHAR(39),@temp,CHAR(39));

			IF @counterFiltros=0
				SET @SqlStatement = @SqlStatement + ' WHERE '
			ELSE
				SET @SqlStatement = @SqlStatement + ' AND '
				
			SET @SqlStatement = @SqlStatement + ' info.ProductoDescripcion IN (' + @Producto + ')'
			SET @counterFiltros=@counterFiltros+1;
        END

		IF @Domicilio<>'*'
		BEGIN
		   SET @temp=REPLACE(@Domicilio,',',''',''');
		   SET @Domicilio= CONCAT(CHAR(39),@temp,CHAR(39));

			IF @counterFiltros=0
				SET @SqlStatement = @SqlStatement + ' WHERE '
			ELSE
				SET @SqlStatement = @SqlStatement + ' AND '
				
			SET @SqlStatement = @SqlStatement + ' info.Domicilio IN (' + @Domicilio + ')'
			SET @counterFiltros=@counterFiltros+1;
        END

 PRINT @SqlStatement
EXEC (@SqlStatement)	

-- TEMPLATE SELECT * FROM dbo.fGYCAvisosCobranzaFNG('*',0,9999,'*','*',@FechaCartera,'*','*',@Empresa) info WHERE (@Sucursal='*' OR info.Sucursal IN (@Sucursal))

END