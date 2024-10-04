
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketTransaccionBKG')
BEGIN
	drop view vFMTticketTransaccionBKG
	SELECT 'vFMTticketTransaccionBKG BORRADO' AS info
END
GO

CREATE VIEW dbo.vFMTticketTransaccionBKG
AS
SELECT	Persona.Nombre,
		Saldo.Codigo,
		Saldo.Descripcion,
		Operacion	= TipoOp.Descripcion,
		Transaccion.Concepto,
		Transaccion.Referencia,
		Monto = CASE WHEN Transaccion.Naturaleza = 1 THEN 
					Transaccion.TotalCargos 
				ELSE 
					Transaccion.TotalAbonos 
				END,
		Transaccion.IdOperacion,
		Transaccion.IdTransaccion

FROM	tGRLoperaciones		Operacion	WITH (NOLOCK) INNER JOIN
		tSDOtransacciones	Transaccion	WITH (NOLOCK) ON Operacion.IdOperacion = Transaccion.IdOperacion INNER JOIN
		tSDOsaldos			Saldo		WITH (NOLOCK) ON Saldo.IdSaldo = Transaccion.IdSaldoDestino INNER JOIN
		tGRLpersonas		Persona		WITH (NOLOCK) ON Persona.IdPersona = Saldo.IdPersona INNER JOIN
		tCTLtiposOperacion	TipoOp		WITH (NOLOCK) ON TipoOp.IdTipoOperacion = Transaccion.IdTipoSubOperacion 

WHERE	--Operacion.IdTipoOperacion in (1,71) and 
NOT Saldo.IdCuentaABCD = Operacion.IdCuentaABCD AND Transaccion.IdEstatus = 1
	

GO


