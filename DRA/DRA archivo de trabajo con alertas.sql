
USE iERP_DRA
GO


/*
EXEC dbo.pAgregarAlerta @TipoOperacion = 'SOCIOSCARTERAVENCIDA', -- varchar(250)
                        @Mensaje = '',       -- varchar(max)
                        @Bloqueo = 0,     -- bit
                        @IdtipoDdominio = 208, -- int
                        @IdRegistro = 0      -- int
*/


SELECT COUNT(*) FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.Agrupador='SOCIOSENMORA'

SELECT COUNT(*) FROM dbo.tCTLmensajes m  WITH(nolock) WHERE m.Agrupador='SOCIOSCARTERAVENCIDA'

-- DELETE FROM dbo.tCTLmensajes WHERE agrupador='SOCIOSCARTERAVENCIDA'

SELECT * FROM dbo.tCTLconsultas c  WITH(nolock) WHERE c.Descripcion LIKE '%prevent%'


EXEC dbo.plstMensajesDeCobranzaPreventiva



SELECT * FROM dbo.tCTLestatus 


SELECT --CONCAT(@Mensaje,'Socio: ',socio.Codigo,' Cuenta: ',cuentas.Codigo), 1537, @TipoInstruccion,1544,-1,-1,@IdtipoDdominio,cuentas.IdSocio,0,'19000101','19000101',1,@Alta,0,'19000101','',CONCAT('Socio: ',socio.Codigo) AS Concepto,CONCAT('Cuenta: ',cuentas.Codigo) AS Referencia,@agrupador
				cuentas.IdEstatusCartera, cartera.IdEstatusCartera,
				*
					FROM dbo.tAYCcartera cartera  WITH(nolock) 
					INNER JOIN dbo.tAYCcuentas cuentas  WITH(nolock) ON cuentas.IdCuenta = cartera.IdCuenta
					INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdSocio = cuentas.IdSocio
					WHERE cartera.FechaCartera='20210414' AND cartera.IdEstatusCartera=29
					AND cartera.DiasMoraCapital=0



