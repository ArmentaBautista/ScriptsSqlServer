

DECLARE @Hoy AS DATE='20240109'

DECLARE @MontoEnDolares AS NUMERIC(13,2)=3000
DECLARE @Inicio AS DATE
DECLARE @Fin AS DATE

SELECT @Inicio=p.Inicio, @Fin=p.Fin 
FROM dbo.tCTLperiodos p  WITH(NOLOCK) 
WHERE p.EsAjuste=0
	AND @Hoy BETWEEN p.Inicio AND p.Fin

DECLARE @FactorVentaOrigen AS DECIMAL(23,8)  
SELECT @FactorVentaOrigen = FactorVentaOrigen FROM dbo.tDIVfactoresTipoCambio  WITH(NOLOCK) WHERE IdDivisaOrigen=-4 AND fecha=@Hoy

SELECT @Inicio, @Fin, @FactorVentaOrigen

SELECT
 oper.IdPersonaMovimiento,1593,46,SUM(trans.SubTotalGenerado),1,-1,@Hoy,-1,GETDATE(),1598,0,0,0,
 'Suma entrega de remesas en mes calendario = > 3,000 dls',SUM(trans.SubTotalGenerado),socio.IdSocio,0,47,'x'
FROM dbo.tSDOtransacciones trans WITH(NOLOCK)
INNER JOIN dbo.tGRLoperaciones oper WITH(NOLOCK) 
	ON oper.IdOperacion = trans.IdOperacion
		AND oper.IdOperacion != 0
INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) 
	ON persona.IdPersona = oper.IdPersonaMovimiento	
INNER JOIN dbo.tCTLtiposOperacion tco WITH (NOLOCK) 
	ON tco.IdTipoOperacion = oper.IdTipoOperacion
INNER JOIN dbo.tSDOsaldos s WITH (NOLOCK) 
	ON s.IdSaldo = trans.IdSaldoDestino
INNER JOIN dbo.tGRLcuentasABCD abcd WITH (NOLOCK) 
	ON abcd.IdCuentaABCD = s.IdCuentaABCD
INNER JOIN dbo.tCNTauxiliares au WITH (NOLOCK) 
	ON au.IdAuxiliar = s.IdAuxiliar		
INNER JOIN dbo.tCTLsucursales tc WITH (NOLOCK) 
	ON tc.IdSucursal = s.IdSucursal
LEFT JOIN dbo.tCOMconfiguracionPagoServicios remesa  WITH(NOLOCK) 
	ON remesa.IdAuxiliar = au.IdAuxiliar	
LEFT JOIN dbo.tSCSsocios socio 
	ON socio.IdPersona = persona.IdPersona
WHERE trans.IdTipoSubOperacion = 516
	AND (au.IdAuxiliar IN (-4,-3,-5) OR remesa.EsOperacionesRemesas=1)
	AND trans.Fecha BETWEEN @Inicio AND @Fin
		AND NOT EXISTS(SELECT 
						IdTransaccionD 
						FROM dbo.tPLDoperaciones  WITH(NOLOCK) 
						WHERE IdSocio=socio.IdSocio 
							AND IdInusualidad=44 
								AND CAST(alta AS DATE)=@Hoy)
GROUP BY 
oper.IdPersonaMovimiento,
trans.IdTipoSubOperacion,
socio.IdSocio
HAVING ((@FactorVentaOrigen)* SUM(trans.SubTotalGenerado)) >= @MontoEnDolares

