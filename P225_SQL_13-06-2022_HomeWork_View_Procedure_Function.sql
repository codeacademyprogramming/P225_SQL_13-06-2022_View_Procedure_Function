Create Database P225HomeWork2Db

Use P225HomeWork2Db

Create Table Departments
(
	Id int Constraint PK_Departments_Id Primary Key Identity,
	Name nvarchar(255) Not Null,
)

Alter Table Departments
Add Constraint CK_Departments_Name Check(Len(Name) >2)

Alter Table Departments
Add Constraint UNQ_Departments_Name Unique(Name)

Alter Table Departments
Drop CK_Departments_Name

Create Table Sizes
(
	Id int primary key identity,
	Name nvarchar(255) not null unique
)

Create Table Products
(
	Id int primary key identity,
	Name nvarchar(255) not null unique
)

Select Products.Name 'Product Name', Sizes.Name 'Size Name' From Products 
Cross Join Sizes Where LEN(Products.Name) > 5 AND Sizes.Id != 3

Create Table Groups
(
	Id int primary key identity,
	Name nvarchar(255) not null unique
)

Create Table Students
(
	Id int primary key identity,
	Name nvarchar(255) Not Null,
	SurName nvarchar(255) Not Null,
	Email nvarchar(255) Not Null Unique,
	Grade int Not Null
)

Alter Table Students
Add GroupId int Foreign Key References Groups(Id)

Insert Into Groups
Values
('P225'),
('P224'),
('P129'),
('P128')

Insert Into Students(Name, SurName,Email, Grade, GroupId)
Values
(N'Vüsal',N'Əliyev','vusalma@code.edu.az',85,1),
(N'Vüsal',N'İmanov','vusalmi@code.edu.az',75,1),
(N'İsmayıl',N'Cabbarlı','ismayilaj@code.edu.az',35,1),
(N'Səxavət',N'Əliyev','sexavet@code.edu.az',85,2),
(N'Sadiqxan',N'Qayxanov','sadiq@code.edu.az',65,2),
(N'Elgiz',N'Əliyev','elgiz@code.edu.az',85,3),
(N'Əliskəndər',N'Qurbanov','aliskandar@code.edu.az',55,3),
(N'Vasif',N'Əliyev','vasif@code.edu.az',90,3)

Select g.Id, g.Name, COUNT(*) From Students s
Right Join Groups g On s.GroupId = g.Id 
Group By g.Id, g.Name
Having COUNT(*) > 2

Select COUNT(Distinct Name) From Students

Select COUNT(Name) From Students

Create Table Employees
(
	Id int primary key identity,
	FullName nvarchar(255) Not Null,
	Email nvarchar(255) Not Null Unique
)

Insert Into Employees(FullName,Email)
Values
(N'Vüsal Əliyev','vusalma@code.edu.az'),
(N'Vüsal İmanov','vusalmi@code.edu.az'),
(N'İsmayıl Cabbarlı','ismayilaj@code.edu.az'),
(N'Səxavət Əliyev','sexavet@code.edu.az'),
(N'Sadiqxan Qayxanov','sadiq@code.edu.az'),
(N'Elgiz Əliyev','elgiz@code.edu.az'),
(N'Əliskəndər Qurbanov','aliskandar@code.edu.az'),
(N'Vasif Əliyev','vasif@code.edu.az')

Select (Name+' '+SurName) 'FullName', Email From Students
Union All
Select FullName, Email From Employees

Select (Name+' '+SurName) 'FullName', Email From Students
Union
Select FullName, Email From Employees

Select FullName,Email,COUNT(*) From
(Select (Name+' '+SurName) 'FullName', Email From Students
Union All
Select FullName, Email From Employees) unTbls
Group By FullName, Email

Select Distinct FullName From (Select (Name+' '+SurName) 'FullName', Email From Students
Union All
Select FullName, Email From Employees) unTbls

Select Count( Distinct FullName) From (Select (Name+' '+SurName) 'FullName', Email From Students
Union All
Select FullName, Email From Employees) unTbls

Select (s.Name+' '+SurName) 'FullName' From Students s
Join Groups g On s.GroupId = g.Id where g.Id = 1
Union
Select FullName From Employees

--View Yaratmaq
Create View usv_GetAllStudentsAndEmployees
As
Select (Name+' '+SurName) 'FullName' from Students
Union All
Select FullName From Employees

--Yaradilmis View Uzerinde Update
Alter View usv_GetAllStudentsAndEmployees
As
Select (Name+' '+SurName) 'AdSoyad' from Students
Union All
Select FullName 'AdSoyad' From Employees

Select * From usv_GetAllStudentsAndEmployees

Select FullName, Count(*) From usv_GetAllStudentsAndEmployees Group By FullName

Select COUNT(Distinct FullName) From usv_GetAllStudentsAndEmployees where LEN(FullName) > 15

--Create Procedure
Create Procedure usp_GeyCountByFullNameLength
@count int
As
Begin
	Select COUNT(Distinct FullName) From usv_GetAllStudentsAndEmployees where LEN(FullName) > @count
End

--Update Procedure
Alter Procedure usp_GeyCountByFullNameLength
@count int,
@name nvarchar(255)
As
Begin
	Select COUNT(Distinct FullName) From usv_GetAllStudentsAndEmployees 
	where LEN(FullName) > @count And FullName Like '%'+@name+'%'
End


exec usp_GeyCountByFullNameLength 5, 'vüsal'
exec usp_GeyCountByFullNameLength 15, 'İsmayıl'
exec usp_GeyCountByFullNameLength 10


Create Function usf_GetCount
(@count int)
returns int
As
Begin
	declare @mycount int

	Select @mycount = COUNT(Distinct FullName) From usv_GetAllStudentsAndEmployees 
	where LEN(FullName) > @count 

	return @mycount 
End

Alter Function usf_GetCount
(@count int, @src nvarchar(255))
returns int
As
Begin
	declare @mycount int

	Select @mycount = COUNT(Distinct FullName) From usv_GetAllStudentsAndEmployees 
	where LEN(FullName) > @count And FullName Like '%'+@src+'%'

	return @mycount 
End

select dbo.usf_GetCount(5,'İsm')