
USE iERP_FNG_CSM
GO

 /* 
 SELECT TOP 100 fechacartera FROM tAYCcartera cr  WITH(NOLOCK) 
 GROUP BY cr.FechaCartera ORDER BY cr.FechaCartera DESC
 */

DECLARE @fecha AS DATE='20211009'



--       pGYCobtenerInfoAvisosCobranza

DECLARE @SqlStatement NVARCHAR(MAX);
EXEC dbo.pGYCobtenerInfoAvisosCobranza @FechaCartera = '20211231',          
                                       @Sucursal = '001', -- '001,003',
                                       @Domicilio = '*', --ABEDUL,CIUDAD SAHAGUN',                     
                                       @Producto = 'PRÉSTAMO DIAMANTE', --'PRÉSTAMO DIAMANTE,PRÉSTAMO SOCIO EXCELENTE',                      
                                       @MoraInicial = '1',                   
                                       @MoraFinal = '10',                     
                                       @CodigoRuta = '*',                    
                                       @Socio = '*',  
									   @Empresa ='*',
                                       @SqlStatement = @SqlStatement OUTPUT,
									   @TipoOperacion='GRID'

PRINT @SqlStatement
		
SELECT  info.Sucursal,info.MoraMaxima,info.Producto,info.ProductoDescripcion,info.socio,info.Domicilio,info.DetalleDomicilioSocio,info.Cuenta,
info.ParcialidadesAtrasadas,info.NombreEmpresa,info.SaldoCapital,info.FechaUltimoPago,info.TotalALiquidar,
info.MontoEntregado,info.CapitalAtrasado,info.InteresOrdinario,info.InteresMoratorio,info.IVA,info.SaldoTotalSinCargos,
info.PlazoVencido,info.EstatusCartera,info.PorcentagePagado,info.Amortizacion,info.AportacionSocial,info.Ahorro,
info.Reciprocidad,info.ProcentajePagadoAmortzacion,info.FechaCartera,info.IdCuenta  FROM dbo.fGYCAvisosCobranzaFNG('*',1,10,'*','*','20211231','*','*','*') info WHERE  info.Sucursal IN ('001') AND  info.ProductoDescripcion IN ('PRÉSTAMO DIAMANTE')

 SELECT  *  FROM dbo.fGYCAvisosCobranzaFNG('*',1,10,'*','*','20211231','*','*','*') info WHERE  info.Sucursal IN ('001') AND  info.ProductoDescripcion IN ('PRÉSTAMO DIAMANTE')
		


SELECT  info.Sucursal,info.MoraMaxima,info.Producto,info.ProductoDescripcion,info.socio,info.Domicilio,info.DetalleDomicilioSocio,info.Cuenta,
info.ParcialidadesAtrasadas,info.NombreEmpresa,info.SaldoCapital,info.FechaUltimoPago,info.TotalALiquidar,
info.MontoEntregado,info.CapitalAtrasado,info.InteresOrdinario,info.InteresMoratorio,info.IVA,info.SaldoTotalSinCargos,
info.PlazoVencido,info.EstatusCartera,info.PorcentagePagado,info.Amortizacion,info.AportacionSocial,info.Ahorro,
info.Reciprocidad,info.ProcentajePagadoAmortzacion,info.FechaCartera,info.IdCuenta  FROM dbo.fGYCAvisosCobranzaFNG('*',1,10,'*','*','20211231','*','*','*') info WHERE  info.Sucursal IN ('001','005') AND  info.ProductoDescripcion IN ('PRÉSTAMO DIAMANTE')




