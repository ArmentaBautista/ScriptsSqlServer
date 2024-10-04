
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnCNToperacionesDepositoAhorro')
BEGIN
	DROP PROC pCnCNToperacionesDepositoAhorro
	SELECT 'pCnCNToperacionesDepositoAhorro BORRADO' AS info
END
GO

CREATE PROC pCnCNToperacionesDepositoAhorro
	@FechaInicial AS DATE ='19000101',
	@FechaFinal AS DATE ='19000101'
AS
BEGIN
	SELECT 
	TipoOperacion=tpOperacion.Descripcion, 
	Folio=CONCAT(tpOperacion.Codigo,'-',oper.Folio) ,
	ISNULL(oper.Concepto,'') AS ConceptoOperacion,
	oper.Referencia AS ReferenciaOperacion,
	finan.Concepto,
	finan.Referencia,
	NumeroCuenta=cue.Codigo,
	Socio=soc.Codigo, 
	NombreSocio =per.Nombre,
	MontoMovimiento= finan.MontoSubOperacion,
	FechaMovimiento=finan.Fecha,
	Contabilizada=IIF(oper.IdPolizaE=0,'NO','SI')
	from dbo.tSDOtransaccionesFinancieras finan With(nolock) 
	INNER JOIN  dbo.tAYCcuentas cue With(nolock) ON cue.IdCuenta = finan.IdCuenta AND cue.IdTipoDProducto=144
	INNER JOIN dbo.tSCSsocios soc With(nolock) ON soc.IdSocio = cue.IdSocio
	INNER JOIN dbo.tGRLpersonas per With(nolock) ON per.IdPersona = soc.IdPersona
	INNER JOIN dbo.tGRLoperaciones oper With(nolock) ON oper.IdOperacion = finan.IdOperacion AND finan.IdTipoSubOperacion=500
	INNER JOIN dbo.tCTLtiposOperacion tpOperacion With(nolock) ON tpOperacion.IdTipoOperacion = oper.IdTipoOperacion
	WHERE oper.IdTipoOperacion NOT IN(4,20,18,42) 
		  AND oper.IdEstatus=1 AND oper.RequierePoliza=1 
		  AND (finan.Fecha BETWEEN @FechaInicial AND @FechaFinal)
END
 
GO

