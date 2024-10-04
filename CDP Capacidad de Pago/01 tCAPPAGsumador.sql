
-- DROP TABLE tCAPPAGsumador

IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tCAPPAGSumador')
BEGIN

	CREATE TABLE tCAPPAGsumador(				
		IdItem			INT	IDENTITY,
		IdCapacidadPago	INT,
		Año				SMALLINT,			
		Mes				TINYINT,
		Fecha			DATE NOT NULL,			
		Concepto		VARCHAR(160),
		TipoComprobante	VARCHAR(32),
		Monto			NUMERIC(10,2),
		IdEstatus		INT DEFAULT 1,
		IdSesion		INT,

		CONSTRAINT PK_tCAPPAGsumador_IdItem PRIMARY KEY(IdItem),
		CONSTRAINT FK_tCAPPAGsumador_IdCapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES tCAPPAGgenerales(IdCapacidadPago),
		CONSTRAINT FK_tCAPPAGsumador_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus(IdEstatus),
		CONSTRAINT FK_tCAPPAGsumador_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones(IdSesion)
		
		)
END
GO

/* INFO (⊙_☉) JCA.29/11/2023.02:42 p. m. 
Nota: Faltan los parámetros

** Crear parámetro de configuración "Porcentaje de Ingresos a considerar en el Sumador" en el módulo "Capacidad de Pago CDP",
valor por defecto .4
** Los datos de total por mes, promedio, total global, ing mensuales, ingeresos al 40% 
y comparativo deben devolverse mediante una función
*/



