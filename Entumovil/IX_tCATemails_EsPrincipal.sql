

IF EXISTS(SELECT name FROM sys.indexes o WHERE o.name='IX_tCATemails_EsPrincipal')
BEGIN
	DROP INDEX IX_tCATemails_EsPrincipal ON [tCATemails]
	SELECT 'IX_tCATemails_EsPrincipal BORRADO' AS info
END
GO

CREATE NONCLUSTERED INDEX IX_tCATemails_EsPrincipal
ON [dbo].[tCATemails] ([EsPrincipal])
INCLUDE ([IdRel],[email],[IdEstatusActual])
GO

