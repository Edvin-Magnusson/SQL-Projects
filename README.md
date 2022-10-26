# SQL Projects
My first SQL Projects 

This repository will contain my SQL projects i have created while learning SQL. 

## San Francisco Library Usage
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







````sql

````






