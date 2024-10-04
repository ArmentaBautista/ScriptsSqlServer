
declare @FolioApertura as int=137098

declare @IdSocio as int=0
declare @NoSocio as varchar(20)=''
declare @IdApertura as int=0
declare @IdCuenta as int=0
declare @MontoSolicitado as numeric(13,2)=0
declare @FechaTrabajo as date=getdate()

select @IdApertura=a.IdApertura, @IdSocio=a.IdSocio, @MontoSolicitado=a.MontoSolicitado, @IdCuenta = c.IdCuenta
from dbo.tAYCaperturas a  with(nolock) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	on c.IdApertura = a.IdApertura
where a.Folio=@FolioApertura

/********  JCA.3/3/2024.22:29 Info:Datos del Socio  ********/
declare @socio as table(
	IdSocio int primary key, 
	NoSocio varchar(20), 
	IdPersona int, 
	Nombre varchar(250)
)

insert into @socio
SELECT sc.IdSocio, sc.Codigo, p.IdPersona, p.Nombre
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE sc.IdSocio=@IdSocio

/********  JCA.3/3/2024.22:35 Info:Avalados del Socio  ********/
declare @avalados as table(
	IdAval	int,
	RelAvales	int,
	IdPersona	int,
	IdSocio		int,
	Porcentaje	numeric(3,2)
)

insert into @avalados
select aval.IdAval, aval.RelAvales, aval.IdPersona, aval.IdSocio, aval.PorcentajeAmparado
from dbo.tAYCavalesAsignados aval  WITH(NOLOCK) 
INNER JOIN @socio sc 
	on sc.IdPersona = aval.IdPersona
where aval.EsSolicitanteCredito=0
	and aval.IdEstatus=1

/********  JCA.2/3/2024.14:24 Info:Cuentas del Socio ********/
declare @CuentasSocio as table(
	IdSocio			int,
	NoSocio			varchar(20),
	NombreSocio		varchar(250),
	Cuenta			varchar(30),
	DeudaInicial	numeric(13,2),
	SaldoEnDeuda	numeric(13,2),
	DiasMora		int
	)

	insert into @CuentasSocio
	SELECT 
	 sc.IdSocio
	,ca.Socio 
	,ca.NombreSocio
	,ca.Cuenta				
	,ca.[DEUDA INICIAL]
	,ca.[SALDO EN DEUDA]
	,ca.[DIAS DE ATRASO]
	FROM iERP_FNG_RPT.dbo.tAYCcarteraAvisosCobranza ca  WITH(NOLOCK)
	INNER JOIN @socio sc 
		on sc.NoSocio=ca.Socio
	where ca.FechaCartera	= @FechaTrabajo

/********  JCA.5/3/2024.19:08 Info: Cuentas de Avalados  ********/
declare @CuentasAvalados as table(
	IdSocio			int,
	NoSocio			varchar(20),
	NombreSocio		varchar(250),
	Cuenta			varchar(30),
	DeudaInicial	numeric(13,2),
	SaldoEnDeuda	numeric(13,2),
	DiasMora		int
	)

	insert into @CuentasAvalados
	SELECT 
	 c.IdSocio
	,ca.Socio 
	,ca.NombreSocio
	,ca.Cuenta				
	,ca.[DEUDA INICIAL]
	,ca.[SALDO EN DEUDA]
	,ca.[DIAS DE ATRASO]
	FROM iERP_FNG_RPT.dbo.tAYCcarteraAvisosCobranza ca  WITH(NOLOCK)
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		on c.Codigo=ca.Cuenta
	INNER JOIN @avalados aval
		on aval.RelAvales = c.RelAvales
	where ca.FechaCartera	= @FechaTrabajo

/********  JCA.5/3/2024.19:31 Info: Avales  ********/
declare @Avales as table(
	IdSocio			int,
	IdPersona		int,
	NoSocio			varchar(20)
)

insert into @Avales
select av.IdSocio,av.IdPersona, sc.Codigo 
from dbo.tAYCavalesAsignados av  WITH(NOLOCK)
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdSocio = av.IdSocio
where av.RelAvales=@IdCuenta
	and av.IdSocio<>@IdSocio

