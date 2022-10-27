# SQL Projects
 

## San Francisco Library Usage
- My first SQL project
- Created some simple queries to test some new SQL techniques i have learned
### Dataset 
- https://www.kaggle.com/datasets/datasf/sf-library-usage-data 

Starting of with some simple data exploration 

````sql
SELECT COUNT(*)
FROM LibraryUsage

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='LibraryUsage'
````
The dataset consists of 423448 rows and 15 columns.

Ordering the dataset by the **Total Checkouts** column to see which patron that has most total checkouts. 

````sql
SELECT *
FROM LibraryUsage
ORDER BY [Total Checkouts]DESC

````

![image](https://user-images.githubusercontent.com/114582898/198070126-817ba401-312a-475f-b103-cd91134d0e94.png)


 The columns **Circulation Active Year** and  **Supervisor District** contains a lot of null values. 


````sql
SELECT COUNT(*)
FROM LibraryUsage
WHERE [Circulation Active Year] is null 
````
 Contains 67904 null values. 
 
 
````sql
SELECT COUNT(*)
FROM LibraryUsage
WHERE [Supervisor District] is null

````
Contains 110310 null values. 

Checking the total number of items checked out from the libraries. 

````sql
SELECT SUM ([Total Checkouts])
FROM LibraryUsage
````
The total number of checkouts is 68590995.

It would probalby be of interest for the library staff to know how many of the patrons that 
has never requested a renewal of a loaned item. 
In the dataset there is a lot of patrons that has not checked out any item from the library.
Therefore we will create a temporary table with only patrons that has checked out at least 1 item. 

````sql
Drop table if exists IdealCustomerTable
create table IdealCustomerTable
(
[Patron Type Definition] NVARCHAR(255),
[Total Checkouts] FLOAT,
[Total Renewals] FLOAT,
[Home Library Definition] NVARCHAR(255),
[IdealCustomer] NVARCHAR (255)
)
````
Inserting the data into the temporary table.

````sql
INSERT INTO IdealCustomerTable
SELECT 	[Patron Type Definition],[Total Checkouts],[Total Renewals],[Home Library Definition],
(CASE WHEN  [Total Renewals]<1 THEN 'No Renewals' ELSE 'Has Renewals' END) as IdealCustomer 
FROM LibraryUsage
WHERE [Total Checkouts] >0

````

Displaying the temporary table.
````sql
SELECT *
FROM IdealCustomerTable
````
![image](https://user-images.githubusercontent.com/114582898/198223388-9504736f-6f2c-4fb2-9216-48b44088b976.png)

Checking the number of patrons that has checked out at least one item. 
````sql
SELECT COUNT (*)
FROM IdealCustomerTable
````

The library has 349870 patrons that has checked out at least one item during this period.
Since the dataset contains 423448 registered patrons we can draw the conclusion that 73578 of these patrons has not checked out any item. 

Checking number of patrons that has renewed the loan for at least one item and the number of patrons that has not renewed the loan for any item.
````sql
SELECT COUNT(*)
FROM IdealCustomerTable
WHERE [IdealCustomer] = 'Has Renewals'

SELECT COUNT(*)
FROM IdealCustomerTable
WHERE [IdealCustomer] = 'No Renewals'
````
 246661 of the patrons has renewen at least one item and 103209 of the patrons has not renewed any item. 
 
 However, this does not really paint the whole picture of the ratio between loaned items and renewed items. 
 So we create a new column to check the percentage of renewed items for each patron. 
 
 ````sql
 SELECT *,
ROUND(([Total Renewals]/[Total Checkouts]),3)*100 AS PercentageRenewals
FROM IdealCustomerTable
 ````
 ![image](https://user-images.githubusercontent.com/114582898/198242016-01ac32ab-2615-4a11-a925-8b34cf7489e2.png)

 








