 --create data warehousing table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_warehouse.accounts (
    account_id integer,
    account TEXT,
    sector TEXT,
    year_established INT,
    revenue decimal(10, 2),
    employees int,
    office_location TEXT,
    subsidiary_of TEXT null,
    checksum bytea,
    end_date timestamp null
  );

--create staging table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.accounts_staging (
    account_id integer,
    account TEXT,
    sector TEXT,
    year_established INT,
    revenue decimal(10, 2),
    employees int,
    office_location TEXT,
    subsidiary_of TEXT,
    checksum bytea
  );

--create insert table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.accounts_insert (
    account_id integer,
    account TEXT,
    sector TEXT,
    year_established int,
    revenue decimal(10, 2),
    employees int,
    office_location TEXT,
    subsidiary_of TEXT,
    checksum bytea
  );

--create update table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.accounts_update (
    account_id integer,
    account TEXT,
    sector TEXT,
    year_established int,
    revenue decimal(10, 2),
    employees int,
    office_location TEXT,
    subsidiary_of TEXT,
    checksum bytea
  );

--trucate all the tables before ETL process begins
TRUNCATE TABLE
  crm_sales_pipeline_staging.accounts_staging;

TRUNCATE TABLE
  crm_sales_pipeline_staging.accounts_insert;

TRUNCATE TABLE
  crm_sales_pipeline_staging.accounts_update;

--insert the transformed data with correct datatype and the calculated checksum

INSERT INTO crm_sales_pipeline_staging.accounts_staging
    SELECT account_id::integer,
    account,
    sector,
    year_established::int,
    revenue::decimal(10,2),
    employees::int,
    office_location,
    subsidiary_of
    FROM
    crm_sales_pipeline_loading.accounts_loading;

--find all the new records that do not exist and add them to the insert table
INSERT INTO crm_sales_pipeline_staging.accounts_insert
SELECT s.*
FROM
    crm_sales_pipeline_staging.accounts_staging s
WHERE
    NOT EXISTS
        (
        SELECT w.* FROM crm_sales_pipeline_warehouse.accounts w
        WHERE s.account_id = w.account_id
        );

--find all the records that have been updated using the binary checksum
INSERT INTO crm_sales_pipeline_staging.accounts_update
SELECT
    s.*
FROM
    crm_sales_pipeline_staging.accounts_staging s
LEFT JOIN crm_sales_pipeline_warehouse.accounts w  on s.account_id = w.account_id
WHERE s.account_id = w.account_id AND s.checksum <> w.checksum AND w.end_date is null;
