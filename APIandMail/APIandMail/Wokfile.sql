


SELECT * FROM dbo.tCTLtiposE e  WITH(NOLOCK) WHERE e.Descripcion LIKE '%etapa%'

SELECT d.IdTipoD,d.Codigo,d.Descripcion,d.Orden 
FROM dbo.tCTLtiposD d  WITH(NOLOCK) WHERE d.IdTipoE = 172 ORDER BY d.Orden


SELECT TOP 100 c.IdCuenta, c.Descripcion
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1
ORDER BY c.IdCuenta DESC




EXEC dbo.pCTLenvíoCorreoCredito @pIdEtapaCredito = 2236, -- int
                                @pIdCuenta = 10147        -- int


