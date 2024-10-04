
USE ErpriseExpediente
GO


-- 13 pCnDIGexpedientes


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnDIGexpedientes')
BEGIN
	DROP PROC pCnDIGexpedientes
	SELECT 'pCnDIGexpedientes BORRADO' AS info
END
GO

CREATE PROC pCnDIGexpedientes
@pTipoOperacion		VARCHAR(24),
@pIdRegistro		INT=0,
@pIdTipoDdominio	INT=0,
@pFechaInicial		DATE='19000101',
@pFechaFinal		DATE='19000101'
AS
BEGIN
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	-- Tipos de dominio
	--	208 socio  | 232 credito
	DECLARE @FechaDefault AS DATETIME 
	SET @FechaDefault = DATEFROMPARTS ( 1900, 01, 01 )


	IF @pTipoOperacion='SOCIO' 
	BEGIN
		DECLARE @socio AS TABLE(
			Agrupador		VARCHAR(50),
			Requisito		VARCHAR(50),
			Archivo			VARCHAR(256),
			Sincronizado	BIT,
			Registro		VARCHAR(256),
			Fecha			DATE,
			Hora			VARCHAR(8)  
		)

		INSERT INTO @socio
		SELECT
			[Agrupador]	=	ra.AgrupadorDescripcion,
			[Requisito]	=	ra.RequisitoDescripcion,
			a.Nombre, 
			[Sincronizado] =	a.EstaSincronizado,
			a.Descripcion, 
			[Fecha]			= isnull(a.Fecha,'19000101'),
			[Hora]			= CONVERT(VARCHAR(8), a.Alta, 108)
			FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 
			INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) 
				ON ra.IdRequisito = ex.IdRequisito
			LEFT JOIN dbo.tDIGarchivos a  WITH(NOLOCK) 
				ON a.IdExpediente = ex.IdExpediente
				AND a.IdEstatus=1
			WHERE ex.IdTipoDdominio=208 
				AND ex.IdRegistro=@pIdRegistro
			
		INSERT INTO @socio
		SELECT 
			[Agrupador]	=	ra.AgrupadorDescripcion,
			[Requisito]	=	ra.RequisitoDescripcion,
			a.Nombre, 
			[Sincronizado] =	a.EstaSincronizado,
			a.Descripcion, 
			[Fecha]			= isnull(a.Fecha,'19000101'),
			[Hora]			= CONVERT(VARCHAR(8), a.Alta, 108)
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = c.IdPersona
					AND p.IdSocio=@pIdRegistro 
			INNER JOIN  dbo.tDIGexpediente ex  WITH(NOLOCK) 
				ON ex.IdRegistro=c.IdCuenta
				AND ex.IdTipoDdominio=232
			INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) 
				ON ra.IdRequisito = ex.IdRequisito
			LEFT JOIN dbo.tDIGarchivos a  WITH(NOLOCK) 
				ON a.IdExpediente = ex.IdExpediente
				AND a.IdEstatus=1
			
		SELECT s.Agrupador,
               s.Requisito,
               s.Archivo,
               s.Sincronizado,
               s.Registro,
               s.Fecha,
               s.Hora 
		FROM @socio s
		ORDER BY s.Agrupador, s.Requisito

		RETURN 1
	END

	IF @pTipoOperacion='ARCHIVOS_FECHA' 
	BEGIN
		SELECT
			[Agrupador]		=	ra.AgrupadorDescripcion,
			[Requisito]		=	ra.RequisitoDescripcion,
			[Registro]		=	a.Descripcion, 
			[Archivo]		=	a.Nombre, 
			[Sincronizado]	=	a.EstaSincronizado,
			[Fecha]			= isnull(a.Fecha,'19000101'),
			[Hora]			= CONVERT(VARCHAR(8), a.Alta, 108)
			FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 
			INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) 
				ON ra.IdRequisito = ex.IdRequisito
			INNER JOIN dbo.tDIGarchivos a  WITH(NOLOCK) 
				ON a.IdExpediente = ex.IdExpediente
					AND a.IdEstatus=1
					AND a.Fecha BETWEEN @pFechaInicial AND @pFechaFinal
			WHERE ex.IdTipoDdominio IN (208,232)
			ORDER BY ra.IdAgrupador, ra.RequisitoDescripcion

		RETURN 1
	END

	IF @pTipoOperacion='SIN_ARCHIVOS'
	BEGIN	
			DECLARE @faltantes AS TABLE(
				Identificador		VARCHAR(30),
				Agrupador			VARCHAR(50),
				Requisito			VARCHAR(50),
				Archivo				VARCHAR(250),
				Sincronizado		BIT,
				Registro			VARCHAR(250),
				Fecha				DATE,
				Hora				VARCHAR(8)
			)

			INSERT INTO @faltantes
			SELECT 
				Identificador = p.NumeroSocio,
				[Agrupador]	=	ra.AgrupadorDescripcion,
				[Requisito]	=	ra.RequisitoDescripcion,
				Archivo		=	a.Nombre, 
				[Sincronizado] =	a.EstaSincronizado,
				Registro	=	TRIM(CONCAT(p.NombreRazonSocial,' ',p.Nombre2,' ',p.ApellidoPaterno,' ',p.ApellidoMaterno)),
				[Fecha]			= isnull(a.Fecha,'19000101'),
				[Hora]			= CONVERT(VARCHAR(8), a.Alta, 108)
			FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
			LEFT JOIN dbo.tDIGexpediente ex  WITH(NOLOCK) 
				ON p.IdSocio=ex.IdRegistro
					AND ex.IdTipoDdominio=208
			LEFT JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) 
				ON ra.IdRequisito = ex.IdRequisito
			LEFT JOIN dbo.tDIGarchivos a  WITH(NOLOCK) 
				ON a.IdExpediente = ex.IdExpediente
					AND a.IdEstatus=1
					AND a.IdArchivo IS NULL
			

			INSERT INTO @faltantes
			SELECT
				Identificador	= c.NumeroCuenta,
				[Agrupador]	=	ra.AgrupadorDescripcion,
				[Requisito]	=	ra.RequisitoDescripcion,
				Archivo = a.Nombre, 
				[Sincronizado] =	a.EstaSincronizado,
				Registro = TRIM(CONCAT(c.Descripcion,' ',p.NumeroSocio,' ',p.NombreRazonSocial,' ',p.Nombre2,' ',p.ApellidoPaterno,' ',p.ApellidoMaterno)),
				[Fecha]			= isnull(a.Fecha,'19000101'),
				[Hora]			= CONVERT(VARCHAR(8), a.Alta, 108)
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = c.IdPersona
			LEFT JOIN  dbo.tDIGexpediente ex  WITH(NOLOCK) 
				ON ex.IdRegistro=c.IdCuenta
					AND ex.IdTipoDdominio =232
			LEFT JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) 
				ON ra.IdRequisito = ex.IdRequisito
			LEFT JOIN dbo.tDIGarchivos a  WITH(NOLOCK) 
				ON a.IdExpediente = ex.IdExpediente
					AND a.IdEstatus=1
					AND a.IdArchivo IS NULL	
			
			SELECT f.Identificador,
                   f.Registro,
                   f.Agrupador,
                   f.Requisito,
                   f.Archivo,
                   f.Sincronizado,
                   f.Fecha,
                   f.Hora
			FROM @faltantes f
			ORDER BY f.Agrupador, f.Requisito

			RETURN 1

	END


END