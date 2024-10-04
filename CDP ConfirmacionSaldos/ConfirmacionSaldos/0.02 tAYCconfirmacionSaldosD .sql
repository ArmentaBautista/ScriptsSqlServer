/* JCA.17/4/2024.02:51 
Nota: Tabla para el detalle de las cuentas de la Confirmación de saldos y la respuesta del Socio
*/

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAYCconfirmacionSaldosD')
BEGIN
	CREATE TABLE [dbo].[tAYCconfirmacionSaldosD]
	(
		IdConfirmacionSaldosD 					INT NOT NULL PRIMARY KEY IDENTITY,
		IdConfirmacionSaldos					INT NOT NULL,
		IdCuenta								INT	NOT NULL,
		IdTipoDproducto							INT NOT NULL,
		Capital									NUMERIC(12,2) NULL,
		InteresOrdinarioAlDia					NUMERIC(12,2) NULL,
		InteresMoratorio						NUMERIC(12,2) NULL,
		Saldo									NUMERIC(12,2) NULL,
		EstaConforme							BIT NOT NULL DEFAULT 0,
		UltimoCambio							DATETIME NOT NULL DEFAULT GETDATE()	
	) 

	SELECT 'Tabla Creada tAYCconfirmacionSaldosD' AS info
	
	ALTER TABLE dbo.tAYCconfirmacionSaldosD 
	ADD CONSTRAINT FK_tAYCconfirmacionSaldosD_IdConfirmacionSaldos 
	FOREIGN KEY (IdConfirmacionSaldos) REFERENCES dbo.tAYCconfirmacionSaldosE (IdConfirmacionSaldos)
	
	ALTER TABLE dbo.tAYCconfirmacionSaldosD
	ADD CONSTRAINT FK_tAYCconfirmacionSaldosD_IdCuenta
	FOREIGN KEY (IdCuenta) REFERENCES dbo.tAYCcuentas(IdCuenta)

	ALTER TABLE dbo.tAYCconfirmacionSaldosD
	ADD CONSTRAINT FK_tAYCconfirmacionSaldosD_IdTipoDproducto
	FOREIGN KEY (IdTipoDproducto) REFERENCES dbo.tCTLtiposD(IdTipoD)

END
ELSE 
	-- DROP TABLE tAYCconfirmacionSaldosD
	SELECT 'tAYCconfirmacionSaldosD Existe'
GO