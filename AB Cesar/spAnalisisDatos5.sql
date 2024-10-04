USE [1G_WFS]
go

IF(object_id('spAnalisisDatos5') is not null)
BEGIN
	DROP PROC spAnalisisDatos5
	SELECT 'spAnalisisDatos5 BORRADO' AS info
END
GO

CREATE PROC spAnalisisDatos5    
    @pFechaI AS DATE,    
    @pFechaF AS DATE,    
    @UUID AS VARCHAR(50),    
    @archivo AS INT,    
    @consolidadoNumFac AS BIT,    
    @Filtro AS VARCHAR(3)    
AS    
BEGIN    
 DECLARE @RfcEmpresa as VARCHAR(13)=(SELECT TOP (1) REPLACE(rfc, '-', '') FROM dbo.cfg_empresa  WITH(NOLOCK))    
 DECLARE @FechaI AS DATE=@pFechaI     
 DECLARE @FechaF AS DATE=@pFechaF    
    
    DECLARE @Tabla TABLE    
    (    
        EstatusComprobante VARCHAR(MAX),    
        UUIDCobro VARCHAR(MAX),    
        UUIDRelacionado VARCHAR(MAX) NOT NULL,    
        FolioFacturaA INT,    
        NumeroOperacion VARCHAR(MAX) NOT NULL,    
        Serie VARCHAR(MAX) NOT NULL,    
        folio VARCHAR(MAX) NOT NULL,    
        Monto FLOAT NOT NULL,    
        SerieF VARCHAR(MAX) NOT NULL,    
        FolioF VARCHAR(MAX) NOT NULL,    
        FechaPago DATE NOT NULL,    
        FechaRegistro DATE NOT NULL,    
        FechaTimbrado DATE NOT NULL,    
        MonedaP VARCHAR(MAX) NOT NULL,    
        ImpPagado FLOAT NOT NULL    
    );    
    
    DECLARE @TFinal TABLE    
    (    
        EstatusComprobante VARCHAR(MAX),    
        NumeroPoliza VARCHAR(MAX),    
        TipoDocumento VARCHAR(MAX),    
        NumeroFactura VARCHAR(MAX),    
        ClaveCliente VARCHAR(MAX),    
        CuentaBanco VARCHAR(MAX),    
        NumeroCobro VARCHAR(MAX),    
        UUIDCobro VARCHAR(MAX),    
        UUID VARCHAR(MAX),    
        UUIDFactura VARCHAR(MAX),    
        FacturaXML VARCHAR(MAX),    
        Serie VARCHAR(MAX),    
        Seriex VARCHAR(MAX),    
        Folio VARCHAR(MAX),    
        Foliox VARCHAR(MAX),    
        SerieFactura VARCHAR(MAX),    
        SerieF VARCHAR(MAX),    
        FolioFactura VARCHAR(MAX),    
        FolioF VARCHAR(MAX),    
        MtoFac FLOAT,    
        ImpPagado FLOAT,    
        Moneda VARCHAR(MAX),    
        MonedaP VARCHAR(MAX),    
        MontoReqCFDI FLOAT,    
        Monto FLOAT,    
        FechaPagoxml DATE,    
        FechaPagoOracle DATE,    
        Num1 INT,    
        num2 INT,    
        fechaRegistroOracle DATE    
    );    
    
    DECLARE @Tabla2 TABLE    
    (    
        UUID VARCHAR(MAX),    
        UUIDFactura VARCHAR(MAX),    
        serie VARCHAR(MAX),    
        Folio VARCHAR(MAX),    
        SerieFactura VARCHAR(MAX),    
        FolioFactura VARCHAR(MAX),    
        ClaveCliente VARCHAR(MAX),    
        CuentaBanco VARCHAR(MAX),    
        Moneda VARCHAR(MAX),    
        NumeroPoliza VARCHAR(MAX),    
        TipoDocumento VARCHAR(MAX),    
        NumeroFactura VARCHAR(MAX),    
        MontoReqCFDI FLOAT,    
        NumeroCobro VARCHAR(MAX),    
        MtoFac FLOAT,    
        Estatus VARCHAR(MAX),    
        Mensaje VARCHAR(MAX),    
        fechaRegistro DATE    
    );    
    
    DECLARE @Tuui1 TABLE    
    (    
        uuid VARCHAR(50),    
        numero INT    
    );    
    DECLARE @Tuui2 TABLE    
    (    
        uuid VARCHAR(50),    
        numero INT    
    );    
    
    DECLARE @Final TABLE    
    (    
        EstatusComprobante VARCHAR(MAX),    
        NumeroPoliza VARCHAR(MAX),    
        TipoDocumento VARCHAR(MAX),    
        NumeroFactura VARCHAR(MAX),    
        ClaveCliente VARCHAR(MAX),    
        CuentaBanco VARCHAR(MAX),    
        NumeroCobro VARCHAR(MAX),    
        UUIDCobro VARCHAR(MAX),    
        UUID VARCHAR(MAX),    
        UUIDFactura VARCHAR(MAX),    
        FacturaXML VARCHAR(MAX),    
        Serie VARCHAR(MAX),    
        Seriex VARCHAR(MAX),    
        Folio VARCHAR(MAX),    
        Foliox VARCHAR(MAX),    
        SerieFactura VARCHAR(MAX),    
        SerieF VARCHAR(MAX),    
        FolioFactura VARCHAR(MAX),    
        FolioF VARCHAR(MAX),    
        MtoFac FLOAT,    
        ImpPagado FLOAT,    
        Moneda VARCHAR(MAX),    
        MonedaP VARCHAR(MAX),    
        MontoReqCFDI FLOAT,    
        Monto FLOAT,    
        FechaPagoxml DATE,    
        FechaPagoOracle DATE,    
        Num1 INT,    
        num2 INT,    
        fechaRegistroOracle DATE,    
        IGUuid INT,    
        IGUuiR INT,    
        IGSerie INT,    
        IGFolio INT,    
        IGSerieF INT,    
        IGFolioF INT,    
        IGImpPagado INT,    
        IGMonedaP INT,    
        IGMonto INT,    
        IGFecha INT,    
        IGNumFac INT    
  );    
    
    IF @Filtro = 'Ndc'    
    BEGIN    
        DECLARE @TUUID TABLE    
        (    
            UUID VARCHAR(50)    
        );    
    
        INSERT INTO @TUUID    
        SELECT DISTINCT    
               UUID    
        FROM dbo.tbl_ServicioCentinelaWFSCobros  WITH(NOLOCK)     
        WHERE FechaRegistro >= @pFechaI    
              AND FechaRegistro <= @pFechaF    
              AND MontoFactura < 0    
              AND IdArchivo = @archivo;    
