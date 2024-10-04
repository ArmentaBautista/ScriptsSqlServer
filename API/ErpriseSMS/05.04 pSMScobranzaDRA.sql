

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSMScobranzaDRA')
BEGIN
	DROP PROC pSMScobranzaDRA
	SELECT 'pSMScobranzaDRA BORRADO' AS info
END
GO

CREATE PROC dbo.pSMScobranzaDRA
@pDebug as bit=0,
@pReemplazarTelefono as bit=0,
@pTelefonoReemplazo as nvarchar(10)='',
@pLimiteDeResultados as int=0
as
begin

/********  JCA.26/02/2024.06:50 p. m. Info:Variables  ********/
declare @Debug as bit=@pDebug
declare @ReemplazarTelefono as bit=@pReemplazarTelefono
declare @TelefonoReemplazo as nvarchar(10)=@pTelefonoReemplazo
declare @LimiteDeResultados as int=@pLimiteDeResultados
declare @fecha as date=getdate();
declare @fechacartera AS DATE=GETDATE();

declare @sms as table(
	Id			int identity,
	IdCuenta	int,
	Telefono	varchar(10),
	Mensaje		varchar(max)
)


/********  JCA.26/02/2024.06:51 p. m. Info:Consulta de cuentas con los criterios del cliente, inserción en tabla en memoría para optimizar el recorrido del cursor. Importante que no incluya diagonales el mensaje, ejemplo en las fechas.  ********/
insert @sms
select
c.IdCuenta
,isnull(tel.Telefono,'') as Telefono,
Mensaje3=iif(c.IdEstatusCartera=28
,concat('Caja Dr Arroyo le informa que el',' ',  convert(varchar, PAR.Vencimiento,5),' vencio su cuenta',' ', c.Codigo ,' ','por',' ','$',  fasc.CapitalAtrasado + fasc.InteresOrdinarioTotalAtrasado + fasc.InteresMoratorioTotal + fasc.Cargos + fasc.CargosImpuestos,' ','Conserve su buen historial. Si realizo el pago favor de ignorar')
,'Caja Dr Arroyo le informa que vencio su cuenta. Por lo que le sugerimos se comunique al 4888880057 o pase a nuestras oficinas horario 9:00 a 17:00 hrs')
from dbo.tSCSsocios s  WITH(NOLOCK) 	
join dbo.tAYCcuentas c  with(nolock) 
	on c.IdSocio = s.IdSocio
		and c.IdTipoDProducto=143
			and c.IdEstatus=1 
				--AND c.IdCuenta=111925
join dbo.tGRLpersonas per  with(nolock) 
	on per.IdPersona = s.IdPersona
left join dbo.vTelefonosConsultaSat tel with(nolock) 
	on tel.IdSocio= s.IdSocio 
		and tel.Orden=1
join dbo.tAYCparcialidades par  with(nolock) 
	on par.IdCuenta = c.IdCuenta
		and  par.Vencimiento=iif(c.PrimerVencimientoPendienteInteres<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres,c.PrimerVencimientoPendienteCapital)
join dbo.fAYCcalcularCarteraOperacion(@fechacartera, 2, 0, 0, 'DEVPAG') fasc 
	on fasc.IdCuenta = c.IdCuenta 
where dbo.fAYCmoraMaxima(@fecha,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) between 1 and 89

if @Debug=1
	select * from @sms

if @LimiteDeResultados>0
begin
	delete from @sms where Id>=@LimiteDeResultados
	select * from @sms
end

if @ReemplazarTelefono=1
begin
	update m set m.Telefono=@TelefonoReemplazo from @sms m 
	select * from @sms
end
				

-- Variables Cursor
declare @IdCuenta	int=0
declare @Telefono	varchar(10)=''
declare @Mensaje	varchar(max)=''

DECLARE cur CURSOR local fast_forward READ_ONLY FOR select IdCuenta,Telefono,Mensaje from @sms where Telefono<>''
OPEN cur
FETCH NEXT FROM cur INTO @IdCuenta,@Telefono,@Mensaje
WHILE @@FETCH_STATUS = 0
BEGIN
	
	if not exists(select 1 
					from tSMScobranzaEnviados sms  WITH(NOLOCK) 
					where sms.telefono=@Telefono
						and sms.fecha=@fecha 
							and not sms.Respuesta is null)
				OR @ReemplazarTelefono=1
	begin
			declare @resp as nvarchar(max)
			exec dbo.pSMSenvio @Telefono,@mensaje,@resp output
			
			if @Debug=1
				select concat_ws(' ','SMS Enviado Telefono',@Telefono,'Mensaje',@Mensaje,'Resp',@resp)

			insert into dbo.tSMScobranzaEnviados (Telefono,Respuesta, IdCuenta, Mensaje) 
			values (@Telefono,@resp,@IdCuenta,@Mensaje)
	end
	
    FETCH NEXT FROM cur INTO @IdCuenta,@Telefono,@Mensaje
END
CLOSE cur
DEALLOCATE cur

/********  JCA.29/2/2024.17:29 Info:Notificación del proceso  ********/
BEGIN TRY
		declare @m as nvarchar(160)
		declare @r as nvarchar(max)=''
		declare @mensajesenviados as int=(select count(1) from dbo.tSMScobranzaEnviados m  WITH(NOLOCK) where m.Fecha=@fecha)
		set @m=concat_ws(' ',try_cast(@mensajesenviados as varchar(5)),' mensajes de cobranza enviados el ',convert(varchar, @fecha,5))

		exec dbo.pSMSenvio '2451022064',@m,@r output
		exec dbo.pSMSenvio '4881162451',@m,@r output

END TRY
BEGIN CATCH
	print concat_ws(' - ',error_number(),error_procedure(),error_line(),error_message()) 
END CATCH;


	
END
GO
