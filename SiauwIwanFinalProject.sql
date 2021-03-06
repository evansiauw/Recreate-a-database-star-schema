/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [BIClass]
GO
/****** Object:  StoredProcedure [Project1].[AddForeignKeysToStarSchemaData]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [Project1].[AddForeignKeysToStarSchemaData]
 as 
 begin
 set nocount on;
 
	alter table [CH01-01-Fact].[Data] with nocheck add constraint 
    [FK_Data_DimCustomer] foreign key(Customerkey) 
	references [CH01-01-Dimension].[DimCustomer](CustomerKey);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimMaritalStatus] foreign key(MaritalStatus) 
	references [CH01-01-Dimension].[DimMaritalStatus] (MaritalStatus);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimOccupation] foreign key(OccupationKey) 
	references [CH01-01-Dimension].[DimOccupation] (OccupationKey);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimOrderDate] foreign key(OrderDate) 
	references [CH01-01-Dimension].[DimOrderDate] (OrderDate);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimProduct] foreign key(ProductKey) 
	references [CH01-01-Dimension].[DimProduct] (Productkey);
	 
	alter table [CH01-01-Dimension].[DimProductSubcategory] with nocheck add constraint
	[FK_DimProductSubcategory_DimProductCategory] foreign key(ProductCategoryKey) 
	references [CH01-01-Dimension].[DimProductCategory] (ProductCategoryKey);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimTerritory] foreign key(TerritoryKey) 
	references [CH01-01-Dimension].[DimTerritory] (TerritoryKey);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_SalesManagers] foreign key(SalesManagerKey) 
	references [CH01-01-Dimension].[SalesManagers] (SalesManagerKey);

	alter table [CH01-01-Fact].[Data] with nocheck add constraint
	[FK_Data_DimGender] foreign key(Gender) 
	references [CH01-01-Dimension].[DimGender](Gender);

	alter table [CH01-01-Dimension].[DimProduct] with nocheck add constraint
	[FK_DimProduct_DimProductSubcategory] foreign key(ProductSubcategoryKey) 
	references [CH01-01-Dimension].[DimProductSubcategory] (ProductSubcategoryKey);

	end;
GO
/****** Object:  StoredProcedure [Project1].[DropForeignKeysToStarSchemaData]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [Project1].[DropForeignKeysToStarSchemaData]
 as 
 begin
 set nocount on;
 
 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimCustomer;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimMaritalStatus;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimOccupation;
  
 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimOrderDate;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimProduct;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimTerritory;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_SalesManagers;

 alter table [CH01-01-Fact].Data 
 drop constraint FK_Data_DimGender;

 alter table [CH01-01-Dimension].[DimProductSubcategory] 
 drop constraint FK_DimProductSubcategory_DimProductCategory;

 alter table [CH01-01-Dimension].[DimProduct] 
 drop constraint FK_DimProduct_DimProductSubCategory;

 end;
GO
/****** Object:  StoredProcedure [Project1].[Load_Data]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [Project1].[Load_Data]
 as
 begin
 set nocount on;

 Insert into [CH01-01-Fact].data
	(SalesKey,SalesManagerKey, OccupationKey, TerritoryKey, ProductKey, CustomerKey,
	ProductCategory,SalesManager, ProductSubcategory, ProductCode, Productname,
	Color, ModelName, OrderQuantity, UnitPrice, ProductStandardCost, 
	SalesAmount, OrderDate, Monthname, MonthNumber, Year, Customername, 
	MaritalStatus, Gender, Education, Occupation, TerritoryRegion,
	TerritoryCountry, TerritoryGroup)
 select
	old.SalesKey,old.SalesManagerKey, old.OccupationKey, dt.TerritoryKey, dp.ProductKey,
	dc.CustomerKey, old.ProductCategory, old.SalesManager, old.ProductSubcategory,
	old.ProductCode, old.Productname, old.Color, old.ModelName, old.OrderQuantity, 
	old.UnitPrice, old.ProductStandardCost, old.SalesAmount, old.OrderDate, 
	old.Monthname, old.MonthNumber, old.Year, old.Customername, old.MaritalStatus, 
	old.Gender, old.Education, old.Occupation, old.TerritoryRegion, old.TerritoryCountry, 
	old.TerritoryGroup
 from 
	FileUpload.OriginallyLoadedData AS old inner join
	[CH01-01-Dimension].DimProduct AS dp
		on dp.ProductName = old.ProductName inner join

	[CH01-01-Dimension].DimTerritory AS dt 
		on dt.TerritoryCountry = old.TerritoryCountry and

		dt.TerritoryGroup = old.TerritoryGroup and 
		dt.TerritoryRegion = old.TerritoryRegion inner join

	[CH01-01-Dimension].DimCustomer as dc 
		on dc.CustomerName = old.CustomerName  
end; 
GO
/****** Object:  StoredProcedure [Project1].[Load_DimCustomer]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimCustomer]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimCustomer
 (CustomerName)
 select distinct CustomerName
 from FileUpload.OriginallyLoadedData

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimGender]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimGender]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimGender
 (Gender,GenderDescription)
 select distinct Gender, 
 case when Gender = 'F' then 'Female' else 'Male'
 end
 from FileUpload.OriginallyLoadedData

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimMaritalStatus]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimMaritalStatus]
 as 
 begin
 set nocount on;
 
 insert into [CH01-01-Dimension].DimMaritalStatus
 (MaritalStatus,MaritalStatusDescription)
 select distinct Gender, 
 case when Gender = 'S' then 'Single' else 'Married'
 end
 from FileUpload.OriginallyLoadedData

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimOccupation]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimOccupation]
 as 
 begin
 set nocount on;
 
 insert into [CH01-01-Dimension].DimOccupation
 (OccupationKey, Occupation)
 select distinct OccupationKey,Occupation
 from FileUpload.OriginallyLoadedData

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimOrderDate]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimOrderDate]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimOrderDate
 (OrderDate, MonthName, MonthNumber, Year)
 select distinct OrderDate, MonthName, MonthNumber, Year
 from FileUpload.OriginallyLoadedData
 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProduct]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[Load_DimProduct]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimProduct
 ( 
	ProductSubCategoryKey,
	ProductCategory,
	ProductSubcategory,
	ProductCode,
	ProductName, 
	Color,
	ModelName)
 select distinct 
	dps.ProductSubCategoryKey,
	old.ProductCategory,
	dps.ProductSubcategory, 
	ProductCode, 
	ProductName, 
	Color, 
	ModelName

 from FileUpload.OriginallyLoadedData as old
	inner join [CH01-01-Dimension].DimProductSubcategory as dps
		on dps.ProductSubcategory = old.ProductSubcategory
	inner join [CH01-01-Dimension].DimProductCategory as dpc
		on dpc.ProductCategoryKey = dps.ProductCategorykey
			and dpc.ProductCategory = old.ProductCategory;

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProductCategory]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 create   procedure [Project1].[Load_DimProductCategory]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimProductCategory
 (ProductCategory)
 select distinct ProductCategory
 from FileUpload.OriginallyLoadedData
 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProductSubcategory]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
 create   procedure [Project1].[Load_DimProductSubcategory]
 as 
 begin
 set nocount on;
 
 insert into [CH01-01-Dimension].DimProductSubcategory
 (
	 ProductCategorykey,
	 ProductSubcategory
 )

 select distinct
	dpc.productcategorykey,
	old.productsubcategory

 from FileUpload.OriginallyLoadedData as old
	inner join [CH01-01-Dimension].DimProductCategory as dpc
		on dpc.ProductCategory = old.ProductCategory;
 end
GO
/****** Object:  StoredProcedure [Project1].[Load_DimTerritory]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
 create   procedure [Project1].[Load_DimTerritory]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].DimTerritory
 (TerritoryGroup, TerritoryCountry, TerritoryRegion)
 select distinct TerritoryGroup, TerritoryCountry, TerritoryRegion
 from FileUpload.OriginallyLoadedData

 end
GO
/****** Object:  StoredProcedure [Project1].[Load_SalesManagers]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create   procedure [Project1].[Load_SalesManagers]
 as 
 begin
 set nocount on;

 insert into [CH01-01-Dimension].SalesManagers
 (SalesManagerKey, Category, SalesManager, Office)
 select distinct SalesManagerKey, old.ProductCategory, SalesManager,
 Office = CASE
				When old.SalesManager like 'Marco%' then
					'Redmond'
				When old.SalesManager like 'Alberto%' then
					'Seattle'
				When old.SalesManager like 'Maurizio%' then
					'Redmond'
				else
					'Seattle'
		  End
 from FileUpload.OriginallyLoadedData as old
 order by old.SalesManagerKey;

 end
GO
/****** Object:  StoredProcedure [Project1].[LoadStarSchemaData]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create   procedure [Project1].[LoadStarSchemaData]
 @YesNo CHAR(1) = 'Y'
 as
 begin
 set nocount on;

 declare @return_value int;

 exec [Project1].[DropForeignKeysToStarSchemaData];

 exec @return_value = [Project1].[TruncateStarSchemaData];

 exec @return_value = [Project1].[Load_DimProductCategory];
 exec @return_value = [Project1].[Load_DimProductSubCategory];
 exec @return_value = [Project1].[Load_DimProduct];
 exec @return_value = [Project1].[Load_SalesManagers];
 exec @return_value = [Project1].[Load_DimGender];
 exec @return_value = [Project1].[Load_DimMaritalStatus];
 exec @return_value = [Project1].[Load_DimOccupation];
 exec @return_value = [Project1].[Load_DimOrderDate];
 exec @return_value = [Project1].[Load_DimTerritory];
 exec @return_value = [Project1].[Load_DimCustomer];
 exec @return_value = [Project1].[Load_Data];

 exec [project1].[AddForeignKeysToStarSchemaData];

 end;
GO
/****** Object:  StoredProcedure [Project1].[TruncateStarSchemaData]    Script Date: 12/10/2017 3:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create   procedure [Project1].[TruncateStarSchemaData]
 as
 begin
 set nocount on;

 truncate table [CH01-01-Fact].data;
 truncate table [CH01-01-Dimension].SalesManagers;
 truncate table [CH01-01-Dimension].DimProductSubcategory;
 truncate table [CH01-01-Dimension].DimProductCategory;
 truncate table [CH01-01-Dimension].DimGender;
 truncate table [CH01-01-Dimension].DimMaritalStatus;
 truncate table [CH01-01-Dimension].DimOccupation;
 truncate table [CH01-01-Dimension].DimOrderDate;
 truncate table [CH01-01-Dimension].DimProduct;
 truncate table [CH01-01-Dimension].DimTerritory;
 truncate table [CH01-01-Dimension].DimCustomer;
 end
GO
