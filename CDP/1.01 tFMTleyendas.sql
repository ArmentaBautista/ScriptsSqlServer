
IF (OBJECT_ID('tFMTleyendas') IS NULL)
    BEGIN
        -- DROP TABLE tFMTleyendas
        create TABLE tFMTleyendas
        (
            IdInforme int,
            IdSucursal INT DEFAULT 0,
            Leyenda1 VARCHAR(256) DEFAULT '',
            Leyenda2 VARCHAR(256) DEFAULT '',
            Leyenda3 VARCHAR(256) DEFAULT '',
            IdEstatus int DEFAULT 1,

            CONSTRAINT FK_tFMTleyendas_IdInforme FOREIGN KEY (IdInforme) REFERENCES tCTLInformes(IdInforme),
            CONSTRAINT FK_tFMTleyendas_IdSucursal FOREIGN KEY (IdSucursal) REFERENCES tCTLsucursales(IdSucursal),
            CONSTRAINT FK_tFMTleyendas_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES tCTLestatus(IdEstatus)
        )

        SELECT 'tFMTleyendas CREADA' AS info
    END
GO


