


EXEC dbo.pPLDlistarActualizacionesPerfilTransaccional @pTipoOperacion = 'EVALUACIONES',  -- varchar(25)
                                                      @pIdActualizacion = 0, -- int
                                                      @pNoSocio = 0,         -- int
                                                      @pPersona = ''         -- varchar(20)


EXEC dbo.pPLDlistarActualizacionesPerfilTransaccional @pTipoOperacion = 'RESULTADOS',  -- varchar(25)
                                                      @pIdActualizacion = 5, -- int
                                                      @pNoSocio = 0,         -- int
                                                      @pPersona = ''         -- varchar(20)

EXEC dbo.pPLDlistarActualizacionesPerfilTransaccional @pTipoOperacion = 'SOCIO',  -- varchar(25)
                                                      @pIdActualizacion = 0, -- int
                                                      @pNoSocio = '0030476202',         -- int
                                                      @pPersona = ''         -- varchar(20)

EXEC dbo.pPLDlistarActualizacionesPerfilTransaccional @pTipoOperacion = 'PERSONA',  -- varchar(25)
                                                      @pIdActualizacion = 0, -- int
                                                      @pNoSocio = '',         -- int
                                                      @pPersona = 'Sergio'         -- varchar(20)

EXEC dbo.pCnPLDPTactualizacionesPerfilTransaccional

EXEC dbo.pCnPLDPTresultadosActualizacionesPerfilTransaccional @pIdActualizacion = 5 -- int

EXEC dbo.pCnPLDPTactualizacionesPerfilTransaccionalSocio @pNoSocio = '0020695902' -- varchar(20)

EXEC dbo.pCnPLDPTactualizacionesPerfilTransaccionalPersona @pPersona = 'sergio' -- varchar(20)


