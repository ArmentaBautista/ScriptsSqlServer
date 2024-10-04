

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDPTactualizacionesPerfilTransaccional')
BEGIN
	DROP PROC dbo.pPLDPTactualizacionesPerfilTransaccional
	SELECT 'pPLDPTactualizacionesPerfilTransaccional BORRADO' AS info
END
GO

CREATE PROC dbo.pPLDPTactualizacionesPerfilTransaccional
@pTipoOperacion AS VARCHAR(25)='',
@pIdActualizacion AS INT=0,
@pNoSocio AS VARCHAR(20)='',
@pPersona AS VARCHAR(20)=''
AS
BEGIN

	IF @pTipoOperacion='EVALUACIONES'
	BEGIN
		SELECT 
		DISTINCT
		[IdEvaluacion] = e.IdActualizacionPerfilTransaccional,
        e.Fecha,
        e.PorcentajeVariacion,
        e.MesesEvaluados,
        e.Inicio,
        e.Fin,
		COUNT(d.IdPersona) OVER(PARTITION BY e.IdActualizacionPerfilTransaccional) AS NumResultados
		FROM dbo.tPLDactualizacionesPerfilTransaccionalE e  WITH(NOLOCK) 
		LEFT JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdActualizacionPerfilTransaccional = e.IdActualizacionPerfilTransaccional
	RETURN 1
	END

	IF @pTipoOperacion='RESULTADOS'
	BEGIN
		SELECT 
		[IdResultado] = d.IdActualizacionesPerfilTransaccionalD,
        p.Nombre,
		[NoSocio] = ISNULL(sc.Codigo,''),
        lista.Dato,
        d.ValorDeclaracion,
        d.ValorOperaciones,
        d.Fecha
		FROM dbo.tPLDactualizacionesPerfilTransaccionalE e  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdActualizacionPerfilTransaccional = e.IdActualizacionPerfilTransaccional
		INNER JOIN (
					VALUES (1,'Num. Depósitos'), (2,'Num. Retiros'), (3,'Monto Depósitos'), (4,'Monto Retiros')
					) AS lista(DatoTransaccional,Dato)
			ON lista.DatoTransaccional = d.DatoTransaccional
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = d.IdPersona
		LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdPersona = p.IdPersona
		WHERE e.IdActualizacionPerfilTransaccional=@pIdActualizacion
		ORDER BY IdResultado
	RETURN 1
	END

	IF @pTipoOperacion='SOCIO'
	BEGIN
		SELECT 
		[IdEvaluacion] = e.IdActualizacionPerfilTransaccional,
        e.Fecha,
        e.PorcentajeVariacion,
        e.MesesEvaluados,
        e.Inicio,
        e.Fin,
		[IdResultado] = d.IdActualizacionesPerfilTransaccionalD,
        p.Nombre,
		[NoSocio] = ISNULL(sc.Codigo,''),
        lista.Dato,
        d.ValorDeclaracion,
        d.ValorOperaciones,
        d.Fecha
		FROM dbo.tPLDactualizacionesPerfilTransaccionalE e  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdActualizacionPerfilTransaccional = e.IdActualizacionPerfilTransaccional
		INNER JOIN (
					VALUES (1,'Num. Depósitos'), (2,'Num. Retiros'), (3,'Monto Depósitos'), (4,'Monto Retiros')
					) AS lista(DatoTransaccional,Dato)
			ON lista.DatoTransaccional = d.DatoTransaccional
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = d.IdPersona
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdPersona = p.IdPersona
				AND sc.Codigo=@pNoSocio
		ORDER BY e.IdActualizacionPerfilTransaccional
	RETURN 1
	END

	IF @pTipoOperacion='PERSONA'
	BEGIN
		SELECT 
		[IdEvaluacion] = e.IdActualizacionPerfilTransaccional,
        e.Fecha,
        e.PorcentajeVariacion,
        e.MesesEvaluados,
        e.Inicio,
        e.Fin,
		[IdResultado] = d.IdActualizacionesPerfilTransaccionalD,
        p.Nombre,
		[NoSocio] = ISNULL(sc.Codigo,''),
        lista.Dato,
        d.ValorDeclaracion,
        d.ValorOperaciones,
        d.Fecha
		FROM dbo.tPLDactualizacionesPerfilTransaccionalE e  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdActualizacionPerfilTransaccional = e.IdActualizacionPerfilTransaccional
		INNER JOIN (
					VALUES (1,'Num. Depósitos'), (2,'Num. Retiros'), (3,'Monto Depósitos'), (4,'Monto Retiros')
					) AS lista(DatoTransaccional,Dato)
			ON lista.DatoTransaccional = d.DatoTransaccional
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = d.IdPersona
				AND p.Nombre LIKE '%' + @pPersona +'%'
		LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdPersona = p.IdPersona
		ORDER BY p.IdPersona
	RETURN 1
	END

END
GO
	
	
