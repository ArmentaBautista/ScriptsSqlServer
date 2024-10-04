
-- 0.20 trAlertasOficialCumplimiento

if EXISTS(SELECT o.name, t.name 
			FROM sys.triggers t 
			INNER JOIN sys.objects o
				ON o.object_id = t.parent_id
			WHERE t.name='trAlertasOficialCumplimiento'
				AND o.name='tPLDoperaciones')
BEGIN
	DROP TRIGGER trAlertasOficialCumplimiento 
	SELECT 'trAlertasOficialCumplimiento ON tPLDoperaciones BORRADO'
END
GO

CREATE TRIGGER dbo.trAlertasOficialCumplimiento
ON dbo.tPLDoperaciones
for insert
AS
 BEGIN
	SET NOCOUNT ON ;

	DECLARE @IdPersona AS INT=0
	DECLARE @Mensaje AS VARCHAR(max)

	SELECT @IdPersona=i.IdPersona, 
	@Mensaje=CONCAT('Nuevo Alertamiento: ', t.Descripcion, ' Para: ', p.Nombre,' ', i.Texto, ' ', i.TipoIndicador)
	FROM INSERTED i 
	INNER JOIN dbo.tCTLtiposD t  WITH(NOLOCK) 
		ON t.IdTipoD = i.IdTipoDoperacionPLD
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = i.IdPersona

	SET @Mensaje = CONCAT('Se ha detectado un nuevo alertamiento para el Oficial de Cumplimiento',CHAR(13),@Mensaje)


	IF EXISTS(SELECT ccc.IdPersona 
				FROM dbo.tPLDccc ccc  WITH(NOLOCK) 
				WHERE ccc.IdListaDpuesto=-49 
					AND ccc.IdPersona=@IdPersona)
	BEGIN
		/* Usar si la bd es menor a 2016
		SELECT
			  (
				SELECT
				  mail.Email + ';'
				FROM
				  (
					SELECT
					  mail.Email
					FROM
					  [Person]
					FOR XML PATH('')
				  )
				AS t
				WHERE
				  t.value('.', 'nvarchar(max)') IS NOT NULL
				FOR XML PATH('')
			  ).value('.', 'nvarchar(max)')
			AS ConcatenatedNames;
		*/

		DECLARE @correos AS VARCHAR(512) = (SELECT STRING_AGG(mail.Email,';') FROM dbo.fnPLDemailsCCC() mail)
		SET @correos = CONCAT(@correos,';carlos.armenta@intelix.mx;alicia.ambrocio@intelix.mx,karloz.arba@gmail.com')
		
		EXEC dbo.pCTLenviarMail @destinatario = @correos, 
		                        @asunto = 'Alertarmiento para el Oficial de Cumplimiento',       
		                        @cuerpo = @Mensaje       
		
	END	
 END
 GO

 
IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='trAlertasOficialCumplimiento')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('trAlertasOficialCumplimiento')
END
GO
