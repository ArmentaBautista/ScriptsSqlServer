-- 11 pBKGgetProductOwnerAndCurrency

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductOwnerAndCurrency')
BEGIN
	DROP PROC pBKGgetProductOwnerAndCurrency
	SELECT 'pBKGgetProductOwnerAndCurrency BORRADO' AS info
END
GO

CREATE PROC pBKGgetProductOwnerAndCurrency
@ProductNumber VARCHAR(24),		-- Numero de Cuenta
@ProductTypeId INT = 1,				-- Tipo de producto
@DocumentType INT = 1,				-- Identificación del socio
@DocumentId VARCHAR(24) = '',		-- Número de identificación
@ThirdPartyProductType INT = 1		-- Tipo de Operación 
AS
BEGIN

--#region
	/*		
	ClientBankIdentifiers				List<string>	Lista de identificadores del backend de Clientes para registrar el producto de terceros (solo aplica en caso de que la propiedad sea un parámetro de entrada)
	ThirdPartyProductNumber				string			Número de producto de terceros
	ThirdPartyProductBankIdentifier		string			Identificador interno del producto en caso de que el producto pertenezca a la propia organización
	Alias								string			Alias del producto de terceros
	CurrencyId							string			Identificador de la moneda del producto de terceros según catálogo Currencies.
	TransactionSubType					int				Sub tipo de la transacción para la cual el produco de terceros es registrado, según catálogo TransactionSubTypes
	ThirdPartyProductType				int				Tipo de producto de terceros según catálogo ThirdPartyProductTypes
	ProductType							int				Tipo de producto según catálogo ProductTypes
	OwnerName							string			Nombre completo del titular del producto de terceros.
	OwnerCountryId						string			Pais del titular del producto de terceros
	OwnerEmail							string			Correo electrónico del titular del producto de terceros
	OwnerCity							string			Ciudad del titular del producto de terceros
	OwnerAddress						string			Dirección completa del titular del producto de terceros
	OwnerDocumentId						DocumentId		Tipo (según DocumentType) y número de documento de identidad del titular del producto de terceros.
	OwnerPhoneNumber					string			Teléfono de contacto del titular del producto de terceros
	Bank								Bank			Banco del produco de terceros (ver entidad Bank). Solo se utiliza para productos de terceros fuera de la institución.
	CorrespondentBank					Bank			Banco corresponsal (ver entidad Bank). Es opcional no es requerida.
	UserDocumentId						DocumentId		Tipo (según DocumentType) y número de documento de identidad del Usuario que ejecuta la operación.
	*/
--#endregion


--  Variables
	DECLARE @idSocio INT;
	DECLARE @noSocio VARCHAR(24);
	DECLARE @idPersona INT;
	DECLARE @idCuenta INT;
	
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- JCA 20230505 Inicialmente este método obtenúa el socio y la persona por el documento de identidad y el número de esta.
--				Posteriormente se toma la desición por BKG y KFT de buscar solo por el número de cuenta.

-- 0. Cuenta
	DECLARE @cuenta AS TABLE
	(
		IdCuenta		INT,
		NoCuenta		VARCHAR(32),
		Alias			VARCHAR(80),
		ProductType		INT,
		IdSocio			INT
	)

	INSERT INTO @cuenta
	(
	    IdCuenta,
	    NoCuenta,
		Alias,
	    ProductType,
	    IdSocio
	)
	SELECT c.IdCuenta,c.Codigo, pf.Descripcion, pt.ProductTypeId, c.IdSocio
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	WHERE c.Codigo=@ProductNumber
	
	SET @idSocio= (SELECT TOP 1 c.IdSocio FROM @cuenta c)

-- 1. Validar socio, por documento y número
		DECLARE @persona AS TABLE
		(
			IdPersona			INT,
			IdSocio				INT,
			NoSocio				VARCHAR(24),
			Nombre				VARCHAR(64),
			Domicilio			VARCHAR(256),
			IdRelDomicilios		INT,
			IdRelEmails			INT,
			IdRelTelefonos		INT,
			DocumentType		INT,
			DocumentId			VARCHAR(24)
		)

		INSERT INTO @persona
		(
		    IdPersona,
		    IdSocio,
		    NoSocio,
		    Nombre,
		    Domicilio,
		    IdRelDomicilios,
		    IdRelEmails,
		    IdRelTelefonos,
			DocumentType,
			DocumentId
		)
		SELECT sc.IdPersona, sc.IdSocio, sc.Codigo, p.Nombre, p.Domicilio, p.IdRelDomicilios, p.IdRelEmails, p.IdRelTelefonos, dt.IdDocumentType, pf.IFE
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
															-- AND pf.IFE=@DocumentId				-- Se suprime el filtro por acuerdo con la entidad
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = pf.IdPersona
		INNER JOIN dbo.tBKGcatalogoDocumentType dt  WITH(NOLOCK) ON dt.IdListaDidentificacion=pf.IdTipoDidentificacion 
															-- AND dt.IdDocumentType=@DocumentType  -- Se suprime el filtro por acuerdo con la entidad
		WHERE sc.IdEstatus=1 AND sc.IdSocio=@idSocio

		-- Variables de identificación 
		SELECT TOP 1 @DocumentType=p.DocumentType, @DocumentId=p.DocumentId FROM @persona p

		IF NOT EXISTS(SELECT 1 FROM @persona)
		BEGIN
			RAISERROR ('Socio no encontrado con los datos de indentificación proporcionados.', 1, 1);
			RETURN -1
		END
		--SELECT * FROM @persona

