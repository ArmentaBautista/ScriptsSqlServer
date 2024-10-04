
-- 2.06 fnPLDdestinosRecursosSocios




IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDdestinosRecursosSocios')
BEGIN
	DROP FUNCTION fnPLDdestinosRecursosSocios
	SELECT 'fnPLDdestinosRecursosSocios BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDdestinosRecursosSocios(
@pIdPersona AS INT=0
)
RETURNS TABLE
AS RETURN(

		SELECT IdPersona,IdSocio,IdAnalisisCrediticio, OrigenDetino, Monto
		FROM 
		   (SELECT  an.IdPersona,an.IdSocio,
					e.IdAnalisisCrediticio,
				    e.Alimentos,
					e.LuzAgua,
					e.Transporte,
					e.Vivienda,
					e.Combustible,
					e.Extraordinarios,
					e.CooperativasBancos,
					e.TarjetaCredito,
					e.Almacenes,
					e.CostosOperacion,
					e.CostosVentas,
					e.Educacion,
					e.OtrosEgresos	
			FROM dbo.tSCSanalisisIngresosEgresos e WITH (NOLOCK)
			INNER JOIN dbo.tSCSanalisisCrediticio an  WITH(NOLOCK) 
				ON an.IdAnalisisCrediticio = e.IdAnalisisCrediticio
					AND ((@pIdPersona=0) OR (an.IdPersona= @pIdPersona))
			WHERE an.IdAnalisisCrediticio<>0
			) p
		UNPIVOT
		   (Monto FOR OrigenDetino IN 
			  (
				Alimentos,LuzAgua,Transporte,Vivienda,Combustible,Extraordinarios,CooperativasBancos,TarjetaCredito,Almacenes,CostosOperacion,CostosVentas,Educacion,OtrosEgresos	
)
		) AS unpvt
		WHERE unpvt.Monto>0
)
GO

IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='fnPLDdestinosRecursosSocios')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('fnPLDdestinosRecursosSocios')
END

-- SELECT * FROM dbo.fnPLDdestinosRecursosSocios(30)
-- SELECT * FROM dbo.fnPLDdestinosRecursosSocios(0)

