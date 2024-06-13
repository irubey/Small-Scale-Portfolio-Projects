SELECT *
FROM dataset_1
LIMIT 10;

SELECT DISTINCT passanger
FROM dataset_1;

SELECT *
FROM dataset_1
WHERE passanger = 'Alone'
AND weather = 'Sunny'
OR time = '2PM'
ORDER BY time DESC;

SELECT 
destination, 
passanger, 
time as 'The Time'
FROM dataset_1;

--Aggregation

SELECT destination, time,
AVG(temperature) as 'Average Temperature', 
COUNT(temperature),
COUNT(DISTINCT(temperature)) as 'Distinct Temperature'
FROM dataset_1 d 
WHERE time <> '10PM'
GROUP BY destination, time
ORDER BY time;


--Combining data

SELECT *
FROM dataset_1 d 
UNION ALL
SELECT *
FROM table_to_union;

SELECT DISTINCT destination
FROM dataset_1 d;

SELECT DISTINCT destination 
FROM
(
SELECT *
FROM dataset_1 d 
UNION
SELECT *
FROM table_to_union);

--Join data


SELECT *
FROM table_to_join ttj;

SELECT destination,d.time,ttj.part_of_day 
FROM dataset_1 d
LEFT JOIN table_to_join ttj 
ON d.time = ttj.time;

--filtering data

SELECT *
FROM dataset_1 d 
WHERE weather LIKE 'Sun%';

SELECT *
FROM dataset_1 d 
WHERE d.time LIKE '%P%';

SELECT DISTINCT temperature
FROM dataset_1 d 
WHERE temperature BETWEEN 26 AND 65


SELECT occupation
FROM dataset_1 d 
WHERE occupation IN ('Sales & Related', 'Management');


-- Partitions 

SELECT 
	destination,
	weather,
	AVG(temperature) OVER (PARTITION BY weather) AS 'avg_temp_by'
FROM dataset_1 d;



SELECT 
	destination,
	weather,
	ROW_NUMBER () OVER (PARTITION BY weather ORDER BY destination) AS 'row_num_by'
FROM dataset_1 d;


SELECT 
	destination,
	weather,
	RANK() OVER (PARTITION BY weather ORDER BY destination) AS 'row_rank'
FROM dataset_1 d;



SELECT 
	destination,
	weather,
	DENSE_RANK()OVER (PARTITION BY weather ORDER BY destination) AS 'dense_rank'
FROM dataset_1 d;



SELECT time, NTILE (50) OVER (ORDER BY time)
FROM dataset_1 d ;


SELECT destination, time,
LAG(row_count, 1, '99999') OVER (ORDER BY row_count) AS 'Lagged row count'
FROM dataset_1 d 



SELECT destination, time,
LEAD(row_count, 1, '99999') OVER (ORDER BY row_count) AS 'Led row count'
FROM dataset_1 d 
