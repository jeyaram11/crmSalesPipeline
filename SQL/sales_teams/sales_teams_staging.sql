 --create staging sales_teams table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.sales_teams_staging (
    agent_id integer NOT NULL,
    sales_agent TEXT,
    manager TEXT,
    regional_office TEXT,
    checksum bytea
  );

--create insert sales_teams table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.sales_teams_insert (
    agent_id integer NOT NULL,
    sales_agent TEXT,
    manager TEXT,
    regional_office TEXT,
    checksum bytea
  );

--create update sales_teams table
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.sales_teams_update (
    agent_id integer NOT NULL,
    sales_agent TEXT,
    manager TEXT,
    regional_office TEXT,
    checksum bytea
  );

--create warehousing table to store final data
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_warehouse.sales_teams (
    agent_id integer NOT NULL,
    sales_agent TEXT,
    manager TEXT,
    regional_office TEXT,
    checksum bytea,
    end_date timestamp null
  );

--truncate the loading tables
TRUNCATE TABLE
  crm_sales_pipeline_staging.sales_teams_update;

TRUNCATE TABLE
  crm_sales_pipeline_staging.sales_teams_insert;

TRUNCATE TABLE
  crm_sales_pipeline_staging.sales_teams_staging;

--insert the transformed data with correct datatype and the calculated checksum
INSERT INTO
  crm_sales_pipeline_staging.sales_teams_staging
SELECT
  agent_id::int,
  sales_agent::TEXT,
  manager::TEXT,
  regional_office::TEXT
FROM
  crm_sales_pipeline_loading.sales_teams_loading;

--find all the new records that do not exist and add them to the insert table
INSERT INTO
  crm_sales_pipeline_staging.sales_teams_insert
SELECT
  *
FROM
  crm_sales_pipeline_staging.sales_teams_staging s
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      crm_sales_pipeline_warehouse.sales_teams w
    WHERE
      w.agent_id = s.agent_id
  );

--find all the records that have been updated using the binary checksum
INSERT INTO
  crm_sales_pipeline_staging.sales_teams_update
SELECT
  s.*
FROM
  crm_sales_pipeline_staging.sales_teams_staging s
  LEFT JOIN crm_sales_pipeline_warehouse.sales_teams w ON s.agent_id = w.agent_id
WHERE
  s.agent_id = w.agent_id
  AND s.checksum <> w.checksum
  AND w.end_date IS NULL