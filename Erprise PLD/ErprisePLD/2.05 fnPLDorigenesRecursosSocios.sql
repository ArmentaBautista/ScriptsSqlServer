


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDorigenesRecursosSocios')
BEGIN
	DROP FUNCTION fnPLDorigenesRecursosSocios
	SELECT 'fnPLDorigenesRecursosSocios BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDorigenesRecursosSocios(
@pIdPersona AS INT=0
)
RETURNS TABLE
AS RETURN(

		SELECT IdPersona,IdSocio,IdAnalisisCrediticio, OrigenDetino, Monto
		FROM 
		   (SELECT e.IdAnalisisCrediticio, an.IdPersona,an.IdSocio,
				  e.Sueldo,
				  e.Comisiones,
				  e.HonorariosProfecionales,
				  e.InteresesInversiones,
				  e.Arrendamientos,
				  e.OtrosIngresos,
				  e.ConyugueSueldo,
				  e.ConyugueComisiones,
				  e.ConyugueHonorariosProfecionales,
				  e.Becas,
				  e.Donativos,
				  e.Fideicomiso,
				  e.Herencia,
				  e.LiquidacionFiniquito,
				  e.Pension,
				  e.Premios,
				  e.Remesas,
				  e.Seguros,
				  e.Subsidio,
				  e.Dividendos,
				  e.ProyectoAgricola,
				  e.UtilidadNegocio,
				  e.VentasComercializacion,
				  e.VentaBienesInmuebles,
				  e.VentaBienesMuebles,
				  e.Aguinaldo,
				  e.ProvienePrestamo,
				  e.AhorroInversionOtraInstitucion,
				  e.AhorroIngresos
			FROM dbo.tSCSanalisisIngresosEgresos e WITH (NOLOCK)
			INNER JOIN dbo.tSCSanalisisCrediticio an  WITH(NOLOCK) 
				ON an.IdAnalisisCrediticio = e.IdAnalisisCrediticio
					AND ((@pIdPersona=0) OR (an.IdPersona= @pIdPersona))
			WHERE an.IdAnalisisCrediticio<>0
			) p
		UNPIVOT
		   (Monto FOR OrigenDetino IN 
			  (
				Sueldo,Comisiones,HonorariosProfecionales,InteresesInversiones,Arrendamientos,OtrosIngresos,ConyugueSueldo
				,ConyugueComisiones,ConyugueHonorariosProfecionales,Becas,Donativos,Fideicomiso,Herencia,LiquidacionFiniquito
				,Pension,Premios,Remesas,Seguros,Subsidio,Dividendos,ProyectoAgricola,UtilidadNegocio,VentasComercializacion
				,VentaBienesInmuebles,VentaBienesMuebles,Aguinaldo,ProvienePrestamo,AhorroInversionOtraInstitucion,AhorroIngresos)
		) AS unpvt
		WHERE unpvt.Monto>0
)
GO

IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='fnPLDorigenesRecursosSocios')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('fnPLDorigenesRecursosSocios')
END
GO

--SELECT * FROM dbo.fnPLDorigenesRecursosSocios(85806)

