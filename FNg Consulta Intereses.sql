

--SET STATISTICS IO ON 
-- SET STATISTICS TIME ON 

   declare @IdCuenta AS INT = 0, --1817055, -- 0 = Todas la Cuentas
    @IdSocio AS INT = 0,
    @FechaTrabajo AS DATE='20240812',
    @Decimales AS INT = 2,
    @CodigoOperacion AS VARCHAR(20) = 'DEVPAG'

DECLARE @cuentas TABLE
	(
		IdCuenta INT,
		FechaUltimoCalculo DATE,
		IdTipoDProducto INT,
		IdTipoDParcialidad INT,
		IdEstatusEntrega INT,
		FechaActivacion DATE,
		NumeroParcialidades INT,
		IdEstatus INT,
		IdSocio INT,
		IdApertura INT,
		IdProductoFinanciero INT,
		IdTipoDplanCastigo INT,
		SaldoCapital NUMERIC(18,2),
		TasaIva NUMERIC(18,2),
		Vencimiento DATE,
		InteresOrdinarioAnual NUMERIC(18,2),
		DiasTipoAnio INT,
		InteresMoratorioAnual NUMERIC(18,2),
		IdPeriodoUltimoCalculo INT,
		IdEstatusCartera INT

		INDEX IX_IdCuenta (IdCuenta)
	)

	INSERT INTO @cuentas
	SELECT IdCuenta,
           FechaUltimoCalculo,
           IdTipoDProducto,
           IdTipoDParcialidad,
           IdEstatusEntrega,
           FechaActivacion,
           NumeroParcialidades,
           IdEstatus,
           IdSocio,
           IdApertura,
           IdProductoFinanciero,
           IdTipoDplanCastigo,
           SaldoCapital,
           TasaIva,
           Vencimiento,
           InteresOrdinarioAnual,
           DiasTipoAnio,
           InteresMoratorioAnual,
           IdPeriodoUltimoCalculo,
           IdEstatusCartera 
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	WHERE c.IdEstatus=1
		AND c.IdTipoDProducto=143
			AND c.IdEstatusEntrega IN (20,27)
			 AND (
                       c.IdCuenta = @IdCuenta
                       OR @IdCuenta = 0
                   )

DECLARE @parcialidades TABLE(
	IdParcialidad INT PRIMARY KEY,
	IdCuenta int,
	Inicio date,
	IdEstatus int,
	IdApertura int,
	Capital numeric(18,2),
	CapitalPagado numeric(18,2),
	CapitalCondonado numeric(18,2),
	Orden int,
	Vencimiento date,
	Fin date,
	EstaPagada BIT,
	IdPeriodo int,
	PagadoInteresOrdinario DATE,
	InteresOrdinario numeric(18,2),
	InteresOrdinarioCuentasOrden numeric(18,2),
	InteresOrdinarioPagado numeric(18,2),
	InteresOrdinarioCondonado numeric(18,2),
	IVAInteresOrdinario numeric(18,2),
	IVAInteresOrdinarioPagado numeric(18,2),
	IVAInteresOrdinarioCondonado numeric(18,2),
	InteresMoratorio numeric(18,2),
	InteresMoratorioPagado numeric(18,2),
	InteresMoratorioCondonado numeric(18,2),
	IVAInteresMoratorio numeric(18,2),
	IVAInteresMoratorioPagado numeric(18,2),
	IVAInteresMoratorioCondonado numeric(18,2),
	InteresMoratorioCuentasOrden numeric(18,2),
	Ahorro numeric(18,2),
	Ahorrado numeric(18,2),
	SaldoCargo1 numeric(18,2),
	SaldoIVAcargo1 numeric(18,2),
	SaldoCargo2 numeric(18,2),
	SaldoIVAcargo2 numeric(18,2),
	SaldoCargo3 numeric(18,2),
	SaldoIVAcargo3 numeric(18,2),
	SaldoCargo4 numeric(18,2),
	SaldoIVAcargo4 numeric(18,2),
	SaldoCargo5 numeric(18,2),
	SaldoIVAcargo5 numeric(18,2),
	InteresOrdinarioCalculado numeric(18,2),
	NumeroParcialidad int,
	InteresOrdinarioEstimado numeric(18,2),
	UltimoCalculoInteresMoratorio date,
	FechaPago date,
	InteresMoratorioCalculado numeric(18,2),
	IVAInteresOrdinarioEstimado numeric(18,2)
)

