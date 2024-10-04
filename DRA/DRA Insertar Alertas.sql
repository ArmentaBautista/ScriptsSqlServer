

-- JCAalertasVarias



DECLARE @TipoInstruccion AS INT=0
SET @TipoInstruccion=1543

DECLARE @Alta AS DATETIME = CURRENT_TIMESTAMP;
		
DECLARE @agrupador AS VARCHAR(60)='ImpresionSolIngreso230530'



INSERT INTO dbo.tCTLmensajes (Mensaje,IdTipoDmensaje,IdTipoDinstruccion,IdTipoDdespliegue,UsuarioEmisor,UsuarioReceptor,IdTipoDdominio,IdDominio
					,UsaVigencia,InicioVigencia,FinVigencia,IdEstatus,Alta,UsuarioBaja,Baja,NotaBaja
					,Concepto
					,Referencia
					,Agrupador)
SELECT al.[ALERTA DE BLOQUEO], 1537, @TipoInstruccion,1544,-1,-1,208,sc.IdSocio
,0,'19000101','19000101',1,@Alta,0,'19000101',''
,'Imprimir solicitud de ingreso'
, CONCAT('Socio: ',p.Nombre)
,@agrupador
--,al.[No# Cliente/Usuario], sc.Codigo
FROM JCAalertasVarias al  WITH(NOLOCK)
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.Codigo=al.[No# Cliente/Usuario]
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona



	--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--			SELECT m.IdMensaje,				-- Identity
		--			       m.Mensaje,				-- Mensaje
		--			       m.IdTipoDmensaje,		-- 1537 Alerta | 1539 Instruccion | 1538 Mensaje
		--			       m.IdTipoDinstruccion,	-- 1541 MÉTODOCLASE | 1542 BLOQUEO | 1543 INFORMACIÓN | 1540 STOREDPROCEDURE
		--			       m.IdTipoDdespliegue,		-- 1544 MODAL | 1545 NO MODAL
		--			       m.UsuarioEmisor,			
		--			       m.UsuarioReceptor,
		--			       m.IdTipoDdominio,		-- 208 Socio | 232 CUENTA
		--			       m.IdDominio,				-- Id del Registro
		--			       m.UsaVigencia,
		--			       m.InicioVigencia,
		--			       m.FinVigencia,
		--			       m.IdEstatus,
		--			       m.Alta,
		--			       m.UsuarioBaja,
		--			       m.Baja,
		--			       m.NotaBaja,
		--			       --m.IdTipoDalerta
		--			FROM dbo.tCTLmensajes m  WITH(NOLOCK) 
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--
		--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--


SELECT * 
-- BEGIN TRAN UPDATE m SET m.IdTipoDinstruccion=1542
FROM dbo.tCTLmensajes m
WHERE m.Agrupador='ImpresionSolIngreso230530'


-- COMMIT



