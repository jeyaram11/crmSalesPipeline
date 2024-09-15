--create staging products table
CREATE TABLE IF NOT EXISTS crm_sales_pipeline_staging.products_staging (
product_id varchar(255) NOT NULL,
product varchar(255),
series varchar(255),
sales_price varchar(255)
);

--create insert and update table in the staging schema
CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.products_insert (
    product_id integer  NOT NULL,
    product character varying(30),
    series character varying(30),
    sales_price numeric NULL,
    checksum bytea NULL
  );

  CREATE TABLE IF NOT EXISTS
  crm_sales_pipeline_staging.products_update (
    product_id integer NOT NULL,
    product character varying(30),
    series character varying(30),
    sales_price numeric,
    checksum bytea
  );

TRUNCATE TABLE
  crm_sales_pipeline_staging.products_staging;

TRUNCATE TABLE
  crm_sales_pipeline_staging.products_insert;

TRUNCATE TABLE
  crm_sales_pipeline_staging.products_update;

--insert the transformed data with correct datatype and the calculated checksum
INSERT INTO
  crm_sales_pipeline_staging.products_staging
SELECT
  product_id::int,
  product::varchar(30),
  series::varchar(30),
  sales_price::numeric
FROM
  crm_sales_pipeline_loading.products_loading;

--find all the new records that do not exist and add them to the insert table
INSERT INTO
  crm_sales_pipeline_staging.products_insert
SELECT
  *
FROM
  crm_sales_pipeline_staging.products_staging s
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      crm_sales_pipeline_warehouse.products p
    WHERE
      s.product_id = p.product_id
  );

--find all the records that have been updated using the binary checksum
INSERT INTO
  crm_sales_pipeline_staging.products_update
SELECT
  s.*
FROM
  crm_sales_pipeline_staging.products_staging s
  LEFT JOIN crm_sales_pipeline_warehouse.products p ON p.product_id = s.product_id
WHERE
  s.product_id = p.product_id
  AND s.checksum <> p.checksum AND p.end_date IS NULL;