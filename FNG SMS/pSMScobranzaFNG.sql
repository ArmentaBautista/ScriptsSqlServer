

IF(object_id('pSMScobranzaFNG') is not null)
BEGIN
	DROP PROC pSMScobranzaFNG
	SELECT 'pSMScobranzaFNG BORRADO' AS info
END
GO

CREATE PROC pSMScobranzaFNG
@pDebug as bit=0,
@RETURN_MESSAGE AS VARCHAR(max)='' OUTPUT,
@pReemplazarTelefono as bit=0,
@pTelefonoReemplazo as nvarchar(10)='',
@pLimiteDeResultados as int=0,
@pNoMandarSMS AS BIT = 0
as
begin

/********  JCA.26/8/2024.19:19 Info: Variables  ********/
DECLARE @Debug as bit=@pDebug
declare @ReemplazarTelefono as bit=@pReemplazarTelefono
declare @TelefonoReemplazo as nvarchar(10)=@pTelefonoReemplazo
declare @LimiteDeResultados as int=@pLimiteDeResultados
declare @fecha as date=getdate();
declare @fechacartera AS DATE=GETDATE();

DECLARE @cuentas AS TABLE(
	IdCuenta INT,
	NoCuenta VARCHAR(30),
	ProximoVencimiento DATE,
	DiasMora INT,
	Celular VARCHAR(10),
    ConceptoMora CHAR(7) DEFAULT '',

	INDEX IX_IdCuenta (IdCuenta),
	INDEX IX_DiasMora (DiasMora)
)

declare @sms as table(
	Id			int identity,
	IdCuenta	int,
	Celular		VARCHAR(10),
	Mensaje		varchar(max)
)

DECLARE @repetidos AS TABLE
(
    Telefono VARCHAR(30),

    INDEX IX_telefono(Telefono)
)

INSERT INTO @repetidos
SELECT
    Telefono
FROM tCATtelefonos t WITH (NOLOCK)
INNER JOIN tCTLestatusActual ea WITH (NOLOCK)
    ON t.IdEstatusActual = ea.IdEstatusActual
        AND ea.IdEstatus=1
INNER JOIN tGRLpersonas p WITH (NOLOCK)
    ON p.IdRelTelefonos=t.IdRel
WHERE IdRel<>0
GROUP BY Telefono,IdPersona
HAVING count(1)>1

/********  JCA.26/8/2024.19:20 Info: Constantes para mensajes  ********/
DECLARE @Mensaje3DiasAntes AS VARCHAR(160);
DECLARE @MensajeHasta7DiasMora AS VARCHAR(160);
DECLARE @MensajeHasta29DiasMora AS VARCHAR(160);
DECLARE @MensajeHasta59DiasMora AS VARCHAR(160);
DECLARE @MensajeHasta89DiasMora AS VARCHAR(160);
DECLARE @MensajeApartir90DiasMora AS VARCHAR(160);

set @Mensaje3DiasAntes = 'Estimado Socio, le invitamos a hacer su pago antes del $FECHA$ Cuenta $CUENTA$'
set @MensajeHasta7DiasMora = 'Estimado Socio, su fecha de pago vencio el $FECHA$ ($CONCEPTO$), le invitamos a regularizar su cuenta $CUENTA$'
set @MensajeHasta29DiasMora = 'Estimado Socio, su prestamo $CUENTA$, mantiene una "MENSUALIDAD VENCIDA" ($CONCEPTO$), le invitamos a realizar su pago'
set @MensajeHasta59DiasMora = 'Estimado Socio, su prestamo $CUENTA$, mantiene dos "MENSUALIDADES VENCIDAS" ($CONCEPTO$), se le exhorta a regularizarse'
set @MensajeHasta89DiasMora = 'Estimado Socio, su prestamo $CUENTA$ tiene "TRES PAGOS VENCIDOS" ($CONCEPTO$), realice su PAGO y evite ser turnado a Juridico'
set @MensajeApartir90DiasMora = 'Estimado socio, se requiere el PAGO INMEDIATO de sus pagos vencidos, se encuentra en CARTERA VENCIDA, evite que su cuenta $CUENTA$ se turne a Jurídico'

/********  JCA.26/8/2024.19:51 Info: Generación de cartera con los Socios que tienen Teléfono  ********/
INSERT INTO @cuentas(IdCuenta,NoCuenta,ProximoVencimiento, DiasMora,Celular,ConceptoMora)
SELECT c.IdCuenta,ctas.Codigo,c.ProximoVencimiento,c.MoraMaxima,tels.Telefono, iif(c.DiasMoraCapital>c.DiasMoraInteres,'Capital','Interés') AS Concepto
FROM dbo.tAYCcartera c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas ctas  WITH(NOLOCK) 
	ON ctas.IdCuenta = c.IdCuenta
