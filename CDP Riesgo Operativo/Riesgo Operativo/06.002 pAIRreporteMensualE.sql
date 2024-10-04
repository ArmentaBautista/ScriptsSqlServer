
-- 06.002 pAIRreporteMensualE

/* JCA.19/4/2024.01:32 
Nota: Riesgo Operativo: Procedimiento para las operaciones sobre el encabezado del reporte mensual
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRreporteMensualE')
BEGIN
	DROP PROC pAIRreporteMensualE
	SELECT 'pAIRreporteMensualE BORRADO' AS info
END
GO

CREATE PROC pAIRreporteMensualE
@MESSAGE_RETURN VARCHAR(max)='' OUTPUT,
@pTipoOperacion	VARCHAR(16),
@pIdReporteMensualE INT =0 OUTPUT,	
@pIdPeriodo			INT=0,
@pIdUsuario			INT=0,
@pIdDepartamento	INT=0,	
@pIdPuesto			INT=0,
@pFecha				DATE='19000101'
AS
BEGIN
	DECLARE @IdSesion INT = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 

	IF @pTipoOperacion='C'
	BEGIN

	    IF @pIdPeriodo=0
		BEGIN
		    set @MESSAGE_RETURN = 'El dato Periódo es obligatorio';
			RETURN -1
		END
		IF @pIdUsuario=0
		BEGIN
		    set @MESSAGE_RETURN = 'El dato Usuario es obligatorio';
			RETURN -1
		END
		IF @pIdDepartamento=0
		BEGIN
		    set @MESSAGE_RETURN = 'El dato Departamento es obligatorio';
			RETURN -1
		END
		IF @pIdPuesto=0
		BEGIN
		    set @MESSAGE_RETURN = 'El dato Puesto es obligatorio';
			RETURN -1
		END
		IF @pFecha='19000101'
		BEGIN
		    set @MESSAGE_RETURN = 'El dato Fecha es obligatorio';
			RETURN -1
		END

	    INSERT INTO dbo.tAIRreporteMensualE
	    (
	        IdPeriodo,
	        IdUsuario,
	        IdDepartamento,
	        IdPuesto,
	        Fecha,
	        IdSesion
	    )
	    VALUES
	    (   @pIdPeriodo,       
	        @pIdUsuario,       
	        @pIdDepartamento,       
	        @pIdPuesto,       
	        @pFecha, 
	        @IdSesion        
	        )
	   SET @pIdReporteMensualE = SCOPE_IDENTITY();

		RETURN 1
	END

	IF @pTipoOperacion='R'
	BEGIN
		SELECT 
		e.IdReporteMensualE,
		[PeriodoCodigo]				= p.Codigo,
		[PeriodoDescripcion]		= p.Descripcion,
		u.IdUsuario,
		u.Usuario,
		per.Nombre,
		[DepartamentoCodigo]		= dep.Codigo,
		[DepartamentoDescripcion]	= dep.Descripcion
		FROM dbo.tAIRreporteMensualE e  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLperiodos p  WITH(NOLOCK) 
			ON p.IdPeriodo = e.IdPeriodo
				AND p.IdPeriodo=@pIdPeriodo
		INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK)		
			ON u.IdUsuario = e.IdUsuario
		INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) 
			ON per.IdPersonaFisica = u.IdPersonaFisica
		INNER JOIN  dbo.tPERdepartamentos dep  WITH(NOLOCK) 
			ON dep.IdDepartamento = e.IdDepartamento
		INNER JOIN dbo.tPERpuestos pue  WITH(NOLOCK) 
			ON pue.IdPuesto = e.IdPuesto
		
	 RETURN 1
	END


END
GO

