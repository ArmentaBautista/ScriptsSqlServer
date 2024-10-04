
if not exists(select 1
				FROM sys.indexes i 
				WHERE i.name='IX_tSDOtransaccionesFinancieras_INC_IdOperacion_IdCuenta' 
					AND i.object_id=OBJECT_ID('tSDOtransaccionesFinancieras'))
BEGIN
	CREATE NONCLUSTERED INDEX IX_tSDOtransaccionesFinancieras_INC_IdOperacion_IdCuenta
	ON [dbo].[tSDOtransaccionesFinancieras] ([IdEstatus])
	INCLUDE ([IdOperacion],[IdCuenta])

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('IX_tSDOtransaccionesFinancieras_INC_IdOperacion_IdCuenta')

	SELECT 'Indice creado' AS info
END
GO