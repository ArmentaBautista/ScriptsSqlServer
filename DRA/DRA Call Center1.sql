

USE iERP_DRA
GO

DECLARE @FechaFin AS DATE='20200418'
DECLARE @FechaTrabajo AS DATE=GETDATE();

SELECT	
		 
 [NoSocio] = socio.Codigo
 ,Socio = persona.Nombre
 ,cuenta.Vencimiento
 ,Tel.Telefono
 , @FechaTrabajo AS FechaGeneracion
 ,CONCAT('Estimado socio, Caja Dr. Arroyo le informa que el día '
		 , ISNULL((SELECT TOP 1 Vencimiento FROM tAYCparcialidades WITH(NOLOCK) WHERE EstaPagada = 0 AND Vencimiento> @FechaFin AND IdCuenta=Cuenta.IdCuenta ORDER BY Vencimiento), cuenta.Vencimiento) 
		 , ' vence su cuenta '
		 , Cuenta.Codigo
		 ,' por: '
		 ,FORMAT(Calculo.TotalAtrasado,'C','es-MX')
		 ,' Conserve su buen historial crediticio') AS Mensaje
FROM	tAYCcuentas Cuenta		WITH(NOLOCK)	
INNER JOIN fAYCcalcularSaldoDeudoras(0,CURRENT_TIMESTAMP,16,0)	Calculo ON Calculo.IdCuenta = Cuenta.IdCuenta
INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = Cuenta.IdSocio
INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
left JOIN (
			SELECT b.IdRel,CONCAT( b.CodigoArea, Telefono) AS Telefono
			 FROM tCATtelefonos b WITH (NOLOCK)
			 JOIN tCTLestatusActual c WITH (NOLOCK) ON c.IdEstatusActual = b.IdEstatusActual AND c.IdEstatus=1
			 INNER JOIN dbo.tCTLrelaciones rel WITH(NOLOCK) ON rel.IdRel = b.IdRel	
			 WHERE b.IdListaD = -1339
		   ) AS Tel ON tel.IdRel=persona.IdRelTelefonos 
WHERE	Cuenta.IdTipoDproducto = 143 AND cuenta.IdEstatus=1 AND
		(	
			Cuenta.PrimerVencimientoPendienteCapital <= @FechaFin OR 
			cuenta.PrimerVencimientoPendienteInteres <= @FechaFin
		)			


