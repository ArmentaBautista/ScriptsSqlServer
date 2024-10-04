

 
/* INSERT DUMMY CANALES */
-- SELECT FLOOR(rand()*101)
-- 1: Instrumentos 2: Canales
-- SELECT * FROM tPLDmatrizConfiguracionInstrumentosCanales
 delete from tPLDmatrizConfiguracionInstrumentosCanales where Tipo=2
go

 /* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
 

 INSERT INTO dbo.tPLDmatrizConfiguracionInstrumentosCanales
 (
     Tipo,
     IdValor1,
     IdValor2,
     ValorDescripcion,
     Puntos
 )
 VALUES
 (2,1,0,'VENTANILLA (TICKET)',1),
 (2,2,0,'SUCURSAL (TRSP.CTA)',1),
 (2,3,0,'CTA CONCENTRADORA (TRN)',1),
 (2,10,0,'CTA CONCENTRADORA (MOV.BCO)',1),
 (2,17,0,'VENTANILLA (VENTA)',1),
 (2,22,0,'VENTANILLA (TRSP.SDO)',1),
 (2,23,0,'ATM | TPV (MOV.ATM)',1),
 (2,32,0,'SPEI',1),
 (2,33,0,'SUCURSAL (EMICHE)',1),
 (2,52,0,'BANCA MOVIL (ENTM)',1),
 (2,70,0,'ATM | TPV (ATM-MULT)',1)



GO

SELECT * FROM tPLDmatrizConfiguracionInstrumentosCanales
GO

   /*
   SELECT toper.IdTipoOperacion,toper.Codigo,toper.Descripcion 
   FROM dbo.tCTLtiposOperacion toper  WITH(NOLOCK) 
   WHERE toper.IdTipoOperacion IN (23,70,52,3,10,32,2,33,57,1,17,22)
   */

