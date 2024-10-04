
IF EXISTS(SELECT o.object_id FROM sys.objects o WHERE o.name='AddNewStudent')
BEGIN
	DROP PROCEDURE AddNewStudent
	SELECT 'AddNewStudent' + ' Borrado' AS Info
END
GO

Create procedure [dbo].[AddNewStudent]  
(  
   @Name nvarchar (50),  
   @City nvarchar (50),  
   @Address nvarchar (100)  
)  
as  
begin  
   Insert into StudentReg values(@Name,@City,@Address)  
END
GO

SELECT 'AddNewStudent creado'  AS info
GO


IF EXISTS(SELECT o.object_id FROM sys.objects o WHERE o.name='GetStudentDetails')
BEGIN
	DROP PROCEDURE GetStudentDetails
	SELECT 'GetStudentDetails' + ' Borrado' AS Info
END
GO

Create procedure [dbo].[GetStudentDetails]  
as  
begin  
   SELECT * FROM dbo.StudentReg  WITH(NOLOCK) 
END
GO

SELECT 'GetStudentDetails creado'  AS info
GO


IF EXISTS(SELECT o.object_id FROM sys.objects o WHERE o.name='UpdateStudentDetails')
BEGIN
	DROP PROCEDURE UpdateStudentDetails
	SELECT 'UpdateStudentDetails' + ' Borrado' AS Info
END
GO

Create procedure [dbo].[UpdateStudentDetails]  
(  
   @StdId int,  
   @Name nvarchar (50),  
   @City nvarchar (50),  
   @Address nvarchar (100)
)  
as  
begin  
   Update StudentReg   set Name=@Name,  City=@City,  Address=@Address  where Id=@StdId
END
GO

SELECT 'UpdateStudentDetails creado'  AS info
GO

IF EXISTS(SELECT o.object_id FROM sys.objects o WHERE o.name='DeleteStudent')
BEGIN
	DROP PROCEDURE DeleteStudent
	SELECT 'DeleteStudent' + ' Borrado' AS Info
END
GO

Create procedure [dbo].[DeleteStudent]  
(  
   @StdId int  
)  
as  
begin  
   Delete from StudentReg where Id=@StdId
END
GO

SELECT 'DeleteStudent creado'  AS info
GO
