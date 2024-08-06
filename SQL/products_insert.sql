--first insert the new script
INSERT INTO crm_sales_pipeline_warehouse.products
   SELECT
    i.product_id,
    i.product,
    i.series,
    i.sales_price,
    i.checksum,
    null
    FROM crm_sales_pipeline_staging.products_insert i;


--update the records that already exist but need to be updated
UPDATE crm_sales_pipeline_warehouse.products p
SET
  p.end_date = current_date
FROM
  crm_sales_pipeline_staging.products_update u
WHERE
  p.product_id = u.product_id AND p.end_date IS NOT NULL;


--insert the new record from the update table
INSERT INTO crm_sales_pipeline_warehouse.products
   SELECT
    i.product_id,
    i.product,
    i.series,
    i.sales_price,
    i.checksum,
    null
    FROM crm_sales_pipeline_staging.products_update i;