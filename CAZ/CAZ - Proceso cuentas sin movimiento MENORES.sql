

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO







create PROC [dbo].[pAYCtraspasoMenores]
@IdPeriodo AS INT=0


AS
BEGIN

DECLARE @IdProducto AS integer= (SELECT ISNULL(IdProductoFinancieroAdolecentesInactivos,0)
								  FROM tCTLempresasAhorroYcredito)

DECLARE @fechaTrabajo AS DATE='19000101'
SET @fechaTrabajo=(SELECT Fin FROM dbo.tCTLperiodos (NOLOCK) WHERE IdPeriodo=@IdPeriodo AND EsAjuste=0)

--------------crear el idsesion para traspasos 
DECLARE @idsesion AS INT =(SELECT MIN(idsesion)-1 FROM tCTLsesiones tc)
SET IDENTITY_INSERT tCTLsesiones ON
IF NOT EXISTS(SELECT *FROM tCTLsesiones tc WHERE tc.IdSesion=@idsesion)
INSERT INTO tCTLsesiones(IdSesion,IdUsuario,IdPerfil,IdSucursal,IP,Host,	Inicio,Fin,FechaTrabajo,IdVersion)
VALUES(@idsesion,0,0,0,'TRASPASOMENORES','TRASPASOMENORES',GETDATE(),GETDATE(),GETDATE(),0)

SET IDENTITY_INSERT tCTLsesiones OFF
----------------------------------------------crear cuentas---------------****************************


DECLARE @idTipoDproucto AS INT=0
DECLARE @idTipoDtasa AS INT=0
DECLARE @TipoAIC AS INT=0
DECLARE @IdRelCatalogosAsignados AS INT=0
DECLARE @IdDivision AS INT=0
DECLARE @idTasa AS INT=0
DECLARE @DiasTipoAñio AS INT=0
DECLARE @IdImpuesto AS INT=0
DECLARE @Descripcion AS VARCHAR(500)=''
DECLARE @IdTipoDIncremental AS INT=407


SELECT @idTipoDproucto=taf.IdTipoDDominioCatalogo,@idTipoDtasa=taf.IdTipoDTasa,@IdRelCatalogosAsignados=taf.IdRelDivisionesAsignadas,@Descripcion=taf.Descripcion  FROM tAYCproductosFinancieros taf (nolock)WHERE taf.IdProductoFinanciero=@idproducto

SELECT  @tipoAIC=CatalogoAsignado.IdTipoDCredito,@IdDivision=DivisionAsignada.IdDivision
			FROM vGRLDivisionesAsignadasGUI DivisionAsignada
			INNER JOIN vCNTdivisionesGUI Division ON Division.IdDivision = DivisionAsignada.IdDivision AND Division.IdEstatus =1 
			INNER JOIN vCNTcatalogosAsignadosGUI CatalogoAsignado ON CatalogoAsignado.RelCatalogosAsignados = Division.RelCatalogosAsignados
			WHERE DivisionAsignada.IdRel=@IdRelCatalogosAsignados	AND CatalogoAsignado.IdEstatus=1 AND Division.IdEstatus=1 AND DivisionAsignada.IdEstatus=1
				
SELECT @idTasa =Id  FROM   vCTLproductosFinancierosTasasGUI
				WHERE reltasas = @idproducto AND IdEstatus=1
				ORDER BY Descripcion 
SET @DiasTipoAñio=CAST((SELECT valor FROM tCTLconfiguracion tc WHERE idconfiguracion=62) AS INT)

SET @IDImpuesto=CAST((SELECT valor FROM tCTLconfiguracion tc WHERE idconfiguracion=89) AS INT)

;

