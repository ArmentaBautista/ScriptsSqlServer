
USE iERP_DRA_VAL


SELECT *
FROM sys.objects o 
WHERE o.name LIKE '%BKG%' AND o.type NOT IN ('N','D','PK','F')



DECLARE @nombreBuscado AS VARCHAR(64)='ismael duran'

SELECT 
sc.IdSocio, sc.Codigo, p.IdPersona, p.Nombre
, pf.IdTipoDidentificacion, d.Descripcion
, pf.IFE, pf.NumeroLicencia, pf.NumeroIMMS, pf.NoPasaporte
--, p.*
, c.IdCuenta, c.Codigo, c.Descripcion
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
INNER JOIN dbo.tCATlistasD d  WITH(NOLOCK) ON d.IdListaD = pf.IdTipoDidentificacion
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdEstatus=1
WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'


EXEC dbo.pBKGgetClientsByDocument @documentType=104,
								  @documentId='5140306',
								  @name = '',     
                                  @lastName = '', 
                                  @mail = '',     
                                  @cellPhone = ''


SELECT * FROM dbo.tBKGcatalogoDocumentType

								  
DECLARE @ClientBankIdentifiers AS VARCHAR(24)='010100085840'

SELECT 
	ClientBankIdentifier			= sc.Codigo, 
	ProductBankIdentifier			= pf.Descripcion,
	ProductNumber					= c.Codigo,
	ProductStatusId					= c.IdEstatus,
	ProductTypeId					= pt.ProductTypeId,
	ProductAlias					= pt.ProductTypeName,
	CanTransact						= t.CanTransactType,
	CurrencyId						= 'MXP'
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdEstatus=1 and sc.Codigo= @ClientBankIdentifiers
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = pf.IdProductoFinanciero
	WHERE c.IdEstatus=1 AND c.IdSocio=sc.idSocio


EXEC dbo.pBKGgetProducts @ClientBankIdentifiers = '010100085840', -- varchar(24)
                         @ProductTypes = ''           -- varchar(7)



EXEC pBKGgetProductsConsolidatedPosition @ClientBankIdentifiers = '010100085840', -- varchar(24)
										 @ProductTypes = ''           -- varchar(7)



 -- EXEC dbo.pAYCcalcularCartera @FechaCartera = '20230621', @Idusuario = -1, @SobreEscribirDatos = 1



EXEC dbo.pBKGgetAccountDetails @ProductBankIdentifier = '102-004868' -- varchar(32)
	



exec pAYCcaptacion 

DECLARE @idcuenta INT=78508

DECLARE @parcialidades AS TABLE
	(
		IdParcialidad				INT,
		NumeroParcialidad			INT,
		DiasCalculados				INT,
		Inicio						DATE,
		Vencimiento					DATE,
		IdPeriodo					INT,
		IdCuenta					INT,
		EstaPagada					BIT,
		Fin							DATE,
		IdApertura					INT,
		IdEstatus					INT,
		FechaPago					DATE,
		EsPeriodoGracia				INT,
		EsPeriodoGraciaCapital		BIT
	)

SELECT p.IdParcialidad,
       p.NumeroParcialidad,
       p.DiasCalculados,
       p.Inicio,
       p.Vencimiento,
       p.IdPeriodo,
       p.IdCuenta,
       p.EstaPagada,
       p.Fin,
       p.IdApertura,
       p.IdEstatus,
       p.FechaPago,
       p.EsPeriodoGracia,
       p.EsPeriodoGraciaCapital
FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
WHERE p.IdEstatus=1 AND  p.IdCuenta=@idcuenta



SELECT  * FROM dbo.tAYCcartera ORDER BY FechaCartera DESC


-- EXEC dbo.pAYCcalcularCartera @FechaCartera = '2023-02-21', @Idusuario = -1

SELECT *
FROM dbo.tAYCcaptacion cap  WITH(NOLOCK) 

EXEC dbo.pBKGgetAccountDetails @ProductBankIdentifier = '102-004868' -- varchar(32)
		

SELECT * 
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcaptacion cap  WITH(NOLOCK)  ON cap.IdCuenta = c.IdCuenta
WHERE c.Codigo='01010008584000021'


EXEC pBKGgetAccountMovements @ProductBankIdentifier='01010008584000021',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='098578-00015126-1201',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='000736-00015126-1201',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='000737-00015126-1251',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='093592-00015126-1251',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='101-001500',
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC pBKGgetAccountMovements @ProductBankIdentifier='101-004156', 
							 @DateFromFilter = '20200101', -- date
                             @DateToFilter = '20230301',   -- date
                             @OrderByField = 'MovementDate DESC',             -- varchar(128)
                             @PageStartIndex = 1,            -- int
                             @PageSize = 9999                   -- int

EXEC dbo.pBKGgetAccountMovements @ProductBankIdentifier = '000735-00015126-1201',    -- varchar(32)
                                 @DateFromFilter = '20200101', -- date
                                 @DateToFilter = '20230301',   -- date
                                 @OrderByField = 'MovementDate DESC',             -- varchar(128)
                                 @PageStartIndex = 1,            -- int
                                 @PageSize = 9999                   -- int



