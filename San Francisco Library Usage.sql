

-- Data exploration, data cleaning and some queries with the San Francisco library usage dataset. 

-- Starting of with some data exploration 

USE [FirstPortfolioproject]

SELECT COUNT(*)
FROM LibraryUsage

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='LibraryUsage'

-- The dataset consists of 423448 rows and 15 columns.

-- Ordering the dataset by the [Circulation Active Year] column. 

SELECT *
FROM FirstPortfolioproject..LibraryUsage
ORDER BY [Circulation Active Year];

-- The columns for [Circulation Active Year] and  [Supervisor District] contains a lot of null values. 

SELECT COUNT(*)
FROM FirstPortfolioproject..LibraryUsage
WHERE [Circulation Active Year] is null ;

-- Contains 67904 null values . 

SELECT COUNT(*)
FROM FirstPortfolioproject..LibraryUsage
WHERE [Supervisor District] is null ;

-- Contains 110310 null values. 


--	Ordering the data by the [Total Checkouts] column to see which patron that has checked out most items from the library.

SELECT * 
FROM FirstPortfolioproject..LibraryUsage
ORDER BY [Total Checkouts] DESC

-- The patron that has most checkouts from the library is an adult that has checked out 35907 items. 

-- Checking the total number of checkouts from the library between the years 2003 and 2016.

SELECT SUM ([Total Checkouts])
FROM FirstPortfolioproject..LibraryUsage

-- The total number of checkouts is 68590995. 


-- It would probalby be of interest for the library staff to know how many of the patrons that 
-- has checked out an item and never requested a renewal of the loaned item. 
-- In the dataset there is a lot of patrons that has not checked out any item and therefore they have not renewed the loan.
-- To answer this we will only check the patrons that has checked out atleast one item from the library. 


-- Checking proportion of active users that are "Idealcustomers".

-- Creating a temp table (Temporary table) to not manipulate the orignal dataset. 

Drop table if exists IdealCustomerTable
create table IdealCustomerTable
(
[Patron Type Definition] NVARCHAR(255),
[Total Checkouts] FLOAT,
[Total Renewals] FLOAT,
[Home Library Definition] NVARCHAR(255),
[IdealCustomer] NVARCHAR (255)
)

-- Inserting only the active users to the temp table

INSERT INTO IdealCustomerTable
SELECT 	[Patron Type Definition],[Total Checkouts],[Total Renewals],[Home Library Definition],
(CASE WHEN  [Total Renewals]<1 THEN 'No Renewals' END) as IdealCustomer 
FROM FirstPortfolioproject..LibraryUsage
WHERE [Total Checkouts] >0; 

-- Update the null vaues in the temp table for the patrons that has made renewals. 

UPDATE IdealCustomerTable
SET IdealCustomer= ISNULL([IdealCustomer],'Has Renewals')
FROM IdealCustomerTable


-- The library has 699740 users that has checked out at least one item during this period. 

SELECT COUNT(*)
FROM IdealCustomerTable
WHERE [IdealCustomer] = 'Has Renewals'

-- 493322 of these users has renewed at least one of these loans. 

SELECT COUNT(*)
FROM IdealCustomerTable
WHERE [IdealCustomer] = 'No Renewals'

-- 206418 of these users has not renewed any of the loaned items. 


-- Back to the original dataset. 
-- Lets see how many different Home libraries there is in the dataset. 

SELECT COUNT(DISTINCT [Home Library Definition]) AS #DifferentHomeLibraires
FROM LibraryUsage

-- There is 35 different libraries in the dataset, well 34 libraries one of them is "unkown". 


-- Lets order these libraries based on total number of checked out items
-- In some cases it is unkown from which librarie the item was checked out from so i will exclude the unkowns.   

SELECT [Home Library Definition],[Home Library Code],
SUM([Total Checkouts]) AS Checkouts
FROM LibraryUsage
WHERE [Home Library Definition] <> 'Unknown'
GROUP BY [Home Library Definition],[Home Library Code]
ORDER BY [Checkouts] DESC



-- Lets see which year that most patrons registered for the libraries services. 
-- Ordering the [Year Patron Registered] column by number of patrons. 


SELECT [Year Patron Registered], 
COUNT([Year Patron Registered]) as #NumberOfPatrons
from libraryusage
GROUP BY [Year Patron Registered]
ORDER BY #NumberOfPatrons DESC 

-- The starting year 2003 has most newly registered patrons. 