WITH tabla AS
 (
SELECT DISTINCT  
(ROW_NUMBER()OVER (PARTITION BY c.IdSucursal ORDER BY c.IdSucursal ) +
(SELECT dbo.fObtenerIncremental(c.idsucursal,232)))-1 AS Numero
, @Descripcion as Descripcion
,@fechaTrabajo as FechaAutorizacion
, a.idsocio
,-1 as IdUsuarioAutorizo
,@idTipoDproucto as IdTipoDproducto,@idtipodtasa as IdTipoDTasa,@TipoAIC as IdTipoDAIC, a.ExentaIVA as ExentaIVA,@IdDivision as IdDivision ,@IdTasa as IdTasa,1 as IdEstatus,@IdProducto as IdProductoFinanciero,1 as divisa,1 as FactorDivisa,c.IdSucursal,
@fechaTrabajo as FechaActivacion,dateadd(day,-1,@fechaTrabajo )as FechaUltimoCalculo,
@DiasTipoAñio as DiasTipoAñio,1 as EsAutoapertura,@IDImpuesto as IdImpuesto,-1 as IdSuarioAlta,@fechaTrabajo as FechaAlta,-1 as IdUsuarioCambio,getdate() as UltimoCambio,@idTipoDproucto as IdTipoDdominio,@TipoAIC as IdTipoDAICclasificacion,getdate() as Alta,@idsesion as IdSesion
from tSCSsocios  a with(nolock)
		join tGRLpersonasFisicas tgf(nolock)on tgf.IdPersonaFisica=a.IdPersona
		inner join dbo.tAYCcuentas c with(nolock) on c.IdSocio = a.IdSocio
		inner join dbo.tAYCproductosFinancieros p with(nolock) on p.IdProductoFinanciero=c.IdProductoFinanciero
		left join tayccuentas cuenta (nolock)on cuenta.IdSocio=c.IdSocio and cuenta.IdProductoFinanciero=@IdProducto
		where dbo.fGRLcalcularEdad(tgf.FechaNacimiento, @FechaTrabajo) >= 18
		and p.IdProductoFinanciero in (select IdProducto from tCFGproductosMenoresAhorradores)
		and c.Saldo>0 and cuenta.IdCuenta is null
 )
 insert into tayccuentas (codigo,[Incremental],Descripcion,FechaAutorizacion,IdSocio,IdUsuarioAutorizo
 ,IdTipoDProducto,IdTipoDTasa,IdTipoDAIC,ExentaIVA,IdDivision,IdTasa,IdEstatus,IdProductoFinanciero
 ,IdDivisa,FactorDivisa,IdSucursal,FechaActivacion,FechaUltimoCalculo,DiasTipoAnio,EsAutoApertura
 ,IdImpuesto,IdUsuarioAlta,FechaAlta,IdUsuarioCambio,UltimoCambio,Alta,idsesion
 ,IdTipoDAICclasificacion,IdTipoDDominio)
select (select dbo.ObtenerCodigoIncremental('CUENTA', @IdTipodIncremental, t.IdSucursal, 232,t.Numero)) 
,numero,t.Descripcion,t.FechaAutorizacion,t.idsocio,t.IdUsuarioAutorizo,t.IdTipoDproducto,t.IdTipoDTasa,t.IdTipoDAIC,t.ExentaIVA,t.IdDivision,t.IdTasa,t.IdEstatus,t.IdProductoFinanciero,1,t.FactorDivisa,t.IdSucursal,t.FechaActivacion,t.FechaUltimoCalculo,t.DiasTipoAñio,t.EsAutoapertura,t.IdImpuesto,-1,@fechaTrabajo,-1,@fechaTrabajo,@fechaTrabajo,@idsesion,@idTipoDproucto,@TipoAIC
from tabla t
order by t.IdSucursal

-------Se aactualiza la tabla de incrementales
exec dbo.pCTLincrementales @TipoOperacion = 'UPD', -- varchar(5)
    @IdTipoDdominio = 232, -- int
    @IdSucursal = 0, -- int
    @IdTipoDincremental = @IdTipoDIncremental, -- int
    @Incremental = 0 -- int

		
-------------------------------------------------------creacion de los saldos

