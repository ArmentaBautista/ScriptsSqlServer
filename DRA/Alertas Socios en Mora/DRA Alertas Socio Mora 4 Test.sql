
USE iERP_DRA
GO


SELECT * FROM dbo.tCTLmensajes  WITH(nolock) 

/*

EXEC dbo.pAgregarAlerta @TipoOperacion = 'SOCIOSENMORA', -- varchar(250)
                        @Mensaje = '',       -- varchar(max)
                        @Bloqueo = 0,     -- bit
                        @IdtipoDdominio = 208, -- int
                        @IdRegistro = 0      -- int

*/

-- 6,790

 -- DELETE FROM dbo.tCTLmensajes   WHERE Mensaje= 'EL SOCIO PRESENTA ATRASO EN SU PAGO DE CRÉDITO'


SELECT * FROM dbo.tCTLmensajes  WITH(nolock) 
WHERE Agrupador='SOCIOSENMORA' AND Referencia LIKE '%53777%'


-- SOCIO EN MORA - Socio: 010100053777 Cuenta: 01010005377700042


SELECT ct.DiasMoraCapital, ct.FechaCartera,ct.FechaHora ,c.*
FROM dbo.tAYCcartera ct  WITH(nolock) 
INNER JOIN dbo.tAYCcuentas c  WITH(nolock) ON c.IdCuenta = ct.IdCuenta
WHERE c.Codigo='01010005377700042'
AND ct.FechaCartera BETWEEN '20210119' AND '20210121'




