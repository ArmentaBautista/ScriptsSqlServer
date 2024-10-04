SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER PROC dbo.[pa_gen_fac_aut_JCA]
AS
BEGIN
	SELECT tiempo = GETDATE(), mensaje = 'Empieza el procedure'
	--Declaración de variables
	BEGIN
		--Para cursor de factura
		DECLARE
		@idFacImp AS BIGINT,
		@serieImp AS VARCHAR(10),
		@numeroImp AS INT,
		@fechaImp AS DATETIME,
		@idTipDocImp AS INT,
		@cmtImp AS VARCHAR(300),
		@notaImp AS VARCHAR(255),
		@diasImp AS INT,
		@fecVencImp AS DATETIME,
		@fecRegSEImp AS DATETIME,
		@fecEstCobImp AS DATETIME,
		@fecRevImp AS DATETIME,
		@cveClienteImp AS VARCHAR(12),
		@idOtrSisCliImp AS VARCHAR(25),
		@cveFaImp AS VARCHAR(12),
		@subImp AS FLOAT,
		@imptosImp AS FLOAT,
		@totalImp AS FLOAT,
		@monedaImp AS VARCHAR(5),
		@tipCamImp AS FLOAT,
		@cndPagImp AS INT,
		@mtdPagImp AS VARCHAR(MAX),
		@cveSucImp AS VARCHAR(15),
		@numPolImp AS VARCHAR(MAX),
		@usoCFDIImp AS VARCHAR(100),
		@idFacCliImp AS BIGINT,
		@mtdPag2Imp AS VARCHAR(100)

		--Para procedure de encabezado
		DECLARE
		@operFac AS INT,
		@tipoFac AS INT,
		@idFac AS INT,
		@idCli AS INT,
		@idCliPad AS INT,
		@serieFac AS VARCHAR(10),
		@numeroFac AS INT,
		@idMda AS INT,
		@saldoFac AS FLOAT,
		@idUsr AS INT,
		@idSuc AS INT,
		@cMdaBse AS TINYINT,
		@statusFac AS INT,
		@fecEstPag AS DATETIME,
		@idNota AS INT,
		@idVend AS INT,
		@operMda AS INT,
		@idCpt AS INT,
		@idClasCli AS INT,
		@idFA AS INT,
		@idCto AS INT,
		@idCtoCat AS INT,
		@idRelImpDoc AS INT,
		@idRelDa AS INT,
		@idCliDaMer AS INT,
		@idUsoCFDI AS INT
	
		--Para procedure de cliente
		DECLARE
		@nom1 AS VARCHAR(128),
		@nom2 AS VARCHAR(128),
		@dir1 AS VARCHAR(255),
		@ciu AS VARCHAR(80),
		@est AS VARCHAR(30),
		@cp AS VARCHAR(10),
		@rfc AS VARCHAR(40),
		@tel1 AS VARCHAR(30),
		@tel2 AS VARCHAR(30),
		@tipTrn AS INT,
		@tipGrp AS INT,
		@cIepsDesg AS TINYINT,
		@numApr AS INT,
		@idSerFol AS INT,
		@idTipFac AS INT,
		@uuid AS VARCHAR(36),
		@selloSAT AS VARCHAR(255),
		@cbb AS VARCHAR(MAX),
		@idPac AS INT,
		@calle AS VARCHAR(500),
		@numInt AS VARCHAR(30),
		@numExt AS VARCHAR(120),
		@colonia AS VARCHAR(70),
		@delegacion AS VARCHAR(125),
		@calles AS VARCHAR(500),
		@idPais AS INT,
		@idEdo AS INT,
		@idComprobante AS INT,
		@fecCertSAT AS DATETIME,
		@certificado AS VARCHAR(100),
		@xmlCanc AS XML,
		@idSerie AS INT,
		@cTimb AS TINYINT,
		@ultDigCta AS VARCHAR(50),
		@idSugar AS VARCHAR(36),
		@idCliCta AS INT,
		@tipPagCta AS VARCHAR(MAX),
		@bcoCta AS VARCHAR(MAX),
		@idsCtas AS VARCHAR(MAX),
		@usoCFDIDes AS VARCHAR(250),
		@cCompCp AS VARCHAR(50),
		@idRegFisc AS INT

		--Para procedure de partidas
		DECLARE
		@idFacDet AS INT

		--Para cursor de partidas
		DECLARE
		@idFacDetPImp AS BIGINT,
		@cveProPImp AS VARCHAR(25),
		@idOtrSisProPImp AS VARCHAR(25),
		@descripcionPImp AS VARCHAR(250),
		@cantPImp AS FLOAT,
		@udmPImp AS VARCHAR(5),
		@subPImp AS FLOAT,
		@dctoMtoPImp AS FLOAT,
		@imptosPImp AS FLOAT,
		@totalPImp AS FLOAT,
		@idImptoPImp AS INT,
		@costoPImp AS FLOAT,
		@costoTotalPImp AS FLOAT,
		@codAlmPImp AS VARCHAR(10),
		@idOtrSisAlmPImp AS VARCHAR(25),
		@cenCtoPImp AS VARCHAR(10),
		@codSrvPImp AS VARCHAR(64),
		@numPedCliPImp AS VARCHAR(50),
		@fecReqPImp AS DATETIME,
		@numRefPImp AS VARCHAR(64),
		@cmtPImp AS VARCHAR(50)

		--Para armar partidas
		DECLARE
		@idFacDetPC AS INT,
		@idDocVtaPC AS INT,
		@subPC AS FLOAT,
		@imptosPC AS FLOAT,
		@totalPC AS FLOAT,
		@idSucPC AS INT,
		@noPartPC AS INT,
		@idProPC AS INT,
		@udmPC AS VARCHAR(10),
		@cantPC AS FLOAT,
		@precioOrigPC AS FLOAT,
		@promocPC AS FLOAT,
		@precioPubPC AS FLOAT,
		@dctoPtgPC AS FLOAT,
		@precioCimptosPC AS FLOAT,
		@importeCimptosPC AS FLOAT,
		@precioPubSimptosPC AS FLOAT,
		@precioSimptosPC AS FLOAT,
		@importeSimptosPC AS FLOAT,
		@montoSImptosPC AS FLOAT,
		@idImptoPC AS INT,
		@cCambioPrecPC AS TINYINT,
		@costoPC AS FLOAT,
		@montoDesctoPC AS FLOAT,
		@costoTotalPC AS FLOAT,
		@idAlmacPC AS INT,
		@idNotaPC AS INT,
		@tipoPC AS TINYINT,
		@tipoProPC AS TINYINT,
		@esSubPC AS TINYINT,
		@cantDevPC AS FLOAT,
		@porFacturarPC AS FLOAT,
		@idRemPC AS INT,
		@idRemPartPC AS INT,
		@idMdaPC AS INT,
		@tcPC AS FLOAT,
		@operPC AS TINYINT,
		@idComSerLotPC AS INT,
		@diasEntPC AS INT,
		@fecPromPC AS DATETIME,
		@fecEmbPC AS DATETIME,
		@fecReqPC AS DATETIME,
		@idPrgEntFacDetPC AS INT,
		@cantSurtPC AS FLOAT,
		@porSolicPC AS FLOAT,
		@idPartPadPC AS INT,
		@idProOrdPC AS INT,
		@cantOrdProPC AS FLOAT,
		@idProLisPC AS INT,
		@idLisPrePC AS INT,
		@cPrecModifPC AS TINYINT,
		@idKardexPC AS INT,
		@idCodSrvPC AS INT,
		@idCenCtoPC AS INT,
		@idRefPC AS INT,
		@idUdmPC AS INT,
		@ftrPC AS FLOAT,
		@idPedPC AS INT,
		@idPedPartPC AS INT,
		@numPedPC AS INT,
		@idCotPC AS INT,
		@idCotPartPC AS INT,
		@numCotPC AS INT,
		@idSptPC AS INT,
		@idSptPartPC AS INT,
		@numSptPC AS INT,
		@idPadPC AS INT,
		@idTipDocPadPC AS INT,
		@numPadPC AS INT,
		@numPedCliPC AS VARCHAR(50),
		@numReqCliPC AS VARCHAR(50),
		@idClasProPC AS INT,
		@idRelImptoPC AS INT,
		@numRemPC AS INT,
		@operacionPC AS TINYINT,
		@idTipDocPC AS INT,
		@numDocPC AS INT,
		@idUsrPC AS INT,
		@idKitPC AS INT,
		@cantKitsPC AS FLOAT,
		@statusPC AS TINYINT,
		@numDocCnlPC AS INT,
		@idSisCnlPC AS INT,
		@idNotaCnlPC AS INT,
		@fecAplCnlPC AS DATETIME,
		@idActPC AS INT,
		@idClasActPC AS INT,
		@valorBasePC AS FLOAT,
		@depAcuPC AS FLOAT,
		@depRemPC AS FLOAT,
		@campo1PC AS INT,
		@campo2PC AS INT,
		@campo3PC AS INT,
		@campo4PC AS FLOAT,
		@campo5PC AS VARCHAR(50),
		@campo6PC AS VARCHAR(50),
		@campo7PC AS VARCHAR(50),
		@campo8PC AS VARCHAR(50),
		@campo9PC AS VARCHAR(50),
		@campo10PC AS DATETIME,
		@cPrgPC AS TINYINT,
		@idProPaqPC AS INT,
		@idPartOriPC AS INT,
		@secPC AS INT,
		@idIntPC AS INT,
		@idCliCtaDePC AS INT,
		@idRefDetPC AS INT,
		@ptgKitPC AS FLOAT,
		@idCptPC AS INT,
		@cmtPC AS VARCHAR(50),
		@RefExtPC AS VARCHAR(64),
		@baseGravPC AS FLOAT,
		@tipHonPC AS INT,
		@ptgHonPC AS FLOAT,
		@modImptoPC AS TINYINT,
		@precioExtPC AS FLOAT,
		@Campo11PC AS INT,
		@Campo12PC AS INT,
		@Campo13PC AS INT,
		@Campo14PC AS INT,
		@Campo15PC AS INT,
		@Campo16PC AS INT,
		@Campo17PC AS FLOAT,
		@Campo18PC AS FLOAT,
		@Campo19PC AS FLOAT,
		@Campo20PC AS FLOAT,
		@Campo21PC AS FLOAT,
		@Campo22PC AS FLOAT,
		@Campo23PC AS FLOAT,
		@Campo24PC AS FLOAT,
		@Campo25PC AS FLOAT,
		@Campo26PC AS DATETIME,
		@Campo27PC AS DATETIME,
		@Campo28PC AS DATETIME,
		@Campo29PC AS DATETIME,
		@Campo30PC AS VARCHAR(50),
		@Campo31PC AS VARCHAR(50),
		@Campo32PC AS VARCHAR(50),
		@Campo33PC AS VARCHAR(50),
		@Campo34PC AS VARCHAR(50),
		@Campo35PC AS VARCHAR(50),
		@Campo36PC AS VARCHAR(50),
		@Campo37PC AS VARCHAR(50),
		@Campo38PC AS VARCHAR(50),
		@Campo39PC AS VARCHAR(50),
		@Campo40PC AS VARCHAR(50),
		@IdNota2PC AS INT,
		@IdNota3PC AS INT,
		@tipComPC AS TINYINT,
		@ptgComPC AS FLOAT,
		@mtoComPC AS FLOAT,
		@idSisLisPrePC AS INT,
		@idTarHonPC AS INT,
		@desTarHonPC AS VARCHAR(50),
		@idFisRelPC AS INT,
		@idOpeExtPC AS INT,
		@AfeInvKardexPC AS TINYINT,
		@idPartAlmSirPC AS INT,
		@diasAlmSirPC AS FLOAT,
		@diasLibAlmSirPC AS FLOAT,
		@diasDctoAlmSirPC AS FLOAT,
		@fecCorteAlmSirPC AS DATETIME,
		@idAlmjeGralPC AS INT,
		@idAlmjeEspPC AS INT,
		@desHonPC AS VARCHAR(50),
		@desPC AS VARCHAR(254),
		@cAfeExisVtaPC AS TINYINT,
		@idComPC AS INT,
		@numGrpPC AS INT,
		@cantSurtAutPC AS FLOAT,
		@apartadoPC AS FLOAT,
		@backorderPC AS FLOAT,
		@fecPedCliPC AS DATETIME,
		@aumPtgPC AS FLOAT,
		@cantTraspPC AS FLOAT,
		@idTurReqPC AS INT,
		@idTurPromPC AS INT,
		@idMovPartPC AS INT,
		@noPartPadPC AS INT,
		@idFacDetKitPC AS INT,
		@cPtgIngPC AS TINYINT,
		@ptgIngPC AS FLOAT,
		@idProvTerPC AS INT,
		@rfcProvPC AS VARCHAR(250),
		@nomProvPC AS VARCHAR(250),
		@calleProvPC AS VARCHAR(250),
		@numExtProvPC AS VARCHAR(250),
		@numIntProvPC AS VARCHAR(250),
		@colProvPC AS VARCHAR(250),
		@locProvPC AS VARCHAR(250),
		@refProvPC AS VARCHAR(250),
		@munProvPC AS VARCHAR(250),
		@edoProvPC AS VARCHAR(250),
		@paisProvPC AS VARCHAR(250),
		@cpProvPC AS VARCHAR(250),
		@numAduPC AS VARCHAR(250),
		@fecAduPC AS DATETIME,
		@aduanaPC AS VARCHAR(250),
		@ctaPredNumPC AS VARCHAR(250),
		@idRelGasPC AS INT,
		@cProvGasCorPC AS TINYINT,
		@mtoDesctoCouponPC AS FLOAT,
		@mtoDesctoVoucherPC AS FLOAT,
		@mtoIngresosConfirmadoPC AS FLOAT,
		@mtoIngresosFuturosPC AS FLOAT,
		@mtoOtrosIngresosPC AS FLOAT,
		@sub_bse AS float,
		@imptos_bse AS float,
		@total_bse AS float,
		@precio_orig_bse AS float,
		@precio_pub_bse AS float,
		@precio_cimptos_bse AS float,
		@importe_cimptos_bse AS float,
		@precio_pub_simptos_bse AS float,
		@precio_simptos_bse AS float,
		@importe_simptos_bse AS float,
		@monto_imptos_bse AS float,
		@monto_descto_bse AS float,
		@mtoDesctoCoupon_bse AS FLOAT,
		@mtoDesctoVoucher_bse AS FLOAT,
		@mtoIngresosConfirmado_bse AS FLOAT,
		@mtoIngresosFuturos_bse AS FLOAT,
		@mtoOtrosIngresos_bse AS FLOAT

		--Para armar los impuestos
		DECLARE
		@idEI AS INT,
		@mtoImptoInversoEI AS FLOAT,
		@montoBaseEI AS FLOAT,
		@montoImpuestosEI AS FLOAT,
		@totImpuestosEI AS INT,
		@descripcionImpuestosEI AS VARCHAR(MAX),
		@modificadoEI AS TINYINT,
		@idImpEI AS INT,
		@descripcionEI AS VARCHAR(MAX),
		@tasaEI AS FLOAT,
		@montoEI AS FLOAT,
		@idCtaEI AS INT,
		@cIvaEI AS INT,
		@cRetEI AS INT,
		@cExeEI AS INT,
		@tipImptoEI AS INT,
		@idTipImptoEI AS INT,
		@cBaseIvaEI AS TINYINT,
		@ImpCDesEI AS VARCHAR(MAX),
		@ImpCTasaEI AS FLOAT,
		@ImpCFtrEI AS FLOAT,
		@ImpCCantEI AS FLOAT,
		@ImpCUDCEI AS FLOAT,
		@ImpCMtoEI AS FLOAT

		--Para cursor de impuestos
		DECLARE
		@idFacDetCI AS INT,
		@idSisImpCI AS INT,
		@idRelImpCI AS INT,
		@idTipDocCI AS INT,
		@idDocCI AS INT,
		@idDocPartCI AS INT,
		@numDocCI AS INT,
		@fecDocCI AS DATETIME,
		@idCliCI AS INT,
		@idProvCI AS INT,
		@idImptoCI AS INT,
		@idCodImpCI AS INT,
		@desCI AS VARCHAR(30),
		@tasaCI AS FLOAT,
		@cIvaCI AS TINYINT,
		@cRetCI AS TINYINT,
		@cExeCI AS TINYINT,
		@mtoBaseCI AS FLOAT,
		@mtoImpCI AS FLOAT,
		@idMdaCI AS INT,
		@operCI AS TINYINT,
		@tcCI AS FLOAT,
		@mtoBaseBseCI AS FLOAT,
		@mtoImpBseCI AS FLOAT,
		@idCtaCI AS INT,
		@idUsrCI AS INT,
		@fecRegCI AS DATETIME,
		@statusCI AS TINYINT,
		@cAfeCtbCI AS TINYINT,
		@dctoGlbCI AS FLOAT,
		@mtoImpSDctoCI AS FLOAT,
		@mtoBaseSDctoCI AS FLOAT,
		@idRelImpDocCI AS INT,
		@cModImptosCI AS TINYINT,
		@ivaAplCI AS FLOAT,
		@ivaSdoCI AS FLOAT,
		@mtoPagRetCI AS FLOAT,
		@mtoAcrRetCI AS FLOAT,
		@fecPgoCI AS DATETIME,
		@idBcoAuxCI AS INT,
		@idCliFaCI AS INT,
		@noFactCI AS VARCHAR(40),
		@cRecIvaCI AS TINYINT,
		@idFisRelCI AS INT,
		@idCenCtoCI AS INT,
		@idRefCI AS INT,
		@idCodSrvCI AS INT,
		@idProCI AS INT,
		@idAlmCI AS INT,
		@idEntCI AS INT,
		@impCTipCI AS TINYINT,
		@impCDesCI AS VARCHAR(25),
		@impCTasaCI AS FLOAT,
		@impCFtrCI AS FLOAT,
		@impCCantCI AS FLOAT,
		@impCUDCCI AS FLOAT,
		@impCMtoCI AS FLOAT,
		@ptgAcuComCI AS FLOAT

		--Para insertar los impuestos de la partida
		DECLARE
		@idSisImpSP AS INT,
		@idRelImptoSP AS INT

		--Otras
		DECLARE
		@contParts AS INT,
		@subParts AS FLOAT,
		@imptosParts AS FLOAT,
		@totalParts AS FLOAT,
		@decCosto AS INT,
		@decCostoTot AS INT,
		@decCant AS INT,
		@decPrecio AS INT,
		@decPtgVta AS INT,
		@decMonto AS INT,
		@imptosXPart AS FLOAT,
		@desctoXPart AS FLOAT,
		@pVarImptos AS INT,
		@desCuentas AS VARCHAR(MAX),
		@contPartidas AS INT

		--Para calcular la estructura de los impuestos
		BEGIN
			--Parámetros de entrada
		    DECLARE
			@montoEI2 AS FLOAT,
			@IdImpEI2 AS INT,
			@decimalesEI2 AS INT,
			@mtoImpManualEI2 AS FLOAT,
			@diferenciaEntrEI2 AS INT,
			@montoConImptosEI2 AS FLOAT,
			@cantidadEI2 AS FLOAT,
			@IdProEI2 AS INT,
			@esPaqueteEI2 AS TINYINT,
			@mtoImptoInversoEntrEI2 AS FLOAT,
			@dPrecioPaqEI2 AS FLOAT,
			@bTruncarEI2 AS TINYINT,
			@dctoEI2 AS FLOAT,
			@pImptoManualEI2 AS TINYINT,
			@tipoDocumentoEI2 AS VARCHAR(MAX),
			@origenEI2 AS VARCHAR(MAX)

			--La que regresa el valor
			DECLARE
			@mtoImptoInversoEI2 AS FLOAT

			--Las de la parte superior de la estructura
			DECLARE
			@montoBaseEI2 AS FLOAT,
			@montoImpuestosEI2 AS FLOAT,
			@totImpuestosEI2 AS INT,
			@descripcionImpuestosEI2 AS VARCHAR(MAX),
			@modificadoEI2 AS TINYINT

			--Para cálculos
			DECLARE
			@calcInversoEI2 AS TINYINT,
			@BaseEI2 AS FLOAT,
			@tipImptoEI2 AS TINYINT,
			@tasaTotEI2 AS FLOAT,
			@mtoTotEI2 AS FLOAT,
			@EstructDblEI2 AS TINYINT,
			@BseImpEI2 AS TINYINT,
			@BseCanEI2 AS TINYINT,
			@pEnteraEI2 AS FLOAT,
			@pDecimalEI2 AS FLOAT,
			@pDecimal1EI2 AS FLOAT,
			@pDecimal2EI2 AS FLOAT,
			@IepsBaseIvaEI2 AS FLOAT,
			@BaseImptosEI2 AS FLOAT,
			@cPtgImpLocalEI2 AS TINYINT,
			@ImpLocalEI2 AS FLOAT,
			@ImpCTipEI2 AS INT,
			@ImpCDesEI2 AS NVARCHAR(MAX),
			@ImpCTasaEI2 AS FLOAT,
			@ImpCFtrEI2 AS FLOAT,
			@ImpCCantEI2 AS FLOAT,
			@ImpCUDCEI2 AS FLOAT,
			@cPagImpEI2 AS INT,
			@XEI2 AS INT,
			@IEI2 AS FLOAT,
			@tasaEI2 AS FLOAT,
			@difEI2 AS FLOAT,
			@tasaMenosIepsEI2 AS FLOAT,
			@soloIvaEI2 AS FLOAT,
			@mtoImpLEI2 AS FLOAT,
			@mtoImpLcdEI2 AS FLOAT,
			@TipDocEI2 AS VARCHAR(MAX),
			@BaseImptos120EI2 AS FLOAT

			--Para recorrer la estructura de impuestos
			DECLARE
			@IdImptoCIEI2 AS INT,
			@desCIEI2 AS VARCHAR(40),
			@statusCIEI2 AS TINYINT,
			@IdImptoDetCIEI2 AS INT,
			@IdCodImpCIEI2 AS INT,
			@IdCtaCIEI2 AS INT,
			@desCodImpCIEI2 AS VARCHAR(30),
			@numCtaCIEI2 AS VARCHAR(25),
			@nomCIEI2 AS VARCHAR(80),
			@statusCtaCIEI2 AS TINYINT,
			@tasaCIEI2 AS FLOAT,
			@cIvaCIEI2 AS INT,
			@cRetCIEI2 AS TINYINT,
			@cExeCIEI2 AS TINYINT,
			@tipoCIEI2 AS TINYINT,
			@tipImptoCIEI2 AS TINYINT,
			@IdImpto_cmpCIEI2 AS TINYINT,
			@cPagImpCIEI2 AS TINYINT,
			@cZonFrnCIEI2 AS TINYINT,
			@cIvaImpCIEI2 AS TINYINT,
			@IdTipImptoCIEI2 AS INT,
			@cBaseIvaCIEI2 AS TINYINT,
			@IdTipRetCIEI2 AS INT,
			@IdOtrSisCIEI2 AS VARCHAR(25),
			@cExcluirCfdiCIEI2 AS BIT

			--Otras variables
			DECLARE
			@pRoundImptosEI2 AS INT,
			@decMontoEI2 AS INT,
			@contadorEI2 AS INT,
			@pVarImptosEI2 AS INT
		END

		DECLARE @TblDocs AS TABLE (
			id_fac BIGINT NOT NULL,
			serie VARCHAR(10) NOT NULL,
			numero INT NOT NULL,
			fecha DATETIME NOT NULL,
			id_tip_doc INT NOT NULL,
			cmt VARCHAR(300) NOT NULL,
			nota VARCHAR(255) NOT NULL,
			dias INT NOT NULL,
			fec_venc DATETIME NOT NULL,
			fec_reg_se DATETIME NOT NULL,
			fec_est_cob DATETIME NOT NULL,
			fec_rev DATETIME NOT NULL,
			cve_cliente VARCHAR(12) NOT NULL,
			id_otr_sis_cli VARCHAR(25) NOT NULL,
			cve_fa VARCHAR(12) NOT NULL,
			sub FLOAT NOT NULL,
			imptos FLOAT NOT NULL,
			total FLOAT NOT NULL,
			moneda VARCHAR(5) NOT NULL,
			tip_cam FLOAT NOT NULL,
			cnd_pag INT NOT NULL,
			mtd_pag VARCHAR(MAX) NOT NULL,
			cve_suc VARCHAR(15) NOT NULL,
			num_pol VARCHAR(MAX) NOT NULL
		)

		DECLARE @TblParts AS TABLE (
			id_fac_det BIGINT NOT NULL,
			cve_pro VARCHAR(25) NOT NULL,
			id_otr_sis_pro VARCHAR(25) NOT NULL,
			descripcion VARCHAR(250) NOT NULL,
			cant FLOAT NOT NULL,
			udm VARCHAR(5) NOT NULL,
			sub FLOAT NOT NULL,
			dcto_mto FLOAT NOT NULL,
			imptos FLOAT NOT NULL,
			total FLOAT NOT NULL,
			id_impto INT NOT NULL,
			costo FLOAT NOT NULL,
			costo_total FLOAT NOT NULL,
			cod_alm VARCHAR(10) NOT NULL,
			id_otr_sis_alm VARCHAR(25) NOT NULL,
			cen_cto VARCHAR(10) NOT NULL,
			cod_srv VARCHAR(64) NOT NULL,
			num_ped_cli VARCHAR(50) NOT NULL,
			fec_req DATETIME NOT NULL,
			num_ref VARCHAR(64) NOT NULL,
			cmt VARCHAR(50) NOT NULL
		)

		DECLARE @TblPartsSp AS TABLE (
			id_fac_det INT NOT NULL,
			/*id_fac INT NOT NULL,*/
			id_doc_vta INT NOT NULL,
			sub FLOAT NOT NULL,
			imptos FLOAT NOT NULL,
			total FLOAT NOT NULL,
			id_suc INT NOT NULL,
			no_part INT NOT NULL,
			id_pro INT NOT NULL,
			udm VARCHAR(10) NOT NULL,
			cant FLOAT NOT NULL,
			precio_orig FLOAT NOT NULL,
			promoc FLOAT NOT NULL,
			precio_pub FLOAT NOT NULL,
			dcto_ptg FLOAT NOT NULL,
			precio_cimptos FLOAT NOT NULL,
			importe_cimptos FLOAT NOT NULL,
			precio_pub_simptos FLOAT NOT NULL,
			precio_simptos FLOAT NOT NULL,
			importe_simptos FLOAT NOT NULL,
			montos_imptos FLOAT NOT NULL,
			id_impto INT NOT NULL,
			c_cambio_prec TINYINT NOT NULL,
			costo FLOAT NOT NULL,
			monto_descto FLOAT NOT NULL,
			costo_total FLOAT NOT NULL,
			id_almac INT NOT NULL,
			id_nota INT NOT NULL,
			tipo TINYINT NOT NULL,
			tipo_pro TINYINT NOT NULL,
			es_sub TINYINT NOT NULL,
			cant_dev FLOAT NOT NULL,
			por_facturar FLOAT NOT NULL,
			id_rem INT NOT NULL,
			id_rem_part INT NOT NULL,
			id_mda INT NOT NULL,
			tc FLOAT NOT NULL,
			oper TINYINT NOT NULL,
			id_com_ser_lot INT NOT NULL,
			dias_ent INT  NOT NULL,
			fec_prom DATETIME NOT NULL,
			fec_emb DATETIME NOT NULL,
			fec_req DATETIME NOT NULL,
			id_prg_ent_fac_det INT NOT NULL,
			cant_surt FLOAT NOT NULL,
			por_solic FLOAT NOT NULL,
			id_part_pad INT NOT NULL,
			id_pro_ord INT NOT NULL,
			cant_ord_pro FLOAT NOT NULL,
			id_pro_lis INT NOT NULL,
			id_lis_pre INT NOT NULL,
			c_prec_modif TINYINT NOT NULL,
			id_kardex INT NOT NULL,
			id_cod_srv INT NOT NULL,
			id_cen_cto INT NOT NULL,
			id_ref INT NOT NULL,
			id_udm INT NOT NULL,
			ftr FLOAT NOT NULL,
			id_ped INT NOT NULL,
			id_ped_part INT NOT NULL,
			num_ped INT NOT NULL,
			id_cot INT NOT NULL,
			id_cot_part INT NOT NULL,
			num_cot INT NOT NULL,
			id_spt INT NOT NULL,
			id_spt_part INT NOT NULL,
			num_spt INT NOT NULL,
			id_pad INT NOT NULL,
			id_tip_doc_pad INT NOT NULL,
			num_pad INT NOT NULL,
			num_ped_cli VARCHAR(50) NOT NULL,
			num_req_cli VARCHAR(50) NOT NULL,
			id_clas_pro INT NOT NULL,
			id_rel_impto INT NOT NULL,
			num_rem INT NOT NULL,
			operacion TINYINT NOT NULL,
			id_tip_doc INT NOT NULL,
			num_doc INT NOT NULL,
			id_usr INT NOT NULL,
			id_kit INT NOT NULL,
			cant_kits FLOAT NOT NULL,
			[status] TINYINT NOT NULL,
			num_doc_cnl INT NOT NULL,
			id_sis_cnl INT NOT NULL,
			id_nota_cnl INT NOT NULL,
			fec_apl_cnl DATETIME NOT NULL,
			id_act INT NOT NULL,
			id_clas_act INT NOT NULL,
			valor_base FLOAT NOT NULL,
			dep_acu FLOAT NOT NULL,
			dep_rem FLOAT NOT NULL,
			campo1 INT NOT NULL,
			campo2 INT NOT NULL,
			campo3 INT NOT NULL,
			campo4 FLOAT NOT NULL,
			campo5 VARCHAR(50) NOT NULL,
			campo6 VARCHAR(50) NOT NULL,
			campo7 VARCHAR(50) NOT NULL,
			campo8 VARCHAR(50) NOT NULL,
			campo9 VARCHAR(50) NOT NULL,
			campo10 DATETIME NOT NULL,
			c_prg TINYINT NOT NULL,
			id_pro_paq INT NOT NULL,
			id_part_ori INT NOT NULL,
			sec INT NOT NULL,
			id_int INT NOT NULL,
			id_cli_cta_de INT NOT NULL,
			id_ref_det INT NOT NULL,
			ptg_kit FLOAT NOT NULL,
			id_cpt INT NOT NULL,
			cmt VARCHAR(50) NOT NULL,
			Ref_ext VARCHAR(64) NOT NULL,
			base_grav FLOAT NOT NULL,
			tip_hon INT NOT NULL,
			ptg_hon FLOAT NOT NULL,
			mod_impto TINYINT NOT NULL,
			precio_ext FLOAT NOT NULL,
			Campo11 INT NOT NULL,
			Campo12 INT NOT NULL,
			Campo13 INT NOT NULL,
			Campo14 INT NOT NULL,
			Campo15 INT NOT NULL,
			Campo16 INT NOT NULL,
			Campo17 FLOAT NOT NULL,
			Campo18 FLOAT NOT NULL,
			Campo19 FLOAT NOT NULL,
			Campo20 FLOAT NOT NULL,
			Campo21 FLOAT NOT NULL,
			Campo22 FLOAT NOT NULL,
			Campo23 FLOAT NOT NULL,
			Campo24 FLOAT NOT NULL,
			Campo25 FLOAT NOT NULL,
			Campo26 DATETIME NOT NULL,
			Campo27 DATETIME NOT NULL,
			Campo28 DATETIME NOT NULL,
			Campo29 DATETIME NOT NULL,
			Campo30 VARCHAR(50) NOT NULL,
			Campo31 VARCHAR(50) NOT NULL,
			Campo32 VARCHAR(50) NOT NULL,
			Campo33 VARCHAR(50) NOT NULL,
			Campo34 VARCHAR(50) NOT NULL,
			Campo35 VARCHAR(50) NOT NULL,
			Campo36 VARCHAR(50) NOT NULL,
			Campo37 VARCHAR(50) NOT NULL,
			Campo38 VARCHAR(50) NOT NULL,
			Campo39 VARCHAR(50) NOT NULL,
			Campo40 VARCHAR(50) NOT NULL,
			Id_Nota2 INT NOT NULL,
			Id_Nota3 INT NOT NULL,
			tip_com TINYINT NOT NULL,
			ptg_com FLOAT NOT NULL,
			mto_com FLOAT NOT NULL,
			id_sis_lis_pre INT NOT NULL,
			id_tar_hon INT NOT NULL,
			des_tar_hon VARCHAR(50) NOT NULL,
			id_fis_rel INT NOT NULL,
			id_ope_ext INT NOT NULL,
			Afe_inv_kardex TINYINT NOT NULL,
			id_part_alm_sir INT NOT NULL,
			dias_alm_sir FLOAT NOT NULL,
			dias_lib_alm_sir FLOAT NOT NULL,
			dias_dcto_alm_sir FLOAT NOT NULL,
			fec_corte_alm_sir DATETIME NOT NULL,
			id_almje_gral INT NOT NULL,
			id_almje_esp INT NOT NULL,
			des_hon VARCHAR(50) NOT NULL,
			[des] VARCHAR(254) NOT NULL,
			c_afe_exis_vta TINYINT NOT NULL,
			id_com INT NOT NULL,
			num_grp INT NOT NULL,
			cant_surt_aut FLOAT NOT NULL,
			apartado FLOAT NOT NULL,
			backorder FLOAT NOT NULL,
			fec_ped_cli DATETIME NOT NULL,
			aum_ptg FLOAT NOT NULL,
			cant_trasp FLOAT NOT NULL,
			id_tur_req INT NOT NULL,
			id_tur_prom INT NOT NULL,
			id_mov_part INT NOT NULL,
			no_part_pad INT NOT NULL,
			id_fac_det_kit INT NOT NULL,
			c_ptg_ing TINYINT  NOT NULL,
			ptg_ing FLOAT NOT NULL,
			id_prov_ter INT NOT NULL,
			rfc_prov VARCHAR(250) NOT NULL,
			nom_prov VARCHAR(250) NOT NULL,
			calle_prov VARCHAR(250) NOT NULL,
			num_ext_prov VARCHAR(250) NOT NULL,
			num_int_prov VARCHAR(250) NOT NULL,
			col_prov VARCHAR(250) NOT NULL,
			loc_prov VARCHAR(250) NOT NULL,
			ref_prov VARCHAR(250) NOT NULL,
			mun_prov VARCHAR(250) NOT NULL,
			edo_prov VARCHAR(250) NOT NULL,
			pais_prov VARCHAR(250) NOT NULL,
			cp_prov VARCHAR(250) NOT NULL,
			num_adu VARCHAR(250) NOT NULL,
			fec_adu DATETIME NOT NULL,
			aduana VARCHAR(250) NOT NULL,
			cta_pred_num VARCHAR(250) NOT NULL,
			id_rel_gas INT NOT NULL,
			c_prov_gas_cor TINYINT NOT NULL,
			mtoDesctoCoupon FLOAT NOT NULL,
			mtoDesctoVoucher FLOAT NOT NULL,
			mtoIngresosConfirmado FLOAT NOT NULL,
			mtoIngresosFuturos FLOAT NOT NULL,
			mtoOtrosIngresos FLOAT NOT NULL
		)

		DECLARE @TblEstrImptos AS TABLE (
			id INT NOT NULL,
			mto_impto_inverso FLOAT NOT NULL,
			monto_base FLOAT NOT NULL,
			monto_impuestos FLOAT NOT NULL,
			tot_impuestos INT NOT NULL,
			descripcion_impuestos VARCHAR(MAX) NOT NULL,
			modificado TINYINT NOT NULL,
			id_imp INT NOT NULL,
			descripcion VARCHAR(MAX) NOT NULL,
			tasa FLOAT NOT NULL,
			monto FLOAT NOT NULL,
			id_cta INT NOT NULL,
			c_iva INT NOT NULL,
			c_ret INT NOT NULL,
			c_exe INT NOT NULL,
			tip_impto INT NOT NULL,
			id_tip_impto INT NOT NULL,
			c_base_iva TINYINT NOT NULL,
			ImpC_des VARCHAR(MAX) NOT NULL,
			ImpC_tasa FLOAT NOT NULL,
			ImpC_ftr FLOAT NOT NULL,
			ImpC_cant FLOAT NOT NULL,
			ImpC_UDC FLOAT NOT NULL,
			ImpC_mto FLOAT NOT NULL
		)

		DECLARE @TblImptos AS TABLE (
			id_fac_det INT NOT NULL,
			id_sis_imp INT NOT NULL,
			id_rel_imp INT NOT NULL,
			id_tip_doc INT NOT NULL,
			id_doc INT NOT NULL,
			id_doc_part INT NOT NULL,
			num_doc INT NOT NULL,
			fec_doc DATETIME NOT NULL,
			id_cli INT NOT NULL,
			id_prov INT NOT NULL,
			id_impto INT NOT NULL,
			id_cod_imp INT NOT NULL,
			[des] VARCHAR(30) NOT NULL,
			tasa FLOAT NOT NULL,
			c_iva TINYINT NOT NULL,
			c_ret TINYINT NOT NULL,
			c_exe TINYINT NOT NULL,
			mto_base FLOAT NOT NULL,
			mto_imp FLOAT NOT NULL,
			id_mda INT NOT NULL,
			oper TINYINT NOT NULL,
			tc FLOAT NOT NULL,
			mto_base_bse FLOAT NOT NULL,
			mto_imp_bse FLOAT NOT NULL,
			id_cta INT NOT NULL,
			id_usr INT NOT NULL,
			fec_reg DATETIME NOT NULL,
			[status] TINYINT NOT NULL,
			c_afe_ctb TINYINT NOT NULL,
			dcto_glb FLOAT NOT NULL,
			mto_imp_s_dcto FLOAT NOT NULL,
			mto_base_s_dcto FLOAT NOT NULL,
			id_rel_imp_doc INT NOT NULL,
			c_mod_imptos TINYINT NOT NULL,
			iva_apl FLOAT NOT NULL,
			iva_sdo FLOAT NOT NULL,
			mto_pag_ret FLOAT NOT NULL,
			mto_acr_ret FLOAT NOT NULL,
			fec_pgo DATETIME NOT NULL,
			id_bco_aux INT NOT NULL,
			id_cli_fa INT NOT NULL,
			no_fact VARCHAR(40) NULL,
			c_rec_iva TINYINT NOT NULL,
			id_fis_rel INT NOT NULL,
			id_cen_cto INT NOT NULL,
			id_ref INT NOT NULL,
			id_cod_srv INT NOT NULL,
			id_pro INT NOT NULL,
			id_alm INT NOT NULL,
			id_ent INT NOT NULL,
			impC_tip TINYINT NOT NULL,
			impC_des VARCHAR(25) NOT NULL,
			impC_tasa FLOAT NOT NULL,
			impC_ftr FLOAT NOT NULL,
			impC_cant FLOAT NOT NULL,
			impC_UDC FLOAT NOT NULL,
			impC_mto FLOAT NOT NULL,
			ptg_acu_com FLOAT NOT NULL
		)

		DECLARE @TblProds AS TABLE (
			clave VARCHAR(25),
			id_pro INT,
			udm_vta VARCHAR(5),
			c_camb_precio TINYINT,
			tipo_pro TINYINT,
			id_pro_lis INT,
			id_udm_vta INT,
			ftr_vta FLOAT,
			id_clas1 INT,
			c_afe_exis_vta INT,
			c_ptg_ing TINYINT,
			ptg_ing FLOAT,
			cPtgImpLocal INT,
			impLocal FLOAT,
			impCTip INT,
			impCDes VARCHAR(25),
			impCTasa FLOAT,
			impCFtr FLOAT,
			impCCant FLOAT,
			impCUDC FLOAT,
			INDEX indIdPro NONCLUSTERED(clave)
		)

		DECLARE @TblCatImptos AS TABLE (
			id_impto INT,
			[des] VARCHAR(40),
			[status] TINYINT,
			id_impto_det INT,
			id_cod_imp INT,
			id_cta INT,
			des_cod_imp VARCHAR(30),
			num_cta VARCHAR(25),
			nom VARCHAR(80),
			status_cta TINYINT,
			tasa FLOAT,
			c_iva INT,
			c_ret TINYINT,
			c_exe TINYINT,
			tipo TINYINT,
			tip_impto TINYINT,
			id_impto_cmp TINYINT,
			c_pag_imp TINYINT,
			c_zon_frn TINYINT,
			c_iva_imp TINYINT,
			id_tip_impto INT,
			c_base_iva TINYINT,
			id_tip_ret INT,
			id_otr_sis VARCHAR(25),
			c_excluir_cfdi BIT,
			INDEX IX_id_impto NONCLUSTERED(id_impto)
		)

		DECLARE @TblAlmac AS TABLE (
			id_almac INT,
			codigo VARCHAR(10)
		)

		DECLARE @TblCodSrv AS TABLE (
			id_cod_svr INT,
			codigo VARCHAR(64)
		)

		DECLARE @TblCenCto AS TABLE (
			id_cen_cto INT,
			codigo VARCHAR(10)
		)

		DECLARE @TblFisRel AS TABLE (
			id_fis_rel INT,
			id_cod_srv INT,
			id_pro INT
		)

		DECLARE @TblImpuestosEI2 AS TABLE 
		(
			id INT NOT NULL,
			mto_impto_inverso FLOAT NOT NULL,
			monto_base FLOAT NOT NULL,
			monto_impuestos FLOAT NOT NULL,
			tot_impuestos INT NOT NULL,
			descripcion_impuestos VARCHAR(MAX) NOT NULL,
			modificado TINYINT NOT NULL,
			id_imp INT NOT NULL,
			descripcion VARCHAR(MAX) NOT NULL,
			tasa FLOAT NOT NULL,
			monto FLOAT NOT NULL,
			id_cta INT NOT NULL,
			c_iva INT NOT NULL,
			c_ret INT NOT NULL,
			c_exe INT NOT NULL,
			tip_impto INT NOT NULL,
			id_tip_impto INT NOT NULL,
			c_base_iva TINYINT NOT NULL,
			ImpC_des VARCHAR(MAX) NOT NULL,
			ImpC_tasa FLOAT NOT NULL,
			ImpC_ftr FLOAT NOT NULL,
			ImpC_cant FLOAT NOT NULL,
			ImpC_UDC FLOAT NOT NULL,
			ImpC_mto FLOAT NOT NULL,
			INDEX indImptosEI NONCLUSTERED(id_imp)
		)

		DECLARE @TblCfgGbl AS TABLE (
			id_cfg_glb INT NOT NULL,
			valor VARCHAR(300) NOT NULL
		)

		DECLARE @TblSisTip AS TABLE (
			id_tip INT NOT NULL,
			descripcion VARCHAR(160) NOT NULL,
			tipo INT NOT NULL,
			codigo VARCHAR(50) NOT NULL
		)

		DECLARE @TblCatClientes AS TABLE(
			id_cli INT NOT NULL,
			id_mda INT NOT NULL,
			id_vend INT NOT NULL,
			id_clas1 INT NOT NULL,
			id_cto_cat INT NOT NULL,
			id_rel_da INT NOT NULL,
			id_cli_pad INT NOT NULL,
			[status] INT NOT NULL,
			clave VARCHAR(12) NOT NULL,
			id_rel_fa_da INT NOT NULL
		)
	END

	--Asignación de valores
	BEGIN
		INSERT INTO @TblCfgGbl ( id_cfg_glb, valor )
			SELECT
				cg.id_cfg_glb, cg.Valor
			FROM dbo.cfg_global AS cg WITH (NOLOCK)
			WHERE cg.id_cfg_glb IN (63, 709, 6, 22, 8, 19, 7, 836, 744, 670)
 
		SELECT @pVarImptos = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 63
	    SELECT @decPtgVta = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 709
	    SELECT @decCosto = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 6
	    SELECT @decCostoTot = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 22
	    SELECT @decCant = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 8
	    SELECT @decPrecio = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 19
	    SELECT @decMonto = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 7
  
		SET @pVarImptos = ISNULL(@pVarImptos, 100000)
		SET @decPtgVta = ISNULL(@decPtgVta, 0)
 
		SELECT @pRoundImptosEI2 = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 836
  
		SET @pVarImptosEI2 = @pVarImptos
		SET @pRoundImptosEI2 = ISNULL(@pRoundImptosEI2, 0)
		SET @pVarImptosEI2 = ISNULL(@pVarImptosEI2, 100000)
		SET @decMontoEI2 = @decMonto

		INSERT INTO @TblSisTip ( id_tip, descripcion, tipo, codigo )
			SELECT
				st.id_tip, st.[des], st.tipo, st.codigo
			FROM dbo.sis_tip AS st WITH (NOLOCK)
			WHERE st.id_tip > 0 AND st.[status] = 1 AND st.tipo IN (180, 156)

		INSERT INTO @TblCatClientes ( id_cli, id_mda, id_vend, id_clas1, id_cto_cat, id_rel_da, id_cli_pad, [status], clave, id_rel_fa_da )
			SELECT
				cc.id_cli, cc.id_mda, cc.id_vend, cc.id_clas1, cc.id_cto_cat, cc.id_rel_da, cc.id_cli_pad, cc.[status], cc.clave, cc.id_rel_fa_da
			FROM dbo.cat_clientes AS cc WITH (NOLOCK)
			WHERE cc.id_cli > 0
	END

    --Empezamos obteniendo todos los registros en las tablas que están pendientes de procesarse
	INSERT INTO @TblDocs ( id_fac, serie, numero, fecha, id_tip_doc, cmt, nota, dias, fec_venc, fec_reg_se, fec_est_cob, fec_rev, cve_cliente, id_otr_sis_cli, cve_fa, sub, imptos, total, moneda, tip_cam, cnd_pag, mtd_pag, cve_suc, num_pol )
		SELECT
			imp.id_fac, imp.serie, imp.numero, imp.fecha, imp.id_tip_doc, cmt = UPPER(imp.cmt), nota = UPPER(imp.nota), imp.dias, imp.fec_venc, imp.fec_reg_se, imp.fec_est_cob, imp.fec_rev, imp.cve_cliente, imp.id_otr_sis_cli, imp.cve_fa, imp.sub, imp.imptos, imp.total, imp.moneda, imp.tip_cam, imp.cnd_pag, imp.mtd_pag, imp.cve_suc, imp.num_pol
		FROM dbo.imp_vta_fac_enc AS imp WITH (NOLOCK) 
		WHERE imp.status_imp >= 0 AND imp.status_imp NOT IN (1) AND imp.id_tip_doc = 8
	
	--Ahora ya con esto, vamos a iniciar un cursor
	DECLARE Documentos CURSOR LOCAL FORWARD_ONLY FOR
		SELECT
			id_fac, serie, numero, fecha, id_tip_doc, cmt, nota, dias, fec_venc, fec_reg_se, fec_est_cob, fec_rev, cve_cliente, id_otr_sis_cli, cve_fa, sub, imptos, total, moneda, tip_cam, td.cnd_pag, mtd_pag, cve_suc, num_pol
		FROM @TblDocs AS td

	OPEN Documentos

	FETCH NEXT FROM Documentos
	INTO @idFacImp, @serieImp, @numeroImp, @fechaImp, @idTipDocImp, @cmtImp, @notaImp, @diasImp, @fecVencImp, @fecRegSEImp, @fecEstCobImp, @fecRevImp, @cveClienteImp, @idOtrSisCliImp, @cveFaImp, @subImp, @imptosImp, @totalImp, @monedaImp, @tipCamImp, @cndPagImp, @mtdPagImp, @cveSucImp, @numPolImp
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT tiempo = GETDATE(), mensaje = 'Empieza el documento'
		--Limpieza de variables
		BEGIN
			BEGIN
			    SET @operFac = 1
				SET @tipoFac = 2
				SET @idUsr = 0
				SET @statusFac = 1
				SET @idCli = 0
				SET @idCliPad = 0
				SET @idMda = 0
				SET @cMdaBse = 0
				SET @idSuc = 0
				SET @idNota = 0
				SET @idCpt = 0
				SET @idFA = 0
				SET @idCto = 0
				SET @idCtoCat = 0
				SET @idRelImpDoc = 0
				SET @idRelDa = 0
				SET @idCliDaMer = 0
				SET @idFacCliImp = 0
				SET @idUsoCFDI = 0
				SET @nom1 = ''
				SET @nom2 = ''
				SET @dir1 = ''
				SET @ciu = ''
				SET @est = ''
				SET @cp = ''
				SET @rfc = ''
				SET @tel1 = ''
				SET @tel2 = ''
				SET @tipTrn = 0
				SET @mtdPag2Imp = ''
				SET @tipGrp = 0
				SET @cIepsDesg = 0
				SET @numApr = 0
				SET @idSerFol = 0
				SET @idTipFac = 0
				SET @uuid = ''
				SET @selloSAT = ''
				SET @cbb = ''
				SET @idPac = 0
				SET @calle = ''
				SET @numInt = ''
				SET @numExt = ''
				SET @colonia = ''
				SET @delegacion = ''
				SET @calles = ''
				SET @idPais = 0
				SET @idEdo = 0
				SET @idComprobante = 0
				SET @fecCertSAT = '19000101'
				SET @certificado = ''
				SET @xmlCanc = ''
				SET @idSerie = 0
				SET @cTimb = 0
				SET @ultDigCta = ''
				SET @idSugar = ''
				SET @idCliCta = 0
				SET @tipPagCta = ''
				SET @bcoCta = ''
				SET @idsCtas = ''
				SET @usoCFDIDes = ''
				SET @cCompCp = 'FALSO'
				SET @idRegFisc = 0
				SET @contParts = 0
				SET @subParts = 0
				SET @imptosParts = 0
				SET @totalParts = 0
			END

			--Tablas
			BEGIN
			    DELETE FROM @TblParts
				DELETE FROM @TblPartsSp
				DELETE FROM @TblImptos
				DELETE FROM @TblProds
				DELETE FROM @TblCatImptos
				DELETE FROM @TblAlmac
				DELETE FROM @TblCodSrv
				DELETE FROM @TblCenCto
				DELETE FROM @TblFisRel
			END
		END
		
		BEGIN TRY
			--Encabezado
			BEGIN
				--Validamos si es que no ya existe un documento con esa serie-folio
				IF EXISTS ( SELECT vfe.id_fac FROM dbo.vta_fac_enc AS vfe WITH (NOLOCK) WHERE vfe.id_tipo_doc = 8 AND vfe.serie = @serieImp AND vfe.numero = @numeroImp )
				BEGIN
					UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'Serie-folio ya existe' WHERE id_fac = @idFacImp

					GOTO Siguiente
				END

				--Sucursal
				BEGIN
					SELECT
						@idSuc = ms.id_suc
					FROM dbo.mcp_suc AS ms WITH (NOLOCK) 
					WHERE ms.id_suc > 0 AND ms.suc = @cveSucImp AND ms.[status] = 1

					IF ISNULL(@idSuc, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'La sucursal no existe' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Serie
				BEGIN
					SELECT DISTINCT
						@idSerie = s.id_serie
					FROM dbo.sis_doctos_ser AS s WITH (NOLOCK)
					LEFT OUTER JOIN dbo.msc_tbl_uni AS m WITH (NOLOCK) ON (m.id = s.id_serie AND m.id_tbl = 169 AND m.c_dsp = 1 AND m.id_suc = @idSuc)
					LEFT OUTER JOIN dbo.vt_suc_pat_adu AS v WITH (NOLOCK) ON (v.nidsucursal = m.id_suc AND s.[status] = 1 AND s.id_tip_doc = @idTipDocImp AND s.id_caj = 0 AND s.c_act = 1)
					

					IF ISNULL(@idSerie, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'La serie no existe' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END

					SELECT
						@numApr = a.num_apr, @idSerFol = a.id_ser_fol, @idTipFac = a.id_tip_cfd
					FROM dbo.vt_sis_doctos_ser_fol AS a WITH (NOLOCK) 
					WHERE a.[status] = 1 AND a.id_tip_doc = @idTipDocImp AND a.fol_ini <= @numeroImp AND a.fol_fin >= @numeroImp AND a.serie = @serieImp AND a.status_fol = 1

					SET @numApr = ISNULL(@numApr, 0)

					IF @idTipFac = 41001 OR @idTipFac = 41005 OR @idTipFac = 41006
					BEGIN
					    SET @cTimb = 1
					END
				END

				SET @serieFac = @serieImp
				SET @numeroFac = @numeroImp
				SET @saldoFac = @totalImp

				--Usuario que realiza la factura
				BEGIN
					SELECT @idUsr = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 744

					IF NOT EXISTS ( SELECT cu.usr FROM dbo.cat_usr AS cu WITH (NOLOCK) WHERE cu.id_usr > 0 AND cu.id_usr = ISNULL(@idUsr, 0) AND cu.id_tip_usr = 212 AND cu.[status] = 1 )
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'El usuario no existe' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Datos del cliente, moneda y condición de pago
				BEGIN
					SELECT TOP (1)
						@idCli = cc2.id_cli, @idCliPad = cc.id_cli, @idMda = cc2.id_mda, @cMdaBse= mm2.c_base, @idVend = cc.id_vend, @operMda = mm2.oper, @idClasCli = cc.id_clas1, @idCtoCat = cc.id_cto_cat, @idRelDa = cc.id_rel_da
					FROM @TblCatClientes AS cc
					INNER JOIN @TblCatClientes AS cc2 ON (cc2.id_cli_pad = cc.id_cli /*AND cc2.id_cli_pad <> cc2.id_cli*/ AND cc2.[status] = 1)
					INNER JOIN dbo.mon_monedas AS mm2 ON (mm2.id_moneda > 0 AND mm2.id_moneda = cc2.id_mda AND mm2.codsat = @monedaImp)
					WHERE cc.id_cli = cc.id_cli_pad AND cc.[status] = 1 AND cc.id_cli > 0 AND /*(@idOtrSisCliImp <> '' AND LTRIM(RTRIM(cc.id_otr_sis)) <> '' AND LTRIM(RTRIM(cc.id_otr_sis)) <> '0' AND cc.id_otr_sis = @idOtrSisCliImp) OR*/ (@cveClienteImp <> '' AND cc.clave = @cveClienteImp)
					ORDER BY cc.id_cli

					IF ISNULL(@idCli, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró al cliente' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END

					IF (@cMdaBse = 1 AND @tipCamImp <> 1) OR (@cMdaBse = 0 AND @tipCamImp = 1) OR @tipCamImp <= 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'La combinación de la moneda y el TC no es el correcto' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END

					IF NOT EXISTS ( SELECT cc.id_cnd FROM dbo.cat_cnd AS cc WITH (NOLOCK) WHERE cc.id_cnd > 0 AND cc.id_cnd = @cndPagImp AND cc.[status] = 1 )
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existe la condición' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Fechas
				BEGIN
				   SET @fecEstPag = dbo.fn_dve_fec_est_pag(@fecVencImp, @idCliPad) 
				END

				--Concepto
				BEGIN
					SELECT @idCpt = TRY_CAST(cg.Valor AS INT) FROM @TblCfgGbl AS cg WHERE cg.id_cfg_glb = 670

					IF NOT EXISTS ( SELECT vsc.id_cpt FROM dbo.sis_conceptos AS vsc WITH (NOLOCK) WHERE vsc.id_cpt > 0 AND vsc.id_cpt = ISNULL(@idCpt, 0) AND vsc.id_mod = 4 )
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existe el concepto' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Contacto
				BEGIN
					SELECT TOP (1)
						@idCto = vscf.id_cto
					FROM dbo.sis_cto AS vscf  
					WHERE vscf.id_cto_cat = @idCtoCat AND vscf.[status] = 1

					SET @idCto = ISNULL(@idCto, 0)
				END

				--Dirección de entrega de mercancía
				BEGIN
					SELECT TOP (1)
						@idCliDaMer = c.id_cli_fa_da
					FROM dbo.cat_cli_fa_da AS c WITH (NOLOCK) 
					INNER JOIN dbo.sis_rel_fa_da AS s WITH (NOLOCK) ON (s.id_cli_fa_da = c.id_cli_fa_da)
					WHERE c.[status] = 1 AND c.id_cli_fa_da > 0 AND c.tipo = 2 AND c.tipcliprov = 1 AND s.id_rel_fa_da = @idRelDa AND c.tip_dir IN (1, 2)
					ORDER BY s.c_principal DESC--, c.nom1

					SET @idCliDaMer = ISNULL(@idCliDaMer, 0)
				END
			END
			
			--Datos del cliente desde la tabla intermedia
			BEGIN
				SELECT
					@idFacCliImp = ic.id_fac_cli, @usoCFDIImp = ic.codsat_uso_cfdi, @mtdPag2Imp = ic.mtd_pag, @uuid = ic.uuid
				FROM dbo.imp_vta_fac_cli AS ic WITH (NOLOCK) 
				WHERE ic.id_fac = @idFacImp

				IF ISNULL(@idFacCliImp, 0) = 0
				BEGIN
					UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existen los datos del cliente en la intermedia' WHERE id_fac = @idFacImp
				
					GOTO Siguiente
				END
			END
			
			--Cliente
			BEGIN
				--Facturar A, pendiente ver si se dan de alta si no existe
				BEGIN
					SELECT DISTINCT
						@idFA = a.id_cli_fa_da, @nom1 = a.nom1, @nom2 = a.nom2, @dir1 = a.dir1, @ciu = a.ciu, @est = a.est, @cp = a.cp, @rfc = a.rfc, @tel1 = a.tel1, @tel2 = a.tel2, @tipGrp = a.num_grp, @calle = a.calle, @numInt = a.num_int, @numExt = a.num_ext, @colonia = a.col, @delegacion = a.deleg, @calles = a.calles, @idPais = a.id_pais, @idEdo = a.id_edo, @idRegFisc = a.id_reg_fis
					FROM dbo.vt_cat_cli_fa_da_rel AS a
					LEFT JOIN @TblCatClientes AS b ON (b.id_rel_fa_da = a.id_rel_fa_da)
					INNER JOIN dbo.cat_estatus AS c ON (c.id_status = a.[status] AND c.tipo = 1)
					WHERE a.id_cli_fa_da > 0 AND a.tipo = 1 AND a.[status] IN (1, 99) AND ISNULL(b.[status], 0) IN (0, 1, 99) AND a.tipcliprov = 1 AND b.id_cli = @idCliPad AND a.clave = @cveFaImp

					IF ISNULL(@idFA, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existe el Facturar A' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END

					IF ISNULL(@idRegFisc, 0) = 0
					BEGIN
					    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No tiene definido el régimen fiscal' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Uso CFDI
				BEGIN
					SELECT
						@idUsoCFDI = st.id_tip, @usoCFDIDes = st.descripcion
					FROM @TblSisTip AS st 
					WHERE st.tipo = 180 AND st.codigo = @usoCFDIImp
				
					IF ISNULL(@idUsoCFDI, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existe el uso del CFDI' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END

				--Método de pago
				BEGIN
				    SELECT
						@tipTrn = st.id_tip, @desCuentas = st.descripcion
					FROM @TblSisTip AS st
					WHERE st.tipo = 156 AND st.codigo = @mtdPag2Imp

					IF ISNULL(@tipTrn, 0) = 0
					BEGIN
					    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existe el método de pago' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END

					SET @tipPagCta = @mtdPag2Imp
					SET @ultDigCta = 'No Aplica'
					SET @bcoCta = 'No Aplica[' + CAST(@totalImp AS VARCHAR(MAX)) + ']{' + @desCuentas + '}'
					SET @idsCtas = '0'
				END
			END
			
			--Datos de la tabla de metadatos
			BEGIN
			    SELECT
					@idComprobante = cic.IdComprobante, @fecCertSAT = cic.FechaTimbrado/*, @certificado = cic.NoCertificado*/
				FROM dbo.CFDIdataComprobante AS cic WITH (NOLOCK) 
				WHERE cic.UUIDTimbre = @uuid

				IF ISNULL(@idComprobante, 0) = 0
				BEGIN
				    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existen datos en la tabla de metadatos' WHERE id_fac = @idFacImp

					GOTO Siguiente
				END
			END
	
			--Datos de las partidas desde la tabla intermedia
			BEGIN
				SELECT tiempo = GETDATE(), mensaje = 'Empieza partidas'
			    INSERT INTO @TblParts ( id_fac_det, cve_pro, id_otr_sis_pro, descripcion, cant, udm, sub, dcto_mto, imptos, total, id_impto, costo, costo_total, cod_alm, id_otr_sis_alm, cen_cto, cod_srv, num_ped_cli, fec_req, num_ref, cmt )
					SELECT
						ivfd.id_fac_det, ivfd.cve_pro, ivfd.id_otr_sis_pro, ivfd.descripcion, cant = ROUND(ivfd.cant, @decCant), ivfd.udm, sub = ROUND(ivfd.sub, @decMonto), dcto_mto = ROUND(ivfd.dcto_mto, @decMonto), imptos = ROUND(ivfd.imptos, @decMonto), total = ROUND(ivfd.total, @decMonto), ivfd.id_impto, costo = ROUND(ivfd.costo, @decCosto), costo_total = ROUND(ivfd.costo_total, @decCostoTot), ivfd.cod_alm, ivfd.id_otr_sis_alm, ivfd.cen_cto, ivfd.cod_srv, ivfd.num_ped_cli, ivfd.fec_req, ivfd.num_ref, cmt = UPPER(ivfd.cmt)
					FROM dbo.imp_vta_fac_det AS ivfd WITH (NOLOCK)
					WHERE ivfd.id_fac = @idFacImp
				
				--Validamos que sí hayamos traido partidas
				BEGIN
				    SELECT
						@contParts = COUNT(tp.id_fac_det)
					FROM @TblParts AS tp

					IF ISNULL(@contParts, 0) = 0
					BEGIN
						UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No existen partidas' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END
				
				--Validamos que la sumatoria de las partidas sea igual a las del total
				BEGIN
				    SELECT
						@subParts = ROUND(SUM(tp.sub), @decMonto), @imptosParts = ROUND(SUM(tp.imptos), @decMonto), @totalParts = ROUND(SUM(tp.total), @decMonto)
					FROM @TblParts AS tp

					IF @subParts <> @subImp OR @imptosParts <> @imptosImp OR @totalParts <> @totalImp
					BEGIN
					    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'El subtotal/importe/total de las partidas no coincide con el encabezado' WHERE id_fac = @idFacImp

						GOTO Siguiente
					END
				END
				
				SET @noPartPC = 0
				SET @contPartidas = 1

				--Vamos a llenar tablas con los datos que se requieren para las partidas y así no estar haciendo consultas a cada rato
				BEGIN
				    INSERT INTO @TblProds ( clave, id_pro, udm_vta, c_camb_precio, tipo_pro, id_pro_lis, id_udm_vta, ftr_vta, id_clas1, c_afe_exis_vta, c_ptg_ing, ptg_ing, cPtgImpLocal, impLocal, impCTip, impCDes, impCTasa, impCFtr, impCCant, impCUDC )
						SELECT
							cp.clave, cp.id_pro, cp.udm_vta, cp.c_camb_precio, cp.tipo_pro, cp.id_pro_lis, cp.id_udm_vta, cp.ftr_vta, cp.id_clas1, cp.c_afe_exis_vta, ec.c_ptg_ing, ec.ptg_ing, cPtgImpLocal = CASE WHEN cp.imp_comp_tasa > 0 THEN 1 ELSE 0 END, impLocal = CASE WHEN cp.imp_comp_tasa > 0 THEN cp.imp_comp_tasa ELSE cp.imp_comp_ftr END, impCTip = CASE WHEN cp.imp_comp_tasa > 0 THEN 1 ELSE 2 END, cp.imp_comp_des, impCTasa = CASE WHEN cp.imp_comp_tasa > 0 THEN cp.imp_comp_tasa ELSE 0 END, impCFtr = CASE WHEN cp.imp_comp_tasa > 0 THEN 0 ELSE cp.imp_comp_ftr END, ImpCCant = CAST(0 AS FLOAT), cp.contenido
						FROM dbo.cat_pro AS cp
						LEFT JOIN dbo.pro_est_pro_cto AS ec ON (ec.id_est_pro_cto = cp.id_est_cto)
						WHERE cp.id_pro > 0 AND cp.[status] = 1 AND cp.clave IN ( SELECT tp.cve_pro FROM @TblParts AS tp GROUP BY tp.cve_pro )

					INSERT INTO @TblCatImptos ( id_impto, [des], [status], id_impto_det, id_cod_imp, id_cta, des_cod_imp, num_cta, nom, status_cta, tasa, c_iva, c_ret, c_exe, tipo, tip_impto, id_impto_cmp, c_pag_imp, c_zon_frn, c_iva_imp, id_tip_impto, c_base_iva, id_tip_ret, id_otr_sis, c_excluir_cfdi )
						SELECT
							vcif.id_impto, vcif.[des], vcif.[status], vcif.id_impto_det, vcif.id_cod_imp, vcif.id_cta, vcif.des_cod_imp, vcif.num_cta, vcif.nom, vcif.status_cta, vcif.tasa, vcif.c_iva, vcif.c_ret, vcif.c_exe, vcif.tipo, vcif.tip_impto, vcif.id_impto_cmp, vcif.c_pag_imp, vcif.c_zon_frn, vcif.c_iva_imp, vcif.id_tip_impto, vcif.c_base_iva, vcif.id_tip_ret, vcif.id_otr_sis, vcif.c_excluir_cfdi
						FROM dbo.vt_cat_imp_frm AS vcif
						WHERE vcif.id_impto > 0 AND vcif.tipo IN (0, 1) AND vcif.[status] = 1 AND vcif.id_impto IN ( SELECT tp.id_impto FROM @TblParts AS tp GROUP BY tp.id_impto )

					INSERT INTO @TblAlmac ( id_almac, codigo )
						SELECT
							ca.id_almac, ca.codigo
						FROM dbo.cat_almac AS ca
						LEFT OUTER JOIN dbo.msc_tbl_uni AS mtu ON (mtu.id = ca.id_almac AND mtu.id_tbl IN (16))
						LEFT OUTER JOIN dbo.vt_suc_pat_adu AS vt ON (vt.nidsucursal = mtu.id_suc)
						WHERE ca.c_vta = 1 AND ca.c_consig_prov = 0 AND mtu.c_dsp = 1 AND mtu.id_suc IN (0, @idSuc) AND ca.id_almac > 0 AND ca.[status] = 1 AND ca.codigo IN ( SELECT tp.cod_alm FROM @TblParts AS tp GROUP BY tp.cod_alm )

					INSERT INTO @TblCodSrv ( id_cod_svr, codigo )
						SELECT
							vscs.id_cod_svr, vscs.codigo
						FROM dbo.vt_sis_cod_svr AS vscs
						WHERE vscs.id_cod_svr > 0 AND vscs.[status] = 1 AND vscs.codigo IN ( SELECT tp.cod_srv FROM @TblParts AS tp GROUP BY tp.cod_srv )

					INSERT INTO @TblCenCto ( id_cen_cto, codigo )
						SELECT
							v.id_cen_cto, v.codigo
						FROM dbo.vt_ctb_cen_cto_frm AS v
						LEFT OUTER JOIN dbo.msc_tbl_uni AS mtu ON (mtu.id = v.id_cen_cto AND mtu.id_tbl IN (26))
						LEFT OUTER JOIN dbo.vt_suc_pat_adu AS vt ON (vt.nidsucursal = mtu.id_suc)
						WHERE v.id_cen_cto > 0 AND v.[status] = 1 AND mtu.c_dsp = 1 AND mtu.id_suc IN (0, @idSuc) AND v.codigo IN ( SELECT tp.cen_cto FROM @TblParts AS tp GROUP BY tp.cen_cto )

					INSERT INTO @TblFisRel ( id_fis_rel, id_cod_srv, id_pro )
						SELECT
							r.id_fis_rel, r.id, id_pro = 0
						FROM dbo.fis_cfg AS f
						INNER JOIN dbo.fis_cfg_rel AS r ON (r.id_fis_cfg = f.id_fis_cfg)
						INNER JOIN dbo.sis_cod_svr AS g ON (g.id_cod_svr = r.id AND r.id_tbl = 31)
						WHERE r.id_fis_rel > 0 AND r.id_tbl = 31 AND @fechaImp BETWEEN f.ini_vig AND f.fin_vig AND r.[status] = 1 AND r.id IN ( SELECT tcs.id_cod_svr FROM @TblCodSrv AS tcs GROUP BY tcs.id_cod_svr )

					INSERT INTO @TblFisRel ( id_fis_rel, id_cod_srv, id_pro )
						SELECT
							r.id_fis_rel, id_cod_srv = 0, r.id
						FROM dbo.fis_cfg AS f
						INNER JOIN dbo.fis_cfg_rel AS r ON (r.id_fis_cfg = f.id_fis_cfg)
						WHERE r.id_fis_rel > 0 AND r.id_tbl IN (213, 222, 3, 209, 223) AND @fechaImp BETWEEN f.ini_vig AND f.fin_vig AND r.[status] = 1 AND r.id IN ( SELECT tp.id_pro FROM @TblProds AS tp GROUP BY tp.id_pro )
				END

				--Ahora vamos a armar la información de cada partida
				DECLARE Partidas CURSOR LOCAL FAST_FORWARD FOR
					SELECT
						tp.id_fac_det, tp.cve_pro, tp.id_otr_sis_pro, tp.descripcion, tp.cant, tp.udm, tp.sub, tp.dcto_mto, tp.imptos, tp.total, tp.id_impto, tp.costo, tp.costo_total, tp.cod_alm, tp.id_otr_sis_alm, tp.cen_cto, tp.cod_srv, tp.num_ped_cli, tp.fec_req, tp.num_ref, tp.cmt
					FROM @TblParts AS tp
				
				OPEN Partidas

				FETCH NEXT FROM Partidas
				INTO @idFacDetPImp, @cveProPImp, @idOtrSisProPImp, @descripcionPImp, @cantPImp, @udmPImp, @subPImp, @dctoMtoPImp, @imptosPImp, @totalPImp, @idImptoPImp, @costoPImp, @costoTotalPImp, @codAlmPImp, @idOtrSisAlmPImp, @cenCtoPImp, @codSrvPImp, @numPedCliPImp, @fecReqPImp, @numRefPImp, @cmtPImp
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--Limpiamos variables del ciclo
					BEGIN
					    --sp_vta_fac_det
						BEGIN
						    SET @idFacDetPC = 0
							SET @idDocVtaPC = 0
							SET @subPC = 0
							SET @imptosPC = 0
							SET @totalPC = 0
							SET @idSucPC = 0
							SET @noPartPC = @noPartPC + 1
							SET @idProPC = 0
							SET @udmPC = ''
							SET @cantPC = 0
							SET @precioOrigPC = 0
							SET @promocPC = 0
							SET @precioPubPC = 0
							SET @dctoPtgPC = 0
							SET @precioCimptosPC = 0
							SET @importeCimptosPC = 0
							SET @precioPubSimptosPC = 0
							SET @precioSimptosPC = 0
							SET @importeSimptosPC = 0
							SET @montoSImptosPC = 0
							SET @idImptoPC = 0
							SET @cCambioPrecPC = 0
							SET @costoPC = 0
							SET @montoDesctoPC = 0
							SET @costoTotalPC = 0
							SET @idAlmacPC = 0
							SET @idNotaPC = 0
							SET @tipoPC = 1
							SET @tipoProPC = 0
							SET @esSubPC = 0
							SET @cantDevPC = 0
							SET @porFacturarPC = 0
							SET @idRemPC = 0
							SET @idRemPartPC = 0
							SET @idMdaPC = 0
							SET @tcPC = 0
							SET @operPC = 0
							SET @idComSerLotPC = 0
							SET @diasEntPC = 0
							SET @fecPromPC = @fechaImp
							SET @fecEmbPC = '19000101'
							SET @fecReqPC = @fecReqPImp
							SET @idPrgEntFacDetPC = 0
							SET @cantSurtPC = 0
							SET @porSolicPC = 0
							SET @idPartPadPC = 0
							SET @idProOrdPC = 0
							SET @cantOrdProPC = 0
							SET @idProLisPC = 0
							SET @idLisPrePC = 1
							SET @cPrecModifPC = 1
							SET @idKardexPC = 0
							SET @idCodSrvPC = 0
							SET @idCenCtoPC = 0
							SET @idRefPC = 0
							SET @idUdmPC = 0
							SET @ftrPC = 0
							SET @idPedPC = 0
							SET @idPedPartPC = 0
							SET @numPedPC = 0
							SET @idCotPC = 0
							SET @idCotPartPC = 0
							SET @numCotPC = 0
							SET @idSptPC = 0
							SET @idSptPartPC = 0
							SET @numSptPC = 0
							SET @idPadPC = 0
							SET @idTipDocPadPC = 0
							SET @numPadPC = 0
							SET @numPedCliPC = @numPedCliPImp
							SET @numReqCliPC = ''
							SET @idClasProPC = 0
							SET @idRelImptoPC = 0
							SET @numRemPC = 0
							SET @operacionPC = 1
							SET @idTipDocPC = 0
							SET @numDocPC = 0
							SET @idUsrPC = 0
							SET @idKitPC = 0
							SET @cantKitsPC = 0
							SET @statusPC = 0
							SET @numDocCnlPC = 0
							SET @idSisCnlPC = 0
							SET @idNotaCnlPC = 0
							SET @fecAplCnlPC = '19000101'
							SET @idActPC = 0
							SET @idClasActPC = 0
							SET @valorBasePC = 0
							SET @depAcuPC = 0
							SET @depRemPC = 0
							SET @campo1PC = 0
							SET @campo2PC = 0
							SET @campo3PC = 0
							SET @campo4PC = 0
							SET @campo5PC = ''
							SET @campo6PC = ''
							SET @campo7PC = ''
							SET @campo8PC = ''
							SET @campo9PC = ''
							SET @campo10PC = '19000101'
							SET @cPrgPC = 0
							SET @idProPaqPC = 0
							SET @idPartOriPC = @noPartPC
							SET @secPC = 0
							SET @idIntPC = 0
							SET @idCliCtaDePC = 0
							SET @idRefDetPC = 0
							SET @ptgKitPC = 0
							SET @idCptPC = 0
							SET @cmtPC = ''
							SET @RefExtPC = @numRefPImp
							SET @baseGravPC = 0
							SET @tipHonPC = 0
							SET @ptgHonPC = 0
							SET @modImptoPC = 1
							SET @precioExtPC = 0
							SET @Campo11PC = 0
							SET @Campo12PC = 0
							SET @Campo13PC = 0
							SET @Campo14PC = 0
							SET @Campo15PC = 0
							SET @Campo16PC = 0
							SET @Campo17PC = 0
							SET @Campo18PC = 0
							SET @Campo19PC = 0
							SET @Campo20PC = 0
							SET @Campo21PC = 0
							SET @Campo22PC = 0
							SET @Campo23PC = 0
							SET @Campo24PC = 0
							SET @Campo25PC = 0
							SET @Campo26PC = '19000101'
							SET @Campo27PC = '19000101'
							SET @Campo28PC = '19000101'
							SET @Campo29PC = '19000101'
							SET @Campo30PC = ''
							SET @Campo31PC = ''
							SET @Campo32PC = ''
							SET @Campo33PC = ''
							SET @Campo34PC = ''
							SET @Campo35PC = ''
							SET @Campo36PC = ''
							SET @Campo37PC = ''
							SET @Campo38PC = ''
							SET @Campo39PC = ''
							SET @Campo40PC = ''
							SET @IdNota2PC = 0
							SET @IdNota3PC = 0
							SET @tipComPC = 0
							SET @ptgComPC = 0
							SET @mtoComPC = 0
							SET @idSisLisPrePC = 0
							SET @idTarHonPC = 0
							SET @desTarHonPC = ''
							SET @idFisRelPC = 0
							SET @idOpeExtPC = 0
							SET @AfeInvKardexPC = 1
							SET @idPartAlmSirPC = 0
							SET @diasAlmSirPC = 0
							SET @diasLibAlmSirPC = 0
							SET @diasDctoAlmSirPC = 0
							SET @fecCorteAlmSirPC = '19000101'
							SET @idAlmjeGralPC = 0
							SET @idAlmjeEspPC = 0
							SET @desHonPC = ''
							SET @desPC = ''
							SET @cAfeExisVtaPC = 0
							SET @idComPC = 0
							SET @numGrpPC = 0
							SET @cantSurtAutPC = 0
							SET @apartadoPC = 0
							SET @backorderPC = 0
							SET @fecPedCliPC = @fechaImp
							SET @aumPtgPC = 0
							SET @cantTraspPC = 0
							SET @idTurReqPC = 0
							SET @idTurPromPC = 0
							SET @idMovPartPC = 0
							SET @noPartPadPC = 0
							SET @idFacDetKitPC = 0
							SET @cPtgIngPC = 0
							SET @ptgIngPC = 0
							SET @idProvTerPC = 0
							SET @rfcProvPC = ''
							SET @nomProvPC = ''
							SET @calleProvPC = ''
							SET @numExtProvPC = ''
							SET @numIntProvPC = ''
							SET @colProvPC = ''
							SET @locProvPC = ''
							SET @refProvPC = ''
							SET @munProvPC = ''
							SET @edoProvPC = ''
							SET @paisProvPC = ''
							SET @cpProvPC = ''
							SET @numAduPC = ''
							SET @fecAduPC = '19000101'
							SET @aduanaPC = ''
							SET @ctaPredNumPC = ''
							SET @idRelGasPC = 0
							SET @cProvGasCorPC = 0
							SET @mtoDesctoCouponPC = 0
							SET @mtoDesctoVoucherPC = 0
							SET @mtoIngresosConfirmadoPC = 0
							SET @mtoIngresosFuturosPC = 0
							SET @mtoOtrosIngresosPC = 0
						END
						
						--Otros
						BEGIN
							SET @imptosXPart = 0
							SET @desctoXPart = 0

							DELETE FROM @TblEstrImptos
							DELETE FROM @TblImpuestosEI2
						END

						--Para la estructura de impuestos
						BEGIN
						    --Parámetros de entrada
							SET @montoEI2 = 0
							SET @IdImpEI2 = 0
							SET @decimalesEI2 = 0
							SET @mtoImpManualEI2 = 0
							SET @diferenciaEntrEI2 = 0
							SET @montoConImptosEI2 = 0
							SET @cantidadEI2 = 0
							SET @IdProEI2 = 0
							SET @esPaqueteEI2 = 0
							SET @mtoImptoInversoEntrEI2 = -1
							SET @dPrecioPaqEI2 = 0
							SET @bTruncarEI2 = 0
							SET @dctoEI2 = 0
							SET @pImptoManualEI2 = 0
							SET @tipoDocumentoEI2 = ''
							SET @origenEI2 = ''

							--La que regresa el valor
							SET @mtoImptoInversoEI2 = 0

							--Las de la parte superior de la estructura
							SET @montoBaseEI2 = 0
							SET @montoImpuestosEI2 = 0
							SET @totImpuestosEI2 = 0
							SET @descripcionImpuestosEI2 = ''
							SET @modificadoEI2 = 0

							--Para cálculos
							SET @calcInversoEI2 = 0
							SET @BaseEI2 = 0
							SET @tipImptoEI2 = 0
							SET @tasaTotEI2 = 0
							SET @mtoTotEI2 = 0
							SET @EstructDblEI2 = 0
							SET @BseImpEI2 = 0
							SET @BseCanEI2 = 0
							SET @pEnteraEI2 = 0
							SET @pDecimalEI2 = 0
							SET @pDecimal1EI2 = 0
							SET @pDecimal2EI2 = 0
							SET @IepsBaseIvaEI2 = 0
							SET @BaseImptosEI2 = 0
							SET @cPtgImpLocalEI2 = 0
							SET @ImpLocalEI2 = 0
							SET @ImpCTipEI2 = 0
							SET @ImpCDesEI2 = ''
							SET @ImpCTasaEI2 = 0
							SET @ImpCFtrEI2 = 0
							SET @ImpCCantEI2 = 0
							SET @ImpCUDCEI2 = 0
							SET @cPagImpEI2 = 0
							SET @XEI2 = 0
							SET @IEI2 = 0
							SET @tasaEI2 = 0
							SET @difEI2 = 0
							SET @tasaMenosIepsEI2 = 0
							SET @soloIvaEI2 = 0
							SET @mtoImpLEI2 = 0
							SET @mtoImpLcdEI2 = 0
							SET @TipDocEI2 = ''
							SET @BaseImptos120EI2 = 0

							--Para recorrer la estructura de impuestos
							SET @IdImptoCIEI2 = 0
							SET @desCIEI2 = ''
							SET @statusCIEI2 = 0
							SET @IdImptoDetCIEI2 = 0
							SET @IdCodImpCIEI2 = 0
							SET @IdCtaCIEI2 = 0
							SET @desCodImpCIEI2 = ''
							SET @numCtaCIEI2 = ''
							SET @nomCIEI2 = ''
							SET @statusCtaCIEI2 = 0
							SET @tasaCIEI2 = 0
							SET @cIvaCIEI2 = 0
							SET @cRetCIEI2 = 0
							SET @cExeCIEI2 = 0
							SET @tipoCIEI2 = 0
							SET @tipImptoCIEI2 = 0
							SET @IdImpto_cmpCIEI2 = 0
							SET @cPagImpCIEI2 = 0
							SET @cZonFrnCIEI2 = 0
							SET @cIvaImpCIEI2 = 0
							SET @IdTipImptoCIEI2 = 0
							SET @cBaseIvaCIEI2 = 0
							SET @IdTipRetCIEI2 = 0
							SET @IdOtrSisCIEI2 = ''
							SET @cExcluirCfdiCIEI2 = 0

							--Otras variables
							SET @pRoundImptosEI2 = 0
							SET @decMontoEI2 = 0
							SET @contadorEI2 = 0
							SET @pVarImptosEI2 = 0
						END
					END
					
					--SET @idFacDetPC = @idFacDetPImp
					--SET @subPC = @subPImp
					--SET @imptosPC = @imptosPImp
					--SET @totalPC = @totalPImp
					--SET @idSucPC = @idSuc
					--SET @cantPC = @cantPImp

					--Validamos si el total y descuento no vengan en negativo o como en 0
					BEGIN
					    IF @totalPImp <= 0
						BEGIN
							UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'El total de la partida está en negativo' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'El total de la partida está en negativo' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END

						IF @dctoMtoPImp < 0
						BEGIN
							UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'El descuento de la partida está en negativo' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'El descuento de la partida está en negativo' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--Validamos que la suma del subtotal e impuestos de cada partida sea igual a su total
					BEGIN
						IF ROUND(ROUND(@subPImp, @decMonto) + ROUND(@imptosPImp, @decMonto), @decMonto) <> ROUND(@totalPImp, @decMonto)
						BEGIN
							--SELECT subtotal = @subPImp, imptos = @imptosPImp, total = @totalPImp, totalCalc = @subPImp + @imptosPImp

						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'El subtotal e impuestos de la partida no coincide con su total' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'El subtotal e impuestos de la partida no coincide con su total' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--Datos del producto
					BEGIN
					    SELECT
							@idProPC = vcp.id_pro, @udmPC = vcp.udm_vta, @cCambioPrecPC = vcp.c_camb_precio, @tipoProPC = vcp.tipo_pro, @idProLisPC = vcp.id_pro_lis, @idUdmPC = vcp.id_udm_vta, @ftrPC = vcp.ftr_vta, @idClasProPC = vcp.id_clas1, @cAfeExisVtaPC = vcp.c_afe_exis_vta, @cPtgIngPC = ISNULL(vcp.c_ptg_ing, 0), @ptgIngPC = ISNULL(vcp.ptg_ing, 0)
						FROM @TblProds AS vcp
						WHERE vcp.clave = @cveProPImp

						IF ISNULL(@idProPC, 0) = 0
						BEGIN
						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró el producto' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No se encontró el producto' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END

						IF @idUdmPC = 0
						BEGIN
						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No tiene definida la UDM de venta' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No tiene definida la UDM de venta' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--Datos del impuesto
					BEGIN
					    SELECT
							@idImptoPC = ci.id_impto
						FROM @TblCatImptos AS ci
						WHERE ci.id_impto = @idImptoPImp

						IF ISNULL(@idImptoPC, 0) = 0
						BEGIN
						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró el impuesto o está inactivo' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No se encontró el impuesto o está inactivo' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--Precios, importes y costos
					BEGIN
						SET @precioOrigPC = 0 --Chocobo
						SET @precioPubSimptosPC = ROUND((@subPImp + @dctoMtoPImp / @cantPImp), @decPrecio)
						
						IF @imptosImp > 0
						BEGIN
						    --SET @imptosXPart = ROUND(dbo.fn_calcula_impuesto(@precioPubSimptosPC, @idImptoPImp, 1), @decMonto)
							SET @imptosXPart = ROUND(@imptosImp / @cantPImp, @decMonto)
						END
						ELSE
                        BEGIN
							SET @imptosXPart = 0
                        END

						SET @precioPubPC = ROUND(@precioPubSimptosPC + @imptosXPart, @decPrecio)

						IF @dctoMtoPImp > 0
						BEGIN
						    SET @dctoPtgPC = ROUND(@dctoMtoPImp * 100 / ROUND(@precioPubSimptosPC * @cantPImp, @decMonto), @decPtgVta)
							SET @desctoXPart = ROUND(@precioPubSimptosPC * @dctoPtgPC, @decPrecio)
						END
						ELSE
						BEGIN
						    SET @dctoPtgPC = 0
							SET @desctoXPart = 0
						END

						SET @precioCimptosPC = ROUND(@precioPubSimptosPC - @desctoXPart, @decPrecio)
						SET @precioPubSimptosPC = ROUND((@subPImp + @dctoMtoPImp) / @cantPImp, @decPrecio)
						SET @precioSimptosPC = @precioCimptosPC
						SET @precioCimptosPC = ROUND(@precioCimptosPC + @imptosXPart, @decPrecio)

						IF @costoTotalPImp > 0
						BEGIN
						    SET @costoPC = ROUND(@costoTotalPImp / @cantPImp, @decCosto)
						END
						ELSE
						BEGIN
						    SET @costoPC = 0
						END
					END
					
					--Almacén
					BEGIN
					    SELECT
							@idAlmacPC = vca.id_almac
						FROM @TblAlmac AS vca
						WHERE vca.codigo = @codAlmPImp

						IF ISNULL(@idAlmacPC, 0) = 0
						BEGIN
						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró el almacén, está inactivo, no es de ventas o no está compartido a la sucursal' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No se encontró el almacén, está inactivo, no es de ventas o no está compartido a la sucursal' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--Código de trabajo
					BEGIN
						IF @codSrvPImp <> '' AND @codSrvPImp <> '0'
						BEGIN
							SELECT
								@idCodSrvPC = vscs.id_cod_svr
							FROM @TblCodSrv AS vscs
							WHERE vscs.codigo = @codSrvPImp

							IF ISNULL(@idCodSrvPC, 0) = 0
							BEGIN
								UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró el código de trabajo o está inactivo' WHERE id_fac = @idFacImp
								UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No se encontró el código de trabajo o está inactivo' WHERE id_fac_det = @idFacDetPImp
							
								GOTO Siguiente
							END 
						END
					END
					
					--Centro de costos
					BEGIN
					    SELECT
							@idCenCtoPC = v.id_cen_cto
						FROM @TblCenCto AS v
						WHERE v.codigo = @cenCtoPImp

						IF ISNULL(@idCenCtoPC, 0) = 0
						BEGIN
						    UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'No se encontró el centro de costos o está inactivo' WHERE id_fac = @idFacImp
							UPDATE dbo.imp_vta_fac_det SET status_det_imp = 2, cmt_imp = 'No se encontró el centro de costos o está inactivo' WHERE id_fac_det = @idFacDetPImp
							
							GOTO Siguiente
						END
					END
					
					--id_fis_rel
					BEGIN
						IF @idCodSrvPC > 0
					    BEGIN
							SELECT
								@idFisRelPC = tfr.id_fis_rel
							FROM @TblFisRel AS tfr
							WHERE tfr.id_cod_srv = @idCodSrvPC
					    END
						ELSE
						BEGIN
						    SELECT
								@idFisRelPC = tfr.id_fis_rel
							FROM @TblFisRel AS tfr
							WHERE tfr.id_pro = @idProPC
						END

						SET @idFisRelPC = ISNULL(@idFisRelPC, 0)
					END
					
					--Otros
					SET @idProPaqPC = CASE WHEN @tipoProPC = 3 AND @secPC = 0 THEN @idProPC ELSE 0 END
					
					INSERT INTO @TblPartsSp ( id_fac_det, id_doc_vta, sub, imptos, total, id_suc, no_part, id_pro, udm, cant, precio_orig, promoc, precio_pub, dcto_ptg, precio_cimptos, importe_cimptos, precio_pub_simptos, precio_simptos, importe_simptos, montos_imptos, id_impto, c_cambio_prec, costo, monto_descto, costo_total, id_almac, id_nota, tipo, tipo_pro, es_sub, cant_dev, por_facturar, id_rem, id_rem_part, id_mda, tc, oper, id_com_ser_lot, dias_ent, fec_prom, fec_emb, fec_req, id_prg_ent_fac_det, cant_surt, por_solic, id_part_pad, id_pro_ord, cant_ord_pro, id_pro_lis, id_lis_pre, c_prec_modif, id_kardex, id_cod_srv, id_cen_cto, id_ref, id_udm, ftr, id_ped, id_ped_part, num_ped, id_cot, id_cot_part, num_cot, id_spt, id_spt_part, num_spt, id_pad, id_tip_doc_pad, num_pad, num_ped_cli, num_req_cli, id_clas_pro, id_rel_impto, num_rem, operacion, id_tip_doc, num_doc, id_usr, id_kit, cant_kits, [status], num_doc_cnl, id_sis_cnl, id_nota_cnl, fec_apl_cnl, id_act, id_clas_act, valor_base, dep_acu, dep_rem, campo1, campo2, campo3, campo4, campo5, campo6, campo7, campo8, campo9, campo10, c_prg, id_pro_paq, id_part_ori, sec, id_int, id_cli_cta_de, id_ref_det, ptg_kit, id_cpt, cmt, Ref_ext, base_grav, tip_hon, ptg_hon, mod_impto, precio_ext, Campo11, Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18, Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25, Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32, Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39, Campo40, Id_Nota2, Id_Nota3, tip_com, ptg_com, mto_com, id_sis_lis_pre, id_tar_hon, des_tar_hon, id_fis_rel, id_ope_ext, Afe_inv_kardex, id_part_alm_sir, dias_alm_sir, dias_lib_alm_sir, dias_dcto_alm_sir, fec_corte_alm_sir, id_almje_gral, id_almje_esp, des_hon, [des], c_afe_exis_vta, id_com, num_grp, cant_surt_aut, apartado, backorder, fec_ped_cli, aum_ptg, cant_trasp, id_tur_req, id_tur_prom, id_mov_part, no_part_pad, id_fac_det_kit, c_ptg_ing, ptg_ing, id_prov_ter, rfc_prov, nom_prov, calle_prov, num_ext_prov, num_int_prov, col_prov, loc_prov, ref_prov, mun_prov, edo_prov, pais_prov, cp_prov, num_adu, fec_adu, aduana, cta_pred_num, id_rel_gas, c_prov_gas_cor, mtoDesctoCoupon, mtoDesctoVoucher, mtoIngresosConfirmado, mtoIngresosFuturos, mtoOtrosIngresos )
					VALUES ( @idFacDetPImp, @idDocVtaPC, @subPImp, @imptosPImp, @totalPImp, @idSuc, @noPartPC, @idProPC, @udmPC, @cantPImp, @precioOrigPC, @promocPC, @precioPubPC, @dctoPtgPC, @precioCimptosPC, @totalPImp, @precioPubSimptosPC, @precioSimptosPC, @subPImp, @imptosPImp, @idImptoPC, @cCambioPrecPC, @costoPC, @dctoMtoPImp, @costoTotalPImp, @idAlmacPC, @idNotaPC, @tipoPC, @tipoProPC, @esSubPC, @cantDevPC, @porFacturarPC, @idRemPC, @idRemPartPC, @idMda, @tipCamImp, @operMda, @idComSerLotPC, @diasEntPC, @fecPromPC, @fecPromPC, @fecReqPC, @idPrgEntFacDetPC, @cantSurtPC, @porSolicPC, @idPartPadPC, @idProOrdPC, @cantOrdProPC, @idProLisPC, @idLisPrePC, @cPrecModifPC, @idKardexPC, @idCodSrvPC, @idCenCtoPC, @idRefPC, @idUdmPC, @ftrPC, @idPedPC, @idPedPartPC, @numPedPC, @idCotPC, @idCotPartPC, @numCotPC, @idSptPC, @idSptPartPC, @numSptPC, @idPadPC, @idTipDocPadPC, @numPadPC, UPPER(@numPedCliPC), @numReqCliPC, @idClasProPC, 0, @numRemPC, @operacionPC, @idTipDocImp, @numeroImp, @idUsr, @idKitPC, @cantKitsPC, @statusFac, @numDocCnlPC, @idSisCnlPC, @idNotaCnlPC, @fecAplCnlPC, @idActPC, @idClasActPC, @valorBasePC, @depAcuPC, @depRemPC, @campo1PC, @campo2PC, @campo3PC, @campo4PC, @campo5PC, @campo6PC, @campo7PC, @campo8PC, @campo9PC, @campo10PC, @cPrgPC, @idProPaqPC, @idPartOriPC, @secPC, @idIntPC, @idCliCtaDePC, @idRefDetPC, @ptgKitPC, @idCptPC, @cmtPImp, UPPER(@RefExtPC), @baseGravPC, @tipHonPC, @ptgHonPC, @modImptoPC, @precioExtPC, @Campo11PC, @Campo12PC, @Campo13PC, @Campo14PC, @Campo15PC, @Campo16PC, @Campo17PC, @campo18PC, @campo19PC, @campo20PC, @campo21PC, @campo22PC, @campo23PC, @campo24PC, @campo25PC, @campo26PC, @campo27PC, @campo28PC, @campo29PC, @campo30PC, @campo31PC, @campo32PC, @campo33PC, @campo34PC, @campo35PC, @campo36PC, @campo37PC, @campo38PC, @campo39PC, @campo40PC, @IdNota2PC, @IdNota3PC, @tipComPC, @ptgComPC, @mtoComPC, @idSisLisPrePC, @idTarHonPC, @desTarHonPC, @idFisRelPC, @idOpeExtPC, @AfeInvKardexPC, @idPartAlmSirPC, @diasAlmSirPC, @diasLibAlmSirPC, @diasDctoAlmSirPC, @fecCorteAlmSirPC, @idAlmjeGralPC, @idAlmjeEspPC, @desHonPC, @descripcionPImp, @cAfeExisVtaPC, @idComPC, @numGrpPC, @cantSurtAutPC, @apartadoPC, @backorderPC, @fecPedCliPC, @aumPtgPC, @cantTraspPC, @idTurReqPC, @idTurPromPC, @idMovPartPC, @noPartPadPC, @idFacDetKitPC, @cPtgIngPC, @ptgIngPC, @idProvTerPC, @rfcProvPC, @nomProvPC, @calleProvPC, @numExtProvPC, @numIntProvPC, @colProvPC, @locProvPC, @refProvPC, @munProvPC, @edoProvPC, @paisProvPC, @cpProvPC, @numAduPC, @fecAduPC, @aduanaPC, @ctaPredNumPC, @idRelGasPC, @cProvGasCorPC, @mtoDesctoCouponPC, @mtoDesctoVoucherPC, @mtoIngresosConfirmadoPC, @mtoIngresosFuturosPC, @mtoOtrosIngresosPC )
					
					--Vamos a calcular los impuestos
					BEGIN
						--Empezamos obteniendo los datos como si estuviéramos calculando la estructura del impuesto
						BEGIN
						    DELETE FROM @TblImpuestosEI2

							--Parámetros de entrada
							SET @montoEI2 = @subPImp
							SET @IdImpEI2 = @idImptoPC
							SET @decimalesEI2 = @decCostoTot + 4
							SET @mtoImpManualEI2 = @imptosPImp
							SET @diferenciaEntrEI2 = @pVarImptos
							SET @montoConImptosEI2 = 0
							SET @cantidadEI2 = @cantPImp
							SET @IdProEI2 = @idProPC
							SET @esPaqueteEI2 = 0
							SET @mtoImptoInversoEntrEI2 = -1
							SET @dPrecioPaqEI2 = 0
							SET @bTruncarEI2 = 0
							SET @dctoEI2 = 0
							SET @pImptoManualEI2 = 0
							SET @tipoDocumentoEI2 = ''
							SET @origenEI2 = ''

							SET @mtoImptoInversoEI2 = @mtoImptoInversoEntrEI2
							SET @TipDocEI2 = @tipoDocumentoEI2

							IF @tipoDocumentoEI2 <> ''
								SET @tipoDocumentoEI2 = @tipoDocumentoEI2
							ELSE
								SET @tipoDocumentoEI2 = ''

							IF @origenEI2 <> ''
								SET @origenEI2 = LOWER(@origenEI2)
							ELSE
								SET @tipoDocumentoEI2 = ''

							IF @dctoEI2 > 0
								SET @dctoEI2 = @dctoEI2 / 100

							IF @IdProEI2 > 0
							BEGIN
								SELECT
									@cPtgImpLocalEI2 = cp.cPtgImpLocal, @ImpLocalEI2 = cp.impLocal, @ImpCTipEI2 = cp.impCTip, @ImpCDesEI2 = cp.impCDes, @ImpCTasaEI2 = cp.impCTasa, @ImpCFtrEI2 = cp.impCFtr, @ImpCCantEI2 = @cantidadEI2, @ImpCUDCEI2 = cp.impCUDC
								FROM @TblProds AS cp
								WHERE id_pro = @IdProEI2
							END

							SET @montoBaseEI2 = @montoEI2
							SET @montoImpuestosEI2 = 0

							IF @mtoImpManualEI2 > 0 OR @pImptoManualEI2 = 1
							BEGIN
								SET @calcInversoEI2 = 1
							END

							DECLARE ImpuestosEI3 CURSOR LOCAL FAST_FORWARD FOR
								SELECT
									vcif.id_impto, vcif.[des], vcif.[status], vcif.id_impto_det, vcif.id_cod_imp, vcif.id_cta, vcif.des_cod_imp, vcif.num_cta, vcif.nom, vcif.status_cta, vcif.tasa, vcif.c_iva, vcif.c_ret, vcif.c_exe, vcif.tipo, vcif.tip_impto, vcif.id_impto_cmp, vcif.c_pag_imp, vcif.c_zon_frn, vcif.c_iva_imp, vcif.id_tip_impto, vcif.c_base_iva, vcif.id_tip_ret, vcif.id_otr_sis, vcif.c_excluir_cfdi
								FROM @TblCatImptos AS vcif
								WHERE vcif.id_impto = @IdImpEI2

							OPEN ImpuestosEI3

							SET @contadorEI2 = @@CURSOR_ROWS

							FETCH FIRST FROM ImpuestosEI3
							INTO @IdImptoCIEI2, @desCIEI2, @statusCIEI2, @IdImptoDetCIEI2, @IdCodImpCIEI2, @IdCtaCIEI2, @desCodImpCIEI2, @numCtaCIEI2, @nomCIEI2, @statusCtaCIEI2, @tasaCIEI2, @cIvaCIEI2, @cRetCIEI2, @cExeCIEI2, @tipoCIEI2, @tipImptoCIEI2, @IdImpto_cmpCIEI2, @cPagImpCIEI2, @cZonFrnCIEI2, @cIvaImpCIEI2, @IdTipImptoCIEI2, @cBaseIvaCIEI2, @IdTipRetCIEI2, @IdOtrSisCIEI2, @cExcluirCfdiCIEI2

							IF @contadorEI2 > 0
							BEGIN
								SET @descripcionImpuestosEI2 = @desCIEI2
								SET @cPagImpEI2 = @cPagImpCIEI2
							Calcula:
								SET @XEI2 = 0
								SET @IEI2 = 0
								SET @tasaTotEI2 = 0
								SET @mtoTotEI2 = 0
								SET @IepsBaseIvaEI2 = 0
							END

							IF @contadorEI2 > 1
							BEGIN
								WHILE @@FETCH_STATUS = 0
								BEGIN
									SET @tipImptoEI2 = @tipImptoCIEI2

									IF @tipImptoEI2 = 1
									BEGIN
										SET @tasaTotEI2 = @tasaTotEI2 + @tasaCIEI2
										SET @BseImpEI2 = 1
									END
									ELSE IF @tipImptoEI2 = 2
									BEGIN
										SET @mtoTotEI2 = @mtoTotEI2 + (CASE WHEN @cPagImpEI2 = 1 THEN @tasaCIEI2 * -1 ELSE @tasaCIEI2 END * @cantidadEI2)

										IF @pRoundImptosEI2 = 1
										BEGIN
											SET @mtoTotEI2 = ROUND(@mtoTotEI2, @decMontoEI2)
										END

										SET @BseCanEI2 = 1
									END

									SET @EstructDblEI2 = CASE WHEN @BseImpEI2 = 1 AND @BseCanEI2 = 1 THEN 1 ELSE 0 END

									FETCH NEXT FROM ImpuestosEI3
									INTO @IdImptoCIEI2, @desCIEI2, @statusCIEI2, @IdImptoDetCIEI2, @IdCodImpCIEI2, @IdCtaCIEI2, @desCodImpCIEI2, @numCtaCIEI2, @nomCIEI2, @statusCtaCIEI2, @tasaCIEI2, @cIvaCIEI2, @cRetCIEI2, @cExeCIEI2, @tipoCIEI2, @tipImptoCIEI2, @IdImpto_cmpCIEI2, @cPagImpCIEI2, @cZonFrnCIEI2, @cIvaImpCIEI2, @IdTipImptoCIEI2, @cBaseIvaCIEI2, @IdTipRetCIEI2, @IdOtrSisCIEI2, @cExcluirCfdiCIEI2
								END
							END
							ELSE
							BEGIN
								SET @tasaTotEI2 = CASE WHEN @cPagImpEI2 = 1 THEN @tasaCIEI2 * -1 ELSE @tasaCIEI2 END
							END

							FETCH FIRST FROM ImpuestosEI3
							INTO @IdImptoCIEI2, @desCIEI2, @statusCIEI2, @IdImptoDetCIEI2, @IdCodImpCIEI2, @IdCtaCIEI2, @desCodImpCIEI2, @numCtaCIEI2, @nomCIEI2, @statusCtaCIEI2, @tasaCIEI2, @cIvaCIEI2, @cRetCIEI2, @cExeCIEI2, @tipoCIEI2, @tipImptoCIEI2, @IdImpto_cmpCIEI2, @cPagImpCIEI2, @cZonFrnCIEI2, @cIvaImpCIEI2, @IdTipImptoCIEI2, @cBaseIvaCIEI2, @IdTipRetCIEI2, @IdOtrSisCIEI2, @cExcluirCfdiCIEI2

							WHILE @@FETCH_STATUS = 0
							BEGIN
								SET @XEI2 = @XEI2 + 1

								INSERT INTO @TblImpuestosEI2 ( id, mto_impto_inverso, monto_base, monto_impuestos, tot_impuestos, descripcion_impuestos, modificado, id_imp, descripcion, tasa, monto, id_cta, c_iva, c_ret, c_exe, tip_impto, id_tip_impto, c_base_iva, ImpC_des, ImpC_tasa, ImpC_ftr, ImpC_cant, ImpC_UDC, ImpC_mto )
								VALUES ( @XEI2, 0.0, CASE WHEN @XEI2 = 1 THEN @montoBaseEI2 ELSE 0.0 END, CASE WHEN @XEI2 = 1 THEN @montoImpuestosEI2 ELSE 0.0 END, 0, CASE WHEN @XEI2 = 1 THEN @descripcionImpuestosEI2 ELSE '' END, 0, 0, '', 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, '', 0.0, 0.0, 0.0, 0.0, 0.0 )

								IF @cPagImpEI2 = 1
								BEGIN
									SET @tasaEI2 = @tasaCIEI2 * -1
								END
								ELSE
								BEGIN
									SET @tasaEI2 = @tasaCIEI2
								END

								SET @tipImptoEI2 = @tipImptoCIEI2

								UPDATE i
								SET
									i.descripcion = @desCodImpCIEI2,
									i.tasa = @tasaEI2,
									i.id_imp = @IdCodImpCIEI2,
									i.tip_impto = @tipImptoEI2,
									i.id_tip_impto = @IdTipImptoCIEI2,
									i.c_base_iva = @cBaseIvaCIEI2,
									i.id_cta = @IdCtaCIEI2,
									i.c_iva = @cIvaCIEI2,
									i.c_ret = CASE WHEN @cPagImpEI2 = 1 THEN 0 ELSE @cRetCIEI2 END,
									i.c_exe = @cExeCIEI2
								FROM @TblImpuestosEI2 AS i
								WHERE i.id = @XEI2

								IF @calcInversoEI2 = 1
								BEGIN
									IF @tasaTotEI2 = 0
									BEGIN
										SET @BaseEI2 = @montoEI2 - @mtoTotEI2
									END
									ELSE
									BEGIN
										SET @BaseEI2 = (@mtoImpManualEI2 - @mtoTotEI2) / (@tasaTotEI2 / 100)
									END

									IF @tipoDocumentoEI2 = '120' AND @origenEI2 <> 'cxc'
									BEGIN
										SET @BaseImptosEI2 = ROUND(@BaseEI2, @decimalesEI2)
									END
									ELSE
									BEGIN
										SET @BaseImptosEI2 = @BaseEI2
									END

									IF @tipImptoEI2 = 1
									BEGIN
										UPDATE i
										SET i.monto = ROUND(@BaseImptosEI2 * (@tasaEI2 / 100), @decimalesEI2)
										FROM @TblImpuestosEI2 AS i
										WHERE i.id = @XEI2
									END
									ELSE IF @tipImptoEI2 = 2
									BEGIN
										UPDATE i
										SET i.monto = ROUND(@cantidadEI2 * @tasaEI2, @decimalesEI2)
										FROM @TblImpuestosEI2 AS i
										WHERE i.id = @XEI2
									END

									IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.c_iva = 1 AND i.c_ret = 0 AND i.c_exe = 0 AND @ImpLocalEI2 > 0 AND @BaseEI2 > 0 )
									BEGIN
										IF @cPtgImpLocalEI2 = 1
										BEGIN
											SET @mtoImpLEI2 = @montoEI2 * @ImpLocalEI2 * 0.01
										END
										ELSE
										BEGIN
											SET @mtoImpLEI2 = @ImpCUDCEI2 * @cantidadEI2 * @ImpLocalEI2
										END

										UPDATE i
										SET
											i.tip_impto = @ImpCTipEI2,
											i.ImpC_des = @ImpCDesEI2,
											i.ImpC_tasa = @ImpCTasaEI2,
											i.ImpC_ftr = @ImpCFtrEI2,
											i.ImpC_cant = @ImpCCantEI2,
											i.ImpC_UDC = @ImpCUDCEI2,
											i.ImpC_mto = @mtoImpLEI2
										FROM @TblImpuestosEI2 AS i
										WHERE i.id = @XEI2
									END
									ELSE
									BEGIN
										UPDATE i
										SET
											i.tip_impto = 0,
											i.ImpC_des = '',
											i.ImpC_tasa = 0,
											i.ImpC_ftr = 0,
											i.ImpC_cant = 0,
											i.ImpC_UDC = 0,
											i.ImpC_mto = 0
										FROM @TblImpuestosEI2 AS i
										WHERE i.id = @XEI2
									END
								END
								ELSE
								BEGIN
									IF @montoConImptosEI2 > 0
									BEGIN
										SET @BaseEI2 = @montoConImptosEI2

										IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.id_tip_impto = 15000 )
										BEGIN
											IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.c_iva = 1 AND i.c_ret = 0 AND i.c_exe = 0 AND @ImpLocalEI2 > 0 AND @BaseEI2 > 0 )
											BEGIN
												IF @cPtgImpLocalEI2 = 1
												BEGIN
													SET @mtoImpLEI2 = @montoEI2 * @ImpLocalEI2 * 0.01
												END
												ELSE
												BEGIN
													IF @dctoEI2 > 0
													BEGIN
														SET @mtoImpLEI2 = (@ImpCUDCEI2 * @cantidadEI2 * @ImpLocalEI2)
														SET @mtoImpLcdEI2 = @mtoImpLEI2 - (@mtoImpLEI2 * @dctoEI2)
													END
													ELSE
													BEGIN
														SET @mtoImpLEI2 = @ImpCUDCEI2 * @cantidadEI2 * @ImpLocalEI2
													END
												END

												IF @dctoEI2 > 0
												BEGIN
													SET @mtoImpLEI2 = @mtoImpLcdEI2

													UPDATE i
													SET i.monto_base = @BaseImptosEI2
													FROM @TblImpuestosEI2 AS i
													WHERE i.id = 1

													SET @BaseImptosEI2 = @BaseImptosEI2 - @mtoImpLEI2
												END
												ELSE
												BEGIN
													SET @BaseImptosEI2 = @BaseEI2 - @mtoImpLEI2
												END

												SET @mtoTotEI2 = @mtoImpLEI2

												UPDATE i
												SET
													i.id_tip_impto = @ImpCTipEI2,
													i.ImpC_des = @ImpCDesEI2,
													i.ImpC_tasa = @ImpCTasaEI2,
													i.ImpC_ftr = @ImpCFtrEI2,
													i.ImpC_cant = @ImpCCantEI2,
													i.ImpC_UDC = @ImpCUDCEI2,
													i.ImpC_mto = @mtoImpLEI2
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
											ELSE
											BEGIN
												SET @mtoTotEI2 = @mtoImpLEI2
												SET @BaseImptosEI2 = @BaseEI2 + @IepsBaseIvaEI2

												UPDATE i
												SET
													i.id_tip_impto = 0,
													i.ImpC_des = '',
													i.ImpC_tasa = 0,
													i.ImpC_ftr = 0,
													i.ImpC_cant = 0,
													i.ImpC_UDC = 0,
													i.ImpC_mto = 0
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
										END

										IF @esPaqueteEI2 = 1
										BEGIN
											SET @BaseEI2 = (@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaEI2 / 100))
										END
										ELSE IF @origenEI2 = 'cxc'
										BEGIN
											SET @BaseEI2 = ROUND((@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaTotEI2 / 100)), 6)
										END
										ELSE IF @tipoDocumentoEI2 <> '' AND @tipoDocumentoEI2 = '120'
										BEGIN
											SET @BaseEI2 = ROUND((@montoConImptosEI2 - @mtoTotEI2) / (1 + @tasaTotEI2 / 100), @decimalesEI2)
										END
										ELSE
										BEGIN
											SET @BaseEI2 = (@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaTotEI2 / 100))
										END

										IF @tipoDocumentoEI2 = '120' AND @origenEI2 <> 'cxc'
										BEGIN
											SET @BaseImptosEI2 = ROUND(@BaseEI2, @decimalesEI2)
										END
										ELSE IF @origenEI2 = 'cxc'
										BEGIN
											SET @BaseImptosEI2 = ROUND(@BaseEI2, 6)
										END
										ELSE
										BEGIN
											SET @BaseImptosEI2 = @BaseEI2
										END

										IF @mtoImptoInversoEI2 >= 0 AND @esPaqueteEI2 = 1
										BEGIN
											IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.id_tip_impto = 15004 AND i.c_base_iva = 1 )
											BEGIN
												SET @tasaMenosIepsEI2 = @tasaTotEI2 - @tasaEI2
												SET @soloIvaEI2 = (@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaMenosIepsEI2 / 100))
												SET @mtoImptoInversoEI2 = @soloIvaEI2 / (1 + (@tasaEI2 / 100))
											END
											ELSE
											BEGIN
												IF @mtoImptoInversoEI2 = 0
												BEGIN
													SET @mtoImptoInversoEI2 = (@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaTotEI2 / 100))
												END
											END
										END

										IF @tipImptoEI2 = 1
										BEGIN
											IF @tipoDocumentoEI2 = '120'
											BEGIN
												SET @BaseImptos120EI2 = ROUND((@montoConImptosEI2 - @mtoTotEI2) / (1 + (@tasaTotEI2 / 100)), 6)

												UPDATE i
												SET i.monto = ROUND(@BaseImptos120EI2 * (@tasaEI2 / 100), @decimalesEI2)
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
											ELSE
											BEGIN
												UPDATE i
												SET i.monto = ROUND(@BaseImptosEI2 * (@tasaEI2 / 100), @decimalesEI2)
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
										END
										ELSE IF @tipImptoEI2 = 2
										BEGIN
											UPDATE i
											SET i.monto = @cantidadEI2 * @tasaEI2
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = @XEI2
										END

										IF @origenEI2 = 'cxc'
										BEGIN
											UPDATE i
											SET i.monto_base = ROUND(@BaseImptosEI2, 6)
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = 1
										END
										ELSE
										BEGIN
											UPDATE i
											SET i.monto_base = ROUND(@BaseImptosEI2, @decimalesEI2)
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = 1
										END
									END
									ELSE
									BEGIN
										SET @BaseEI2 = @montoEI2
										SET @BaseImptosEI2 = @BaseEI2

										IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.id_tip_impto = 1500 )
										BEGIN
											IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.c_iva = 1 AND i.c_ret = 0 AND i.c_exe = 0 AND @ImpLocalEI2 > 0 AND @BaseEI2 > 0 )
											BEGIN
												IF @cPtgImpLocalEI2 = 1
												BEGIN
													SET @mtoImpLEI2 = @montoEI2 * @ImpLocalEI2 * 0.01
												END
												ELSE
												BEGIN
													IF @dctoEI2 > 0
													BEGIN
														SET @mtoImpLEI2 = (@ImpCUDCEI2 * @cantidadEI2 * @ImpLocalEI2)
														SET @mtoImpLcdEI2 = @mtoImpLEI2 - (@mtoImpLEI2 * @dctoEI2)
													END
													ELSE
													BEGIN
														SET @mtoImpLEI2 = @ImpCUDCEI2 * @cantidadEI2 * @ImpLocalEI2
													END
												END

												IF @dctoEI2 > 0
												BEGIN
													SET @mtoImpLEI2 = @mtoImpLcdEI2
							
													UPDATE i
													SET i.monto_base = @BaseImptosEI2
													FROM @TblImpuestosEI2 AS i
													WHERE i.id = 1

													SET @BaseImptosEI2 = @BaseEI2 - @mtoImpLEI2
												END
												ELSE
												BEGIN
													SET @BaseImptosEI2 = @BaseEI2 - @mtoImpLEI2
												END

												UPDATE i
												SET
													i.id_tip_impto = @ImpCTipEI2,
													i.ImpC_des = @ImpCDesEI2,
													i.ImpC_tasa = @ImpCTasaEI2,
													i.ImpC_ftr = @ImpCFtrEI2,
													i.ImpC_cant = @ImpCCantEI2,
													i.ImpC_UDC = @ImpCUDCEI2,
													i.ImpC_mto = @mtoImpLEI2
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
											ELSE
											BEGIN
												SET @BaseImptosEI2 = @BaseEI2 + @IepsBaseIvaEI2

												UPDATE i
												SET
													i.id_tip_impto = 0,
													i.ImpC_des = '',
													i.ImpC_tasa = 0,
													i.ImpC_ftr = 0,
													i.ImpC_cant = 0,
													i.ImpC_UDC = 0,
													i.ImpC_mto = 0
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
										END

										IF @tipImptoEI2 = 1
										BEGIN
											IF @EstructDblEI2 = 1 OR @bTruncarEI2 = 1
											BEGIN
												UPDATE i
												SET i.monto = @BaseImptosEI2 * (@tasaEI2 / 100)
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
											ELSE
											BEGIN
												UPDATE i
												SET i.monto = ROUND(@BaseImptosEI2 * (@tasaEI2 / 100), @decimalesEI2)
												FROM @TblImpuestosEI2 AS i
												WHERE i.id = @XEI2
											END
										END
										ELSE IF @tipImptoEI2 = 2
										BEGIN
											UPDATE i
											SET i.monto = @cantidadEI2 * @tasaEI2
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = @XEI2
										END

										IF ISNULL(TRY_CAST(@TipDocEI2 AS INT), 0) IN (99, 110, 90, 121)
										BEGIN
											UPDATE i
											SET i.monto = @mtoImpManualEI2
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = @XEI2
										END

										IF @pRoundImptosEI2 = 1
										BEGIN
											UPDATE i
											SET i.monto = ROUND(i.monto, @decMontoEI2)
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = @XEI2
										END

										IF EXISTS ( SELECT i.id FROM @TblImpuestosEI2 AS i WHERE i.id = @XEI2 AND i.id_tip_impto = 15004 AND i.c_base_iva = 1 )
										BEGIN
											SELECT
												@IepsBaseIvaEI2 = @IepsBaseIvaEI2 + i.monto
											FROM @TblImpuestosEI2 AS i
											WHERE i.id = @XEI2
										END
									END
								END

								UPDATE i
								SET
									i.id_cta = @IdCtaCIEI2,
									i.c_iva = @cIvaCIEI2,
									i.c_ret = CASE WHEN @cPagImpEI2 = 1 THEN 0 ELSE @cRetCIEI2 END,
									i.c_exe = @cExeCIEI2
								FROM @TblImpuestosEI2 AS i
								WHERE i.id = @XEI2

								SELECT
									@IEI2 = @IEI2 + i.monto
								FROM @TblImpuestosEI2 AS i
								WHERE i.id = @XEI2

								FETCH NEXT FROM ImpuestosEI3
								INTO @IdImptoCIEI2, @desCIEI2, @statusCIEI2, @IdImptoDetCIEI2, @IdCodImpCIEI2, @IdCtaCIEI2, @desCodImpCIEI2, @numCtaCIEI2, @nomCIEI2, @statusCtaCIEI2, @tasaCIEI2, @cIvaCIEI2, @cRetCIEI2, @cExeCIEI2, @tipoCIEI2, @tipImptoCIEI2, @IdImpto_cmpCIEI2, @cPagImpCIEI2, @cZonFrnCIEI2, @cIvaImpCIEI2, @IdTipImptoCIEI2, @cBaseIvaCIEI2, @IdTipRetCIEI2, @IdOtrSisCIEI2, @cExcluirCfdiCIEI2
							END

							CLOSE ImpuestosEI3
							DEALLOCATE ImpuestosEI3

							IF @calcInversoEI2 = 1
							BEGIN
								SET @difEI2 = ROUND(@IEI2 - @mtoImpManualEI2, @decimalesEI2)

								IF @difEI2 <> 0
								BEGIN
									IF @pVarImptosEI2 < ABS(@difEI2)
									BEGIN
										SET @calcInversoEI2 = 0

										FETCH FIRST FROM ImpuestosEI3
										INTO @IdImptoCIEI2, @desCIEI2, @statusCIEI2, @IdImptoDetCIEI2, @IdCodImpCIEI2, @IdCtaCIEI2, @desCodImpCIEI2, @numCtaCIEI2, @nomCIEI2, @statusCtaCIEI2, @tasaCIEI2, @cIvaCIEI2, @cRetCIEI2, @cExeCIEI2, @tipoCIEI2, @tipImptoCIEI2, @IdImpto_cmpCIEI2, @cPagImpCIEI2, @cZonFrnCIEI2, @cIvaImpCIEI2, @IdTipImptoCIEI2, @cBaseIvaCIEI2, @IdTipRetCIEI2, @IdOtrSisCIEI2, @cExcluirCfdiCIEI2

										GOTO Calcula
									END
									ELSE
									BEGIN
										UPDATE i
										SET i.monto = i.monto - @difEI2
										FROM @TblImpuestosEI2 AS i
										WHERE i.id = @XEI2
									END
								END
							END

							UPDATE i
							SET
								i.tot_impuestos = @XEI2,
								i.monto_impuestos = @IEI2,
								i.mto_impto_inverso = CASE WHEN @mtoImptoInversoEntrEI2 < 0 THEN 0 ELSE @mtoImptoInversoEntrEI2 END
							FROM @TblImpuestosEI2 AS i
							WHERE i.id = 1
						END

						--Armamos la estructura de los impuestos
					    INSERT INTO @TblEstrImptos ( id, mto_impto_inverso, monto_base, monto_impuestos, tot_impuestos, descripcion_impuestos, modificado, id_imp, descripcion, tasa, monto, id_cta, c_iva, c_ret, c_exe, tip_impto, id_tip_impto, c_base_iva, ImpC_des, ImpC_tasa, ImpC_ftr, ImpC_cant, ImpC_UDC, ImpC_mto )
							SELECT
								fci.id, fci.mto_impto_inverso, fci.monto_base, fci.monto_impuestos, fci.tot_impuestos, fci.descripcion_impuestos, fci.modificado, fci.id_imp, fci.descripcion, fci.tasa, fci.monto, fci.id_cta, fci.c_iva, fci.c_ret, fci.c_exe, fci.tip_impto, fci.id_tip_impto, fci.c_base_iva, fci.ImpC_des, fci.ImpC_tasa, fci.ImpC_ftr, fci.ImpC_cant, fci.ImpC_UDC, fci.ImpC_mto
							FROM @TblImpuestosEI2 AS fci
							/*
							SELECT
								fci.id, fci.mto_impto_inverso, fci.monto_base, fci.monto_impuestos, fci.tot_impuestos, fci.descripcion_impuestos, fci.modificado, fci.id_imp, fci.descripcion, fci.tasa, fci.monto, fci.id_cta, fci.c_iva, fci.c_ret, fci.c_exe, fci.tip_impto, fci.id_tip_impto, fci.c_base_iva, fci.ImpC_des, fci.ImpC_tasa, fci.ImpC_ftr, fci.ImpC_cant, fci.ImpC_UDC, fci.ImpC_mto
							FROM dbo.fn_calcula_impuestos(@subPImp, @idImptoPC, @decCostoTot + 4, @imptosPImp, @pVarImptos, DEFAULT, @cantPImp, @idProPC, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) AS fci
							*/
						
						--Ahora por cada uno vamos a ingresarlo a la tabla de impuestos que creamos
						DECLARE EstrImptos CURSOR FOR
							SELECT
								tei.id, tei.mto_impto_inverso, tei.monto_base, tei.monto_impuestos, tei.tot_impuestos, tei.descripcion_impuestos, tei.modificado, tei.id_imp, tei.descripcion, tei.tasa, tei.monto, tei.id_cta, tei.c_iva, tei.c_ret, tei.c_exe, tei.tip_impto, tei.id_tip_impto, tei.c_base_iva, tei.ImpC_des, tei.ImpC_tasa, tei.ImpC_ftr, tei.ImpC_cant, tei.ImpC_UDC, tei.ImpC_mto
							FROM @TblEstrImptos AS tei
						
						OPEN EstrImptos

						FETCH NEXT FROM EstrImptos
						INTO @idEI, @mtoImptoInversoEI, @montoBaseEI, @montoImpuestosEI, @totImpuestosEI, @descripcionImpuestosEI, @modificadoEI, @idImpEI, @descripcionEI, @tasaEI, @montoEI, @idCtaEI, @cIvaEI, @cRetEI, @cExeEI, @tipImptoEI, @idTipImptoEI, @cBaseIvaEI, @ImpCDesEI, @ImpCTasaEI, @ImpCFtrEI, @ImpCCantEI, @ImpCUDCEI, @ImpCMtoEI
						
						WHILE @@FETCH_STATUS = 0
						BEGIN
							--Limpieza de variables
							BEGIN
							    SET @idFacDetCI = @idFacDetPImp
								SET @idSisImpCI = 0 /*Se calcula en el grabado*/
								SET @idRelImpCI = 0 /*Se calcula en el grabado*/
								SET @idTipDocCI = @idTipDocImp
								SET @idDocCI = 0 /*Se calcula en el grabado*/
								SET @idDocPartCI = 0 /*Se calcula en el grabado*/
								SET @numDocCI = @numeroImp
								SET @fecDocCI = @fechaImp
								SET @idCliCI = @idCli
								SET @idProvCI = 0
								SET @idImptoCI = @idImptoPC
								SET @idCodImpCI = @idImpEI
								SET @desCI = @descripcionEI
								SET @tasaCI = @tasaEI
								SET @cIvaCI = @cIvaEI
								SET @cRetCI = @cRetEI
								SET @cExeCI = @cExeEI
								SET @mtoBaseCI = @subPImp
								SET @mtoImpCI = ROUND(@montoEI * (1 - 0 / 100), @decMonto)
								SET @idMdaCI = @idMda
								SET @operCI = @operMda
								SET @tcCI = @tipCamImp
								SET @mtoBaseBseCI = CASE
									WHEN @operMda = 0 THEN @subPImp * @tipCamImp
									ELSE @subPImp / @tipCamImp
								END
								SET @mtoImpBseCI = CASE
									WHEN @operMda = 0 THEN ROUND(@mtoImpCI * @tipCamImp, @decMonto)
									ELSE ROUND(@mtoImpCI / @tipCamImp, @decMonto)
								END
								SET @idCtaCI = @idCtaEI
								SET @idUsrCI = @idUsr
								SET @fecRegCI = GETDATE()
								SET @statusCI = 1
								SET @cAfeCtbCI = 1
								SET @dctoGlbCI = 0
								SET @mtoImpSDctoCI = ROUND(@montoEI, @decMonto)
								SET @mtoBaseSDctoCI = ROUND(@subPImp, @decMonto)
								SET @idRelImpDocCI = 0 /*Se calcula en el grabado*/
								SET @cModImptosCI = @modImptoPC
								SET @ivaAplCI = 0
								SET @ivaSdoCI = @mtoImpBseCI
								SET @mtoPagRetCI = 0
								SET @mtoAcrRetCI = 0
								SET @fecPgoCI = '19000101'
								SET @idBcoAuxCI = 0
								SET @idCliFaCI = @idFA
								SET @noFactCI = ''
								SET @cRecIvaCI = CASE
									WHEN @idProPaqPC > 0 AND @secPC = 0 THEN 0
									ELSE 1
								END
								SET @idFisRelCI = @idFisRelPC
								SET @idCenCtoCI = @idCenCtoPC
								SET @idRefCI = @idRefPC
								SET @idCodSrvCI = @idCodSrvPC
								SET @idProCI = @idProPC
								SET @idAlmCI = @idAlmacPC
								SET @idEntCI = 0
								SET @impCTipCI = CASE
									WHEN @ImpCTasaEI > 0 THEN 1
									ELSE CASE
										WHEN @ImpCFtrEI > 0 THEN 2
										ELSE 0
									END
								END
								SET @impCDesCI = @ImpCDesEI
								SET @impCTasaCI = @ImpCTasaEI
								SET @impCFtrCI = @ImpCFtrEI
								SET @impCCantCI = @ImpCCantEI
								SET @impCUDCCI = @ImpCUDCEI
								SET @impCMtoCI = @ImpCMtoEI
								SET @ptgAcuComCI = 100
							END
							
							INSERT INTO @TblImptos ( id_fac_det, id_sis_imp, id_rel_imp, id_tip_doc, id_doc, id_doc_part, num_doc, fec_doc, id_cli, id_prov, id_impto, id_cod_imp, [des], tasa, c_iva, c_ret, c_exe, mto_base, mto_imp, id_mda, oper, tc, mto_base_bse, mto_imp_bse, id_cta, id_usr, fec_reg, [status], c_afe_ctb, dcto_glb, mto_imp_s_dcto, mto_base_s_dcto, id_rel_imp_doc, c_mod_imptos, iva_apl, iva_sdo, mto_pag_ret, mto_acr_ret, fec_pgo, id_bco_aux, id_cli_fa, no_fact, c_rec_iva, id_fis_rel, id_cen_cto, id_ref, id_cod_srv, id_pro, id_alm, id_ent, impC_tip, impC_des, impC_tasa, impC_ftr, impC_cant, impC_UDC, impC_mto, ptg_acu_com )
							VALUES ( @idFacDetCI, @idSisImpCI, @idRelImpCI, @idTipDocCI, @idDocCI, @idDocPartCI, @numDocCI, @fecDocCI, @idCliCI, @idProvCI, @idImptoCI, @idCodImpCI, @desCI, @tasaCI, @cIvaCI, @cRetCI, @cExeCI, @mtoBaseCI, @mtoImpCI, @idMdaCI, @operCI, @tcCI, @mtoBaseBseCI, @mtoImpBseCI, @idCtaCI, @idUsrCI, @fecRegCI, @statusCI, @cAfeCtbCI, @dctoGlbCI, @mtoImpSDctoCI, @mtoBaseSDctoCI, @idRelImpDocCI, @cModImptosCI, @ivaAplCI, @ivaSdoCI, @mtoPagRetCI, @mtoAcrRetCI, @fecPgoCI, @idBcoAuxCI, @idCliFaCI, @noFactCI, @cRecIvaCI, @idFisRelCI, @idCenCtoCI, @idRefCI, @idCodSrvCI, @idProCI, @idAlmCI, @idEntCI, @impCTipCI, @impCDesCI, @impCTasaCI, @impCFtrCI, @impCCantCI, @impCUDCCI, @impCMtoCI, @ptgAcuComCI )
							
						    FETCH NEXT FROM EstrImptos
							INTO @idEI, @mtoImptoInversoEI, @montoBaseEI, @montoImpuestosEI, @totImpuestosEI, @descripcionImpuestosEI, @modificadoEI, @idImpEI, @descripcionEI, @tasaEI, @montoEI, @idCtaEI, @cIvaEI, @cRetEI, @cExeEI, @tipImptoEI, @idTipImptoEI, @cBaseIvaEI, @ImpCDesEI, @ImpCTasaEI, @ImpCFtrEI, @ImpCCantEI, @ImpCUDCEI, @ImpCMtoEI
						END
						
						CLOSE EstrImptos
						DEALLOCATE EstrImptos
					END
					
					SET @contPartidas = @contPartidas + 1
					
				    FETCH NEXT FROM Partidas
					INTO @idFacDetPImp, @cveProPImp, @idOtrSisProPImp, @descripcionPImp, @cantPImp, @udmPImp, @subPImp, @dctoMtoPImp, @imptosPImp, @totalPImp, @idImptoPImp, @costoPImp, @costoTotalPImp, @codAlmPImp, @idOtrSisAlmPImp, @cenCtoPImp, @codSrvPImp, @numPedCliPImp, @fecReqPImp, @numRefPImp, @cmtPImp
				END

				CLOSE Partidas
				DEALLOCATE Partidas
			END
			SELECT tiempo = GETDATE(), mensaje = 'Termina de armar partidas'
			--Ya tenemos todo, vamos a empezar a guardar todo en tablas
			BEGIN TRANSACTION

			BEGIN TRY
				--Obtenemos Identities
				BEGIN
					EXEC dbo.sp_obtIdvtafacenc @id = @idFac OUTPUT

					EXEC dbo.sp_sis_notas @id_nota = @idNota OUTPUT, @nota = @notaImp, @cmt = '', @id_clas1 = 0, @id_usr = @idUsr, @status = 1

					EXEC dbo.sp_obtIdsisrelimpdoc @id = @idRelImpDoc OUTPUT 
				END
				
				--Ejecutamos procedures
				BEGIN
					EXEC dbo.sp_vta_fac_enc_dir @id_fac = @idFac,
						@id_usr = @idUsr, -- Pendiente*
						@id_cli = @idCli,
						@id_tipo_doc = @idTipDocImp,
						@numero = @numeroFac,
						@fecha = @fechaImp,
						@sub = @subImp,
						@imptos = @imptosImp,
						@total = @totalImp,
						@saldo = @saldoFac,
						@dcto = 0.0,
						@dcto_mto = 0.0,
						@id_suc = @idSuc,
						@status = @statusFac,
						@dias = @diasImp,
						@fecha_venc = @fecVencImp,
						@id_nota = @idNota,
						@id_proy = 0,
						@ref = @cmtImp,
						@id_vend = @idVend,
						@tipo_fac = @tipoFac,
						@id_mda = @idMda,
						@tip_cam = @tipCamImp,
						@oper = @operMda,
						@id_lab = 0,
						@id_med_env1 = 0,
						@no_guia1 = '',
						@fec_guia1 = '19000101',
						@id_med_env2 = 0,
						@no_guia2 = '',
						@fec_guia2 = '19000101',
						@fec_ent = '19000101',
						@id_emp_realizo = 0,
						@id_emp_aut = 0,
						@prioridad = 0,
						@id_sis_edo_act = 0,
						@falla = '',
						@id_cpt = @idCpt,
						@id_cnd = @cndPagImp,
						@id_cli_pad = @idCliPad,
						@id_clas_cli = @idClasCli,
						@id_cli_fa = @idFA,
						@id_cli_da = @idCliDaMer, -- Pendiente*
						@id_cto = @idCto,
						@id_rel_imp_doc = @idRelImpDoc,
						@num_doc_cnl = 0,
						@id_sis_cnl = 0,
						@id_nota_cnl = 0,
						@fec_apl_cnl = '19000101',
						@serie = @serieFac,
						@operacion = @operFac,
						@BuscaComision = 0, -- Pendiente
						@c_dis = 0,
						@dis = 0,
						@ptg_dis = 0.0,
						@id_fac_sust = 0, -- Pendiente*
						@id_nota_sust = 0,
						@id_tip_vta = 0,
						@mto_ant = 0.0,
						@sdo_ant = 0.0,
						@mto_apl = 0.0,
						@sdo_apl = 0.0,
						@fec_est_cob = @fecEstPag,
						@fec_rev = @fechaImp,
						@status_prc = 0,
						@id_cli_da_mer = @idCliDaMer,
						@tip_nc = 0,
						@c_comp = 0,
						@v_cancelar = 0,
						@status_surt = 99,
						@c_imp_ley = 0, -- Pendiente
						@leyenda = '', -- Pendiente
						@id_tip_uso = @idUsoCFDI,
						@id_operador = 0,
						@id_equipo = 0,
						@id_porteador = 0,
						@fec_recoleccion = @fechaImp,
						@fec_prometida = @fechaImp,
						@fec_ent_real = @fechaImp,
						@id_caja = 0,
						@id_almac_orig = 0,
						@id_caja2 = 0,
						@origen_doc = 13,
						@c_multisuc = 0,
						@idAlmacDest = 0,
						@idPreRef = 0,
						@perFacGlobal = 0
					
					EXEC dbo.sp_vta_fac_enc_cli @id_fact = @idFac,
						@id_clie = @idCli,
						@nom1 = @nom1,
						@nom2 = @nom2,
						@dir1 = @dir1,
						@dir2 = '',
						@ciu = @ciu,
						@est = @est,
						@cp = @cp,
						@rfc = @rfc,
						@tel1 = @tel1,
						@tel2 = @tel2,
						@c_most = 0,
						@operacion = @operFac,
						@contacto1 = '',
						@depto = '',
						@tip_trn = @tipTrn,
						@tip_grp = @tipGrp,
						@c_ieps_desg = @cIepsDesg,
						@num_apr = @numApr,
						@id_ser_fol = @idSerFol,
						@id_tip_ser = @idTipFac,
						@uuid = @uuid,
						@sello_sat = @selloSAT, -- Pendiente
						@CBB = @cbb, -- Pendiente
						@id_pac = @idPac, -- Pendiente
						@calle = @calle,
						@num_int = @numInt,
						@num_ext = @numExt,
						@col = @colonia,
						@deleg = @delegacion,
						@calles = @calles,
						@id_pais = @idPais,
						@id_edo = @idEdo,
						@fec_tim_pac = @fecCertSAT,
						@cert_sat = @certificado,
						@xml_canc = @xmlCanc,
						@c_timb = @cTimb,
						@ult_dig_cta = @ultDigCta, -- Pendiente
						@id_sugar = @idSugar,
						@id_cli_cta = @idCliCta, -- Pendiente
						@tip_pag_cta = @tipPagCta,
						@bco_cta = @bcoCta, -- Pendiente
						@idis_cta = @idsCtas, -- Pendiente
						@UsoCFDI = @usoCFDIImp,
						@UsoCFDIdes = @usoCFDIDes,
						@c_comp_cp = @cCompCp,
						@idRegFis = @idRegFisc
					
					--Partidas
					BEGIN
						SELECT tiempo = GETDATE(), mensaje = 'Empieza a grabar partidas'
						--Volvemos a limpiar las variables a usar en el fetch para asegurarnos de que no traigan basura
						BEGIN
							SET @idFacDetPC = 0
							SET @idDocVtaPC = 0
							SET @subPC = 0
							SET @imptosPC = 0
							SET @totalPC = 0
							SET @idSucPC = 0
							SET @noPartPC = 1
							SET @idProPC = 0
							SET @udmPC = ''
							SET @cantPC = 0
							SET @precioOrigPC = 0
							SET @promocPC = 0
							SET @precioPubPC = 0
							SET @dctoPtgPC = 0
							SET @precioCimptosPC = 0
							SET @importeCimptosPC = 0
							SET @precioPubSimptosPC = 0
							SET @precioSimptosPC = 0
							SET @importeSimptosPC = 0
							SET @montoSImptosPC = 0
							SET @idImptoPC = 0
							SET @cCambioPrecPC = 0
							SET @costoPC = 0
							SET @montoDesctoPC = 0
							SET @costoTotalPC = 0
							SET @idAlmacPC = 0
							SET @idNotaPC = 0
							SET @tipoPC = 0
							SET @tipoProPC = 0
							SET @esSubPC = 0
							SET @cantDevPC = 0
							SET @porFacturarPC = 0
							SET @idRemPC = 0
							SET @idRemPartPC = 0
							SET @idMdaPC = 0
							SET @tcPC = 0
							SET @operPC = 0
							SET @idComSerLotPC = 0
							SET @diasEntPC = 0
							SET @fecPromPC = '19000101'
							SET @fecEmbPC = '19000101'
							SET @fecReqPC = '19000101'
							SET @idPrgEntFacDetPC = 0
							SET @cantSurtPC = 0
							SET @porSolicPC = 0
							SET @idPartPadPC = 0
							SET @idProOrdPC = 0
							SET @cantOrdProPC = 0
							SET @idProLisPC = 0
							SET @idLisPrePC = 0
							SET @cPrecModifPC = 0
							SET @idKardexPC = 0
							SET @idCodSrvPC = 0
							SET @idCenCtoPC = 0
							SET @idRefPC = 0
							SET @idUdmPC = 0
							SET @ftrPC = 0
							SET @idPedPC = 0
							SET @idPedPartPC = 0
							SET @numPedPC = 0
							SET @idCotPC = 0
							SET @idCotPartPC = 0
							SET @numCotPC = 0
							SET @idSptPC = 0
							SET @idSptPartPC = 0
							SET @numSptPC = 0
							SET @idPadPC = 0
							SET @idTipDocPadPC = 0
							SET @numPadPC = 0
							SET @numPedCliPC = ''
							SET @numReqCliPC = ''
							SET @idClasProPC = 0
							SET @idRelImptoPC = 0
							SET @numRemPC = 0
							SET @operacionPC = 0
							SET @idTipDocPC = 0
							SET @numDocPC = 0
							SET @idUsrPC = 0
							SET @idKitPC = 0
							SET @cantKitsPC = 0
							SET @statusPC = 0
							SET @numDocCnlPC = 0
							SET @idSisCnlPC = 0
							SET @idNotaCnlPC = 0
							SET @fecAplCnlPC = '19000101'
							SET @idActPC = 0
							SET @idClasActPC = 0
							SET @valorBasePC = 0
							SET @depAcuPC = 0
							SET @depRemPC = 0
							SET @campo1PC = 0
							SET @campo2PC = 0
							SET @campo3PC = 0
							SET @campo4PC = 0
							SET @campo5PC = ''
							SET @campo6PC = ''
							SET @campo7PC = ''
							SET @campo8PC = ''
							SET @campo9PC = ''
							SET @campo10PC = '19000101'
							SET @cPrgPC = 0
							SET @idProPaqPC = 0
							SET @idPartOriPC = 0
							SET @secPC = 0
							SET @idIntPC = 0
							SET @idCliCtaDePC = 0
							SET @idRefDetPC = 0
							SET @ptgKitPC = 0
							SET @idCptPC = 0
							SET @cmtPC = ''
							SET @RefExtPC = ''
							SET @baseGravPC = 0
							SET @tipHonPC = 0
							SET @ptgHonPC = 0
							SET @modImptoPC = 0
							SET @precioExtPC = 0
							SET @Campo11PC = 0
							SET @Campo12PC = 0
							SET @Campo13PC = 0
							SET @Campo14PC = 0
							SET @Campo15PC = 0
							SET @Campo16PC = 0
							SET @Campo17PC = 0
							SET @Campo18PC = 0
							SET @Campo19PC = 0
							SET @Campo20PC = 0
							SET @Campo21PC = 0
							SET @Campo22PC = 0
							SET @Campo23PC = 0
							SET @Campo24PC = 0
							SET @Campo25PC = 0
							SET @Campo26PC = '19000101'
							SET @Campo27PC = '19000101'
							SET @Campo28PC = '19000101'
							SET @Campo29PC = '19000101'
							SET @Campo30PC = ''
							SET @Campo31PC = ''
							SET @Campo32PC = ''
							SET @Campo33PC = ''
							SET @Campo34PC = ''
							SET @Campo35PC = ''
							SET @Campo36PC = ''
							SET @Campo37PC = ''
							SET @Campo38PC = ''
							SET @Campo39PC = ''
							SET @Campo40PC = ''
							SET @IdNota2PC = 0
							SET @IdNota3PC = 0
							SET @tipComPC = 0
							SET @ptgComPC = 0
							SET @mtoComPC = 0
							SET @idSisLisPrePC = 0
							SET @idTarHonPC = 0
							SET @desTarHonPC = ''
							SET @idFisRelPC = 0
							SET @idOpeExtPC = 0
							SET @AfeInvKardexPC = 1
							SET @idPartAlmSirPC = 0
							SET @diasAlmSirPC = 0
							SET @diasLibAlmSirPC = 0
							SET @diasDctoAlmSirPC = 0
							SET @fecCorteAlmSirPC = '19000101'
							SET @idAlmjeGralPC = 0
							SET @idAlmjeEspPC = 0
							SET @desHonPC = ''
							SET @desPC = ''
							SET @cAfeExisVtaPC = 1
							SET @idComPC = 0
							SET @numGrpPC = 0
							SET @cantSurtAutPC = 0
							SET @apartadoPC = 0
							SET @backorderPC = 0
							SET @fecPedCliPC = '19000101'
							SET @aumPtgPC = 0
							SET @cantTraspPC = 0
							SET @idTurReqPC = 0
							SET @idTurPromPC = 0
							SET @idMovPartPC = 0
							SET @noPartPadPC = 0
							SET @idFacDetKitPC = 0
							SET @cPtgIngPC = 0
							SET @ptgIngPC = 0
							SET @idProvTerPC = 0
							SET @rfcProvPC = ''
							SET @nomProvPC = ''
							SET @calleProvPC = ''
							SET @numExtProvPC = ''
							SET @numIntProvPC = ''
							SET @colProvPC = ''
							SET @locProvPC = ''
							SET @refProvPC = ''
							SET @munProvPC = ''
							SET @edoProvPC = ''
							SET @paisProvPC = ''
							SET @cpProvPC = ''
							SET @numAduPC = ''
							SET @fecAduPC = '19000101'
							SET @aduanaPC = ''
							SET @ctaPredNumPC = ''
							SET @idRelGasPC = 0
							SET @cProvGasCorPC = 0
							SET @mtoDesctoCouponPC = 0
							SET @mtoDesctoVoucherPC = 0
							SET @mtoIngresosConfirmadoPC = 0
							SET @mtoIngresosFuturosPC = 0
							SET @mtoOtrosIngresosPC = 0
							SET @contPartidas = 1
						END
						
						DECLARE PartidasSp CURSOR LOCAL FAST_FORWARD FOR
							SELECT
								tps.id_fac_det, tps.id_doc_vta, tps.sub, tps.imptos, tps.total, tps.id_suc, tps.no_part, tps.id_pro, tps.udm, tps.cant, tps.precio_orig, tps.promoc, tps.precio_pub, tps.dcto_ptg, tps.precio_cimptos, tps.importe_cimptos, tps.precio_pub_simptos, tps.precio_simptos, tps.importe_simptos, tps.montos_imptos, tps.id_impto, tps.c_cambio_prec, tps.costo, tps.monto_descto, tps.costo_total, tps.id_almac, tps.id_nota, tps.tipo, tps.tipo_pro, tps.es_sub, tps.cant_dev, tps.por_facturar, tps.id_rem, tps.id_rem_part, tps.id_mda, tps.tc, tps.oper, tps.id_com_ser_lot, tps.dias_ent, tps.fec_prom, tps.fec_emb, tps.fec_req, tps.id_prg_ent_fac_det, tps.cant_surt, tps.por_solic, tps.id_part_pad, tps.id_pro_ord, tps.cant_ord_pro, tps.id_pro_lis, tps.id_lis_pre, tps.c_prec_modif, tps.id_kardex, tps.id_cod_srv, tps.id_cen_cto, tps.id_ref, tps.id_udm, tps.ftr, tps.id_ped, tps.id_ped_part, tps.num_ped, tps.id_cot, tps.id_cot_part, tps.num_cot, tps.id_spt, tps.id_spt_part, tps.num_spt, tps.id_pad, tps.id_tip_doc_pad, tps.num_pad, tps.num_ped_cli, tps.num_req_cli, tps.id_clas_pro, tps.id_rel_impto, tps.num_rem, tps.operacion, tps.id_tip_doc, tps.num_doc, tps.id_usr, tps.id_kit, tps.cant_kits, tps.[status], tps.num_doc_cnl, tps.id_sis_cnl, tps.id_nota_cnl, tps.fec_apl_cnl, tps.id_act, tps.id_clas_act, tps.valor_base, tps.dep_acu, tps.dep_rem, tps.campo1, tps.campo2, tps.campo3, tps.campo4, tps.campo5, tps.campo6, tps.campo7, tps.campo8, tps.campo9, tps.campo10, tps.c_prg, tps.id_pro_paq, tps.id_part_ori, tps.sec, tps.id_int, tps.id_cli_cta_de, tps.id_ref_det, tps.ptg_kit, tps.id_cpt, tps.cmt, tps.Ref_ext, tps.base_grav, tps.tip_hon, tps.ptg_hon, tps.mod_impto, tps.precio_ext, tps.Campo11, tps.Campo12, tps.Campo13, tps.Campo14, tps.Campo15, tps.Campo16, tps.Campo17, tps.Campo18, tps.Campo19, tps.Campo20, tps.Campo21, tps.Campo22, tps.Campo23, tps.Campo24, tps.Campo25, tps.Campo26, tps.Campo27, tps.Campo28, tps.Campo29, tps.Campo30, tps.Campo31, tps.Campo32, tps.Campo33, tps.Campo34, tps.Campo35, tps.Campo36, tps.Campo37, tps.Campo38, tps.Campo39, tps.Campo40, tps.Id_Nota2, tps.Id_Nota3, tps.tip_com, tps.ptg_com, tps.mto_com, tps.id_sis_lis_pre, tps.id_tar_hon, tps.des_tar_hon, tps.id_fis_rel, tps.id_ope_ext, tps.Afe_inv_kardex, tps.id_part_alm_sir, tps.dias_alm_sir, tps.dias_lib_alm_sir, tps.dias_dcto_alm_sir, tps.fec_corte_alm_sir, tps.id_almje_gral, tps.id_almje_esp, tps.des_hon, tps.[des], tps.c_afe_exis_vta, tps.id_com, tps.num_grp, tps.cant_surt_aut, tps.apartado, tps.backorder, tps.fec_ped_cli, tps.aum_ptg, tps.cant_trasp, tps.id_tur_req, tps.id_tur_prom, tps.id_mov_part, tps.no_part_pad, tps.id_fac_det_kit, tps.c_ptg_ing, tps.ptg_ing, tps.id_prov_ter, tps.rfc_prov, tps.nom_prov, tps.calle_prov, tps.num_ext_prov, tps.num_int_prov, tps.col_prov, tps.loc_prov, tps.ref_prov, tps.mun_prov, tps.edo_prov, tps.pais_prov, tps.cp_prov, tps.num_adu, tps.fec_adu, tps.aduana, tps.cta_pred_num, tps.id_rel_gas, tps.c_prov_gas_cor, tps.mtoDesctoCoupon, tps.mtoDesctoVoucher, tps.mtoIngresosConfirmado, tps.mtoIngresosFuturos, tps.mtoOtrosIngresos
							FROM @TblPartsSp AS tps
						
						OPEN PartidasSp

						FETCH NEXT FROM PartidasSp
						INTO @idFacDetPC, @idDocVtaPC, @subPC, @imptosPC, @totalPC, @idSucPC, @noPartPC, @idProPC, @udmPC, @cantPC, @precioOrigPC, @promocPC, @precioPubPC, @dctoPtgPC, @precioCimptosPC, @importeCimptosPC, @precioPubSimptosPC, @precioSimptosPC, @importeSimptosPC, @montoSImptosPC, @idImptoPC, @cCambioPrecPC, @costoPC, @montoDesctoPC, @costoTotalPC, @idAlmacPC, @idNotaPC, @tipoPC, @tipoProPC, @esSubPC, @cantDevPC, @porFacturarPC, @idRemPC, @idRemPartPC, @idMdaPC, @tcPC, @operPC, @idComSerLotPC, @diasEntPC, @fecPromPC, @fecEmbPC, @fecReqPC, @idPrgEntFacDetPC, @cantSurtPC, @porSolicPC, @idPartPadPC, @idProOrdPC, @cantOrdProPC, @idProLisPC, @idLisPrePC, @cPrecModifPC, @idKardexPC, @idCodSrvPC, @idCenCtoPC, @idRefPC, @idUdmPC, @ftrPC, @idPedPC, @idPedPartPC, @numPedPC, @idCotPC, @idCotPartPC, @numCotPC, @idSptPC, @idSptPartPC, @numSptPC, @idPadPC, @idTipDocPadPC, @numPadPC, @numPedCliPC, @numReqCliPC, @idClasProPC, @idRelImptoPC, @numRemPC, @operacionPC, @idTipDocPC, @numDocPC, @idUsrPC, @idKitPC, @cantKitsPC, @statusPC, @numDocCnlPC, @idSisCnlPC, @idNotaCnlPC, @fecAplCnlPC, @idActPC, @idClasActPC, @valorBasePC, @depAcuPC, @depRemPC, @campo1PC, @campo2PC, @campo3PC, @campo4PC, @campo5PC, @campo6PC, @campo7PC, @campo8PC, @campo9PC, @campo10PC, @cPrgPC, @idProPaqPC, @idPartOriPC, @secPC, @idIntPC, @idCliCtaDePC, @idRefDetPC, @ptgKitPC, @idCptPC, @cmtPC, @RefExtPC, @baseGravPC, @tipHonPC, @ptgHonPC, @modImptoPC, @precioExtPC, @Campo11PC, @Campo12PC, @Campo13PC, @Campo14PC, @Campo15PC, @Campo16PC, @Campo17PC, @Campo18PC, @Campo19PC, @Campo20PC, @Campo21PC, @Campo22PC, @Campo23PC, @Campo24PC, @Campo25PC, @Campo26PC, @Campo27PC, @Campo28PC, @Campo29PC, @Campo30PC, @Campo31PC, @Campo32PC, @Campo33PC, @Campo34PC, @Campo35PC, @Campo36PC, @Campo37PC, @Campo38PC, @Campo39PC, @Campo40PC, @IdNota2PC, @IdNota3PC, @tipComPC, @ptgComPC, @mtoComPC, @idSisLisPrePC, @idTarHonPC, @desTarHonPC, @idFisRelPC, @idOpeExtPC, @AfeInvKardexPC, @idPartAlmSirPC, @diasAlmSirPC, @diasLibAlmSirPC, @diasDctoAlmSirPC, @fecCorteAlmSirPC, @idAlmjeGralPC, @idAlmjeEspPC, @desHonPC, @desPC, @cAfeExisVtaPC, @idComPC, @numGrpPC, @cantSurtAutPC, @apartadoPC, @backorderPC, @fecPedCliPC, @aumPtgPC, @cantTraspPC, @idTurReqPC, @idTurPromPC, @idMovPartPC, @noPartPadPC, @idFacDetKitPC, @cPtgIngPC, @ptgIngPC, @idProvTerPC, @rfcProvPC, @nomProvPC, @calleProvPC, @numExtProvPC, @numIntProvPC, @colProvPC, @locProvPC, @refProvPC, @munProvPC, @edoProvPC, @paisProvPC, @cpProvPC, @numAduPC, @fecAduPC, @aduanaPC, @ctaPredNumPC, @idRelGasPC, @cProvGasCorPC, @mtoDesctoCouponPC, @mtoDesctoVoucherPC, @mtoIngresosConfirmadoPC, @mtoIngresosFuturosPC, @mtoOtrosIngresosPC
						
						WHILE @@FETCH_STATUS = 0
						BEGIN
							--Limpieza de variables
							BEGIN
								SET @idFacDet = 0
							END
							
							--Obtención de identities
							BEGIN
							    EXEC dbo.sp_obtIdvtafacdet @id = @idFacDet OUTPUT
								
								EXEC dbo.sp_ObtIdRelImpto @id = @idRelImptoSP OUTPUT
							END
							
							--Ahora aquí vamos a hacer una decisión, si el producto es inventariable, lo vamos a enviar al procedure, en caso contrario vamos a hacer la inserción directa
							/*IF @cAfeExisVtaPC = 1
							BEGIN*/
								EXEC dbo.sp_vta_fac_det_dir @id_fac_det = @idFacDet,
									@id_fac = @idFac,
									@id_doc_vta = @idDocVtaPC,
									@sub = @subPC,
									@imptos = @imptosPC,
									@total = @totalPC,
									@id_suc = @idSucPC,
									@no_part = @noPartPC,
									@id_pro = @idProPC,
									@udm = @udmPC,
									@cant = @cantPC,
									@precio_orig = @precioOrigPC,
									@promoc = @promocPC,
									@precio_pub = @precioPubPC,
									@dcto_ptg = @dctoPtgPC,
									@precio_cimptos = @precioCimptosPC,
									@importe_cimptos = @importeCimptosPC,
									@precio_pub_simptos = @precioPubSimptosPC,
									@precio_simptos = @precioSimptosPC,
									@importe_simptos = @importeSimptosPC,
									@montoS_imptos = @montoSImptosPC,
									@id_impto = @idImptoPC,
									@c_cambio_prec = @cCambioPrecPC,
									@costo = @costoPC,
									@monto_descto = @montoDesctoPC,
									@costo_total = @costoTotalPC,
									@id_almac = @idAlmacPC,
									@id_nota = @idNotaPC,
									@tipo = @tipoPC,
									@tipo_pro = @tipoProPC,
									@es_sub = @esSubPC,
									@cant_dev = @cantDevPC,
									@por_facturar = @porFacturarPC,
									@id_rem = @idRemPC,
									@id_rem_part = @idRemPartPC,
									@id_mda = @idMdaPC,
									@tc = @tcPC,
									@oper = @operPC,
									@id_com_ser_lot = @idComSerLotPC,
									@dias_ent = @diasEntPC,
									@fec_prom = @fecPromPC,
									@fec_emb = @fecEmbPC,
									@fec_req = @fecReqPC,
									@id_prg_ent_fac_det = @idPrgEntFacDetPC,
									@cant_surt = @cantSurtPC,
									@por_solic = @porSolicPC,
									@id_part_pad = @idPartPadPC,
									@id_pro_ord = @idProOrdPC,
									@cant_ord_pro = @cantOrdProPC,
									@id_pro_lis = @idProLisPC,
									@id_lis_pre = @idLisPrePC,
									@c_prec_modif = @cPrecModifPC,
									@id_kardex = @idKardexPC,
									@id_cod_srv = @idCodSrvPC,
									@id_cen_cto = @idCenCtoPC,
									@id_ref = @idRefPC, /*Pendiente*/
									@id_udm = @idUdmPC,
									@ftr = @ftrPC,
									@id_ped = @idPedPC,
									@id_ped_part = @idPedPartPC,
									@num_ped = @numPedPC,
									@id_cot = @idCotPC,
									@id_cot_part = @idCotPartPC,
									@num_cot = @numCotPC,
									@id_spt = @idSptPC,
									@id_spt_part = @idSptPartPC,
									@num_spt = @numSptPC,
									@id_pad = @idPadPC,
									@id_tip_doc_pad = @idTipDocPadPC,
									@num_pad = @numPadPC,
									@num_ped_cli = @numPedCliPC,
									@num_req_cli = @numReqCliPC,
									@id_clas_pro = @idClasProPC,
									@id_rel_impto = @idRelImptoSP,
									@num_rem = @numRemPC,
									@operacion = @operacionPC,
									@id_tip_doc = @idTipDocPC,
									@num_doc = @numDocPC,
									@id_usr = @idUsrPC,
									@id_kit = @idKitPC,
									@cant_kits = @cantKitsPC,
									@status = @statusPC,
									@num_doc_cnl = @numDocCnlPC,
									@id_sis_cnl = @idSisCnlPC,
									@id_nota_cnl = @idNotaCnlPC,
									@fec_apl_cnl = @fecAplCnlPC,
									@id_act = @idActPC,
									@id_clas_act = @idClasActPC,
									@valor_base = @valorBasePC,
									@dep_acu = @depAcuPC,
									@dep_rem = @depRemPC,
									@campo1 = @campo1PC,
									@campo2 = @campo2PC,
									@campo3 = @campo3PC,
									@campo4 = @campo4PC,
									@campo5 = @campo5PC,
									@campo6 = @campo6PC,
									@campo7 = @campo7PC,
									@campo8 = @campo8PC,
									@campo9 = @campo9PC,
									@campo10 = @campo10PC,
									@c_prg = @cPrgPC,
									@id_pro_paq = @idProPaqPC,
									@id_part_ori = @idPartOriPC,
									@sec = @secPC,
									@id_int = @idIntPC,
									@id_cli_cta_de = @idCliCtaDePC,
									@id_ref_det = @idRefDetPC, /*Pendiente*/
									@ptg_kit = @ptgKitPC,
									@id_cpt = @idCptPC,
									@cmt = @cmtPC,
									@Ref_ext = @RefExtPC, /*Pendiente*/
									@base_grav = @baseGravPC,
									@tip_hon = @tipHonPC,
									@ptg_hon = @ptgHonPC,
									@mod_impto = @modImptoPC,
									@precio_ext = @precioExtPC,
									@Campo11 = @Campo11PC,
									@Campo12 = @Campo12PC,
									@Campo13 = @Campo13PC,
									@Campo14 = @Campo14PC,
									@Campo15 = @Campo15PC,
									@Campo16 = @Campo16PC,
									@Campo17 = @Campo17PC,
									@Campo18 = @Campo18PC,
									@Campo19 = @Campo19PC,
									@Campo20 = @Campo20PC,
									@Campo21 = @Campo21PC,
									@Campo22 = @Campo22PC,
									@Campo23 = @Campo23PC,
									@Campo24 = @Campo24PC,
									@Campo25 = @Campo25PC,
									@Campo26 = @Campo26PC,
									@Campo27 = @Campo27PC,
									@Campo28 = @Campo28PC,
									@Campo29 = @Campo29PC,
									@Campo30 = @Campo30PC,
									@Campo31 = @Campo31PC,
									@Campo32 = @Campo32PC,
									@Campo33 = @Campo33PC,
									@Campo34 = @Campo34PC,
									@Campo35 = @Campo35PC,
									@Campo36 = @Campo36PC,
									@Campo37 = @Campo37PC,
									@Campo38 = @Campo38PC,
									@Campo39 = @Campo39PC,
									@Campo40 = @Campo40PC,
									@Id_Nota2 = @IdNota2PC,
									@Id_Nota3 = @IdNota3PC,
									@tip_com = @tipComPC, /*Pendiente*/
									@ptg_com = @ptgComPC, /*Pendiente*/
									@mto_com = @mtoComPC, /*Pendiente*/
									@id_sis_lis_pre = @idSisLisPrePC,
									@id_tar_hon = @idTarHonPC,
									@des_tar_hon = @desTarHonPC,
									@id_fis_rel = @idFisRelPC,
									@id_ope_ext = @idOpeExtPC,
									@Afe_inv_kardex = @AfeInvKardexPC,
									@id_part_alm_sir = @idPartAlmSirPC,
									@dias_alm_sir = @diasAlmSirPC,
									@dias_lib_alm_sir = @diasLibAlmSirPC,
									@dias_dcto_alm_sir = @diasDctoAlmSirPC,
									@fec_corte_alm_sir = @fecCorteAlmSirPC,
									@id_almje_gral = @idAlmjeGralPC,
									@id_almje_esp = @idAlmjeEspPC,
									@des_hon = @desHonPC,
									@des = @desPC,
									@c_afe_exis_vta = @cAfeExisVtaPC,
									@id_com = @idComPC, /*Pendiente*/
									@num_grp = @numGrpPC,
									@cant_surt_aut = @cantSurtAutPC,
									@apartado = @apartadoPC,
									@backorder = @backorderPC,
									@fec_ped_cli = @fecPedCliPC,
									@aum_ptg = @aumPtgPC,
									@cant_trasp = @cantTraspPC,
									@id_tur_req = @idTurReqPC,
									@id_tur_prom = @idTurPromPC,
									@id_mov_part = @idMovPartPC,
									@no_part_pad = @noPartPadPC,
									@id_fac_det_kit = @idFacDetKitPC,
									@c_ptg_ing = @cPtgIngPC,
									@ptg_ing = @ptgIngPC,
									@id_prov_ter = @idProvTerPC,
									@rfc_prov = @rfcProvPC,
									@nom_prov = @nomProvPC,
									@calle_prov = @calleProvPC,
									@num_ext_prov = @numExtProvPC,
									@num_int_prov = @numIntProvPC,
									@col_prov = @colProvPC,
									@loc_prov = @locProvPC,
									@ref_prov = @refProvPC,
									@mun_prov = @munProvPC,
									@edo_prov = @edoProvPC,
									@pais_prov = @paisProvPC,
									@cp_prov = @cpProvPC,
									@num_adu = @numAduPC,
									@fec_adu = @fecAduPC,
									@aduana = @aduanaPC,
									@cta_pred_num = @ctaPredNumPC,
									@id_rel_gas = @idRelGasPC,
									@c_prov_gas_cor = @cProvGasCorPC,
									@mtoDesctoCoupon = @mtoDesctoCouponPC,
									@mtoDesctoVoucher = @mtoDesctoVoucherPC,
									@mtoIngresosConfirmado = @mtoIngresosConfirmadoPC,
									@mtoIngresosFuturos = @mtoIngresosFuturosPC,
									@mtoOtrosIngresos = @mtoOtrosIngresosPC
							/*END
							ELSE
                            BEGIN
								INSERT INTO dbo.vta_fac_det ( id_fac_det, id_fac, id_doc_vta, sub, imptos, total, id_suc, no_part, id_pro, udm, cant, precio_orig, promoc, precio_pub, dcto_ptg, precio_cimptos, importe_cimptos, precio_pub_simptos, precio_simptos, importe_simptos, montos_imptos, id_impto, c_cambio_prec, costo, monto_descto, costo_total, id_almac, id_nota, tipo, tipo_pro, es_sub, cant_dev, por_facturar, id_rem, id_rem_part, id_fac_det_kit, id_mda, tc, oper, sub_bse, imptos_bse, total_bse, precio_orig_bse, precio_pub_bse, precio_cimptos_bse, importe_cimptos_bse, precio_pub_simptos_bse, precio_simptos_bse, importe_simptos_bse, monto_imptos_bse, monto_descto_bse, id_com_ser_lot, dias_ent, fec_prom, fec_emb, fec_req, id_prg_ent_fac_det, cant_surt, por_solic, id_part_pad, id_pro_ord, cant_ord_pro, id_pro_lis, id_lis_pre, c_prec_modif, id_kardex, id_cod_srv, id_cen_cto, id_ref, id_udm, ftr, id_ped, id_ped_part, num_ped, id_cot, id_cot_part, num_cot, id_spt, id_spt_part, num_spt, id_pad, id_tip_doc_pad, num_pad, num_ped_cli, num_req_cli, id_clas_pro, id_rel_impto, num_rem, id_act, id_clas_act, valor_base, dep_acu, dep_rem, campo1, campo2, campo3, campo4, campo5, campo6, campo7, campo8, campo9, campo10, c_prg, id_pro_paq, id_part_ori, sec, id_int, id_cli_cta_de, id_ref_det, ptg_kit, ref_ext, base_grav, tip_hon, ptg_hon, mod_impto, precio_ext, Campo11, Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18, Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25, Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32, Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39, Campo40, id_Nota2, id_Nota3, tip_com, ptg_com, mto_com, id_sis_lis_pre, id_tar_hon, des_tar_hon, id_fis_rel, id_ope_ext, id_part_alm_sir, dias_alm_sir, dias_lib_alm_sir, dias_dcto_alm_sir, fec_corte_alm_sir, id_almje_gral, id_almje_esp, cmt, des_hon, [des], c_afe_exis_vta, id_com, num_grp, cant_surt_aut, apartado, backorder, fec_ped_cli, aum_ptg, cant_trasp, partcerrpedcot, id_tur_req, id_tur_prom, id_mov_part, no_part_pad, c_ptg_ing, ptg_ing, id_prov_ter, id_rel_gas, c_prov_gas_cor, dcto_cupon, dcto_voucher, dcto_cupon_bse, dcto_voucher_bse, mto_confirmado, mto_futuro, mto_otros, mto_confirmado_bse, mto_futuro_bse, mto_otros_bse, id_motv_cnl )
								VALUES ( @idFacDet, @idFac, @idDocVtaPC, @subPC, @imptosPC, @totalPC, @idSucPC, @noPartPC, @idProPC, @udmPC, @cantPC, @precioOrigPC, @promocPC, @precioPubPC, @dctoPtgPC, @precioCimptosPC, @importeCimptosPC, @precioPubSimptosPC, @precioSimptosPC, @importeSimptosPC, @montoSImptosPC, @idImptoPC, @cCambioPrecPC, @costoPC, @montoDesctoPC, @costoTotalPC, @idAlmacPC, @idNotaPC, @tipoPC, @tipoProPC, @esSubPC, @cantDevPC, @porFacturarPC, @idRemPC, @idRemPartPC, @idFacDetKitPC, @idMdaPC, @tcPC, @operPC, @idComSerLotPC, @diasEntPC, @fecPromPC, @fecEmbPC, @fecReqPC, @idPrgEntFacDetPC, @cantSurtPC, @porSolicPC, @idPartPadPC, @idProOrdPC, @cantOrdProPC, @idProLisPC, @idLisPrePC, @cPrecModifPC, @idKardexPC, @idCodSrvPC, @idCenCtoPC, @idRefPC, @idUdmPC, @ftrPC, @idPedPC, @idPedPartPC, @numPedPC, @idCotPC, @idCotPartPC, @numCotPC, @idSptPC, @idSptPartPC, @numSptPC, @idPadPC, @idTipDocPadPC, @numPadPC, @numPedCliPC, @numReqCliPC, @idClasProPC, @idRelImptoSP, @numRemPC, @operacionPC, @idTipDocPC, @numDocPC, @idUsrPC, @idKitPC, @cantKitsPC, @statusPC, @numDocCnlPC, @idSisCnlPC, @idNotaCnlPC, @fecAplCnlPC, @idActPC, @idClasActPC, @valorBasePC, @depAcuPC, @depRemPC, @campo1PC, @campo2PC, @campo3PC, @campo4PC, @campo5PC, @campo6PC, @campo7PC, @campo8PC, @campo9PC, @campo10PC, @cPrgPC, @idProPaqPC, @idPartOriPC, @secPC, @idIntPC, @idCliCtaDePC, @idRefDetPC, @ptgKitPC, @idCptPC, @cmtPC, @RefExtPC, @baseGravPC, @tipHonPC, @ptgHonPC, @modImptoPC, @precioExtPC, @Campo11PC, @Campo12PC, @Campo13PC, @Campo14PC, @Campo15PC, @Campo16PC, @Campo17PC, @Campo18PC, @Campo19PC, @Campo20PC, @Campo21PC, @Campo22PC, @Campo23PC, @Campo24PC, @Campo25PC, @Campo26PC, @Campo27PC, @Campo28PC, @Campo29PC, @Campo30PC, @Campo31PC, @Campo32PC, @Campo33PC, @Campo34PC, @Campo35PC, @Campo36PC, @Campo37PC, @Campo38PC, @Campo39PC, @Campo40PC, @IdNota2PC, @IdNota3PC, @tipComPC, @ptgComPC, @mtoComPC, @idSisLisPrePC, @idTarHonPC, @desTarHonPC, @idFisRelPC, @idOpeExtPC, @AfeInvKardexPC, @idPartAlmSirPC, @diasAlmSirPC, @diasLibAlmSirPC, @diasDctoAlmSirPC, @fecCorteAlmSirPC, @idAlmjeGralPC, @idAlmjeEspPC, @desHonPC, @desPC, @cAfeExisVtaPC, @idComPC, @numGrpPC, @cantSurtAutPC, @apartadoPC, @backorderPC, @fecPedCliPC, @aumPtgPC, @cantTraspPC, @idTurReqPC, @idTurPromPC, @idMovPartPC, @noPartPadPC, @cPtgIngPC, @ptgIngPC, @idProvTerPC, @rfcProvPC, @nomProvPC, @calleProvPC, @numExtProvPC, @numIntProvPC, @colProvPC, @locProvPC, @refProvPC, @munProvPC, @edoProvPC, @paisProvPC, @cpProvPC, @numAduPC, @fecAduPC, @aduanaPC, @ctaPredNumPC, @idRelGasPC, @cProvGasCorPC, @mtoDesctoCouponPC, @mtoDesctoVoucherPC, @mtoIngresosConfirmadoPC, @mtoIngresosFuturosPC, @mtoOtrosIngresosPC )
                            END
							*/
							--Inserción de los impuestos
							BEGIN
							    --Limpiamos todas las variables a usar en el cursor
								BEGIN
								    SET @idFacDetCI = 0
									SET @idSisImpCI = 0
									SET @idRelImpCI = 0
									SET @idTipDocCI = 0
									SET @idDocCI = 0
									SET @idDocPartCI = 0
									SET @numDocCI = 0
									SET @fecDocCI = '19000101'
									SET @idCliCI = 0
									SET @idProvCI = 0
									SET @idImptoCI = 0
									SET @idCodImpCI = 0
									SET @desCI = ''
									SET @tasaCI = 0
									SET @cIvaCI = 0
									SET @cRetCI = 0
									SET @cExeCI = 0
									SET @mtoBaseCI = 0
									SET @mtoImpCI = 0
									SET @idMdaCI = 0
									SET @operCI = 0
									SET @tcCI = 0
									SET @mtoBaseBseCI = 0
									SET @mtoImpBseCI = 0
									SET @idCtaCI = 0
									SET @idUsrCI = 0
									SET @fecRegCI = '19000101'
									SET @statusCI = 0
									SET @cAfeCtbCI = 0
									SET @dctoGlbCI = 0
									SET @mtoImpSDctoCI = 0
									SET @mtoBaseSDctoCI = 0
									SET @idRelImpDocCI = 0
									SET @cModImptosCI = 0
									SET @ivaAplCI = 0
									SET @ivaSdoCI = 0
									SET @mtoPagRetCI = 0
									SET @mtoAcrRetCI = 0
									SET @fecPgoCI = '19000101'
									SET @idBcoAuxCI = 0
									SET @idCliFaCI = 0
									SET @noFactCI = ''
									SET @cRecIvaCI = 0
									SET @idFisRelCI = 0
									SET @idCenCtoCI = 0
									SET @idRefCI = 0
									SET @idCodSrvCI = 0
									SET @idProCI = 0
									SET @idAlmCI = 0
									SET @idEntCI = 0
									SET @impCTipCI = 0
									SET @impCDesCI = ''
									SET @impCTasaCI = 0
									SET @impCFtrCI = 0
									SET @impCCantCI = 0
									SET @impCUDCCI = 0
									SET @impCMtoCI = 0
									SET @ptgAcuComCI = 0
								END
								
								--Creamos el cursor por los impuestos
								DECLARE Impuestos CURSOR FOR
									SELECT
										ti.id_fac_det, ti.id_sis_imp, ti.id_rel_imp, ti.id_tip_doc, ti.id_doc, ti.id_doc_part, ti.num_doc, ti.fec_doc, ti.id_cli, ti.id_prov, ti.id_impto, ti.id_cod_imp, ti.[des], ti.tasa, ti.c_iva, ti.c_ret, ti.c_exe, ti.mto_base, ti.mto_imp, ti.id_mda, ti.oper, ti.tc, ti.mto_base_bse, ti.mto_imp_bse, ti.id_cta, ti.id_usr, ti.fec_reg, ti.[status], ti.c_afe_ctb, ti.dcto_glb, ti.mto_imp_s_dcto, ti.mto_base_s_dcto, ti.id_rel_imp_doc, ti.c_mod_imptos, ti.iva_apl, ti.iva_sdo, ti.mto_pag_ret, ti.mto_acr_ret, ti.fec_pgo, ti.id_bco_aux, ti.id_cli_fa, ti.no_fact, ti.c_rec_iva, ti.id_fis_rel, ti.id_cen_cto, ti.id_ref, ti.id_cod_srv, ti.id_pro, ti.id_alm, ti.id_ent, ti.impC_tip, ti.impC_des, ti.impC_tasa, ti.impC_ftr, ti.impC_cant, ti.impC_UDC, ti.impC_mto, ti.ptg_acu_com
									FROM @TblImptos AS ti
									WHERE ti.id_fac_det = @idFacDetPC
								
								OPEN Impuestos

								FETCH NEXT FROM Impuestos
								INTO @idFacDetCI, @idSisImpCI, @idRelImpCI, @idTipDocCI, @idDocCI, @idDocPartCI, @numDocCI, @fecDocCI, @idCliCI, @idProvCI, @idImptoCI, @idCodImpCI, @desCI, @tasaCI, @cIvaCI, @cRetCI, @cExeCI, @mtoBaseCI, @mtoImpCI, @idMdaCI, @operCI, @tcCI, @mtoBaseBseCI, @mtoImpBseCI, @idCtaCI, @idUsrCI, @fecRegCI, @statusCI, @cAfeCtbCI, @dctoGlbCI, @mtoImpSDctoCI, @mtoBaseSDctoCI, @idRelImpDocCI, @cModImptosCI, @ivaAplCI, @ivaSdoCI, @mtoPagRetCI, @mtoAcrRetCI, @fecPgoCI, @idBcoAuxCI, @idCliFaCI, @noFactCI, @cRecIvaCI, @idFisRelCI, @idCenCtoCI, @idRefCI, @idCodSrvCI, @idProCI, @idAlmCI, @idEntCI, @impCTipCI, @impCDesCI, @impCTasaCI, @impCFtrCI, @impCCantCI, @impCUDCCI, @impCMtoCI, @ptgAcuComCI

								WHILE @@FETCH_STATUS = 0
								BEGIN
									--Limpieza de variables
									BEGIN
									    SET @idSisImpSP = 0
									END
									
									--Obtención de identities
									BEGIN
									    EXEC dbo.sp_obtIdsisimptos @id = @idSisImpSP OUTPUT 
									END
									
									INSERT INTO dbo.sis_imptos ( id_sis_imp, id_rel_imp, id_tip_doc, id_doc, id_doc_part, num_doc, fec_doc, id_cli, id_prov, id_impto, id_cod_imp, [des], tasa, c_iva, c_ret, c_exe, mto_base, mto_imp, id_mda, oper, tc, mto_base_bse, mto_imp_bse, id_cta, id_usr, fec_reg, [status], c_afe_ctb, dcto_glb, mto_imp_s_dcto, mto_base_s_dcto, id_rel_imp_doc, c_mod_imptos, iva_apl, iva_sdo, mto_pag_ret, mto_acr_ret, fec_pgo, id_bco_aux, id_cli_fa, no_fact, c_rec_iva, id_fis_rel, id_cen_cto, id_ref, id_cod_srv, id_pro, id_alm, id_ent, impC_tip, impC_des, impC_tasa, impC_ftr, impC_cant, impC_UDC, impC_mto, ptg_acu_com )
									VALUES ( @idSisImpSP, @idRelImptoSP, @idTipDocImp, @idFac, @idFacDet, @numDocCI, @fecDocCI, @idCliCI, @idProvCI, @idImptoCI, @idCodImpCI, @desCI, @tasaCI, @cIvaCI, @cRetCI, @cExeCI, @mtoBaseCI, @mtoImpCI, @idMdaCI, @operCI, @tcCI, @mtoBaseBseCI, @mtoImpBseCI, @idCtaCI, @idUsrCI, @fecRegCI, @statusCI, @cAfeCtbCI, @dctoGlbCI, @mtoImpSDctoCI, @mtoBaseSDctoCI, @idRelImpDoc, @cModImptosCI, @ivaAplCI, @ivaSdoCI, @mtoPagRetCI, @mtoAcrRetCI, @fecPgoCI, @idBcoAuxCI, @idCliFaCI, @noFactCI, @cRecIvaCI, @idFisRelCI, @idCenCtoCI, @idRefCI, @idCodSrvCI, @idProCI, @idAlmCI, @idEntCI, @impCTipCI, @impCDesCI, @impCTasaCI, @impCFtrCI, @impCCantCI, @impCUDCCI, @impCMtoCI, @ptgAcuComCI )
									
								    FETCH NEXT FROM Impuestos
									INTO @idFacDetCI, @idSisImpCI, @idRelImpCI, @idTipDocCI, @idDocCI, @idDocPartCI, @numDocCI, @fecDocCI, @idCliCI, @idProvCI, @idImptoCI, @idCodImpCI, @desCI, @tasaCI, @cIvaCI, @cRetCI, @cExeCI, @mtoBaseCI, @mtoImpCI, @idMdaCI, @operCI, @tcCI, @mtoBaseBseCI, @mtoImpBseCI, @idCtaCI, @idUsrCI, @fecRegCI, @statusCI, @cAfeCtbCI, @dctoGlbCI, @mtoImpSDctoCI, @mtoBaseSDctoCI, @idRelImpDocCI, @cModImptosCI, @ivaAplCI, @ivaSdoCI, @mtoPagRetCI, @mtoAcrRetCI, @fecPgoCI, @idBcoAuxCI, @idCliFaCI, @noFactCI, @cRecIvaCI, @idFisRelCI, @idCenCtoCI, @idRefCI, @idCodSrvCI, @idProCI, @idAlmCI, @idEntCI, @impCTipCI, @impCDesCI, @impCTasaCI, @impCFtrCI, @impCCantCI, @impCUDCCI, @impCMtoCI, @ptgAcuComCI
								END

								CLOSE Impuestos
								DEALLOCATE Impuestos
							END
							
							SET @contPartidas = @contPartidas + 1

							FETCH NEXT FROM PartidasSp
							INTO @idFacDetPC, @idDocVtaPC, @subPC, @imptosPC, @totalPC, @idSucPC, @noPartPC, @idProPC, @udmPC, @cantPC, @precioOrigPC, @promocPC, @precioPubPC, @dctoPtgPC, @precioCimptosPC, @importeCimptosPC, @precioPubSimptosPC, @precioSimptosPC, @importeSimptosPC, @montoSImptosPC, @idImptoPC, @cCambioPrecPC, @costoPC, @montoDesctoPC, @costoTotalPC, @idAlmacPC, @idNotaPC, @tipoPC, @tipoProPC, @esSubPC, @cantDevPC, @porFacturarPC, @idRemPC, @idRemPartPC, @idMdaPC, @tcPC, @operPC, @idComSerLotPC, @diasEntPC, @fecPromPC, @fecEmbPC, @fecReqPC, @idPrgEntFacDetPC, @cantSurtPC, @porSolicPC, @idPartPadPC, @idProOrdPC, @cantOrdProPC, @idProLisPC, @idLisPrePC, @cPrecModifPC, @idKardexPC, @idCodSrvPC, @idCenCtoPC, @idRefPC, @idUdmPC, @ftrPC, @idPedPC, @idPedPartPC, @numPedPC, @idCotPC, @idCotPartPC, @numCotPC, @idSptPC, @idSptPartPC, @numSptPC, @idPadPC, @idTipDocPadPC, @numPadPC, @numPedCliPC, @numReqCliPC, @idClasProPC, @idRelImptoPC, @numRemPC, @operacionPC, @idTipDocPC, @numDocPC, @idUsrPC, @idKitPC, @cantKitsPC, @statusPC, @numDocCnlPC, @idSisCnlPC, @idNotaCnlPC, @fecAplCnlPC, @idActPC, @idClasActPC, @valorBasePC, @depAcuPC, @depRemPC, @campo1PC, @campo2PC, @campo3PC, @campo4PC, @campo5PC, @campo6PC, @campo7PC, @campo8PC, @campo9PC, @campo10PC, @cPrgPC, @idProPaqPC, @idPartOriPC, @secPC, @idIntPC, @idCliCtaDePC, @idRefDetPC, @ptgKitPC, @idCptPC, @cmtPC, @RefExtPC, @baseGravPC, @tipHonPC, @ptgHonPC, @modImptoPC, @precioExtPC, @Campo11PC, @Campo12PC, @Campo13PC, @Campo14PC, @Campo15PC, @Campo16PC, @Campo17PC, @Campo18PC, @Campo19PC, @Campo20PC, @Campo21PC, @Campo22PC, @Campo23PC, @Campo24PC, @Campo25PC, @Campo26PC, @Campo27PC, @Campo28PC, @Campo29PC, @Campo30PC, @Campo31PC, @Campo32PC, @Campo33PC, @Campo34PC, @Campo35PC, @Campo36PC, @Campo37PC, @Campo38PC, @Campo39PC, @Campo40PC, @IdNota2PC, @IdNota3PC, @tipComPC, @ptgComPC, @mtoComPC, @idSisLisPrePC, @idTarHonPC, @desTarHonPC, @idFisRelPC, @idOpeExtPC, @AfeInvKardexPC, @idPartAlmSirPC, @diasAlmSirPC, @diasLibAlmSirPC, @diasDctoAlmSirPC, @fecCorteAlmSirPC, @idAlmjeGralPC, @idAlmjeEspPC, @desHonPC, @desPC, @cAfeExisVtaPC, @idComPC, @numGrpPC, @cantSurtAutPC, @apartadoPC, @backorderPC, @fecPedCliPC, @aumPtgPC, @cantTraspPC, @idTurReqPC, @idTurPromPC, @idMovPartPC, @noPartPadPC, @idFacDetKitPC, @cPtgIngPC, @ptgIngPC, @idProvTerPC, @rfcProvPC, @nomProvPC, @calleProvPC, @numExtProvPC, @numIntProvPC, @colProvPC, @locProvPC, @refProvPC, @munProvPC, @edoProvPC, @paisProvPC, @cpProvPC, @numAduPC, @fecAduPC, @aduanaPC, @ctaPredNumPC, @idRelGasPC, @cProvGasCorPC, @mtoDesctoCouponPC, @mtoDesctoVoucherPC, @mtoIngresosConfirmadoPC, @mtoIngresosFuturosPC, @mtoOtrosIngresosPC
						END
						
						CLOSE PartidasSp
						DEALLOCATE PartidasSp
						SELECT tiempo = GETDATE(), mensaje = 'Termina de grabar partidas'
					END
				END
				/*--*/--SELECT tiempo = GETDATE(), mensaje = 'A punto de terminar'
				--Por último marcamos que la factura y sus partidas se procesaron de forma correcta
				UPDATE dbo.imp_vta_fac_enc SET status_imp = 1, cmt_imp = 'Factura importada' WHERE id_fac = @idFacImp
				UPDATE dbo.imp_vta_fac_det SET status_det_imp = 1, cmt_imp = 'Partida generada' WHERE id_fac = @idFacImp
				SELECT tiempo = GETDATE(), mensaje = 'Terminado'
				RAISERROR (N'No se graba por ser prueba', -- Message text.
					16, -- Severity,
					1) -- State

				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION

				UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = ERROR_MESSAGE() WHERE id_fac = @idFacImp
			END CATCH
        END TRY
		BEGIN CATCH
			UPDATE dbo.imp_vta_fac_enc SET status_imp = 2, cmt_imp = 'Error 1' WHERE id_fac = @idFacImp
		END CATCH

		Siguiente:
		
		FETCH NEXT FROM Documentos
		INTO @idFacImp, @serieImp, @numeroImp, @fechaImp, @idTipDocImp, @cmtImp, @notaImp, @diasImp, @fecVencImp, @fecRegSEImp, @fecEstCobImp, @fecRevImp, @cveClienteImp, @idOtrSisCliImp, @cveFaImp, @subImp, @imptosImp, @totalImp, @monedaImp, @tipCamImp, @cndPagImp, @mtdPagImp, @cveSucImp, @numPolImp
    END

	CLOSE Documentos
	DEALLOCATE Documentos
END
GO