INSERT INTO @parcialidades
SELECT 
p.IdParcialidad,
p.IdCuenta,
p.Inicio,
p.IdEstatus,
p.IdApertura,
p.Capital,
p.CapitalPagado,
p.CapitalCondonado,
p.Orden,
p.Vencimiento,
p.Fin,
p.EstaPagada,
p.IdPeriodo,
p.PagadoInteresOrdinario,
p.InteresOrdinario,
p.InteresOrdinarioCuentasOrden,
p.InteresOrdinarioPagado,
p.InteresOrdinarioCondonado,
p.IVAInteresOrdinario,
p.IVAInteresOrdinarioPagado,
p.IVAInteresOrdinarioCondonado,
p.InteresMoratorio,
p.InteresMoratorioPagado,
p.InteresMoratorioCondonado,
p.IVAInteresMoratorio,
p.IVAInteresMoratorioPagado,
p.IVAInteresMoratorioCondonado,
p.InteresMoratorioCuentasOrden,
p.Ahorro,
p.Ahorrado,
p.SaldoCargo1,
p.SaldoIVAcargo1,
p.SaldoCargo2,
p.SaldoIVAcargo2,
p.SaldoCargo3,
p.SaldoIVAcargo3,
p.SaldoCargo4,
p.SaldoIVAcargo4,
p.SaldoCargo5,
p.SaldoIVAcargo5,
p.InteresOrdinarioCalculado,
p.NumeroParcialidad,
p.InteresOrdinarioEstimado,
p.UltimoCalculoInteresMoratorio,
p.FechaPago,
p.InteresMoratorioCalculado,
p.IVAInteresOrdinarioEstimado
FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 	
INNER JOIN @cuentas c
	ON c.IdCuenta = p.IdCuenta
		AND c.IdApertura = p.IdApertura
			AND p.IdEstatus=1


    SELECT 
		   q.IdCuenta,
           q.IdSaldo,
           q.IdParcialidad,
           q.IdPeriodo,
           q.IdPeriodoJoin,
           q.InicioPeriodo,
           q.FinPeriodo,
           q.Inicio,
           q.Fin,
           IIF(IdTipoDParcialidad = 718,Fin,Vencimiento) Vencimiento,
           q.SaldoCapital,
           q.SaldoInteresOrdinario,
           q.SaldoIVAinteresOrdinario,
           q.SaldoInteresMoratorio,
           q.SaldoIVAinteresMoratorio,
           q.SaldoInteresOrdinarioEstimado,
           q.SaldoIVAinteresOrdinarioEstimado,
           q.SaldoInteresMoratorioEstimado,
           q.SaldoIVAinteresMoratorioEstimado,
           q.SaldoInteresOrdinarioCuentasOrden,
           q.SaldoIVAinteresOrdinarioCuentasOrden,
           q.SaldoInteresMoratorioCuentasOrden,
           q.SaldoIVAinteresMoratorioCuentasOrden,
           q.SaldoAhorro,
           q.SaldoCargo1,
           q.SaldoIVACargo1,
           q.SaldoCargo2,
           q.SaldoIVACargo2,
           q.SaldoCargo3,
           q.SaldoIVACargo3,
           q.SaldoCargo4,
           q.SaldoIVACargo4,
           q.SaldoCargo5,
           q.SaldoIVACargo5,
           q.EsExigible,
           q.DiasTranscurridos,
           q.InteresOrdinarioDiario,
           q.DiasParcialidad,
           q.InteresOrdinario,
           IVAinteresOrdinario = CASE
                                     WHEN q.Vencimiento
                                          BETWEEN q.InicioPeriodo AND q.FinPeriodoReal THEN
                                         q.IVAInteresOrdinario
                                         - (q.IVAinteresOrdinarioCalculado
                                            + SUM(q.IVAInteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo)
                                           )
                                         + (ROUND(
                                                     (q.InteresOrdinarioCalculado
                                                      + SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo)
                                                     )
                                                     * q.TasaIva,
                                                     @Decimales
                                                 )
                                           )
                                     ELSE
                                         q.IVAInteresOrdinario
                                 END,
                                         --InteresOrdinario = IIF( IdTipoDplanCastigo = 2140,InteresOrdinario,0) ,--q.idtipodparcialidad, 
                                         --IVAinteresOrdinario = IIF( IdTipoDplanCastigo = 2140,CASE WHEN q.Vencimiento BETWEEN q.InicioPeriodo
                                         --                                              AND
                                         --                                              q.FinPeriodoReal
                                         --                           THEN q.IVAInteresOrdinario
                                         --                                - ( q.IVAinteresOrdinarioCalculado
                                         --                                    + SUM(q.IVAInteresOrdinario) OVER ( PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo ) )
                                         --                                + ( ROUND(( q.InteresOrdinarioCalculado
                                         --                                            + SUM(q.InteresOrdinario) OVER ( PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo ) )
                                         --                                          * q.TasaIva,
                                         --                                          @Decimales) )
                                         --                           ELSE q.IVAInteresOrdinario
                                         --                      END,0) ,
                                         -- Inicia secci?n de columnas que hay que ocultar posteriormente
                                         --IVAInteresOrdinarioAnterior=q.IVAinteresOrdinario,
                                         --IVAinteresOrdinarioCalculadoAcumulado=q.IVAinteresOrdinarioCalculado+sum(q.IVAinteresOrdinario) over (Partition by q.IdParcialidad Order by q.IdParcialidad, IdPeriodo),
                                         --IVAinteresOrdinarioCalculadoTotalizado=round((q.InteresOrdinarioCalculado+sum(q.InteresOrdinario) over (Partition by q.IdParcialidad Order by q.IdParcialidad, IdPeriodo))*q.TasaIVA, @Decimales),	
                                         -- Termina secci?n de columnas que hay que ocultar posteriormente
           q.MoraMaxima,
           q.DiasMoraTotal,
           q.DiasMora,
           q.InteresMoratorioDiario,
           q.InteresMoratorio,
           IVAinteresMoratorio = CASE
                                     WHEN q.Vencimiento = q.FechaUltimoAtraso THEN
                                         q.IVAInteresMoratorio
                                         + - (q.SaldoIVAinteresMoratorioEstimado + q.SaldoIVAinteresMoratorio
                                              + SUM(q.IVAInteresMoratorio) OVER (PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo)
                                             )
                                         + (ROUND(
                                                     (q.SaldoInteresMoratorioEstimado + q.SaldoInteresMoratorio
                                                      + SUM(q.InteresMoratorio) OVER (PARTITION BY q.IdParcialidad ORDER BY q.IdParcialidad, q.IdPeriodo)
                                                     )
                                                     * q.TasaIva,
                                                     @Decimales
                                                 )
                                           )
                                     ELSE
                                         q.IVAInteresMoratorio
                                 END,
                                         -- Inicia secci?n de columnas que hay que ocultar posteriormente
                                         --IVAinteresMoratorioAnterior=q.IVAInteresMoratorio, 
                                         --IVAinteresMoratorioCalculadoAcumulado=q.SaldoIVAinteresMoratorioEstimado+SaldoIVAinteresMoratorio+sum(q.IVAinteresMoratorio) over (Order by IdParcialidad, IdPeriodo),
                                         --IVAinteresMoratorioCalculadoTotalizado=round((q.SaldoInteresMoratorioEstimado+q.SaldoInteresMoratorio+sum(q.InteresMoratorio) over (Order by IdParcialidad, IdPeriodo))*q.TasaIVA, @Decimales),
                                         --q.IVAinteresMoratorioCalculado,
                                         -- Termina secci?n de columnas que hay que ocultar posteriormente
           q.FechaVencido,
           DiasVencido = CASE
                             WHEN q.DiasVencido < 0
                                  OR
                                  (
                                      q.FechaVencido < q.FechaUltimoCalculo
                                      AND q.FechaVencido != '1900-01-01'
                                  ) THEN
                                 q.DiasTranscurridos
                             WHEN q.DiasVencido > q.DiasTranscurridos THEN
                                 q.DiasTranscurridos
                             ELSE
                                 q.DiasVencido
                         END,
           DiasMoraVencido = CASE
                                 WHEN q.CalcularMoratoriosBalance = 1 THEN
                                     CASE
                                         WHEN q.DiasMora >= q.DiasMoraVencido THEN
                                             q.DiasMoraVencido
                                         ELSE
                                             q.DiasMora
                                     END
                                 ELSE
                                     q.DiasMora
                             END,
           q.CalcularMoratoriosBalance,
           DiasMoraVencidox = q.DiasMoraVencido,

                                         --q.Devengado, 
                                         --q.IVAdevengado,
                                         --q.Pagado, 
                                         --q.DevengadoVencido, q.PagadoVencido,
           PendienteDevengar = q.InteresOrdinario + q.SaldoInteresOrdinarioEstimado
                               + IIF(
                                     AplicaAjuste = 1
                                     AND SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                     q.InteresOrdinarioEstimado
                                     - (q.InteresOrdinarioCalculado
                                        + SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden)
                                       ),
                                     0),
           IVApendienteDevengar = ROUND((q.InteresOrdinario + q.SaldoInteresOrdinarioEstimado) * q.TasaIva, @Decimales) --+IIF(q.IdParcialidad in(1110115), -0.01, 0)
                                  + IIF(
                                        AplicaAjuste = 1
                                        AND SUM(q.IVAInteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                        q.IVAInteresOrdinarioEstimado
                                        - (q.IVAinteresOrdinarioDevengado
                                           + SUM(ROUND(
                                                          (q.InteresOrdinario + q.SaldoInteresOrdinarioEstimado)
                                                          * q.TasaIva,
                                                          @Decimales
                                                      )
                                                ) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden)
                                          ),
                                        0),
           PendientePagar = q.InteresOrdinario + q.PendientePagar
                            + IIF(
                                  AplicaAjuste = 1
                                  AND SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                  q.InteresOrdinarioEstimado
                                  - (q.InteresOrdinarioPagado + q.InteresOrdinarioCondonado
                                     + SUM(q.InteresOrdinario + q.PendientePagar) OVER (PARTITION BY q.IdParcialidad ORDER BY q.AplicaAjuste)
                                    ),
                                  0),
           PendientePagarSinAjuste = q.InteresOrdinario + q.PendientePagar,
           AjustePendientePagar = IIF(AplicaAjuste = 1,
                                      q.InteresOrdinarioEstimado
                                      - (q.InteresOrdinarioPagado + q.InteresOrdinarioCondonado
                                         + SUM(q.InteresOrdinario + q.PendientePagar) OVER (PARTITION BY q.IdParcialidad ORDER BY q.AplicaAjuste)
                                        ),
                                      0),
           OverPartition = SUM(q.InteresOrdinario + q.SaldoInteresOrdinarioEstimado) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, q.FinPeriodo),
           IVApendientePagar = ROUND((q.InteresOrdinario + q.PendientePagar) * q.TasaIva, @Decimales) -- - IIF(q.IdParcialidad in(7038858), 0.01, 0)
                               + IIF(
                                     AplicaAjuste = 1
                                     AND SUM(q.IVAInteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                     q.IVAInteresOrdinarioEstimado
                                     - (q.IVAInteresOrdinarioPagado + q.IVAInteresOrdinarioCondonado
                                        + SUM(ROUND((q.InteresOrdinario + q.PendientePagar) * q.TasaIva, @Decimales)) OVER (PARTITION BY q.IdParcialidad ORDER BY q.AplicaAjuste)
                                       ),
                                     0), --+IIF(q.IdParcialidad in(0), 0.45, 0),
           PendienteDevengarVencido = ROUND(
                                               CASE
                                                   WHEN q.DiasVencido > 0
                                                        AND q.InteresOrdinario > 0 THEN
                                                       q.InteresOrdinario * q.DiasVencido / q.DiasTranscurridos
                                                       - q.DevengadoVencido
                                                   ELSE
                                                       0
                                               END,
                                               @Decimales
                                           ),
                                         /*PendienteDevengarVencido2=round(case 
										when DiasVencido>0 and q.InteresOrdinario>0 
										then InteresOrdinario* CASE 
																	WHEN DiasVencido < DiasTranscurridos 
																	THEN CAST(DiasVencido/DiasTranscurridos as numeric(23,8))
																	ELSE DiasVencido 
																END 
										else 0 
									end, @decimales),
	*/
           q.Orden,
                                         --PendPagAcu=sum(case when q.InteresOrdinario=0 then 0 else q.InteresOrdinario-q.Pagado-q.PagadoVencido end) over (Partition by IdParcialidad Order by IdParcialidad, IdPeriodo),
                                         --IVAacu=sum(q.IVAdevengado+ROUND((q.InteresOrdinario+q.SaldoInteresOrdinarioEstimado)*q.TasaIVA, @Decimales)) over (Partition by IdParcialidad Order by IdParcialidad, IdPeriodo),	
                                         --InteresOrdinarioPlan,
                                         --IVAinteresOrdinarioPlan,
                                         --AplicaAjuste=CASE WHEN q.Vencimiento between q.InicioPeriodo and q.FinPeriodo THEN 1 ELSE 0 END,
                                         --AjusteIVA=IVAinteresOrdinarioPlan-sum(q.IVAdevengado+ROUND((q.InteresOrdinario+q.SaldoInteresOrdinarioEstimado)*q.TasaIVA, @Decimales)) over (Partition by IdParcialidad Order by IdParcialidad, IdPeriodo),
           q.FechaUltimoAtraso,
           q.TasaIva,
           q.IdTipoDParcialidad,
           q.IdSocio,
           CapitalMasAtrasado = CASE
                                    WHEN q.Vencimiento = q.FechaPrimerAtraso THEN
                                        q.SaldoCapital
                                    ELSE
                                        0
                                END,
                                         -- Columnas temporales Ajuste Pagos Fijos
           q.AplicaAjuste,
           InteresOrdinarioCalculadoAcumulado = SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo),
           AjusteInteresOrdinarioPagosFijos = IIF(
                                                  AplicaAjuste = 1
                                                  AND SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                                  q.InteresOrdinarioEstimado
                                                  - (q.InteresOrdinarioCalculado
                                                     + SUM(q.InteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden)
                                                    ),
                                                  0),
           IVAInteresOrdinarioCalculadoAcumulado = SUM(ROUND(
                                                                (q.InteresOrdinario + q.SaldoInteresOrdinarioEstimado)
                                                                * q.TasaIva,
                                                                @Decimales
                                                            )
                                                      ) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo),
           AjusteIVAInteresOrdinarioPagosFijos = IIF(
                                                     AplicaAjuste = 1
                                                     AND SUM(q.IVAInteresOrdinario) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden, FinPeriodo) > 0.01,
                                                     q.IVAInteresOrdinarioEstimado
                                                     - (q.IVAinteresOrdinarioDevengado
                                                        + SUM(ROUND(
                                                                       (q.InteresOrdinario
                                                                        + q.SaldoInteresOrdinarioEstimado
                                                                       ) * q.TasaIva,
                                                                       @Decimales
                                                                   )
                                                             ) OVER (PARTITION BY q.IdParcialidad ORDER BY q.Orden)
                                                       ),
                                                     0),
           q.InteresOrdinarioCalculado,
           q.InteresOrdinarioEstimado,
           q.IVAInteresOrdinarioEstimado,
           q.IVAinteresOrdinarioDevengado,
           q.EstaPagada,
           DiasValidacionCalculo	
    FROM
    (
        SELECT cuenta.IdCuenta,
               ISNULL(s.IdSaldo, 0) AS IdSaldo,
               parcialidades.IdParcialidad,
               IdPeriodo = CASE
                               WHEN periodos.IdPeriodo > periodos.IdPeriodoTrabajo THEN
                                   periodos.IdPeriodoTrabajo
                               ELSE
                                   periodos.IdPeriodo
                           END,
               IdPeriodoJoin = periodos.IdPeriodo,
               periodos.Inicio AS InicioPeriodo,
               periodos.Fin AS FinPeriodo,
               parcialidades.Inicio,
               parcialidades.Fin,
               parcialidades.Vencimiento,
                                  --parcialidades.Fin,
                                  -- Columnas Validaci?n
                                  --p.NumeroParcialidad, p.Inicio, p.Fin, per.InicioPeriodo, per.FinPeriodo,
                                  -- c.IdPeriodoUltimoCalculo, c.IdPeriodoUltimoCierre, p.Inicio, p.Fin, per.Inicio as InicioCalculo, per.Fin as FinCalculo, p.UltimoCalculoInteresMoratorio, c.FechaUltimoCalculo, p.Capital, p.CapitalPagado, p.CapitalCondonado,
                                  -- Fin de Columnas de Validaci?n
               SaldoCapital = IIF(parcialidades.IdParcialidad = 0,
                                  0.00,
                                  CASE
                                      WHEN cuenta.FechaActivacion = @FechaTrabajo THEN
                                          0
                                      ELSE
                                          CASE
                                              WHEN (@FechaTrabajo
                                                   BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                   ) THEN
                                  (CASE
                                       WHEN parcialidades.CapitalPagado + parcialidades.CapitalCondonado > parcialidades.Capital THEN
                                           0
                                       ELSE
                                           parcialidades.Capital - parcialidades.CapitalPagado
                                           - parcialidades.CapitalCondonado
                                   END
                                  )
                                              ELSE
                                                  0
                                          END
                                  END),
               SaldoInteresOrdinario = CASE
               							   WHEN @FechaTrabajo BETWEEN parcialidades.Inicio AND DATEADD(DAY,pf.DiasPeriodoParaPago,parcialidades.Inicio) AND cuenta.IdTipoDParcialidad = 718 AND cuenta.SaldoCapital >0 THEN 
											0
                                           WHEN @FechaTrabajo
                                                BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                               parcialidades.InteresOrdinario - parcialidades.InteresOrdinarioPagado
                                               - parcialidades.InteresOrdinarioCondonado
                                           ELSE
                                               0
                                       END,
               SaldoIVAinteresOrdinario = CASE
               								  WHEN @FechaTrabajo BETWEEN parcialidades.Inicio AND DATEADD(DAY,pf.DiasPeriodoParaPago,parcialidades.Inicio) AND cuenta.IdTipoDParcialidad = 718 AND cuenta.SaldoCapital >0 THEN 
												0
                                              WHEN @FechaTrabajo
                                                   BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                  parcialidades.IVAInteresOrdinario
                                                  - parcialidades.IVAInteresOrdinarioPagado
                                                  - parcialidades.IVAInteresOrdinarioCondonado
                                              ELSE
                                                  0
                                          END,
               SaldoInteresMoratorio = CASE
                                           WHEN @FechaTrabajo
                                                BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                               parcialidades.InteresMoratorio - parcialidades.InteresMoratorioPagado
                                               - parcialidades.InteresMoratorioCondonado
                                           ELSE
                                               0
                                       END,
               SaldoIVAinteresMoratorio = CASE
                                              WHEN @FechaTrabajo
                                                   BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                  parcialidades.IVAInteresMoratorio
                                                  - parcialidades.IVAInteresMoratorioPagado
                                                  - parcialidades.IVAInteresMoratorioCondonado
                                              ELSE
                                                  0
                                          END,
               SaldoInteresOrdinarioEstimado = CASE
                                                   WHEN @FechaTrabajo
                                                        BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                       parcialidades.InteresOrdinarioCuentasOrden
                                                   ELSE
                                                       0
                                               END,
               SaldoIVAinteresOrdinarioEstimado = ROUND(
                                                           CASE
                                                               WHEN @FechaTrabajo
                                                                    BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                                   parcialidades.InteresOrdinarioCuentasOrden
                                                               ELSE
                                                                   0
                                                           END * cuenta.TasaIva,
                                                           @Decimales
                                                       ),
               SaldoInteresMoratorioEstimado = CASE
                                                   WHEN @FechaTrabajo
                                                        BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                       parcialidades.InteresMoratorioCuentasOrden
                                                   ELSE
                                                       0
                                               END,
               SaldoIVAinteresMoratorioEstimado = ROUND(
                                                           CASE
                                                               WHEN @FechaTrabajo
                                                                    BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                                   parcialidades.InteresMoratorioCuentasOrden
                                                               ELSE
                                                                   0
                                                           END * cuenta.TasaIva,
                                                           @Decimales
                                                       ),
               SaldoInteresOrdinarioCuentasOrden = CASE
                                                       WHEN @FechaTrabajo
                                                            BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                           parcialidades.InteresOrdinarioCuentasOrden
                                                       ELSE
                                                           0
                                                   END,
               SaldoIVAinteresOrdinarioCuentasOrden = ROUND(
                                                               CASE
                                                                   WHEN @FechaTrabajo
                                                                        BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                                       parcialidades.InteresOrdinarioCuentasOrden
                                                                   ELSE
                                                                       0
                                                               END * cuenta.TasaIva,
                                                               @Decimales
                                                           ),
               SaldoInteresMoratorioCuentasOrden = CASE
                                                       WHEN @FechaTrabajo
                                                            BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                           parcialidades.InteresMoratorioCuentasOrden
                                                       ELSE
                                                           0
                                                   END,
               SaldoIVAinteresMoratorioCuentasOrden = ROUND(
                                                               CASE
                                                                   WHEN @FechaTrabajo
                                                                        BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                                       parcialidades.InteresMoratorioCuentasOrden
                                                                   ELSE
                                                                       0
                                                               END * cuenta.TasaIva,
                                                               @Decimales
                                                           ),
               SaldoAhorro = CASE
                                 WHEN @FechaTrabajo
                                      BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                     parcialidades.Ahorro - parcialidades.Ahorrado
                                 ELSE
                                     0
                             END, -- Agregar la resta de lo ahorrado

                                  --saldo cargo 1
               SaldoCargo1 = CASE
                                 WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                     0
                                 ELSE
                                     CASE
                                         WHEN (@FechaTrabajo
                                              BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                              ) THEN
                                             parcialidades.SaldoCargo1
                                         ELSE
                                             0
                                     END
                             END,
               SaldoIVACargo1 = CASE
                                    WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                        0
                                    ELSE
                                        CASE
                                            WHEN (@FechaTrabajo
                                                 BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                 ) THEN
                                                parcialidades.SaldoIVAcargo1
                                            ELSE
                                                0
                                        END
                                END,

                                  --saldo cargo 2
               SaldoCargo2 = CASE
                                 WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                     0
                                 ELSE
                                     CASE
                                         WHEN (@FechaTrabajo
                                              BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                              ) THEN
                                             parcialidades.SaldoCargo2
                                         ELSE
                                             0
                                     END
                             END,
               SaldoIVACargo2 = CASE
                                    WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                        0
                                    ELSE
                                        CASE
                                            WHEN (@FechaTrabajo
                                                 BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                 ) THEN
                                                parcialidades.SaldoIVAcargo2
                                            ELSE
                                                0
                                        END
                                END,

                                  --saldo cargo 3
               SaldoCargo3 = CASE
                                 WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                     0
                                 ELSE
                                     CASE
                                         WHEN (@FechaTrabajo
                                              BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                              ) THEN
                                             parcialidades.SaldoCargo3
                                         ELSE
                                             0
                                     END
                             END,
               SaldoIVACargo3 = CASE
                                    WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                        0
                                    ELSE
                                        CASE
                                            WHEN (@FechaTrabajo
                                                 BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                 ) THEN
                                                parcialidades.SaldoIVAcargo3
                                            ELSE
                                                0
                                        END
                                END,

                                  --saldo cargo 4
               SaldoCargo4 = CASE
                                 WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                     0
                                 ELSE
                                     CASE
                                         WHEN (@FechaTrabajo
                                              BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                              ) THEN
                                             parcialidades.SaldoCargo4
                                         ELSE
                                             0
                                     END
                             END,
               SaldoIVACargo4 = CASE
                                    WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                        0
                                    ELSE
                                        CASE
                                            WHEN (@FechaTrabajo
                                                 BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                 ) THEN
                                                parcialidades.SaldoIVAcargo4
                                            ELSE
                                                0
                                        END
                                END,

                                  --saldo cargo 5
               SaldoCargo5 = CASE
                                 WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                     0
                                 ELSE
                                     CASE
                                         WHEN (@FechaTrabajo
                                              BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                              ) THEN
                                             parcialidades.SaldoCargo5
                                         ELSE
                                             0
                                     END
                             END,
               SaldoIVACargo5 = CASE
                                    WHEN parcialidades.Inicio = @FechaTrabajo THEN
                                        0
                                    ELSE
                                        CASE
                                            WHEN (@FechaTrabajo
                                                 BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo
                                                 ) THEN
                                                parcialidades.SaldoIVAcargo5
                                            ELSE
                                                0
                                        END
                                END,
               PendientePagar = ROUND(
                                         CASE
                                             WHEN @FechaTrabajo
                                                  BETWEEN periodos.InicioPeriodo AND periodos.FinPeriodo THEN
                                                 parcialidades.InteresOrdinarioCalculado
                                                 - parcialidades.InteresOrdinarioPagado
                                                 - parcialidades.InteresOrdinarioCondonado
                                             ELSE
                                                 0
                                         END,
                                         @Decimales
                                     ),
                                  --EsExigible=CAST(CASE WHEN @FechaTrabajo between per.InicioPeriodo AND per.FinPeriodo AND p.Inicio < per.Fin THEN 1 ELSE 0 END as bit),
                                  --EsExigible=CAST(CASE WHEN @FechaTrabajo between per.InicioPeriodo AND per.FinPeriodo AND p.Inicio < @FechaTrabajo THEN 1 ELSE 0 END as bit),
               EsExigible = CAST(CASE
                                     WHEN @FechaTrabajo <= periodos.FinPeriodo
                                          AND parcialidades.Inicio < @FechaTrabajo THEN
                                         1
                                     ELSE
                                         0
                                 END AS BIT),
               DiasTranscurridos = CASE
									   WHEN cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion = 'DEV' THEN
											DATEDIFF(DAY, IIF(cuenta.fechaultimocalculo >= parcialidades.Vencimiento AND parcialidades.InteresOrdinarioEstimado = parcialidades.InteresOrdinario,parcialidades.Fin,cuenta.FechaUltimoCalculo), @FechaTrabajo)
                                        
										WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.NumeroParcialidad = cuenta.numeroParcialidades AND parcialidades.Vencimiento < @FechaTrabajo AND cuenta.fechaultimocalculo <= parcialidades.Vencimiento AND @CodigoOperacion <> 'Dev'
											THEN DATEDIFF(DAY,parcialidades.Fin,@FechaTrabajo)

                                       WHEN NOT (
                                                    @CodigoOperacion = 'DEVPAG'
                                                    AND cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                                                    AND @FechaTrabajo < periodos.FinPeriodo
                                                    AND parcialidades.Inicio < @FechaTrabajo
                                                )
                                            AND
                                            (
                                                @FechaTrabajo < parcialidades.Inicio
                                                OR @FechaTrabajo <= cuenta.FechaUltimoCalculo
                                                --OR periodos.IdPeriodo < cuenta.IdPeriodoUltimoCalculo
                                                OR cuenta.FechaUltimoCalculo > @FechaTrabajo
                                            ) THEN
                                           0         -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                       WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                            AND parcialidades.Inicio < cuenta.Vencimiento
                                            AND parcialidades.Vencimiento < cuenta.Vencimiento THEN
                                           0
                                       WHEN cuenta.Vencimiento = parcialidades.Fin
                                            --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                            AND cuenta.Vencimiento < @FechaTrabajo THEN
                                           DATEDIFF(
                                                       DAY,
                                                       CASE
                                                           WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                               cuenta.FechaUltimoCalculo
                                                           ELSE
                                                               parcialidades.Inicio
                                                       END,
                                                       @FechaTrabajo
                                                   ) -- Es la ?ltima parcialidad
                                       WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                            AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                           DATEDIFF(
                                                       DAY,
                                                       CASE
                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                               parcialidades.Inicio
                                                           ELSE
                                                               cuenta.FechaUltimoCalculo
                                                       END,
                                                       parcialidades.Fin
                                                   ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                       WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                           DATEDIFF(
                                                       DAY,
                                                       CASE
                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                               parcialidades.Inicio
                                                           ELSE
                                                               cuenta.FechaUltimoCalculo
                                                       END,
                                                       @FechaTrabajo
                                                   ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                       WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                           DATEDIFF(
                                                       d,
                                                       CASE
                                                           WHEN cuenta.FechaUltimoCalculo
                                                                BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                               cuenta.FechaUltimoCalculo
                                                           ELSE
                                                               parcialidades.Inicio
                                                       END,
                                                       parcialidades.Fin
                                                   ) --La Parcialidad est? dentro del periodo de c?lculo
                                       WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                           DATEDIFF(DAY, cuenta.FechaUltimoCalculo, @FechaTrabajo)
									   WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                            AND @FechaTrabajo > parcialidades.Vencimiento AND cuenta.IdTipoDParcialidad = 718 AND parcialidades.NumeroParcialidad = cuenta.NumeroParcialidades THEN
                                           DATEDIFF(DAY, cuenta.FechaUltimoCalculo, @FechaTrabajo)
                                       ELSE
                                           0
                                   END,
               InteresOrdinarioDiario = cuenta.SaldoCapital * cuenta.InteresOrdinarioAnual / cuenta.DiasTipoAnio,
               DiasParcialidad = DATEDIFF(d, parcialidades.Inicio, parcialidades.Fin),
               InteresOrdinario = ROUND(
                                           CASE
											   WHEN cuenta.IdTipoDParcialidad IN (718) AND @FechaTrabajo BETWEEN parcialidades.Inicio AND DATEADD(DAY,pf.DiasPeriodoParaPago,parcialidades.Inicio) AND @CodigoOperacion = 'DevPag' AND parcialidades.numeroparcialidad <> 1  AND cuenta.SaldoCapital >0
													THEN 0
                                               WHEN cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                                                    AND
                                                    (
                                                        parcialidades.Fin < cuenta.Vencimiento
                                                        OR (parcialidades.Fin = cuenta.Vencimiento
                                                           --AND @FechaTrabajo <= parcialidades.Fin --se comento para considerar y topar el estimado de las parcialidades para pagos fijos y tipo de calculo FNG
                                                           )
                                                    ) THEN
                                                   CASE
                                                       WHEN @CodigoOperacion = 'Dev' THEN -- Pagos Fijos (Solo Devengamiento)
                                                           CASE
                                                               -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                                               WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                                    AND parcialidades.Inicio < cuenta.Vencimiento
                                                                    AND
                                                                    (
                                                                        parcialidades.Vencimiento < cuenta.Vencimiento
                                                                        OR cuenta.FechaUltimoCalculo > parcialidades.Vencimiento
                                                                    ) THEN
                                                                   0
                                                               WHEN cuenta.Vencimiento = parcialidades.Fin
                                                                    --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                    AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                                   DATEDIFF(
                                                                               DAY,
                                                                               CASE
                                                                                   WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                       cuenta.FechaUltimoCalculo
                                                                                   ELSE
                                                                                       parcialidades.Inicio
                                                                               END,
                                                                               --@FechaTrabajo --se comento para considerar y topar el estimado de las parcialidades para pagos fijos y tipo de calculo FNG
                                                                               parcialidades.Fin
                                                                           ) -- Es la ?ltima parcialidad
                                                               WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                                    AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                                    AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                   DATEDIFF(
                                                                               DAY,
                                                                               CASE
                                                                                   WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                       parcialidades.Inicio
                                                                                   ELSE
                                                                                       cuenta.FechaUltimoCalculo
                                                                               END,
                                                                               parcialidades.Fin
                                                                           ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                               WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                                    AND @FechaTrabajo < parcialidades.Fin THEN
                                                                   DATEDIFF(
                                                                               DAY,
                                                                               CASE
                                                                                   WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                       parcialidades.Inicio
                                                                                   ELSE
                                                                                       cuenta.FechaUltimoCalculo
                                                                               END,
                                                                               @FechaTrabajo
                                                                           ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                               WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                                    AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                   DATEDIFF(
                                                                               d,
                                                                               CASE
                                                                                   WHEN cuenta.FechaUltimoCalculo
                                                                                        BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                       cuenta.FechaUltimoCalculo
                                                                                   ELSE
                                                                                       parcialidades.Inicio
                                                                               END,
                                                                               parcialidades.Fin
                                                                           ) --La Parcialidad est? dentro del periodo de c?lculo
                                                               WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                    AND @FechaTrabajo < parcialidades.Fin THEN
                                                                   DATEDIFF(
                                                                               DAY,
                                                                               cuenta.FechaUltimoCalculo,
                                                                               @FechaTrabajo
                                                                           )
                                                               ELSE
                                                                   0
                                                           END * parcialidades.InteresOrdinarioEstimado
                                                           / DATEDIFF(d, parcialidades.Inicio, parcialidades.Fin)
                                                       WHEN @CodigoOperacion = 'DevPag' THEN -- Pagos Fijos (Devengamiento y Pago)
                                                           CASE
                                                               WHEN @FechaTrabajo > parcialidades.Inicio
                                                                    AND cuenta.FechaUltimoCalculo < periodos.Fin THEN
                                                                   CASE -- D?as considerados en la Parcialidad de acuerdo al Plan de Pagos
                                                                       --WHEN @FechaTrabajo < p.Inicio OR @FechaTrabajo <= per.Inicio OR per.IdPeriodo<c.IdPeriodoUltimoCalculo OR c.FechaUltimoCalculo > per.Fin  THEN 0 -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                                                       --WHEN c.Vencimiento=p.Fin AND p.Inicio < per.Inicio THEN datediff(d,CASE WHEN c.FechaUltimoCalculo between per.Inicio and per.Fin THEN c.FechaUltimoCalculo ELSE per.Inicio END, per.Fin) --Es la ?ltima parcialidad del plan de pago
                                                                       WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                                            AND parcialidades.Inicio < cuenta.Vencimiento
                                                                            AND
                                                                            (
                                                                                parcialidades.Vencimiento < cuenta.Vencimiento
                                                                                OR cuenta.FechaUltimoCalculo > parcialidades.Vencimiento
                                                                            ) THEN
                                                                           0
                                                                       WHEN cuenta.Vencimiento = parcialidades.Fin
                                                                            --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                            AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                                           DATEDIFF(
                                                                                       DAY,
                                                                                       CASE
                                                                                           WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                               cuenta.FechaUltimoCalculo
                                                                                           ELSE
                                                                                               parcialidades.Inicio
                                                                                       END,
                                                                                       parcialidades.Fin
                                                                                   ) -- Es la ?ltima parcialidad
                                                                       WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                                            AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                           DATEDIFF(
                                                                                       DAY,
                                                                                       CASE
                                                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                               parcialidades.Inicio
                                                                                           ELSE
                                                                                               cuenta.FechaUltimoCalculo
                                                                                       END,
                                                                                       parcialidades.Fin
                                                                                   ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                                       WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                                                           DATEDIFF(
                                                                                       DAY,
                                                                                       CASE
                                                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                               parcialidades.Inicio
                                                                                           ELSE
                                                                                               cuenta.FechaUltimoCalculo
                                                                                       END,
                                                                                       @FechaTrabajo
                                                                                   ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                                       WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                           DATEDIFF(
                                                                                       d,
                                                                                       CASE
                                                                                           WHEN cuenta.FechaUltimoCalculo
                                                                                                BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                               cuenta.FechaUltimoCalculo
                                                                                           ELSE
                                                                                               parcialidades.Inicio
                                                                                       END,
                                                                                       parcialidades.Fin
                                                                                   ) --La Parcialidad est? dentro del periodo de c?lculo
                                                                       WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                                                           DATEDIFF(
                                                                                       DAY,
                                                                                       cuenta.FechaUltimoCalculo,
                                                                                       @FechaTrabajo
                                                                                   )
                                                                       ELSE
                                                                           0
                                                                   END * parcialidades.InteresOrdinarioEstimado
                                                                   / DATEDIFF(
                                                                                 d,
                                                                                 parcialidades.Inicio,
                                                                                 parcialidades.Fin
                                                                             )
                                                               ELSE
                                                                   0
                                                           END
                                                       ELSE
                                                           0
                                                   END
                                               ELSE
                                                   CASE 
														WHEN parcialidades.Vencimiento < @FechaTrabajo --AND cuenta.fechaultimocalculo > parcialidades.Vencimiento
														      AND cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion <> 'DEV' THEN
														      DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo)
 
														WHEN cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion = 'DEV' AND  parcialidades.NumeroParcialidad <> 1  THEN
														       DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo) --DATEDIFF(DAY, IIF( parcialidades.InteresOrdinarioEstimado = parcialidades.InteresOrdinario + parcialidades.InteresOrdinarioCuentasOrden,parcialidades.Fin,cuenta.FechaUltimoCalculo), @FechaTrabajo)        
																
														WHEN cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion = 'DEV' AND  parcialidades.NumeroParcialidad = 1 THEN
														        DATEDIFF(DAY, IIF( parcialidades.InteresOrdinarioEstimado = parcialidades.InteresOrdinario + parcialidades.InteresOrdinarioCuentasOrden,cuenta.FechaUltimoCalculo,cuenta.FechaUltimoCalculo), @FechaTrabajo) 

                                                       WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                            AND parcialidades.Inicio < cuenta.Vencimiento
                                                            AND parcialidades.Vencimiento < cuenta.Vencimiento THEN
                                                           0
                                                       WHEN cuenta.Vencimiento = parcialidades.Fin
                                                            --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                            AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                           DATEDIFF(
                                                                       DAY,
                                                                       CASE
                                                                           WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                               cuenta.FechaUltimoCalculo
                                                                           ELSE
                                                                               parcialidades.Inicio
                                                                       END,
                                                                       @FechaTrabajo
                                                                   ) -- Es la ?ltima parcialidad
                                                       WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                            AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                                           DATEDIFF(
                                                                       DAY,
                                                                       CASE
                                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                               parcialidades.Inicio
                                                                           ELSE
                                                                               cuenta.FechaUltimoCalculo
                                                                       END,
                                                                       parcialidades.Fin
                                                                   ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                       WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                                           DATEDIFF(
                                                                       DAY,
                                                                       CASE
                                                                           WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                               parcialidades.Inicio
                                                                           ELSE
                                                                               cuenta.FechaUltimoCalculo
                                                                       END,
                                                                       @FechaTrabajo
                                                                   ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                       WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                            AND parcialidades.Fin <= @FechaTrabajo THEN
                                                           DATEDIFF(
                                                                       d,
                                                                       CASE
                                                                           WHEN cuenta.FechaUltimoCalculo
                                                                                BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                               cuenta.FechaUltimoCalculo
                                                                           ELSE
                                                                               parcialidades.Inicio
                                                                       END,
                                                                       parcialidades.Fin
                                                                   ) --La Parcialidad est? dentro del periodo de c?lculo
                                                       WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                            AND @FechaTrabajo < parcialidades.Fin THEN
                                                           DATEDIFF(DAY, cuenta.FechaUltimoCalculo, @FechaTrabajo)
                                                       ELSE
                                                           0
                                                   END * cuenta.SaldoCapital * cuenta.InteresOrdinarioAnual
                                                   / cuenta.DiasTipoAnio
                                           END,
                                           @Decimales
                                       ) - IIF(parcialidades.IdParcialidad = 9593421,0.01,0),
               IVAInteresOrdinario = ROUND(
                                              CASE
												  WHEN cuenta.IdTipoDParcialidad IN (718) AND @FechaTrabajo BETWEEN parcialidades.Inicio AND DATEADD(DAY,pf.DiasPeriodoParaPago,parcialidades.Inicio) AND @CodigoOperacion = 'DevPag' AND parcialidades.numeroparcialidad <> 1  AND cuenta.SaldoCapital >0
													THEN 0
                                                  WHEN cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                                                       AND
                                                       (
                                                           parcialidades.Fin < cuenta.Vencimiento
                                                           OR (parcialidades.Fin = cuenta.Vencimiento
                                                              --AND @FechaTrabajo <= parcialidades.Fin
                                                              )
                                                       ) THEN
                                                      CASE
                                                          WHEN @CodigoOperacion = 'Dev' THEN -- Pagos Fijos (Solo Devengamiento)
                                                              CASE
                                                                  -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                                                  WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                                       AND parcialidades.Inicio < cuenta.Vencimiento
                                                                       AND
                                                                       (
                                                                           parcialidades.Vencimiento < cuenta.Vencimiento
                                                                           OR cuenta.FechaUltimoCalculo > parcialidades.Vencimiento
                                                                       ) THEN
                                                                      0
                                                                  WHEN cuenta.Vencimiento = parcialidades.Fin
                                                                       --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                       AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                                      DATEDIFF(
                                                                                  DAY,
                                                                                  CASE
                                                                                      WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                          cuenta.FechaUltimoCalculo
                                                                                      ELSE
                                                                                          parcialidades.Inicio
                                                                                  END,
                                                                                  parcialidades.Fin
                                                                              ) -- Es la ?ltima parcialidad
                                                                  WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                                       AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                                       AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                      DATEDIFF(
                                                                                  DAY,
                                                                                  CASE
                                                                                      WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                          parcialidades.Inicio
                                                                                      ELSE
                                                                                          cuenta.FechaUltimoCalculo
                                                                                  END,
                                                                                  parcialidades.Fin
                                                                              ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                                  WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                                       AND @FechaTrabajo < parcialidades.Fin THEN
                                                                      DATEDIFF(
                                                                                  DAY,
                                                                                  CASE
                                                                                      WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                          parcialidades.Inicio
                                                                                      ELSE
                                                                                          cuenta.FechaUltimoCalculo
                                                                                  END,
                                                                                  @FechaTrabajo
                                                                              ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                                  WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                                       AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                      DATEDIFF(
                                                                                  d,
                                                                                  CASE
                                                                                      WHEN cuenta.FechaUltimoCalculo
                                                                                           BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                          cuenta.FechaUltimoCalculo
                                                                                      ELSE
                                                                                          parcialidades.Inicio
                                                                                  END,
                                                                                  parcialidades.Fin
                                                                              ) --La Parcialidad est? dentro del periodo de c?lculo
                                                                  WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                       AND @FechaTrabajo < parcialidades.Fin THEN
                                                                      DATEDIFF(
                                                                                  DAY,
                                                                                  cuenta.FechaUltimoCalculo,
                                                                                  @FechaTrabajo
                                                                              )
                                                                  ELSE
                                                                      0
                                                              END * parcialidades.InteresOrdinarioEstimado
                                                              / DATEDIFF(d, parcialidades.Inicio, parcialidades.Fin)
                                                          WHEN @CodigoOperacion = 'DevPag' THEN -- Pagos Fijos (Devengamiento y Pago)
                                                              CASE
                                                                  WHEN @FechaTrabajo > parcialidades.Inicio
                                                                       AND cuenta.FechaUltimoCalculo < periodos.Fin THEN
                                                                      CASE -- D?as considerados en la Parcialidad de acuerdo al Plan de Pagos
                                                                          --WHEN @FechaTrabajo < p.Inicio OR @FechaTrabajo <= per.Inicio OR per.IdPeriodo<c.IdPeriodoUltimoCalculo OR c.FechaUltimoCalculo > per.Fin  THEN 0 -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                                                          --WHEN c.Vencimiento=p.Fin AND p.Inicio < per.Inicio THEN datediff(d,CASE WHEN c.FechaUltimoCalculo between per.Inicio and per.Fin THEN c.FechaUltimoCalculo ELSE per.Inicio END, per.Fin) --Es la ?ltima parcialidad del plan de pago
                                                                          WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                                               AND parcialidades.Inicio < cuenta.Vencimiento
                                                                               AND
                                                                               (
                                                                                   parcialidades.Vencimiento < cuenta.Vencimiento
                                                                                   OR cuenta.FechaUltimoCalculo > parcialidades.Vencimiento
                                                                               ) THEN
                                                                              0
                                                                          WHEN cuenta.Vencimiento = parcialidades.Fin
                                                                               --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                               AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                                              DATEDIFF(
                                                                                          DAY,
                                                                                          CASE
                                                                                              WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                                  cuenta.FechaUltimoCalculo
                                                                                              ELSE
                                                                                                  parcialidades.Inicio
                                                                                          END,
                                                                                          parcialidades.Fin
                                                                                      ) -- Es la ?ltima parcialidad
                                                                          WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                                               AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                                               AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                              DATEDIFF(
                                                                                          DAY,
                                                                                          CASE
                                                                                              WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                                  parcialidades.Inicio
                                                                                              ELSE
                                                                                                  cuenta.FechaUltimoCalculo
                                                                                          END,
                                                                                          parcialidades.Fin
                                                                                      ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                                          WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                                               AND @FechaTrabajo < parcialidades.Fin THEN
                                                                              DATEDIFF(
                                                                                          DAY,
                                                                                          CASE
                                                                                              WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                                  parcialidades.Inicio
                                                                                              ELSE
                                                                                                  cuenta.FechaUltimoCalculo
                                                                                          END,
                                                                                          @FechaTrabajo
                                                                                      ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                                          WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                                               AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                              DATEDIFF(
                                                                                          d,
                                                                                          CASE
                                                                                              WHEN cuenta.FechaUltimoCalculo
                                                                                                   BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                                  cuenta.FechaUltimoCalculo
                                                                                              ELSE
                                                                                                  parcialidades.Inicio
                                                                                          END,
                                                                                          parcialidades.Fin
                                                                                      ) --La Parcialidad est? dentro del periodo de c?lculo
                                                                          WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                               AND @FechaTrabajo < parcialidades.Fin THEN
                                                                              DATEDIFF(
                                                                                          DAY,
                                                                                          cuenta.FechaUltimoCalculo,
                                                                                          @FechaTrabajo
                                                                                      )
                                                                          ELSE
                                                                              0
                                                                      END * parcialidades.InteresOrdinarioEstimado
                                                                      / DATEDIFF(
                                                                                    d,
                                                                                    parcialidades.Inicio,
                                                                                    parcialidades.Fin
                                                                                )
                                                                  ELSE
                                                                      0
                                                              END
                                                          ELSE
                                                              0
                                                      END
                                                  ELSE
                                                      CASE
                                                        WHEN parcialidades.Vencimiento < @FechaTrabajo AND cuenta.fechaultimocalculo > parcialidades.Vencimiento
														        AND cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion <> 'DEV' THEN
														        DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo)
														  
														WHEN parcialidades.Vencimiento < @FechaTrabajo AND cuenta.Vencimiento < @FechaTrabajo
														      AND cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion <> 'DEV' THEN
														      DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo)

														WHEN cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion = 'DEV' AND  parcialidades.NumeroParcialidad <> 1  THEN
														        DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo)--DATEDIFF(DAY, IIF( parcialidades.InteresOrdinarioEstimado = parcialidades.InteresOrdinario + parcialidades.InteresOrdinarioCuentasOrden,parcialidades.Fin,cuenta.FechaUltimoCalculo), @FechaTrabajo)        
																
														WHEN cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad AND @CodigoOperacion = 'DEV' AND  parcialidades.NumeroParcialidad = 1 THEN
														        DATEDIFF(DAY, IIF( parcialidades.InteresOrdinarioEstimado = parcialidades.InteresOrdinario + parcialidades.InteresOrdinarioCuentasOrden,cuenta.FechaUltimoCalculo,cuenta.FechaUltimoCalculo), @FechaTrabajo) 

                                                        WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin AND parcialidades.Inicio < cuenta.Vencimiento
                                                               AND parcialidades.Vencimiento < cuenta.Vencimiento THEN
                                                              0
                                                              
														WHEN cuenta.Vencimiento = parcialidades.Fin
                                                               --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                               AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                              DATEDIFF(
                                                                          DAY,
                                                                          CASE
                                                                              WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                  cuenta.FechaUltimoCalculo
                                                                              ELSE
                                                                                  parcialidades.Inicio
                                                                          END,
                                                                          @FechaTrabajo
                                                                      ) -- Es la ?ltima parcialidad
                                                          WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                               AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                               AND parcialidades.Fin <= @FechaTrabajo THEN
                                                              DATEDIFF(
                                                                          DAY,
                                                                          CASE
                                                                              WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                  parcialidades.Inicio
                                                                              ELSE
                                                                                  cuenta.FechaUltimoCalculo
                                                                          END,
                                                                          parcialidades.Fin
                                                                      ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                          WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                               AND @FechaTrabajo < parcialidades.Fin THEN
                                                              DATEDIFF(
                                                                          DAY,
                                                                          CASE
                                                                              WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                  parcialidades.Inicio
                                                                              ELSE
                                                                                  cuenta.FechaUltimoCalculo
                                                                          END,
                                                                          @FechaTrabajo
                                                                      ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                          WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                               AND parcialidades.Fin <= @FechaTrabajo THEN
                                                              DATEDIFF(
                                                                          d,
                                                                          CASE
                                                                              WHEN cuenta.FechaUltimoCalculo
                                                                                   BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                  cuenta.FechaUltimoCalculo
                                                                              ELSE
                                                                                  parcialidades.Inicio
                                                                          END,
                                                                          parcialidades.Fin
                                                                      ) --La Parcialidad est? dentro del periodo de c?lculo
                                                          WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                               AND @FechaTrabajo < parcialidades.Fin THEN
                                                              DATEDIFF(DAY, cuenta.FechaUltimoCalculo, @FechaTrabajo)

														  WHEN parcialidades.Vencimiento < @FechaTrabajo AND cuenta.fechaultimocalculo <= parcialidades.Vencimiento
                                                            AND cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad THEN
                                                            DATEDIFF(DAY, IIF(@FechaTrabajo <= parcialidades.Vencimiento,@FechaTrabajo,parcialidades.Fin), @FechaTrabajo)
														 
														  WHEN parcialidades.Vencimiento < @FechaTrabajo AND cuenta.fechaultimocalculo > parcialidades.Vencimiento
																 AND cuenta.idTipoDparcialidad = 718 AND cuenta.NumeroParcialidades = parcialidades.NumeroParcialidad THEN
																 DATEDIFF(DAY, cuenta.fechaultimocalculo, @FechaTrabajo)

                                                          ELSE
                                                              0
                                                      END * cuenta.SaldoCapital * cuenta.InteresOrdinarioAnual
                                                      / cuenta.DiasTipoAnio
                                              END * cuenta.TasaIva,
                                              @Decimales
                                          )  + IIF(parcialidades.IdParcialidad IN ( 6385408 ), 0.02, 0),
               t.MoraMaxima,
               DiasMoraTotal = CASE
                                   WHEN @FechaTrabajo <= parcialidades.UltimoCalculoInteresMoratorio
               --OR p.EstaPagada = 1 
               THEN
                                       0
                                   ELSE
                                       DATEDIFF(d, parcialidades.UltimoCalculoInteresMoratorio, @FechaTrabajo)
                               END,
               DiasMora = CASE
							  WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.Vencimiento >= @FechaTrabajo
							  THEN 0
                              	WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.Vencimiento < @FechaTrabajo
									THEN
										DATEDIFF(DAY,
													IIF(parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Vencimiento,
														 parcialidades.UltimoCalculoInteresMoratorio,
														 parcialidades.Vencimiento),@FechaTrabajo)
                                WHEN parcialidades.Fin < @FechaTrabajo AND cuenta.IdTipoDParcialidad <> 718 THEN
                                     DATEDIFF(DAY,
                                                  IIF(parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Fin,
                                                      parcialidades.UltimoCalculoInteresMoratorio,
                                                      parcialidades.Fin),@FechaTrabajo)
                              ELSE
                                  0
                          END,
               InteresMoratorioDiario = (CASE
                                             WHEN parcialidades.CapitalPagado + parcialidades.CapitalCondonado > parcialidades.Capital THEN
                                                 0
                                             ELSE
                                                 parcialidades.Capital - parcialidades.CapitalPagado
                                                 - parcialidades.CapitalCondonado
                                         END
                                        ) * cuenta.InteresMoratorioAnual / cuenta.DiasTipoAnio,
               InteresMoratorio = IIF(
                                      parcialidades.IdParcialidad = ISNULL(primeraVencida.IdParcialidad, 0)
                                      AND DATEDIFF(DAY, parcialidades.Vencimiento, @FechaTrabajo) <= 30
                                      AND graciaMoratorio.AplicarDiasGraciaMoratorio = 1,
                                      0,
                                      ROUND(
                                               CASE
												   WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.Vencimiento >= @FechaTrabajo
													THEN 0
                                                   WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.Vencimiento < @FechaTrabajo
																	THEN
																	   DATEDIFF(
																				   DAY,
																				   IIF(
																					   parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Vencimiento,
																					   parcialidades.UltimoCalculoInteresMoratorio,
																					   parcialidades.Vencimiento),
																				   @FechaTrabajo
																			   )
                                                   WHEN parcialidades.Fin < @FechaTrabajo AND cuenta.IdTipoDParcialidad <> 718 THEN
                                                       DATEDIFF(
                                                                   DAY,
                                                                   IIF(
                                                                       parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Fin,
                                                                       parcialidades.UltimoCalculoInteresMoratorio,
                                                                       parcialidades.Fin),
                                                                   @FechaTrabajo
                                                               )
                                                   ELSE
                                                       0
                                               END * cuenta.InteresMoratorioAnual / DiasTipoAnio
                                               * (CASE
                                                      WHEN parcialidades.CapitalPagado + parcialidades.CapitalCondonado > parcialidades.Capital THEN
                                                          0
                                                      ELSE
                                                          parcialidades.Capital - parcialidades.CapitalPagado
                                                          - parcialidades.CapitalCondonado
                                                  END
                                                 ),
                                               @Decimales
                                           )),
               IVAInteresMoratorio = ROUND(
                                              IIF(
                                                  parcialidades.IdParcialidad = ISNULL(primeraVencida.IdParcialidad, 0)
                                                  AND DATEDIFF(DAY, parcialidades.Vencimiento, @FechaTrabajo) <= 30
                                                  AND graciaMoratorio.AplicarDiasGraciaMoratorio = 1,
                                                  0,
                                                  ROUND(
                                                           CASE
															   WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.FechaPago >= @FechaTrabajo
																THEN 0
																WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.Vencimiento < @FechaTrabajo
																	THEN
																	   DATEDIFF(
																				   DAY,
																				   IIF(
																					   parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Vencimiento,
																					   parcialidades.UltimoCalculoInteresMoratorio,
																					   parcialidades.Vencimiento),
																				   @FechaTrabajo
																			   )
                                                               WHEN parcialidades.Fin < @FechaTrabajo AND cuenta.IdTipoDParcialidad <> 718 THEN
                                                                   DATEDIFF(
                                                                               DAY,
                                                                               IIF(
                                                                                   parcialidades.UltimoCalculoInteresMoratorio > parcialidades.Fin,
                                                                                   parcialidades.UltimoCalculoInteresMoratorio,
                                                                                   parcialidades.Fin),@FechaTrabajo)
                                                               ELSE
                                                                   0
                                                           END * cuenta.InteresMoratorioAnual / DiasTipoAnio
                                                           * (CASE
                                                                  WHEN parcialidades.CapitalPagado
                                                                       + parcialidades.CapitalCondonado > parcialidades.Capital THEN
                                                                      0
                                                                  ELSE
                                                                      parcialidades.Capital
                                                                      - parcialidades.CapitalPagado
                                                                      - parcialidades.CapitalCondonado
                                                              END
                                                             ),
                                                           @Decimales
                                                       )) * cuenta.TasaIva,
                                              @Decimales
                                          ),
               FechaVencido,
                                  /*DiasVencido=CASE WHEN t.FechaVencido < per.Fin and t.FechaVencido >'19000101'
						THEN 
							CASE 
								WHEN t.FechaVencido BETWEEN per.Inicio AND per.Fin THEN DATEDIFF(d,t.FechaVencido,per.Fin)+1
								ELSE DATEDIFF(d,per.Inicio,per.Fin) 
							END
						ELSE 0 END,*/
               DiasVencido = CASE
                                 WHEN t.FechaVencido > '19000101'
                                      AND parcialidades.Inicio < periodos.Fin
                                      AND CASE
                                              WHEN NOT (
                                                           @CodigoOperacion = 'DEVPAG'
                                                           AND cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                                                           AND @FechaTrabajo < periodos.FinPeriodo
                                                           AND parcialidades.Inicio < @FechaTrabajo
                                                       )
                                                   AND
                                                   (
                                                       @FechaTrabajo < parcialidades.Inicio
                                                       OR @FechaTrabajo <= periodos.Inicio
                                                       OR periodos.IdPeriodo < cuenta.IdPeriodoUltimoCalculo
                                                       OR cuenta.FechaUltimoCalculo > periodos.Fin
                                                   ) THEN
                                                  0                                                    -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                              WHEN cuenta.Vencimiento = parcialidades.Fin
                                                   AND parcialidades.Inicio < periodos.Inicio THEN
                                                  DATEDIFF(d, periodos.Inicio, periodos.Fin)           --Es la ?ltima parcialidad del plan de pago
                                              WHEN parcialidades.Inicio <= periodos.Inicio
                                                   AND periodos.Inicio <= parcialidades.Fin
                                                   AND parcialidades.Fin <= periodos.Fin THEN
                                                  DATEDIFF(d, periodos.Inicio, parcialidades.Fin)      -- El final de la parcialidad est? dentro del periodo de c?lculo
                                              WHEN periodos.Inicio <= parcialidades.Inicio
                                                   AND parcialidades.Inicio <= periodos.Fin
                                                   AND periodos.Fin <= parcialidades.Fin THEN
                                                  DATEDIFF(d, parcialidades.Inicio, periodos.Fin)      -- El inicio de la parcialidad est? dentro del periodo de c?lculo
                                              WHEN periodos.Inicio < parcialidades.Inicio
                                                   AND parcialidades.Fin <= periodos.Fin THEN
                                                  DATEDIFF(d, parcialidades.Inicio, parcialidades.Fin) --La Parcialidad est? dentro del periodo de c?lculo
                                              WHEN parcialidades.Inicio < periodos.Inicio
                                                   AND periodos.Fin < parcialidades.Fin THEN
                                                  DATEDIFF(d, periodos.Inicio, periodos.Fin)           --La Parcialidad abarca el periodo de c?lculo								
                                              ELSE
                                                  0
                                          END > 0 THEN
                                     CASE
                                         -- FechaVencido est? en el periodo de C?lculo
                                         WHEN t.FechaVencido > (CASE
                                                                    WHEN periodos.Inicio < parcialidades.Inicio THEN
                                                                        parcialidades.Inicio
                                                                    ELSE
                                                                        periodos.Inicio
                                                                END
                                                               )
                                              AND t.FechaVencido <= (CASE
                                                                         WHEN periodos.Fin > parcialidades.Fin
                                                                              AND parcialidades.Fin > periodos.Inicio THEN
                                                                             parcialidades.Fin
                                                                         ELSE
                                                                             periodos.Fin
                                                                     END
                                                                    ) THEN
                                             DATEDIFF(
                                                         d,
                                                         t.FechaVencido,
                                                         CASE
                                                             WHEN periodos.Fin > parcialidades.Fin
                                                                  AND parcialidades.Fin > periodos.Inicio THEN
                                                                 parcialidades.Fin
                                                             ELSE
                                                                 periodos.Fin
                                                         END
                                                     ) + 1
                                         -- FechaVencido est? en un periodo de C?lculo anterior								
                                         ELSE
                                             DATEDIFF(   d,
                                                         CASE
                                                             WHEN periodos.Inicio < parcialidades.Inicio THEN
                                                                 parcialidades.Inicio
                                                             ELSE
                                                                 periodos.Inicio
                                                         END,
                                                         CASE
                                                             WHEN periodos.Fin > parcialidades.Fin THEN
                                                                 parcialidades.Fin
                                                             ELSE
                                                                 periodos.Fin
                                                         END
                                                     )
                                     END
                                 ELSE
                                     0
                             END,
               DiasMoraVencido = CASE
									 WHEN cuenta.IdTipoDParcialidad = 718 AND parcialidades.FechaPago <= @FechaTrabajo
									 THEN 0
                                     WHEN t.FechaVencido > @FechaTrabajo
                                          OR parcialidades.Fin > @FechaTrabajo
                                          OR t.FechaVencido > periodos.Fin
                                          OR t.FechaVencido = '19000101'
                                          OR periodos.Fin <= parcialidades.UltimoCalculoInteresMoratorio
                                          OR periodos.InicioPeriodo > @FechaTrabajo
                                          OR parcialidades.EstaPagada = 1
                                          OR periodos.Fin <= parcialidades.Fin THEN
                                         0
                                     ELSE
                                         CASE
                                             -- Es el periodo de la Fecha de Trabajo
                                             WHEN periodos.Inicio <= @FechaTrabajo
                                                  AND @FechaTrabajo <= periodos.Fin
                                                  AND periodos.Inicio <= parcialidades.Fin
                                                  AND parcialidades.Fin <= periodos.Fin THEN -- Vence dentro del periodo
                                                 CASE
                                                     WHEN t.FechaVencido <= parcialidades.Fin THEN
                                                         DATEDIFF(d, parcialidades.Fin, @FechaTrabajo)
                                                     ELSE
                                                         DATEDIFF(d, DATEADD(d, -1, t.FechaVencido), @FechaTrabajo)
                                                 END
                                             WHEN periodos.Inicio <= @FechaTrabajo
                                                  AND @FechaTrabajo <= periodos.Fin
                                                  AND parcialidades.Fin < periodos.Inicio THEN -- Vence antes del periodo
                                                 CASE
                                                     WHEN t.FechaVencido <= periodos.Inicio THEN
                                                         DATEDIFF(d, periodos.Inicio, @FechaTrabajo)
                                                     ELSE
                                                         DATEDIFF(d, DATEADD(d, -1, t.FechaVencido), @FechaTrabajo)
                                                 END
                                             -- Es periodo anterior a la Fecha de Trabajo
                                             WHEN periodos.Inicio <= parcialidades.Fin
                                                  AND parcialidades.Fin <= periodos.Fin THEN -- Vence dentro del periodo	
                                                 CASE
                                                     WHEN t.FechaVencido <= parcialidades.Fin THEN
                                                         DATEDIFF(d, parcialidades.Fin, periodos.Fin)
                                                     ELSE
                                                         DATEDIFF(d, DATEADD(d, -1, t.FechaVencido), periodos.Fin)
                                                 END
                                             WHEN parcialidades.Fin < periodos.Inicio THEN
                                                 CASE
                                                     WHEN t.FechaVencido <= periodos.Inicio THEN
                                                         DATEDIFF(d, periodos.Inicio, periodos.Fin)
                                                     ELSE
                                                         DATEDIFF(d, DATEADD(d, -1, t.FechaVencido), periodos.Fin)
                                                 END

                                             /*
								WHEN per.Inicio < @FechaTrabajo and @FechaTrabajo <= per.Fin AND per.Inicio < t.FechaVencido and t.FechaVencido <= per.Fin THEN datediff(d,t.FechaVencido, @FechaTrabajo) -- Vencido dentro del periodo
								WHEN per.Inicio < @FechaTrabajo and @FechaTrabajo <= per.Fin AND t.FechaVencido <= per.Inicio THEN datediff(d,per.Inicio, @FechaTrabajo) -- Vencido antes del periodo
								-- Es periodo anterior a la Fecha de Trabajo
								WHEN per.Inicio < t.FechaVencido and t.FechaVencido <= per.Fin THEN datediff(d,t.FechaVencido, per.Fin) -- Vencido dentro del periodo								
								WHEN t.FechaVencido < per.Inicio THEN datediff(d,per.Inicio, per.Fin) -- Vencido antes del periodo											
								*/
                                         END
                                 END,
                                  --Deprecated IdEstatusCartera=case when c.IdEstatusCartera=29 then c.IdEstatusCartera when FechaVencido > '1900-01-01' then 29 else 28 end,
                                  --Deprecated InteresOrdinarioCuotasFijas=ROUND(CASE  
                                  --						WHEN @FechaTrabajo < p.Inicio OR @FechaTrabajo <= per.Inicio OR per.IdPeriodo<c.IdPeriodoUltimoCalculo OR c.FechaUltimoCalculo > per.Fin  THEN 0 -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                  --						WHEN p.Inicio <= @FechaTrabajo THEN p.InteresOrdinarioEstimado -- El inicio de la parcialidad es menor a la Fecha de Trabajo
                                  --						WHEN c.Vencimiento=p.Fin AND p.Inicio < per.Inicio and @FechaTrabajo>p.Fin THEN c.SaldoCapital*c.InteresOrdinarioAnual/c.DiasTipoAnio --Es la ?ltima parcialidad del plan de pago y ya se venci?
                                  --						ELSE 0 END, @Decimales),
               IdEstatusCartera = CASE
                                      WHEN cuenta.IdEstatusCartera = 29
                                           AND FechaVencido = '19000101' THEN
                                          NULL
                                      WHEN cuenta.IdEstatusCartera = 29
                                           OR FechaVencido <> '19000101' THEN
                                          29
                                      ELSE
                                          28
                                  END,
                                  /* Comentado para pruebas
		Devengado=isnull(PD.Devengado,0),
		Pagado=isnull(PD.Pagado,0),
		DevengadoVencido=isnull(PD.DevengadoVencido,0),
		PagadoVencido=isnull(PD.PagadoVencido,0),
		*/
                                  --Devengado=p.InteresOrdinario,
                                  --IVAdevengado=p.IVAinteresOrdinario,
               InteresOrdinarioCalculado = parcialidades.InteresOrdinarioCalculado,
               InteresMoratorioCalculado = parcialidades.InteresMoratorioCalculado,
               IVAinteresOrdinarioCalculado = ROUND(
                                                       parcialidades.InteresOrdinarioCalculado * cuenta.TasaIva,
                                                       @Decimales
                                                   ),
               IVAinteresMoratorioCalculado = ROUND(
                                                       parcialidades.InteresMoratorioCalculado * cuenta.TasaIva,
                                                       @Decimales
                                                   ),
                                  --Pagado=p.InteresOrdinarioPagado+p.InteresOrdinarioCondonado,
               DevengadoVencido = ISNULL(PD.DevengadoVencido, 0),
               PagadoVencido = ISNULL(PD.PagadoVencido, 0),
               cuenta.TasaIva,
               InteresOrdinarioPlan = parcialidades.InteresOrdinarioEstimado,
               IVAinteresOrdinarioPlan = parcialidades.IVAInteresOrdinarioEstimado,
               periodos.FinPeriodoReal,
               FechaUltimoAtraso = ISNULL(   MAX(CASE
                                                     WHEN parcialidades.Fin < @FechaTrabajo THEN
                                                         parcialidades.Fin
                                                     ELSE
                                                         '19000101'
                                                 END
                                                ) OVER (PARTITION BY cuenta.IdCuenta
                                                        ORDER BY parcialidades.IdParcialidad DESC
                                                       ),
                                             '19000101'
                                         ),
               FechaPrimerAtraso = ISNULL(   MIN(CASE
                                                     WHEN parcialidades.Fin < @FechaTrabajo THEN
                                                         parcialidades.Fin
                                                     ELSE
                                                         '19000101'
                                                 END
                                                ) OVER (PARTITION BY cuenta.IdCuenta
                                                        ORDER BY parcialidades.IdParcialidad DESC
                                                       ),
                                             '19000101'
                                         ),
               parcialidades.Orden,
               cuenta.IdTipoDParcialidad,
               cuenta.FechaUltimoCalculo,
               cuenta.IdSocio,
                                  --AplicaAjuste = IIF(
                                  --                   cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                                  --                   AND
                                  --                   (
                                  --                       parcialidades.Fin < cuenta.Vencimiento
                                  --                       OR @FechaTrabajo <= parcialidades.Fin
                                  --                   )
                                  --                   AND periodos.Inicio < parcialidades.Fin
                                  --                   AND parcialidades.Fin <= periodos.Fin
                                  --                   AND parcialidades.Inicio < @FechaTrabajo
                                  --                   AND cuenta.FechaUltimoCalculo < @FechaTrabajo
                                  --                   AND
                                  --                   (
                                  --                       @CodigoOperacion = 'DevPag'
                                  --                       OR
                                  --                       (
                                  --                           @CodigoOperacion = 'Dev'
                                  --                           AND parcialidades.Fin = periodos.Fin
                                  --                       )
                                  --                   ),
                                  --                   1,
                                  --                   0),

               AplicaAjuste = 0,
               parcialidades.InteresOrdinarioEstimado,
               parcialidades.IVAInteresOrdinarioEstimado,
               IVAinteresOrdinarioDevengado = parcialidades.IVAInteresOrdinario,
               parcialidades.InteresOrdinarioPagado,
               parcialidades.InteresOrdinarioCondonado,
               parcialidades.IVAInteresOrdinarioPagado,
               parcialidades.IVAInteresOrdinarioCondonado,
               parcialidades.EstaPagada,
               parcialidades.UltimoCalculoInteresMoratorio,
               empresa.CalcularMoratoriosBalance,
               cuenta.IdTipoDplanCastigo,
               DiasValidacionCalculo = (CASE
                                            WHEN @CodigoOperacion = 'DevPag' THEN -- Pagos Fijos (Devengamiento y Pago)
                                                CASE
                                                    WHEN @FechaTrabajo > parcialidades.Inicio
                                                         AND cuenta.FechaUltimoCalculo < periodos.Fin THEN
                                                        CASE -- D?as considerados en la Parcialidad de acuerdo al Plan de Pagos
                                                            --WHEN @FechaTrabajo < p.Inicio OR @FechaTrabajo <= per.Inicio OR per.IdPeriodo<c.IdPeriodoUltimoCalculo OR c.FechaUltimoCalculo > per.Fin  THEN 0 -- La Fecha de Trabajo es menor al inicio de la parcialidad o la Fecha de Trabajo es menor al inicio del periodo o El periodo ya fue calculado
                                                            --WHEN c.Vencimiento=p.Fin AND p.Inicio < per.Inicio THEN datediff(d,CASE WHEN c.FechaUltimoCalculo between per.Inicio and per.Fin THEN c.FechaUltimoCalculo ELSE per.Inicio END, per.Fin) --Es la ?ltima parcialidad del plan de pago
                                                            WHEN cuenta.FechaUltimoCalculo >= parcialidades.Fin
                                                                 AND parcialidades.Inicio < cuenta.Vencimiento
                                                                 AND parcialidades.Vencimiento < cuenta.Vencimiento THEN
                                                                0
                                                            WHEN cuenta.Vencimiento = parcialidades.Fin
                                                                 --AND parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                 AND cuenta.Vencimiento < @FechaTrabajo THEN
                                                                DATEDIFF(
                                                                            DAY,
                                                                            CASE
                                                                                WHEN cuenta.FechaUltimoCalculo > parcialidades.Inicio THEN
                                                                                    cuenta.FechaUltimoCalculo
                                                                                ELSE
                                                                                    parcialidades.Inicio
                                                                            END,
                                                                            parcialidades.Fin
                                                                        ) -- Es la ?ltima parcialidad
                                                            WHEN parcialidades.Inicio <= cuenta.FechaUltimoCalculo
                                                                 AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                                                                 AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                DATEDIFF(
                                                                            DAY,
                                                                            CASE
                                                                                WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                    parcialidades.Inicio
                                                                                ELSE
                                                                                    cuenta.FechaUltimoCalculo
                                                                            END,
                                                                            parcialidades.Fin
                                                                        ) -- el final de la parcialidad se encuentra entre el periodo de calculo
                                                            WHEN cuenta.FechaUltimoCalculo <= parcialidades.Inicio
                                                                 AND @FechaTrabajo < parcialidades.Fin THEN
                                                                DATEDIFF(
                                                                            DAY,
                                                                            CASE
                                                                                WHEN parcialidades.Inicio > cuenta.FechaUltimoCalculo THEN
                                                                                    parcialidades.Inicio
                                                                                ELSE
                                                                                    cuenta.FechaUltimoCalculo
                                                                            END,
                                                                            @FechaTrabajo
                                                                        ) -- El Inicio de la parcialidad se encuentra entre el periodo de calculo
                                                            WHEN cuenta.FechaUltimoCalculo < parcialidades.Inicio
                                                                 AND parcialidades.Fin <= @FechaTrabajo THEN
                                                                DATEDIFF(
                                                                            d,
                                                                            CASE
                                                                                WHEN cuenta.FechaUltimoCalculo
                                                                                     BETWEEN parcialidades.Inicio AND parcialidades.Fin THEN
                                                                                    cuenta.FechaUltimoCalculo
                                                                                ELSE
                                                                                    parcialidades.Inicio
                                                                            END,
                                                                            parcialidades.Fin
                                                                        ) --La Parcialidad est? dentro del periodo de c?lculo
                                                            WHEN parcialidades.Inicio < cuenta.FechaUltimoCalculo
                                                                 AND @FechaTrabajo < parcialidades.Fin THEN
                                                                DATEDIFF(DAY, cuenta.FechaUltimoCalculo, @FechaTrabajo)
                                                            ELSE
                                                                0
                                                        END
                                                END
                                        END
                                       )
        FROM @cuentas cuenta 
			INNER JOIN  dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  
				ON pf.IdProductoFinanciero = cuenta.IdProductoFinanciero
            INNER JOIN dbo.tCTLempresas empresa WITH (NOLOCK)
                ON empresa.IdEmpresa = 1
            JOIN @parcialidades parcialidades
                ON cuenta.IdCuenta = parcialidades.IdCuenta
                   AND parcialidades.Inicio <= @FechaTrabajo
                   AND parcialidades.IdEstatus = 1
                   AND
                   (
                       cuenta.IdCuenta = @IdCuenta
                       OR @IdCuenta = 0
                   )
            LEFT JOIN
            (
                SELECT parcialidad.IdParcialidad,
                       Numero = ROW_NUMBER() OVER (PARTITION BY cuenta.IdCuenta ORDER BY parcialidad.Orden),
                       parcialidad.Vencimiento,
                       cuenta.IdCuenta
                FROM @cuentas cuenta 
                    INNER JOIN @parcialidades parcialidad
                        ON parcialidad.IdCuenta = cuenta.IdCuenta
                           AND parcialidad.IdApertura = cuenta.IdApertura
                           AND parcialidad.Capital - parcialidad.CapitalPagado - parcialidad.CapitalCondonado > 0 
                WHERE (
                          cuenta.IdCuenta = @IdCuenta
                          OR @IdCuenta = 0
                      )
            ) AS primeraVencida
                ON cuenta.IdCuenta = primeraVencida.IdCuenta
                   AND primeraVencida.Numero = 1
            CROSS JOIN
            (
                SELECT configuracion.AplicarDiasGraciaMoratorio
                FROM
                (
                    VALUES
                        (ISNULL(   TRY_CAST(
                                   (
                                       SELECT Valor FROM dbo.tCTLconfiguracion WHERE IdConfiguracion = 345
                                   ) AS BIT),
                                   0
                               )
                        )
                ) AS configuracion (AplicarDiasGraciaMoratorio) --configuraci?n que determina si se aplicaran dias de gracia al inter?s moratorio
            ) AS graciaMoratorio
            JOIN
            (
                SELECT cuenta.IdCuenta,
                       periodo.IdPeriodo,
                                                           --pa.IdPeriodo AS IdPeriodoTrabajo,
                       IdPeriodoTrabajo = periodo.IdPeriodo,
                                                           --dateadd(d,-1, p.Inicio) as Inicio, --
                                                           --Inicio=CASE WHEN c.IdPeriodoUltimoCalculo=p.IdPeriodo THEN c.FechaUltimoCalculo else dateadd(d,-1, p.Inicio) END, -- Condici?n requerida para Capital Fijo (pero oculta parcialidades de Pagos Fijos con saldo - Rev.)
                       Inicio = cuenta.FechaUltimoCalculo, -- Condici?n ajustada para calcular diferente en Pagos Fijos
                       Fin = @FechaTrabajo,
                       FinPeriodoReal = periodo.Fin,
                       InicioPeriodo = periodo.Inicio,
                       FinPeriodo = periodo.Fin
                FROM @cuentas cuenta 
                    JOIN tCTLperiodos periodo WITH (NOLOCK)
                        ON periodo.EsAjuste = 0
                           AND @FechaTrabajo
                           BETWEEN periodo.Inicio AND periodo.Fin
                WHERE (
                          cuenta.IdCuenta = @IdCuenta
                          OR @IdCuenta = 0
                      )
                      AND
                      (
                          cuenta.IdSocio = @IdSocio
                          OR @IdSocio = 0
                      )
            ) periodos
                ON cuenta.IdCuenta = periodos.IdCuenta
                   AND
                   (
                       periodos.Inicio <= parcialidades.Fin
                       OR periodos.Inicio <= @FechaTrabajo
                   )
                   AND
                   (
                       (
                           (
                               parcialidades.Inicio < periodos.Fin
                               OR periodos.IdPeriodo = periodos.IdPeriodoTrabajo
                           )
                           AND cuenta.IdTipoDParcialidad NOT IN ( 415, 2673 )
                           AND periodos.Inicio <= @FechaTrabajo
                       )
                       OR
                       --comentado temporalmente ((p.Inicio < per.Fin or per.IdPeriodo=per.IdPeriodoTrabajo) AND per.Inicio < p.Fin AND c.IdTipoDparcialidad=415)
                       (
                           (
                               parcialidades.Inicio < periodos.Fin
                               OR periodos.IdPeriodo = periodos.IdPeriodoTrabajo
                           ) --AND (p.Fin < per.Fin OR @FechaTrabajo < per.Fin) 
                           AND
                           (
                               periodos.Inicio < parcialidades.Fin
                               OR periodos.Inicio < @FechaTrabajo
                               OR parcialidades.EstaPagada = 0
                           )
                           AND cuenta.IdTipoDParcialidad IN ( 415, 2673 )
                       )
                   )
            JOIN dbo.ifAYCcalcularVencimientoCredito(@IdCuenta, @FechaTrabajo, NULL, NULL) t
                ON cuenta.IdCuenta = t.IdCuenta
            JOIN tSDOsaldos s WITH (NOLOCK)
                ON cuenta.IdCuenta = s.IdCuenta
            LEFT JOIN
            (
                SELECT IdPeriodo,
                       IdParcialidad,
                       Devengado = SUM(   CASE
                                              WHEN IdEstatusCartera = 28 THEN
                                                  Devengado
                                              ELSE
                                                  0
                                          END
                                      ),
                       Pagado = SUM(   CASE
                                           WHEN IdEstatusCartera = 28 THEN
                                               Pagado
                                           ELSE
                                               0
                                       END
                                   ),
                       DevengadoVencido = SUM(   CASE
                                                     WHEN IdEstatusCartera = 29 THEN
                                                         Devengado
                                                     ELSE
                                                         0
                                                 END
                                             ),
                       PagadoVencido = SUM(   CASE
                                                  WHEN IdEstatusCartera = 29 THEN
                                                      Pagado
                                                  ELSE
                                                      0
                                              END
                                          )
                FROM tSDOtransaccionesFinancierasD WITH (NOLOCK)
                WHERE IdEstatus = 1
                GROUP BY IdPeriodo,
                         IdParcialidad
            ) PD -- PagadoDevengado
                ON parcialidades.IdParcialidad = PD.IdParcialidad
                   AND parcialidades.IdPeriodo = PD.IdPeriodo
        WHERE 
              (
				  (cuenta.IdTipoDParcialidad = 718 AND parcialidades.Orden = cuenta.NumeroParcialidades AND parcialidades.EstaPagada = 1) OR
                  parcialidades.EstaPagada = 0
                  OR
                  (
                      parcialidades.EstaPagada = 1
                      AND cuenta.FechaUltimoCalculo <= parcialidades.Fin
                      AND @FechaTrabajo <= parcialidades.Fin
                  )
                  OR
                  (
                      parcialidades.EstaPagada = 1
                      AND cuenta.FechaUltimoCalculo < parcialidades.Fin
                  )
                  --seccion p?ra considerar las parcialidades que ya se pagaron por adelantado pero tiene dias pendientes de c?lculo
                  OR
                  (
                      parcialidades.EstaPagada = 1
                      AND parcialidades.Fin <= @FechaTrabajo
                      AND
                      (
                          parcialidades.PagadoInteresOrdinario < parcialidades.Fin
                          OR (parcialidades.InteresOrdinario + parcialidades.InteresOrdinarioCuentasOrden
                              - parcialidades.InteresOrdinarioPagado - parcialidades.InteresOrdinarioCondonado
                             ) > 0
                      )
                  --and p.IdCuenta = 997849
                  )
              )
              AND cuenta.FechaActivacion <= @FechaTrabajo
              AND parcialidades.Inicio <= @FechaTrabajo
    ) q

