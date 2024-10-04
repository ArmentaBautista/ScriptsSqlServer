IF (OBJECT_ID('pAYCsimuladorRendimientos') IS NOT NULL)
    BEGIN
        DROP PROC pAYCsimuladorRendimientos
        SELECT 'pAYCsimuladorRendimientos BORRADO' AS info
    END
GO

CREATE PROC pAYCsimuladorRendimientos
@RETURN_MESSAGE VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion VARCHAR(16)='',
@pIdSesion INT=0,
@pCadenaBusqueda VARCHAR(16)='',
@pFecha DATE ='19000101',
@pSucursal varchar(32)='',
@pIdUsuario int =0,
@pUdi NUMERIC(5,2)=0,
@pMontoExento NUMERIC(11,2)=0,
@pTasaIsr NUMERIC(5,3)=0,
@pIdSocio int=0,
@pTelefonoSocio varchar(64)='',
@pSolicitante varchar(128)='',
@pTelefonoSolicitante varchar(64)='',
@pMonto NUMERIC(11,2)=0
AS
BEGIN
    IF @pTipoOperacion = ''
        RETURN -1;

    IF @pTipoOperacion = 'GRALES'
    BEGIN
        declare @Udi NUMERIC(5,2),
                @MontoExento NUMERIC(11,2),
                @TasaIsr NUMERIC(5,3)

        DECLARE @grales TABLE
        (
            Fecha DATE,
            Sucursal VARCHAR(32),
            IdUsuario INT,
            Usuario VARCHAR(24),
            Udi NUMERIC(5,2),
            MontoExento NUMERIC(11,2),
            TasaIsr NUMERIC(5,3)
        )

        insert into @grales (Fecha, Sucursal, IdUsuario, Usuario)
        select ss.FechaTrabajo, s.Descripcion,u.IdUsuario, u.Usuario
        from tCTLsesiones ss WITH (NOLOCK)
        inner join dbo.tCTLsucursales s WITH (NOLOCK)
            ON ss.IdSucursal = s.IdSucursal
        inner join tCTLusuarios u WITH (NOLOCK)
            on ss.IdUsuario = u.IdUsuario
        where ss.idsesion=@pIdSesion

        select top 1
        @TasaIsr = TasaRetencionISR
        from tIMPimpuestos i WITH (NOLOCK)
        inner join tCTLestatusActual ea WITH (NOLOCK)
            on i.IdEstatusActual = ea.IdEstatusActual
                and ea.IdEstatus=1
        where i.TasaRetencionISR<>0

        SELECT top 1
        @Udi = d.FactorCompraDestino
        from tDIVfactoresTipoCambio d WITH (NOLOCK)
        inner join dbo.tCTLdivisas dv WITH (NOLOCK)
            ON d.IdDivisaOrigen = dv.IdDivisa
                and dv.IdDivisa=-3
        where d.IdEstatus=1
        order by d.Id DESC

        SELECT @MontoExento =(VecesSalario * 365 )
        FROM dbo.fTBLvecesSalario(5,@pFecha)

        update t
        set t.MontoExento=@MontoExento, t.TasaIsr=@TasaIsr, t.Udi=@Udi
        from @grales t

        SELECT
        Fecha,Sucursal,IdUsuario,Usuario,udi,MontoExento,TasaIsr
        from @grales

        RETURN 0;
    END

    IF @pTipoOperacion = 'SOCIO_F3'
    BEGIN
        DECLARE @personas TABLE
        (
            IdPersona INT,
            Nombre VARCHAR(256),
            Rfc VARCHAR(30),
            Domicilio VARCHAR(512),
            IdRelTelefonos int
        )

        insert into @personas
        select
        p.IdPersona,
        p.Nombre,
        p.rfc,
        p.Domicilio,
        p.IdRelTelefonos
        from tGRLpersonas p WITH (NOLOCK)
        where p.Nombre like '%' + @pCadenaBusqueda + '%'

        SELECT
        IdSocio,
        sc.Codigo as Nosocio,
        p.Nombre,
        p.rfc,
        p.Domicilio,
        x.Telefono
        FROM tSCSsocios sc WITH (NOLOCK)
        inner JOIN @personas p
            on sc.IdPersona = p.IdPersona
        left join (
            select
                tel.IdRel,
                tel.Telefono
            from tCATtelefonos tel WITH (NOLOCK)
            inner join tCTLestatusActual ea WITH (NOLOCK)
                on tel.IdEstatusActual = ea.IdEstatusActual
                    and ea.IdEstatus=1
            INNER JOIN @personas p
                on p.IdRelTelefonos=tel.IdRel
                    and p.IdRelTelefonos<>0
            where tel.IdListaD=-1339
        ) x on x.IdRel=p.IdRelTelefonos
        where sc.IdEstatus=1
            and sc.EsSocioValido=1
                and (sc.Codigo like '%' + @pCadenaBusqueda + '%'
                        OR p.Nombre like '%' + @pCadenaBusqueda + '%')

        RETURN 0;
    END

    IF @pTipoOperacion = 'GRABAR'
    BEGIN
        INSERT INTO tAYCsimulacionesRendimiento (Fecha, Sucursal, IdUsuario, Udi, MontoExento, TasaIsr, IdSocio,
                                                 TelefonoSocio, Solicitante, TelefonoSolicitante, Monto)
        VALUES (@pFecha,@pSucursal, @pIdUsuario, @pUdi, @pMontoExento, @pTasaIsr, @pIdSocio,
                                                 @pTelefonoSocio, @pSolicitante, @pTelefonoSolicitante, @pMonto)

        RETURN 0;
    END

END
GO