USE iERP_KFT
go

EXEC dbo.pBKGgetProductOwnerAndCurrency @ProductNumber = '01010008584000021',       
                                        @ProductTypeId = 0,        
                                        @DocumentType = 1,         
                                        @DocumentId = '5140306',          
                                        @ThirdPartyProductType = 0 



EXEC dbo.pBKGgetProductOwnerAndCurrency @ProductNumber = '01010008584000021'


SELECT * FROM tBKGcatalogoDocumentType


SELECT sc.IdPersona, sc.IdSocio, sc.Codigo, p.Nombre, p.Domicilio, p.IdRelDomicilios, p.IdRelEmails, p.IdRelTelefonos
, pf.IFE,dt.IdDocumentType, t.Telefono
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
															--AND pf.IFE=@DocumentId
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = pf.IdPersona
		INNER JOIN dbo.tBKGcatalogoDocumentType dt  WITH(NOLOCK) ON dt.IdListaDidentificacion=pf.IdTipoDidentificacion 
															--AND dt.IdDocumentType=@DocumentType
		INNER JOIN dbo.tCATtelefonos t  ON t.IdRel=p.IdRelTelefonos
		WHERE sc.IdEstatus=1
AND p.Nombre LIKE '%ismael duran%'



EXEC dbo.pBKGgetLoan  @ProductBankIdentifier = '102-004868',			-- varchar(32)
                      @FeesStatus = 0,					-- int
                      @OrderByField = '',					-- varchar(128)
                      @PageStartIndex = 1,					-- int
                      @PageSize = 999					-- int
					  




SELECT  p.EstaPagada, p.Fin,p.*
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCparcialidades p  WITH(NOLOCK) ON p.IdCuenta = c.IdCuenta
WHERE c.Codigo='102-004868'
ORDER BY p.NumeroParcialidad asc

DECLARE @FeesCount INT;
EXEC pBKGgetLoanFees  '102-004868',		--@ProductBankIdentifier varchar(32)
					  0,				-- @feesstatus
					  '',				--@OrderByField varchar(128)
					  1,				--@PageStartIndex int
					  100,              --@PageSize int
					 @FeesCount OUTPUT
 SELECT @FeesCount

EXEC dbo.pBKGgetLoanRates @ProductBankIdentifier = '102-004868', -- varchar(32)
                          @OrderByField = '',          -- varchar(128)
                          @PageStartIndex = 1,         -- int
                          @PageSize = 999                -- int

EXEC dbo.pBKGgetLoanPayments @ProductBankIdentifier = '102-004868', -- varchar(32)
                             @OrderByField = '',          -- varchar(128)
                             @PageStartIndex = 1,         -- int
                             @PageSize = 100                -- int

/*
101-004667
101-003827
*/

EXEC dbo.pBKGgetTransactionCost @FeatureId = 0,                     -- int
                                @TransactionTypeId = 0,             -- int
                                @SubTransactionTypeId = 0,          -- int
                                @ValueDate = '2023-04-12',          -- date
                                @ClientBankIdentifier = '',         -- varchar(32)
                                @CurrencyId = '',                   -- varchar(16)
                                @Amount = 0,                        -- numeric(18, 2)
                                @DebitProductBankIdentifier = '',   -- varchar(24)
                                @DebitProductTypeId = 0,            -- int
                                @DebitCurrencyId = '',              -- varchar(24)
                                @CreditProductBankIdentifier = '',  -- varchar(24)
                                @CreditProductTypeId = 0,           -- int
                                @CreditCurrencyId = '',             -- varchar(24)
                                @DestinationBankRoutingNumber = '', -- varchar(24)
                                @AuthorizationCode = '',            -- varchar(24)
                                @DocumentNumber = '',               -- varchar(24)
                                @DocumentType = 0,                  -- int
                                @CancelCheckReasonCode = ''         -- varchar(32)


EXEC dbo.pBKGgetProductBankStatements @ClientBankIdentifier = '01-00015126',  -- varchar(24)
                                      @ProductBankIdentifier = '101-004667', -- varchar(24)
                                      @ProductType = 1             -- int


EXEC dbo.pBKGgetProductBankStatementFile @ProductBankIdentifier = '101-004667',    -- varchar(24)
                                         @ProductBankStatementDate = '2023-02', -- varchar(8)
                                         @ProductBankStatementId = '',   -- varchar(128)
                                         @ProductType = 1                -- int


exec pAYCcaptacion