/*!! TODO !! JCA:28/8/2024.10:11 Castear las fechas a tipo DATE y cambiar la condición por un BETWEEN  */    
    
        IF @consolidadoNumFac = 1    
        BEGIN    
            INSERT INTO @Tabla2    
            SELECT tbl.UUID,    
                   tbl.UUIDFactura,    
                   tbl.Serie,    
                   tbl.Folio,    
                   tbl.SerieFactura,    
                   tbl.FolioFactura,    
                   tbl.ClaveCliente,    
                   tbl.CuentaBanco,    
                   tbl.Moneda,    
                   "NumeroPoliza" = MAX(tbl.NumeroPoliza),    
                   tbl.TipoDocumento,    
                   tbl.NumeroFactura,    
                   tbl.MontoReqCFDI,    
                   tbl.NumeroCobro,    
                   "MtoFac" = SUM(CONVERT(FLOAT, tbl.MontoFactura)),    
                   tbl.Estatus,    
                   tbl.Mensaje,    
                   "fechaRegistro" = CONVERT(DATE, MAX(tbl.FechaRegistro))    
            FROM dbo.tbl_ServicioCentinelaWFSCobros tbl  WITH(NOLOCK)     
            WHERE tbl.IdArchivo = @archivo    
                AND EXISTS (SELECT 1 FROM @TUUID t WHERE t.UUID=tbl.UUID)    
            GROUP BY tbl.UUID,    
                     tbl.UUIDFactura,    
                     tbl.Serie,    
                     tbl.Folio,    
                     tbl.SerieFactura,    
                     tbl.FolioFactura,    
                     tbl.ClaveCliente,    
                     tbl.CuentaBanco,    
                     tbl.Moneda,    
                     tbl.TipoDocumento,    
                     tbl.NumeroFactura,    
                     tbl.MontoReqCFDI,    
                     tbl.NumeroCobro,    
                     tbl.Estatus,    
                     tbl.Mensaje;    
        END;    
        ELSE    
        BEGIN    
            INSERT INTO @Tabla2    
            SELECT tbl.UUID,    
                   tbl.UUIDFactura,    
                   tbl.Serie,    
                   tbl.Folio,    
                   tbl.SerieFactura,    
                   tbl.FolioFactura,    
                   tbl.ClaveCliente,    
                   tbl.CuentaBanco,    
                   tbl.Moneda,    
                   "NumeroPoliza" = tbl.NumeroPoliza,    
                   tbl.TipoDocumento,    
                   tbl.NumeroFactura,    
                   tbl.MontoReqCFDI,    
                   tbl.NumeroCobro,    
                   "MtoFac" = tbl.MontoFactura,    
                   tbl.Estatus,    
                   tbl.Mensaje,    
                   "fechaRegistro" = tbl.FechaRegistro    
            FROM dbo.tbl_ServicioCentinelaWFSCobros tbl    
            WHERE tbl.IdArchivo = @archivo    
                  AND EXISTS (SELECT 1     
          FROM @TUUID t     
          WHERE t.UUID=tbl.UUID)    
        END;    
    
        INSERT INTO @Tabla    
        SELECT a.ESTATUS_COMPROBANTE,    
               a.UUID,    
               K.value('./@IdDocumento', 'varchar(MAX)'),    
               K.value('./@Folio', 'INT'),    
               "NumeroOperacion" = I.value('./@NumOperacion', 'varchar(MAX)'),    
               "Serie" = Y.value('./@Serie', 'varchar(MAX)'),    
               "Folio" = Y.value('./@Folio', 'varchar(MAX)'),    
               "Monto" = I.value('./@Monto', 'varchar(MAX)'),    
               "SerieF" = K.value('./@Serie', 'varchar(MAX)'),    
               "FolioF" = K.value('./@Folio', 'varchar(MAX)'),    
               "FechaPago" = I.value('./@FechaPago', 'varchar(MAX)'),    
               a.fec_reg,    
               "FechaTimbrado" = W.value('./@FechaTimbrado', 'varchar(MAX)'),    
               "MonedaP" = I.value('./@MonedaP', 'varchar(MAX)'),    
               "ImpPagado" = K.value('./@ImpPagado', 'varchar(MAX)')    
        FROM dbo.sis_aud_cfdi a  WITH(NOLOCK)  
  INNER JOIN @TUUID tuuid  
   ON tuuid.UUID=a.UUID  
            OUTER APPLY a.XML_FILE.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";/cfdi:Comprobante') AS X(Y)    
            OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Receptor') AS S(R)    
            OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Complemento') AS L(B)    
            OUTER APPLY l.b.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pagos') AS T(U)    
            OUTER APPLY t.u.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pago') AS F(I)    
            OUTER APPLY f.i.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:DoctoRelacionado') AS Q(K)    
            OUTER APPLY l.b.nodes('declare namespace tfd = "http://www.sat.gob.mx/TimbreFiscalDigital";./tfd:TimbreFiscalDigital') AS C(W)    
        WHERE a.EFECTO_COMPROBANTE = 'P'    
              AND REPLACE(a.RFC_EMISOR, '-', '') = @RfcEmpresa    
                  
    
        INSERT INTO @Tuui1    
        SELECT UUIDCobro,    
               COUNT(UUIDCobro)    
        FROM @Tabla    
        WHERE UUIDCobro IN    
              (    
                  SELECT DISTINCT UUIDCobro FROM @Tabla    
              )    
        GROUP BY UUIDCobro;    
    
        INSERT INTO @Tuui2    
        SELECT UUID,    
               COUNT(UUID)    
        FROM @Tabla2    
        WHERE uuid IN    
              (    
                  SELECT DISTINCT UUID FROM @Tabla2    
              )    
        GROUP BY UUID;    
    
        INSERT INTO @TFinal    
        SELECT a.EstatusComprobante,    
               tbl.NumeroPoliza,    
               tbl.TipoDocumento,    
               "NumeroFactura" = '',    
               --tbl.NumeroFactura,     
               tbl.ClaveCliente,    
               tbl.CuentaBanco,    
               tbl.NumeroCobro,    
               a.UUIDCobro,    
               tbl.UUID,    
               tbl.UUIDFactura,    
               "FacturaXML" = ISNULL(a.UUIDRelacionado, '-'),    
               tbl.serie,    
               "Seriex" = a.Serie,    
               tbl.Folio,    
               "Foliox" = a.folio,    
               tbl.SerieFactura,    
               a.SerieF,    
               tbl.FolioFactura,    
               a.FolioF,    
               tbl.MtoFac,    
               a.ImpPagado,    
               tbl.Moneda,    
               a.MonedaP,    
               tbl.MontoReqCFDI,    
               a.Monto,    
               a.FechaPago,    
               tbl.fechaRegistro,    
               "NumFacOrac" = U2.numero,    
               "num2" = U1.numero,    
               tbl.fechaRegistro    
        FROM @Tabla a    
            INNER JOIN @Tuui1 AS U1    
                ON a.UUIDCobro = U1.uuid    
            FULL OUTER JOIN @Tabla2 tbl    
                ON a.UUIDCobro = tbl.UUID    
                   AND tbl.FolioFactura = a.FolioFacturaA    
                   AND a.UUIDRelacionado = tbl.UUIDFactura    
            INNER JOIN @Tuui2 AS U2    
                ON tbl.UUID = U2.uuid;    
    
        INSERT @Final    
        SELECT *,    
               "IGUuid" = CASE    
                              WHEN UUID = UUIDCobro THEN    
                                  1    
                              ELSE    
                                  0    
                          END,    
               "IGUuiR" = CASE    
             WHEN UUIDFactura = FacturaXML THEN    
                                  1    
                              ELSE    
                                  0    
                          END,    
               "IGSerie" = CASE    
                               WHEN Serie = Seriex THEN    
                                   1    
                               ELSE    
                                   0    
                           END,    
               "IGFolio" = CASE    
                               WHEN Folio = Foliox THEN    
                                   1    
    ELSE    
                                   0    
                           END,    
               "IGSerieF" = CASE    
                                WHEN SerieFactura = SerieF THEN    
                                    1    
                                ELSE    
                                    0    
                            END,    
               "IGFolioF" = CASE    
                                WHEN FolioFactura = FolioF THEN    
                                    1    
                                ELSE    
                                    0    
                            END,    
               "IGImpPagado" = CASE    
                                   WHEN MtoFac = ImpPagado THEN    
                                       1    
                                   ELSE    
                                       0    
                               END,    
               "IGMonedaP" = CASE    
                                 WHEN Moneda = MonedaP THEN    
                                     1    
                                 ELSE    
                                     0    
                             END,    
               "IGMonto" = CASE    
                               WHEN MontoReqCFDI = Monto THEN    
                                   1    
                               ELSE    
                                   0    
                           END,    
               "IGFecha" = CASE    
                               WHEN FechaPagoxml = FechaPagoOracle THEN    
                                   1    
                               ELSE    
                                   0    
                           END,    
               "IGNumFac" = CASE    
                                WHEN Num1 = num2 THEN    
                                    1    
                                ELSE    
                                    0    
                            END    
        FROM @TFinal;    
    
    END;    
    ELSE    
    BEGIN    
        IF @consolidadoNumFac = 1    
        BEGIN    
            IF @UUID = ''    
            BEGIN    
				
                INSERT INTO @Tabla    
                SELECT a.ESTATUS_COMPROBANTE,    
                       a.UUID,    
                       [IdDocumento] = K.value('./@IdDocumento', 'varchar(MAX)'),    
                       [Folio1] = K.value('./@Folio', 'INT'),    
                       "NumeroOperacion" = I.value('./@NumOperacion', 'varchar(MAX)'),    
                       "Serie" = Y.value('./@Serie', 'varchar(MAX)'),    
                       "Folio" = Y.value('./@Folio', 'varchar(MAX)'),    
                       "Monto" = I.value('./@Monto', 'varchar(MAX)'),    
                       "SerieF" = K.value('./@Serie', 'varchar(MAX)'),    
                       "FolioF" = K.value('./@Folio', 'varchar(MAX)'),    
                       "FechaPago" = I.value('./@FechaPago', 'varchar(MAX)'),    
                       a.fec_reg,    
                       "FechaTimbrado" = W.value('./@FechaTimbrado', 'varchar(MAX)'),    
                       "MonedaP" = I.value('./@MonedaP', 'varchar(MAX)'),    
                       "ImpPagado" = K.value('./@ImpPagado', 'varchar(MAX)')    
                FROM (
					SELECT   
					a.ESTATUS_COMPROBANTE,  
					a.UUID,  
					a.XML_FILE,  
					a.fec_reg,  
					a.RFC_EMISOR  
					FROM dbo.sis_aud_cfdi a  WITH(NOLOCK)  
					WHERE a.EFECTO_COMPROBANTE = 'P'     
					 AND CAST(FECHA_EMISION AS DATE) >= @FechaI
				) a   
                    OUTER APPLY a.XML_FILE.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";/cfdi:Comprobante') AS X(Y)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Receptor') AS S(R)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Complemento') AS L(B)    
                    OUTER APPLY l.b.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pagos') AS T(U)    
                    OUTER APPLY t.u.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pago') AS F(I)    
                    OUTER APPLY f.i.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:DoctoRelacionado') AS Q(K)    
                    OUTER APPLY l.b.nodes('declare namespace tfd = "http://www.sat.gob.mx/TimbreFiscalDigital";./tfd:TimbreFiscalDigital') AS C(W)    
                WHERE REPLACE(a.RFC_EMISOR, '-', '') = @RfcEmpresa    
                      AND @FechaI  <= I.value('./@FechaPago', 'DATE')    
                      AND @FechaF >= I.value('./@FechaPago', 'DATE')    
                         
    
                INSERT INTO @Tabla2    
                SELECT tbl.UUID,    
                       tbl.UUIDFactura,    
                       tbl.Serie,    
                       tbl.Folio,    
                       tbl.SerieFactura,    
                       tbl.FolioFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.Moneda,    
                       "NumeroPoliza" = tbl.NumeroPoliza,    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.MontoReqCFDI,    
                       tbl.NumeroCobro,    
                       "MtoFac" = tbl.MontoFactura,    
                       tbl.Estatus,    
                       tbl.Mensaje,    
                       "fechaRegistro" = tbl.FechaRegistro
                FROM dbo.tbl_ServicioCentinelaWFSCobros tbl  WITH(NOLOCK)     
                WHERE tbl.IdArchivo = @archivo    
                      AND @FechaF >= tbl.FechaRegistro    
                      AND @FechaI <= tbl.FechaRegistro   
   
                INSERT INTO @Tuui1    
                SELECT 
				a.UUIDCobro, 
				COUNT(1)    
                FROM @Tabla AS a    
                GROUP BY a.UUIDCobro;    
    
                INSERT INTO @Tuui2    
                SELECT 
				UUID,    
                COUNT(1)    
                FROM @Tabla2  AS a  
                GROUP BY a.UUID;    
    
				SELECT COUNT(1) AS ConteoTuui1 FROM @Tuui1
				SELECT COUNT(1) AS ConteoTuui2 FROM @Tuui2
    
                INSERT INTO @TFinal    
                SELECT a.EstatusComprobante,    
                       tbl.NumeroPoliza,    
                       tbl.TipoDocumento,    
                       "NumeroFactura" = '',    
                       --tbl.NumeroFactura,     
					   tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.NumeroCobro,    
                       a.UUIDCobro,    
                       tbl.UUID,    
                       tbl.UUIDFactura,    
                       "FacturaXML" = ISNULL(a.UUIDRelacionado, '-'),    
                       tbl.serie,    
                       "Seriex" = a.Serie,    
                       tbl.Folio,    
                       "Foliox" = a.folio,    
                       tbl.SerieFactura,    
                       a.SerieF,    
                       tbl.FolioFactura,    
                       a.FolioF,    
                       tbl.MtoFac,    
                       a.ImpPagado,    
                       tbl.Moneda,    
                       a.MonedaP,    
                       tbl.MontoReqCFDI,    
                       a.Monto,    
                       a.FechaPago,    
                       tbl.fechaRegistro,    
                       "NumFacOrac" = U2.numero,    
                       "num2" = U1.numero,    
                       tbl.fechaRegistro    
                FROM @Tabla a  
				INNER JOIN @Tuui1 AS U1 
					ON a.UUIDCobro = U1.uuid  
				FULL OUTER JOIN (SELECT UUID,  
								   UUIDFactura,  
								   Serie,  
								   Folio,  
								   SerieFactura,  
								   FolioFactura,  
								   ClaveCliente,  
								   CuentaBanco,  
								   Moneda,  
								   "NumeroPoliza" = MAX(NumeroPoliza),  
								   TipoDocumento,  
								   NumeroFactura,  
								   MontoReqCFDI,  
								   NumeroCobro,  
								   "MtoFac" = SUM(CONVERT(FLOAT, MontoReqCFDI)),  
								   Estatus,  
								   Mensaje,  
								   "fechaRegistro" = CONVERT(DATE, MAX(FechaRegistro))  
								FROM @Tabla2
								GROUP BY UUID,  
										 UUIDFactura,  
										 Serie,  
										 Folio,  
										 SerieFactura,  
										 FolioFactura,  
										 ClaveCliente,  
										 CuentaBanco,  
										 Moneda,  
										 TipoDocumento,  
										 NumeroFactura,  
										 MontoReqCFDI,  
										 NumeroCobro,  
										 Estatus,  
										 Mensaje) tbl /*!! TODO !! JCA:28/8/2024.17:40 Cambiar tabla2 por subconsulta agrupando  */  
						ON  a.UUIDCobro = tbl.UUID   
							AND tbl.FolioFactura = a.FolioFacturaA  
				INNER JOIN @Tuui2 AS U2 
					ON tbl.UUID = U2.uuid;  
				
				SELECT * FROM @TFinal;  
      
	  RETURN 0
    /*    
                INSERT @Final    
                SELECT *,    
                       "IGUuid" = CASE    
                                      WHEN UUID = UUIDCobro THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGUuiR" = CASE    
                                      WHEN UUIDFactura = FacturaXML THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGSerie" = CASE    
                                       WHEN Serie = Seriex THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFolio" = CASE    
                                       WHEN Folio = Foliox THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGSerieF" = CASE    
                                        WHEN SerieFactura = SerieF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGFolioF" = CASE    
                                        WHEN FolioFactura = FolioF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGImpPagado" = CASE    
                                           WHEN MtoFac = ImpPagado THEN    
                                               1    
                                           ELSE    
                                               0    
                                       END,    
                       "IGMonedaP" = CASE    
                                         WHEN Moneda = MonedaP THEN    
                                             1    
                                         ELSE    
                                             0    
                                     END,    
                       "IGMonto" = CASE    
                                       WHEN MontoReqCFDI = Monto THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFecha" = CASE    
                                       WHEN FechaPagoxml = FechaPagoOracle THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGNumFac" = CASE    
                                        WHEN Num1 = num2 THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END    
                FROM @TFinal;    
*/    
            END;    
            ELSE    
            BEGIN    
                INSERT INTO @Tabla    
                SELECT a.ESTATUS_COMPROBANTE,    
                       a.UUID,    
                       K.value('./@IdDocumento', 'varchar(MAX)'),    
                       K.value('./@Folio', 'INT'),    
                       "NumeroOperacion" = I.value('./@NumOperacion', 'varchar(MAX)'),    
                       "Serie" = Y.value('./@Serie', 'varchar(MAX)'),    
                       "Folio" = Y.value('./@Folio', 'varchar(MAX)'),    
                       "Monto" = I.value('./@Monto', 'varchar(MAX)'),    
                       "SerieF" = K.value('./@Serie', 'varchar(MAX)'),    
                       "FolioF" = K.value('./@Folio', 'varchar(MAX)'),    
                       "FechaPago" = I.value('./@FechaPago', 'varchar(MAX)'),    
                       a.fec_reg,    
                       "FechaTimbrado" = W.value('./@FechaTimbrado', 'varchar(MAX)'),    
                       "MonedaP" = I.value('./@MonedaP', 'varchar(MAX)'),    
                       "ImpPagado" = K.value('./@ImpPagado', 'varchar(MAX)')    
                FROM dbo.sis_aud_cfdi a    
                    OUTER APPLY a.XML_FILE.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";/cfdi:Comprobante') AS X(Y)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Receptor') AS S(R)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Complemento') AS L(B)    
                    OUTER APPLY l.b.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pagos') AS T(U)    
                    OUTER APPLY t.u.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pago') AS F(I)    
                    OUTER APPLY f.i.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:DoctoRelacionado') AS Q(K)    
                    OUTER APPLY l.b.nodes('declare namespace tfd = "http://www.sat.gob.mx/TimbreFiscalDigital";./tfd:TimbreFiscalDigital') AS C(W)    
                WHERE a.EFECTO_COMPROBANTE = 'P'    
                      AND a.UUID = @UUID    
                      AND REPLACE(a.RFC_EMISOR, '-', '') =    
                      (    
                          SELECT TOP (1) REPLACE(rfc, '-', '')FROM dbo.cfg_empresa ORDER BY rfc    
                      );    
    
                INSERT INTO @Tabla2    
                SELECT tbl.UUID,    
                       tbl.UUIDFactura,    
                       tbl.Serie,    
                       tbl.Folio,    
                       tbl.SerieFactura,    
                       tbl.FolioFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.Moneda,    
                       "NumeroPoliza" = MAX(tbl.NumeroPoliza),    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.MontoReqCFDI,    
                       tbl.NumeroCobro,    
                  "MtoFac" = SUM(CONVERT(FLOAT, tbl.MontoFactura)),    
                       tbl.Estatus,    
                       tbl.Mensaje,    
                       "fechaRegistro" = CONVERT(DATE, MAX(tbl.FechaRegistro))    
                FROM dbo.tbl_ServicioCentinelaWFSCobros tbl    
                WHERE tbl.IdArchivo = @archivo    
                      AND tbl.UUID = @UUID    
                GROUP BY tbl.UUID,    
                         tbl.UUIDFactura,    
                         tbl.Serie,    
                         tbl.Folio,    
                         tbl.SerieFactura,    
                         tbl.FolioFactura,    
                         tbl.ClaveCliente,    
                         tbl.CuentaBanco,    
                         tbl.Moneda,    
                         tbl.TipoDocumento,    
                         tbl.NumeroFactura,    
                         tbl.MontoReqCFDI,    
                         tbl.NumeroCobro,    
                         tbl.Estatus,    
                         tbl.Mensaje;    
    
                INSERT INTO @Tuui1    
                SELECT UUIDCobro,    
                       COUNT(UUIDCobro)    
                FROM @Tabla    
                WHERE UUIDCobro IN    
                      (    
                          SELECT DISTINCT UUIDCobro FROM @Tabla    
                      )    
   GROUP BY UUIDCobro;    
    
                INSERT INTO @Tuui2    
                SELECT UUID,    
                       COUNT(UUID)    
                FROM @Tabla2    
                WHERE uuid IN    
                      (    
                          SELECT DISTINCT UUID FROM @Tabla2    
                      )    
                GROUP BY UUID;    
    
                INSERT INTO @TFinal    
                SELECT a.EstatusComprobante,    
                       tbl.NumeroPoliza,    
                       tbl.TipoDocumento,    
                       "NumeroFactura" = '',    
                       --tbl.NumeroFactura,     
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.NumeroCobro,    
                       a.UUIDCobro,    
                       tbl.UUID,    
                       tbl.UUIDFactura,    
                       "FacturaXML" = ISNULL(a.UUIDRelacionado, '-'),    
                       tbl.serie,    
                       "Seriex" = a.Serie,    
                       tbl.Folio,    
                       "Foliox" = a.folio,    
                       tbl.SerieFactura,    
                       a.SerieF,    
                       tbl.FolioFactura,    
                       a.FolioF,    
                       tbl.MtoFac,    
                       a.ImpPagado,    
                       tbl.Moneda,    
                       a.MonedaP,    
                       tbl.MontoReqCFDI,    
                       a.Monto,    
                       a.FechaPago,    
                       tbl.fechaRegistro,    
                       "NumFacOrac" = U2.numero,    
                       "num2" = U1.numero,    
                       tbl.fechaRegistro    
                FROM @Tabla a    
                    INNER JOIN @Tuui1 AS U1    
                        ON a.UUIDCobro = U1.uuid    
                    FULL OUTER JOIN @Tabla2 tbl    
                        ON a.UUIDCobro = tbl.UUID    
                           AND tbl.FolioFactura = a.FolioFacturaA --AND a.UUIDRelacionado = tbl.UUIDFactura    
                    INNER JOIN @Tuui2 AS U2    
                        ON tbl.UUID = U2.uuid;    
    
                INSERT @Final    
                SELECT *,    
                       "IGUuid" = CASE    
                                      WHEN UUID = UUIDCobro THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGUuiR" = CASE    
                                      WHEN UUIDFactura = FacturaXML THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGSerie" = CASE    
                                       WHEN Serie = Seriex THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFolio" = CASE    
                                       WHEN Folio = Foliox THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGSerieF" = CASE    
                                        WHEN SerieFactura = SerieF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGFolioF" = CASE    
                                        WHEN FolioFactura = FolioF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGImpPagado" = CASE    
                                           WHEN MtoFac = ImpPagado THEN    
                             1    
                                           ELSE    
                                               0    
                                       END,    
                       "IGMonedaP" = CASE    
                                         WHEN Moneda = MonedaP THEN    
                                             1    
                                         ELSE    
                                             0    
                                     END,    
                       "IGMonto" = CASE    
                                       WHEN MontoReqCFDI = Monto THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFecha" = CASE    
                                       WHEN FechaPagoxml = FechaPagoOracle THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGNumFac" = CASE    
                                        WHEN Num1 = num2 THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END    
                FROM @TFinal;    
            END;    
        END;    
        ELSE    
        BEGIN    
            IF @UUID = ''    
            BEGIN    
                INSERT INTO @Tabla    
                SELECT a.ESTATUS_COMPROBANTE,    
                       a.UUID,    
                       K.value('./@IdDocumento', 'varchar(MAX)'),    
                       K.value('./@Folio', 'INT'),    
                       "NumeroOperacion" = I.value('./@NumOperacion', 'varchar(MAX)'),    
                       "Serie" = Y.value('./@Serie', 'varchar(MAX)'),    
                       "Folio" = Y.value('./@Folio', 'varchar(MAX)'),    
                       "Monto" = I.value('./@Monto', 'varchar(MAX)'),    
                       "SerieF" = K.value('./@Serie', 'varchar(MAX)'),    
                       "FolioF" = K.value('./@Folio', 'varchar(MAX)'),    
                       "FechaPago" = I.value('./@FechaPago', 'varchar(MAX)'),    
                       a.fec_reg,    
                       "FechaTimbrado" = W.value('./@FechaTimbrado', 'varchar(MAX)'),    
          "MonedaP" = I.value('./@MonedaP', 'varchar(MAX)'),    
                       "ImpPagado" = K.value('./@ImpPagado', 'varchar(MAX)')    
                FROM dbo.sis_aud_cfdi a    
                    OUTER APPLY a.XML_FILE.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";/cfdi:Comprobante') AS X(Y)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Receptor') AS S(R)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Complemento') AS L(B)    
                    OUTER APPLY l.b.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pagos') AS T(U)    
                    OUTER APPLY t.u.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pago') AS F(I)    
                    OUTER APPLY f.i.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:DoctoRelacionado') AS Q(K)    
                    OUTER APPLY l.b.nodes('declare namespace tfd = "http://www.sat.gob.mx/TimbreFiscalDigital";./tfd:TimbreFiscalDigital') AS C(W)    
                WHERE a.EFECTO_COMPROBANTE = 'P'    
                      AND @pFechaI <= I.value('./@FechaPago', 'DATE')    
                      AND @pFechaF >= I.value('./@FechaPago', 'DATE')    
                      AND REPLACE(a.RFC_EMISOR, '-', '') =    
                      (    
                          SELECT TOP (1) REPLACE(rfc, '-', '')FROM dbo.cfg_empresa ORDER BY rfc    
                      );    
    
                INSERT INTO @Tabla2    
                SELECT tbl.UUID,    
                       tbl.UUIDFactura,    
                       tbl.Serie,    
                       tbl.Folio,    
                       tbl.SerieFactura,    
                       tbl.FolioFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.Moneda,    
                       "NumeroPoliza" = MAX(tbl.NumeroPoliza),    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.MontoReqCFDI,    
                       tbl.NumeroCobro,    
                       "MtoFac" = SUM(CONVERT(FLOAT, tbl.MontoFactura)),    
                       tbl.Estatus,    
                       tbl.Mensaje,    
                       "fechaRegistro" = CONVERT(DATE, MAX(tbl.FechaRegistro))    
                FROM dbo.tbl_ServicioCentinelaWFSCobros tbl    
                WHERE tbl.IdArchivo = @archivo    
                      AND @pFechaF >= tbl.FechaRegistro    
                      AND @pFechaI <= tbl.FechaRegistro    
                GROUP BY tbl.UUID,    
                         tbl.UUIDFactura,    
                         tbl.Serie,    
                         tbl.Folio,    
                         tbl.SerieFactura,    
                         tbl.FolioFactura,    
                         tbl.ClaveCliente,    
                         tbl.CuentaBanco,    
                         tbl.Moneda,    
                         tbl.TipoDocumento,    
                         tbl.NumeroFactura,    
                         tbl.MontoReqCFDI,    
                         tbl.NumeroCobro,    
                         tbl.Estatus,    
                         tbl.Mensaje;    
    
                INSERT INTO @Tuui1    
                SELECT UUIDCobro,    
                       COUNT(UUIDCobro)    
                FROM @Tabla    
                WHERE UUIDCobro IN    
                      (    
                          SELECT DISTINCT UUIDCobro FROM @Tabla    
                      )    
                GROUP BY UUIDCobro;    
    
                INSERT INTO @Tuui2    
                SELECT UUID,    
                       COUNT(UUID)    
                FROM @Tabla2    
                WHERE uuid IN    
                      (    
                          SELECT DISTINCT UUID FROM @Tabla2    
                      )    
                GROUP BY UUID;    
    
             INSERT INTO @TFinal    
                SELECT a.EstatusComprobante,    
                       tbl.NumeroPoliza,    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.NumeroCobro,    
                       a.UUIDCobro,    
                       tbl.UUID,    
                       tbl.UUIDFactura,    
                       "FacturaXML" = ISNULL(a.UUIDRelacionado, '-'),    
                       tbl.serie,    
                       "Seriex" = a.Serie,    
                       tbl.Folio,    
                       "Foliox" = a.folio,    
                       tbl.SerieFactura,    
                       a.SerieF,    
                       tbl.FolioFactura,    
                       a.FolioF,    
                       tbl.MtoFac,    
                       a.ImpPagado,    
                       tbl.Moneda,    
                       a.MonedaP,    
                       tbl.MontoReqCFDI,    
                       a.Monto,    
                       a.FechaPago,    
                       tbl.fechaRegistro,    
                       "NumFacOrac" = U2.numero,    
                       "num2" = U1.numero,    
                       tbl.fechaRegistro    
                FROM @Tabla a    
                    INNER JOIN @Tuui1 AS U1    
                        ON a.UUIDCobro = U1.uuid    
                    FULL OUTER JOIN @Tabla2 tbl    
                        ON a.UUIDCobro = tbl.UUID    
                           AND tbl.FolioFactura = a.FolioFacturaA --AND a.UUIDRelacionado = tbl.UUIDFactura    
                    INNER JOIN @Tuui2 AS U2    
                        ON tbl.UUID = U2.uuid;    
    
                INSERT @Final    
                SELECT *,    
                       "IGUuid" = CASE    
                                      WHEN UUID = UUIDCobro THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGUuiR" = CASE    
                                      WHEN UUIDFactura = FacturaXML THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGSerie" = CASE    
                                       WHEN Serie = Seriex THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFolio" = CASE    
                                       WHEN Folio = Foliox THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGSerieF" = CASE    
                                        WHEN SerieFactura = SerieF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGFolioF" = CASE    
                                        WHEN FolioFactura = FolioF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGImpPagado" = CASE    
                                           WHEN MtoFac = ImpPagado THEN    
                                               1    
                                           ELSE    
                                               0    
                                       END,    
                       "IGMonedaP" = CASE    
                                         WHEN Moneda = MonedaP THEN    
                                             1    
                                         ELSE    
                                             0    
                                     END,    
                       "IGMonto" = CASE    
                                       WHEN MontoReqCFDI = Monto THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFecha" = CASE    
                                       WHEN FechaPagoxml = FechaPagoOracle THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGNumFac" = CASE    
                                        WHEN Num1 = num2 THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END    
                FROM @TFinal;    
            END; --    
            ELSE    
            BEGIN    
                INSERT INTO @Tabla    
                SELECT a.ESTATUS_COMPROBANTE,    
                       a.UUID,    
                       K.value('./@IdDocumento', 'varchar(MAX)'),    
                       K.value('./@Folio', 'INT'),    
                       "NumeroOperacion" = I.value('./@NumOperacion', 'varchar(MAX)'),    
                       "Serie" = Y.value('./@Serie', 'varchar(MAX)'),    
                       "Folio" = Y.value('./@Folio', 'varchar(MAX)'),    
                       "Monto" = I.value('./@Monto', 'varchar(MAX)'),    
                       "SerieF" = K.value('./@Serie', 'varchar(MAX)'),    
                       "FolioF" = K.value('./@Folio', 'varchar(MAX)'),    
                       "FechaPago" = I.value('./@FechaPago', 'varchar(MAX)'),    
                       a.fec_reg,    
                       "FechaTimbrado" = W.value('./@FechaTimbrado', 'varchar(MAX)'),    
                       "MonedaP" = I.value('./@MonedaP', 'varchar(MAX)'),    
                       "ImpPagado" = K.value('./@ImpPagado', 'varchar(MAX)')    
                FROM dbo.sis_aud_cfdi a    
                    OUTER APPLY a.XML_FILE.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";/cfdi:Comprobante') AS X(Y)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Receptor') AS S(R)    
                    OUTER APPLY x.y.nodes('declare namespace cfdi = "http://www.sat.gob.mx/cfd/4";./cfdi:Complemento') AS L(B)    
                    OUTER APPLY l.b.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pagos') AS T(U)    
                    OUTER APPLY t.u.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:Pago') AS F(I)    
                    OUTER APPLY f.i.nodes('declare namespace pago20 = "http://www.sat.gob.mx/Pagos20";./pago20:DoctoRelacionado') AS Q(K)    
                    OUTER APPLY l.b.nodes('declare namespace tfd = "http://www.sat.gob.mx/TimbreFiscalDigital";./tfd:TimbreFiscalDigital') AS C(W)    
                WHERE a.EFECTO_COMPROBANTE = 'P'    
                      AND a.UUID = @UUID    
                      AND REPLACE(a.RFC_EMISOR, '-', '') =    
                      (    
                          SELECT TOP (1) REPLACE(rfc, '-', '')FROM dbo.cfg_empresa ORDER BY rfc    
                      );    
    
                INSERT INTO @Tabla2    
                SELECT tbl.UUID,    
                       tbl.UUIDFactura,    
                       tbl.Serie,    
                       tbl.Folio,    
                       tbl.SerieFactura,    
                       tbl.FolioFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.Moneda,    
                       "NumeroPoliza" = MAX(tbl.NumeroPoliza),    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.MontoReqCFDI,    
                       tbl.NumeroCobro,    
                       "MtoFac" = SUM(CONVERT(FLOAT, tbl.MontoFactura)),    
                       tbl.Estatus,    
                       tbl.Mensaje,    
                       "fechaRegistro" = CONVERT(DATE, MAX(tbl.FechaRegistro))    
                FROM dbo.tbl_ServicioCentinelaWFSCobros tbl    
                WHERE tbl.IdArchivo = @archivo    
                      AND tbl.UUID = @UUID    
                GROUP BY tbl.UUID,    
                         tbl.UUIDFactura,    
                         tbl.Serie,    
                         tbl.Folio,    
                         tbl.SerieFactura,    
                         tbl.FolioFactura,    
                         tbl.ClaveCliente,    
                         tbl.CuentaBanco,    
                         tbl.Moneda,    
                         tbl.TipoDocumento,    
                         tbl.NumeroFactura,    
                         tbl.MontoReqCFDI,    
                         tbl.NumeroCobro,    
                         tbl.Estatus,    
                         tbl.Mensaje;    
    
                INSERT INTO @Tuui1    
                SELECT UUIDCobro,    
                       COUNT(UUIDCobro)    
                FROM @Tabla    
                WHERE UUIDCobro IN    
                      (    
                          SELECT DISTINCT UUIDCobro FROM @Tabla    
                      )    
                GROUP BY UUIDCobro;    
    
                INSERT INTO @Tuui2    
                SELECT UUID,    
                       COUNT(UUID)    
                FROM @Tabla2    
                WHERE uuid IN    
                      (    
                          SELECT DISTINCT UUID FROM @Tabla2    
                      )    
                GROUP BY UUID;    
    
                INSERT INTO @TFinal    
                SELECT a.EstatusComprobante,    
                       tbl.NumeroPoliza,    
                       tbl.TipoDocumento,    
                       tbl.NumeroFactura,    
                       tbl.ClaveCliente,    
                       tbl.CuentaBanco,    
                       tbl.NumeroCobro,    
                       a.UUIDCobro,    
                       tbl.UUID,    
                       tbl.UUIDFactura,    
                       "FacturaXML" = ISNULL(a.UUIDRelacionado, '-'),    
                       tbl.serie,    
                       "Seriex" = a.Serie,    
                       tbl.Folio,    
                       "Foliox" = a.folio,    
                       tbl.SerieFactura,    
                       a.SerieF,    
                       tbl.FolioFactura,    
                       a.FolioF,    
                       tbl.MtoFac,    
                       a.ImpPagado,    
                       tbl.Moneda,    
                       a.MonedaP,    
                       tbl.MontoReqCFDI,    
                       a.Monto,    
                       a.FechaPago,    
                       tbl.fechaRegistro,    
                       "NumFacOrac" = U2.numero,    
                       "num2" = U1.numero,    
                       tbl.fechaRegistro    
                FROM @Tabla a    
                    INNER JOIN @Tuui1 AS U1    
                        ON a.UUIDCobro = U1.uuid    
                    FULL OUTER JOIN @Tabla2 tbl    
                        ON a.UUIDCobro = tbl.UUID    
                           AND tbl.FolioFactura = a.FolioFacturaA --AND a.UUIDRelacionado = tbl.UUIDFactura    
                    INNER JOIN @Tuui2 AS U2    
                        ON tbl.UUID = U2.uuid;    
    
                INSERT @Final    
                SELECT *,    
                       "IGUuid" = CASE    
                                      WHEN UUID = UUIDCobro THEN    
        1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGUuiR" = CASE    
                                      WHEN UUIDFactura = FacturaXML THEN    
                                          1    
                                      ELSE    
                                          0    
                                  END,    
                       "IGSerie" = CASE    
                                       WHEN Serie = Seriex THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFolio" = CASE    
                                       WHEN Folio = Foliox THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGSerieF" = CASE    
                                        WHEN SerieFactura = SerieF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGFolioF" = CASE    
                                        WHEN FolioFactura = FolioF THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END,    
                       "IGImpPagado" = CASE    
                                           WHEN MtoFac = ImpPagado THEN    
                                               1    
                                           ELSE    
                                               0    
                                       END,    
                       "IGMonedaP" = CASE    
                                         WHEN Moneda = MonedaP THEN    
                                             1    
                                         ELSE    
                                             0    
                                     END,    
                       "IGMonto" = CASE    
                 WHEN MontoReqCFDI = Monto THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGFecha" = CASE    
                                       WHEN FechaPagoxml = FechaPagoOracle THEN    
                                           1    
                                       ELSE    
                                           0    
                                   END,    
                       "IGNumFac" = CASE    
                                        WHEN Num1 = num2 THEN    
                                            1    
                                        ELSE    
                                            0    
                                    END    
                FROM @TFinal;    
            END;    
        END;    
    END;    
    
 /********  28/8/2024.10:07 Info: Sobre la tabla procesada  ********/    
    
    IF @Filtro = 'Mon'    
    BEGIN    
        SELECT *    
        FROM @Final    
        WHERE IGImpPagado = 0;    
    END;    
    ELSE IF @Filtro = 'Suo'    
    BEGIN    
        SELECT *    
        FROM @Final    
        WHERE UUID = '';    
    END;    
    ELSE IF @Filtro = 'Dfc'    
    BEGIN    
        SELECT *    
        FROM @Final    
        WHERE IGNumFac = 0;    
    END;    
    ELSE IF @Filtro = 'Dfe'    
    BEGIN    
        SELECT *    
        FROM @Final    
        WHERE IGFecha = 0    
              AND FechaPagoxml <> NULL    
              AND fechaRegistroOracle <> NULL;    
    END;    
    ELSE    
    BEGIN    
        SELECT *    
  FROM @Final;    
    END;    
    
Salida:    
END;    
GO

