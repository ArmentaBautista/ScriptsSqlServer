



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnAYCpivotDatosBeneficiarios')
BEGIN
	DROP FUNCTION dbo.fnAYCpivotDatosBeneficiarios
	SELECT 'fnAYCpivotDatosBeneficiarios BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnAYCpivotDatosBeneficiarios()
RETURNS @Pivot TABLE(
 RelReferenciasPersonales		INT 
,[Beneficiario1]				INT
,[B1Parentesco]					VARCHAR(250)
,[B1Nombre]						VARCHAR(250)
,[B1AP]							VARCHAR(30)
,[B1AM]							VARCHAR(30)
,[B1porcentaje]					NUMERIC(3,2)
,[Beneficiario2]				INT
,[B2Parentesco]					VARCHAR(250)
,[B2Nombre]						VARCHAR(250)
,[B2AP]							VARCHAR(30)
,[B2AM]							VARCHAR(30)
,[B2porcentaje]					NUMERIC(3,2)
,[Beneficiario3]				INT
,[B3Parentesco]					VARCHAR(250)
,[B3Nombre]						VARCHAR(250)
,[B3AP]							VARCHAR(30)
,[B3AM]							VARCHAR(30)
,[B3porcentaje]					NUMERIC(3,2)
,[Beneficiario4]				INT
,[B4Parentesco]					VARCHAR(250)
,[B4Nombre]						VARCHAR(250)
,[B4AP]							VARCHAR(30)
,[B4AM]							VARCHAR(30)
,[B4porcentaje]					NUMERIC(3,2)
,[Beneficiario5]				INT
,[B5Parentesco]					VARCHAR(250)
,[B5Nombre]						VARCHAR(250)
,[B5AP]							VARCHAR(30)
,[B5AM]							VARCHAR(30)
,[B5porcentaje]					NUMERIC(3,2)
,[Beneficiario6]				INT
,[B6Parentesco]					VARCHAR(250)
,[B6Nombre]						VARCHAR(250)
,[B6AP]							VARCHAR(30)
,[B6AM]							VARCHAR(30)
,[B6porcentaje]					NUMERIC(3,2)
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

	INSERT INTO @Pivot
	(
		RelReferenciasPersonales,
		Beneficiario1,
		Beneficiario2,
		Beneficiario3,
		Beneficiario4,
		Beneficiario5,
		Beneficiario6
	)
	SELECT  *
	FROM dbo.fnAYCpivotBeneficiarios()


	DECLARE @ref TABLE(
	IdReferenciaPersonal			INT PRIMARY KEY,
	RelReferenciasPersonales		INT,
	IdPersona						INT,
	IdTipoD							INT,
	PorcentajeBeneficiario			NUMERIC(3,2),
	Nombre							VARCHAR(80),
	ApellidoPaterno					VARCHAR(30),
	Apellidomaterno					VARCHAR(30),
	Parentesco						VARCHAR(250)
	, INDEX ixrel (RelReferenciasPersonales)
	, INDEX ixper (IdPersona)
	)

	INSERT INTO @ref
	SELECT 
	ref.IdReferenciaPersonal,
	ref.RelReferenciasPersonales,
	ref.IdPersona,
	ref.IdTipoD,
	ref.PorcentajeBeneficiario,
	pf.Nombre,
	pf.ApellidoPaterno,
	pf.ApellidoMaterno,
	td.Descripcion
	FROM dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = ref.IdEstatusActual
			AND ea.IdEstatus=1
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
		ON pf.IdPersonaFisica=ref.IdPersona
	INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) 
		ON td.IdTipoD = ref.IdTipoD
	WHERE ref.EsBeneficiario=1


	UPDATE p SET p.B1Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B1Nombre=r.Nombre, p.B1AP=r.ApellidoPaterno, p.B1AM=r.Apellidomaterno, p.B1porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario1
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario1<>0

	UPDATE p SET p.B2Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B2Nombre=r.Nombre, p.B2AP=r.ApellidoPaterno, p.B2AM=r.Apellidomaterno, p.B2porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario2
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario2<>0

	UPDATE p SET p.B3Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B3Nombre=r.Nombre, p.B3AP=r.ApellidoPaterno, p.B3AM=r.Apellidomaterno, p.B3porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario3
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario3<>0

	UPDATE p SET p.B4Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B4Nombre=r.Nombre, p.B4AP=r.ApellidoPaterno, p.B4AM=r.Apellidomaterno, p.B4porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario4
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario4<>0

	UPDATE p SET p.B5Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B5Nombre=r.Nombre, p.B5AP=r.ApellidoPaterno, p.B5AM=r.Apellidomaterno, p.B5porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario5
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario5<>0

	UPDATE p SET p.B6Parentesco=ISNULL(pa.ClaveParentesco,'ZOTR'),p.B6Nombre=r.Nombre, p.B6AP=r.ApellidoPaterno, p.B6AM=r.Apellidomaterno, p.B6porcentaje=r.PorcentajeBeneficiario
	FROM @Pivot p 
	INNER JOIN  @ref r 
		ON r.IdReferenciaPersonal = p.Beneficiario6
	LEFT JOIN tASEMEXparentescos pa  WITH(NOLOCK) 
		ON pa.IdTipoDparentesco=r.IdTipoD
	WHERE p.Beneficiario6<>0

	RETURN
END
GO

