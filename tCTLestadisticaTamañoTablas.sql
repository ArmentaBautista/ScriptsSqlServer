

CREATE TABLE tCTLestadisticaTamañoTablas
(
	Id		  int PRIMARY KEY identity, 
	BaseDatos varchar(30) NULL,
	Tabla	  VARCHAR(50) null,
	Registros BIGINT null,
	KB		  BIGINT null,
	MB		  BIGINT null,
	GB		  BIGINT null,
	Alta	  DATETIME DEFAULT GETDATE() NOT NULL
)