insert into tsdosaldos(IdTipoDDominioCatalogo,IdAuxiliar,IdEstructuraContable,IdSucursal,IdSocio,IdPersona,IdDivision,IdDivisa,Fecha,IdEstatus,IdCuenta,FactorDivisa,Naturaleza,IdPeriodo,Factor,IdUsuarioAlta,IdUsuarioUltimoCambio,alta,UltimaModificacion,IdSesion,Descripcion,Codigo)
select  ta.IdTipoDProducto,-14 as IDAuxiliar,-8 as IdEstructuraContable,ta.IdSucursal,ta.IdSocio,vsb.SocioPersonaIdPersona,ta.IdDivision,ta.IdDivisa,ta.FechaAlta,1 as IdEstatus,ta.IdCuenta,1,-1,@IdPeriodo,1,-1,-1,@fechaTrabajo,@fechaTrabajo,@idsesion,@Descripcion,ta.codigo
from tAYCcuentas ta
join vSCSsociosBAS vsb (nolock)on vsb.IdSocio=ta.IdSocio
left join  tSDOsaldos ts (nolock)on ts.IdCuenta=ta.IdCuenta
 
where  ta.IdSesion=@idsesion and ta.IdProductoFinanciero= @IdProducto  and ts.IdSaldo is null and ta.FechaAlta=@fechaTrabajo


--SELECT *
-----
update ta set IdSaldo = ts.IdSaldo
from tAYCcuentas ta
join tSDOsaldos ts(nolock)on ts.IdCuenta=ta.IdCuenta
where ta.IdProductoFinanciero=@IdProducto and ta.IdSesion=@idsesion and ts.Fecha=@fechaTrabajo and ta.IdSaldo=0

--ROLLBACK
------------------------------------------------******************************************************************************************************************************

exec pAYCejecutarProvisionAcreedoras
	@TipoOperacion = 'BJCTAMAS',
	@FechaTrabajo = @fechaTrabajo,
	@IdCuenta = 0,
	@Decimales = 2,
	@EsFinMes = 1,
	@DevengarIntereses = 0,
	@CapitalizarIntereses = 0,
	@IdImpuesto = 6,
	@IdSucursal = 0,
	@IdSucursalProceso = 1,
	@IdUsuario = -1,
	@IdSesion = @idsesion,
	@MontoRetirar = 0


--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--DECLARE @FechaTrabajo AS DATE = '20160229'
declare @IdPeridodoTrabajo as int=@IdPeriodo
declare @IdPeridoSiguiente as int
declare @FechaInicio as date 
declare @fechaFin as date
declare @folio_output as int
declare @IdOperacion_output as int




declare @tmpSociosCuentas  as table(
IdSocio int,
IdCuentaOrigen int,
Idcuentadestino int,
SaldoCuentaOrigen numeric(23,8),
Fecha date
)



insert into @tmpSociosCuentas
        ( IdSocio ,
          IdCuentaOrigen ,
          Idcuentadestino ,
          SaldoCuentaOrigen ,
          Fecha
        )
select distinct a.IdSocio,c.IdCuenta,cd.IdCuenta,c.Saldo,@FechaTrabajo
  from dbo.tSCSsocios a with(nolock)
  inner join dbo.tGRLpersonasFisicas pf on pf.IdPersona = a.IdPersona
  inner join dbo.tAYCcuentas c with(nolock) on c.IdSocio = a.IdSocio
  inner join dbo.tAYCcuentas cd with(nolock) on cd.IdSocio = a.IdSocio and cd.IdProductoFinanciero = @IdProducto
  where dbo.fGRLcalcularEdad(pf.FechaNacimiento, @FechaTrabajo) >= 18
  and c.IdProductoFinanciero=31 and c.Saldo>0
  order by a.IdSocio,c.IdCuenta,cd.IdCuenta asc

 select *
 from @tmpSociosCuentas TSC

