

SELECT *
FROM tayccuentas c  WITH(NOLOCK) 
--WHERE codigo='10803-046319'
WHERE codigo IN ('10801-054195','10803-046319')

-- 723867
-- 703561
SELECT * 
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
WHERE b.Tabla='tayccuentas' AND b.Campo='vencimiento' and b.IdRegistro IN (703561,723867)
ORDER BY IdRegistro,b.Id




-- '10801-054195'










