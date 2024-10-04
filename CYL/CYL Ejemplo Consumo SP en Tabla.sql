

CREATE TABLE #MiTabla (
    Sucursal NVARCHAR(255),
    ClaveSocio NVARCHAR(50),
    Nombre NVARCHAR(255),
    Referencia NVARCHAR(255),
    TipoPrestamo NVARCHAR(100),
    Finalidad NVARCHAR(255),
    TipoEstimacion NVARCHAR(100),
    Frecuencia NVARCHAR(100),
    MontoOtorgado DECIMAL(18, 2),
    FechaOtorgamiento DATE,
    FechaVencimiento DATE,
    Cobrador NVARCHAR(255),
    FinalidadOperativa NVARCHAR(255),
    CierreCapitalVigente DECIMAL(18, 2),
    CierreCapitalVencido DECIMAL(18, 2),
    CierreDiasMoraCapital INT,
    CierreDiasMoraInteresOrdinario INT,
    CierreDiasMoraInteresMoratorio INT,
    CierreDiasMoraREG INT,
    CierreFecha DATE,
    ActualCapitalVigente DECIMAL(18, 2),
    ActualCapitalVencido DECIMAL(18, 2),
    ActualDiasMoraCapital INT,
    ActualDiasMoraInteresOrdinario INT,
    ActualDiasMoraInteresMoratorio INT,
    ActualDiasMoraREG INT,
    ActualCategoria NVARCHAR(100),
    ActualFecha DATE,
    Conteo INT
);

insert into #MiTabla
exec dbo.pAYCanalisisCartera @Sucursal = '002';

select sc.IdSocio, * 
from #MiTabla mt
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.Codigo=mt.ClaveSocio



drop table #MiTabla

