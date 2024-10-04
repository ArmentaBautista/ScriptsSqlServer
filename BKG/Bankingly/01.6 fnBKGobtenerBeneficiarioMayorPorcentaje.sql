

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnBKGobtenerBeneficiarioMayorPorcentaje')
BEGIN
	DROP FUNCTION fnBKGobtenerBeneficiarioMayorPorcentaje
	SELECT 'fnBKGobtenerBeneficiarioMayorPorcentaje BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnBKGobtenerBeneficiarioMayorPorcentaje(
@IdCuenta AS INT
)
RETURNS VARCHAR(128)
AS
BEGIN
/* INFO (⊙_☉) 
Solo usar cuando se esta filtrando una sola cuenta en la consulta llamante
NO SE USE PARA CONSULTAS QUE DEVUELVEN MÁS DE UNA CUENTA
*/
	DECLARE @Beneficiario AS VARCHAR(128)=''

		SELECT TOP 1 
		 @Beneficiario = p.nombre
		FROM tayccuentas c  WITH(NOLOCK) 
		INNER JOIN tAYCreferenciasAsignadas ref  WITH(NOLOCK) 
			ON ref.relreferenciasAsignadas=c.relreferenciasAsignadas
				AND ref.idestatus=1
		INNER JOIN dbo.tSCSpersonasFisicasReferencias pr  WITH(NOLOCK) 
			ON pr.IdReferenciaPersonal = ref.IdReferenciaPersonal
		INNER JOIN tgrlpersonas p  WITH(NOLOCK) 
			ON p.idpersona=pr.IdPersona
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
		WHERE c.IdCuenta=@IdCuenta

		RETURN @Beneficiario
END
GO	