/********  JCA.5/3/2024.19:54 Info: Cuentas Avales  ********/
declare @CuentasAvales as table(
	IdSocio			int,
	NoSocio			varchar(20),
	NombreSocio		varchar(250),
	Cuenta			varchar(30),
	DeudaInicial	numeric(13,2),
	SaldoEnDeuda	numeric(13,2),
	DiasMora		int	
)

	insert into @CuentasAvales
	SELECT 
	 aval.IdSocio
	,ca.Socio 
	,ca.NombreSocio
	,ca.Cuenta				
	,ca.[DEUDA INICIAL]
	,ca.[SALDO EN DEUDA]
	,ca.[DIAS DE ATRASO]
	FROM iERP_FNG_RPT.dbo.tAYCcarteraAvisosCobranza ca  WITH(NOLOCK)
	INNER JOIN @Avales aval
		on aval.NoSocio = ca.Socio
	where ca.FechaCartera	= @FechaTrabajo

/********  JCA.5/3/2024.20:23 Info: Avalados de los Avales  ********/
declare @AvaladosAvales as table(
	IdAval	int,
	RelAvales	int,
	IdPersona	int,
	IdSocio		int,
	Porcentaje	numeric(3,2)
)

insert into @AvaladosAvales
select aval.IdAval, aval.RelAvales, aval.IdPersona, aval.IdSocio, aval.PorcentajeAmparado
from dbo.tAYCavalesAsignados aval  WITH(NOLOCK) 
INNER JOIN @Avales a 
	on a.IdPersona = aval.IdPersona
where aval.EsSolicitanteCredito=0
	and aval.IdEstatus=1

/********  JCA.5/3/2024.20:49 Info: Cuentas Avalados Avales  ********/
declare @CuentasAvaladosAvales as table(
	IdSocio			int,
	NoSocio			varchar(20),
	NombreSocio		varchar(250),
	Cuenta			varchar(30),
	DeudaInicial	numeric(13,2),
	SaldoEnDeuda	numeric(13,2),
	DiasMora		int
	)

	insert into @CuentasAvaladosAvales
	SELECT 
	 c.IdSocio
	,ca.Socio 
	,ca.NombreSocio
	,ca.Cuenta				
	,ca.[DEUDA INICIAL]
	,ca.[SALDO EN DEUDA]
	,ca.[DIAS DE ATRASO]
	FROM iERP_FNG_RPT.dbo.tAYCcarteraAvisosCobranza ca  WITH(NOLOCK)
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		on c.Codigo=ca.Cuenta
	INNER JOIN @AvaladosAvales aval
		on aval.RelAvales = c.RelAvales
	where ca.FechaCartera	= @FechaTrabajo

-------------------
/**/
select '**** SOCIO ****' as info
select @FolioApertura as Folio, NoSocio,Nombre from @socio
select '**** CUENTAS DEL SOCIO ****' as info
select NoSocio,NombreSocio,Cuenta,DeudaInicial,SaldoEnDeuda,DiasMora from @CuentasSocio
select '**** CUENTAS AVALADOS ****' as info
select NoSocio,NombreSocio,Cuenta,DeudaInicial,SaldoEnDeuda,DiasMora from @CuentasAvalados 
select '**** CUENTAS DE AVALES ****' as info
select NoSocio,NombreSocio,Cuenta,DeudaInicial,SaldoEnDeuda,DiasMora from @CuentasAvales
select '**** CUENTAS DE AVALADOS DE AVALES ****' as info
select NoSocio,NombreSocio,Cuenta,DeudaInicial,SaldoEnDeuda,DiasMora from @CuentasAvaladosAvales



--select 
--(select * from @socio for json path) as Socio,
--(select * from @CuentasSocio for json path) as CuentasSocio, 
--(select * from @CuentasAvalados for json path) as CuentasAvalados,
--(select * from @CuentasAvales for json path) as CuentasAvales,
--(select * from @CuentasAvaladosAvales for json path) as CuentasAvaladosDeAvales
--for json path;  











