-- SHOW data_directory; C:/Program Files/PostgreSQL/16/data
-- bank_data

-- Creating Table bank_data
DROP TABLE IF EXISTS bank_data;

CREATE TABLE IF NOT EXISTS bank_data (
    id INT,
    date DATE,
    asset INT,
    liability INT,
    idx serial
);

-- 1. Create a primary key for the import table:
ALTER TABLE bank_data ADD PRIMARY KEY (idx);

-- 2. Import given bank data into PostgreSQL database.
COPY bank_data (id, date, asset, liability, idx) FROM 'C:/Program Files/PostgreSQL/16/data/bank_data.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM bank_data

-- 3. Find the highest asset observation for each bank and report the first 10 observations.
WITH ranked_assets AS (
    SELECT
        id, asset,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY asset DESC) AS rnk
    FROM
        bank_data
)
SELECT
    id, asset
FROM
    ranked_assets
WHERE
    rnk = 1
ORDER BY
    asset DESC
LIMIT 10;

-- 4. Show the query plan for question 1.3 using EXPLAIN tool.
EXPLAIN
WITH ranked_assets AS (
    SELECT
        id, asset,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY asset DESC) AS rnk
    FROM
        bank_data
)
SELECT
    id, asset
FROM
    ranked_assets
WHERE
    rnk = 1
ORDER BY
    asset DESC
LIMIT 10;

-- 5. Given the highest asset table from question 1.3, count how many observations are there for each quarter.
WITH ranked_assets AS (
    SELECT
        id, date, asset,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY asset DESC) AS rnk
    FROM
        bank_data
)
SELECT
    date_part('quarter', date) AS quarter,
    COUNT(*) AS observation_count
FROM
    ranked_assets
WHERE
    rnk = 1
GROUP BY
    quarter
ORDER BY
    quarter;


-- 6. Count observations with asset value higher than 100,000 and liability value smaller than 100,000.
SELECT COUNT(*)
FROM bank_data
WHERE asset > 100000 AND liability < 100000;

-- 7. Find the average liability of observations with odd 'idx' number.
SELECT AVG(liability) AS average_liability
FROM bank_data
WHERE idx % 2 <> 0;

-- 8. Find the average liability of observations with even 'idx' number and calculate the difference.
-- Average liability for even 'idx' numbers
SELECT AVG(liability) AS average_liability_even
FROM bank_data
WHERE idx % 2 = 0;

-- Calculate the difference between the averages
SELECT
    (SELECT AVG(liability) FROM bank_data WHERE idx % 2 = 0) -
    (SELECT AVG(liability) FROM bank_data WHERE idx % 2 <> 0) AS average_liability_difference;


-- 9. For each bank find all records with increased asset. Report the first 10 observations.
WITH increased_assets AS (
    SELECT
        id, date, asset,liability,
        LAG(asset) OVER (PARTITION BY id ORDER BY date) AS prev_asset
    FROM
        bank_data
)
SELECT
    id, date, asset,liability
FROM
    increased_assets
WHERE
    prev_asset IS NULL OR asset > prev_asset
ORDER BY
    id, date
LIMIT 10;
