
USE IERP_OBL


SELECT pf.Codigo AS ProductoCodigo, pf.Descripcion AS Producto, pf.EsPrendario, pf.NumeroMaximoRefrendos
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
WHERE pf.EsPrendario=1

SELECT c.NumeroMaximoRefrendos, COUNT(c.IdCuenta) AS NoCuentas
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdEstatus=1 AND c.NumeroMaximoRefrendos >0
GROUP BY c.NumeroMaximoRefrendos

/*

UPDATE pf SET pf.NumeroMaximoRefrendos=0
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) WHERE pf.EsPrendario=1

--SELECT c.IdCuenta
UPDATE c SET c.NumeroMaximoRefrendos=0
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdEstatus=1 AND c.NumeroMaximoRefrendos >0

*/


SELECT * FROM dbo.tDIVfactoresTipoCambio


SELECT c.IdCuenta
--begin tran UPDATE c SET c.NumeroMaximoRefrendos=	9999
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdEstatus=1 AND C.EsPrendario=1



SELECT c.NumeroMaximoRefrendos, t.numeromaximorefrendos
-- BEGIN TRAN UPDATE c SET c.NumeroMaximoRefrendos=t.numeromaximorefrendos
FROM [dbo].[tTMPprendariosRefrendos] t  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta=t.idcuenta
WHERE  c.NumeroMaximoRefrendos <> t.numeromaximorefrendos


SELECT t.numeromaximorefrendos, COUNT(idcuenta)
FROM [tTMPprendariosRefrendos] t
GROUP BY t.numeromaximorefrendos

SELECT t.numeromaximorefrendos, COUNT(idcuenta)
FROM dbo.tAYCcuentas t
WHERE t.IdEstatus=1 AND t.EsPrendario=1
GROUP BY t.numeromaximorefrendos