set @folio_output=0;
  EXECUTE [dbo].[pLSTseriesRangosFolios] 'LST',24,'',1,@FechaTrabajo,@folio_output OUTPUT;
 
  INSERT INTO dbo.tGRLoperaciones(Serie,Folio,IdTipoOperacion,Fecha,Concepto,Referencia,
            IdPersona,IdSocio,IdPeriodo,IdSucursal,IdDivisa,FactorDivisa,IdListaDPoliza,
            IdEstatus,IdUsuarioAlta,Alta,IdTipoDdominio,Idsesion,Requierepoliza)
  SELECT Serie='',Folio=@folio_output,IdTipoOperacion=24,Fecha=IIF(@FechaTrabajo = '19000101',@fechaFin,@FechaTrabajo)
  ,Concepto='TRASPASO DE MENORES',Referencia='',
    IdPersona=0,IdSocio=0,IdPeriodo=@IdPeridodoTrabajo,IdSucursal=1,IdDivisa=1,FactorDivisa=1,IdListaDPoliza=-1,
    Idestatus=1,IdUsuarioAlta=-1,Alta=getdate(),IdTipoDdominio=727,idsesion=-11,RequierePoliza=1;
  
  set @idoperacion_output=SCOPE_IDENTITY();

  UPDATE dbo.tGRLoperaciones SET IdOperacionPadre=@idoperacion_output, RelTransaccionesFinancieras=@idoperacion_output
  WHERE IdOperacion>0 AND IdOperacion=@idoperacion_output;

INSERT INTO dbo.tSDOtransaccionesFinancieras (IdOperacion, IdTipoSubOperacion, Fecha, Descripcion, Idsaldodestino, IdAuxiliar
, IdCuenta, TipoMovimiento, MontoSuboperacion, Naturaleza, totalcargos, totalabonos, cambioneto, capitalgenerado, totalgenerado
, capitalpagado, TotalPagado, numeroMovimiento, esprincipal, IdSucursal, IdEstructuraContableE, IdCentroCostos, IdDivisa, IdDivision
, idgarantia, idestatus, idusuarioalta, idsesion, factordivisa, idestatusdominio, Referencia, Concepto, Alta,MontoBloqueado)
  SELECT tmp.idoperacion, tmp.IdTipoSubOperacion, tmp.Fecha, Descripcion=p.Descripcion+'TRASPASO' , Idsaldodestino=s.IdSaldo, s.IdAuxiliar
  , c.IdCuenta, tmp.TipoMovimiento, tmp.MontoSuboperacion, tmp.Naturaleza,tmp.totalcargos, tmp.totalabonos, tmp.cambioneto
  , tmp.capitalgenerado, tmp.totalgenerado, tmp.capitalpagado, tmp.TotalPagado, tmp.numeroMovimiento, tmp.esprincipal, c.IdSucursal
  , IdEstructuraContableE=s.IdEstructuraContable, su.IdCentroCostos, s.IdDivisa, c.IdDivision, tmp.idgarantia, tmp.idestatus,
    idusuarioalta=-1, tmp.idsesion, factordivisa=1, idestatusdominio=tmp.idestatus, Referencia=c.Codigo, Concepto='Traspaso', tmp.Alta
	,tmp.MontoBloqueado
  FROM tAYCcuentas c
  JOIN tAYCproductosFinancieros p ON p.IdProductoFinanciero = c.IdProductoFinanciero
  JOIN tSDOsaldos s ON s.IdCuenta = c.IdCuenta
  JOIN tCTLsucursales su ON su.IdSucursal=c.IdSucursal
  JOIN (
			SELECT IdOperacion = @IdOperacion_output
			  ,IdCuenta=TSC.IdCuentaOrigen
			  ,IdTipoSubOperacion  = 501
			  ,Fecha
			  ,TipoMovimiento = 2
			  ,MontoSubOperacion = TSC.SaldoCuentaOrigen
			  ,Naturaleza = -1
			  ,TotalCargos = 0
			  ,TotalAbonos = TSC.SaldoCuentaOrigen
			  ,CambioNeto = -TSC.SaldoCuentaOrigen
			  ,CapitalGenerado = 0
			  ,CapitalPagado = TSC.SaldoCuentaOrigen
			  ,TotalGenerado = 0
			  ,TotalPagado = TSC.SaldoCuentaOrigen
			  ,NumeroMovimiento = 0
			  ,EsPrincipal = 1
			  ,IdGarantia = 0
			  ,IdEstatus = 1
			  ,Orden = 1
			  ,IdSesion = @idsesion
			  ,MontoBloqueado = 0
			  ,Alta = GETDATE()  
			FROM @tmpSociosCuentas TSC
			INNER JOIN dbo.tAYCcuentas TAC ON TAC.IdCuenta = TSC.IdCuentaOrigen
			UNION ALL
			SELECT IdOperacion = @IdOperacion_output
			  ,IdCuenta=TSC.Idcuentadestino
			  ,IdTipoSubOperacion  = 500
			  ,Fecha
			  ,TipoMovimiento = 2
			  ,MontoSubOperacion = TSC.SaldoCuentaOrigen
			  ,Naturaleza = 1
			  ,TotalCargos = TSC.SaldoCuentaOrigen
			  ,TotalAbonos = 0
			  ,CambioNeto = TSC.SaldoCuentaOrigen
			  ,CapitalGenerado = TSC.SaldoCuentaOrigen
			  ,CapitalPagado = 0
			  ,TotalGenerado = TSC.SaldoCuentaOrigen
			  ,TotalPagado = 0
			  ,NumeroMovimiento = 0
			  ,EsPrincipal = 1
			  ,IdGarantia = 0
			  ,IdEstatus = 1
			  ,Orden = 2
			  ,IdSesion = @idsesion
			  ,MontoBloqueado = 0
			  ,Alta = GETDATE()
			FROM @tmpSociosCuentas TSC
			INNER JOIN dbo.tAYCcuentas TAC ON TAC.IdCuenta = TSC.IdCuentaOrigen

  ) AS tmp ON tmp.idcuenta=c.IdCuenta
  ORDER BY c.IdSocio, tmp.orden;

