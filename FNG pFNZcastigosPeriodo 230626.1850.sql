
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pFNZcastigosPeriodo')
BEGIN
	DROP PROC pFNZcastigosPeriodo
	SELECT 'pFNZcastigosPeriodo BORRADO' AS info
END
GO

create PROCEDURE [dbo].[pFNZcastigosPeriodo] 
		@Codigo AS VARCHAR(50) = ''
AS
BEGIN
    
	DECLARE @Inicio AS DATE,
        @Fin AS DATE;
SELECT @Inicio = Inicio,
       @Fin = Fin
FROM tCTLperiodos
WHERE Codigo = @Codigo;

SELECT Fecha,
       Concepto,
       [Socio] = s.Codigo + ' - ' + p.Nombre,
       [Cuenta] = c.Codigo + ' - ' + c.Descripcion,
       [Dias Mora] = DiasMora,
       CapitalCastigado,
       [Capital Castigado Vencido] = CapitalCastigadoVencido,
       [Interes Ordinario Castigado] = InteresOrdinarioCastigado,
       [Interes Ordinario Castigado Vencido] = InteresOrdinarioCastigadoVencido,
       [Interes Moratorio Castigado] = InteresMoratorioCastigado,
       [Interes Moratorio Castigado Vencido] = InteresMoratorioCastigadoVencido,
       Total = (CapitalCastigado + CapitalCastigadoVencido + InteresOrdinarioCastigado
                + InteresOrdinarioCastigadoVencido + InteresMoratorioCastigado + InteresMoratorioCastigadoVencido
               ),
       Nosocio = s.Codigo,
       Nombre = pf.Nombre,
       ApellidoPaterno = pf.ApellidoPaterno,
       ApellidoMaterno = pf.ApellidoMaterno,
       NoCuenta = c.Codigo,
       Producto = c.Descripcion
FROM vSDOtransaccionesFinancierasISNULL tf
    INNER JOIN tAYCcuentas c WITH (NOLOCK)
        ON tf.IdCuenta = c.IdCuenta
           AND tf.IdEstatus = 1
    INNER JOIN tSCSsocios s WITH (NOLOCK)
        ON s.IdSocio = c.IdSocio
    INNER JOIN tGRLpersonas p WITH (NOLOCK)
        ON p.IdPersona = s.IdPersona
    LEFT JOIN dbo.tGRLpersonasFisicas pf WITH (NOLOCK)
        ON pf.IdPersona = p.IdPersona
WHERE tf.IdTipoSubOperacion = 14
      AND tf.Fecha
      BETWEEN @Inicio AND @Fin;


END;










GO

