/*
    LayoffLens: SQL Deep Dive into Workforce Trends
    File: clean_data.sql
    Purpose: 
      - Load and clean the raw layoffs dataset from the attached CSV file.
      - Remove duplicates, standardize text, convert date formats,
        and prepare numeric fields for analysis.
    Dataset: layoffs.csv (attached)
*/

/* -----------------------------
   Step 0: Create Raw Table
   ----------------------------- */
CREATE TABLE IF NOT EXISTS raw_layoffs (
    company                VARCHAR(255),
    location               VARCHAR(255),
    industry               VARCHAR(255),
    total_laid_off         INT,
    percentage_laid_off    VARCHAR(50),  -- may be stored as text (e.g., '100%') 
    date                   VARCHAR(50),
    stage                  VARCHAR(255),
    country                VARCHAR(255),
    funds_raised_millions  VARCHAR(50)
);

/* -----------------------------
   Step 1: Load CSV Data
   ----------------------------- */
/* 
   Update the file path below to match your environment.
   This command assumes that fields are comma-separated, enclosed by double quotes,
   and that the first line contains headers.
*/
LOAD DATA LOCAL INFILE 'layoffs.csv'
INTO TABLE raw_layoffs
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* -----------------------------
   Step 2: Create a Staging Table for Cleaning
   ----------------------------- */
DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging AS
SELECT * FROM raw_layoffs;

/* -----------------------------
   Step 3: Text Standardization
   ----------------------------- */
UPDATE layoffs_staging
SET company  = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage    = TRIM(stage),
    country  = TRIM(country);

/* -----------------------------
   Step 4: Standardize Specific Fields
   ----------------------------- */
/* Standardize Industry Names: e.g., multiple forms of "Crypto" become 'Crypto' */
UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

/* Standardize Country Names: e.g., variations of United States */
UPDATE layoffs_staging
SET country = 'United States'
WHERE country LIKE 'United States%';

/* Optionally, standardize stage names (e.g., remove extra spaces, fix case) */
UPDATE layoffs_staging
SET stage = UPPER(stage);

/* -----------------------------
   Step 5: Convert Date Field
   ----------------------------- */
/* Convert date stored as text into DATE format.
   Adjust the format string if your CSV uses a different date format.
*/
UPDATE layoffs_staging
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE;

/* -----------------------------
   Step 6: Clean Numeric Fields
   ----------------------------- */
/* Convert funds_raised_millions to a decimal type. 
   Remove non-numeric characters if necessary (here assumed clean numeric text) */
ALTER TABLE layoffs_staging
MODIFY COLUMN funds_raised_millions DECIMAL(10,2);

/* Clean percentage_laid_off: remove any '%' symbols and convert to DECIMAL */
UPDATE layoffs_staging
SET percentage_laid_off = REPLACE(percentage_laid_off, '%', '');

ALTER TABLE layoffs_staging
MODIFY COLUMN percentage_laid_off DECIMAL(5,2);

/* -----------------------------
   Step 7: Handle Missing Values
   ----------------------------- */
/* Set blank industry values to NULL */
UPDATE layoffs_staging
SET industry = NULL
WHERE TRIM(industry) = '';

/* Fill missing industry values by referencing another row from the same company */
UPDATE layoffs_staging t1
JOIN layoffs_staging t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

/* Optionally, you may want to clean or flag rows with missing critical fields */

/* -----------------------------
   Step 8: Remove Duplicates and Create Clean Table
   ----------------------------- */
/* Instead of deleting rows in place, we create a new table that keeps only the first occurrence per duplicate group */
DROP TABLE IF EXISTS clean_data;
CREATE TABLE clean_data AS
SELECT * FROM (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
             ORDER BY company
           ) AS rn
    FROM layoffs_staging
) AS sub
WHERE rn = 1;

/* Optionally drop the temporary column if it exists */
ALTER TABLE clean_data DROP COLUMN rn;

/* -----------------------------
   Cleanup Complete
   The table "clean_data" now holds the cleaned and standardized dataset.
   ----------------------------- */
