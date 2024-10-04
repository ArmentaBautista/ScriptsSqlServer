
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCTLvalidarLimitesMetodoPago')
BEGIN
	DROP FUNCTION dbo.fnCTLvalidarLimitesMetodoPago
	SELECT 'fnCTLvalidarLimitesMetodoPago BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnCTLvalidarLimitesMetodoPago(
@IdMetodoPago AS INT,
@IdRecurso AS INT,
@IdTipoOperacion AS INT,
@IdTipoSubOperacion AS INT,
@Monto AS NUMERIC(12,2)
)
RETURNS BIT
BEGIN
	DECLARE @resultado AS BIT=0;

	DECLARE @lmp AS TABLE
	(
		IdLimitesMetodosPago int,
		IdMetodoPago int,
		IdRecurso INT,
		IdTipoOperacion INT,
		IdTipoSubOperacion INT,
		LimiteInferior NUMERIC(12,2),
		LimiteSuperior NUMERIC(12,2)
	)

	INSERT @lmp
	SELECT lmp.IdLimitesMetodosPago,lmp.IdMetodoPago,lmp.IdRecurso,lmp.IdTipoOperacion,lmp.IdTipoSubOperacion, lmp.LimiteInferior, lmp.LimiteSuperior
	FROM dbo.tCTLlimitesMetodosPago lmp  WITH(NOLOCK)  WHERE lmp.IdEstatus=1

	IF NOT EXISTS(SELECT 1 FROM @lmp lmp 
					WHERE lmp.IdMetodoPago=@IdMetodoPago
					AND lmp.IdRecurso=@IdRecurso
					AND lmp.IdTipoOperacion=@IdTipoOperacion
					AND lmp.IdTipoSubOperacion=@IdTipoSubOperacion)
	BEGIN
		SET @resultado=1;
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM @lmp lmp  
					WHERE lmp.IdMetodoPago=@IdMetodoPago
					AND lmp.IdRecurso=@IdRecurso
					AND lmp.IdTipoOperacion=@IdTipoOperacion
					AND lmp.IdTipoSubOperacion=@IdTipoSubOperacion
					AND @Monto BETWEEN lmp.LimiteInferior AND lmp.LimiteSuperior
					)
			SET @resultado=1;
		ELSE	
			SET @resultado=0;
	END

	RETURN @resultado
END
GO