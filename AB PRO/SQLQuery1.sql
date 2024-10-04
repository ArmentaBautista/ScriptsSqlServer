
USE [1G_AEMSA]
GO

SELECT * FROM dbo.sis_int  WITH(NOLOCK) 

Select *, '' as sNumPedimento, '' as Import_Nombre_Comercial from vt_sis_int_fac Where status = 99 order by numero