
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnSDOhistorialTransaccionesFaltantesSobrantes')
BEGIN
	DROP PROC pCnSDOhistorialTransaccionesFaltantesSobrantes
	SELECT 'pCnSDOhistorialTransaccionesFaltantesSobrantes BORRADO' AS info
END
GO

CREATE PROC pCnSDOhistorialTransaccionesFaltantesSobrantes
    @FechaInicial AS DATE = '19000101',
    @FechaFinal AS DATE = '19000101',
    @Sucursal VARCHAR(100) = '',
    @Usuario VARCHAR(100) = ''
AS
BEGIN
    SELECT Consecutivo = ROW_NUMBER () OVER ( PARTITION BY Transaccion.IdSaldoDestino
                                              ORDER BY Transaccion.Fecha,
                                                       Transaccion.IdTransaccion ),
           [Código Sucursal] = Sucursal.Codigo,
           Sucursal = Sucursal.Descripcion,
           Clase = Clase.Descripcion,
           Naturaleza = CASE Saldo.Naturaleza WHEN 1 THEN 'Deudor'
                                              WHEN -1 THEN 'Acreedor'
                                              ELSE 'NA'
                        END,
           [Operación Padre] = operacionPadre.OperacionPadre,
           [Operación] = operacionPadre.Operacion,
           Operacion.Fecha,
           Período = Periodo.Codigo,
           persona.IdPersona,
           persona.Nombre,
           AuxiliarCodigo = Auxiliar.Codigo,
           [Tipo de Saldo] = Auxiliar.Descripcion,
           [Código Saldo] = Saldo.Codigo,
           [Descripción Saldo] = Saldo.Descripcion,
           Transaccion.Concepto,
           Transaccion.Referencia,
           [Saldo Inicial] = Transaccion.SaldoAnterior,
           Depósito = Transaccion.TotalCargos,
           Retiro = Transaccion.TotalAbonos,
           Transaccion.Saldo,
           [Salvo Buen Cobro] = Transaccion.SalvoBuenCobro,
           [Saldo Conciliado] = Transaccion.SaldoConciliado,
           Usuario.Usuario
    FROM dbo.tSDOsaldos AS Saldo WITH ( NOLOCK )
    INNER JOIN dbo.tCTLtiposD AS Clase WITH ( NOLOCK ) ON Clase.IdTipoD = Saldo.IdTipoDclase
    INNER JOIN dbo.tSDOtransacciones AS Transaccion WITH ( NOLOCK ) ON Saldo.IdSaldo = Transaccion.IdSaldoDestino
    INNER JOIN dbo.tGRLoperaciones AS Operacion WITH ( NOLOCK ) ON Transaccion.IdOperacion = Operacion.IdOperacion
    INNER JOIN dbo.vGRLoperacionesPadrePoliza AS operacionPadre WITH ( NOLOCK ) ON Operacion.IdOperacion = operacionPadre.IdOperacion
    INNER JOIN dbo.tCTLtiposOperacion AS TipoOperacion WITH ( NOLOCK ) ON Operacion.IdTipoOperacion = TipoOperacion.IdTipoOperacion
    INNER JOIN dbo.tCTLperiodos AS Periodo WITH ( NOLOCK ) ON Operacion.IdPeriodo = Periodo.IdPeriodo
    INNER JOIN dbo.tCTLsucursales AS Sucursal WITH ( NOLOCK ) ON Saldo.IdSucursal = Sucursal.IdSucursal
    INNER JOIN dbo.tCTLusuarios AS Usuario WITH ( NOLOCK ) ON Operacion.IdUsuarioAlta = Usuario.IdUsuario
    INNER JOIN dbo.tCNTauxiliares AS Auxiliar WITH ( NOLOCK ) ON Saldo.IdAuxiliar = Auxiliar.IdAuxiliar
	AND Auxiliar.IdAuxiliar IN (-1,-2)
    INNER JOIN dbo.tGRLpersonas AS persona WITH ( NOLOCK ) ON persona.IdPersona = Saldo.IdPersona
    WHERE operacionPadre.IdOperacion != 0 
	AND NOT Transaccion.IdEstatus IN (18) 
	AND ( Operacion.Fecha BETWEEN @FechaInicial AND @FechaFinal 
	AND ( [Sucursal].Codigo = @Sucursal OR @Sucursal = '*' )  
	AND ( Usuario.Usuario = @Usuario OR @Usuario = '*' ))
    ORDER BY Fecha;
END;
GO

