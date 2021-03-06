USE [master]
GO
/****** Object:  Database [DB_Blood_Bank]    Script Date: 1/21/2022 1:34:49 PM ******/
CREATE DATABASE [DB_Blood_Bank]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_Blood_Bank', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DB_Blood_Bank.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DB_Blood_Bank_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DB_Blood_Bank_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [DB_Blood_Bank] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_Blood_Bank].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_Blood_Bank] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_Blood_Bank] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_Blood_Bank] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DB_Blood_Bank] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_Blood_Bank] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET RECOVERY FULL 
GO
ALTER DATABASE [DB_Blood_Bank] SET  MULTI_USER 
GO
ALTER DATABASE [DB_Blood_Bank] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_Blood_Bank] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DB_Blood_Bank] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DB_Blood_Bank] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DB_Blood_Bank] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DB_Blood_Bank] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DB_Blood_Bank', N'ON'
GO
ALTER DATABASE [DB_Blood_Bank] SET QUERY_STORE = OFF
GO
USE [DB_Blood_Bank]
GO
/****** Object:  UserDefinedFunction [dbo].[Connexion]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Connexion](@CIN varchar(9), @password varchar(25)) 
returns @tmp table (id int, employeeType varchar(9) )
as 
begin
	if exists(select CIN from [dbo].[Employee] where CIN = @CIN and [password] = @password)
	begin
		declare @id int, @userType varchar(25)
		select @id = employeeID from [dbo].[Employee] where CIN = @CIN and [password] = @password
		select @userType = [employee_Type] from [dbo].[Employee] where CIN = @CIN and [password] = @password
		insert into @tmp values (@id, @userType);
	end
	else 
	begin
		insert into @tmp values (-1, 'undefined')
	end
	return;
end
GO
/****** Object:  UserDefinedFunction [dbo].[isDoctor]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[isDoctor] (@id int) returns varchar(7)
as 
begin 
	if exists (select employeeID from Employee where [employee_type] = 'Doctor' and employeeID = @id) begin 
			return 'True'
		end
	return 'False'
end
GO
/****** Object:  UserDefinedFunction [dbo].[isNurse]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[isNurse] (@id int) returns varchar(7)
as 
begin 
	if exists (select employeeID from Employee where [employee_type] = 'Nurse' and employeeID = @id) begin 
			return 'True'
		end
	return 'False'
end
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[employeeID] [int] IDENTITY(1,1) NOT NULL,
	[fullName] [varchar](25) NOT NULL,
	[CIN] [varchar](9) NOT NULL,
	[phone] [char](10) NOT NULL,
	[adress] [varchar](25) NOT NULL,
	[password] [varchar](25) NOT NULL,
	[employee_type] [varchar](25) NOT NULL,
	[isActive] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[employeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getEmployee]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getEmployee]()
returns table
as 
return
	select 
	employeeID,
	fullName,
	CIN,
	phone,
	adress,
	[password],
	employee_Type
	from [dbo].[Employee] where isActive = 'Y'
	
GO
/****** Object:  UserDefinedFunction [dbo].[search]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[search](@word varchar(25) ) returns table as
return select * from dbo.getEmployee()
where fullName like '%' + @word + '%' 
or CIN like '%' + @word + '%'
or adress like '%' + @word + '%'
or phone like '%' + @word + '%'
GO
/****** Object:  UserDefinedFunction [dbo].[filterBy]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[filterBy](@word varchar(25) ) returns table as
return select * from dbo.getEmployee()
where employee_Type like @word;
GO
/****** Object:  Table [dbo].[Event]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[eventID] [int] IDENTITY(1,1) NOT NULL,
	[adress] [varchar](25) NOT NULL,
	[startDate] [date] NULL,
	[endDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[eventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getUpcomingEvents]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getUpcomingEvents]() returns table 
as return
	select * from [dbo].[Event] where dateDiff(day, startDate, getDate()) <= 0
GO
/****** Object:  Table [dbo].[BloodType]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BloodType](
	[typeID] [int] IDENTITY(1,1) NOT NULL,
	[type] [varchar](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[typeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stock]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[blood_type] [int] NOT NULL,
	[quantity] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[blood_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getBloodQuantity]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getBloodQuantity]() returns table as
return 
	select [quantity], [type] 
	from [dbo].[BloodType],[dbo].[Stock] 
	where [typeID] = [blood_type]
GO
/****** Object:  Table [dbo].[Hospital]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hospital](
	[hospitalID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](25) NOT NULL,
	[adress] [varchar](25) NOT NULL,
	[phone] [varchar](12) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[hospitalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[orderDate] [smalldatetime] NOT NULL,
	[hospitalID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getOrder]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getOrder]() returns table 
as return
	select [name], [adress], [orderID], [orderDate] 
	from [dbo].[Order], [dbo].[Hospital]
	where [dbo].[Hospital].hospitalID = [dbo].[Order].[hospitalID]
GO
/****** Object:  Table [dbo].[Order_Details]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Details](
	[orderID] [int] NOT NULL,
	[typeBlood] [int] NOT NULL,
	[quantity] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getOrderDetails]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getOrderDetails](@id int) returns table as 
return 
	select [type], [quantity] 
	from Order_Details , [dbo].[BloodType]
	where [dbo].[BloodType].[typeID] = [dbo].[Order_Details].[typeBlood]
	and  [orderID] = @id
GO
/****** Object:  Table [dbo].[DoctorsInEvent]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorsInEvent](
	[eventID] [int] NOT NULL,
	[doctorID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NurseInEvent]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NurseInEvent](
	[eventID] [int] NOT NULL,
	[nurseID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getEventForEmployee]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getEventForEmployee](@employeeID int) returns table 
as return
	select eventID, adress, startDate, endDate from [dbo].[Event] S,
	(select eventId as eID, doctorId as employeeID from [dbo].[DoctorsInEvent] 
	union 
	select eventId as eID, nurseId as employeeID from [dbo].[NurseInEvent]) T
	where T.eID = S.eventID and T.employeeID = @employeeID
	and DATEDIFF(day, startDate, GETDATE()) >= 0
	and DATEDIFF(day, endDate, GETDATE()) <= 0
GO
/****** Object:  Table [dbo].[Donor]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donor](
	[donorID] [int] IDENTITY(1,1) NOT NULL,
	[fullName] [varchar](25) NOT NULL,
	[CIN] [varchar](25) NOT NULL,
	[phone] [char](10) NULL,
	[birth_day] [date] NOT NULL,
	[blood_type] [int] NOT NULL,
	[quantity] [float] NOT NULL,
	[eventID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[donorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getDonor]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getDonor](@id int)  returns 
table as return 
	select CIN, phone, birth_day, type, quantity
	from Donor, [dbo].[BloodType]
	where [blood_type] = [typeID] and [eventID] =@id
GO
/****** Object:  Table [dbo].[SoloBloodDonnation]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SoloBloodDonnation](
	[donnationDate] [date] NULL,
	[DonorID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ('Y') FOR [isActive]
GO
ALTER TABLE [dbo].[Stock] ADD  CONSTRAINT [ck_default_quantity]  DEFAULT ((0)) FOR [quantity]
GO
ALTER TABLE [dbo].[DoctorsInEvent]  WITH CHECK ADD  CONSTRAINT [PK_doctor_event] FOREIGN KEY([doctorID])
REFERENCES [dbo].[Employee] ([employeeID])
GO
ALTER TABLE [dbo].[DoctorsInEvent] CHECK CONSTRAINT [PK_doctor_event]
GO
ALTER TABLE [dbo].[DoctorsInEvent]  WITH CHECK ADD  CONSTRAINT [PK_event] FOREIGN KEY([eventID])
REFERENCES [dbo].[Event] ([eventID])
GO
ALTER TABLE [dbo].[DoctorsInEvent] CHECK CONSTRAINT [PK_event]
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD FOREIGN KEY([blood_type])
REFERENCES [dbo].[BloodType] ([typeID])
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD FOREIGN KEY([eventID])
REFERENCES [dbo].[Event] ([eventID])
GO
ALTER TABLE [dbo].[NurseInEvent]  WITH CHECK ADD FOREIGN KEY([nurseID])
REFERENCES [dbo].[Employee] ([employeeID])
GO
ALTER TABLE [dbo].[NurseInEvent]  WITH CHECK ADD  CONSTRAINT [PK_event_nurse] FOREIGN KEY([eventID])
REFERENCES [dbo].[Event] ([eventID])
GO
ALTER TABLE [dbo].[NurseInEvent] CHECK CONSTRAINT [PK_event_nurse]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([hospitalID])
REFERENCES [dbo].[Hospital] ([hospitalID])
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD FOREIGN KEY([orderID])
REFERENCES [dbo].[Order] ([orderID])
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD FOREIGN KEY([typeBlood])
REFERENCES [dbo].[BloodType] ([typeID])
GO
ALTER TABLE [dbo].[SoloBloodDonnation]  WITH CHECK ADD FOREIGN KEY([DonorID])
REFERENCES [dbo].[Donor] ([donorID])
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD FOREIGN KEY([blood_type])
REFERENCES [dbo].[BloodType] ([typeID])
GO
ALTER TABLE [dbo].[DoctorsInEvent]  WITH CHECK ADD  CONSTRAINT [CK_doctors] CHECK  (([dbo].[isDoctor]([doctorID])='True'))
GO
ALTER TABLE [dbo].[DoctorsInEvent] CHECK CONSTRAINT [CK_doctors]
GO
ALTER TABLE [dbo].[Donor]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[NurseInEvent]  WITH CHECK ADD  CONSTRAINT [CK_nurse] CHECK  (([dbo].[isNurse]([nurseID])='True'))
GO
ALTER TABLE [dbo].[NurseInEvent] CHECK CONSTRAINT [CK_nurse]
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[Stock]  WITH CHECK ADD CHECK  (([quantity]>=(0)))
GO
/****** Object:  StoredProcedure [dbo].[add_blood_type]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[add_blood_type]
	@blood_type varchar(4)
as
begin
	insert into BloodType values(
		@blood_type 
	)
end
GO
/****** Object:  StoredProcedure [dbo].[add_donor]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[add_donor]
@fullName varchar(25), @CIN varchar(9), @phone char(10),@birth_day date, 
@blood_type varchar(4), @quantity float, @eventID int 
as
begin
	declare @bloodID int;
	select @bloodID = [typeID] from [dbo].[BloodType] where [type] = @blood_type
	declare @dateF Date;
	select @dateF = Convert(DATETIMe, @birth_day, 103)
	insert into Donor values(
		@fullName, @CIN , @phone, @dateF,
		@bloodID , @quantity, @eventID
	)
end
GO
/****** Object:  StoredProcedure [dbo].[add_employee]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[add_employee]
	@fullName varchar(25), @CIN varchar(9), @phone char(10), @adress varchar(25), @password varchar(25), @type varchar(25)
as 
begin 
	insert into Employee (fullName, CIN, phone, adress, [password], employee_type) values(
		@fullName, @CIN, @phone, @adress, @password, @type 
	)
end
GO
/****** Object:  StoredProcedure [dbo].[add_event]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[add_event] 
	@adress varchar(25), @startDate varchar(25), @endDate varchar(25)
as
begin
	begin try 
		declare @start Date, @end Date
		set @start = Convert(Date,@startDate,103)
		set @end = Convert(Date,@endDate,103)
		if(DATEDIFF(day, @start, @end ) >= 0) 
		begin
			insert into [dbo].[Event] Values (
				@adress, Convert(Date,@startDate,103), Convert(Date,@endDate,103)
			)
			declare @id int
			set @id = SCOPE_IDENTITY();
			return @id;
		end
		else 
			RAISERROR('The end date must be greater then the start', 16, 1)
	end try
	begin catch
		RAISERROR('The end date must be greater then the start', 16, 1);
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[add_hospital]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[add_hospital]
	@name varchar(25), @adress varchar(25) --, @phone char(12)
as
begin
	insert into Hospital values(
		@name,
		@adress,
		'0648597261'
	)
	declare @id int
	SET @id=SCOPE_IDENTITY()
	return @id
end
GO
/****** Object:  StoredProcedure [dbo].[addEvent]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[addEvent] @adress varchar(25), 
	@startDate varchar(25), @endDate varchar(25)
as 
begin  
	insert into [dbo].[Event] Values (@adress, Convert(Date,@startDate,103), Convert(Date,@endDate,103) );
	declare @id int
	SET @id=SCOPE_IDENTITY()
	return @id
end
GO
/****** Object:  StoredProcedure [dbo].[create_order]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[create_order]
	@hospitalID int
as begin
	insert into [dbo].[Order] values(
		GETDATE(),
		@hospitalID
	)
	declare @id int
	SET @id=SCOPE_IDENTITY()
	return @id
end
GO
/****** Object:  StoredProcedure [dbo].[create_order_details]    Script Date: 1/21/2022 1:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[create_order_details]
	@orderID int, @type_blood int, @quantity float
as begin
	insert into [dbo].[Order_Details] values(
		@orderID,  @type_blood, @quantity 
	) 
end
GO
USE [master]
GO
ALTER DATABASE [DB_Blood_Bank] SET  READ_WRITE 
GO
