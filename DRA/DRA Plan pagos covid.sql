

 SELECT		
			   parcialidad.IdCuenta,
			   parcialidad.IdParcialidad,
               parcialidad.NumeroParcialidad,
               parcialidad.Inicio,
               parcialidad.Fin,
               parcialidad.CapitalInicial,
               parcialidad.Capital,
			   parcialidad.CapitalPagado,
               InteresOrdinario = parcialidad.InteresOrdinarioEstimado,
               IVAInteresOrdinario = parcialidad.IVAInteresOrdinarioEstimado,
               parcialidad.PagoProgramado,
               parcialidad.Notas,
               parcialidad.Total,
               parcialidad.CapitalFinal,
               InteresGracia = ISNULL(pGracia.InteresOrdinario, 0.00),
			   IVAinteresGracia = ISNULL(pGracia.IVAinteresOrdinario, 0.00),
               TotalMasInteresGracia = parcialidad.Total + ISNULL(pGracia.InteresOrdinario , 0.00) + ISNULL(pGracia.IVAinteresOrdinario,0),
			   InteresAplazado = ISNULL(contingenciaD.InteresAplazado, 0.00),
			   IvaInteresAplazado= ISNULL(contingenciaD.IVAinteresAplazado, 0.00)
        FROM dbo.tAYCparcialidades parcialidad
            LEFT JOIN dbo.tAYCparcialidadesInteresPeriodosGracia pGracia
                ON pGracia.IdParcialidad = parcialidad.IdParcialidad
			LEFT JOIN dbo.tAYCmovimientosContingenciaD contingenciaD 
			    ON contingenciaD.IdParcialidad = parcialidad.IdParcialidad
        --WHERE parcialidad.IdCuenta = 89918
              --AND parcialidad.IdEstatus = 1
        ORDER BY parcialidad.NumeroParcialidad;