-- 1.1 Correos

		DECLARE @emails AS TABLE
		(
			IdPersona INT,
			IdRel INT,
			IdMail INT,
			IdListaD INT,
			Tipo VARCHAR(24),
			Email VARCHAR(128)
		)

		INSERT INTO @emails (idpersona,IdRel, IdMail, IdListaD, Tipo, Email)
		SELECT TOP 1 p.IdPersona,m.IdRel, m.IdEmail, ld.IdListaD, ld.Descripcion, m.email 
		FROM dbo.tCATemails m  WITH(NOLOCK) 
		INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = m.IdListaD
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = m.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN @persona p ON p.IdRelEmails=m.IdRel 

		--SELECT * FROM @emails

-- 1.2 Teléfonos

		DECLARE @telefonos AS TABLE
		(
			IdPersona INT,
			IdRel	INT, 
			IdTelefono	INT,
			IdListaD	INT,
			Tipo		VARCHAR(24),
			Telefono	VARCHAR(10)
		)

		INSERT INTO @telefonos (IdPersona,IdRel,IdTelefono,IdListaD,Tipo,Telefono)
		SELECT TOP 1 p.IdPersona,t.IdRel, t.IdTelefono, t.IdListaD, ld.Descripcion, t.Telefono
		FROM dbo.tCATtelefonos t  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = t.IdListaD
		INNER JOIN @persona p ON p.IdRelTelefonos=t.IdRel 
		WHERE t.IdListaD=-1339 

		--SELECT * FROM @telefonos

-- 1.3 Domicilio
		
		DECLARE @domicilios AS TABLE
		(
			IdPersona		INT,
			IdRel			INT,
			IdDomicilio		INT,
			IdAsentamiento	INT,
			Asentamiento	VARCHAR(64),
			IdCiudad		INT,
			Ciudad			VARCHAR(64),
			IdPais			INT,
			Pais			VARCHAR(24)
		)

		INSERT INTO @domicilios
		(
		    IdPersona,
		    IdRel,
		    IdDomicilio,
		    IdAsentamiento,
		    Asentamiento,
		    IdCiudad,
		    Ciudad,
		    IdPais,
		    Pais
		)
		SELECT TOP 1 p.IdPersona, dom.IdRel, dom.IdDomicilio, dom.IdAsentamiento, dom.Asentamiento, dom.IdCiudad, dom.Ciudad, dom.IdPais, dom.Pais
		FROM @persona p 
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdRel=p.IdRelDomicilios
														AND dom.IdTipoD=11
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual
														AND ea.IdEstatus=1

		--SELECT * FROM @domicilios

-- 2. Validar cuenta por número y tipo
		
		--SELECT @idCuenta = c.IdCuenta
		--FROM dbo.tAYCcuentas c  WITH(NOLOCK)
		--INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
		--														AND pt.ProductTypeId=@ProductTypeId
		--WHERE c.Codigo=@ProductNumber
		--AND c.IdEstatus=1
		--AND c.IdSocio=@idSocio

		--IF @idCuenta=0
		--	RAISERROR ('El Socio y la Cuenta proporcionados no coinciden', 1, 1);

-- 3. Validar el tipo de operación de terceros

		IF @ThirdPartyProductType IN (2,3,4,5)
		begin
			RAISERROR ('ThirdPartyProductType no permitido', 1, 1);
			RETURN -1
		END
-- 4. Consulta

SELECT 
	ClientBankIdentifiers				= p.NoSocio,
	ThirdPartyProductNumber				= c.NoCuenta,
	ThirdPartyProductBankIdentifier		= c.NoCuenta,
	Alias								= c.Alias,
	CurrencyId							= '484',
	TransactionSubType					= 2,
	ThirdPartyProductType				= 1,
	ProductType							= c.ProductType,
	OwnerName							= p.Nombre,
	OwnerCountryId						= dom.Pais,
	OwnerEmail							= m.Email,
	OwnerCity							= IIF(dom.Ciudad IS NULL,dom.Asentamiento,dom.Ciudad),
	OwnerAddress						= p.Domicilio,
	OwnerDocumentId						= @DocumentId,
	OwnerPhoneNumber					= t.Telefono
	FROM @persona p
	INNER JOIN @cuenta c ON c.IdSocio = p.IdSocio						
	LEFT JOIN @domicilios dom ON dom.IdRel=p.IdRelDomicilios
	LEFT JOIN @emails m on m.IdRel = p.IdRelEmails
	LEFT JOIN @telefonos t ON t.IdRel = p.IdRelTelefonos


END
GO