EXEC dbo.pBKGinsertTransaction @SubTransactionTypeId = 0,               -- int
                               @CurrencyId = '',                        -- varchar(8)
                               @ValueDate = '2023-05-03',               -- date
                               @TransactionTypeId = 0,                  -- int
                               @TransactionStatusId = 0,                -- int
                               @ClientBankIdentifier = '',              -- varchar(24)
                               @DebitProductBankIdentifier = '',        -- varchar(32)
                               @DebitProductTypeId = 0,                 -- int
                               @DebitCurrencyId = '',                   -- varchar(8)
                               @CreditProductBankIdentifier = '',       -- varchar(32)
                               @CreditProductTypeId = 0,                -- int
                               @CreditCurrencyId = '',                  -- varchar(8)
                               @Amount = 0,                             -- numeric(18, 2)
                               @NotifyTo = '',                          -- varchar(64)
                               @NotificationChannelId = 0,              -- int
                               @TransactionId = 0,                      -- int
                               @DestinationDocumentId = '',             -- varchar(24)
                               @DestinationName = '',                   -- varchar(32)
                               @DestinationBank = '',                   -- varchar(32)
                               @Description = '',                       -- varchar(32)
                               @BankRoutingNumber = '',                 -- varchar(32)
                               @SourceName = '',                        -- varchar(32)
                               @SourceBank = '',                        -- varchar(32)
                               @SourceDocumentId = '',                  -- varchar(32)
                               @RegulationAmountExceeded = NULL,        -- bit
                               @SourceFunds = '',                       -- varchar(32)
                               @DestinationFunds = '',                  -- varchar(32)
                               @UserDocumentId = '',                    -- varchar(32)
                               @TransactionCost = 0,                    -- numeric(18, 2)
                               @TransactionCostCurrencyId = '',         -- varchar(8)
                               @ExchangeRate = 0,                       -- numeric(4, 2)
                               @CountryIntermediaryInstitution = '',    -- varchar(32)
                               @IntermediaryInstitution = '',           -- varchar(32)
                               @RouteNumberIntermediaryInstitution = '' -- varchar(32)


SELECT * FROM dbo.tBKGcatalogoCanTransactType

							   
SELECT
	'INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) ' + 
	CONCAT('VALUES (',pf.IdProductoFinanciero,',') +
	CAST(
	CASE c.IdTipoDProducto
		WHEN 144 THEN 1
		WHEN 398 THEN 0
		WHEN 143 THEN 2
		WHEN 716 THEN 0
	END AS CHAR(1)) +
	') ', -- + CHAR(13) + 'GO'  + CHAR(13),
	pf.IdProductoFinanciero, pf.Descripcion
	FROM dbo.tAYCproductosFinancieros pf 
	INNER JOIN dbo.tAYCcuentas c ON c.IdProductoFinanciero = pf.IdProductoFinanciero AND c.IdEstatus=1
	WHERE pf.IdTipoDDominioCatalogo IN (144,398,143,716)
	GROUP BY pf.IdProductoFinanciero, pf.Descripcion,c.IdTipoDProducto
	ORDER BY pf.IdProductoFinanciero


SELECT pf.IdProductoFinanciero, pf.Codigo, pf.Descripcion, pf.IdTipoDDominioCatalogo
, ct.CanTransactType, ct.Descripcion
FROM dbo.tBKGproductosCanTransactType pct  WITH(NOLOCK) 
INNER JOIN dbo.tBKGcatalogoCanTransactType ct  WITH(NOLOCK) ON ct.CanTransactType = pct.CanTransactType
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = pct.IdProducto
ORDER BY pf.IdTipoDDominioCatalogo, pct.IdProducto


SELECT pct.IdProducto, pct.CanTransactType
FROM dbo.tBKGproductosCanTransactType pct  WITH(NOLOCK) 
WHERE pct.IdProducto IN (101,133,144)


SELECT * FROM dbo.tBKGcatalogoProductTypes


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Get Voucher

DECLARE @idOperacion AS INT

SELECT @idOperacion=op.IdOperacion FROM dbo.tGRLoperaciones op  WITH(NOLOCK) WHERE op.Folio=484296	


DECLARE @RazonSocial VARCHAR(128);
--EXEC dbo.pBKGgetTransactionVoucher @TransactionVoucherIdentifier = '1051377', @RazonSocial = @RazonSocial OUTPUT  -- varchar(128)



SELECT * FROM fFMTticketTransaccionFinancieraBKG(@idOperacion)

SELECT * FROM vFMTticketBKG v  WITH(NOLOCK) WHERE v.IdOperacion=@idOperacion

SELECT * FROM vFMTticketTransaccionBKG v  WITH(NOLOCK) WHERE v.IdOperacion=@idOperacion

SELECT * FROM vFMTticketOperacionesRelacionadasDetalleBKG v  WITH(NOLOCK) WHERE v.IdOperacion=@idOperacion



-- SELECT op.IdOperacion, folio FROM dbo.tGRLoperaciones op  WITH(NOLOCK)  ORDER BY op.IdOperacion desc
/*
484299
484298
484297
484296
*/



SELECT c.* 
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
		AND p.Nombre LIKE '%carolina maldon%'
WHERE c.IdTipoDProducto=398



-- 01010003727500111

EXEC dbo.pBKGgetFixedTermDeposit @pProductBankIdentifier = '01010003727500111' -- varchar(32)
