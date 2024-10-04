
	DECLARE @result AS TABLE( 
	Ant_IdCorteD	int	,
	Ant_IdCorte	int	,
	Ant_CorteIdCierre	int	,
	Ant_CorteIdUsuarioCajero	int	,
	Ant_CorteIdRelSaldoRealMontoDenominacion	int	,
	Ant_IdDivisa	int	,
	Ant_DivisaCodigo	varchar(50)	,
	Ant_DivisaDescripcion	varchar(50)	,
	Ant_DivisaEsLocal	bit	,
	Ant_SaldoInicial	numeric(18,2)	,
	Ant_Entradas	numeric(18,2)	,
	Ant_Salidas	numeric(18,2)	,
	Ant_SaldoFinal	numeric(18,2)	,
	Ant_SaldoReal	numeric(18,2)	,
	Ant_FaltanteSobrante	numeric(18,2)	,
	Ant_FaltanteSobranteLocal	numeric(18,2)	,
	Ant_IdEstatus	int	,
	Ant_IdSaldoDestino	int	,
	Ant_SaldoIdDivisa	int	,
	Ant_TotalCargos	numeric(18,2)	,
	Ant_TotalAbonos	numeric(18,2)	,
	Ant_CambioNeto	numeric(18,2)	,
	Nvo_IdCorteD	int	,
	Nvo_IdCorte	int	,
	Nvo_CorteIdCierre	int	,
	Nvo_CorteIdUsuarioCajero	int	,
	Nvo_CorteIdRelSaldoRealMontoDenominacion	int	,
	Nvo_IdDivisa	int	,
	Nvo_DivisaCodigo	varchar(50)	,
	Nvo_DivisaDescripcion	varchar(50)	,
	Nvo_DivisaEsLocal	bit	,
	Nvo_SaldoInicial	numeric(18,2)	,
	Nvo_Entradas	numeric(18,2)	,
	Nvo_Salidas	numeric(18,2)	,
	Nvo_SaldoFinal	numeric(18,2)	,
	Nvo_SaldoReal	numeric(18,2)	,
	Nvo_FaltanteSobrante	numeric(18,2)	,
	Nvo_FaltanteSobranteLocal	numeric(18,2)	,
	Nvo_IdEstatus	int	,
	Nvo_IdSaldoDestino	int	,
	Nvo_SaldoIdDivisa	int	,
	Nvo_TotalCargos	numeric(18,2)	,
	Nvo_TotalAbonos	numeric(18,2)	,
	Nvo_CambioNeto	numeric(18,2)	
)	


    DECLARE @spAnterior AS TABLE(
		IdCorteD	int	,
		IdCorte	int	,
		CorteIdCierre	int	,
		CorteIdUsuarioCajero	int	,
		CorteIdRelSaldoRealMontoDenominacion	int	,
		IdDivisa	int	,
		DivisaCodigo	varchar(50)	,
		DivisaDescripcion	varchar(50)	,
		DivisaEsLocal	bit	,
		SaldoInicial	numeric(18,2)	,
		Entradas	numeric(18,2)	,
		Salidas	numeric(18,2)	,
		SaldoFinal	numeric(18,2)	,
		SaldoReal	numeric(18,2)	,
		FaltanteSobrante	numeric(18,2)	,
		FaltanteSobranteLocal	numeric(18,2)	,
		IdEstatus	int	,
		IdSaldoDestino	int	,
		SaldoIdDivisa	int	,
		TotalCargos	numeric(18,2)	,
		TotalAbonos	numeric(18,2)	,
		CambioNeto	numeric(18,2)	
	)

	DECLARE @spNuevo AS TABLE(
		IdCorteD	int	,
		IdCorte	int	,
		CorteIdCierre	int	,
		CorteIdUsuarioCajero	int	,
		CorteIdRelSaldoRealMontoDenominacion	int	,
		IdDivisa	int	,
		DivisaCodigo	varchar(50)	,
		DivisaDescripcion	varchar(50)	,
		DivisaEsLocal	bit	,
		SaldoInicial	numeric(18,2)	,
		Entradas	numeric(18,2)	,
		Salidas	numeric(18,2)	,
		SaldoFinal	numeric(18,2)	,
		SaldoReal	numeric(18,2)	,
		FaltanteSobrante	numeric(18,2)	,
		FaltanteSobranteLocal	numeric(18,2)	,
		IdEstatus	int	,
		IdSaldoDestino	int	,
		SaldoIdDivisa	int	,
		TotalCargos	numeric(18,2)	,
		TotalAbonos	numeric(18,2)	,
		CambioNeto	numeric(18,2)	
	)


/* declare variables */
DECLARE @IdCorteD INT
DECLARE @IdCorte INT
DECLARE @IdCierre INT
DECLARE @IdUsuarioCajero INT
DECLARE @IdDivisa INT

DECLARE Cortes CURSOR FAST_FORWARD READ_ONLY FOR SELECT cd.IdCorteD, c.IdCorte, c.IdCierre, c.IdUsuarioCajero, cd.IdDivisa
													FROM dbo.tVENcortesD cd  WITH(NOLOCK) 
													INNER JOIN dbo.tVENcortes c  WITH(NOLOCK) ON c.IdCorte = cd.IdCorte
													INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = c.IdOperacion
													INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = op.IdSucursal
													WHERE op.Fecha BETWEEN '20221101' AND '20221101'

OPEN Cortes

