
-- [9] GetAccountLast5Movements

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountLast5Movements')
BEGIN
	DROP PROC pBKGgetAccountLast5Movements
	SELECT 'pBKGgetAccountLast5Movements BORRADO' AS info
END
GO

CREATE PROC pBKGgetAccountLast5Movements
@ProductBankIdentifier AS VARCHAR(32)
AS
BEGIN

--#region Definicion
/*
MovementId 						int 		Identificador del movimiento
AccountBankIdentifier			string 		Identificador interno de la cuenta
MovementDate 					dateTime 	Fecha del movimiento
Description 					string 		Descripción (que se muestra en posición consolidada)
Amount 							decimal 	Monto del movimiento
isDebit 						boolean 	True si es un movimiento de débito. False si es un movimiento de crédito
Balance 						decimal 	Saldo o balance de la cuenta luego de aplicado el movimiento.
MovementTypeId 					int 		Tipo de movimiento según MovementTypes
TypeDescription 				string 		Descripción del tipo de movimiento
CheckId							string 		Identificador del cheque asociado al movimiento (si corresponde)
VoucherId						string		Identificador del comprobante asociado al movimiento (si corresponde)
*/
--#endregion Definicion

SELECT TOP 5
MovementId 				= o.IdOperacion,
AccountBankIdentifier	= c.Codigo,
MovementDate 			= o.Fecha,
Description 			= c.Descripcion,
Amount 					= tf.MontoSubOperacion,
isDebit 				= IIF(tf.IdTipoSubOperacion=500,0,1),
Balance 				= tf.SaldoCapital,
MovementTypeId 			= tm.IdMovementType,
TypeDescription 		= mov.Descripcion,
CheckId					= 1,
--VoucherId				= CONCAT(tipop.Codigo,'-', o.Folio)
VoucherId				= o.Folio
FROM dbo.tGRLoperaciones o  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tipop  WITH(NOLOCK) ON tipop.IdTipoOperacion = o.IdTipoOperacion
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = o.IdOperacion
															AND tf.IdEstatus=1 
															AND tf.IdTipoSubOperacion IN (500,501)
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta 
											AND c.Codigo=@ProductBankIdentifier
INNER JOIN dbo.tBKGtipoMovimientoMovementTypes tm  WITH(NOLOCK) ON tm.IdTipoMovimiento=tf.IdTipoSubOperacion
INNER JOIN dbo.tBKGcatalogoMovementTypes mov  WITH(NOLOCK) ON mov.Id=tm.IdMovementType
WHERE o.IdTipoOperacion NOT IN (4) AND  o.IdEstatus=1 
ORDER BY o.IdOperacion DESC

END
GO