INNER JOIN dbo.ifGRLpersonasSociosTelefonosCelulares() tels
	ON tels.IdSocio = ctas.IdSocio
		AND LEN(tels.Telefono)<=10
WHERE c.FechaCartera=@fechacartera
    AND NOT exists(SELECT 1 FROM @repetidos rep WHERE rep.Telefono=tels.Telefono)

IF @pDEBUG=1 SELECT count(1) FROM @cuentas

/********  JCA.26/8/2024.22:04 Info: Cuentas Cobranza Preventiva  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@Mensaje3DiasAntes,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.ProximoVencimiento BETWEEN @fechacartera AND (DATEADD(DAY,3,@fechacartera))

/********  JCA.26/8/2024.22:15 Info: Cobranza hasta 7 días de Mora  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@MensajeHasta7DiasMora,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.DiasMora BETWEEN 1 AND 7

/********  JCA.26/8/2024.22:25 Info: Cobranza hasta 29 días  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@MensajeHasta29DiasMora,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.DiasMora BETWEEN 8 AND 29

/********  JCA.26/8/2024.22:28 Info: Cobranza hasta 59 días  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@MensajeHasta59DiasMora,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.DiasMora BETWEEN 30 AND 59

/********  JCA.26/8/2024.22:29 Info: Cobranza hasta 89 días  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@MensajeHasta89DiasMora,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.DiasMora BETWEEN 60 AND 89

/********  JCA.26/8/2024.22:31 Info: Cobranza arriba de 90 días  ********/
INSERT @sms (IdCuenta,Celular,Mensaje)
SELECT 
c.IdCuenta,
c.Celular,
REPLACE(
            REPLACE(
		        REPLACE(@MensajeApartir90DiasMora,'$FECHA$',convert(varchar, c.ProximoVencimiento,5)),
	            '$CUENTA$',c.NoCuenta),
                    '$CONCEPTO$',c.ConceptoMora)
FROM @cuentas c
WHERE c.DiasMora >= 90

IF @pDEBUG=1 SELECT * FROM @sms

/********  JCA.26/8/2024.22:36 Info: Opciones de Depuracion  ********/
IF @pDEBUG=1 
BEGIN
	IF @LimiteDeResultados>0
	begin
		delete from @sms where Id>=@LimiteDeResultados
	end

	if @ReemplazarTelefono=1
	begin
		update m set m.Celular=@TelefonoReemplazo from @sms m
	END
END

IF @pDEBUG=1 AND @pNoMandarSMS=1 GOTO HELL				

-- Variables Cursor
declare @IdCuenta	int=0
declare @Telefono	varchar(10)=''
declare @Mensaje	varchar(max)=''

DECLARE cur CURSOR local fast_forward READ_ONLY FOR select IdCuenta,Celular,Mensaje from @sms where Celular<>''
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
			
			insert into dbo.tSMScobranzaEnviados (Telefono,Respuesta, IdCuenta, Mensaje) 
			values (@Telefono,@resp,@IdCuenta,@Mensaje)
	end

	--WAITFOR DELAY '00:00:01'

    FETCH NEXT FROM cur INTO @IdCuenta,@Telefono,@Mensaje
END
CLOSE cur
DEALLOCATE cur

/********  JCA.26/8/2024.22:43 Info:Notificación del proceso  ********/
BEGIN TRY
		declare @m as nvarchar(160)
		declare @r as nvarchar(max)=''
		declare @mensajesenviados as int
		select @mensajesenviados=COUNT(1) from dbo.tSMScobranzaEnviados m  WITH(NOLOCK) where m.Fecha=@fecha
		
		SET @m=concat_ws(' ',try_cast(@mensajesenviados as varchar(5)),' mensajes de cobranza enviados el ',convert(varchar, @fecha,5))

		exec dbo.pSMSenvio '2451022064',@m,@r output
		--exec dbo.pSMSenvio '7731163230',@m,@r output
        IF @Debug=1
            select @m as Resultado

END TRY
BEGIN CATCH
	SET @RETURN_MESSAGE = concat_ws(' - ',error_number(),error_procedure(),error_line(),error_message()) 
END CATCH;

HELL:
END
GO

