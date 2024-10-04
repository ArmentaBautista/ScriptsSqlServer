
DECLARE @MensajeError AS VARCHAR(MAX)='';

/********  JCA.2/9/2024.11:17 Info: Creación de la persona, debe actualizarse el IdPersona Física y RelSociosComerciales  ********/
DECLARE @IdPersona_RelSociosComerciales as INTEGER
DECLARE @IdSocioComercial AS INTEGER
DECLARE @IdSocio AS INTEGER

if NOT exists(select 1 from dbo.tGRLpersonas p WITH (NOLOCK) where Nombre='SIMULADOR')
BEGIN
    INSERT INTO dbo.tGRLpersonas (Nombre, RFC,  EsExtranjero, EsPersonaMoral, EsSocio,  IdPersonaMoral, IdPersonaFisica,RelSociosComerciales, IdEstatus, Alta)
    select
    'SIMULADOR',
    'XXXX820101000',
    0,
    0,
    1,
    0,
    0,
    0,
    1,
    GETDATE()

    SET @IdPersona_RelSociosComerciales=SCOPE_IDENTITY();
END
ELSE
BEGIN
    set @IdPersona_RelSociosComerciales= (SELECT idpersona from tGRLpersonas p WITH(NOLOCK) where nombre='SIMULADOR')
END

/********  JCA.2/9/2024.13:35 Info: Creación de Persona física y actualización de persona  ********/
IF NOT exists (select 1 from tgrlpersonasfisicas pf WITH (NOLOCK) WHERE pf.idpersona=@IdPersona_RelSociosComerciales)
BEGIN
    BEGIN TRY
        BEGIN TRAN

            INSERT INTO dbo.tGRLpersonasFisicas
            (
                IdPersonaFisica,
                Nombre,
                ApellidoPaterno,
                ApellidoMaterno,
                FechaNacimiento,
                Sexo,
                IdPersona
            )
            SELECT
                @IdPersona_RelSociosComerciales,
                'SIMULADOR',
                'DE CREDITOS',
                'ERPRISE',
                '19820101',
                'M',
                @IdPersona_RelSociosComerciales

            UPDATE tgrlpersonas SET idpersonafisica=@IdPersona_RelSociosComerciales WHERE idpersona=@IdPersona_RelSociosComerciales

        COMMIT  TRAN
    END TRY
    begin catch

        ROLLBACK TRAN
        SET @MensajeError = concat_ws
        (
            ' | ',
            cast(ERROR_NUMBER() AS VARCHAR(10)),
            ERROR_PROCEDURE(),
            cast(ERROR_LINE() AS VARCHAR(10)),
            ERROR_MESSAGE()
        );
        GOTO final
    end CATCH
END

/********  JCA.2/9/2024.13:36 Info: Creación del Socio comercial y actualización de persona  ********/
IF NOT exists (select 1 from dbo.tSCSsociosComerciales sc WITH (NOLOCK) WHERE sc.RelSociosComerciales=@IdPersona_RelSociosComerciales)
BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
                    INSERT INTO dbo.tSCSsociosComerciales
                    (
                        RelSociosComerciales
                    )
                    SELECT
                        @IdPersona_RelSociosComerciales

                     SET @IdSocioComercial=SCOPE_IDENTITY();

                    UPDATE tgrlpersonas SET RelSociosComerciales=@IdPersona_RelSociosComerciales WHERE idpersona=@IdPersona_RelSociosComerciales

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @MensajeError = concat_ws
                (
                    ' | ',
                    cast(ERROR_NUMBER() AS VARCHAR(10)),
                    ERROR_PROCEDURE(),
                    cast(ERROR_LINE() AS VARCHAR(10)),
                    ERROR_MESSAGE()
                );

            GOTO final
        END CATCH;
END
ELSE
BEGIN
    select @IdSocioComercial=sc.idsociocomercial from dbo.tSCSsociosComerciales sc WITH (NOLOCK) WHERE sc.RelSociosComerciales=@IdPersona_RelSociosComerciales
END

/********  JCA.2/9/2024.13:56 Info: Creación del Socio y actualización del socio comercial  ********/
IF NOT exists(SELECT 1 FROM dbo.tSCSsocios WHERE IdPersona=@IdPersona_RelSociosComerciales)
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE  @IdSucursal AS INTEGER
            SELECT TOP (1) @IdSucursal = sc.IdSucursal
            FROM dbo.tCTLsucursales sc  WITH(NOLOCK)
            INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK)
                ON ea.IdEstatusActual = sc.IdEstatusActual
                    AND ea.IdEstatus=1
            WHERE sc.EsMatriz<>1 AND sc.IdSucursal<>0
            ORDER BY sc.IdSucursal

            INSERT INTO tscssocios (IdSocio,[IdSocioComercial], [IdPersona], [AltaSocio], [FechaAlta], [Codigo], [IdSucursal], [FechaSolicitudIngreso], [IdEstatus], [IdUsuarioAlta], [Alta], [IdTipoDDominio])
            VALUES
            ( @IdSocioComercial,
              @IdSocioComercial,
              @IdPersona_RelSociosComerciales,
              getdate(),
              getdate(),
              'SIM-00000',
              @IdSucursal,
              GETDATE(),
              1,
              -1,
              GETDATE(),
              208 )

            UPDATE sc
            SET sc.IdSocio=@IdSocioComercial
            from tSCSsociosComerciales sc where IdSocioComercial=@IdSocioComercial

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @MensajeError = concat_ws
                (
                    ' | ',
                    cast(ERROR_NUMBER() AS VARCHAR(10)),
                    ERROR_PROCEDURE(),
                    cast(ERROR_LINE() AS VARCHAR(10)),
                    ERROR_MESSAGE()
                );

        GOTO final
    END CATCH;
END

final:
IF (@MensajeError<>'')
begin
    SELECT @MensajeError
END
ELSE
BEGIN
    SELECT
        p.idpersona,
        p.nombre,
        sc.idsocio,
        sc.codigo
    FROM tgrlpersonas p with(nolock)
    INNER JOIN tscssocios sc WITH (nolock)
        ON sc.idpersona=p.idpersona
    WHERE p.idpersona=@IdPersona_RelSociosComerciales
END








