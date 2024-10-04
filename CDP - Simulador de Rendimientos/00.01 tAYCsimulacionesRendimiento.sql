IF (OBJECT_ID('tAYCsimulacionesRendimiento') IS NULL)
    BEGIN
        --DROP table tAYCsimulacionesRendimiento

        CREATE TABLE tAYCsimulacionesRendimiento
        (
            IdSimulacion int IDENTITY PRIMARY KEY ,
            Fecha DATE NOT NULL,
            Sucursal varchar(32),
            IdUsuario int NOT NULL FOREIGN key REFERENCES tCTLusuarios(IdUsuario),
            Udi NUMERIC(5,2),
            MontoExento NUMERIC(11,2),
            TasaIsr NUMERIC(5,3),
            IdSocio int NULL FOREIGN key REFERENCES tSCSsocios(IdSocio),
            TelefonoSocio varchar(64),
            Solicitante varchar(128),
            TelefonoSolicitante varchar(64),
            Monto NUMERIC(11,2),
            Alta DATETIME not NULL DEFAULT current_timestamp
        );

        SELECT 'tAYCsimulacionesRendimiento CREADA' AS info
    END
GO




