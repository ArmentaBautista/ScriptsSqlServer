USE [iERP_AMEC]
GO
/****** Object:  Trigger [dbo].[trValidarRFC]    Script Date: 06/09/2023 01:23:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[trValidarRFC] ON [dbo].[tGRLpersonas]
AFTER INSERT, UPDATE
AS
BEGIN

    IF UPDATE(RFC) OR NOT EXISTS(SELECT I.IdPersona FROM Deleted D INNER JOIN Inserted I ON I.IdPersona = D.IdPersona)
    BEGIN

        DECLARE @RFC AS VARCHAR(30);
        DECLARE @EsExtranjero AS BIT;
        DECLARE @EsPersonaMoral AS BIT;
        DECLARE @IdPersona AS INT = 0;
		DECLARE @PersonaNombre AS VARCHAR(1024)      

        DECLARE @IdReferenciaPersonal INT;
        DECLARE @RelReferenciasPersonales INT;
        DECLARE @IdEstatus INT;


        SELECT @IdPersona = I.IdPersona, @PersonaNombre = I.Nombre,
               @RFC = I.RFC,
               @EsExtranjero = I.EsExtranjero,
               @EsPersonaMoral = I.EsPersonaMoral
        FROM INSERTED I;

        SELECT @IdReferenciaPersonal = ReferenciaPersonal.IdReferenciaPersonal,
               @RelReferenciasPersonales = ReferenciaPersonal.RelReferenciasPersonales,
               @IdEstatus = EstatusActual.IdEstatus
        FROM dbo.vGRLpersonas Persona WITH (NOLOCK)
            INNER JOIN dbo.tSCSpersonasFisicasReferencias ReferenciaPersonal WITH (NOLOCK) ON Persona.IdPersona = ReferenciaPersonal.IdPersona
            INNER JOIN dbo.vCTLestatusActual				   EstatusActual WITH (NOLOCK) ON ReferenciaPersonal.IdEstatusActual = EstatusActual.IdEstatusActual
        WHERE Persona.IdPersona = @IdPersona;

        IF NOT @RFC IN ('XAXX010101000', 'XEXX010101000')
        BEGIN

            /*valida si ya existe algún rfc identico registrado*/
            DECLARE @count AS INT = (
                                        SELECT COUNT(Persona.RFC)
                                        FROM dbo.tGRLpersonas Persona WITH (NOLOCK)
                                        INNER JOIN Inserted			I WITH (NOLOCK) ON I.IdPersona = Persona.IdPersona
                                        WHERE I.IdEstatus = 1 AND Persona.IdEstatus = 1 AND Persona.RFC = I.RFC AND Persona.IdPersona <> I.IdPersona AND LEN(I.RFC) > 0
                                    );

            IF @count > 0
            BEGIN
                RAISERROR('CodEx|01694|trValidarRFC|%s ', 16, 8, @PersonaNombre);
            END;

            /*valida que la persona no sea estranjero*/

            IF @EsExtranjero = 0
            BEGIN
                /*valida si es una persona moral y el tamaño debe ser de 12 caracteres*/
                IF @EsPersonaMoral = 1 AND LEN(@RFC) <> 12
                BEGIN
                    RAISERROR('CodEx|01718|trValidarRFC|%s ', 16, 8, @PersonaNombre);
                END;


                /*valida si es una persona física y el tamaño debe ser de 13 caracteres*/
                IF NOT LEN(@RFC) = ''
                BEGIN
                    IF @EsPersonaMoral = 0
                       AND LEN(@RFC) <> 13
                    BEGIN
                        RAISERROR('CodEx|01718|trValidarRFC|%s ', 16, 8, @PersonaNombre);
                    END;
                END;

            END;
        END;
    END;
END;