FETCH NEXT FROM Cortes INTO @IdCorteD , @IdCorte ,@IdCierre , @IdUsuarioCajero, @IdDivisa 
WHILE @@FETCH_STATUS = 0
BEGIN


	INSERT INTO @spAnterior
	(IdCorteD,IdCorte,CorteIdCierre,CorteIdUsuarioCajero,CorteIdRelSaldoRealMontoDenominacion,IdDivisa,DivisaCodigo,DivisaDescripcion,
	 DivisaEsLocal,SaldoInicial,Entradas,Salidas,SaldoFinal,SaldoReal,FaltanteSobrante,FaltanteSobranteLocal,IdEstatus,IdSaldoDestino,
	 SaldoIdDivisa,TotalCargos,TotalAbonos,CambioNeto
	)
	EXEC dbo.pLSTcorteD @TipoOperacion = 'CRTES',
                    @IdCorteD = @IdCorteD,      
                    @IdCorte = @IdCorte,       
                    @IdCierre = @IdCierre,       
                    @IdUsuario = @IdUsuarioCajero,      
                    @IdDivisa = @IdDivisa   

	INSERT INTO @spNuevo
	(IdCorteD,IdCorte,CorteIdCierre,CorteIdUsuarioCajero,CorteIdRelSaldoRealMontoDenominacion,IdDivisa,DivisaCodigo,DivisaDescripcion,
	 DivisaEsLocal,SaldoInicial,Entradas,Salidas,SaldoFinal,SaldoReal,FaltanteSobrante,FaltanteSobranteLocal,IdEstatus,IdSaldoDestino,
	 SaldoIdDivisa,TotalCargos,TotalAbonos,CambioNeto
	)
	EXEC dbo.pLSTVENcortesD 
                    @IdCorteD = @IdCorteD,      
                    @IdCorte = @IdCorte,       
                    @IdCierre = @IdCierre,       
                    @IdUsuario = @IdUsuarioCajero,      
                    @IdDivisa = @IdDivisa  

	INSERT INTO @result
	(Ant_IdCorteD,Ant_IdCorte,Ant_CorteIdCierre,Ant_CorteIdUsuarioCajero,Ant_CorteIdRelSaldoRealMontoDenominacion,
	    Ant_IdDivisa,Ant_DivisaCodigo,Ant_DivisaDescripcion,Ant_DivisaEsLocal,Ant_SaldoInicial,Ant_Entradas,
	    Ant_Salidas,Ant_SaldoFinal,Ant_SaldoReal,Ant_FaltanteSobrante,Ant_FaltanteSobranteLocal,Ant_IdEstatus,
	    Ant_IdSaldoDestino,Ant_SaldoIdDivisa,Ant_TotalCargos,Ant_TotalAbonos,Ant_CambioNeto,
	    Nvo_IdCorteD,Nvo_IdCorte,Nvo_CorteIdCierre,Nvo_CorteIdUsuarioCajero,Nvo_CorteIdRelSaldoRealMontoDenominacion,
	    Nvo_IdDivisa,Nvo_DivisaCodigo,Nvo_DivisaDescripcion,Nvo_DivisaEsLocal,Nvo_SaldoInicial,Nvo_Entradas,
	    Nvo_Salidas,Nvo_SaldoFinal,Nvo_SaldoReal,Nvo_FaltanteSobrante,Nvo_FaltanteSobranteLocal,Nvo_IdEstatus,
	    Nvo_IdSaldoDestino,Nvo_SaldoIdDivisa,Nvo_TotalCargos,Nvo_TotalAbonos,Nvo_CambioNeto)
	SELECT a.IdCorteD,a.IdCorte,a.CorteIdCierre,a.CorteIdUsuarioCajero,
	a.CorteIdRelSaldoRealMontoDenominacion,a.IdDivisa,a.DivisaCodigo,a.DivisaDescripcion,a.DivisaEsLocal,
	a.SaldoInicial,a.Entradas,a.Salidas,a.SaldoFinal,a.SaldoReal,a.FaltanteSobrante,a.FaltanteSobranteLocal,
	a.IdEstatus,a.IdSaldoDestino,a.SaldoIdDivisa,a.TotalCargos,a.TotalAbonos,a.CambioNeto,n.IdCorteD,n.IdCorte,
	n.CorteIdCierre,n.CorteIdUsuarioCajero,n.CorteIdRelSaldoRealMontoDenominacion,n.IdDivisa,n.DivisaCodigo,
	n.DivisaDescripcion,n.DivisaEsLocal,n.SaldoInicial,n.Entradas,n.Salidas,n.SaldoFinal,n.SaldoReal,n.FaltanteSobrante,
	n.FaltanteSobranteLocal,n.IdEstatus,n.IdSaldoDestino,n.SaldoIdDivisa,n.TotalCargos,n.TotalAbonos,n.CambioNeto		 
	FROM @spAnterior a
	INNER JOIN  @spNuevo n ON n.IdCorteD = a.IdCorteD 
							AND n.CorteIdCierre = a.CorteIdCierre
							AND n.IdCorte = a.IdCorte
							AND n.IdDivisa = a.IdDivisa
	WHERE a.SaldoInicial<>n.SaldoInicial 
	OR a.Entradas <> n.Entradas 
	OR a.Salidas <>	n.Salidas 
	OR a.SaldoFinal <> n.SaldoFinal 
	OR a.SaldoReal <> n.SaldoReal 
	OR a.FaltanteSobrante = n.FaltanteSobrante
	OR a.TotalCargos <> n.TotalCargos 
	OR a.TotalAbonos <>	n.TotalAbonos 
	OR a.CambioNeto <> n.CambioNeto 

	

    FETCH NEXT FROM Cortes INTO @IdCorteD , @IdCorte ,@IdCierre , @IdUsuarioCajero, @IdDivisa 
END

CLOSE Cortes
DEALLOCATE Cortes

SELECT * FROM @result






