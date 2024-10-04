


if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1428)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1428, N'INE', N'INAPAM', N'Tarjeta INAPAM', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1429)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1429, N'CIMSS', N'Credencial o Carnet IMSS', N'Credencial o Carnet IMSS', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1430)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1430, N'CONSUL', N'Certificado de Matrícula Consular', N'Certificado de Matrícula Consular', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1431)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1431, N'TUIM', N'Tarjeta Única de Identidad Militar', N'Tarjeta Única de Identidad Militar', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1432)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1432, N'CFEM', N'Credencial Federal, Estatal, Municipal', N'Credencial Federal, Estatal, Municipal', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

if not exists(select 1 from tCATlistasD d WITH (NOLOCK) where d.idlistad=-1433)
BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    set IDENTITY_INSERT tCATlistasD ON

    INSERT INTO dbo.tCATlistasD (IdListaD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdListaDPadre, IdTipoDAgrupador, IdTipoDDominioPrincipal, IdEstatusActual, ValorSimple, Orden, RangoInicio, RangoFin, Valor, IdCatalogoSITI, IdTipoDpadre, IdCatalogoBanxico, EsInmueble)
    VALUES  (-1433, N'CIDENT', N'Constancia de Identidad Municipal', N'Constancia de Identidad Municipal', 173, 0, 0, 0, @idEstatusActual, 0.00000000, 1, 0.00000000, 0.00000000, 0.00000000, 0, 0, 0, NULL);

    set IDENTITY_INSERT tCATlistasD OFF
END
GO

BEGIN
    DECLARE @idEstatusActual INT=0
    INSERT INTO dbo.tCTLestatusActual (IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio,
                                       IdTipoDDominio, IdObservacionE, IdObservacionEDominio, IdSesion, IdControl)
    VALUES (1, 0, N'2015-06-19 00:00:00.000', 0, N'2023-07-05 23:00:00.240', 212, 0, 0, 0, 0);
    set @idEstatusActual = scope_identity()

    update ld set ld.IdEstatusActual=@idEstatusActual
    from tcatlistasd ld
    where idlistad=-31

    update ea set ea.IdEstatus=2
    from tcatlistasd ld
    INNER JOIN tCTLestatusActual ea
        on ld.IdEstatusActual = ea.IdEstatusActual
    where idlistad=-31
END
GO

update ea set ea.IdEstatus=1
from tcatlistasd ld
INNER JOIN tCTLestatusActual ea
    on ld.IdEstatusActual = ea.IdEstatusActual
where idlistad=-1357
GO


select
    ld.IdListaD, ld.Codigo, ld.Descripcion, ea.idestatus, ld.idestatusactual
from tCATlistasD ld WITH (NOLOCK)
inner join tCTLestatusActual ea WITH (NOLOCK)
    on ea.idestatusactual=ld.idestatusactual
        --and ea.IdEstatus=1
where IdTipoE=173