UPDATE ts SET idestatus=56
FROM @tmpSociosCuentas c
JOIN tayccuentas ts (NOLOCK)ON ts.IdCuenta=c.IdCuentaOrigen
 
EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @IdOperacion = @IdOperacion_output -- int


UPDATE ts SET idestatus=7
FROM @tmpSociosCuentas c
JOIN tayccuentas ts (NOLOCK)ON ts.IdCuenta=c.IdCuentaOrigen


UPDATE ts SET idestatus=7
FROM @tmpSociosCuentas c
JOIN tSDOsaldos ts (NOLOCK)ON ts.IdCuenta=c.IdCuentaOrigen


UPDATE ts SET FechaBAja=@fechaTrabajo
FROM @tmpSociosCuentas c
JOIN tAYCcuentasEstadisticas  ts (NOLOCK)ON ts.IdCuenta=c.IdCuentaOrigen

 DECLARE @IdEstatusPoliza AS INT = 34

     EXEC pCNTgenerarPolizaBaseDatos 
    @TipoFiltro=1, 
    @IdOperacion=@idoperacion_output,
    @Idcierre=0, 
    @IdSucursal=1,
    @IdUsuario=-1,
    @IdSesion=@idsesion,
    @MostrarPoliza=0,
    @IdEstatusPoliza=@IdEstatusPoliza OUTPUT,
    @NoAcumular=1;
    
    
    PRINT concat('IdEstatusPoliza->', @IdEstatusPoliza);
    
	--insert ala tabla de estadisticas de cuentas
	INSERT INTO  dbo.tAYCcuentasEstadisticas (IdCuenta,UltimoPagoInteres)
SELECT tsf.IdCuenta,tsf.Fecha FROM tSDOtransaccionesFinancieras tsf
LEFT JOIN tAYCcuentasEstadisticas tae (NOLOCK)ON tae.IdCuenta=tsf.IdCuenta
WHERE tsf.IdOperacion=@idoperacion_output AND tsf.IdTipoSubOperacion=500
AND tae.IdCuenta IS null


	
END






GO

