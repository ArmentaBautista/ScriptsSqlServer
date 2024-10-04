

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaPerfilSocio2')
BEGIN
	DROP PROC pEMbusquedaPerfilSocio2
	SELECT 'pEMbusquedaPerfilSocio2 BORRADO' AS info
END
GO

CREATE PROC pEMbusquedaPerfilSocio2
@Socio AS VARCHAR(50) =''
AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN		
		DECLARE @IdSocio AS INT =0
		DECLARE @IdPersona AS INT =0

		SELECT @IdSocio = idsocio, @IdPersona=s.IdPersona FROM dbo.tSCSsocios s With (nolock) WHERE s.Codigo=@Socio

		IF @IdSocio=NULL OR @IdSocio=0
			RETURN 0

		PRINT @IdPersona

		-- Correos begin
		DECLARE @correos AS TABLE(
			Id INT PRIMARY KEY IDENTITY,
			IdPersona INT,
			Email VARCHAR(50) NULL
		)

		INSERT INTO @correos (IdPersona,Email)
		SELECT p.IdPersona, e.email
		FROM dbo.tCATemails e  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdRelEmails=e.IdRel AND p.IdPersona=@IdPersona
		INNER JOIN dbo.tCTLestatusActual ea WITH(NOLOCK)ON ea.IdEstatusActual = e.IdEstatusActual
														AND ea.IdTipoDDominio=213
														AND ea.IdEstatus=1
		WHERE e.EsPrincipal=1
		-- Correos end

		-- teléfonos begin
		
		DECLARE @tels AS TABLE(
			Id INT PRIMARY KEY IDENTITY,
			IdPersona INT,
			Telefono VARCHAR(15) NULL,
			Extension varCHAR(3) NULL,
			TipoTelefono VARCHAR(10)
		)

		INSERT INTO @tels (IdPersona,Telefono,Extension,TipoTelefono)
		SELECT 
			p.IdPersona
			,CONCAT ( tel.CodigoArea,' ',tel.Telefono) AS Telefono
			,tel.Extension
			,CASE tel.IdListaD 
				WHEN -1338 THEN 'EvePhone'
				WHEN -1340 THEN 'DayPhone'
				WHEN -1339 THEN 'CellPhone' 
				ELSE '' 
			 END AS TipoTelefono
			FROM dbo.tCATtelefonos tel WITH(NOLOCK)
			JOIN dbo.tCTLestatusActual ea WITH(NOLOCK) ON ea.IdEstatusActual = tel.IdEstatusActual
													   AND ea.IdTipoDDominio=219
													   AND ea.IdEstatus=1
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdRelTelefonos=tel.IdRel AND p.IdPersona=@IdPersona
		-- teléfonos end

		/*Domicilios begin*/
		DECLARE @domicilios AS TABLE(
			Id INT PRIMARY KEY IDENTITY,
			IdPais INT,
			NumeroExterior VARCHAR(24),
			NumeroInterior VARCHAR(24),
			Calle VARCHAR(80),
			Colonia VARCHAR(80),
			Ciudad VARCHAR(80),
			Estado VARCHAR(80),
			CodigoPostal VARCHAR(80),
			Pais VARCHAR(80),
			IdRel INT,
			IdDomicilio INT

		)


		INSERT INTO @domicilios
		(
		    IdPais,
		    NumeroExterior,
		    NumeroInterior,
		    Calle,
		    Colonia,
		    Ciudad,
		    Estado,
		    CodigoPostal,
		    Pais,
		    IdRel,
		    IdDomicilio
		)
		
		SELECT		 pa.IdPais, dom.NumeroExterior,dom.NumeroInterior,
					 dom.Calle,a.Descripcion AS colonia,
					 c.Descripcion AS Ciudad
					 ,e.Descripcion AS Estado
					 ,dom.CodigoPostal
					 ,pa.Descripcion AS Pais,
					 dom.IdRel,dom.IdDomicilio 
					 FROM dbo.tCATdomicilios dom WITH(NOLOCK)
					 JOIN dbo.tCTLestatusActual ea WITH(NOLOCK)ON ea.IdEstatusActual = dom.IdEstatusActual
																AND ea.IdEstatus=1 
					 JOIN dbo.tCTLasentamientos a WITH(NOLOCK)ON a.IdAsentamiento = dom.IdAsentamiento
					 JOIN dbo.tCTLciudades c WITH(NOLOCK)ON c.IdCiudad = dom.IdCiudad 
					 JOIN dbo.tCTLestados e WITH(NOLOCK)ON e.IdEstado = dom.IdEstado
					 JOIN dbo.tCTLpaises pa WITH(NOLOCK)ON pa.IdPais = dom.IdPais
					 INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdRelDomicilios=dom.IdRel
																	AND per.IdPersona=@IdPersona
					 WHERE dom.IdTipoD=11  

		/*Domicilios end*/

		-- PRINCIPAL

		SELECT s.IdSocio,s.codigo AS CodigoSocio,p.IdPersona, 
				CASE  s.IdEstatus  
					WHEN 1 THEN 'Active'
					WHEN 3 THEN 'Inactive'
					WHEN 2 THEN 'Inactive'
					WHEN 105 THEN 'Inactive'
				END EstatusSocio
				,p.RFC AS INE,
				CASE p.EsPersonaMoral WHEN 1 THEN  p.Nombre ELSE pf.Nombre END Nombre,
				CASE p.EsPersonaMoral WHEN 0 THEN  pf.ApellidoPaterno ELSE '' END ApellidoPaterno,
				CASE p.EsPersonaMoral WHEN 0 THEN  pf.ApellidoMaterno ELSE '' END ApellidoMaterno,
				domi.NumeroExterior,domi.NumeroInterior,domi.Calle,domi.colonia,domi.Ciudad,domi.Estado,
				domi.CodigoPostal,
				CASE domi.IdPais
					WHEN 142 THEN 'MEX'
					WHEN 95 THEN 'HND'
					WHEN 70 THEN 'USA' 
				END AS Pais,
				telefono.TipoTelefono,telefono,telefono.Extension,
				correo.email
				,pf.Sexo
				,YEAR(pf.FechaNacimiento) AS AñoNacimiento
				--,LEFT (REPLACE(str(MONTH(pf.FechaNacimiento), 2), ' ', '0'),2 ) AS MesNacimiento
				,FORMAT(MONTH(pf.FechaNacimiento),'00') AS MesNacimiento
				,FORMAT(DAY(pf.FechaNacimiento),'00') AS DiaNacimiento
		  FROM dbo.tSCSsocios s WITH(NOLOCK)
		  JOIN dbo.tGRLpersonas p WITH(NOLOCK)ON p.IdPersona = s.IdPersona
		  LEFT JOIN dbo.tGRLpersonasFisicas pf WITH(NOLOCK)ON pf.IdPersonaFisica = p.IdPersonaFisica
		  LEFT JOIN dbo.tGRLpersonasMorales pm WITH(NOLOCK)ON pm.IdPersonaMoral = p.IdPersonaMoral
		  LEFT JOIN @domicilios AS domi ON domi.IdRel=p.IdRelDomicilios AND domi.Id = 1
		  LEFT JOIN @tels AS telefono ON telefono.IdPersona = p.IdPersona AND telefono.Id=1
		  LEFT JOIN @correos AS correo ON correo.IdPersona = p.IdPersona AND correo.Id =1
		  WHERE s.IdSocio=@IdSocio
	END
 






GO

