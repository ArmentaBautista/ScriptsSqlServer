

/* INFO (⊙_☉) JCA.27/08/2023.02:44 a. m. 
Nota: Carga inicial de catálogos
*/

/* ฅ^•ﻌ•^ฅ   JCA.27/08/2023.02:51 a. m. Nota: Tipos de Atención   */

INSERT INTO dbo.tATNStiposAtencion(Codigo,Descripcion,IdSesion) 
VALUES 
    ('CONS','Consulta',0),
    ('ACLA','Aclaración',0),
    ('RECL','Reclamo',0);
GO

/*  (◕ᴥ◕)    JCA.27/08/2023.02:51 a. m. Nota: Medios Notificación  */

INSERT INTO tATNSmediosNotificacion (Codigo,Descripcion,IdSesion) 
VALUES
    ('CEL','Correo Electrónico',0),
    ('BUZ','Buzón',0),
    ('SUC','Sucursales',0),
    ('TEL','Teléfono',0),
    ('UNE','UNE',0),
    ('CDF','Condusef',0),
    ('SIGE','Condusef SIGE',0),
    ('OTRO','Otro',0);
GO    

/* ฅ^•ﻌ•^ฅ   JCA.27/08/2023.03:06 a. m. Nota: Tipos de Causa   */

INSERT INTO dbo.tATNStiposCausa (Codigo,Descripcion,IdSesion)
VALUES
('TC01','Orientación sobre funcionamiento de productos y servicios financieros',0),
('TC02','Inconformidad por comisiones, intereses e impuestos cobrados de forma indebida',0),
('TC03','Inconformidad con el saldo del crédito o del monto de las amortizaciones',0),
('TC04','Inconformidad con el saldo y disposición de efectivo en ventanilla y/o sucursal no reconocida por el usuario',0),
('TC05','Inconformidad por cobranza indebida',0),
('TC06','Inconformidad por incumplimiento de contrato',0),
('TC07','Inconformidad por la prima de los seguros y/o con la forma del pago del mismo',0),
('TC08','Inconformidad por actualización en historial crediticio BC',0),
('TC09','Inconformidad con el monto de los rendimientos pagados',0),
('TC010','Otras inconformidades',0);
GO

/*  (◕ᴥ◕)    JCA.27/08/2023.03:11 a. m. Nota: SubTipos de Causa  */
/*
INSERT INTO dbo.tATNSsubtiposCausa (Codigo,Descripcion,IdSesion)
VALUES
('','',0)
*/

--SELECT * FROM dbo.tATNStiposAtencion
--SELECT * FROM dbo.tATNSmediosNotificacion
--SELECT * FROM dbo.tATNStiposCausa


