# SQL Projects
My first SQL Projects 

This repository will contain my SQL projects i have created while learning SQL. 

## San Francisco Library Usage
- Created some simple queries to test some new SQL techniques i have learned
### Dataset 
- https://www.kaggle.com/datasets/datasf/sf-library-usage-data 


````sql
SELECT [Home Library Definition],[Home Library Code],
SUM([Total Checkouts]) AS Checkouts
FROM LibraryUsage
WHERE [Home Library Definition] <> 'Unknown'
GROUP BY [Home Library Definition],[Home Library Code]
ORDER BY [Checkouts] DESC
````
We get the following results 

![image](https://user-images.githubusercontent.com/114582898/198046350-9fe6e11e-3b8b-4836-abee-1668eb265663.png)

