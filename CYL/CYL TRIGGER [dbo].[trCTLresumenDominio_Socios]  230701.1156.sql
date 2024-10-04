
USE iERP_CYL
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


ALTER TRIGGER [dbo].[trCTLresumenDominio_Socios] 
   ON  [dbo].[tSCSsocios] 
AFTER INSERT,update
AS 
BEGIN

SET NOCOUNT ON;

DECLARE @Idregistro AS bigint;
DECLARE @Idtipoddominio AS bigint = 208;
DECLARE @Codigo AS varchar(20) = '';
DECLARE @Descripcion AS varchar(80) = '';
DECLARE @Fecha AS datetime = '19000101';
DECLARE @Monto AS numeric(23, 8) = 0;
DECLARE @Concepto AS varchar(30) = '';
DECLARE @Rfc AS varchar(30) = '';

BEGIN TRY

 SELECT @Idregistro = IdSocio FROM INSERTED

 SET @Concepto=''
SELECT @Codigo = sc.Codigo,
       @Descripcion = com.NombreComercial,
       @Fecha = sc.Alta,
       @Rfc = p.RFC
FROM dbo.tSCSsocios sc  WITH(NOLOCK) --vSCSSociosGUI vsg
INNER JOIN dbo.tSCSsociosComerciales com  WITH(NOLOCK) 
	ON com.IdSocio = sc.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN INSERTED i
    ON sc.IdSocio = @Idregistro;


		IF
		(
			SELECT COUNT(@Idregistro)FROM INSERTED
		) >= 1
		BEGIN
			IF NOT EXISTS
			(
				SELECT IdRegistro,
					   IdTipoDdominio
				FROM tCTLresumenDominio  WITH(NOLOCK) 
				WHERE IdRegistro = @Idregistro
					  AND IdTipoDdominio = @Idtipoddominio
			)
			BEGIN

				UPDATE tCTLresumenDominio
				SET Codigo = @Codigo,
					Descripcion = @Descripcion,
					Fecha = @Fecha,
					Concepto = @Concepto,
					RFC = @Rfc
				WHERE IdRegistro = @Idregistro
					  AND @Idtipoddominio = @Idtipoddominio;

				INSERT INTO tCTLresumenDominio
				(
					IdRegistro,
					IdTipoDdominio,
					Codigo,
					Descripcion,
					Fecha,
					Monto,
					Concepto,
					RFC
				)
				VALUES
				(@Idregistro, @Idtipoddominio, @Codigo, @Descripcion, @Fecha, @Monto, @Concepto, @Rfc);


			END;

			ELSE
			BEGIN
				UPDATE tCTLresumenDominio
				SET Codigo = @Codigo,
					Descripcion = @Descripcion,
					Fecha = @Fecha,
					Concepto = @Concepto,
					RFC = @Rfc
				WHERE IdRegistro = @Idregistro
					  AND @Idtipoddominio = @Idtipoddominio;
			END;
		END;

END TRY 
BEGIN CATCH
DECLARE @Errormessage nvarchar(4000);
DECLARE @Errorseverity int;
DECLARE @Errorstate int;
SELECT
	@Errormessage = Error_message(),
	@Errorseverity = Error_severity(),
	@Errorstate = Error_state();
RAISERROR (@Errormessage, @Errorseverity, @Errorstate);

END CATCH

END 



GO

