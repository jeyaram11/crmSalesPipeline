--first insert the new script
INSERT INTO crm_sales_pipeline_warehouse.products
   SELECT
    i.product_id,
    i.product,
    i.series,
    i.sales_price,
    i.checksum
    FROM crm_sales_pipeline_staging.products_insert i;


--update the records that already exist but need to be updated
UPDATE crm_sales_pipeline_warehouse.products p
SET
  product_id = u.product_id,
  product = u.product,
  series = u.series,
  sales_price = u.sales_price,
  checksum = u.checksum
FROM
  crm_sales_pipeline_staging.products_update u
WHERE
  p.product_id = u.product_id;