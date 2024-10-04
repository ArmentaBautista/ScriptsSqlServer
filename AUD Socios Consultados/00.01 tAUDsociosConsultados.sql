-- 00.01 tAUDsociosConsultados
IF (OBJECT_ID('tAUDsociosConsultados') IS NULL)
BEGIN
    CREATE TABLE tAUDsociosConsultados
    (
        IdSocioConsultado INT IDENTITY
            CONSTRAINT PK_tAUDsociosConsultados_IdSocioConsultado
                PRIMARY KEY,
        IdSocio           INT
            CONSTRAINT FK_tAUDsociosConsultados_IdSocio
                REFERENCES tSCSsocios(IdSocio),
        NoSocio           VARCHAR(32),
        IdSesion          INT
            CONSTRAINT FK_tAUDsociosConsultados_IdSesion
                REFERENCES tCTLsesiones(IdSesion),
        Fecha             DATE
            CONSTRAINT DF_tAUDsociosConsultados_Fecha DEFAULT GETDATE(),
        Hora              TIME
            CONSTRAINT DF_tAUDsociosConsultados_Hora DEFAULT GETDATE()
    )

    SELECT 'Tablas creada'
END
SELECT 'Tabla ya existe'
GO
