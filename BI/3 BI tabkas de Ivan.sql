
-- =========================================================================
-- CATÁLOGO MÍNIMO  (Fuente = REGULATORIOS)  destino: tSITcatalogoMinimo
-- ==========================================)===============================

DECLARE @periodo AS VARCHAR(6)=CONCAT(DATEPART(YYYY,GETDATE()),DATEPART(MM,GETDATE()-30))

SELECT catmin.id,
       catmin.IdPeriodo,
       catmin.IdCatalogoSITI,
       2 AS IdEmpresa,
       catmin.Concepto,
       catmin.Descripcion,
       catmin.Orden,
       catmin.Nivel,
       catmin.Fila,
       catmin.OrdenR01
FROM iERP_FNG_REG.dbo.tSITcatalogoMinimo catmin 
JOIN iERP_FNG_REG.dbo.tSITperiodos per ON per.IdPeriodo = catmin.IdPeriodo
WHERE per.Periodo = @periodo


-- =========================================================================================
-- CATÁLOGO MÍNIMO (SALDOS) (Base = REGULATORIOS)   destino: tSITcatalogoMinimoSaldos
-- =========================================================================================
SELECT IdPeriodo,
       IdCatalogoSITI,
       Periodo,
          2 AS IdEmpresa,
       Importe,
       Saldo,
       IdSucursal
FROM iERP_FNG_REG.dbo.tSITcatalogoMinimoSaldosFinancieros
WHERE Periodo = '202011'

-- ==================================================================
-- sucursales (Base = PRODUCCIÓN)   destino:  tBSIsucursales
-- ==================================================================
USE ierp_fng
SELECT 2 AS IdEmpresa,
             idSucursal,
             '202011' AS Periodo,
             s.Codigo,
             s.Descripcion
FROM iERP_FNG.dbo.tCTLsucursales s JOIN dbo.tCTLestatusActual e ON e.IdEstatusActual = s.IdEstatusActual
WHERE e.IdEstatus = 1




