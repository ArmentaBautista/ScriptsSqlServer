IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='ifAYCcalcularVencimientoCredito')
BEGIN
	DROP FUNCTION dbo.ifAYCcalcularVencimientoCredito
	SELECT 'ifAYCcalcularVencimientoCredito BORRADO' AS info
END
GO

CREATE FUNCTION dbo.ifAYCcalcularVencimientoCredito
(
	@IdCuenta			as int = 0,			-- 0 = Todas la Cuentas	
	@FechaTrabajo		as DATE = NULL,
	@PrimerVencimientoPendienteCapital as DATE = NULL,
	@PrimerVencimientoPendienteInteres as DATE = NULL
)

RETURNS TABLE
AS
RETURN
(
	select c.IdCuenta,
			c.PrimerVencimientoPendienteCapital,
			c.PrimerVencimientoPendienteInteres,
			DiasMoraCapital=CASE WHEN PrimerVencimientoPendienteCapital < @FechaTrabajo THEN DATEDIFF(d,c.PrimerVencimientoPendienteCapital, @FechaTrabajo) else 0 END, 
			DiasMoraInteres=CASE WHEN PrimerVencimientoPendienteInteres < @FechaTrabajo THEN DATEDIFF(d,c.PrimerVencimientoPendienteInteres, @FechaTrabajo) else 0 END,
		MoraMaxima= 
			CASE WHEN VencimientoPorInteres = 0 and c.IdTipoDParcialidad <> 458
			THEN
				CASE WHEN PrimerVencimientoPendienteCapital < @FechaTrabajo 
								THEN DATEDIFF(d,c.PrimerVencimientoPendienteCapital, @FechaTrabajo) 
								else 0 
				END--DATEDIFF(d,c.PrimerVencimientoPendienteCapital, @FechaTrabajo),
			WHEN VencimientoPorInteres = 1 or c.IdTipoDParcialidad = 458
				THEN
				CASE 
					WHEN PrimerVencimientoPendienteCapital < PrimerVencimientoPendienteInteres THEN
						CASE WHEN PrimerVencimientoPendienteCapital < @FechaTrabajo THEN DATEDIFF(d,c.PrimerVencimientoPendienteCapital, @FechaTrabajo) else 0 END
					ELSE
						CASE WHEN PrimerVencimientoPendienteInteres < @FechaTrabajo THEN DATEDIFF(d,c.PrimerVencimientoPendienteInteres, @FechaTrabajo) else 0 END
				END
			END,
			VencidoCapital=CASE WHEN t.Id is NULL THEN NULL WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN 1 else 0 END,
			VencidoInteres=CASE WHEN t.Id is NULL THEN NULL WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN 1 else 0 END,
			FechaVencidoCapital=CASE WHEN t.Id is NULL THEN NULL WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital)  else '19000101' END,
			FechaVencidoInteres=CASE WHEN t.Id is NULL THEN NULL WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END,
			FechaVencido=CASE
						WHEN t.Id is null THEN NULL
						WHEN c.IdEstatusCartera=29 THEN c.FechaVencida	--20140925					
						WHEN -- Si no ha vencido el Capital ni lo Intereses
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else '19000101' END =
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END
							and
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END =
							'19000101'
						THEN
							'19000101'
						WHEN -- Si venció primero el Capital
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else dateadd(d,1,@FechaTrabajo) END <= 
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else dateadd(d,1,@FechaTrabajo) END 
						THEN
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else '19000101' END
						WHEN -- Si venció primero el Interés
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else dateadd(d,1,@FechaTrabajo) END > 
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else dateadd(d,1,@FechaTrabajo) END 
						THEN
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END
						END,
			FechaVencidoCalculada=CASE
						WHEN t.Id is null THEN NULL						
						WHEN -- Si no ha vencido el Capital ni lo Intereses
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else '19000101' END =
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END
							and
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END =
							'19000101'
						THEN
							'19000101'
						WHEN -- Si venció primero el Capital
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else dateadd(d,1,@FechaTrabajo) END <= 
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else dateadd(d,1,@FechaTrabajo) END 
						THEN
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else '19000101' END
						WHEN -- Si venció primero el Interés
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo) >= t.DiasMoraCapital THEN dateadd(d,t.DiasMoraCapital,c.PrimerVencimientoPendienteCapital) else dateadd(d,1,@FechaTrabajo) END > 
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else dateadd(d,1,@FechaTrabajo) END 
						THEN
							CASE WHEN datediff(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo) >= t.DiasMoraInteres THEN dateadd(d,t.DiasMoraInteres,c.PrimerVencimientoPendienteInteres) else '19000101' END
						END,
            ExisteTablaVencimiento=CASE WHEN t.Id IS NULL THEN 0 ELSE 1 END
	from 
	(select cc.IdCuenta, cc.IdTipoDparcialidad, cc.IdEstatus, cc.IdTipoDProducto, cc.IdEstatusCartera, cc.FechaVencida,
		    PrimerVencimientoPendienteCapital=CASE WHEN @PrimerVencimientoPendienteCapital='1900-01-01' THEN NULL
												   ELSE ISNULL(@PrimerVencimientoPendienteCapital,cc.PrimerVencimientoPendienteCapital)
											  END,
			PrimerVencimientoPendienteInteres=CASE WHEN @PrimerVencimientoPendienteInteres='1900-01-01' THEN NULL
												   ELSE ISNULL(@PrimerVencimientoPendienteInteres, cc.PrimerVencimientoPendienteInteres)
											  END
	 from tAYCcuentas cc  WITH(NOLOCK)	
	 where cc.IdTipoDProducto=143 AND cc.IdEstatus in (1,53) AND (cc.IdCuenta=@IdCuenta or @IdCuenta=0)
	)
	c left join tTBLvencimientoCredito t WITH(NOLOCK)on c.idTipoDParcialidad=t.idTipoDParcialidad and @FechaTrabajo between t.InicioVigencia and t.FinVigencia
	cross join (SELECT CAST(Valor AS BIT) VencimientoPorInteres from dbo.tCTLconfiguracion WHERE IdConfiguracion = 260) vpi
)

GO

