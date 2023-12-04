
-- CREATE DATABASE "Assignment 3"
--     WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'English_United States.1252'
--     LC_CTYPE = 'English_United States.1252'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1
--     IS_TEMPLATE = False;

-- SHOW data_directory;

-- Create the 'banks_sec_2002' table

CREATE TABLE banks_sec_2002 (
    id INT ,
    date DATE,
    security INT
);

-- Import data from banks_sec_2002.csv
COPY banks_sec_2002 FROM 'C:/Program Files/PostgreSQL/16/data/banks_sec_2002.csv' WITH CSV HEADER;

select * from banks_sec_2002;

SELECT id, count(*)
  FROM banks_sec_2002
  GROUP BY id
  HAVING COUNT(*) > 1
  order by count asc

-- Create the 'banks_al_2002' table

CREATE TABLE banks_al_2002 (
    id INT,
    date DATE,
    asset INT,
    liability INT
);


-- Import data from banks_al_2002.csv
COPY banks_al_2002 FROM 'C:/Program Files/PostgreSQL/16/data/banks_al_2002.csv' WITH CSV HEADER;

select * from banks_al_2002;

-- 1. Querying Multiple Tables (50pt)
-- 1. Import data from banks sec 2002 and banks al 2002. 
-- Delete duplicate rows from banks sec 2002.

DELETE FROM banks_sec_2002
WHERE (id, date, security) IN (
  SELECT id, date, security
  FROM banks_sec_2002
  GROUP BY id, date, security
  HAVING COUNT(*) > 1
);


-- 2. Select the proper join manner to join banks_sec_2002 and banks_al_2002. Report the first 10 observations.

SELECT *
FROM banks_sec_2002
LEFT JOIN banks_al_2002 ON banks_sec_2002.id = banks_al_2002.id and banks_sec_2002.date = banks_al_2002.date
order by banks_sec_2002.id LIMIT 10;

-- 3. Create a new table banks_total. Insert the values from the previous joint table into this new one. And set a primary key for the table.

-- Creating new table with join

CREATE TABLE banks_total AS
SELECT
  bs.id,
  bs.date,
  bs.security,
  ba.asset,
  ba.liability
FROM banks_sec_2002 bs
LEFT JOIN banks_al_2002 ba ON bs.id = ba.id and ba.date = bs.date ;

Select * from banks_total order by id;

-- Make Primary Key 
ALTER TABLE banks_total ADD PRIMARY KEY (id,date);


-- 4. For each quarter of the year 2002, count how many banks have security over 20% of its assets.

SELECT 
  EXTRACT(QUARTER FROM date) AS quarter,
  COUNT(*) AS num_banks
FROM banks_total
WHERE security > 0.2
GROUP BY quarter;

-- 5. How many banks have liability over 90% of assets in the first quarter of 2002 but go below 90% in the second quarter of 2002.

SELECT COUNT(*) AS num_banks
	FROM banks_total
	WHERE 
  	EXTRACT(QUARTER FROM date) = 1 AND (liability > asset*0.5)
  	AND id IN (
    	SELECT id
		FROM banks_total
		WHERE EXTRACT(QUARTER FROM date) = 2 AND
		(liability < asset*0.5)
	);


-- 6. Export the joint table (banks_total) to a CSV file.sql
COPY banks_total TO 'C:/Program Files/PostgreSQL/16/data/banks_total.csv' WITH CSV HEADER;


-- 2. PostgreSQL API in R (50pt)
-- 1. Make a connection to your local PostgreSQL database using API.


