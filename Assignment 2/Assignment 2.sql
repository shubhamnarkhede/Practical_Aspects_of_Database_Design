
-------------------------------------------------------------------------------------------------
-- Question 1

-- Creating Database
CREATE DATABASE ASSIGNMENT2
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
-- Creating World table to store country information
CREATE TABLE World (
    name VARCHAR PRIMARY KEY,
    continent VARCHAR,
    area INT,
    population INT,
    gdp BIGINT
);

-- Inserting data into World table
INSERT INTO World (name, continent, area, population, gdp) 
VALUES ('Afghanistan', 'Asia', 652230, 25500100, 20343000000);

INSERT INTO World (name, continent, area, population, gdp) 
VALUES ('Albania', 'Europe', 28748, 2831741, 12960000000);

INSERT INTO World (name, continent, area, population, gdp) 
VALUES ('Algeria', 'Africa', 2381741, 37100000, 188681000000);

INSERT INTO World (name, continent, area, population, gdp) 
VALUES ('Andorra', 'Europe', 468, 78115, 3712000000);

INSERT INTO World (name, continent, area, population, gdp) 
VALUES ('Angola', 'Africa', 1246700, 20609294, 100990000000);

SELECT * FROM World;


-- Query to retrieve the name, area, and population of 'big' countries
SELECT name, area, population
FROM World
WHERE area >= 3000000 OR population >= 25000000;


-------------------------------------------------------------------------------------------------------------------------------------------

-- Question 2

-- Creating Products table to store product information
CREATE TABLE Products (
    productid INT PRIMARY KEY,
    lowfats CHAR(1),
    recyclable CHAR(1)
);

-- Inserting data into Products table
INSERT INTO Products (productid, lowfats, recyclable) VALUES (0, 'Y', 'N');
INSERT INTO Products (productid, lowfats, recyclable) VALUES (1, 'Y', 'Y');
INSERT INTO Products (productid, lowfats, recyclable) VALUES (2, 'N', 'Y');
INSERT INTO Products (productid, lowfats, recyclable) VALUES (3, 'Y', 'Y');
INSERT INTO Products (productid, lowfats, recyclable) VALUES (4, 'N', 'N');

SELECT * FROM Products;

-- Query to retrieve product IDs that are both low-fat and recyclable
SELECT productid
FROM Products
WHERE lowfats = 'Y' AND recyclable = 'Y';
