USE [ErpriseExpediente]
GO

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pDIGexpediente')
BEGIN
	DROP PROC pDIGexpediente
	SELECT 'pDIGexpediente BORRADO' AS info
END
GO


CREATE PROC dbo.pDIGexpediente
@tipoOperacion AS VARCHAR(24)='',
@numeroSocio AS VARCHAR(24)='',
@idCuenta AS INT=0,
@idSesion AS INT=0,
@IdPersona AS INT=0
AS
BEGIN

--#region Documentación
/*	Sp para gestión de requisitos del proceso de ingreso. (TipoD = 208)
	Recibe un tipo de operación:
		OBTREQ. Obtiene la lista de requisitos de ingreso de un socio, sino existen en la tabla los inserta.
*/
--#endregion Documentación


	IF @tipoOperacion='' 
	BEGIN
		RAISERROR ( 'Oops (>_<) Tipo de Operación no provisto.',18,1)
		RETURN -1
	END
		
	-- Variables
	DECLARE @fechaTrabajo AS DATE=GETDATE()
	DECLARE @idTipoDdominio AS INT = 0
	
	IF @TipoOperacion='OBTREQING'
	BEGIN	
			IF @numeroSocio='' 
			BEGIN
				RAISERROR ( 'Oops (>_<) Número de Socio no provisto.',18,1)
				RETURN -1
			END

			SET @idTipoDdominio = 208
			--Obtener IdSocio
			DECLARE @idSocio AS INT=0;
			DECLARE @idPersonaSocio AS INT=0;
			SELECT @idSocio=p.idsocio, @idPersonaSocio=p.IdPersona FROM dbo.tGRLpersonas p  WITH(NOLOCK) WHERE p.NumeroSocio=@numeroSocio

			-- Buscar en la tabla de requisitos si ya existen registros para el socio
			IF NOT EXISTS(SELECT 1 FROM dbo.tDIGexpediente ex  WITH(NOLOCK) WHERE ex.IdTipoDdominio=@idTipoDdominio AND ex.IdRegistro=@numeroSocio)
			BEGIN -- Crear los registros de los requisitos en la tabla de expediente
				INSERT INTO dbo.tDIGexpediente
				(
					IdTipoDdominio,
					IdRegistro,
					IdRequisito,
					EsDocumental,
					IdPersona,
					IdSesion
				)
				SELECT @idTipoDdominio,@idSocio,r.IdRequisito,r.EsDocumental,@idPersonaSocio,@idSesion
				FROM dbo.vDIGrequisitosAgrupador r  WITH(NOLOCK) 
				WHERE r.AplicaIngreso=1
			END
			
			--Obtener los registros del expediente
			SELECT
			[Agrupador]	=	ra.AgrupadorDescripcion,
			[Requisito]	=	ra.RequisitoDescripcion,
			ra.AgrupadorObligatorio,
			ra.RequisitoObligatorio,
			ex.IdExpediente,
			ex.IdTipoDdominio,
			ex.IdRegistro,
			ex.IdRequisito,
			ex.EsDocumental,
			ex.EstaCubiertoNoDocumental
			FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 
			INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) ON ra.IdRequisito = ex.IdRequisito
			WHERE ex.IdTipoDdominio=@idTipoDdominio AND ex.IdRegistro=@idSocio
			ORDER BY ra.IdAgrupador, ra.RequisitoDescripcion

			RETURN 1
	END

	IF @tipoOperacion='OBT_REQ_CTA'
	BEGIN
		IF @idCuenta=0
		BEGIN
			RAISERROR ( 'Oops (>_<) Número de Cuenta no provisto.',18,1)
			RETURN -1
		END

		SET @idTipoDdominio = 232
		
		-- Buscar en la tabla de requisitos si ya existen registros para la cuenta y el acreditado
		IF NOT EXISTS(SELECT 1 FROM dbo.tDIGexpediente ex  WITH(NOLOCK) WHERE ex.IdTipoDdominio=@idTipoDdominio 
						AND ex.IdRegistro=@IdCuenta AND ex.IdPersona=@idPersona AND ex.EsAcreditado=1)
		BEGIN
			-- crear los registros
			INSERT INTO dbo.tDIGexpediente
			(
			    IdTipoDdominio,
			    IdRegistro,
			    IdRequisito,
			    EsDocumental,
			    EstaCubiertoNoDocumental,
			    IdPersona,
			    EsAcreditado,
			    EsAval,
			    EsObligadoSolidario,
			    IdOperacion,
			    Fecha,
			    Alta,
			    IdSesion,
			    IdEstatus
			)
			SELECT
			    @idTipoDdominio,       -- IdTipoDdominio - int
			    @IdCuenta,       -- IdRegistro - int
			    r.IdRequisito,       -- IdRequisito - int
			    r.EsDocumental, -- EsDocumental - bit
			    0, -- EstaCubiertoNoDocumental - bit
			    @idPersona, -- IdPersona - int
			    1, -- EsAcreditado - bit
			    0, -- EsAval - bit
			    0, -- EsObligadoSolidario - bit
			    0, -- IdOperacion - int
			    @fechaTrabajo, -- Fecha - date
			    CURRENT_TIMESTAMP, -- Alta - datetime
			    @idSesion,       -- IdSesion - int
			    1  -- IdEstatus - int
			FROM dbo.vDIGrequisitosAgrupador r  WITH(NOLOCK) 
			WHERE r.AplicaCredito=1
		END

		--Obtener los registros del expediente
		SELECT
			[Agrupador]	=	ra.AgrupadorDescripcion,
			[Requisito]	=	ra.RequisitoDescripcion,
			ra.AgrupadorObligatorio,
			ra.RequisitoObligatorio,
			ex.IdExpediente,
			ex.IdTipoDdominio,
			ex.IdRegistro,
			ex.IdRequisito,
			ex.EsDocumental,
			ex.EstaCubiertoNoDocumental,
			ex.IdPersona,
			ex.EsAcreditado,
			ex.EsAval,
			ex.EsObligadoSolidario
			FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 
			INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) ON ra.IdRequisito = ex.IdRequisito
			WHERE ex.IdTipoDdominio=@idTipoDdominio AND ex.IdRegistro=@IdCuenta AND ex.IdPersona=@idPersona
			ORDER BY ra.IdAgrupador, ra.RequisitoDescripcion

		RETURN 1
    END

	

END
GO


