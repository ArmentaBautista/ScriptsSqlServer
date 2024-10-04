

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnAYCpivotBeneficiarios')
BEGIN
	DROP FUNCTION dbo.fnAYCpivotBeneficiarios
	SELECT 'fnAYCpivotBeneficiarios BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnAYCpivotBeneficiarios()
RETURNS @Pivot TABLE(
 RelReferenciasPersonales		INT
,[Beneficiario1]				INT
,[Beneficiario2]				INT
,[Beneficiario3]				INT
,[Beneficiario4]				INT
,[Beneficiario5]				INT
,[Beneficiario6]				INT
, INDEX ixrel (RelReferenciasPersonales)
, INDEX ixb1 (Beneficiario1)
, INDEX ixb2 (Beneficiario2)
, INDEX ixb3 (Beneficiario3)
, INDEX ixb4 (Beneficiario4)
, INDEX ixb5 (Beneficiario5)
, INDEX ixb6 (Beneficiario6)
)
AS
BEGIN 
		DECLARE @Beneficiarios AS TABLE
		(
			RelReferenciasPersonales	INT,
			IdReferenciaPersonal		INT PRIMARY KEY,
			Orden						TINYINT
			, INDEX ixrel (RelReferenciasPersonales)
			, INDEX ixorden (Orden)
		)

		INSERT INTO @Beneficiarios
		(
			RelReferenciasPersonales,
			IdReferenciaPersonal,
			Orden
		)
		SELECT 
		 r.RelReferenciasPersonales
		,r.IdReferenciaPersonal
		,ROW_NUMBER() OVER (PARTITION BY RelReferenciasPersonales ORDER BY IdReferenciaPersonal DESC)
		FROM dbo.tSCSpersonasFisicasReferencias r  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = r.IdEstatusActual
				AND ea.IdEstatus=1
		WHERE r.EsBeneficiario=1
		GROUP BY
		 r.RelReferenciasPersonales
		,r.IdReferenciaPersonal

		-- SELECT COUNT(1) FROM @Beneficiarios

		INSERT INTO @pivot
		SELECT 
		pt.RelReferenciasPersonales
		,[Beneficiario1]	= ISNULL(pt.[1],0)
		,[Beneficiario2]	= ISNULL(pt.[2],0)
		,[Beneficiario3]	= ISNULL(pt.[3],0)
		,[Beneficiario4]	= ISNULL(pt.[4],0)
		,[Beneficiario5]	= ISNULL(pt.[5],0)
		,[Beneficiario6]	= ISNULL(pt.[6],0)
		FROM (
			SELECT b.RelReferenciasPersonales, b.IdReferenciaPersonal, b.Orden
			FROM @Beneficiarios b 
		) AS Source
		PIVOT
		(
			max(IdReferenciaPersonal)
			FOR Orden
			IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])
		) AS pt

		RETURN
END
GO

