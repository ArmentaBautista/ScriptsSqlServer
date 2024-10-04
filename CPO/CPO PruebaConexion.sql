

SELECT * FROM dbo.ftFMTcaratulaCuentas(1296434) --Esta función recibe como parametro el Idcuenta
GO

SELECT * FROM dbo.fFMTtotalAPagar(1296434) --Esta función recibe como parametro el Idcuenta
GO

SELECT * FROM dbo.fFMTcontratoCreditoCPO(1296434) --Esta función recibe como parametro el Idcuenta
GO

SELECT *
FROM dbo.vFMTavalesAsignados a WITH(NOLOCK) --Esta vista se ocupa en las secciones de firma de Avales y recibe un IdCuenta
WHERE a.IdCuenta = 1296434
GO

SELECT * FROM dbo.ffmtPlanPagosCPO(1296434)-- Esta función es para el plan de pagos
GO

SELECT*
FROM dbo.vAYCparcialidadesOriginalesGUI po WITH(NOLOCK) --Esta vista es para obtener las parcialidades del plan de pagos
WHERE po.IdCuenta = 1296434
GO